# 商品管理API仕様

## エンドポイント一覧

### 1. 商品一覧取得（v1）
**GET** `/api/v1/products`

商品の一覧を取得します。ページネーション対応。

**クエリパラメータ:**
- `page` (optional): ページ番号（デフォルト: 1）
- `per_page` (optional): 1ページあたりの件数（デフォルト: 20）
- `name` (optional): 商品名で部分一致検索
- `event_name` (optional): イベント名で部分一致検索
- `status` (optional): 販売状態 (`0`: 停止中, `1`: 販売中)

**レスポンス例:**
```json
{
  "data": [
    {
      "id": 6,
      "client_id": 1,
      "event_id": 1,
      "name": "テスト商品3",
      "sales_start": "2025-12-24T17:00",
      "sales_end": "2025-12-31T17:00",
      "closing_trade": 3,
      "product_category_id": null,
      "description": "商品説明",
      "remarks": "",
      "fee_include": "",
      "fee_exclude": "",
      "cancel_policy": "",
      "purchase_limit": 5,
      "enable_flg": 1,
      "common_names": "[{\"label\":\"名称1\",\"name\":\"大人\",\"description\":\"大人料金\"}]",
      "deleted_at": null,
      "created_at": "2025-12-24 06:18:49",
      "modified_at": "2025-12-24 06:18:49",
      "price_unit": "人",
      "charge_type": "per_person",
      "charge_description": "1人あたりの料金",
      "event_name": "テストイベント"
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 20,
    "total": 100,
    "total_pages": 5
  }
}
```

---

### 2. 商品詳細取得
**GET** `/api/products/:id`

指定したIDの商品詳細情報を取得します。

**パスパラメータ:**
- `id`: 商品ID

**レスポンス例:**
```json
{
  "product": {
    "id": 6,
    "client_id": 1,
    "event_id": 1,
    "name": "テスト商品3",
    "sales_start": "2025-12-24T17:00",
    "sales_end": "2025-12-31T17:00",
    "description": "商品説明",
    "enable_flg": 1,
    "event_name": "テストイベント"
  }
}
```

---

### 3. 商品作成
**POST** `/api/products`

新しい商品を作成します。

**リクエストボディ:**
```json
{
  "name": "新しい商品",
  "event_id": 1,
  "product_category_id": 1,
  "sales_start": "2025-12-25 09:00",
  "sales_end": "2025-12-31 18:00",
  "closing_trade": 3,
  "description": "商品説明",
  "remarks": "備考",
  "fee_include": "含まれる費用",
  "fee_exclude": "含まれない費用",
  "cancel_policy": "キャンセルポリシー",
  "purchase_limit": 10,
  "enable_flg": 1,
  "common_names": [
    {"label": "名称1", "name": "大人", "description": "大人料金"},
    {"label": "名称2", "name": "子供", "description": "子供料金"}
  ],
  "price_unit": "人",
  "charge_type": "per_person"
}
```

**必須フィールド:**
- `name`: 商品名
- `event_id`: イベントID
- `sales_start`: 販売開始日時
- `sales_end`: 販売終了日時

**レスポンス例:**
```json
{
  "success": true,
  "id": 7,
  "message": "商品を登録しました"
}
```

---

### 4. 商品更新
**PUT** `/api/products/:id`

既存の商品を更新します。部分更新に対応しています。

**パスパラメータ:**
- `id`: 商品ID

**リクエストボディ (部分更新可能):**
```json
{
  "name": "更新された商品名",
  "description": "更新された説明",
  "enable_flg": 1,
  "purchase_limit": 20
}
```

**更新可能なフィールド:**
- `name`: 商品名
- `description`: 説明
- `remarks`: 備考
- `sales_start`: 販売開始日時
- `sales_end`: 販売終了日時
- `enable_flg`: 有効フラグ
- `purchase_limit`: 購入制限数

**レスポンス例:**
```json
{
  "success": true,
  "message": "商品を更新しました"
}
```

---

### 5. 商品削除（論理削除）
**DELETE** `/api/products/:id`

商品を論理削除します（`deleted_at`を設定）。

**パスパラメータ:**
- `id`: 商品ID

**レスポンス例:**
```json
{
  "message": "商品を削除しました"
}
```

---

### 6. 商品コピー
**POST** `/api/products/:id/copy`

既存の商品をコピーして新しい商品を作成します。

**パスパラメータ:**
- `id`: コピー元の商品ID

**動作:**
- コピー後の商品名: `"コピー " + 元の商品名`
- コピー後の販売状態: `enable_flg = 0` (停止中)

**レスポンス例:**
```json
{
  "success": true,
  "id": 8,
  "message": "商品をコピーしました"
}
```

---

### 7. 商品在庫一覧取得
**GET** `/api/products/:id/stocks`

商品の在庫情報一覧を取得します。

**パスパラメータ:**
- `id`: 商品ID

**レスポンス例:**
```json
{
  "stocks": [
    {
      "id": 1,
      "product_id": 6,
      "date": "2025-12-30",
      "stock": 50,
      "booked": 10,
      "available": 40,
      "stock_name": "午前便",
      "price_band": "A",
      "enable_flg": 1
    }
  ]
}
```

---

### 8. 商品共有在庫紐付け一覧取得
**GET** `/api/products/:id/shared-stocks`

商品に紐付けられた共有在庫の一覧を取得します。

**パスパラメータ:**
- `id`: 商品ID

**レスポンス例:**
```json
{
  "shared_stocks": [
    {
      "id": 1,
      "product_id": 6,
      "shared_stock_pool_id": 1,
      "stock_name": "駐車場",
      "price_band": "A",
      "consume_quantity": 1,
      "enable_flg": 1,
      "pool_name": "駐車場プール",
      "pool_code": "PARKING_001",
      "date": "2025-12-30"
    }
  ]
}
```

---

### 9. 商品に共有在庫を紐付け
**POST** `/api/products/:id/shared-stocks`

商品に共有在庫プールを紐付けます。

**パスパラメータ:**
- `id`: 商品ID

**リクエストボディ:**
```json
{
  "shared_stock_pool_id": 1,
  "stock_name": "駐車場",
  "price_band": "A",
  "consume_quantity": 1
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

### 10. 商品に共有在庫を一括紐付け
**POST** `/api/products/:id/shared-stocks/batch`

指定したプール名・コード・日付範囲に該当するすべての共有在庫プールを商品に紐付けます。

**パスパラメータ:**
- `id`: 商品ID

**リクエストボディ:**
```json
{
  "pool_name": "駐車場プール",
  "pool_code": "PARKING_001",
  "date_from": "2025-12-25",
  "date_to": "2025-12-31",
  "stock_name": "駐車場",
  "price_band": "A"
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

### 11. 商品の共有在庫紐付け削除
**DELETE** `/api/products/:productId/shared-stocks/:id`

商品と共有在庫プールの紐付けを削除します（論理削除）。

**パスパラメータ:**
- `productId`: 商品ID
- `id`: 紐付けID

**レスポンス例:**
```json
{
  "success": true,
  "message": "共有在庫の紐付けを削除しました"
}
```

---

### 12. 商品価格一覧取得
**GET** `/api/products/:id/prices`

商品の価格情報一覧を取得します。

**パスパラメータ:**
- `id`: 商品ID

**レスポンス例:**
```json
{
  "prices": [
    {
      "id": 1,
      "product_id": 6,
      "price": 5000,
      "category_name": "PriceBand-大人",
      "created_at": "2025-12-24 06:18:49"
    }
  ]
}
```

---

### 13. 商品価格追加
**POST** `/api/products/:id/prices`

商品に価格情報を追加します。

**パスパラメータ:**
- `id`: 商品ID

**リクエストボディ:**
```json
{
  "price": 5000,
  "category_name": "PriceBand-大人"
}
```

**レスポンス例:**
```json
{
  "success": true,
  "id": 2,
  "message": "価格を追加しました"
}
```

---

### 14. 商品価格削除
**DELETE** `/api/products/:productId/prices/:priceId`

商品の価格情報を削除します。

**パスパラメータ:**
- `productId`: 商品ID
- `priceId`: 価格ID

**レスポンス例:**
```json
{
  "success": true,
  "message": "価格を削除しました"
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

## フロントエンドの実装状況

✅ **商品管理画面** (`/admin/products`)
- **完全にAPI化済み**
- API経由でデータを取得・表示
- 検索機能: 商品名、イベント名、状態でフィルタリング
- 削除・コピー機能: API経由で実行

---

## データベース構造

### productsテーブル
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | INTEGER | 主キー |
| client_id | INTEGER | クライアントID |
| event_id | INTEGER | イベントID（外部キー） |
| name | TEXT | 商品名 |
| sales_start | DATETIME | 販売開始日時 |
| sales_end | DATETIME | 販売終了日時 |
| closing_trade | INTEGER | 締切日数 |
| product_category_id | INTEGER | カテゴリーID |
| description | TEXT | 説明 |
| remarks | TEXT | 備考 |
| fee_include | TEXT | 含まれる費用 |
| fee_exclude | TEXT | 含まれない費用 |
| cancel_policy | TEXT | キャンセルポリシー |
| purchase_limit | INTEGER | 購入制限数 |
| enable_flg | INTEGER | 有効フラグ (0: 無効, 1: 有効) |
| common_names | TEXT | 共通名称（JSON） |
| price_unit | TEXT | 価格単位 |
| charge_type | TEXT | 課金タイプ |
| deleted_at | DATETIME | 削除日時（論理削除） |
| created_at | DATETIME | 作成日時 |
| modified_at | DATETIME | 更新日時 |

### product_pricesテーブル
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | INTEGER | 主キー |
| product_id | INTEGER | 商品ID（外部キー） |
| price | INTEGER | 価格 |
| category_name | TEXT | 価格カテゴリー名 |
| created_at | DATETIME | 作成日時 |
| modified_at | DATETIME | 更新日時 |

### product_shared_stocksテーブル
| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | INTEGER | 主キー |
| product_id | INTEGER | 商品ID（外部キー） |
| shared_stock_pool_id | INTEGER | 共有在庫プールID（外部キー） |
| stock_name | TEXT | 在庫名 |
| price_band | TEXT | 価格帯 |
| consume_quantity | INTEGER | 消費数量 |
| enable_flg | INTEGER | 有効フラグ |
| created_at | DATETIME | 作成日時 |
| modified_at | DATETIME | 更新日時 |

---

## テスト手順

### 1. 商品一覧取得
```bash
curl -s "http://localhost:3000/api/v1/products?per_page=10" | jq '.'
```

### 2. 商品詳細取得
```bash
curl -s http://localhost:3000/api/products/6 | jq '.'
```

### 3. 商品更新
```bash
curl -s -X PUT http://localhost:3000/api/products/6 \
  -H "Content-Type: application/json" \
  -d '{"description": "更新された説明"}' | jq '.'
```

### 4. 商品削除
```bash
curl -s -X DELETE http://localhost:3000/api/products/6 | jq '.'
```

### 5. 検索条件でフィルター
```bash
# 販売中のみ
curl -s "http://localhost:3000/api/v1/products?status=1" | jq '.'

# 名前で検索
curl -s "http://localhost:3000/api/v1/products?name=テスト" | jq '.'

# 複数条件
curl -s "http://localhost:3000/api/v1/products?name=テスト&status=1&per_page=5" | jq '.'
```

---

最終更新: 2025-12-24
