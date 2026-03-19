# イベント管理 API仕様書

**バージョン**: 1.3  
**作成日**: 2026-01-28  
**最終更新**: 2026-02-05  
**対象システム**: イベント予約管理システム

---

## 目次

1. [概要](#概要)
2. [認証](#認証)
3. [エンドポイント一覧](#エンドポイント一覧)
4. [API詳細仕様](#api詳細仕様)
5. [エラーレスポンス](#エラーレスポンス)
6. [データモデル](#データモデル)

---

## 概要

### システム概要
イベント予約管理システムのイベント管理機能を提供するAPIです。イベントの作成、更新、削除、検索などの基本的なCRUD操作に加え、イベントに紐付く商品・オプション・フォームフィールド・子イベントの管理機能を提供します。

### 基本情報
- **ベースURL**: `https://your-domain.com/api`
- **プロトコル**: HTTPS
- **リクエスト形式**: JSON
- **レスポンス形式**: JSON
- **文字コード**: UTF-8
- **タイムゾーン**: Asia/Tokyo (JST)

---

## 認証

すべての管理APIは認証が必要です。

### 認証方式
- Cookie-based Session Authentication
- `routeAccessControl('admin')` ミドルウェアによる認証チェック

### 認証ヘッダー
```
Cookie: session_token=<your-session-token>
```

### 権限レベル
- **admin**: すべての管理機能にアクセス可能
- **user**: 参照のみ可能（一部API）

---

## エンドポイント一覧

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/events` | イベント一覧取得（統合版：認証オプショナル） | オプショナル |
| GET | `/api/events/categories` | イベントカテゴリ一覧取得 | 不要 |
| GET | `/api/events/:id` | イベント詳細取得 | 不要 |
| POST | `/api/events` | イベント新規作成 | 必要 |
| PUT | `/api/events/:id` | イベント更新 | 必要 |
| DELETE | `/api/events/:id` | イベント削除（論理削除） | 必要 |
| POST | `/api/events/:id/copy` | イベントコピー | 必要 |
| GET | `/api/events/:id/products` | イベントの商品一覧取得 | 不要 |
| GET | `/api/events/:id/options` | イベントのオプション一覧取得 | 不要 |
| GET | `/api/events/:id/available-dates` | イベントの利用可能日取得 | 不要 |
| GET | `/api/events/:id/products-by-date` | 日付別商品一覧取得 | 不要 |
| POST | `/api/events/upload-image` | イベント画像アップロード | 必要 |
| GET | `/api/events/images/*` | イベント画像取得 | 不要 |

### 非推奨エンドポイント（リダイレクト）
以下のエンドポイントは非推奨です。新しいエンドポイントを使用してください。

| 旧エンドポイント | 新エンドポイント | 状態 |
|----------------|-----------------|------|
| `GET /api/v1/events` | `GET /api/events` | リダイレクト |
| `GET /api/v1/events/categories` | `GET /api/events/categories` | リダイレクト |
| `POST /api/v1/events/:id/copy` | `POST /api/events/:id/copy` | リダイレクト |

---

## API詳細仕様

### 1. イベント一覧取得（統合版 - 認証オプショナル）

**エンドポイント**: `GET /api/events`

**説明**: イベント一覧を取得します。認証状態により返却される項目が異なります。

**認証**: オプショナル（Cookie-based Session）
- **認証なし**: 公開項目のみ返却（フロントエンド用）
- **認証あり（admin）**: 管理画面用項目も含めて返却

**リクエストパラメータ**:
| パラメータ | 型 | 必須 | 説明 | 認証 |
|-----------|------|------|------|------|
| page | integer | × | ページ番号（デフォルト: 1） | - |
| per_page | integer | × | 1ページあたりの件数（デフォルト: 50） | - |
| name | string | × | イベント名での部分一致検索 | - |
| category | string | × | カテゴリでのフィルタ | - |
| event_type | string | × | イベントタイプ（standalone/parent/child） | - |
| sort | string | × | ソート列（id/name/event_start_date/created_at） | - |
| order | string | × | ソート順（asc/desc、デフォルト: desc） | - |
| branch_code | string | × | 支店コードでのフィルタ | 必要 |
| client_id | integer | × | クライアントIDでのフィルタ | 必要 |
| vendor_id | integer | × | ベンダーIDでのフィルタ | 必要 |
| event_start_date_from | string | × | 開催開始日の範囲検索（開始） | 必要 |
| event_start_date_to | string | × | 開催開始日の範囲検索（終了） | 必要 |
| enable_flg | integer | × | 有効フラグ（0 or 1） | 必要 |
| include_deleted | integer | × | 削除済みを含む（0 or 1） | 必要 |

**レスポンス例（認証なし）**:
```json
{
  "data": [
    {
      "id": 1,
      "name": "東京サマーフェスティバル2024",
      "detail": "夏の一大イベント",
      "location": "東京ドーム",
      "event_start_date": "2024-08-01",
      "event_end_date": "2024-08-03",
      "registration_start_date": "2024-06-01",
      "registration_end_date": "2024-07-31",
      "event_url": "tokyo-summer-fest-2024",
      "category": "音楽イベント",
      "enable_flg": 1,
      "image_url": "/api/events/images/event1.jpg",
      "branch_code": "TOKYO001",
      "client_id": 1,
      "client_name": "株式会社イベント企画",
      "branch_name": "東京",
      "branch_full_name": "東京支店"
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 50,
    "total": 100,
    "total_pages": 2
  }
}
```

**注意（2026-02-05更新）**: 
非認証時も以下の支店・クライアント情報を返却するように変更しました：
- `branch_code`, `branch_name`, `branch_full_name`: 支店情報（常に返却）
- `client_id`, `client_name`: クライアント情報（常に返却）
- `organizer_id`: 主催者情報（認証時のみ返却、現在は非表示）

**レスポンス例（認証あり）**:
```json
{
  "data": [
    {
      "id": 1,
      "name": "東京サマーフェスティバル2024",
      "detail": "夏の一大イベント",
      "location": "東京ドーム",
      "contact": "event@example.com",
      "event_start_date": "2024-08-01",
      "event_end_date": "2024-08-03",
      "registration_start_date": "2024-06-01",
      "registration_end_date": "2024-07-31",
      "event_url": "tokyo-summer-fest-2024",
      "category": "音楽イベント",
      "enable_flg": 1,
      "payment_flg": 1,
      "image_url": "/api/events/images/event1.jpg",
      "branch_code": "TOKYO001",
      "organizer_id": 1,
      "customer_client_id": 2,
      "client_id": 1,
      "admin_email": "admin@example.com",
      "created_at": "2024-05-01 10:00:00",
      "modified_at": "2024-05-15 14:30:00",
      "deleted_at": null,
      "client_name": "株式会社イベント企画",
      "vendor_name": "イベント運営会社",
      "branch_name": "東京支店",
      "branch_full_name": "株式会社イベント企画 東京支店"
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 50,
    "total": 100,
    "total_pages": 2
  }
}
```

---

### 2. イベントカテゴリ一覧取得

**エンドポイント**: `GET /api/events/categories`

**説明**: イベントのカテゴリ一覧を取得します。

**認証**: 不要

**リクエストパラメータ**: なし

**レスポンス例**:
```json
{
  "categories": [
    { "id": 1, "name": "セミナー", "slug": "seminar" },
    { "id": 2, "name": "ワークショップ", "slug": "workshop" },
    { "id": 3, "name": "展示会", "slug": "exhibition" },
    { "id": 4, "name": "コンサート", "slug": "concert" },
    { "id": 5, "name": "スポーツ", "slug": "sports" },
    { "id": 6, "name": "フェスティバル", "slug": "festival" },
    { "id": 7, "name": "その他", "slug": "other" }
  ]
}
```

---

### 3. イベント詳細取得

**エンドポイント**: `GET /api/events/:id`

**説明**: 指定されたIDのイベント詳細情報を取得します。

**パスパラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| id | integer | ○ | イベントID |

**レスポンス例**:
```json
{
  "event": {
    "id": 1,
    "name": "東京サマーフェスティバル2024",
    "detail": "夏の一大イベントです。",
    "location": "東京ドーム",
    "contact": "event@example.com",
    "remarks": "雨天決行",
    "thanks_msg": "ご参加ありがとうございました！",
    "client_id": 1,
    "customer_client_id": 2,
    "vendor_id": 3,
    "organizer_id": 1,
    "branch_code": "TOKYO001",
    "enable_flg": 1,
    "payment_flg": 1,
    "event_url": "tokyo-summer-fest-2024",
    "category": "音楽イベント",
    "date_selection_type": "button",
    "event_type": "standalone",
    "parent_event_id": null,
    "event_start_date": "2024-08-01",
    "event_end_date": "2024-08-03",
    "registration_start_date": "2024-06-01",
    "registration_end_date": "2024-07-31",
    "admin_login_start_date": "2024-05-01",
    "admin_login_end_date": "2024-08-31",
    "admin_email": "admin@example.com",
    "admin_cc_email": "cc@example.com",
    "sender_name": "イベント事務局",
    "sender_email": "noreply@example.com",
    "email_signature": "東京サマーフェスティバル事務局",
    "email_signature_en": "Tokyo Summer Festival Office",
    "payment_methods": "credit,bank,convenience",
    "payment_credit_card": 1,
    "payment_bank_transfer": 1,
    "payment_convenience_store": 1,
    "bank_name": "三菱UFJ銀行",
    "bank_branch": "新宿支店",
    "bank_account_type": "普通",
    "bank_account_number": "1234567",
    "bank_account_name": "イベント事務局",
    "store_code": "12345",
    "bank_transfer_deadline": 7,
    "convenience_payment_deadline": 7,
    "available_convenience_stores": "[\"セブンイレブン\",\"ファミリーマート\",\"ローソン\"]",
    "credit_fee_type": "percentage",
    "credit_fee_percentage": 3.0,
    "credit_fee_fixed": 0,
    "bank_fee_type": "fixed",
    "bank_fee_percentage": 0,
    "bank_fee_fixed": 330,
    "convenience_fee_type": "fixed",
    "convenience_fee_percentage": 0,
    "convenience_fee_fixed": 220,
    "cancel_policy": "standard",
    "cancellation_policy_details": "キャンセルポリシー詳細",
    "cancellation_days_1": 7,
    "cancellation_rate_1": 20,
    "cancellation_days_2": 3,
    "cancellation_rate_2": 50,
    "form_field_settings": "{\"name_kanji\":true,\"name_kana\":true,\"address\":true,\"tel\":true}",
    "auto_reply_enabled": 1,
    "auto_reply_credit_payment": "クレジット決済完了メール本文",
    "auto_reply_bank_payment": "銀行振込案内メール本文",
    "auto_reply_convenience_payment": "コンビニ決済案内メール本文",
    "image_url": "/api/events/images/event1.jpg",
    "created_at": "2024-05-01 10:00:00",
    "modified_at": "2024-05-15 14:30:00",
    "deleted_at": null
  }
}
```

**エラーレスポンス**:
```json
{
  "error": "Event not found"
}
```
- ステータスコード: 404

---

### 4. イベント新規作成

**エンドポイント**: `POST /api/events`

**説明**: 新しいイベントを作成します。

**認証**: 必要（admin）

**リクエストボディ**:
```json
{
  "name": "東京サマーフェスティバル2024",
  "detail": "夏の一大イベントです。",
  "location": "東京ドーム",
  "contact": "event@example.com",
  "remarks": "雨天決行",
  "thanks_msg": "ご参加ありがとうございました！",
  "client_id": 1,
  "customer_client_id": 2,
  "vendor_id": 3,
  "organizer_id": 1,
  "branch_code": "TOKYO001",
  "enable_flg": 1,
  "event_url": "tokyo-summer-fest-2024",
  "category": "音楽イベント",
  "date_selection_type": "button",
  "event_type": "standalone",
  "parent_event_id": null,
  "event_start_date": "2024-08-01",
  "event_end_date": "2024-08-03",
  "registration_start_date": "2024-06-01",
  "registration_end_date": "2024-07-31",
  "admin_login_start_date": "2024-05-01",
  "admin_login_end_date": "2024-08-31",
  "admin_email": "admin@example.com",
  "admin_cc_email": "cc@example.com",
  "sender_name": "イベント事務局",
  "sender_email": "noreply@example.com",
  "email_signature": "東京サマーフェスティバル事務局",
  "payment_flg": 1,
  "payment_credit_card": true,
  "payment_bank_transfer": true,
  "payment_convenience_store": true,
  "bank_name": "三菱UFJ銀行",
  "bank_branch": "新宿支店",
  "bank_account_type": "普通",
  "bank_account_number": "1234567",
  "bank_account_name": "イベント事務局",
  "bank_transfer_deadline": 7,
  "convenience_payment_deadline": 7,
  "convenience_stores": ["セブンイレブン", "ファミリーマート", "ローソン"],
  "credit_fee_type": "percentage",
  "credit_fee_percentage": 3.0,
  "credit_fee_fixed": 0,
  "bank_fee_type": "fixed",
  "bank_fee_percentage": 0,
  "bank_fee_fixed": 330,
  "convenience_fee_type": "fixed",
  "convenience_fee_percentage": 0,
  "convenience_fee_fixed": 220,
  "cancel_policy": "standard",
  "cancellation_days_1": 7,
  "cancellation_rate_1": 20,
  "cancellation_days_2": 3,
  "cancellation_rate_2": 50,
  "form_field_settings": "{\"name_kanji\":true,\"name_kana\":true,\"address\":true,\"tel\":true}",
  "auto_reply_enabled": true,
  "auto_reply_credit_payment": "クレジット決済完了メール本文",
  "image_url": "/api/events/images/event1.jpg"
}
```

**必須フィールド**:
- `name`: イベント名
- `contact`: 連絡先
- `client_id`: クライアントID
- `customer_client_id`: 顧客クライアントID
- `event_url`: イベントURL（一意）
- `event_start_date`: 開催開始日
- `event_end_date`: 開催終了日
- `registration_start_date`: 受付開始日
- `registration_end_date`: 受付終了日

**レスポンス例**:
```json
{
  "success": true,
  "id": 5,
  "message": "イベントを登録しました"
}
```

**エラーレスポンス**:

1. 必須フィールドエラー:
```json
{
  "error": "必須フィールドが入力されていません"
}
```
- ステータスコード: 400

2. イベントURL重複エラー:
```json
{
  "error": "このイベントURLは既に使用されています"
}
```
- ステータスコード: 400

---

### 5. イベント更新

**エンドポイント**: `PUT /api/events/:id`

**説明**: 既存のイベント情報を更新します。

**認証**: 必要（admin）

**パスパラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| id | integer | ○ | イベントID |

**リクエストボディ**: イベント作成と同じ形式（更新したいフィールドのみ送信）

**レスポンス例**:
```json
{
  "success": true,
  "message": "イベントを更新しました"
}
```

**エラーレスポンス**: イベント作成と同様

---

### 6. イベント削除

**エンドポイント**: `DELETE /api/events/:id`

**説明**: イベントを論理削除します（deleted_atを設定）。

**認証**: 必要（admin）

**パスパラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| id | integer | ○ | イベントID |

**レスポンス例**:
```json
{
  "message": "イベントを削除しました"
}
```

**エラーレスポンス**:
```json
{
  "error": "イベントが見つかりません"
}
```
- ステータスコード: 404

---

### 7. イベントコピー

**エンドポイント**: `POST /api/events/:id/copy`

**説明**: 既存のイベントをコピーして新しいイベントを作成します。

**認証**: 必要（admin）

**パスパラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| id | integer | ○ | コピー元のイベントID |

**レスポンス例**:
```json
{
  "message": "イベントをコピーしました",
  "event_id": 6,
  "event_url": "tokyo-summer-fest-2024-copy-1706492800000"
}
```

**注意事項**:
- イベント名に「（コピー）」が自動追加されます
- イベントURLは自動生成されます（元のURL + `-copy-{timestamp}`）
- 商品、オプション、在庫情報はコピーされません
- 新規イベントは無効状態（enable_flg=0）で作成されます

---

### 8. イベントの商品一覧取得

**エンドポイント**: `GET /api/events/:id/products`

**説明**: イベントに紐付く商品一覧を取得します。

**パスパラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| id | integer | ○ | イベントID |

**レスポンス例**:
```json
{
  "products": [
    {
      "id": 1,
      "name": "VIP入場券",
      "detail": "特別席入場券",
      "price": 10000,
      "price_unit": "人",
      "purchase_limit": 5,
      "enable_flg": 1
    }
  ]
}
```

---

### 9. イベントの利用可能日取得

**エンドポイント**: `GET /api/events/:id/available-dates`

**説明**: イベントの商品・オプションで利用可能な日付一覧を取得します。

**パスパラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| id | integer | ○ | イベントID |

**レスポンス例**:
```json
{
  "dates": [
    "2024-08-01",
    "2024-08-02",
    "2024-08-03"
  ]
}
```

---

### 10. 日付別商品一覧取得

**エンドポイント**: `GET /api/events/:id/products-by-date`

**説明**: 指定された日付で利用可能な商品一覧を取得します。

**パスパラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| id | integer | ○ | イベントID |

**クエリパラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|------|------|------|
| date | string | ○ | 日付（YYYY-MM-DD形式） |

**レスポンス例**:
```json
{
  "products": [
    {
      "id": 1,
      "name": "VIP入場券",
      "price": 10000,
      "available_stock": 50
    }
  ]
}
```

---

---

### 11. イベント画像アップロード

**エンドポイント**: `POST /api/events/upload-image`

**説明**: イベント用の画像をアップロードします。

**認証**: 必要（admin）

**リクエストボディ**: multipart/form-data
| フィールド | 型 | 必須 | 説明 |
|-----------|------|------|------|
| image | file | ○ | 画像ファイル（JPEG, PNG） |

**レスポンス例**:
```json
{
  "success": true,
  "url": "/api/events/images/event_20240801_123456.jpg"
}
```

---

## エラーレスポンス

### エラーレスポンス形式
```json
{
  "error": "エラーメッセージ"
}
```

### HTTPステータスコード

| コード | 説明 |
|--------|------|
| 200 | 成功 |
| 400 | リクエストエラー（必須パラメータ不足、バリデーションエラー等） |
| 401 | 認証エラー |
| 403 | 権限エラー |
| 404 | リソースが見つからない |
| 500 | サーバーエラー |

---

## データモデル

### Event（イベント）

| フィールド名 | 型 | NULL | デフォルト | 説明 |
|-------------|------|------|----------|------|
| id | INTEGER | NO | AUTO_INCREMENT | イベントID（主キー） |
| name | TEXT | NO | - | イベント名 |
| detail | TEXT | YES | - | イベント詳細 |
| location | TEXT | YES | - | 開催場所 |
| contact | TEXT | NO | - | 連絡先 |
| remarks | TEXT | YES | - | 備考 |
| thanks_msg | TEXT | YES | - | お礼メッセージ |
| client_id | INTEGER | NO | - | クライアントID（FK） |
| customer_client_id | INTEGER | YES | - | 顧客クライアントID |
| organizer_id | INTEGER | YES | - | 主催者ID |
| vendor_id | INTEGER | YES | - | ベンダーID |
| branch_code | TEXT | YES | - | 支店コード |
| enable_flg | INTEGER | NO | 1 | 有効フラグ（0:無効, 1:有効） |
| payment_flg | INTEGER | NO | 0 | 決済フラグ（0:無料, 1:有料） |
| event_url | TEXT | YES | - | イベントURL（一意） |
| category | TEXT | YES | - | カテゴリ |
| date_selection_type | TEXT | YES | 'single' | 日付選択タイプ |
| event_type | TEXT | YES | 'standalone' | イベントタイプ（standalone/parent/child） |
| parent_event_id | INTEGER | YES | - | 親イベントID |
| event_start_date | TEXT | YES | - | 開催開始日 |
| event_end_date | TEXT | YES | - | 開催終了日 |
| registration_start_date | TEXT | YES | - | 受付開始日 |
| registration_end_date | TEXT | YES | - | 受付終了日 |
| admin_login_start_date | TEXT | YES | - | 管理者ログイン開始日 |
| admin_login_end_date | TEXT | YES | - | 管理者ログイン終了日 |
| admin_email | TEXT | YES | - | 管理者メールアドレス |
| admin_cc_email | TEXT | YES | - | 管理者CCメールアドレス |
| sender_name | TEXT | YES | - | 送信者名 |
| sender_email | TEXT | YES | - | 送信者メールアドレス |
| email_signature | TEXT | YES | - | メール署名 |
| email_signature_en | TEXT | YES | - | メール署名（英語） |
| payment_methods | TEXT | YES | - | 決済方法 |
| payment_credit_card | INTEGER | NO | 0 | クレジットカード決済有効 |
| payment_bank_transfer | INTEGER | NO | 0 | 銀行振込決済有効 |
| payment_convenience_store | INTEGER | NO | 0 | コンビニ決済有効 |
| bank_name | TEXT | YES | - | 銀行名 |
| bank_branch | TEXT | YES | - | 支店名 |
| bank_account_type | TEXT | YES | - | 口座種別 |
| bank_account_number | TEXT | YES | - | 口座番号 |
| bank_account_name | TEXT | YES | - | 口座名義 |
| store_code | TEXT | YES | - | 店舗コード |
| bank_transfer_deadline | INTEGER | YES | - | 銀行振込期限（日数） |
| convenience_payment_deadline | INTEGER | YES | - | コンビニ決済期限（日数） |
| available_convenience_stores | TEXT | YES | - | 利用可能なコンビニ（JSON配列） |
| credit_fee_type | TEXT | YES | - | クレジット手数料タイプ（none/percentage/fixed） |
| credit_fee_percentage | REAL | YES | - | クレジット手数料率（%） |
| credit_fee_fixed | INTEGER | YES | - | クレジット手数料固定額 |
| bank_fee_type | TEXT | YES | - | 銀行振込手数料タイプ |
| bank_fee_percentage | REAL | YES | - | 銀行振込手数料率（%） |
| bank_fee_fixed | INTEGER | YES | - | 銀行振込手数料固定額 |
| convenience_fee_type | TEXT | YES | - | コンビニ決済手数料タイプ |
| convenience_fee_percentage | REAL | YES | - | コンビニ決済手数料率（%） |
| convenience_fee_fixed | INTEGER | YES | - | コンビニ決済手数料固定額 |
| cancel_policy | TEXT | YES | - | キャンセルポリシー |
| cancellation_policy_details | TEXT | YES | - | キャンセルポリシー詳細 |
| cancellation_days_1 | INTEGER | YES | - | キャンセル期限1（日数） |
| cancellation_rate_1 | INTEGER | YES | - | キャンセル料率1（%） |
| cancellation_days_2 | INTEGER | YES | - | キャンセル期限2（日数） |
| cancellation_rate_2 | INTEGER | YES | - | キャンセル料率2（%） |
| form_field_settings | TEXT | YES | - | フォーム設定（JSON） |
| auto_reply_enabled | INTEGER | NO | 0 | 自動返信有効フラグ |
| auto_reply_credit_payment | TEXT | YES | - | クレジット決済完了メール本文 |
| auto_reply_bank_payment | TEXT | YES | - | 銀行振込案内メール本文 |
| auto_reply_convenience_payment | TEXT | YES | - | コンビニ決済案内メール本文 |
| auto_reply_credit_cancel | TEXT | YES | - | クレジット決済キャンセルメール本文 |
| auto_reply_bank_cancel | TEXT | YES | - | 銀行振込キャンセルメール本文 |
| auto_reply_convenience_cancel | TEXT | YES | - | コンビニ決済キャンセルメール本文 |
| image_url | TEXT | YES | - | イベント画像URL |
| created_at | TEXT | NO | datetime('now','localtime') | 作成日時 |
| modified_at | TEXT | NO | datetime('now','localtime') | 更新日時 |
| deleted_at | TEXT | YES | - | 削除日時（論理削除） |

### Event Form Fields（イベントフォームフィールド）

| フィールド名 | 型 | NULL | デフォルト | 説明 |
|-------------|------|------|----------|------|
| id | INTEGER | NO | AUTO_INCREMENT | フィールドID（主キー） |
| event_id | INTEGER | NO | - | イベントID（FK） |
| field_type | TEXT | NO | - | フィールドタイプ |
| field_name | TEXT | NO | - | フィールド名 |
| field_label | TEXT | NO | - | フィールドラベル |
| field_options | TEXT | YES | - | 選択肢（JSON） |
| is_required | INTEGER | NO | 0 | 必須フラグ |
| description | TEXT | YES | - | 説明 |
| display_order | INTEGER | NO | 0 | 表示順序 |
| placeholder | TEXT | YES | - | プレースホルダー |
| parent_field_id | INTEGER | YES | - | 親フィールドID |
| parent_condition | TEXT | YES | - | 親フィールド条件 |
| indent_level | INTEGER | NO | 0 | インデントレベル |
| created_at | TEXT | NO | datetime('now','localtime') | 作成日時 |
| modified_at | TEXT | NO | datetime('now','localtime') | 更新日時 |

---

## 関連ドキュメント

- [データベーススキーマ完全版](./DATABASE_SCHEMA_COMPLETE.md)
- [データベーススキーマSQL](./database_schema_complete.sql)

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|---------|
| 1.3 | 2026-02-05 | 未使用エンドポイント5件を仕様書から削除（使用中の13件のみ記載） |
| 1.2 | 2026-02-05 | 未使用エンドポイントの調査と注記を追加（5件） |
| 1.1 | 2026-02-05 | イベント一覧APIの仕様変更：非認証時も支店・クライアント情報を返却、主催者情報は非表示 |
| 1.0 | 2026-01-28 | 初版作成 |

---

## お問い合わせ

API仕様に関するお問い合わせは、開発チームまでご連絡ください。
