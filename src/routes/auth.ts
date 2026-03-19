// src/routes/auth.ts - OTP認証API
import { Hono } from 'hono'
import { getCookie, setCookie } from 'hono/cookie'

type Bindings = {
  DB: D1Database
}

const auth = new Hono<{ Bindings: Bindings }>()

// OTP生成（6桁の数字）
function generateOTP(): string {
  return Math.floor(100000 + Math.random() * 900000).toString()
}

// メールアドレス検証
function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

// セッショントークン生成（32文字のランダム文字列）
function generateSessionToken(): string {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  let token = ''
  for (let i = 0; i < 32; i++) {
    token += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  return token
}

// POST /api/auth/send-otp - OTP送信
auth.post('/send-otp', async (c) => {
  const { DB } = c.env
  const { email } = await c.req.json()
  
  // 1. メールアドレス検証
  if (!email || !validateEmail(email)) {
    return c.json({ error: 'メールアドレスが無効です' }, 400)
  }
  
  // 2. レート制限チェック（同じメールアドレスに30秒間に1回まで - 開発環境用に緩和）
  // まず、期限切れのOTPトークンを削除（クリーンアップ）
  await DB.prepare(`
    DELETE FROM otp_tokens 
    WHERE email = ? AND (expires_at < datetime('now') OR used_at IS NOT NULL)
  `).bind(email).run()
  
  const recentOtp = await DB.prepare(`
    SELECT * FROM otp_tokens
    WHERE email = ? AND created_at > datetime('now', '-30 seconds')
    ORDER BY created_at DESC LIMIT 1
  `).bind(email).first()
  
  if (recentOtp) {
    return c.json({ 
      error: '送信間隔が短すぎます。30秒後に再試行してください',
      retry_after: 30
    }, 429)
  }
  
  // 3. 6桁のOTPコード生成
  const otpCode = generateOTP()
  const expiresAt = new Date(Date.now() + 10 * 60 * 1000) // 10分後
  
  // 4. OTP保存
  const ip = c.req.header('cf-connecting-ip') || 'unknown'
  const userAgent = c.req.header('user-agent') || 'unknown'
  
  await DB.prepare(`
    INSERT INTO otp_tokens (email, otp_code, expires_at, ip_address, user_agent)
    VALUES (?, ?, ?, ?, ?)
  `).bind(
    email,
    otpCode,
    expiresAt.toISOString().replace('T', ' ').substring(0, 19),
    ip,
    userAgent
  ).run()
  
  // 5. 開発用：OTPコードを返す（本番では削除）
  console.log(`[OTP] Generated for ${email}: ${otpCode}`)
  
  return c.json({
    success: true,
    message: 'ワンタイムパスワードを送信しました',
    expires_in: 600,  // 秒
    expires_at: expiresAt.toISOString(),  // ISO形式で返す
    // 開発用：画面に表示するためにOTPを返す
    dev_otp: otpCode,  // フロントエンドが期待するキー名
    debug_mode: true
  })
})

// POST /api/auth/verify-otp - OTP検証・ログイン
auth.post('/verify-otp', async (c) => {
  const { DB } = c.env
  const body = await c.req.json()
  const { email, code, otp_code } = body
  
  // codeとotp_codeの両方に対応（フロントエンドの互換性のため）
  const otpCodeValue = code || otp_code
  
  // 1. 入力検証
  if (!email || !otpCodeValue) {
    return c.json({ error: '必須項目が入力されていません' }, 400)
  }
  
  // 2. OTP取得（有効期限内・未使用）
  const otpRecord = await DB.prepare(`
    SELECT * FROM otp_tokens
    WHERE email = ? AND otp_code = ? AND used_at IS NULL AND expires_at > datetime('now')
    ORDER BY created_at DESC LIMIT 1
  `).bind(email, otpCodeValue).first()
  
  if (!otpRecord) {
    // 試行回数をインクリメント
    await DB.prepare(`
      UPDATE otp_tokens SET attempts = attempts + 1
      WHERE email = ? AND expires_at > datetime('now') AND used_at IS NULL
    `).bind(email).run()
    
    return c.json({ 
      error: 'ワンタイムパスワードが無効です',
      remaining_attempts: 5 - ((otpRecord?.attempts || 0) + 1)
    }, 401)
  }
  
  // 3. 試行回数チェック（5回まで）
  if (otpRecord.attempts >= 5) {
    return c.json({ 
      error: '試行回数が上限に達しました。新しいワンタイムパスワードを発行してください' 
    }, 403)
  }
  
  // 4. セッショントークン生成
  const sessionToken = generateSessionToken()
  
  // 5. OTPを使用済みにマーク & セッショントークン保存
  await DB.prepare(`
    UPDATE otp_tokens 
    SET used_at = datetime('now'), session_token = ?
    WHERE id = ?
  `).bind(sessionToken, otpRecord.id).run()
  
  // 6. 既存会員かチェック
  const member = await DB.prepare(`
    SELECT * FROM members WHERE email = ? AND enable_flg = 1
  `).bind(email).first()
  
  // 7. ログイン日時更新（既存会員の場合）
  if (member) {
    await DB.prepare(`
      UPDATE members SET last_login_at = datetime('now') WHERE id = ?
    `).bind(member.id).run()
  }
  
  // 8. セッションCookie設定
  setCookie(c, 'session_token', sessionToken, {
    httpOnly: true,
    secure: true,
    sameSite: 'Strict',
    maxAge: 86400,  // 24時間
    path: '/'
  })
  
  return c.json({
    success: true,
    // session_token を削除（httpOnly Cookieで送信済み）
    is_existing_member: !!member,
    member: member ? {
      id: member.id,
      email: member.email,
      family_name: member.family_name,
      first_name: member.first_name,
      family_kana: member.family_kana,
      first_kana: member.first_kana,
      tel: member.tel,
      mobile: member.mobile,
      zip: member.zip,
      addr: member.addr
    } : null
  })
})

// GET /api/auth/session - セッション情報取得
auth.get('/session', async (c) => {
  const { DB } = c.env
  const sessionToken = getCookie(c, 'session_token')
  
  if (!sessionToken) {
    return c.json({ authenticated: false }, 401)
  }
  
  // セッショントークン検証
  const session = await DB.prepare(`
    SELECT ot.*, 
           m.id as member_id, 
           m.email, 
           m.family_name, 
           m.first_name,
           m.family_kana,
           m.first_kana,
           m.tel,
           m.mobile,
           m.zip,
           m.addr
    FROM otp_tokens ot
    LEFT JOIN members m ON ot.email = m.email AND m.enable_flg = 1
    WHERE ot.session_token = ? AND ot.used_at IS NOT NULL
  `).bind(sessionToken).first()
  
  if (!session) {
    return c.json({ authenticated: false }, 401)
  }
  
  return c.json({
    authenticated: true,
    email: session.email,
    is_existing_member: !!session.member_id,
    member: session.member_id ? {
      id: session.member_id,
      email: session.email,
      family_name: session.family_name,
      first_name: session.first_name,
      family_kana: session.family_kana,
      first_kana: session.first_kana,
      tel: session.tel,
      mobile: session.mobile,
      zip: session.zip,
      addr: session.addr
    } : null
  })
})

// POST /api/auth/logout - ログアウト
auth.post('/logout', async (c) => {
  const { DB } = c.env
  const sessionToken = getCookie(c, 'session_token')
  
  if (sessionToken) {
    // セッショントークンを無効化（削除）
    await DB.prepare(`
      UPDATE otp_tokens SET session_token = NULL WHERE session_token = ?
    `).bind(sessionToken).run()
  }
  
  // Cookie削除
  setCookie(c, 'session_token', '', {
    httpOnly: true,
    secure: true,
    sameSite: 'Strict',
    maxAge: 0,
    path: '/'
  })
  
  return c.json({ success: true, message: 'ログアウトしました' })
})

// GET /api/auth/product-form-settings/:product_id - 商品のフォーム設定取得
auth.get('/product-form-settings/:product_id', async (c) => {
  const { DB } = c.env
  const productId = c.req.param('product_id')
  
  if (!productId) {
    return c.json({ error: '商品IDが必要です' }, 400)
  }
  
  // 商品のフォーム設定を取得
  const product = await DB.prepare(`
    SELECT id, name, form_field_settings
    FROM products
    WHERE id = ? AND enable_flg = 1
  `).bind(productId).first()
  
  if (!product) {
    return c.json({ error: '商品が見つかりません' }, 404)
  }
  
  // form_field_settingsをパース
  let formSettings = {}
  if (product.form_field_settings) {
    try {
      formSettings = JSON.parse(product.form_field_settings)
    } catch (e) {
      console.error('Failed to parse form_field_settings:', e)
    }
  }
  
  // カスタムフォームフィールドを取得
  const customFields = await DB.prepare(`
    SELECT id, field_type, field_name, field_label, field_options, 
           is_required, description, display_order, placeholder,
           parent_field_id, parent_condition, indent_level, category
    FROM product_form_fields
    WHERE product_id = ?
    ORDER BY display_order, id
  `).bind(productId).all()
  
  // field_optionsをパース
  const parsedFields = (customFields.results || []).map(field => {
    let options = null
    if (field.field_options && field.field_options !== 'null') {
      try {
        options = JSON.parse(field.field_options)
      } catch (e) {
        console.error('Failed to parse field_options:', e)
      }
    }
    return {
      ...field,
      field_options: options
    }
  })
  
  return c.json({
    product_id: product.id,
    product_name: product.name,
    form_settings: formSettings,
    custom_fields: parsedFields
  })
})

export default auth
