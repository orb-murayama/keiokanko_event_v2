# オプション管理API仕様書

**バージョン**: 1.0  
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

オプション管理APIは、イベントに紐づくオプション商品（お弁当・駐車場・シャトルバス等）の作成、取得、更新、削除を行うためのAPIです。オプションには価格設定、在庫管理、共有在庫プール機能が含まれます。

**主要機能**:
- オプションの CRUD 操作
- 価格設定・在庫管理
- 共有在庫プール機能
- 日付別在庫取得
- 画像アップロード

**エンドポイント総数**: 19件

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

### オプション管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/option-categories` | オプションカテゴリ一覧取得 | 必要 |
| GET | `/api/options` | オプション一覧取得 | 必要 |
| GET | `/api/options/:id` | オプション詳細取得 | 必要 |
| POST | `/api/options` | オプション新規作成 | 必要 |
| PUT | `/api/options/:id` | オプション更新 | 必要 |
| DELETE | `/api/options/:id` | オプション削除（論理削除） | 必要 |
| POST | `/api/options/:id/copy` | オプションコピー | 必要 |

### オプション在庫管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/options/:id/stocks` | オプション在庫一覧取得 | 必要 |
| POST | `/api/options/:id/stocks` | オプション在庫新規登録 | 必要 |
| PUT | `/api/options/:id/stocks/:stockId` | オプション在庫更新 | 必要 |
| DELETE | `/api/options/:id/stocks/:stockId` | オプション在庫削除 | 必要 |

### イベント別オプション取得

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/events/:id/options` | イベントのオプション一覧取得 | 不要 |
| GET | `/api/events/:id/options-by-date` | イベントの日付別オプション在庫取得 | 不要 |

### オプション共有在庫管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/options/:id/shared-stocks` | オプション共有在庫一覧取得 | 必要 |
| POST | `/api/options/:id/shared-stocks` | オプション共有在庫登録 | 必要 |
| POST | `/api/options/:id/shared-stocks/batch` | オプション共有在庫一括登録 | 必要 |
| DELETE | `/api/options/:optionId/shared-stocks/:id` | オプション共有在庫削除 | 必要 |

### 画像管理

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| POST | `/api/options/upload-image` | オプション画像アップロード | 必要 |
| GET | `/api/options/images/*` | オプション画像取得 | 不要 |

---

## API詳細

### 1. オプションカテゴリ一覧取得

**エンドポイント**: `GET /api/option-categories`  
**説明**: オプションカテゴリのマスタ一覧を取得

#### レスポンス例

```json
{
  "categories": [
    {
      "id": 1,
      "name": "食事",
      "description": "お弁当・飲食オプション",
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-01T00:00:00Z"
    },
    {
      "id": 2,
      "name": "交通",
      "description": "駐車場・シャトルバス",
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

### 2. オプション一覧取得

**エンドポイント**: `GET /api/options`  
**説明**: オプションの一覧を検索・フィルタリングして取得

#### リクエストパラメータ

| パラメータ | 型 | 必須 | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `event_id` | integer | 任意 | - | イベントID（指定時はフロントエンド向け） |
| `name` | string | 任意 | - | オプション名（部分一致） |
| `event_name` | string | 任意 | - | イベント名（部分一致） |
| `status` | integer | 任意 | - | 有効フラグ（0: 無効, 1: 有効） |
| `page` | integer | 任意 | 1 | ページ番号 |
| `per_page` | integer | 任意 | 20 | 1ページあたりの件数 |

#### レスポンス例（フロントエンド向け - event_id指定）

```json
{
  "options": [
    {
      "id": 1,
      "name": "お弁当（和食）",
      "description": "季節の和食弁当",
      "image_url": "/api/options/images/option_1.jpg",
      "price": 1200
    },
    {
      "id": 2,
      "name": "駐車場",
      "description": "会場駐車場利用券",
      "image_url": "/api/options/images/option_2.jpg",
      "price": 500
    }
  ]
}
```

#### レスポンス例（管理画面向け - event_id未指定）

```json
{
  "options": [
    {
      "id": 1,
      "event_id": 1,
      "name": "お弁当（和食）",
      "description": "季節の和食弁当",
      "remarks": "アレルギー対応可",
      "option_category_id": 1,
      "cancel_policy": "前日まで無料キャンセル可",
      "note": "特記事項なし",
      "enable_flg": 1,
      "image_url": "/api/options/images/option_1.jpg",
      "event_name": "東京サマーフェスティバル2024",
      "category_name": "食事",
      "prices": "1200",
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-15T10:30:00Z",
      "deleted_at": null
    }
  ],
  "total": 15,
  "page": 1,
  "per_page": 20
}
```

---

### 3. オプション詳細取得

**エンドポイント**: `GET /api/options/:id`  
**説明**: 指定IDのオプション詳細情報を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |

#### レスポンス例

```json
{
  "id": 1,
  "event_id": 1,
  "name": "お弁当（和食）",
  "description": "季節の和食弁当",
  "remarks": "アレルギー対応可",
  "option_category_id": 1,
  "cancel_policy": "前日まで無料キャンセル可",
  "note": "特記事項なし",
  "enable_flg": 1,
  "image_url": "/api/options/images/option_1.jpg",
  "created_at": "2024-01-01T00:00:00Z",
  "modified_at": "2024-01-15T10:30:00Z",
  "deleted_at": null
}
```

---

### 4. オプション新規作成

**エンドポイント**: `POST /api/options`  
**説明**: 新しいオプションを登録

#### リクエストボディ

**必須フィールド**:
- `event_id` (integer): イベントID
- `name` (string): オプション名
- `option_category_id` (integer): オプションカテゴリID

**任意フィールド**:
- `description` (string): 説明
- `remarks` (string): 備考
- `cancel_policy` (string): キャンセルポリシー
- `note` (string): 特記事項
- `enable_flg` (integer): 有効フラグ（0: 無効, 1: 有効）
- `image_url` (string): 画像URL
- `prices` (array): 価格設定配列

#### リクエスト例

```json
{
  "event_id": 1,
  "name": "お弁当（和食）",
  "description": "季節の和食弁当",
  "remarks": "アレルギー対応可",
  "option_category_id": 1,
  "cancel_policy": "前日まで無料キャンセル可",
  "note": "特記事項なし",
  "enable_flg": 1,
  "image_url": "/api/options/images/option_1.jpg",
  "prices": [
    {
      "price": 1200,
      "category_name": "標準"
    }
  ]
}
```

#### レスポンス例

```json
{
  "success": true,
  "id": 1,
  "message": "オプションを登録しました"
}
```

---

### 5. オプション更新

**エンドポイント**: `PUT /api/options/:id`  
**説明**: 指定IDのオプション情報を更新

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |

#### リクエストボディ

オプション新規作成と同じフィールドを指定可能

#### レスポンス例

```json
{
  "success": true,
  "message": "オプションを更新しました"
}
```

---

### 6. オプション削除

**エンドポイント**: `DELETE /api/options/:id`  
**説明**: 指定IDのオプションを論理削除

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |

#### レスポンス例

```json
{
  "success": true,
  "message": "オプションを削除しました"
}
```

---

### 7. オプションコピー

**エンドポイント**: `POST /api/options/:id/copy`  
**説明**: 指定IDのオプションを複製

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | コピー元オプションID |

#### レスポンス例

```json
{
  "success": true,
  "newOptionId": 10,
  "message": "オプションをコピーしました"
}
```

---

### 8. オプション在庫一覧取得

**エンドポイント**: `GET /api/options/:id/stocks`  
**説明**: 指定オプションの在庫一覧を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |

#### レスポンス例

```json
{
  "stocks": [
    {
      "id": 1,
      "option_id": 1,
      "date": "2024-08-01",
      "stock": 100,
      "booked": 25,
      "stock_name": "お弁当（和食）",
      "price": 1200,
      "total_stock": 100,
      "available_stock": 75,
      "enable_flg": 1,
      "shared_pool_id": null,
      "created_at": "2024-01-01T00:00:00Z",
      "modified_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

---

### 9. オプション在庫新規登録

**エンドポイント**: `POST /api/options/:id/stocks`  
**説明**: 指定オプションに在庫を追加

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |

#### リクエストボディ

**必須フィールド**:
- `date` (string): 日付（YYYY-MM-DD）
- `stock` (integer): 在庫数

**任意フィールド**:
- `stock_name` (string): 在庫名
- `price` (integer): 価格
- `enable_flg` (integer): 有効フラグ（0: 無効, 1: 有効）
- `shared_pool_id` (integer): 共有在庫プールID

#### リクエスト例

```json
{
  "date": "2024-08-01",
  "stock": 100,
  "stock_name": "お弁当（和食）",
  "price": 1200,
  "enable_flg": 1
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

### 10. オプション在庫更新

**エンドポイント**: `PUT /api/options/:id/stocks/:stockId`  
**説明**: 指定IDのオプション在庫を更新

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |
| `stockId` | integer | ✓ | 在庫ID |

#### リクエストボディ

オプション在庫新規登録と同じフィールドを指定可能

#### レスポンス例

```json
{
  "success": true,
  "message": "在庫を更新しました"
}
```

---

### 11. オプション在庫削除

**エンドポイント**: `DELETE /api/options/:id/stocks/:stockId`  
**説明**: 指定IDのオプション在庫を削除

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |
| `stockId` | integer | ✓ | 在庫ID |

#### レスポンス例

```json
{
  "success": true,
  "message": "在庫を削除しました"
}
```

---

### 12. イベントのオプション一覧取得

**エンドポイント**: `GET /api/events/:id/options`  
**説明**: 指定イベントの有効なオプション一覧を取得（フロントエンド向け）

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | イベントID |

#### レスポンス例

```json
{
  "options": [
    {
      "id": 1,
      "name": "お弁当（和食）",
      "description": "季節の和食弁当",
      "price": 1200
    },
    {
      "id": 2,
      "name": "駐車場",
      "description": "会場駐車場利用券",
      "price": 500
    }
  ]
}
```

---

### 13. イベントの日付別オプション在庫取得

**エンドポイント**: `GET /api/events/:id/options-by-date`  
**説明**: 指定イベントの日付別オプション在庫情報を取得（フロントエンド向け）

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | イベントID |

#### リクエストパラメータ

| パラメータ | 型 | 必須 | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `start_date` | string | ✓ | - | 開始日（YYYY-MM-DD） |
| `end_date` | string | ✓ | - | 終了日（YYYY-MM-DD） |

#### レスポンス例

```json
{
  "options": [
    {
      "option_id": 1,
      "option_name": "お弁当（和食）",
      "option_description": "季節の和食弁当",
      "stocks": [
        {
          "date": "2024-08-01",
          "stock": 100,
          "booked": 25,
          "available": 75,
          "price": 1200
        },
        {
          "date": "2024-08-02",
          "stock": 100,
          "booked": 30,
          "available": 70,
          "price": 1200
        }
      ]
    }
  ]
}
```

---

### 14. オプション共有在庫一覧取得

**エンドポイント**: `GET /api/options/:id/shared-stocks`  
**説明**: 指定オプションの共有在庫リンク一覧を取得

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |

#### レスポンス例

```json
{
  "shared_stocks": [
    {
      "link_id": 1,
      "option_id": 1,
      "pool_id": 1,
      "pool_name": "共有在庫プールA",
      "total_stock": 200,
      "booked": 50,
      "available": 150
    }
  ]
}
```

---

### 15. オプション共有在庫登録

**エンドポイント**: `POST /api/options/:id/shared-stocks`  
**説明**: 指定オプションに共有在庫をリンク

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |

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

### 16. オプション共有在庫一括登録

**エンドポイント**: `POST /api/options/:id/shared-stocks/batch`  
**説明**: 指定オプションに複数の共有在庫を一括でリンク

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `id` | integer | ✓ | オプションID |

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

### 17. オプション共有在庫削除

**エンドポイント**: `DELETE /api/options/:optionId/shared-stocks/:id`  
**説明**: 指定オプションの共有在庫リンクを削除

#### パスパラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| `optionId` | integer | ✓ | オプションID |
| `id` | integer | ✓ | リンクID |

#### レスポンス例

```json
{
  "success": true,
  "message": "共有在庫を削除しました"
}
```

---

### 18. オプション画像アップロード

**エンドポイント**: `POST /api/options/upload-image`  
**説明**: オプション用の画像をCloudflare R2にアップロード

#### リクエスト

**Content-Type**: `multipart/form-data`

**フィールド**:
- `image` (file): 画像ファイル（JPEG, PNG, GIF, WebP）
- 最大サイズ: 5MB

#### レスポンス例

```json
{
  "success": true,
  "url": "/api/options/images/option_1234567890.jpg"
}
```

---

### 19. オプション画像取得

**エンドポイント**: `GET /api/options/images/*`  
**説明**: オプション画像を取得

#### パスパラメータ

画像ファイル名（例: `/api/options/images/option_1234567890.jpg`）

#### レスポンス

画像ファイル（Content-Type: image/jpeg, image/png等）

---

## データモデル

### Option（オプション）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | オプションID（主キー） |
| `event_id` | INTEGER | NO | - | イベントID |
| `name` | TEXT | NO | - | オプション名 |
| `description` | TEXT | YES | NULL | 説明 |
| `remarks` | TEXT | YES | NULL | 備考 |
| `option_category_id` | INTEGER | NO | - | オプションカテゴリID |
| `cancel_policy` | TEXT | YES | NULL | キャンセルポリシー |
| `note` | TEXT | YES | NULL | 特記事項 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `image_url` | TEXT | YES | NULL | 画像URL |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |
| `deleted_at` | TEXT | YES | NULL | 削除日時（論理削除） |

### OptionCategory（オプションカテゴリ）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | カテゴリID（主キー） |
| `name` | TEXT | NO | - | カテゴリ名 |
| `description` | TEXT | YES | NULL | 説明 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

### OptionPrice（オプション価格）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 価格ID（主キー） |
| `option_id` | INTEGER | NO | - | オプションID |
| `price` | INTEGER | NO | - | 価格（円） |
| `category_name` | TEXT | YES | NULL | カテゴリ名 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

### OptionStock（オプション在庫）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 在庫ID（主キー） |
| `option_id` | INTEGER | NO | - | オプションID |
| `date` | TEXT | YES | NULL | 日付（YYYY-MM-DD） |
| `stock` | INTEGER | NO | 0 | 在庫数 |
| `booked` | INTEGER | NO | 0 | 予約済み数 |
| `stock_name` | TEXT | YES | NULL | 在庫名 |
| `price` | INTEGER | YES | NULL | 価格 |
| `total_stock` | INTEGER | YES | 0 | 総在庫数 |
| `available_stock` | INTEGER | YES | 0 | 利用可能在庫数 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `shared_pool_id` | INTEGER | YES | NULL | 共有在庫プールID |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

### OptionBooking（オプション予約）

| フィールド | 型 | NULL | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 予約ID（主キー） |
| `customer_id` | INTEGER | NO | - | 顧客ID |
| `option_id` | INTEGER | NO | - | オプションID |
| `option_stock_id` | INTEGER | YES | NULL | オプション在庫ID |
| `price` | INTEGER | NO | - | 金額（円） |
| `quantity` | INTEGER | NO | 1 | 数量 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `canceled_at` | TEXT | YES | NULL | キャンセル日時 |
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
  "error": "オプションが見つかりません"
}
```

### 500 Internal Server Error

サーバー内部エラー

```json
{
  "error": "オプション情報の取得に失敗しました"
}
```

---

## 関連ドキュメント

- [DATABASE_SCHEMA_OPTIONS.md](./DATABASE_SCHEMA_OPTIONS.md) - オプション管理データベーススキーマ
- [API_SPEC_EVENT_MANAGEMENT.md](./API_SPEC_EVENT_MANAGEMENT.md) - イベント管理API仕様書
- [database_schema_complete.sql](./database_schema_complete.sql) - 完全なデータベーススキーマ

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|---------|
| 1.0 | 2026-02-05 | 初版作成 |

---

## 問い合わせ

API仕様に関するお問い合わせは、開発チームまでご連絡ください。
