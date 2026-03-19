# イベント担当者API 500エラー修正

## 🐛 エラー詳細

### エラーメッセージ
```
GET https://3000-ib4b640jlamofc0mqgpvk-583b4d74.sandbox.gensparksite.com/api/events/4/staff 500 (Internal Server Error)
admin-event-form.js?v=20260217-009:1792
loadExistingStaff @ admin-event-form.js?v=20260217-009:1792
[loadExistingStaff] APIエラー: 500
```

### 発生場所
- **URL**: `/api/events/4/staff`
- **エンドポイント**: `GET /api/events/:id/staff`
- **呼び出し元**: `admin-event-form.js` の `loadExistingStaff()` 関数

## 🔍 根本原因

### データベーステーブルの欠落
APIエンドポイント `/api/events/:id/staff` で以下のSQLクエリを実行しようとしていました：

```sql
SELECT 
  es.id,
  es.account_id,
  a.person_name as name,
  a.login_id,
  a.email,
  b.branch_name,
  es.assigned_at
FROM event_staff es
JOIN accounts a ON es.account_id = a.id
LEFT JOIN branches b ON a.primary_branch_code = b.branch_code
WHERE es.event_id = ?
ORDER BY a.person_name
```

しかし、**`event_staff`テーブルが存在しない**ため、SQLクエリが失敗し、500エラーが返されていました。

### APIコード（src/index.tsx:3216）
```typescript
app.get('/api/events/:id/staff', async (c) => {
  const { DB } = c.env
  const eventId = c.req.param('id')
  
  try {
    const { results: staff } = await DB.prepare(`
      SELECT ... FROM event_staff es  // ← テーブルが存在しない
      ...
    `).bind(eventId).all()
    
    return c.json({ staff: staff || [] })
  } catch (error) {
    console.error('イベント担当者取得エラー:', error)
    return c.json({ error: 'イベント担当者の取得に失敗しました' }, 500)
  }
})
```

## ✅ 修正内容

### マイグレーションファイルの作成
`migrations/0023_create_event_staff_table.sql` を作成し、`event_staff`テーブルを定義しました。

```sql
-- イベント担当者テーブルの作成
CREATE TABLE IF NOT EXISTS event_staff (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  UNIQUE(event_id, account_id)
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_event_staff_event_id ON event_staff(event_id);
CREATE INDEX IF NOT EXISTS idx_event_staff_account_id ON event_staff(account_id);
```

### テーブル設計

#### カラム定義
- **id**: 主キー（自動採番）
- **event_id**: イベントID（外部キー → events.id）
- **account_id**: 担当者ID（外部キー → accounts.id）
- **assigned_at**: 割り当て日時（デフォルト: 現在時刻）

#### 制約
- **FOREIGN KEY**: イベントまたはアカウントが削除された場合、関連レコードも削除（CASCADE）
- **UNIQUE(event_id, account_id)**: 同じイベントに同じ担当者を重複して割り当てることはできない

#### インデックス
- **idx_event_staff_event_id**: event_id でのクエリを高速化
- **idx_event_staff_account_id**: account_id でのクエリを高速化

### マイグレーション適用
```bash
npx wrangler d1 migrations apply webapp-production --local
```

**結果**:
```
✅ 0023_create_event_staff_table.sql
4 commands executed successfully.
```

## 🎯 修正効果

### API動作の正常化
```bash
# 修正前
$ curl "http://localhost:3000/api/events/4/staff"
{"error":"イベント担当者の取得に失敗しました"}  # 500 Error

# 修正後
$ curl "http://localhost:3000/api/events/4/staff"
{"staff":[]}  # 200 OK（空の配列 = まだ担当者が割り当てられていない）
```

### 解決される問題
1. ✅ `/api/events/:id/staff` エンドポイントが正常に動作
2. ✅ イベント編集画面で「読み込み中」が正常に消える
3. ✅ 担当者の割り当て・表示機能が使用可能になる
4. ✅ コンソールエラーが解消される

## 📊 event_staff テーブルの役割

### 多対多の関係管理
```
events (1) ←→ (N) event_staff (N) ←→ (1) accounts
```

- **1つのイベント** に **複数の担当者** を割り当て可能
- **1人の担当者** が **複数のイベント** を担当可能
- 中間テーブル `event_staff` で多対多の関係を実現

### 使用例

#### 担当者を割り当てる（POST /api/events/:id/staff）
```javascript
POST /api/events/4/staff
{
  "assigned_staff": [2, 3]  // アカウントID 2 と 3 を割り当て
}
```

```sql
-- 内部処理
DELETE FROM event_staff WHERE event_id = 4;
INSERT INTO event_staff (event_id, account_id) VALUES (4, 2);
INSERT INTO event_staff (event_id, account_id) VALUES (4, 3);
```

#### 担当者を取得する（GET /api/events/:id/staff）
```javascript
GET /api/events/4/staff

// レスポンス
{
  "staff": [
    {
      "id": 1,
      "account_id": 2,
      "name": "本社管理者",
      "login_id": "keio_honsha",
      "email": "honsha@example.com",
      "branch_name": "本社",
      "assigned_at": "2026-02-17 06:30:00"
    },
    {
      "id": 2,
      "account_id": 3,
      "name": "新宿支店担当",
      "login_id": "keio_shinjuku",
      "email": "shinjuku@example.com",
      "branch_name": "新宿",
      "assigned_at": "2026-02-17 06:30:00"
    }
  ]
}
```

## 🚀 デプロイ状態
- ✅ ローカル環境: テーブル作成済み、動作確認済み
- ⏳ 本番環境: 未デプロイ（マイグレーション適用が必要）

## 🧪 テスト方法

### 1. APIエンドポイントのテスト
```bash
# 担当者取得（初期状態は空）
curl "http://localhost:3000/api/events/4/staff"
# 期待: {"staff":[]}

# 担当者割り当て
curl -X POST "http://localhost:3000/api/events/4/staff" \
  -H "Content-Type: application/json" \
  -d '{"assigned_staff": [2, 3]}'
# 期待: {"success":true,"message":"担当者を更新しました","count":2}

# 担当者取得（割り当て後）
curl "http://localhost:3000/api/events/4/staff"
# 期待: {"staff":[{...}, {...}]}
```

### 2. イベント編集画面のテスト
1. ブラウザでハードリロード（Ctrl+Shift+R）
2. `/events-form?id=4` を開く
3. 「担当者設定」セクションを確認
4. 「検索」ボタンをクリックして担当者を選択
5. フォームを保存
6. ページをリロードして、選択した担当者が表示されることを確認

### 3. コンソールログの確認
デベロッパーツールで以下のログが表示されることを確認：
```
✅ 担当者データ読み込み: 2名
✅ イベントデータ読み込み開始: 4
✅ [loadExistingStaff] イベントID: 4 で担当者を取得します
✅ 初期化完了
```

**エラーログが表示されないこと**:
```
❌ GET .../api/events/4/staff 500 (Internal Server Error)  ← このエラーが消える
❌ [loadExistingStaff] APIエラー: 500  ← このエラーが消える
```

---
**更新日**: 2026-02-17  
**コミット**: 4ff4a86  
**マイグレーション**: `migrations/0023_create_event_staff_table.sql`
