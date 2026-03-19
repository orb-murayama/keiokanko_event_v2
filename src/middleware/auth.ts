import { Context, Next } from 'hono'
import { getCookie } from 'hono/cookie'
import type { Bindings, Account } from '../types'

// コンテキストに account を追加する型
export type AuthContext = {
  Bindings: Bindings
  Variables: {
    account: Account
  }
}

/**
 * セッション認証ミドルウェア
 * Cookie から session_token を取得し、DB で検証
 * 有効なセッションの場合、c.set('account', account) でアカウント情報を保存
 */
export const requireAuth = async (c: Context<AuthContext>, next: Next) => {
  const { DB } = c.env

  // Cookie から session_token を取得
  const sessionToken = getCookie(c, 'admin_session_token')

  console.log('🔐 requireAuth開始:', {
    hasToken: !!sessionToken,
    tokenLength: sessionToken?.length,
    url: c.req.url
  })

  if (!sessionToken) {
    console.error('❌ セッショントークンが見つかりません')
    return c.json({ error: '認証が必要です。ログインしてください。' }, 401)
  }

  try {
    // セッショントークンを検証（24時間有効）
    const tokenRow = await DB.prepare(`
      SELECT 
        ot.email,
        ot.used_at,
        a.id,
        a.login_id,
        a.person_name,
        a.email as account_email,
        a.role,
        a.client_id,
        a.enable_flg,
        a.primary_branch_code,
        a.accessible_branches
      FROM otp_tokens ot
      INNER JOIN accounts a ON ot.email = a.email
      WHERE ot.session_token = ?
        AND ot.used_at IS NOT NULL
        AND datetime(ot.used_at, '+24 hours') > datetime('now')
        AND a.enable_flg = 1
    `).bind(sessionToken).first()

    console.log('🔍 トークン検証結果:', {
      found: !!tokenRow,
      email: tokenRow?.email,
      role: tokenRow?.role
    })

    if (!tokenRow) {
      console.error('❌ セッショントークンが無効または期限切れ')
      return c.json({ error: 'セッションが無効または期限切れです。再度ログインしてください。' }, 401)
    }

    // アカウント情報をコンテキストに保存
    const account: Account = {
      id: tokenRow.id as number,
      login_id: tokenRow.login_id as string,
      person_name: tokenRow.person_name as string,
      email: tokenRow.account_email as string,
      role: tokenRow.role as 'system_admin' | 'admin' | 'branch',
      client_id: tokenRow.client_id as number,
      enable_flg: tokenRow.enable_flg as number,
      primary_branch_code: tokenRow.primary_branch_code as string | undefined,
      accessible_branches: tokenRow.accessible_branches as string | undefined
    }

    console.log('✅ requireAuth: account設定完了', { 
      id: account.id, 
      role: account.role,
      email: account.email 
    })
    c.set('account', account)
    await next()
  } catch (error) {
    console.error('Session verification error:', error)
    return c.json({ error: 'セッション検証中にエラーが発生しました' }, 500)
  }
}

/**
 * ロール権限チェックミドルウェア
 * @param allowedRoles - 許可されたロールの配列
 * @returns ミドルウェア関数
 * 
 * @example
 * app.get('/api/members', requireAuth, requireRole(['system_admin', 'admin']), ...)
 */
export const requireRole = (allowedRoles: Array<'system_admin' | 'admin' | 'branch'>) => {
  return async (c: Context<AuthContext>, next: Next) => {
    const account = c.get('account')

    if (!account) {
      return c.json({ error: '認証が必要です' }, 401)
    }

    if (!allowedRoles.includes(account.role)) {
      return c.json({ 
        error: 'この操作を実行する権限がありません',
        required_roles: allowedRoles,
        current_role: account.role
      }, 403)
    }

    await next()
  }
}

/**
 * イベントアクセス権限チェックミドルウェア
 * system_admin と admin は全イベントにアクセス可能
 * branch は event_staff に登録されている担当イベントのみアクセス可能
 * 
 * @example
 * app.get('/api/bookings/:id', requireAuth, requireEventAccess, ...)
 */
export const requireEventAccess = async (c: Context<AuthContext>, next: Next) => {
  const { DB } = c.env
  const account = c.get('account')

  if (!account) {
    return c.json({ error: '認証が必要です' }, 401)
  }

  // system_admin と admin は全イベントにアクセス可能
  if (['system_admin', 'admin'].includes(account.role)) {
    await next()
    return
  }

  // branch の場合、event_id を取得してチェック
  const eventId = c.req.param('event_id') || c.req.query('event_id')

  if (!eventId) {
    return c.json({ error: 'イベントIDが指定されていません' }, 400)
  }

  try {
    // event_staff テーブルで担当イベントかチェック
    const assigned = await DB.prepare(`
      SELECT 1 FROM event_staff
      WHERE event_id = ? AND account_id = ?
    `).bind(eventId, account.id).first()

    if (!assigned) {
      return c.json({ 
        error: 'このイベントへのアクセス権限がありません',
        event_id: eventId
      }, 403)
    }

    await next()
  } catch (error) {
    console.error('Event access check error:', error)
    return c.json({ error: 'アクセス権限の確認中にエラーが発生しました' }, 500)
  }
}

/**
 * 担当イベントIDリストを取得するヘルパー関数
 * @param DB - D1 Database
 * @param accountId - アカウントID
 * @returns イベントIDの配列
 */
export const getAssignedEventIds = async (DB: any, accountId: number): Promise<number[]> => {
  try {
    const result = await DB.prepare(`
      SELECT event_id FROM event_staff WHERE account_id = ?
    `).bind(accountId).all()

    return result.results.map((row: any) => row.event_id)
  } catch (error) {
    console.error('Get assigned events error:', error)
    return []
  }
}

/**
 * 予約のイベントIDを取得するヘルパー関数
 * @param DB - D1 Database
 * @param bookingId - 予約ID
 * @returns イベントID
 */
export const getBookingEventId = async (DB: any, bookingId: number): Promise<number | null> => {
  try {
    const result = await DB.prepare(`
      SELECT event_id FROM bookings WHERE id = ?
    `).bind(bookingId).first()

    return result?.event_id || null
  } catch (error) {
    console.error('Get booking event ID error:', error)
    return null
  }
}
