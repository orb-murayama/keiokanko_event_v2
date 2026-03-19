# GMO決済 仮売上・売上確定 運用ガイド

## 概要

現在のシステムは **GMO Payment Gateway** を使用し、クレジットカード決済を **仮売上（AUTH）** で処理しています。

---

## 仮売上と売上確定の流れ

### 1. ユーザーが予約・決済（仮売上）
```
ユーザー予約 → GMO決済画面 → カード情報入力 
→ 仮売上（AUTH）実行 → カード枠確保 
→ 予約作成（status: confirmed）
→ 決済ステータス: pending
```

### 2. 管理者が売上確定（CAPTURE）
```
イベント開催前 or 発送前
→ 管理画面で「売上確定」ボタンクリック
→ GMO APIで売上確定（CAPTURE）実行
→ 決済ステータス: completed
→ カード会社から入金
```

### 3. キャンセル時の処理

#### **仮売上期間中（売上確定前）**
```
管理画面で「仮売上取消」ボタンクリック
→ GMO APIで取消（VOID）実行
→ カード枠解放（返金不要）
→ 決済ステータス: cancelled
```

#### **売上確定後**
```
管理画面で「返金」処理
→ GMO APIで返金（REFUND）実行
→ カード会社経由で返金
→ 決済ステータス: refunded
```

---

## API仕様

### 1. 売上確定API

**エンドポイント**: `POST /api/v2/gmo/capture-payment`  
**認証**: 必要（requireAuth）

**リクエスト**:
```json
{
  "booking_number": "BK20260312-001",
  "amount": 16000
}
```

**レスポンス（成功）**:
```json
{
  "success": true,
  "message": "売上確定が完了しました",
  "order_id": "BK20260312-001",
  "tran_id": "202603121234567890",
  "tran_date": "20260312123456"
}
```

**レスポンス（エラー）**:
```json
{
  "error": "GMO売上確定に失敗しました",
  "gmo_error_code": "E01",
  "gmo_error_info": "既に売上確定済みです"
}
```

---

### 2. 仮売上取消API

**エンドポイント**: `POST /api/v2/gmo/void-payment`  
**認証**: 必要（requireAuth）

**リクエスト**:
```json
{
  "booking_number": "BK20260312-001"
}
```

**レスポンス（成功）**:
```json
{
  "success": true,
  "message": "仮売上取消が完了しました",
  "order_id": "BK20260312-001",
  "tran_id": "202603121234567890"
}
```

**レスポンス（エラー）**:
```json
{
  "error": "GMO仮売上取消に失敗しました",
  "gmo_error_code": "E01",
  "gmo_error_info": "既に売上確定済みのため取消できません"
}
```

---

## 管理画面の実装（予定）

### 予約詳細画面に追加するボタン

```javascript
// 決済ステータスに応じてボタンを表示

if (payment_status === 'pending' && payment_method === 'credit_card') {
  // 仮売上状態
  
  // 【売上確定】ボタン
  <button onclick="capturePayment('BK20260312-001', 16000)">
    💰 売上確定
  </button>
  
  // 【仮売上取消】ボタン
  <button onclick="voidPayment('BK20260312-001')">
    🚫 仮売上取消（返金不要）
  </button>
  
} else if (payment_status === 'completed') {
  // 売上確定済み
  
  // 【返金】ボタン（既存機能）
  <button onclick="refundPayment('BK20260312-001', 16000)">
    💸 返金処理
  </button>
}
```

### JavaScriptコード例

```javascript
// 売上確定
async function capturePayment(bookingNumber, amount) {
  if (!confirm(`予約番号 ${bookingNumber} の売上を確定しますか？\n金額: ¥${amount.toLocaleString()}`)) {
    return
  }
  
  try {
    const response = await fetch('/api/v2/gmo/capture-payment', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${getAuthToken()}`
      },
      body: JSON.stringify({
        booking_number: bookingNumber,
        amount: amount
      })
    })
    
    const result = await response.json()
    
    if (result.success) {
      alert('売上確定が完了しました')
      location.reload()  // ページをリロード
    } else {
      alert(`エラー: ${result.error}`)
    }
  } catch (error) {
    console.error('売上確定エラー:', error)
    alert('売上確定に失敗しました')
  }
}

// 仮売上取消
async function voidPayment(bookingNumber) {
  if (!confirm(`予約番号 ${bookingNumber} の仮売上を取消しますか？\nカード枠が解放されます（返金処理は不要）`)) {
    return
  }
  
  try {
    const response = await fetch('/api/v2/gmo/void-payment', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${getAuthToken()}`
      },
      body: JSON.stringify({
        booking_number: bookingNumber
      })
    })
    
    const result = await response.json()
    
    if (result.success) {
      alert('仮売上取消が完了しました')
      location.reload()
    } else {
      alert(`エラー: ${result.error}`)
    }
  } catch (error) {
    console.error('仮売上取消エラー:', error)
    alert('仮売上取消に失敗しました')
  }
}
```

---

## 運用フロー

### パターン1: 正常なイベント実施

```
1. ユーザーが予約・決済（仮売上）
   → payment_status: pending

2. イベント開催2日前に売上確定
   → 管理画面で「売上確定」ボタンクリック
   → payment_status: completed

3. イベント実施
```

### パターン2: イベント前にキャンセル

```
1. ユーザーが予約・決済（仮売上）
   → payment_status: pending

2. ユーザーからキャンセル依頼
   → 管理画面で「仮売上取消」ボタンクリック
   → payment_status: cancelled
   → カード枠解放（返金処理不要）
```

### パターン3: イベント後にキャンセル（売上確定後）

```
1. ユーザーが予約・決済（仮売上）
   → payment_status: pending

2. イベント開催前に売上確定
   → payment_status: completed

3. イベント実施

4. 後日クレーム・返金依頼
   → 管理画面で「返金」ボタンクリック
   → GMO返金API（REFUND）実行
   → payment_status: refunded
```

---

## 仮売上の有効期限

- **GMO Payment Gateway**: 通常45日間
- 有効期限を過ぎると自動的に取消される
- **推奨**: イベント開催3日前〜前日に売上確定

---

## 決済ステータス一覧

```
pending    : 仮売上状態（オーソリ済み、売上未確定）
completed  : 売上確定済み
cancelled  : 取消済み（仮売上取消）
refunded   : 返金済み（売上確定後の返金）
failed     : 決済失敗
```

---

## GMO API仕様

### 売上確定（CAPTURE）

**エンドポイント**: `https://pt01.mul-pay.jp/payment/AlterTran.idPass`  
**メソッド**: POST  
**Content-Type**: `application/x-www-form-urlencoded`

**パラメータ**:
```
ShopID      : ショップID
ShopPass    : ショップパスワード
AccessID    : 取引ID（仮売上時に取得）
AccessPass  : 取引パスワード（仮売上時に取得）
OrderID     : 注文ID（予約番号）
JobCd       : SALES（売上確定）
Amount      : 売上金額
```

**レスポンス**:
```
OrderID=BK20260312-001&TranID=202603121234567890&TranDate=20260312123456
```

### 仮売上取消（VOID）

**エンドポイント**: `https://pt01.mul-pay.jp/payment/AlterTran.idPass`  
**メソッド**: POST  
**Content-Type**: `application/x-www-form-urlencoded`

**パラメータ**:
```
ShopID      : ショップID
ShopPass    : ショップパスワード
AccessID    : 取引ID
AccessPass  : 取引パスワード
OrderID     : 注文ID
JobCd       : VOID（仮売上取消）
```

**レスポンス**:
```
OrderID=BK20260312-001&TranID=202603121234567890
```

---

## セキュリティ

### 保存する情報

**bookingsテーブル**:
```sql
gmo_order_id    : GMO注文ID
gmo_access_id   : 取引ID（売上確定・取消時に必要）
gmo_access_pass : 取引パスワード（売上確定・取消時に必要）
```

### 注意事項

- ✅ `gmo_access_id`、`gmo_access_pass` は必ず保存する
- ✅ これらがないと売上確定・取消ができない
- ✅ フロントエンドには露出しない（管理画面のみ）
- ✅ HTTPS通信で保護

---

## トラブルシューティング

### エラーコード

| コード | 説明 | 対処法 |
|--------|------|--------|
| E01 | 既に売上確定済み | 処理済みのため操作不要 |
| E11 | 取引が見つからない | AccessID/AccessPassを確認 |
| E61 | 仮売上期限切れ | 新規決済が必要 |
| E91 | 通信エラー | GMOサーバーの状態を確認 |

### よくある質問

**Q1: 仮売上と売上確定のタイミングは？**
```
推奨: イベント開催3日前〜前日
理由: 
• キャンセル対応がしやすい（仮売上取消=返金不要）
• 有効期限（45日）に余裕を持つ
```

**Q2: 売上確定を忘れたらどうなる？**
```
• 45日後に自動的に取消される
• 売上が確定しない
• 新規に決済が必要
```

**Q3: 売上確定後にキャンセルする場合は？**
```
• 返金処理（REFUND）が必要
• 既存の返金APIを使用
• カード会社経由で返金（数日〜2週間）
```

---

## まとめ

### 変更内容

1. ✅ **JobCdを変更**: `CAPTURE` → `AUTH`
2. ✅ **売上確定API追加**: `POST /api/v2/gmo/capture-payment`
3. ✅ **仮売上取消API追加**: `POST /api/v2/gmo/void-payment`
4. ⏳ **管理画面UI追加**: 予約詳細画面にボタンを追加（次のステップ）

### 次の作業

- [ ] 管理画面の予約詳細画面にボタンを追加
- [ ] テスト環境で動作確認
- [ ] 本番環境にデプロイ

---

**最終更新**: 2026-03-12  
**バージョン**: 1.0  
**プロジェクト**: keiokanko_event_html
