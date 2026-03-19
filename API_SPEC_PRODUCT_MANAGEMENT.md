# 商品管理API仕様書

**バージョン**: 1.2  
**作成日**: 2026-02-05  
**最終更新**: 2026-02-05

---

## 目次

1. [概要](#概要)
2. [基本情報](#基本情報)
3. [認証](#認証)
4. [エンドポイント一覧](#エンドポイント一覧)
5. [API詳細](#api詳細)
6. [データモデル](#データモデル)
7. [エラーレスポンス](#エラーレスポンス)
8. [関連ドキュメント](#関連ドキュメント)
9. [変更履歴](#変更履歴)

---

## 概要

商品管理APIは、イベントに紐づく商品（チケット・ツアーパッケージ等）の作成、取得、更新、削除を行うためのAPIです。商品には価格帯、在庫、共有在庫プール、カスタムフォーム項目設定などの機能が含まれます。

**主要機能**:
- 商品の CRUD 操作
- 価格帯・在庫管理
- 共有在庫プール管理
- カスタムフォーム項目設定（商品・参加者毎の区分対応）
- 画像アップロード

**エンドポイント総数**: 28件

---

## 基本情報

- **ベースURL**: `https://your-domain.com/api`
- **プロトコル**: HTTPS
- **データ形式**: JSON
- **文字コード**: UTF-8
- **タイムゾーン**: JST (Asia/Tokyo)

---

## 認証

### Cookie認証

管理画面APIは、Cookieベースのセッション認証を使用します。

**リクエストヘッダー例**:
```
Cookie: session_token=xxxxx
```

**認証方式**:
- 管理画面: `routeAccessControl` ミドルウェアによる admin セッション確認

---

## エンドポイント一覧

### 商品管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/products` | 商品一覧取得 | 必要 |
| GET | `/api/products/:id` | 商品詳細取得 | 必要 |
| POST | `/api/products` | 商品新規作成 | 必要 |
| PUT | `/api/products/:id` | 商品更新 | 必要 |
| DELETE | `/api/products/:id` | 商品削除（論理削除） | 必要 |
| POST | `/api/products/:id/copy` | 商品コピー | 必要 |

### 商品価格管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/products/:id/prices` | 商品価格一覧取得 | 必要 |
| POST | `/api/products/:id/prices` | 商品価格登録 | 必要 |
| DELETE | `/api/products/:productId/prices/:priceId` | 商品価格削除 | 必要 |

### 商品在庫管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/products/:id/stocks` | 商品在庫一覧取得 | 必要 |
| GET | `/api/stocks` | イベント在庫一覧取得(公開API) | 不要 |
| POST | `/api/stocks` | 在庫新規登録 | 必要 |
| PUT | `/api/stocks/:id` | 在庫更新 | 必要 |
| DELETE | `/api/stocks/:id` | 在庫削除 | 必要 |

### 商品共有在庫管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/products/:id/shared-stocks` | 商品共有在庫一覧取得 | 必要 |
| POST | `/api/products/:id/shared-stocks` | 商品共有在庫登録 | 必要 |
| POST | `/api/products/:id/shared-stocks/batch` | 商品共有在庫一括登録 | 必要 |
| DELETE | `/api/products/:productId/shared-stocks/:id` | 商品共有在庫削除 | 必要 |

### 共有在庫プール管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/shared-stock-pools/summary` | 共有在庫プール一覧取得（サマリー） | 必要 |
| GET | `/api/shared-stock-pools/by-name` | 共有在庫プール検索（名前・コード） | 必要 |
| GET | `/api/shared-stock-pools/:id` | 共有在庫プール詳細取得 | 必要 |
| POST | `/api/shared-stock-pools` | 共有在庫プール新規作成 | 必要 |
| PUT | `/api/shared-stock-pools/:id` | 共有在庫プール更新 | 必要 |
| DELETE | `/api/shared-stock-pools/:id` | 共有在庫プール削除 | 必要 |

### 商品フォーム設定管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/products/:id/form-fields` | 商品フォーム設定取得 | 必要 |
| PUT | `/api/products/:id/form-fields` | 商品フォーム設定更新 | 必要 |

### 画像管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| POST | `/api/products/upload-image` | 商品画像アップロード | 必要 |
| GET | `/api/products/images/*` | 商品画像取得 | 不要 |

---

## API詳細

### 1. 商品一覧取得

**エンドポイント**: `GET /api/products`  
**説明**: 商品の一覧を検索・フィルタリングして取得

#### リクエストパラメータ

| パラメータ | 型 | 必須 | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `event_id` | integer | 任意 | - | イベントID（指定時はフロントエンド向け、未指定時は管理画面向け） |
| `per_page` | integer | 任意 | 1000 | 1ページあたりの件数 |
| `name` | string | 任意 | - | 商品名（部分一致） |
| `enable_flg` | integer | 任意 | - | 有効フラグ（0: 無効, 1: 有効） |

#### レスポンス例（管理画面向け - event_id未指定）

```json
{
  "products": [
    {
      "id": 1,
      "name": "一般チケット",
      "description": "通常入場チケット",
      "enable_flg": 1,
      "sales_start": "2024-07-01",
      "sales_end": "2024-08-31",
      "event_name": "東京サマーフェスティバル2024",
      "category_name": "入場券"
    }
  ]
}
```

#### レスポンス例（フロントエンド向け - event_id指定）

```json
{
  "products": [
    {
      "id": 1,
      "name": "一般チケット",
      "description": "通常入場チケット",
      "price": 5000,
      "price_name": "大人"
    }
  ]
}
```

---

### 2. 商品詳細取得

**エンドポイント**: `GET /api/products/:id`  
**説明**: 指定IDの商品詳細情報を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### レスポンス例

```json
{
  "id": 1,
  "client_id": 1,
  "event_id": 1,
  "product_category_id": 1,
  "name": "一般チケット",
  "sales_start": "2024-07-01",
  "sales_end": "2024-08-31",
  "closing_trade": 0,
  "description": "通常入場チケット",
  "remarks": "当日券あり",
  "note": "特記事項なし",
  "fee_include": "入場料、パンフレット",
  "fee_exclude": "飲食代、駐車場代",
  "cancel_policy": "開催日の7日前まで無料キャンセル可能",
  "purchase_limit": 10,
  "deposit_address": "振込先情報",
  "enable_flg": 1,
  "common_names": [
    {
      "label": "名称1",
      "name": "大人",
      "description": "12歳以上"
    },
    {
      "label": "名称2",
      "name": "子供",
      "description": "6歳～11歳"
    }
  ],
  "cancellation_policy_details": [
    {
      "days": 7,
      "rate": 0
    },
    {
      "days": 3,
      "rate": 50
    },
    {
      "days": 0,
      "rate": 100
    }
  ],
  "price_unit": "人",
  "charge_type": "per_person",
  "charge_description": "1人あたりの料金",
  "image_url": "/api/products/images/product_1.jpg",
  "form_field_settings": {
    "name_kanji": true,
    "name_kana": true,
    "name_roma": false,
    "address": true,
    "tel": true,
    "birth_date": false,
    "age": false
  },
  "created_at": "2024-01-01T00:00:00Z",
  "modified_at": "2024-01-15T10:30:00Z",
  "deleted_at": null
}
```

---

### 3. 商品新規作成

**エンドポイント**: `POST /api/products`  
**説明**: 新しい商品を登録

#### リクエストボディ

**必須フィールド**:
- `name` (string): 商品名
- `event_id` (integer): イベントID
- `sales_start` (string): 販売開始日（YYYY-MM-DD）
- `sales_end` (string): 販売終了日（YYYY-MM-DD）
- `prices` (array): 価格帯データ（最低1件必要）

**任意フィールド**:
- `product_category_id` (integer): 商品カテゴリID
- `closing_trade` (integer): クロージング取引（0: なし, 1: あり）
- `description` (string): 商品説明
- `remarks` (string): 備考
- `note` (string): 特記事項
- `fee_include` (string): 料金に含まれるもの
- `fee_exclude` (string): 料金に含まれないもの
- `cancel_policy` (string): キャンセルポリシー
- `purchase_limit` (integer): 購入上限
- `deposit_address` (string): 振込先情報
- `enable_flg` (integer): 有効フラグ（0: 無効, 1: 有効）
- `common_names` (array): 共通名称設定
- `cancellation_policy_details` (array): キャンセル料金詳細
- `price_unit` (string): 価格単位（デフォルト: "人"）
- `charge_type` (string): 料金タイプ（デフォルト: "per_person"）
- `charge_description` (string): 料金説明
- `image_url` (string): 画像URL
- `form_field_settings` (object): フォーム項目設定

#### リクエスト例

```json
{
  "name": "一般チケット",
  "event_id": 1,
  "product_category_id": 1,
  "sales_start": "2024-07-01",
  "sales_end": "2024-08-31",
  "closing_trade": 0,
  "description": "通常入場チケット",
  "remarks": "当日券あり",
  "note": "特記事項なし",
  "fee_include": "入場料、パンフレット",
  "fee_exclude": "飲食代、駐車場代",
  "cancel_policy": "開催日の7日前まで無料キャンセル可能",
  "purchase_limit": 10,
  "enable_flg": 1,
  "common_names": [
    {
      "label": "名称1",
      "name": "大人",
      "description": "12歳以上"
    },
    {
      "label": "名称2",
      "name": "子供",
      "description": "6歳～11歳"
    }
  ],
  "cancellation_policy_details": [
    {
      "days": 7,
      "rate": 0
    },
    {
      "days": 3,
      "rate": 50
    }
  ],
  "prices": [
    {
      "price_band": "A",
      "category_name": "A-大人",
      "price_name": "大人",
      "price": 5000,
      "slot_number": 1,
      "display_order": 0
    },
    {
      "price_band": "A",
      "category_name": "A-子供",
      "price_name": "子供",
      "price": 3000,
      "slot_number": 1,
      "display_order": 1
    }
  ],
  "price_unit": "人",
  "charge_type": "per_person",
  "charge_description": "1人あたりの料金",
  "form_field_settings": {
    "name_kanji": true,
    "name_kana": true,
    "name_roma": false,
    "address": true,
    "tel": true,
    "birth_date": false,
    "age": false
  }
}
```

#### レスポンス例

```json
{
  "success": true,
  "id": 1,
  "message": "商品を登録しました"
}
```

---

### 4. 商品更新

**エンドポイント**: `PUT /api/products/:id`  
**説明**: 指定IDの商品情報を更新

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### リクエストボディ

商品新規作成と同じフィールドを指定可能

#### レスポンス例

```json
{
  "success": true,
  "message": "商品を更新しました"
}
```

---

### 5. 商品削除

**エンドポイント**: `DELETE /api/products/:id`  
**説明**: 指定IDの商品を論理削除

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### レスポンス例

```json
{
  "success": true,
  "message": "商品を削除しました"
}
```

---

### 6. 商品コピー

**エンドポイント**: `POST /api/products/:id/copy`  
**説明**: 指定IDの商品を複製

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | コピー元商品ID |

#### レスポンス例

```json
{
  "success": true,
  "newProductId": 10,
  "message": "商品をコピーしました"
}
```

---

### 7. 商品価格一覧取得

**エンドポイント**: `GET /api/products/:id/prices`  
**説明**: 指定商品の価格設定一覧を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### レスポンス例

```json
{
  "prices": [
    {
      "id": 1,
      "product_id": 1,
      "price": 5000,
      "price_band": "A",
      "category_name": "A-大人",
      "price_name": "大人",
      "slot_number": 1,
      "display_order": 0,
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

### 9. 商品価格登録

**エンドポイント**: `POST /api/products/:id/prices`  
**説明**: 指定商品に価格設定を追加

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### リクエストボディ

```json
{
  "prices": [
    {
      "price_band": "A",
      "category_name": "A-大人",
      "price_name": "大人",
      "price": 5000,
      "slot_number": 1,
      "display_order": 0
    }
  ]
}
```

#### レスポンス例

```json
{
  "success": true,
  "message": "価格を登録しました"
}
```

---

### 10. 商品価格削除

**エンドポイント**: `DELETE /api/products/:productId/prices/:priceId`  
**説明**: 指定商品の価格設定を削除

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `productId` | integer | ✓ | 商品ID |
| `priceId` | integer | ✓ | 価格ID |

#### レスポンス例

```json
{
  "success": true,
  "message": "価格を削除しました"
}
```

---

### 11. 商品在庫一覧取得

**エンドポイント**: `GET /api/products/:id/stocks`  
**説明**: 指定商品の在庫一覧を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### レスポンス例

```json
{
  "stocks": [
    {
      "id": 1,
      "product_id": 1,
      "date": "2024-08-01",
      "stock": 100,
      "booked": 25,
      "time_slot_start": "10:00",
      "time_slot_end": "12:00",
      "time_slot_label": "午前の部",
      "stock_name": "一般",
      "price_band": "A",
      "shared_pool_id": null,
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

---

### 12. イベント在庫一覧取得（公開API）

**エンドポイント**: `GET /api/stocks`  
**説明**: 指定イベントの在庫状況を取得（フロントエンド向け公開API）

#### リクエストパラメータ

| パラメータ | 型 | 必須 | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `event_id` | integer | ✓ | - | イベントID |
| `days` | integer | 任意 | 30 | 取得日数（本日から何日分） |

#### レスポンス例

```json
{
  "stocks": [
    {
      "id": 1,
      "product_id": 1,
      "product_name": "一般チケット",
      "date": "2024-08-01",
      "stock_name": "一般",
      "price_band": "A",
      "stock": 100,
      "booked": 25,
      "available": 75
    }
  ]
}
```

---

### 13. 在庫新規登録

**エンドポイント**: `POST /api/stocks`  
**説明**: 新しい在庫を登録

#### リクエストボディ

**必須フィールド**:
- `product_id` (integer): 商品ID
- `date` (string): 日付（YYYY-MM-DD）
- `stock` (integer): 在庫数
- `stock_name` (string): 在庫名
- `price_band` (string): 価格帯

**任意フィールド**:
- `time_slot_start` (string): タイムスロット開始時刻
- `time_slot_end` (string): タイムスロット終了時刻
- `time_slot_label` (string): タイムスロットラベル
- `shared_pool_id` (integer): 共有在庫プールID

#### リクエスト例

```json
{
  "product_id": 1,
  "date": "2024-08-01",
  "stock": 100,
  "stock_name": "一般",
  "price_band": "A",
  "time_slot_start": "10:00",
  "time_slot_end": "12:00",
  "time_slot_label": "午前の部"
}
```

#### レスポンス例

```json
{
  "success": true,
  "id": 1,
  "message": "在庫を登録しました"
}
```

---

### 14. 在庫更新

**エンドポイント**: `PUT /api/stocks/:id`  
**説明**: 指定IDの在庫を更新

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 在庫ID |

#### リクエストボディ

在庫新規登録と同じフィールドを指定可能

#### レスポンス例

```json
{
  "success": true,
  "message": "在庫を更新しました"
}
```

---

### 15. 在庫削除

**エンドポイント**: `DELETE /api/stocks/:id`  
**説明**: 指定IDの在庫を削除

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 在庫ID |

#### レスポンス例

```json
{
  "success": true,
  "message": "在庫を削除しました"
}
```

---

### 16. 商品共有在庫一覧取得

**エンドポイント**: `GET /api/products/:id/shared-stocks`  
**説明**: 指定商品の共有在庫リンク一覧を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### レスポンス例

```json
{
  "shared_stocks": [
    {
      "link_id": 1,
      "product_id": 1,
      "pool_id": 1,
      "pool_name": "共有在庫プールA",
      "pool_code": "POOL-A",
      "date": "2024-08-01",
      "time_slot_label": "午前の部",
      "total_stock": 200,
      "booked": 50,
      "available_stock": 150
    }
  ]
}
```

---

### 17. 商品共有在庫登録

**エンドポイント**: `POST /api/products/:id/shared-stocks`  
**説明**: 指定商品に共有在庫をリンク

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### リクエストボディ

```json
{
  "pool_id": 1
}
```

#### レスポンス例

```json
{
  "success": true,
  "message": "共有在庫をリンクしました"
}
```

---

### 18. 商品共有在庫一括登録

**エンドポイント**: `POST /api/products/:id/shared-stocks/batch`  
**説明**: 指定商品に複数の共有在庫を一括でリンク

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### リクエストボディ

```json
{
  "pool_ids": [1, 2, 3]
}
```

#### レスポンス例

```json
{
  "success": true,
  "message": "共有在庫を一括登録しました",
  "linked_count": 3
}
```

---

### 19. 商品共有在庫削除

**エンドポイント**: `DELETE /api/products/:productId/shared-stocks/:id`  
**説明**: 指定商品の共有在庫リンクを削除

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `productId` | integer | ✓ | 商品ID |
| `id` | integer | ✓ | リンクID |

#### レスポンス例

```json
{
  "success": true,
  "message": "共有在庫を削除しました"
}
```

---

### 20. 共有在庫プール一覧取得（サマリー）

**エンドポイント**: `GET /api/shared-stock-pools/summary`  
**説明**: 共有在庫プールのサマリー情報を取得

#### レスポンス例

```json
{
  "pools": [
    {
      "id": 1,
      "pool_name": "共有在庫プールA",
      "pool_code": "POOL-A",
      "date": "2024-08-01",
      "time_slot_label": "午前の部",
      "total_stock": 200,
      "booked": 50,
      "available_stock": 150,
      "enable_flg": 1
    }
  ]
}
```

---

### 21. 共有在庫プール検索（名前・コード）

**エンドポイント**: `GET /api/shared-stock-pools/by-name`  
**説明**: プール名またはプールコードで検索

#### リクエストパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `pool_name` | string | 任意 | プール名（部分一致） |
| `pool_code` | string | 任意 | プールコード（完全一致） |

#### レスポンス例

```json
{
  "pools": [
    {
      "id": 1,
      "pool_name": "共有在庫プールA",
      "pool_code": "POOL-A",
      "description": "プール説明",
      "date": "2024-08-01",
      "time_slot_start": "10:00",
      "time_slot_end": "12:00",
      "time_slot_label": "午前の部",
      "total_stock": 200,
      "booked": 50,
      "available_stock": 150,
      "enable_flg": 1
    }
  ]
}
```

---

### 22. 共有在庫プール詳細取得

**エンドポイント**: `GET /api/shared-stock-pools/:id`  
**説明**: 指定IDの共有在庫プール詳細を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | プールID |

#### レスポンス例

```json
{
  "id": 1,
  "pool_name": "共有在庫プールA",
  "pool_code": "POOL-A",
  "description": "プール説明",
  "date": "2024-08-01",
  "time_slot_start": "10:00",
  "time_slot_end": "12:00",
  "time_slot_label": "午前の部",
  "total_stock": 200,
  "booked": 50,
  "available_stock": 150,
  "enable_flg": 1,
  "created_at": "2024-01-01T00:00:00Z",
  "modified_at": "2024-01-15T10:30:00Z"
}
```

---

### 23. 共有在庫プール新規作成

**エンドポイント**: `POST /api/shared-stock-pools`  
**説明**: 新しい共有在庫プールを作成

#### リクエストボディ

**必須フィールド**:
- `pool_name` (string): プール名
- `date` (string): 日付（YYYY-MM-DD）
- `total_stock` (integer): 総在庫数

**任意フィールド**:
- `pool_code` (string): プールコード
- `description` (string): 説明
- `time_slot_start` (string): タイムスロット開始時刻
- `time_slot_end` (string): タイムスロット終了時刻
- `time_slot_label` (string): タイムスロットラベル
- `enable_flg` (integer): 有効フラグ（0: 無効, 1: 有効）

#### リクエスト例

```json
{
  "pool_name": "共有在庫プールA",
  "pool_code": "POOL-A",
  "description": "プール説明",
  "date": "2024-08-01",
  "time_slot_start": "10:00",
  "time_slot_end": "12:00",
  "time_slot_label": "午前の部",
  "total_stock": 200,
  "enable_flg": 1
}
```

#### レスポンス例

```json
{
  "success": true,
  "id": 1,
  "message": "共有在庫プールを作成しました"
}
```

---

### 24. 共有在庫プール更新

**エンドポイント**: `PUT /api/shared-stock-pools/:id`  
**説明**: 指定IDの共有在庫プールを更新

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | プールID |

#### リクエストボディ

共有在庫プール新規作成と同じフィールドを指定可能

#### レスポンス例

```json
{
  "success": true,
  "message": "共有在庫プールを更新しました"
}
```

---

### 25. 共有在庫プール削除

**エンドポイント**: `DELETE /api/shared-stock-pools/:id`  
**説明**: 指定IDの共有在庫プールを削除

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | プールID |

#### レスポンス例

```json
{
  "success": true,
  "message": "共有在庫プールを削除しました"
}
```

---

### 26. 商品フォーム設定取得

**エンドポイント**: `GET /api/products/:id/form-fields`  
**説明**: 指定商品のカスタムフォーム項目設定を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### レスポンス例

```json
{
  "fields": [
    {
      "id": 1,
      "product_id": 1,
      "field_type": "text",
      "field_name": "full_name",
      "field_label": "お名前",
      "field_options": null,
      "is_required": 1,
      "description": "フルネームをご入力ください",
      "display_order": 0,
      "placeholder": "例：山田太郎",
      "parent_field_id": null,
      "parent_condition": null,
      "indent_level": 0,
      "category": 1,
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-15T10:30:00Z"
    },
    {
      "id": 2,
      "product_id": 1,
      "field_type": "radio",
      "field_name": "category",
      "field_label": "区分",
      "field_options": "[\"商品\",\"参加者毎\"]",
      "is_required": 1,
      "description": "このフォームを表示する場所を選択してください",
      "display_order": 1,
      "placeholder": null,
      "parent_field_id": null,
      "parent_condition": null,
      "indent_level": 0,
      "category": 1,
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-15T10:30:00Z"
    },
    {
      "id": 3,
      "product_id": 1,
      "field_type": "select",
      "field_name": "age_group",
      "field_label": "年齢区分",
      "field_options": "[\"大人\",\"子供\",\"シニア\"]",
      "is_required": 1,
      "description": null,
      "display_order": 2,
      "placeholder": "選択してください",
      "parent_field_id": null,
      "parent_condition": null,
      "indent_level": 0,
      "category": 2,
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

#### フィールドタイプ

| タイプ | 説明 | field_options |
|-------|------|---------------|
| `text` | テキスト入力 | 不要 |
| `textarea` | テキストエリア | 不要 |
| `select` | プルダウン | 必要（JSON配列） |
| `radio` | ラジオボタン | 必要（JSON配列） |
| `checkbox` | チェックボックス | 必要（JSON配列） |
| `date` | カレンダー | 不要 |
| `file` | ファイルアップロード | 不要 |

#### 区分（category）

| 値 | 説明 |
|----|------|
| `1` | 商品：商品単位で表示されるフィールド |
| `2` | 参加者毎：参加者ごとに表示されるフィールド |

---

### 27. 商品フォーム設定更新

**エンドポイント**: `PUT /api/products/:id/form-fields`  
**説明**: 指定商品のカスタムフォーム項目設定を一括更新

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | 商品ID |

#### リクエストボディ

**必須フィールド**:
- `fields` (array): フォーム項目の配列

**各フィールドの構造**:
- `id` (integer/string): フィールドID（新規の場合は "new_xxx" 形式）
- `field_type` (string): フィールドタイプ（text/textarea/select/radio/checkbox/date/file）
- `field_name` (string): フィールド名（英数字とアンダースコア）
- `field_label` (string): フィールドラベル（画面表示名）
- `field_options` (string): 選択肢（JSON配列文字列、select/radio/checkboxの場合）
- `is_required` (integer): 必須フラグ（0: 任意, 1: 必須）
- `description` (string): 説明文
- `placeholder` (string): プレースホルダー
- `parent_field_id` (integer): 親フィールドID（条件表示の場合）
- `parent_condition` (string): 親フィールドの条件値
- `indent_level` (integer): インデントレベル（0-3）
- `category` (integer): 区分（1: 商品, 2: 参加者毎）

#### リクエスト例

```json
{
  "fields": [
    {
      "id": "new_1",
      "field_type": "text",
      "field_name": "full_name",
      "field_label": "お名前",
      "field_options": null,
      "is_required": 1,
      "description": "フルネームをご入力ください",
      "placeholder": "例：山田太郎",
      "parent_field_id": null,
      "parent_condition": null,
      "indent_level": 0,
      "category": 1
    },
    {
      "id": "new_2",
      "field_type": "radio",
      "field_name": "category",
      "field_label": "区分",
      "field_options": "[\"商品\",\"参加者毎\"]",
      "is_required": 1,
      "description": "このフォームを表示する場所を選択してください",
      "placeholder": null,
      "parent_field_id": null,
      "parent_condition": null,
      "indent_level": 0,
      "category": 1
    },
    {
      "id": 3,
      "field_type": "select",
      "field_name": "age_group",
      "field_label": "年齢区分",
      "field_options": "[\"大人\",\"子供\",\"シニア\"]",
      "is_required": 1,
      "description": null,
      "placeholder": "選択してください",
      "parent_field_id": null,
      "parent_condition": null,
      "indent_level": 0,
      "category": 2
    }
  ]
}
```

#### レスポンス例

```json
{
  "success": true,
  "message": "フォーム項目を更新しました"
}
```

#### 仕様詳細

**display_order（表示順）**:
- 配列のインデックス順に自動設定されます（0から開始）
- リクエスト内の配列順序がそのまま表示順になります

**parent_field_id（親フィールドID）**:
- 条件付き表示を実現する機能
- 親フィールドの値が `parent_condition` と一致した場合のみ表示
- 例：「その他」を選択した場合のみ「その他詳細」フィールドを表示

**category（区分）**:
- `1` (商品): 商品全体に対して1回だけ表示されるフィールド（例：お名前、連絡先）
- `2` (参加者毎): 参加者ごとに繰り返し表示されるフィールド（例：参加者氏名、年齢）

**field_options（選択肢）**:
- JSON配列形式の文字列（例: `"[\"選択肢1\",\"選択肢2\"]"`）
- select/radio/checkbox タイプで必須
- text/textarea/date/file タイプでは不要

**既存フィールドの削除**:
- リクエストに含まれていない既存フィールドは削除されます
- 削除したくないフィールドは必ずリクエストに含めてください

---

### 28. 商品画像アップロード

**エンドポイント**: `POST /api/products/upload-image`  
**説明**: 商品用の画像をCloudflare R2にアップロード

#### リクエスト

**Content-Type**: `multipart/form-data`

**フィールド**:
- `image` (file): 画像ファイル（JPEG, PNG, GIF, WebP）
- 最大サイズ: 5MB

#### レスポンス例

```json
{
  "success": true,
  "url": "/api/products/images/product_1234567890.jpg"
}
```

---

## データモデル

### Product（商品）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 商品ID（主キー） |
| `client_id` | INTEGER | NO | - | クライアントID |
| `event_id` | INTEGER | NO | - | イベントID |
| `name` | TEXT | NO | - | 商品名 |
| `sales_start` | TEXT | NO | - | 販売開始日 |
| `sales_end` | TEXT | NO | - | 販売終了日 |
| `closing_trade` | INTEGER | NO | 0 | クロージング取引 |
| `product_category_id` | INTEGER | YES | NULL | 商品カテゴリID |
| `description` | TEXT | YES | NULL | 商品説明 |
| `remarks` | TEXT | YES | NULL | 備考 |
| `fee_include` | TEXT | YES | NULL | 料金に含まれるもの |
| `fee_exclude` | TEXT | YES | NULL | 料金に含まれないもの |
| `cancel_policy` | TEXT | YES | NULL | キャンセルポリシー |
| `purchase_limit` | INTEGER | YES | NULL | 購入上限 |
| `deposit_address` | TEXT | YES | NULL | 振込先情報 |
| `note` | TEXT | YES | NULL | 特記事項 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |
| `slot_type` | INTEGER | YES | 0 | スロットタイプ |
| `deleted_at` | TEXT | YES | NULL | 削除日時 |
| `cancellation_days_1` | INTEGER | YES | NULL | キャンセル期間1（日数） |
| `cancellation_rate_1` | INTEGER | YES | NULL | キャンセル料率1（%） |
| `cancellation_days_2` | INTEGER | YES | NULL | キャンセル期間2（日数） |
| `cancellation_rate_2` | INTEGER | YES | NULL | キャンセル料率2（%） |
| `cancellation_days_3` | INTEGER | YES | NULL | キャンセル期間3（日数） |
| `cancellation_rate_3` | INTEGER | YES | NULL | キャンセル料率3（%） |
| `cancellation_days_4` | INTEGER | YES | NULL | キャンセル期間4（日数） |
| `cancellation_rate_4` | INTEGER | YES | NULL | キャンセル料率4（%） |
| `cancellation_days_5` | INTEGER | YES | NULL | キャンセル期間5（日数） |
| `cancellation_rate_5` | INTEGER | YES | NULL | キャンセル料率5（%） |
| `common_names` | TEXT | YES | NULL | 共通名称設定（JSON） |
| `cancellation_policy_details` | TEXT | YES | NULL | キャンセル料金詳細（JSON） |
| `price_unit` | TEXT | YES | '人' | 価格単位 |
| `charge_type` | TEXT | YES | 'per_person' | 料金タイプ |
| `charge_description` | TEXT | YES | NULL | 料金説明 |
| `image_url` | TEXT | YES | NULL | 画像URL |
| `form_field_settings` | TEXT | YES | '{"name_kanji":true,...}' | フォーム項目設定（JSON） |

### ProductPrice（商品価格）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 価格ID（主キー） |
| `product_id` | INTEGER | NO | - | 商品ID |
| `price` | INTEGER | NO | - | 価格 |
| `category_name` | TEXT | YES | NULL | カテゴリ名 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |
| `price_band` | TEXT | YES | NULL | 価格帯 |
| `price_name` | TEXT | YES | NULL | 価格名称 |
| `display_order` | INTEGER | YES | 0 | 表示順 |
| `slot_number` | INTEGER | YES | 1 | スロット番号 |

### ProductStock（商品在庫）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 在庫ID（主キー） |
| `product_id` | INTEGER | NO | - | 商品ID |
| `date` | TEXT | NO | - | 日付 |
| `stock` | INTEGER | NO | 0 | 在庫数 |
| `booked` | INTEGER | NO | 0 | 予約済み数 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |
| `time_slot_start` | TEXT | YES | NULL | タイムスロット開始時刻 |
| `time_slot_end` | TEXT | YES | NULL | タイムスロット終了時刻 |
| `time_slot_label` | TEXT | YES | NULL | タイムスロットラベル |
| `stock_name` | TEXT | YES | NULL | 在庫名 |
| `shared_pool_id` | INTEGER | YES | NULL | 共有在庫プールID |
| `price_band` | TEXT | YES | NULL | 価格帯 |

### ProductFormFields（商品フォーム項目）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | フォーム項目ID（主キー） |
| `product_id` | INTEGER | NO | - | 商品ID |
| `field_type` | TEXT | NO | - | フィールドタイプ（text/textarea/select/radio/checkbox/date/file） |
| `field_name` | TEXT | NO | - | フィールド名 |
| `field_label` | TEXT | NO | - | フィールドラベル |
| `field_options` | TEXT | YES | NULL | フィールドオプション（JSON） |
| `is_required` | INTEGER | YES | 0 | 必須フラグ |
| `description` | TEXT | YES | NULL | 説明 |
| `display_order` | INTEGER | YES | 0 | 表示順 |
| `placeholder` | TEXT | YES | NULL | プレースホルダー |
| `parent_field_id` | INTEGER | YES | NULL | 親フィールドID |
| `parent_condition` | TEXT | YES | NULL | 親条件 |
| `indent_level` | INTEGER | YES | 0 | インデントレベル |
| `category` | INTEGER | YES | 1 | 区分（1: 商品, 2: 参加者毎） |
| `validation_rule` | TEXT | YES | NULL | バリデーションルール |
| `default_value` | TEXT | YES | NULL | デフォルト値 |
| `help_text` | TEXT | YES | NULL | ヘルプテキスト |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

### SharedStockPool（共有在庫プール）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | プールID（主キー） |
| `pool_name` | TEXT | NO | - | プール名 |
| `pool_code` | TEXT | YES | NULL | プールコード |
| `description` | TEXT | YES | NULL | 説明 |
| `date` | TEXT | NO | - | 日付 |
| `time_slot_start` | TEXT | YES | NULL | タイムスロット開始時刻 |
| `time_slot_end` | TEXT | YES | NULL | タイムスロット終了時刻 |
| `time_slot_label` | TEXT | YES | NULL | タイムスロットラベル |
| `total_stock` | INTEGER | YES | 0 | 総在庫数 |
| `booked` | INTEGER | YES | 0 | 予約済み数 |
| `available_stock` | INTEGER | VIRTUAL | total_stock - booked | 利用可能在庫数（仮想カラム） |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

---

## エラーレスポンス

### 400 Bad Request

必須フィールドが不足している場合、またはバリデーションエラー

```json
{
  "error": "必須フィールドが入力されていません"
}
```

### 404 Not Found

指定されたリソースが見つからない場合

```json
{
  "error": "商品が見つかりません"
}
```

### 500 Internal Server Error

サーバー内部エラー

```json
{
  "error": "商品情報の取得に失敗しました"
}
```

---

## 関連ドキュメント

- [DATABASE_SCHEMA_PRODUCTS.md](./DATABASE_SCHEMA_PRODUCTS.md) - 商品管理データベーススキーマ
- [API_SPEC_EVENT_MANAGEMENT.md](./API_SPEC_EVENT_MANAGEMENT.md) - イベント管理API仕様書
- [database_schema_complete.sql](./database_schema_complete.sql) - 完全なデータベーススキーマ

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|---------||
| 1.2 | 2026-02-05 | フォーム設定管理エンドポイントを追加（2件追加、合計28エンドポイント）、category（区分）フィールドを追加 |
| 1.1 | 2026-02-05 | 在庫管理・共有在庫プール管理エンドポイントを追加 |
| 1.0 | 2026-02-05 | 初版作成 |

---

## 問い合わせ

API仕様に関するお問い合わせは、開発チームまでご連絡ください。
