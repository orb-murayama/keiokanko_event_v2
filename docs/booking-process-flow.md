# 予約処理フロー（クレジットカード決済）

## 概要

現在のシステムは、**GMO Payment Gateway（GMOペイメントゲートウェイ）** を使用したクレジットカード決済に対応しています。

---

## 予約処理の全体フロー

```
┌─────────────────────────────────────────────────────────────┐
│                    予約処理フロー                            │
└─────────────────────────────────────────────────────────────┘

1. ユーザーが商品を選択
   ↓
2. 参加者情報入力
   ↓
3. 決済方法選択（クレジットカード）
   ↓
4. GMO決済画面へリダイレクト
   ↓
5. カード情報入力・仮売上実行（GMO AUTH）
   ↓
6. 決済完了後、システムに戻る
   ↓
7. 予約作成処理（API呼び出し）
   ① 会員登録/確認
   ② 予約番号生成（BK20260312-001）
   ③ 予約グループ作成
   ④ 決済情報保存（payment_status: pending）
   ⑤ カード情報保存（下4桁のみ）
   ⑥ 予約明細作成
   ⑦ 在庫減算（stock_typeで判定）
   ⑧ 売上確定（GMO CAPTURE）→ payment_status: completed
   ↓
8. 予約完了画面表示
```

---

## 詳細フロー

### 【Phase 1】商品選択・参加者情報入力

#### 1.1 商品詳細画面（`product-detail.html`）
```javascript
// ユーザーが商品を選択
selectedItems = [
  {
    type: 'product',           // 商品タイプ
    id: 8,                     // 商品ID
    name: '展望デッキ入場券',
    stock_id: 16,              // 在庫ID
    stock_type: 'shared',      // 在庫タイプ（個別/共有）
    category: 'A-大人',        // 価格帯
    quantity: 2,               // 数量
    unit_price: 8000,          // 単価
    subtotal: 16000            // 小計
  }
]

// LocalStorageに保存
localStorage.setItem('bookingDraft', JSON.stringify({
  event_id: 4,
  event_name: '東京スカイツリー®展望台入場券',
  participation_date: '2026-03-26',
  items: selectedItems,
  total_amount: 16000
}))

// 次の画面へ遷移
window.location.href = '/auth-email.html'
```

#### 1.2 メール認証画面（`auth-email.html`）
```javascript
// メールアドレスでOTP（ワンタイムパスワード）送信
POST /api/auth/request-otp
{
  email: 'user@example.com',
  event_id: 4
}

// OTP入力・認証
POST /api/auth/verify-otp
{
  email: 'user@example.com',
  otp: '123456'
}

// 認証成功後、参加者情報画面へ
window.location.href = '/participant-info.html'
```

#### 1.3 参加者情報入力（`participant-info.html`）
```javascript
// 予約者情報
booker = {
  email: 'user@example.com',
  family_name: '田中',
  first_name: '太郎',
  family_kana: 'タナカ',
  first_kana: 'タロウ',
  tel: '03-1234-5678',
  mobile: '090-1234-5678',
  zip: '100-0001',
  addr: '東京都千代田区...'
}

// 参加者情報（数量分）
participants = [
  {
    item_type: 'product',
    item_id: 8,
    stock_id: 16,
    category: 'A-大人',
    family_name: '田中',
    first_name: '太郎',
    // ...その他の参加者情報
  },
  {
    item_type: 'product',
    item_id: 8,
    stock_id: 16,
    category: 'A-大人',
    family_name: '田中',
    first_name: '花子',
    // ...
  }
]

// 決済方法選択画面へ
window.location.href = '/payment-method.html'
```

---

### 【Phase 2】決済処理（GMO Payment Gateway）

#### 2.1 決済方法選択（`payment-method.html`）

```javascript
// クレジットカード選択時
payment_method = 'credit_card'

// GMO決済リクエスト作成
POST /api/gmo/create-order  // ※このAPIは実装されていない可能性
{
  amount: 16000,
  order_id: 'ORD20260312-001',
  return_url: 'https://webapp-geh.pages.dev/booking-complete',
  cancel_url: 'https://webapp-geh.pages.dev/payment-method'
}

// GMO決済画面へリダイレクト
window.location.href = gmoPaymentUrl
```

#### 2.2 GMO決済画面（外部サイト）

```
┌──────────────────────────────────────┐
│      GMO Payment Gateway             │
│                                      │
│  カード番号: [________________]      │
│  有効期限:   [__/__]                │
│  セキュリティコード: [___]          │
│  カード名義: [________________]      │
│                                      │
│  [ 決済する ]                        │
└──────────────────────────────────────┘

決済処理:
• 3Dセキュア認証（必要に応じて）
• カード会社への与信確認
• 仮売上（AUTH）実行 → カード枠確保（売上はまだ確定しない）
```

#### 2.3 決済完了後、システムに戻る

```javascript
// GMOから戻ってくるURL（例）
https://webapp-geh.pages.dev/booking-complete?
  AccessID=xxxxx&
  AccessPass=xxxxx&
  OrderID=ORD20260312-001&
  Status=AUTH&              // 仮売上
  Amount=16000

// URLパラメータから決済情報を取得
gmo_details = {
  credit: {
    AccessID: 'xxxxx...',      // GMO取引ID（売上確定・キャンセル時に必要）
    AccessPass: 'xxxxx...',    // GMOアクセスパス（売上確定・キャンセル時に必要）
    OrderID: 'ORD20260312-001',
    Status: 'AUTH',            // 仮売上ステータス
    Amount: '16000'
  }
}
```

---

### 【Phase 3】予約作成処理（バックエンド）

#### 3.1 API呼び出し（POST /api/v2/bookings/create-from-payment）

```javascript
// フロントエンドから送信
POST /api/v2/bookings/create-from-payment
{
  event_id: 4,
  event_name: '東京スカイツリー®展望台入場券',
  participation_date: '2026-03-26',
  booker: { ... },              // 予約者情報
  participants: [ ... ],        // 参加者情報
  items: [ ... ],               // 商品情報（stock_id, stock_type含む）
  total_amount: 16000,
  payment_method: 'credit_card',
  is_new_member: true,          // 新規会員かどうか
  gmo_order_id: 'ORD20260312-001',
  gmo_details: {                // GMO決済情報
    credit: {
      AccessID: 'xxxxx...',
      AccessPass: 'xxxxx...',
      OrderID: 'ORD20260312-001',
      Status: 'CAPTURE'
    }
  },
  card_info: {                  // カード情報（下4桁のみ保存）
    last4: '1234',
    exp_month: '12',
    exp_year: '2028',
    holder_name: 'TARO TANAKA'
  }
}
```

#### 3.2 バックエンド処理（src/index.tsx）

```typescript
app.post('/api/v2/bookings/create-from-payment', async (c) => {
  const { DB } = c.env
  
  // ========== 1. 会員情報の処理 ==========
  let member_id = null
  if (is_new_member) {
    // 新規会員登録
    const memberResult = await DB.prepare(`
      INSERT INTO members (
        email, family_name, first_name, family_kana, first_kana,
        tel, mobile, zip, addr, enable_flg, email_verified
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1)
    `).bind(
      booker.email,
      booker.family_name,
      booker.first_name,
      // ...
    ).run()
    
    member_id = memberResult.meta.last_row_id
    console.log('✅ 新規会員登録完了:', member_id)
  } else {
    // 既存会員検索
    const member = await DB.prepare(`
      SELECT id FROM members WHERE email = ?
    `).bind(booker.email).first()
    
    member_id = member?.id
  }
  
  // ========== 2. 予約番号を生成 ==========
  // BK + YYYYMMDD + 連番（例: BK20260312-001）
  const today = new Date().toISOString().split('T')[0].replace(/-/g, '')
  const lastBooking = await DB.prepare(`
    SELECT booking_number FROM bookings 
    WHERE booking_number LIKE ? 
    ORDER BY booking_number DESC LIMIT 1
  `).bind(`BK${today}%`).first()
  
  let seq = 1
  if (lastBooking) {
    const lastSeq = parseInt(lastBooking.booking_number.slice(-3))
    seq = lastSeq + 1
  }
  const bookingNumber = `BK${today}-${String(seq).padStart(3, '0')}`
  
  // ========== 3. 予約グループを作成 ==========
  const bookingResult = await DB.prepare(`
    INSERT INTO bookings (
      booking_number, member_id, event_id, 
      status, booker_name, booker_email, booker_phone,
      gmo_order_id, gmo_access_id, gmo_access_pass
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `).bind(
    bookingNumber,
    member_id,
    event_id,
    'confirmed',                    // クレジットカードは即確定
    `${booker.family_name} ${booker.first_name}`,
    booker.email,
    booker.tel,
    gmo_order_id,                   // GMO注文ID
    gmo_details.credit.AccessID,    // キャンセル時に必要
    gmo_details.credit.AccessPass   // キャンセル時に必要
  ).run()
  
  const bookingId = bookingResult.meta.last_row_id
  
  // ========== 4. 決済番号を生成 ==========
  const paymentNumber = `PAY${today}-${String(seq).padStart(3, '0')}`
  
  // ========== 5. 決済情報を作成 ==========
  const paymentResult = await DB.prepare(`
    INSERT INTO booking_payments (
      booking_id, booking_number, payment_number,
      payment_type, payment_method, payment_status,
      amount, payment_date,
      gmo_order_id, gmo_transaction_id
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `).bind(
    bookingId,
    bookingNumber,
    paymentNumber,
    'immediate',                 // 即時決済
    'credit_card',
    'pending',                   // 仮売上時点では 'pending'（⑧で 'completed' に更新）
    total_amount,
    new Date().toISOString(),
    gmo_order_id,
    gmo_details.credit.AccessID  // GMO取引ID
  ).run()
  
  const paymentId = paymentResult.meta.last_row_id
  
  // ========== 6. カード情報を保存（下4桁のみ） ==========
  await DB.prepare(`
    INSERT INTO booking_card_transactions (
      payment_id, booking_number,
      card_last4, card_exp_month, card_exp_year,
      card_holder_name, transaction_status,
      gmo_transaction_id, gmo_order_id
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `).bind(
    paymentId,
    bookingNumber,
    card_info.last4,           // 下4桁のみ
    card_info.exp_month,
    card_info.exp_year,
    card_info.holder_name,
    'completed',
    gmo_details.credit.AccessID,
    gmo_order_id
  ).run()
  
  // ========== 7. 予約明細を作成 ==========
  // 参加者情報をグループ化
  const itemParticipantsMap = new Map()
  participants.forEach(participant => {
    const key = `${participant.item_type}-${participant.item_id}-${participant.stock_id}-${participant.category}`
    if (!itemParticipantsMap.has(key)) {
      itemParticipantsMap.set(key, [])
    }
    itemParticipantsMap.get(key).push({
      lastname: participant.family_name,
      firstname: participant.first_name,
      // ...その他の参加者情報
    })
  })
  
  // 各商品の予約明細を作成
  for (const item of items) {
    const key = `${item.type}-${item.id}-${item.stock_id}-${item.category}`
    const itemParticipants = itemParticipantsMap.get(key) || []
    
    await DB.prepare(`
      INSERT INTO booking_items (
        booking_id, payment_id, item_type, item_id, item_name,
        quantity, unit_price, subtotal,
        participation_date, price_category,
        stock_id, stock_type,              // 在庫タイプを保存
        participants, product_custom_fields
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).bind(
      bookingId,
      paymentId,
      item.type,                           // 'product' or 'option'
      item.id,                             // 商品ID
      item.name,                           // 商品名
      item.quantity,                       // 数量
      item.unit_price,                     // 単価
      item.unit_price * item.quantity,     // 小計
      participation_date,                  // 参加日
      item.category,                       // 価格帯（例: 'A-大人'）
      item.stock_id,                       // 在庫ID
      item.stock_type || 'individual',     // 在庫タイプ
      JSON.stringify(itemParticipants),    // 参加者情報（JSON）
      JSON.stringify(item.product_custom_fields || {})
    ).run()
  }
  
  // ========== 8. 在庫を減算 ==========
  for (const item of items) {
    if (item.stock_id) {
      const stockType = item.stock_type || 'individual'
      
      if (item.type === 'product') {
        if (stockType === 'individual') {
          // 個別在庫を減算
          await DB.prepare(`
            UPDATE product_stocks 
            SET booked = booked + ?, 
                modified_at = datetime('now', '+9 hours')
            WHERE id = ?
          `).bind(item.quantity, item.stock_id).run()
          
          console.log(`✅ 商品個別在庫減算: stock_id=${item.stock_id}, quantity=${item.quantity}`)
        } else {
          // 共有在庫プールを減算
          await DB.prepare(`
            UPDATE shared_stock_pools 
            SET booked = booked + ?, 
                modified_at = datetime('now', '+9 hours')
            WHERE id = ?
          `).bind(item.quantity, item.stock_id).run()
          
          console.log(`✅ 商品共有在庫減算: pool_id=${item.stock_id}, quantity=${item.quantity}`)
        }
      } else if (item.type === 'option') {
        // オプション在庫も同様の処理
        // ...
      }
    }
  }
  
  // ========== ⑧ クレジットカード決済の売上確定（Capture） ==========
  if (payment_method === 'credit_card' && gmo_access_id && gmo_access_pass) {
    console.log('💳 [GMO Capture] 売上確定開始')
    
    try {
      // GMO売上確定APIリクエスト
      const captureParams = new URLSearchParams({
        ShopID: c.env.GMO_SHOP_ID,
        ShopPass: c.env.GMO_SHOP_PASS,
        AccessID: gmo_access_id,
        AccessPass: gmo_access_pass,
        OrderID: bookingNumber,
        JobCd: 'SALES',        // 売上確定
        Amount: String(total_amount)
      })
      
      const captureResponse = await fetch(`${c.env.GMO_API_URL}/payment/AlterTran.idPass`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: captureParams.toString()
      })
      
      const captureText = await captureResponse.text()
      const captureResult = new URLSearchParams(captureText)
      const errCode = captureResult.get('ErrCode')
      
      if (errCode) {
        console.error('❌ [GMO Capture] 売上確定エラー:', errCode)
        // エラーでも予約は作成済みなので処理続行（手動で後から確定可能）
      } else {
        const tranId = captureResult.get('TranID')
        console.log('✅ [GMO Capture] 売上確定成功:', tranId)
        
        // 決済ステータスを「完了」に更新
        await DB.prepare(`
          UPDATE booking_payments
          SET payment_status = 'completed',
              payment_date = datetime('now', '+9 hours'),
              modified_at = datetime('now', '+9 hours')
          WHERE id = ?
        `).bind(paymentId).run()
        
        console.log('✅ 決済ステータス更新: pending → completed')
      }
    } catch (captureError) {
      console.error('❌ [GMO Capture] 例外エラー:', captureError)
      // エラーでも予約は作成済みなので処理続行
    }
  }
  
  // ========== 9. レスポンスを返す ==========
  return c.json({
    success: true,
    booking_id: bookingId,
    booking_number: bookingNumber,
    payment_number: paymentNumber,
    message: '予約が完了しました'
  }, 201)
})
```

---

### 【Phase 4】予約完了

#### 4.1 予約完了画面（`booking-complete.html`）

```javascript
// URLパラメータから予約情報を取得
const params = new URLSearchParams(window.location.search)
const bookingNumber = params.get('booking_number')  // BK20260312-001
const bookingId = params.get('booking_id')          // 90

// 予約詳細を表示
fetch(`/api/bookings/${bookingId}`)
  .then(res => res.json())
  .then(booking => {
    // 予約番号、商品名、金額、参加日などを表示
    document.getElementById('booking-number').textContent = booking.booking_number
    document.getElementById('total-amount').textContent = `¥${booking.total_amount.toLocaleString()}`
    // ...
  })

// 確認メール送信（自動）
// バックエンドで予約完了メールを送信
```

---

## データベース構造

### bookings（予約グループ）
```sql
CREATE TABLE bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT UNIQUE NOT NULL,       -- BK20260312-001
  member_id INTEGER,                         -- 会員ID
  event_id INTEGER NOT NULL,                 -- イベントID
  status TEXT DEFAULT 'active',              -- confirmed, cancelled, etc.
  booker_name TEXT NOT NULL,                 -- 予約者名
  booker_email TEXT NOT NULL,                -- 予約者メール
  booker_phone TEXT,                         -- 予約者電話
  gmo_order_id TEXT,                         -- GMO注文ID
  gmo_access_id TEXT,                        -- GMOアクセスID（キャンセル用）
  gmo_access_pass TEXT,                      -- GMOアクセスパス（キャンセル用）
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### booking_payments（決済情報）
```sql
CREATE TABLE booking_payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  booking_number TEXT NOT NULL,
  payment_number TEXT NOT NULL,              -- PAY20260312-001
  payment_type TEXT NOT NULL,                -- immediate, split
  payment_method TEXT NOT NULL,              -- credit_card, bank_transfer, convenience
  payment_status TEXT DEFAULT 'pending',     -- pending, completed, failed, refunded
  amount INTEGER NOT NULL,                   -- 決済金額
  payment_date DATETIME,                     -- 決済日時
  payment_due_date DATETIME,                 -- 支払期限（振込・コンビニ）
  gmo_order_id TEXT,                         -- GMO注文ID
  gmo_transaction_id TEXT,                   -- GMO取引ID
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### booking_card_transactions（カード情報）
```sql
CREATE TABLE booking_card_transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  payment_id INTEGER NOT NULL,
  booking_number TEXT NOT NULL,
  card_last4 TEXT,                           -- カード下4桁（例: 1234）
  card_exp_month TEXT,                       -- 有効期限月（例: 12）
  card_exp_year TEXT,                        -- 有効期限年（例: 2028）
  card_holder_name TEXT,                     -- カード名義
  transaction_status TEXT DEFAULT 'pending', -- pending, completed, failed
  gmo_transaction_id TEXT,                   -- GMO取引ID
  gmo_order_id TEXT,                         -- GMO注文ID
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### booking_items（予約明細）
```sql
CREATE TABLE booking_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  payment_id INTEGER,
  item_type TEXT NOT NULL,                   -- product, option, custom
  item_id INTEGER NOT NULL,                  -- 商品ID or オプションID
  item_name TEXT NOT NULL,                   -- 商品名
  stock_id INTEGER,                          -- 在庫ID
  stock_type TEXT DEFAULT 'individual',      -- individual, shared
  price_category TEXT,                       -- 価格帯（例: A-大人）
  quantity INTEGER DEFAULT 1,                -- 数量
  unit_price INTEGER NOT NULL,               -- 単価
  subtotal INTEGER NOT NULL,                 -- 小計
  participation_date TEXT,                   -- 参加日
  participants TEXT,                         -- 参加者情報（JSON）
  status TEXT DEFAULT 'active',              -- active, cancelled
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

---

## 在庫管理

### 在庫タイプ
- **individual（個別在庫）**: `product_stocks` テーブル
- **shared（共有在庫）**: `shared_stock_pools` テーブル

### 在庫減算ロジック
```typescript
// booking_items.stock_type で判定
if (stock_type === 'individual') {
  // product_stocks.booked を増やす
  UPDATE product_stocks SET booked = booked + quantity WHERE id = stock_id
} else {
  // shared_stock_pools.booked を増やす
  UPDATE shared_stock_pools SET booked = booked + quantity WHERE id = stock_id
}
```

---

## セキュリティ

### クレジットカード情報の取り扱い
- ✅ **カード番号は保存しない**（GMOが管理）
- ✅ **下4桁のみ保存**（表示用）
- ✅ **GMOアクセスID/Passを保存**（キャンセル・返金時に必要）
- ✅ **PCI DSS準拠**（GMO Payment Gatewayが認証済み）

### 個人情報保護
- ✅ **HTTPS通信**（Cloudflare SSL）
- ✅ **パスワードハッシュ化**（bcrypt）
- ✅ **SQLインジェクション対策**（Prepared Statements）
- ✅ **XSS対策**（入力値のサニタイズ）

---

## エラーハンドリング

### 決済失敗時
```javascript
// GMOから戻ってきたステータスがERRORの場合
if (gmo_details.Status === 'ERROR') {
  // エラーメッセージを表示
  alert('決済に失敗しました。カード情報をご確認ください。')
  
  // 予約は作成しない
  // 在庫も減算しない
  
  // 決済方法選択画面に戻る
  window.location.href = '/payment-method.html'
}
```

### タイムアウト時
```javascript
// GMO決済画面で一定時間操作がない場合
// セッションタイムアウト
// cancel_urlに戻る
window.location.href = 'https://webapp-geh.pages.dev/payment-method?error=timeout'
```

### 二重決済防止
```typescript
// 予約番号の重複チェック
const existingBooking = await DB.prepare(`
  SELECT id FROM bookings WHERE booking_number = ?
`).bind(bookingNumber).first()

if (existingBooking) {
  return c.json({ error: '予約番号が重複しています' }, 409)
}
```

---

## まとめ

### 予約処理の流れ（要約）
1. 商品選択 → LocalStorage保存
2. メール認証（OTP）
3. 参加者情報入力
4. 決済方法選択（クレジットカード）
5. GMO決済画面でカード情報入力
6. 決済完了後、システムに戻る
7. バックエンドで予約作成
   - 会員登録/確認
   - 予約番号生成
   - 予約グループ作成
   - 決済情報保存
   - カード情報保存（下4桁のみ）
   - 予約明細作成
   - 在庫減算（stock_typeで判定）
8. 予約完了画面表示

### 重要ポイント
- ✅ クレジットカード情報はGMOが管理（PCI DSS準拠）
- ✅ 決済完了後に予約を作成（決済失敗時は予約なし）
- ✅ 在庫はstock_typeで個別/共有を判定して減算
- ✅ GMOアクセスID/Passを保存（キャンセル・返金用）
- ✅ 予約番号は日付+連番で自動生成

---

**最終更新**: 2026-03-12  
**バージョン**: 1.0  
**プロジェクト**: keiokanko_event_html
