# オプション管理API仕様

## エンドポイント一覧

### 1. オプション一覧取得
**GET** `/api/options`

オプションの一覧を取得します。検索条件でフィルタリング可能です。

**クエリパラメータ:**
- `name` (optional): オプション名で部分一致検索
- `event_name` (optional): イベント名で部分一致検索
- `status` (optional): 販売状態 (`0`: 停止中, `1`: 販売中)

**レスポンス例:**
```json
{
  "options": [
    {
      "id": 1,
      "event_id": 1,
      "name": "バス送迎",
      "description": "更新されたバス送迎サービスの説明",
      "remarks": null,
      "option_category_id": 1,
      "enable_flg": 1,
      "created_at": "2025-12-24 08:26:19",
      "modified_at": "2025-12-24 08:35:42",
      "deleted_at": null,
      "event_name": "テストイベント",
      "category_name": "送迎",
      "prices": "1000"
    }
  ]
}
```

---

### 2. オプション詳細取得
**GET** `/api/options/:id`

指定したIDのオプション詳細と価格情報を取得します。

**パスパラメータ:**
- `id`: オプションID

**レスポンス例:**
```json
{
  "option": {
    "id": 1,
    "event_id": 1,
    "name": "バス送迎",
    "description": "更新されたバス送迎サービスの説明",
    "remarks": null,
    "option_category_id": 1,
    "enable_flg": 1,
    "created_at": "2025-12-24 08:26:19",
    "modified_at": "2025-12-24 08:35:42",
    "deleted_at": null,
    "event_name": "テストイベント",
    "category_name": "送迎"
  },
  "prices": [
    {
      "id": 1,
      "option_id": 1,
      "price": 1000,
      "category_name": "一般",
      "created_at": "2025-12-24 08:26:19",
      "modified_at": "2025-12-24 08:26:19"
    }
  ]
}
```

---

### 3. オプション作成
**POST** `/api/options`

新しいオプションを作成します。

**リクエストボディ:**
```json
{
  "name": "バス送迎",
  "description": "イベント会場までのバス送迎",
  "remarks": "",
  "event_id": 1,
  "option_category_id": 1,
  "price": 1000,
  "enable_flg": 1
}
```

**必須フィールド:**
- `name`: オプション名
- `event_id`: イベントID
- `option_category_id`: オプションカテゴリーID
- `price`: 価格

**レスポンス例:**
```json
{
  "success": true,
  "id": 1,
  "message": "オプションを登録しました"
}
```

---

### 4. オプション更新
**PUT** `/api/options/:id`

既存のオプションを更新します。部分更新に対応しています。

**パスパラメータ:**
- `id`: オプションID

**リクエストボディ (部分更新可能):**
```json
{
  "name": "新しいオプション名",
  "description": "更新された説明",
  "remarks": "備考欄",
  "event_id": 1,
  "option_category_id": 1,
  "enable_flg": 1
}
```

**更新可能なフィールド:**
- `name`: オプション名
- `description`: 説明
- `remarks`: 備考
- `event_id`: イベントID
- `option_category_id`: オプションカテゴリーID
- `enable_flg`: 有効フラグ

**レスポンス例:**
```json
{
  "success": true,
  "message": "オプションを更新しました"
}
```

---

### 5. オプション削除（論理削除）
**DELETE** `/api/options/:id`

オプションを論理削除します（`deleted_at`を設定）。

**パスパラメータ:**
- `id`: オプションID

**レスポンス例:**
```json
{
  "message": "オプションを削除しました"
}
```

---

### 6. オプションコピー
**POST** `/api/options/:id/copy`

既存のオプションをコピーして新しいオプションを作成します。

**パスパラメータ:**
- `id`: コピー元のオプションID

**動作:**
- コピー後のオプション名: `"コピー " + 元のオプション名`
- コピー後の販売状態: `enable_flg = 0` (停止中)

**レスポンス例:**
```json
{
  "success": true,
  "id": 2,
  "message": "オプションをコピーしました"
}
```

---

### 7. オプションの共有在庫紐付け一覧取得
**GET** `/api/options/:id/shared-stocks`

オプションに紐付けられた共有在庫の一覧を取得します。

**パスパラメータ:**
- `id`: オプションID

**レスポンス例:**
```json
{
  "shared_stocks": [
    {
      "id": 1,
      "option_id": 1,
      "shared_stock_pool_id": 1,
      "stock_name": "駐車場",
      "consume_quantity": 1,
      "priority": 1,
      "enable_flg": 1,
      "pool_name": "駐車場プール",
      "pool_code": "PARKING_001",
      "date": "2025-12-30",
      "total_stock": 30,
      "booked": 0
    }
  ]
}
```

---

### 8. オプションに共有在庫を紐付け
**POST** `/api/options/:id/shared-stocks`

オプションに共有在庫プールを紐付けます。

**パスパラメータ:**
- `id`: オプションID

**リクエストボディ:**
```json
{
  "shared_stock_pool_id": 1,
  "stock_name": "駐車場",
  "consume_quantity": 1,
  "priority": 1
}
```

**必須フィールド:**
- `shared_stock_pool_id`: 共有在庫プールID

**レスポンス例:**
```json
{
  "success": true,
  "message": "共有在庫を紐付けました"
}
```

---

### 9. オプションに共有在庫を一括紐付け
**POST** `/api/options/:id/shared-stocks/batch`

指定したプール名・コード・日付範囲に該当するすべての共有在庫プールをオプションに紐付けます。

**パスパラメータ:**
- `id`: オプションID

**リクエストボディ:**
```json
{
  "pool_name": "駐車場プール",
  "pool_code": "PARKING_001",
  "date_from": "2025-12-25",
  "date_to": "2025-12-31",
  "stock_name": "駐車場",
  "consume_quantity": 1,
  "priority": 1
}
```

**必須フィールド:**
- `pool_name`: プール名
- `pool_code`: プールコード
- `date_from`: 開始日
- `date_to`: 終了日

**レスポンス例:**
```json
{
  "success": true,
  "message": "5件の共有在庫を紐付けました"
}
```

---

### 10. オプションの共有在庫紐付け削除
**DELETE** `/api/options/:optionId/shared-stocks/:id`

オプションと共有在庫プールの紐付けを削除します（論理削除）。

**パスパラメータ:**
- `optionId`: オプションID
- `id`: 紐付けID

**レスポンス例:**
```json
{
  "success": true,
  "message": "共有在庫の紐付けを削除しました"
}
```

---

### 11. オプション在庫追加
**POST** `/api/options/:id/stocks`

オプションに在庫情報を追加します。

**パスパラメータ:**
- `id`: オプションID

**リクエストボディ:**
```json
{
  "date": "2025-12-30",
  "stock": 50,
  "stock_name": "午前便",
  "price_band": "A"
}
```

**必須フィールド:**
- `date`: 在庫日付
- `stock`: 在庫数

**レスポンス例:**
```json
{
  "success": true,
  "id": 1,
  "message": "在庫を登録しました"
}
```

---

### 12. オプション在庫削除
**DELETE** `/api/options/:id/stocks/:stockId`

オプションの在庫情報を削除します（論理削除）。

**パスパラメータ:**
- `id`: オプションID
- `stockId`: 在庫ID

**レスポンス例:**
```json
{
  "success": true,
  "message": "在庫を削除しました"
}
```

---

## エラーレスポンス

すべてのAPIで共通のエラーレスポンス形式を使用します：

```json
{
  "error": "エラーメッセージ"
}
```

**HTTPステータスコード:**
- `200 OK`: 成功
- `400 Bad Request`: リクエストパラメータ不正
- `404 Not Found`: リソースが見つからない
- `500 Internal Server Error`: サーバーエラー

---

## データベース構造

### optionsテーブル
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | INTEGER | 主キー |
| event_id | INTEGER | イベントID（外部キー） |
| name | TEXT | オプション名 |
| description | TEXT | 説明 |
| remarks | TEXT | 備考 |
| option_category_id | INTEGER | カテゴリーID（外部キー） |
| cancel_policy | TEXT | キャンセルポリシー |
| note | TEXT | 注意事項 |
| enable_flg | INTEGER | 有効フラグ (0: 無効, 1: 有効) |
| created_at | DATETIME | 作成日時 |
| modified_at | DATETIME | 更新日時 |
| deleted_at | DATETIME | 削除日時（論理削除） |

### option_pricesテーブル
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | INTEGER | 主キー |
| option_id | INTEGER | オプションID（外部キー） |
| price | INTEGER | 価格 |
| category_name | TEXT | 価格カテゴリー名 |
| created_at | DATETIME | 作成日時 |
| modified_at | DATETIME | 更新日時 |

### option_shared_stocksテーブル
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | INTEGER | 主キー |
| option_id | INTEGER | オプションID（外部キー） |
| shared_stock_pool_id | INTEGER | 共有在庫プールID（外部キー） |
| stock_name | TEXT | 在庫名 |
| consume_quantity | INTEGER | 消費数量 |
| priority | INTEGER | 優先度 |
| enable_flg | INTEGER | 有効フラグ |
| created_at | DATETIME | 作成日時 |
| modified_at | DATETIME | 更新日時 |

---

## テスト手順

### 1. オプション一覧取得
```bash
curl -s http://localhost:3000/api/options | jq '.'
```

### 2. オプション詳細取得
```bash
curl -s http://localhost:3000/api/options/1 | jq '.'
```

### 3. オプション更新
```bash
curl -s -X PUT http://localhost:3000/api/options/1 \
  -H "Content-Type: application/json" \
  -d '{"description": "更新された説明"}' | jq '.'
```

### 4. オプション削除
```bash
curl -s -X DELETE http://localhost:3000/api/options/1 | jq '.'
```

### 5. 検索条件でフィルター
```bash
# 販売中のみ
curl -s "http://localhost:3000/api/options?status=1" | jq '.'

# 名前で検索
curl -s "http://localhost:3000/api/options?name=バス" | jq '.'

# 複数条件
curl -s "http://localhost:3000/api/options?name=バス&status=1" | jq '.'
```

---

最終更新: 2025-12-24
