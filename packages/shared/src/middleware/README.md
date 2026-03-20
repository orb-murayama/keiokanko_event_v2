# 認証ミドルウェア

## 概要

このディレクトリには、API のセッション認証とロール権限制御を行うミドルウェアが含まれています。

## ミドルウェア一覧

### 1. `requireAuth`

セッション認証を行うミドルウェア。Cookie から `admin_session_token` を取得し、DB で検証します。

**使用例:**
```typescript
app.get('/api/bookings', requireAuth, async (c) => {
  const account = c.get('account')
  // account.id, account.role などが利用可能
})
```

**検証内容:**
- Cookie に `admin_session_token` が存在するか
- トークンが `otp_tokens` テーブルに存在するか
- トークンの有効期限（24時間）が切れていないか
- アカウントが有効（`enable_flg = 1`）か

**失敗時のレスポンス:**
- 401 Unauthorized: トークンがない、または無効

### 2. `requireRole`

ロール権限をチェックするミドルウェア。`requireAuth` の後に使用します。

**使用例:**
```typescript
// 会員管理: system_admin と admin のみアクセス可能
app.get('/api/members', requireAuth, requireRole(['system_admin', 'admin']), async (c) => {
  // ...
})

// 全ロール共通のエンドポイント
app.get('/api/events', requireAuth, requireRole(['system_admin', 'admin', 'branch']), async (c) => {
  // ...
})
```

**失敗時のレスポンス:**
- 403 Forbidden: ロール権限がない

### 3. `requireEventAccess`

イベントへのアクセス権限をチェックするミドルウェア。

- `system_admin` と `admin`: 全イベントにアクセス可能
- `branch`: `event_staff` テーブルに登録されている担当イベントのみアクセス可能

**使用例:**
```typescript
app.get('/api/events/:event_id', requireAuth, requireEventAccess, async (c) => {
  const eventId = c.req.param('event_id')
  // branch の場合、担当イベントのみ取得可能
})
```

**event_id の取得:**
- パスパラメータ: `c.req.param('event_id')`
- クエリパラメータ: `c.req.query('event_id')`

**失敗時のレスポンス:**
- 400 Bad Request: event_id が指定されていない
- 403 Forbidden: イベントへのアクセス権限がない

## ヘルパー関数

### `getAssignedEventIds(DB, accountId)`

支店管理者の担当イベントIDリストを取得します。

**使用例:**
```typescript
const account = c.get('account')
if (account.role === 'branch') {
  const eventIds = await getAssignedEventIds(c.env.DB, account.id)
  // eventIds: [1, 3, 5]
}
```

### `getBookingEventId(DB, bookingId)`

予約のイベントIDを取得します。

**使用例:**
```typescript
const bookingId = c.req.param('id')
const eventId = await getBookingEventId(c.env.DB, bookingId)
if (eventId) {
  // イベントIDが取得できた
}
```

## ロール定義

| ロール | 値 | 説明 |
|--------|-----|------|
| システム管理者 | `system_admin` | 全機能にアクセス可能 |
| 本社管理者 | `admin` | 全機能にアクセス可能 |
| 支店管理者 | `branch` | 担当イベントのみアクセス可能、一部機能制限あり |

## 権限マトリックス

| 機能 | system_admin | admin | branch |
|------|-------------|-------|--------|
| 予約管理 | 全て | 全て | 担当イベントのみ |
| イベント管理（閲覧） | 全て | 全て | 全て |
| イベント管理（公開設定） | 可能 | 可能 | 不可 |
| 商品管理 | 全て | 全て | 全て |
| オプション管理 | 全て | 全て | 全て |
| 会員管理 | 全て | 全て | アクセス不可 |
| 一括送信 | 全て | 全て | 担当イベントのみ |

## エラーレスポンス形式

### 401 Unauthorized
```json
{
  "error": "認証が必要です。ログインしてください。"
}
```

### 403 Forbidden (ロール権限)
```json
{
  "error": "この操作を実行する権限がありません",
  "required_roles": ["system_admin", "admin"],
  "current_role": "branch"
}
```

### 403 Forbidden (イベントアクセス)
```json
{
  "error": "このイベントへのアクセス権限がありません",
  "event_id": "123"
}
```

## 実装例

### パターン 1: 全ロール共通のエンドポイント
```typescript
app.get('/api/events', requireAuth, async (c) => {
  // 全ロールが全イベントを閲覧可能
  const events = await c.env.DB.prepare('SELECT * FROM events').all()
  return c.json(events.results)
})
```

### パターン 2: 特定ロールのみアクセス可能
```typescript
app.get('/api/members', requireAuth, requireRole(['system_admin', 'admin']), async (c) => {
  // system_admin と admin のみアクセス可能
  const members = await c.env.DB.prepare('SELECT * FROM members').all()
  return c.json(members.results)
})
```

### パターン 3: 担当イベントのみアクセス可能
```typescript
app.get('/api/bookings', requireAuth, async (c) => {
  const account = c.get('account')
  const { DB } = c.env
  
  let bookings
  if (['system_admin', 'admin'].includes(account.role)) {
    // 全予約を取得
    bookings = await DB.prepare('SELECT * FROM bookings').all()
  } else {
    // 担当イベントの予約のみ取得
    const eventIds = await getAssignedEventIds(DB, account.id)
    if (eventIds.length === 0) {
      return c.json({ results: [] })
    }
    const placeholders = eventIds.map(() => '?').join(',')
    bookings = await DB.prepare(
      `SELECT * FROM bookings WHERE event_id IN (${placeholders})`
    ).bind(...eventIds).all()
  }
  
  return c.json(bookings.results)
})
```

### パターン 4: 部分的な権限制限（イベント更新）
```typescript
app.patch('/api/events/:id', requireAuth, async (c) => {
  const account = c.get('account')
  const eventId = c.req.param('id')
  const updates = await c.req.json()
  
  // branch は enable_flg（公開設定）の変更不可
  if (account.role === 'branch' && 'enable_flg' in updates) {
    return c.json({ error: '公開設定の変更権限がありません' }, 403)
  }
  
  // 更新処理
  const updateFields = Object.keys(updates).map(key => `${key} = ?`).join(', ')
  await c.env.DB.prepare(
    `UPDATE events SET ${updateFields}, modified_at = datetime('now') WHERE id = ?`
  ).bind(...Object.values(updates), eventId).run()
  
  return c.json({ success: true })
})
```
