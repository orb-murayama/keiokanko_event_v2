# 予約管理システム 仕様書

## 目次
1. [システム概要](#システム概要)
2. [データベース設計](#データベース設計)
3. [API仕様](#api仕様)
4. [画面仕様](#画面仕様)

---

## システム概要

### 機能概要
京王観光イベント予約管理システムは、イベント・商品の予約から決済、参加者管理までを一元管理するWebアプリケーションです。

### 主要機能
- **予約管理**: 予約の作成・編集・キャンセル
- **商品管理**: イベント商品・オプション商品・カスタム商品の管理
- **決済管理**: GMO決済連携（クレジットカード・コンビニ決済）
- **参加者管理**: 参加者情報の登録・カスタムフィールド対応
- **会員管理**: 会員情報の管理・OTP認証
- **メール通知**: 予約確認メール・リマインダーメール
- **マイページ**: 予約者向けセルフサービス

### 商品タイプ（ポリモーフィック関連）
予約明細（booking_items）は、`item_type` + `item_id` の組み合わせで複数の商品タイプに対応：

| item_type | 意味 | item_id の参照先 | 用途 |
|-----------|------|-----------------|------|
| `product` | 商品 | `products.id` | 通常の予約商品（展望デッキチケットなど） |
| `option` | オプション | `options.id` | 追加オプション（お土産、ガイドツアーなど） |
| `custom` | カスタム商品 | 0 または null | 自由入力の商品（イレギュラーな追加商品） |

### 技術スタック
- **フロントエンド**: HTML, CSS, JavaScript (Vue.js)
- **バックエンド**: Hono (TypeScript)
- **データベース**: Cloudflare D1 (SQLite)
- **ホスティング**: Cloudflare Pages
- **決済**: GMO Payment Gateway

---

## データベース設計

### ER図（テキスト表現）

```
[members] 1---* [bookings] *---1 [events]
              |
              +---* [booking_items] *---1 [products]
              |           |
              |           +---1 [stocks]
              |           |
              |           +---* [booking_payments]
              |
              +---* [booking_messages]
              |
              +---* [booking_emails]
              |
              +---* [booking_files]
```

### テーブル定義

#### 1. bookings（予約テーブル）

**用途**: 予約の基本情報を管理

```sql
CREATE TABLE bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT UNIQUE NOT NULL,        -- 予約番号（BK20260304-001形式）
  member_id INTEGER NOT NULL,                 -- 会員ID
  event_id INTEGER NOT NULL,                  -- イベントID
  status TEXT DEFAULT 'active',               -- ステータス（active/canceled）
  
  -- 予約者情報
  booker_name TEXT,                           -- 予約者名
  booker_email TEXT,                          -- 予約者メール
  booker_phone TEXT,                          -- 予約者電話番号
  
  -- 追加情報
  additional_info TEXT,                       -- 追加情報
  remarks TEXT,                               -- 備考
  
  -- GMO決済情報
  gmo_order_id TEXT,                          -- GMO注文ID
  gmo_access_id TEXT,                         -- GMOアクセスID
  gmo_access_pass TEXT,                       -- GMOアクセスパス
  
  -- マイページ認証
  secure_token TEXT,                          -- セキュアトークン
  token_expires_at DATETIME,                  -- トークン有効期限
  
  -- 新規会員フラグ
  is_new_member INTEGER DEFAULT 0,            -- 新規会員フラグ（0: 既存, 1: 新規）
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (member_id) REFERENCES members(id),
  FOREIGN KEY (event_id) REFERENCES events(id)
);
```

**インデックス**:
```sql
CREATE INDEX idx_bookings_booking_number ON bookings(booking_number);
CREATE INDEX idx_bookings_member_id ON bookings(member_id);
CREATE INDEX idx_bookings_event_id ON bookings(event_id);
CREATE INDEX idx_bookings_status ON bookings(status);
```

---

#### 2. booking_items（予約明細テーブル）

**用途**: 予約に含まれる商品・オプションの明細

```sql
CREATE TABLE booking_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,                -- 予約ID
  payment_id INTEGER,                         -- 支払いID
  
  -- 商品情報
  item_type TEXT NOT NULL,                    -- 商品タイプ（product/option/custom）
  item_id INTEGER NOT NULL,                   -- 商品ID（item_typeに応じて: product→products.id, option→options.id, custom→0 or null）
  item_name TEXT NOT NULL,                    -- 商品名
  stock_id INTEGER,                           -- 在庫ID
  price_category TEXT,                        -- 価格帯（例: A-大人）
  
  -- 数量・金額
  quantity INTEGER DEFAULT 1,                 -- 数量
  unit_price INTEGER NOT NULL,                -- 単価
  subtotal INTEGER NOT NULL,                  -- 小計
  
  -- 参加日
  participation_date TEXT,                    -- 参加日（YYYY-MM-DD）
  
  -- 参加者情報（JSON形式）
  participants TEXT,                          -- 参加者情報配列
  
  -- キャンセル情報
  status TEXT DEFAULT 'active',               -- ステータス（active/canceled）
  canceled_at TEXT,                           -- キャンセル日時
  cancel_reason TEXT,                         -- キャンセル理由
  refund_amount INTEGER DEFAULT 0,            -- 返金額
  
  -- 詳細情報
  item_details TEXT,                          -- 商品詳細（JSON）
  remarks TEXT,                               -- 備考
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (payment_id) REFERENCES booking_payments(id)
);
```

**item_type と item_id の関係**:

| item_type | 意味 | item_id の参照先 | 例 |
|-----------|------|-----------------|-----|
| `product` | 商品 | `products.id` | 8, 9 |
| `option` | オプション | `options.id` | 101, 102 |
| `custom` | カスタム商品 | 0 または null | 0 |

**設計の意図**:
- `item_type` + `item_id` の組み合わせで、複数の商品タイプに対応する**ポリモーフィック関連**を実現
- 1つのテーブルで商品、オプション、カスタム商品を統一的に管理
- JOIN時は `item_type` で振り分け: `LEFT JOIN products p ON item_type = 'product' AND item_id = p.id`

**participants カラムのJSON構造**:
```json
[
  {
    "lastname_kanji": "渡辺",
    "firstname_kanji": "健",
    "lastname_kana": "ワタナベ",
    "firstname_kana": "ケン",
    "lastname_roman": "",
    "firstname_roman": "",
    "age": 33,
    "gender": "1",
    "email": "",
    "phone": "",
    "birth_date": "",
    "address": "",
    "custom_fields": {
      "radio_1": "洋食",
      "radio_2": "白",
      "radio_3": "高い"
    }
  }
]
```

**custom_fields の構造**:
- キー: `product_form_fields` テーブルの `field_name` カラム（例: radio_1, text_2, checkbox_3）
- 値: ユーザーが入力した値（文字列）
- チェックボックスの場合: カンマ区切りの文字列（例: "選択肢1,選択肢2"）

**インデックス**:
```sql
CREATE INDEX idx_booking_items_booking_id ON booking_items(booking_id);
CREATE INDEX idx_booking_items_type_id ON booking_items(item_type, item_id);  -- ポリモーフィック関連用
CREATE INDEX idx_booking_items_status ON booking_items(status);
```

---

#### 3. booking_payments（予約支払いテーブル）

**用途**: 予約に関連する支払い情報

```sql
CREATE TABLE booking_payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,               -- 予約番号
  payment_number TEXT UNIQUE NOT NULL,        -- 支払い番号（PAY20260304-001形式）
  
  -- 支払いタイプ・方法
  payment_type TEXT NOT NULL DEFAULT 'immediate',  -- 支払いタイプ（immediate/split）
  payment_method TEXT NOT NULL,               -- 支払い方法（credit_card/convenience/bank_transfer）
  payment_status TEXT DEFAULT 'pending',      -- 支払いステータス（pending/completed/failed/refunded）
  
  -- 金額情報
  amount INTEGER NOT NULL,                    -- 支払い額
  refunded_amount INTEGER DEFAULT 0,          -- 返金額
  net_amount INTEGER GENERATED ALWAYS AS (amount - refunded_amount) STORED,  -- 実質支払額
  
  -- 日付情報
  payment_date TEXT,                          -- 支払い日
  payment_due_date TEXT,                      -- 支払い期限
  refund_date TEXT,                           -- 返金日
  
  -- GMO決済情報
  payment_transaction_id TEXT,                -- 決済トランザクションID
  payment_details TEXT,                       -- 決済詳細（JSON）
  
  remarks TEXT,                               -- 備考
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_number) REFERENCES bookings(booking_number)
);
```

**payment_details カラムのJSON構造**:
```json
{
  "gmo_access_id": "abc123",
  "gmo_access_pass": "xyz789",
  "gmo_order_id": "TEMP-1234567890-abc",
  "transaction_result": {
    "Status": "AUTH",
    "TranID": "260304173700...",
    "Approve": "097408"
  }
}
```

**インデックス**:
```sql
CREATE INDEX idx_booking_payments_booking_number ON booking_payments(booking_number);
CREATE INDEX idx_booking_payments_payment_status ON booking_payments(payment_status);
```

---

#### 4. booking_messages（予約メッセージテーブル）

**用途**: 予約に関連するメッセージ（リマインダー等）

```sql
CREATE TABLE booking_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,                -- 予約ID
  booking_number TEXT NOT NULL,               -- 予約番号
  recipient_email TEXT NOT NULL,              -- 受信者メールアドレス
  title TEXT NOT NULL,                        -- メッセージタイトル
  message TEXT NOT NULL,                      -- メッセージ本文
  scheduled_send_at TEXT NOT NULL,            -- 送信予定日時
  sent_at TEXT,                               -- 送信日時
  send_status TEXT DEFAULT 'pending',         -- 送信ステータス（pending/sent/failed）
  display_on_mypage INTEGER DEFAULT 1,        -- マイページ表示フラグ
  created_by TEXT,                            -- 作成者
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
```

**インデックス**:
```sql
CREATE INDEX idx_booking_messages_booking_id ON booking_messages(booking_id);
CREATE INDEX idx_booking_messages_send_status ON booking_messages(send_status);
```

---

#### 5. booking_emails（予約メールテーブル）

**用途**: 予約確認メール等の送信管理

```sql
CREATE TABLE booking_emails (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,               -- 予約番号
  from_email TEXT NOT NULL,                   -- 送信元メールアドレス
  to_email TEXT NOT NULL,                     -- 送信先メールアドレス
  bcc_email TEXT,                             -- BCCメールアドレス
  subject TEXT NOT NULL,                      -- 件名
  body TEXT NOT NULL,                         -- 本文
  scheduled_send_at DATETIME NOT NULL,        -- 送信予定日時
  send_status TEXT DEFAULT 'pending',         -- 送信ステータス
  sent_at DATETIME,                           -- 送信日時
  error_message TEXT,                         -- エラーメッセージ
  template_id INTEGER,                        -- テンプレートID
  
  -- タイムスタンプ
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (template_id) REFERENCES email_templates(id)
);
```

**インデックス**:
```sql
CREATE INDEX idx_booking_emails_booking_number ON booking_emails(booking_number);
CREATE INDEX idx_booking_emails_send_status ON booking_emails(send_status);
```

---

#### 6. booking_files（予約ファイルテーブル）

**用途**: 予約に関連するファイル（旅程表等）

```sql
CREATE TABLE booking_files (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,               -- 予約番号
  file_key TEXT NOT NULL,                     -- ファイルキー（R2 Object Storage）
  original_filename TEXT NOT NULL,            -- 元のファイル名
  display_filename TEXT NOT NULL,             -- 表示用ファイル名
  file_size INTEGER NOT NULL,                 -- ファイルサイズ（バイト）
  download_limit INTEGER DEFAULT 0,           -- ダウンロード制限回数（0=無制限）
  download_count INTEGER DEFAULT 0,           -- ダウンロード回数
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_number) REFERENCES bookings(booking_number)
);
```

**インデックス**:
```sql
CREATE INDEX idx_booking_files_booking_number ON booking_files(booking_number);
```

---

#### 7. members（会員テーブル）

**用途**: 予約者の会員情報

```sql
CREATE TABLE members (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,                 -- メールアドレス
  password_hash TEXT NOT NULL,                -- パスワードハッシュ
  family_name TEXT NOT NULL,                  -- 姓
  first_name TEXT NOT NULL,                   -- 名
  family_kana TEXT,                           -- 姓（カナ）
  first_kana TEXT,                            -- 名（カナ）
  tel TEXT,                                   -- 電話番号
  mobile TEXT,                                -- 携帯電話番号
  zip TEXT,                                   -- 郵便番号
  addr TEXT,                                  -- 住所
  enable_flg INTEGER DEFAULT 1,               -- 有効フラグ
  email_verified INTEGER DEFAULT 0,           -- メール認証済みフラグ
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);
```

**インデックス**:
```sql
CREATE INDEX idx_members_email ON members(email);
```

---

#### 8. events（イベントテーブル）

**用途**: イベント情報

```sql
CREATE TABLE events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,                         -- イベント名
  event_url TEXT UNIQUE,                      -- イベントURL（スラッグ）
  description TEXT,                           -- 説明
  location TEXT,                              -- 開催場所
  contact TEXT,                               -- 問合せ先
  event_start_date TEXT NOT NULL,             -- 開催開始日
  event_end_date TEXT NOT NULL,               -- 開催終了日
  registration_start_date TEXT NOT NULL,      -- 受付開始日
  registration_end_date TEXT NOT NULL,        -- 受付終了日
  enable_flg INTEGER DEFAULT 1,               -- 有効フラグ
  payment_required INTEGER DEFAULT 1,         -- 決済必須フラグ
  credit_card_payment INTEGER DEFAULT 1,      -- クレジット決済可否
  bank_transfer_payment INTEGER DEFAULT 0,    -- 銀行振込可否
  convenience_payment INTEGER DEFAULT 0,      -- コンビニ決済可否
  date_selection_type TEXT DEFAULT 'calendar',-- 日付選択タイプ
  event_type TEXT DEFAULT 'standard',         -- イベントタイプ
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);
```

**インデックス**:
```sql
CREATE INDEX idx_events_event_url ON events(event_url);
CREATE INDEX idx_events_enable_flg ON events(enable_flg);
```

---

#### 9. products（商品テーブル）

**用途**: イベントの商品情報

**booking_items との関連**: `booking_items.item_type = 'product'` の場合、`booking_items.item_id` が `products.id` を参照

```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,                  -- イベントID
  name TEXT NOT NULL,                         -- 商品名
  description TEXT,                           -- 説明
  display_order INTEGER DEFAULT 0,            -- 表示順
  enable_flg INTEGER DEFAULT 1,               -- 有効フラグ
  
  -- 販売期間
  sales_start_date TEXT,                      -- 販売開始日
  sales_end_date TEXT,                        -- 販売終了日
  
  -- 参加者情報項目設定（JSON）
  participant_info_config TEXT,               -- 参加者情報設定
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (event_id) REFERENCES events(id)
);
```

**participant_info_config カラムのJSON構造**:
```json
{
  "name_kanji": true,
  "name_kana": true,
  "age": true,
  "gender": true,
  "email": false,
  "phone": false
}
```

**インデックス**:
```sql
CREATE INDEX idx_products_event_id ON products(event_id);
CREATE INDEX idx_products_enable_flg ON products(enable_flg);
```

---

#### 10. product_prices（商品価格テーブル）

**用途**: 商品の価格帯情報

```sql
CREATE TABLE product_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,                -- 商品ID
  price_band TEXT NOT NULL,                   -- 価格帯（A/B/C等）
  price_name TEXT NOT NULL,                   -- 価格名称（大人/子供等）
  price INTEGER NOT NULL,                     -- 価格
  display_order INTEGER DEFAULT 0,            -- 表示順
  enable_flg INTEGER DEFAULT 1,               -- 有効フラグ
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

**インデックス**:
```sql
CREATE INDEX idx_product_prices_product_id ON product_prices(product_id);
```

---

#### 11. product_stocks（商品在庫テーブル）

**用途**: 商品の在庫管理

```sql
CREATE TABLE product_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,                -- 商品ID
  stock_date TEXT NOT NULL,                   -- 在庫日付（YYYY-MM-DD）
  total_quantity INTEGER NOT NULL,            -- 総在庫数
  available_quantity INTEGER NOT NULL,        -- 利用可能在庫数
  reserved_quantity INTEGER DEFAULT 0,        -- 予約済み数
  sold_quantity INTEGER DEFAULT 0,            -- 販売済み数
  enable_flg INTEGER DEFAULT 1,               -- 有効フラグ
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

**インデックス**:
```sql
CREATE INDEX idx_product_stocks_product_id ON product_stocks(product_id);
CREATE INDEX idx_product_stocks_stock_date ON product_stocks(stock_date);
```

---

#### 12. product_form_fields（商品カスタムフィールドテーブル）

**用途**: 商品固有のカスタム入力項目

```sql
CREATE TABLE product_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,                -- 商品ID
  category INTEGER DEFAULT 1,                 -- カテゴリ（1: 予約者, 2: 参加者）
  field_type TEXT NOT NULL,                   -- フィールドタイプ（text/select/radio/checkbox等）
  field_name TEXT NOT NULL,                   -- フィールド名（例: radio_1, text_2）
  field_label TEXT NOT NULL,                  -- ラベル（表示名）
  field_options TEXT,                         -- 選択肢（JSON配列）
  is_required INTEGER DEFAULT 0,              -- 必須フラグ
  description TEXT,                           -- 説明
  placeholder TEXT,                           -- プレースホルダー
  default_value TEXT,                         -- デフォルト値
  help_text TEXT,                             -- ヘルプテキスト
  validation_rule TEXT,                       -- バリデーションルール
  parent_field_id INTEGER,                    -- 親フィールドID（条件表示用）
  parent_condition TEXT,                      -- 親の条件値
  indent_level INTEGER DEFAULT 0,             -- インデントレベル
  display_order INTEGER DEFAULT 0,            -- 表示順
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (parent_field_id) REFERENCES product_form_fields(id)
);
```

**field_options カラムのJSON構造**:
```json
["選択肢1", "選択肢2", "選択肢3"]
```

**field_name の命名規則**:
- ラジオボタン: `radio_1`, `radio_2`, ...
- テキスト: `text_1`, `text_2`, ...
- チェックボックス: `checkbox_1`, `checkbox_2`, ...
- セレクト: `select_1`, `select_2`, ...

**インデックス**:
```sql
CREATE INDEX idx_product_form_fields_product_id ON product_form_fields(product_id);
CREATE INDEX idx_product_form_fields_category ON product_form_fields(category);
```

---

### リレーション図

```
┌──────────────┐
│   members    │
│  (会員)      │
└──────┬───────┘
       │ 1
       │
       │ *
┌──────▼───────┐      ┌──────────────┐
│  bookings    │  *   │   events     │
│  (予約)      ├──────┤  (イベント)   │
└──────┬───────┘   1  └──────┬───────┘
       │ 1                   │
       │                     │
       │ *                   │ 1:*
┌──────▼────────────┐  ┌─────▼───────┐     ┌──────────────┐
│  booking_items    │  │  products   │     │   options    │
│  (予約明細)       │  │  (商品)     │     │  (オプション) │
│                   │  └──────┬──────┘     └──────────────┘
│ item_type +       │         │ 1                  ▲
│ item_id で        │         │                    │
│ ポリモーフィック   │  ┌──────▼──────┐             │
│ 関連を実現        │  │product_prices│             │
│                   │  │(商品価格)    │             │
│ - product → products.id      │                    │
│ - option → options.id        │ *                  │
│ - custom → 0/null   ┌────────▼────────┐           │
└──────┬──────────────┤product_stocks   ├───────────┘
       │ *            │(商品在庫)       │  (オプション在庫も管理)
       │ 1            └─────────────────┘
┌──────▼──────────────┐
│ booking_payments    │
│ (支払い情報)        │
└─────────────────────┘
```

---

## API仕様

### 認証

#### Basic認証
管理画面APIは環境変数で設定されたBasic認証が必要です。

```
Authorization: Basic <base64(username:password)>
```

#### OTP認証（マイページ）
マイページAPIはメールアドレス宛に送信されるOTP（ワンタイムパスワード）による認証が必要です。

---

### 予約API

#### 1. 予約一覧取得

**エンドポイント**: `GET /api/v2/bookings`

**認証**: 必要（Basic Auth）

**参照テーブル**: 
- `bookings` (予約テーブル)
- `members` (会員テーブル - JOIN)
- `events` (イベントテーブル - JOIN)
- `booking_items` (予約明細テーブル - 金額集計用)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| page | integer | × | ページ番号（デフォルト: 1） |
| per_page | integer | × | 1ページあたりの件数（デフォルト: 50） |
| booking_number | string | × | 予約番号（部分一致検索） |
| member_email | string | × | 会員メールアドレス（部分一致検索） |
| event_id | integer | × | イベントID |
| status | string | × | ステータス（active/canceled） |
| date_from | string | × | 作成日From（YYYY-MM-DD） |
| date_to | string | × | 作成日To（YYYY-MM-DD） |

**レスポンス例**:
```json
{
  "bookings": [
    {
      "id": 1,
      "booking_number": "BK20260304-001",
      "member_id": 10,
      "member_email": "user@example.com",
      "event_id": 4,
      "event_name": "東京スカイツリー®展望台入場券",
      "status": "active",
      "total_amount": 12000,
      "booker_name": "山田 太郎",
      "booker_email": "yamada@example.com",
      "created_at": "2026-03-04 15:30:00"
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 50,
    "total": 120,
    "total_pages": 3
  }
}
```

**使用箇所**:
- 管理画面 > 予約一覧画面
- ボタン: 画面初期表示、検索ボタン、ページネーション

---

#### 2. 予約詳細取得

**エンドポイント**: `GET /api/v2/bookings/:booking_number`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル)
- `events` (イベントテーブル - JOIN)
- `booking_items` (予約明細テーブル)
- `products` (商品テーブル - JOIN, item_type='product'の場合)
- `options` (オプションテーブル - JOIN, item_type='option'の場合)
- `booking_payments` (支払い情報テーブル)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**レスポンス例**:
```json
{
  "booking": {
    "id": 1,
    "booking_number": "BK20260304-001",
    "member_id": 10,
    "event_id": 4,
    "event_name": "東京スカイツリー®展望台入場券",
    "status": "active",
    "booker_name": "山田 太郎",
    "booker_email": "yamada@example.com",
    "booker_phone": "090-1234-5678",
    "additional_info": "特別なリクエスト",
    "remarks": "管理者メモ",
    "created_at": "2026-03-04 15:30:00"
  },
  "items": [
    {
      "id": 93,
      "item_type": "product",
      "item_id": 8,                    // item_type='product' なので products.id を参照
      "item_name": "展望デッキ（350m）",
      "price_category": "A-大人",
      "quantity": 2,
      "unit_price": 10000,
      "subtotal": 20000,
      "participation_date": "2026-03-15",
      "participants": "[{...}]",
      "status": "active"
    }
  ],
  "payments": [
    {
      "id": 1,
      "payment_number": "PAY20260304-001",
      "payment_method": "credit_card",
      "payment_status": "completed",
      "amount": 20000,
      "payment_date": "2026-03-04 15:35:00"
    }
  ]
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 画面初期表示、予約番号リンククリック

---

#### 3. 予約編集用データ取得

**エンドポイント**: `GET /api/v2/bookings/:booking_number/edit-data`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル)
- `booking_items` (予約明細テーブル - payment_id含む)
- `booking_payments` (支払い情報テーブル - JOIN)
- `product_form_fields` (商品カスタムフィールドテーブル - item_type='product'の場合)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**レスポンス例**:
```json
{
  "booking": {
    "id": 1,
    "booking_number": "BK20260304-001",
    "member_id": 10,
    "event_id": 4,
    "status": "active",
    "booker_name": "山田 太郎",
    "booker_email": "yamada@example.com",
    "booker_phone": "090-1234-5678"
  },
  "items": [
    {
      "id": 93,
      "booking_id": 1,
      "item_type": "product",
      "item_id": 8,                    // item_type='product' なので products.id を参照
      "product_id": 8,                 // フロントエンド用のエイリアス（item_id と同じ値）
      "item_name": "展望デッキ（350m）",
      "price_category": "A-大人",
      "quantity": 2,
      "unit_price": 10000,
      "subtotal": 20000,
      "participation_date": "2026-03-15",
      "participants": "[{...}]"
    }
  ],
  "formFieldsMap": {
    "93": [
      {
        "id": 1,
        "product_id": 8,
        "field_name": "allergy",
        "field_label": "アレルギー",
        "field_type": "text",
        "is_required": 0
      }
    ]
  }
}
```

**使用箇所**:
- 管理画面 > 予約編集画面（bookings-edit.html）
- ボタン: 画面初期表示、編集ボタンクリック

---

#### 4. 予約作成

**エンドポイント**: `POST /api/v2/bookings`

**認証**: 不要

**参照テーブル**:
- `members` (会員テーブル - メールアドレス検索、新規会員判定)
- `events` (イベントテーブル - event_id検証)
- `products` (商品テーブル - item_type='product'の場合)
- `product_stocks` (商品在庫テーブル - 在庫確認・減算)

**書き込みテーブル**:
- `members` (会員テーブル - is_new_member=1の場合、新規会員登録)
- `bookings` (予約テーブル - INSERT)
- `booking_items` (予約明細テーブル - INSERT)
- `booking_payments` (支払い情報テーブル - INSERT)
- `product_stocks` (商品在庫テーブル - UPDATE remaining_quantity)

**リクエストボディ**:
```json
{
  "event_id": 4,
  "event_name": "東京スカイツリー®展望台入場券",
  "participation_date": "2026-03-15",
  "stock_id": 43,
  "booker": {
    "email": "yamada@example.com",
    "family_name": "山田",
    "first_name": "太郎",
    "family_kana": "ヤマダ",
    "first_kana": "タロウ",
    "tel": "090-1234-5678",
    "mobile": "090-1234-5678",
    "zip": "100-0001",
    "addr": "東京都千代田区..."
  },
  "participants": [
    {
      "lastname_kanji": "山田",
      "firstname_kanji": "太郎",
      "age": 35,
      "gender": "1",
      "custom_fields": {
        "アレルギー": "なし"
      }
    }
  ],
  "items": [
    {
      "type": "product",
      "id": 8,
      "name": "展望デッキ（350m）",
      "category": "A-大人",
      "quantity": 2,
      "price": 10000,
      "stock_id": 43,
      "participation_date": "2026-03-15"
    }
  ],
  "total_amount": 20000,
  "payment_method": "credit_card",
  "is_new_member": false
}
```

**レスポンス例**:
```json
{
  "success": true,
  "booking_number": "BK20260304-001",
  "booking_id": 1
}
```

**使用箇所**:
- お客様画面 > 支払い方法選択画面（銀行振込選択時）
- ボタン: 予約確定ボタン

---

#### 5. 決済完了後の予約作成　✖

**エンドポイント**: `POST /api/v2/bookings/create-from-payment`

**認証**: 不要

**参照テーブル**:
- `members` (会員テーブル - メールアドレス検索)
- `events` (イベントテーブル - event_id検証)
- `bookings` (予約テーブル - 予約番号の連番生成)

**書き込みテーブル**:
- `members` (会員テーブル - is_new_member=1の場合、新規会員登録)
- `bookings` (予約テーブル - INSERT, gmo_order_id保存)
- `booking_items` (予約明細テーブル - INSERT)
- `booking_payments` (支払い情報テーブル - INSERT, GMO決済情報保存)
- `product_stocks` (商品在庫テーブル - UPDATE remaining_quantity)

**リクエストボディ**:
```json
{
  "event_id": 4,
  "event_name": "東京スカイツリー®展望台入場券",
  "participation_date": "2026-03-15",
  "stock_id": 43,
  "booker": { /* 予約者情報 */ },
  "participants": [ /* 参加者情報 */ ],
  "items": [ /* 商品情報 */ ],
  "total_amount": 20000,
  "payment_method": "credit_card",
  "temp_order_id": "TEMP-1772613399524-hv8j58",
  "gmo_order_id": "TEMP-1772613399524-hv8j58",
  "gmo_details": {
    "transactionresult": {
      "AccessID": "ffbfef...",
      "AccessPass": "cca105...",
      "OrderID": "TEMP-1772613399524-hv8j58",
      "Result": "PAYSUCCESS"
    }
  }
}
```

**レスポンス例**:
```json
{
  "success": true,
  "booking_number": "BK20260304-001",
  "message": "予約が完了しました"
}
```

**使用箇所**:
- お客様画面 > 決済コールバック画面（payment-callback.html）
- ボタン: GMO決済完了後の自動処理

---

#### 6. 予約明細追加

**エンドポイント**: `POST /api/v2/bookings/:booking_number/items`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)
- `products` (商品テーブル - item_type='product'の場合)
- `product_stocks` (商品在庫テーブル - 在庫確認)

**書き込みテーブル**:
- `booking_items` (予約明細テーブル - INSERT)
- `product_stocks` (商品在庫テーブル - UPDATE remaining_quantity)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**リクエストボディ**:
```json
{
  "item_type": "product",        // 商品タイプ（product/option/custom）
  "item_id": 9,                   // products.id を参照
  "item_name": "天望回廊（450m）",
  "quantity": 1,
  "unit_price": 8000,
  "subtotal": 8000,
  "price_category": "B-大人",
  "participation_date": "2026-03-15",
  "stock_id": 109,
  "participants": []
}
```

**レスポンス例**:
```json
{
  "success": true,
  "item_id": 94,
  "message": "商品を追加しました"
}
```

**使用箇所**:
- 管理画面 > 予約編集画面
- ボタン: 「別のプランを追加」ボタン → 商品選択 → 「選択した商品を追加」ボタン

---

#### 7. 予約明細の参加者情報更新

**エンドポイント**: `PUT /api/v2/booking-items/:item_id/participants`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_items` (予約明細テーブル - item_id検証、participantsカラム読み込み)

**書き込みテーブル**:
- `booking_items` (予約明細テーブル - UPDATE participants, modified_at)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| item_id | integer | ○ | 予約明細ID |

**リクエストボディ**:
```json
{
  "participants": [
    {
      "lastname_kanji": "山田",
      "firstname_kanji": "太郎",
      "lastname_kana": "ヤマダ",
      "firstname_kana": "タロウ",
      "age": 35,
      "gender": "1",
      "email": "yamada@example.com",
      "phone": "090-1234-5678",
      "custom_fields": {
        "アレルギー": "なし",
        "緊急連絡先": "080-9876-5432"
      }
    }
  ]
}
```

**レスポンス例**:
```json
{
  "success": true,
  "message": "参加者情報を更新しました"
}
```

**使用箇所**:
- 管理画面 > 予約編集画面
- ボタン: 「保存」ボタン（参加者情報変更後）

---

#### 8. 予約明細の数量変更

**エンドポイント**: `PUT /api/v2/booking-items/:item_id/quantity`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_items` (予約明細テーブル - item_id検証、現在の数量取得)
- `product_stocks` (商品在庫テーブル - 在庫確認)

**書き込みテーブル**:
- `booking_items` (予約明細テーブル - UPDATE quantity, subtotal, modified_at)
- `product_stocks` (商品在庫テーブル - UPDATE remaining_quantity)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| item_id | integer | ○ | 予約明細ID |

**リクエストボディ**:
```json
{
  "quantity": 3
}
```

**レスポンス例**:
```json
{
  "success": true,
  "item": {
    "id": 93,
    "quantity": 3,
    "unit_price": 10000,
    "subtotal": 30000
  }
}
```

**使用箇所**:
- 管理画面 > 予約編集画面
- ボタン: 数量入力フィールドの変更（onchangeイベント）

---

#### 9. 予約明細の参加日変更

**エンドポイント**: ※ 現在はフロントエンドのみで処理（APIなし）

**使用箇所**:
- 管理画面 > 予約編集画面
- ボタン: 参加日入力フィールドの変更（onchangeイベント）

---

#### 10. 予約キャンセル

**エンドポイント**: `POST /api/bookings/:booking_number/cancel`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)
- `booking_items` (予約明細テーブル - stock_id取得)

**書き込みテーブル**:
- `bookings` (予約テーブル - UPDATE status='canceled')
- `booking_items` (予約明細テーブル - UPDATE status='canceled', canceled_at, cancel_reason)
- `product_stocks` (商品在庫テーブル - UPDATE remaining_quantity 在庫返却)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**リクエストボディ**:
```json
{
  "cancel_reason": "お客様都合によるキャンセル"
}
```

**レスポンス例**:
```json
{
  "success": true,
  "message": "予約をキャンセルしました"
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 「予約をキャンセル」ボタン

---

#### 11. 返金処理

**エンドポイント**: `POST /api/v2/bookings/:booking_number/refund`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)
- `booking_payments` (支払い情報テーブル - 支払い情報取得)

**書き込みテーブル**:
- `booking_payments` (支払い情報テーブル - UPDATE payment_status='refunded', refunded_amount, refund_date)
- `refund_history` (返金履歴テーブル - INSERT)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**リクエストボディ**:
```json
{
  "payment_id": 1,
  "refund_amount": 10000,
  "refund_reason": "部分キャンセル"
}
```

**レスポンス例**:
```json
{
  "success": true,
  "message": "返金処理を実行しました"
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 「返金処理」ボタン

---

#### 12. 予約備考更新

**エンドポイント**: `PUT /api/v2/bookings/:booking_number/notes`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)

**書き込みテーブル**:
- `bookings` (予約テーブル - UPDATE remarks, modified_at)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**リクエストボディ**:
```json
{
  "remarks": "特別対応が必要"
}
```

**レスポンス例**:
```json
{
  "success": true,
  "message": "備考を更新しました"
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 備考テキストエリアの「保存」ボタン

---

### 支払いAPI

#### 13. 支払い作成

**エンドポイント**: `POST /api/v2/booking-payments`

**認証**: 不要

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)
- `booking_payments` (支払い情報テーブル - payment_numberの連番生成)

**書き込みテーブル**:
- `booking_payments` (支払い情報テーブル - INSERT)
- `booking_items` (予約明細テーブル - UPDATE payment_id)

**リクエストボディ**:
```json
{
  "booking_number": "BK20260304-001",
  "payment_type": "immediate",
  "payment_method": "credit_card",
  "amount": 20000
}
```

**レスポンス例**:
```json
{
  "success": true,
  "payment": {
    "id": 1,
    "payment_number": "PAY20260304-001",
    "booking_number": "BK20260304-001",
    "payment_status": "pending",
    "amount": 20000
  }
}
```

**使用箇所**:
- 管理画面 > 予約編集画面
- ボタン: 「支払いを追加」ボタン

---

#### 14. 支払いステータス更新

**エンドポイント**: `PUT /api/v2/booking-payments/:id/status`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_payments` (支払い情報テーブル - id検証)

**書き込みテーブル**:
- `booking_payments` (支払い情報テーブル - UPDATE payment_status, payment_date, modified_at)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| id | integer | ○ | 支払いID |

**リクエストボディ**:
```json
{
  "payment_status": "completed",
  "payment_date": "2026-03-04"
}
```

**レスポンス例**:
```json
{
  "success": true,
  "message": "支払いステータスを更新しました"
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 支払いステータスプルダウン変更 → 「更新」ボタン

---

#### 15. 支払い削除

**エンドポイント**: `DELETE /api/v2/booking-payments/:id`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_payments` (支払い情報テーブル - id検証)
- `booking_items` (予約明細テーブル - payment_id確認)

**書き込みテーブル**:
- `booking_payments` (支払い情報テーブル - DELETE)
- `booking_items` (予約明細テーブル - UPDATE payment_id=NULL)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| id | integer | ○ | 支払いID |

**レスポンス例**:
```json
{
  "success": true,
  "message": "支払い情報を削除しました"
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 「支払いを削除」ボタン

---

### メッセージAPI

#### 16. メッセージ一覧取得

**エンドポイント**: `GET /api/v2/bookings/:booking_number/messages`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_messages` (予約メッセージテーブル - booking_numberで検索)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**レスポンス例**:
```json
{
  "messages": [
    {
      "id": 1,
      "title": "予約確認のお知らせ",
      "message": "ご予約いただきありがとうございます。",
      "recipient_email": "yamada@example.com",
      "scheduled_send_at": "2026-03-04 16:00:00",
      "send_status": "sent",
      "sent_at": "2026-03-04 16:00:05"
    }
  ]
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 「メッセージ」タブクリック

---

#### 17. メッセージ作成

**エンドポイント**: `POST /api/v2/bookings/:booking_number/messages`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)

**書き込みテーブル**:
- `booking_messages` (予約メッセージテーブル - INSERT)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**リクエストボディ**:
```json
{
  "title": "リマインダー",
  "message": "イベント開催日が近づいています。",
  "recipient_email": "yamada@example.com",
  "scheduled_send_at": "2026-03-14 09:00:00",
  "display_on_mypage": 1
}
```

**レスポンス例**:
```json
{
  "success": true,
  "message_id": 2
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 「新規メッセージ」ボタン → 入力 → 「送信」ボタン

---

#### 18. メッセージ更新

**エンドポイント**: `PUT /api/v2/booking-messages/:id`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_messages` (予約メッセージテーブル - id検証)

**書き込みテーブル**:
- `booking_messages` (予約メッセージテーブル - UPDATE message_text, modified_at)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| id | integer | ○ | メッセージID |

**リクエストボディ**:
```json
{
  "title": "リマインダー（更新）",
  "message": "イベント開催日が近づいています。お忘れなく。",
  "scheduled_send_at": "2026-03-14 10:00:00"
}
```

**レスポンス例**:
```json
{
  "success": true,
  "message": "メッセージを更新しました"
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: メッセージの「編集」ボタン → 入力 → 「更新」ボタン

---

#### 19. メッセージ削除

**エンドポイント**: `DELETE /api/v2/booking-messages/:id`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_messages` (予約メッセージテーブル - id検証)

**書き込みテーブル**:
- `booking_messages` (予約メッセージテーブル - DELETE)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| id | integer | ○ | メッセージID |

**レスポンス例**:
```json
{
  "success": true,
  "message": "メッセージを削除しました"
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: メッセージの「削除」ボタン → 確認ダイアログ → 「はい」

---

### メールAPI

#### 20. メール一覧取得

**エンドポイント**: `GET /api/v2/bookings/:booking_number/emails`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_emails` (予約メールテーブル - booking_numberで検索)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |

**レスポンス例**:
```json
{
  "emails": [
    {
      "id": 1,
      "subject": "【予約確認】東京スカイツリー®展望台入場券",
      "to_email": "yamada@example.com",
      "scheduled_send_at": "2026-03-04 15:35:00",
      "send_status": "sent",
      "sent_at": "2026-03-04 15:35:10"
    }
  ]
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: 「メール」タブクリック

---

#### 21. メール削除

**エンドポイント**: `DELETE /api/v2/booking-emails/:id`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_emails` (予約メールテーブル - id検証)

**書き込みテーブル**:
- `booking_emails` (予約メールテーブル - DELETE)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| id | integer | ○ | メールID |

**レスポンス例**:
```json
{
  "success": true,
  "message": "メールを削除しました"
}
```

**使用箇所**:
- 管理画面 > 予約詳細画面
- ボタン: メールの「削除」ボタン

---

### 商品API

#### 22. 商品一覧取得

**エンドポイント**: `GET /api/v1/products`

**認証**: 不要

**参照テーブル**:
- `products` (商品テーブル - event_idで検索)
- `events` (イベントテーブル - JOIN)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| event_id | integer | ○ | イベントID |
| enable_flg | integer | × | 有効フラグ（0/1） |

**レスポンス例**:
```json
{
  "products": [
    {
      "id": 8,
      "event_id": 4,
      "name": "展望デッキ（350m）",
      "description": "東京スカイツリーの展望デッキチケット",
      "display_order": 0,
      "enable_flg": 1
    }
  ]
}
```

**使用箇所**:
- お客様画面 > 商品詳細画面（product-detail.html）
- ボタン: 画面初期表示

---

#### 23. 商品の価格一覧取得

**エンドポイント**: `GET /api/v2/products/:product_id/prices`

**認証**: 不要

**参照テーブル**:
- `product_prices` (商品価格テーブル - product_idで検索)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| product_id | integer | ○ | 商品ID |

**レスポンス例**:
```json
{
  "prices": [
    {
      "id": 42,
      "price": 10000,
      "price_name": "大人",
      "price_band": "A",
      "category_name": "A-大人",
      "display_order": 0
    },
    {
      "id": 43,
      "price": 2000,
      "price_name": "子供",
      "price_band": "A",
      "category_name": "A-子供",
      "display_order": 0
    }
  ]
}
```

**使用箇所**:
- 管理画面 > 予約編集画面
- ボタン: 「価格帯変更」ボタンクリック

---

#### 24. 商品の在庫一覧取得

**エンドポイント**: `GET /api/v1/products/:product_id/stocks`

**認証**: 不要

**参照テーブル**:
- `product_stocks` (商品在庫テーブル - product_idで検索)
- `product_prices` (商品価格テーブル - JOIN)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| product_id | integer | ○ | 商品ID |
| date_from | string | × | 開始日（YYYY-MM-DD） |
| date_to | string | × | 終了日（YYYY-MM-DD） |

**レスポンス例**:
```json
{
  "stocks": [
    {
      "id": 43,
      "product_id": 8,
      "stock_date": "2026-03-15",
      "total_quantity": 100,
      "available_quantity": 85,
      "reserved_quantity": 15,
      "sold_quantity": 0,
      "enable_flg": 1
    }
  ]
}
```

**使用箇所**:
- お客様画面 > 商品詳細画面
- ボタン: 日付選択カレンダー表示

---

### 参加者CSV API

#### 25. 参加者CSVテンプレートダウンロード

**エンドポイント**: `GET /api/v2/booking-items/:item_id/participants/template`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_items` (予約明細テーブル - item_id検証, item_id取得)
- `product_form_fields` (商品カスタムフィールドテーブル - CSVヘッダー生成)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| item_id | integer | ○ | 予約明細ID |

**レスポンス**: CSV ファイル

**使用箇所**:
- 管理画面 > 予約編集画面
- ボタン: 「CSVテンプレートダウンロード」ボタン

---

#### 26. 参加者CSVアップロード

**エンドポイント**: `POST /api/v2/booking-items/:item_id/participants/upload`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `booking_items` (予約明細テーブル - item_id検証, item_id取得)
- `product_form_fields` (商品カスタムフィールドテーブル - CSVバリデーション)

**書き込みテーブル**:
- `booking_items` (予約明細テーブル - UPDATE participants, modified_at)

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| item_id | integer | ○ | 予約明細ID |

**リクエスト**: multipart/form-data（CSVファイル）

**レスポンス例**:
```json
{
  "success": true,
  "imported_count": 10,
  "message": "10件の参加者情報をインポートしました"
}
```

**使用箇所**:
- 管理画面 > 予約編集画面
- ボタン: 「CSVアップロード」ボタン → ファイル選択

---

### GMO決済API

#### 27. GMO決済URL取得　✖

**エンドポイント**: `POST /api/v2/gmo/get-payment-url`

**認証**: 不要

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)

**書き込みテーブル**:
- `bookings` (予約テーブル - UPDATE gmo_order_id, gmo_access_id, gmo_access_pass)
- `gmo_payment_logs` (GMO決済ログテーブル - INSERT)

**リクエストボディ**:
```json
{
  "booking_number": "TEMP-1772613399524-hv8j58",
  "payment_method": "credit",
  "amount": 20000,
  "tax": 0,
  "customer_info": {
    "email": "yamada@example.com",
    "family_name": "山田",
    "first_name": "太郎",
    "family_kana": "ヤマダ",
    "first_kana": "タロウ",
    "tel": "090-1234-5678"
  }
}
```

**レスポンス例**:
```json
{
  "success": true,
  "link_url": "https://pt01.mul-pay.jp/link/..."
}
```

**使用箇所**:
- お客様画面 > 支払い方法選択画面（payment-method.html）
- ボタン: 「クレジットカードで支払う」ボタン / 「コンビニで支払う」ボタン

---

### マイページAPI

#### 28. マイページ予約一覧取得　✖

**エンドポイント**: `GET /api/mypage/bookings`

**認証**: 必要（OTP認証）

**参照テーブル**:
- `bookings` (予約テーブル - member_idで検索)
- `members` (会員テーブル - OTP認証、member_id取得)
- `events` (イベントテーブル - JOIN)
- `booking_items` (予約明細テーブル - 金額集計)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| email | string | ○ | メールアドレス |

**レスポンス例**:
```json
{
  "bookings": [
    {
      "id": 1,
      "booking_number": "BK20260304-001",
      "event_name": "東京スカイツリー®展望台入場券",
      "status": "active",
      "total_amount": 20000,
      "created_at": "2026-03-04 15:30:00"
    }
  ]
}
```

**使用箇所**:
- お客様画面 > マイページ（mypage.html）
- ボタン: 画面初期表示

---

#### 29. マイページ予約詳細取得　✖

**エンドポイント**: `GET /api/mypage/bookings/:booking_number`

**認証**: 必要（OTP認証 or セキュアトークン）

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証、secure_tokenマッチ確認)
- `members` (会員テーブル - OTP認証)
- `events` (イベントテーブル - JOIN)
- `booking_items` (予約明細テーブル)
- `products` (商品テーブル - JOIN)
- `booking_payments` (支払い情報テーブル)

**書き込みテーブル**: なし（参照のみ）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| booking_number | string | ○ | 予約番号 |
| token | string | × | セキュアトークン |

**レスポンス例**:
```json
{
  "booking": {
    "id": 1,
    "booking_number": "BK20260304-001",
    "event_name": "東京スカイツリー®展望台入場券",
    "status": "active",
    "booker_name": "山田 太郎",
    "booker_email": "yamada@example.com"
  },
  "items": [ /* 予約明細 */ ],
  "messages": [ /* メッセージ */ ]
}
```

**使用箇所**:
- お客様画面 > マイページ予約詳細（mypage-booking-detail.html）
- ボタン: 予約番号リンククリック

---

### 一括処理API

#### 30. 一括メッセージ登録（CSVアップロード）

**エンドポイント**: `POST /api/booking-messages/bulk-upload`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - 予約番号検証、booking_id取得)
- `members` (会員テーブル - メールアドレス検証)

**書き込みテーブル**:
- `booking_messages` (予約メッセージテーブル - INSERT)

**リクエストボディ**: `multipart/form-data`
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| csv_file | File | ○ | CSVファイル（最大1000行） |
| display_on_mypage | string | × | マイページ表示フラグ（'1' or 'true'） |

**CSVフォーマット**:
```csv
予約番号,メールアドレス,タイトル,メッセージ,送信日時
BK20260304-001,user@example.com,リマインダー,明日のイベントです,2026/03/15 10:00
BK20260304-002,user2@example.com,リマインダー,明日のイベントです,2026/03/15 10:00
```

**処理フロー**:
1. CSVファイルをアップロード・解析（ヘッダー行をスキップ）
2. 各行について：
   - 予約番号の存在確認（`bookings`テーブル）
   - メールアドレスの一致確認（`members`テーブル）
   - 送信日時のフォーマット変換（YYYY/MM/DD HH:MM → YYYY-MM-DD HH:MM:SS）
   - `booking_messages`テーブルにINSERT
3. 成功・失敗件数を集計して返却

**レスポンス例**:
```json
{
  "total": 100,
  "success_count": 98,
  "error_count": 2,
  "results": {
    "success": [
      { "line": 2, "booking_number": "BK20260304-001" },
      { "line": 3, "booking_number": "BK20260304-002" }
    ],
    "errors": [
      { "line": 10, "error": "予約番号「BK20260304-XXX」が存在しません" },
      { "line": 15, "error": "メールアドレスが予約と一致しません" }
    ]
  }
}
```

**バリデーション**:
- CSVファイルの存在確認
- 最大行数チェック（1000行）
- 必須項目チェック（予約番号、メールアドレス、タイトル、メッセージ、送信日時）
- 予約番号の存在確認
- メールアドレスの一致確認
- 送信日時のフォーマット検証

**使用箇所**:
- 管理画面 > 一括メッセージ登録画面（admin-bulk-messages.html）
- ボタン: CSVアップロードボタン

---

#### 31. 一括メール送信（プレビュー）

**エンドポイント**: `POST /api/v2/bulk-emails/preview`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)
- `members` (会員テーブル - JOIN、顧客情報取得)
- `events` (イベントテーブル - JOIN、イベント情報取得)
- `clients` (クライアントテーブル - JOIN、クライアント情報取得)
- `organizers` (主催者テーブル - JOIN、主催者情報取得)

**書き込みテーブル**: なし（プレビューのみ）

**リクエストボディ**:
```json
{
  "booking_number": "BK20260304-001",
  "subject_template": "【{{event_name}}】ご予約確認",
  "body_template": "{{customer_name}} 様\n\nご予約番号: {{booking_number}}\nイベント: {{event_name}}\n開催日: {{event_start_date}}"
}
```

**テンプレート変数**:
| 変数名 | 説明 | テーブル/カラム |
|--------|------|----------------|
| `{{booking_number}}` | 予約番号 | bookings.booking_number |
| `{{booking_status}}` | 予約ステータス | bookings.status |
| `{{booker_name}}` | 予約者名 | bookings.booker_name |
| `{{booker_email}}` | 予約者メール | bookings.booker_email |
| `{{booker_phone}}` | 予約者電話 | bookings.booker_phone |
| `{{customer_name}}` | 顧客名（姓名） | members.family_name + first_name |
| `{{customer_name_kana}}` | 顧客名カナ | members.family_kana + first_kana |
| `{{customer_email}}` | 顧客メール | members.email |
| `{{customer_phone}}` | 顧客電話 | members.mobile |
| `{{customer_zip}}` | 顧客郵便番号 | members.zip |
| `{{customer_address}}` | 顧客住所 | members.address |
| `{{event_name}}` | イベント名 | events.name |
| `{{event_start_date}}` | イベント開始日 | events.event_start_date |
| `{{event_end_date}}` | イベント終了日 | events.event_end_date |
| `{{client_name}}` | クライアント名 | clients.name |
| `{{organizer_name}}` | 主催者名 | organizers.name |

**レスポンス例**:
```json
{
  "success": true,
  "preview": {
    "to_email": "yamada@example.com",
    "subject": "【東京スカイツリー®展望台入場券】ご予約確認",
    "body": "山田 太郎 様\n\nご予約番号: BK20260304-001\nイベント: 東京スカイツリー®展望台入場券\n開催日: 2026-03-15"
  }
}
```

**使用箇所**:
- 管理画面 > 一括メール送信画面（admin-bulk-emails.html）
- ボタン: プレビューボタン

---

#### 32. 一括メール送信（登録）

**エンドポイント**: `POST /api/v2/bulk-emails/register`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - booking_number検証)
- `members` (会員テーブル - JOIN、メールアドレス取得)
- `events` (イベントテーブル - JOIN)
- `clients` (クライアントテーブル - JOIN)
- `organizers` (主催者テーブル - JOIN)

**書き込みテーブル**:
- `booking_emails` (予約メールテーブル - INSERT)

**リクエストボディ**:
```json
{
  "from_email": "info@example.com",
  "bcc_email": "admin@example.com",
  "subject_template": "【{{event_name}}】ご予約確認",
  "body_template": "{{customer_name}} 様...",
  "scheduled_send_at": "2026-03-15 10:00:00",
  "booking_numbers": ["BK20260304-001", "BK20260304-002", "BK20260304-003"],
  "template_id": 1
}
```

**処理フロー（バックグラウンド処理）**:
1. ジョブIDを生成（`job_TIMESTAMP_RANDOM`）
2. `c.executionCtx.waitUntil()`でバックグラウンド処理を開始
3. 各予約番号について：
   - 予約情報を取得（bookings JOIN members JOIN events JOIN clients JOIN organizers）
   - メールアドレスの存在確認
   - テンプレート変数を埋め込み（`fillEmailTemplate()`関数）
   - `booking_emails`テーブルにINSERT（send_status='pending'）
4. 成功・失敗件数を集計（コンソールログ）

**レスポンス例**:
```json
{
  "success": true,
  "job_id": "job_1772613399524_abc123",
  "total": 100,
  "message": "メール登録を開始しました"
}
```

**バックグラウンド処理詳細**:
- 関数: `processBulkEmails(DB, jobId, params)`
- 処理内容:
  1. 各予約番号をループ処理
  2. 予約情報 + 会員情報 + イベント情報をJOINして取得
  3. メールアドレスが未登録の場合はスキップ（エラー配列に追加）
  4. テンプレート埋め込み（`fillEmailTemplate()`関数）
  5. `booking_emails`テーブルにINSERT
  6. 成功・失敗件数をコンソールログに出力

**使用箇所**:
- 管理画面 > 一括メール送信画面（admin-bulk-emails.html）
- ボタン: 一括登録ボタン

---

#### 33. 一括メール送信ステータス取得

**エンドポイント**: `GET /api/v2/bulk-emails/status/:jobId`

**認証**: 不要

**参照テーブル**: なし（現在の実装では常に完了ステータスを返す）

**書き込みテーブル**: なし

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| jobId | string | ○ | ジョブID |

**レスポンス例**:
```json
{
  "success": true,
  "job_id": "job_1772613399524_abc123",
  "status": "completed",
  "message": "メール登録が完了しました"
}
```

**注意**: 現在の実装では簡略化されており、常に完了ステータスを返します。本来はKVストレージに実際のステータスを保存すべきです。

**使用箇所**:
- 管理画面 > 一括メール送信画面（admin-bulk-emails.html）
- ボタン: ステータスポーリング

---

#### 34. 帳票一括生成

**エンドポイント**: `POST /api/v2/bulk-documents/generate`

**認証**: 必要（Basic Auth）

**参照テーブル**:
- `bookings` (予約テーブル - 予約データ取得)
- `members` (会員テーブル - JOIN、顧客情報取得)
- `events` (イベントテーブル - JOIN、イベント情報取得)
- `booking_items` (予約明細テーブル - JOIN、明細情報取得)
- `products` (商品テーブル - JOIN、商品情報取得)

**書き込みテーブル**:
- `booking_files` (予約ファイルテーブル - INSERT、生成PDFの情報登録)

**外部API**:
- **CloudConvert API** (`https://api.cloudconvert.com/v2/jobs`)
  - 用途: Excel → PDF変換
  - 認証: Bearer Token（`CLOUDCONVERT_API_KEY`環境変数）
  - 処理フロー: ジョブ作成 → ファイルアップロード → 変換完了待機 → PDFダウンロード

**リクエストボディ**: `multipart/form-data`
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| excel_template | File | ○ | Excelテンプレートファイル |
| booking_csv | File | ○ | 予約番号CSVファイル |

**CSVフォーマット**:
```csv
予約番号
BK20260304-001
BK20260304-002
BK20260304-003
```

**処理フロー（バックグラウンド処理）**:
1. **CSV解析**: 予約番号リストを抽出
2. **ジョブ初期化**: 
   - ジョブIDを生成（`job_TIMESTAMP_RANDOM`）
   - KVストレージに初期ステータスを保存（TTL: 24時間）
3. **バックグラウンド処理開始** (`processBulkDocuments()`):
   ```
   各予約番号について：
   a) 予約データ取得（getBookingData()）
      - bookings JOIN members JOIN events JOIN booking_items JOIN products
   b) Excelテンプレートにデータ埋め込み（fillExcelTemplate()）
      - xlsxライブラリを使用してセル値を置換
   c) Excel → PDF変換（convertExcelToPdf()）
      【CloudConvert API処理】:
      ① ジョブ作成（3タスク定義）
         - upload-file: import/upload
         - convert-file: convert (input=upload-file, output_format=pdf, engine=office)
         - export-file: export/url (input=convert-file)
      ② Excelファイルをアップロード
         - CloudConvertが提供するFormDataでPOST
      ③ 変換完了待機（ポーリング、最大60回×2秒=2分）
         - export-fileタスクのstatusが'finished'になるまで待機
      ④ PDFダウンロード
         - export-fileタスクのresult.files[0].urlからPDFを取得
   d) R2ストレージにPDFアップロード（uploadToR2()）
      - ファイル名: {テンプレート名}_{予約番号}_{YYYYMMDD}.pdf
   e) booking_filesテーブルに登録（registerBookingFile()）
      - file_key, original_filename, file_size等を保存
   f) KVステータス更新（進捗状況を保存）
   ```

**CloudConvert API詳細**:
```json
// ジョブ作成リクエスト
POST https://api.cloudconvert.com/v2/jobs
Authorization: Bearer ${CLOUDCONVERT_API_KEY}
Content-Type: application/json

{
  "tasks": {
    "upload-file": {
      "operation": "import/upload"
    },
    "convert-file": {
      "operation": "convert",
      "input": "upload-file",
      "output_format": "pdf",
      "engine": "office"
    },
    "export-file": {
      "operation": "export/url",
      "input": "convert-file"
    }
  }
}

// レスポンス
{
  "data": {
    "id": "cloudconvert-job-id",
    "tasks": [
      {
        "name": "upload-file",
        "status": "waiting",
        "result": {
          "form": {
            "url": "https://upload.cloudconvert.com/...",
            "parameters": { /* アップロード用パラメータ */ }
          }
        }
      }
    ]
  }
}

// ファイルアップロード
POST https://upload.cloudconvert.com/...
Content-Type: multipart/form-data

// ジョブステータス確認
GET https://api.cloudconvert.com/v2/jobs/${jobId}
Authorization: Bearer ${CLOUDCONVERT_API_KEY}

// レスポンス（完了時）
{
  "data": {
    "tasks": [
      {
        "name": "export-file",
        "status": "finished",
        "result": {
          "files": [{
            "url": "https://storage.cloudconvert.com/.../output.pdf"
          }]
        }
      }
    ]
  }
}
```

**レスポンス例**:
```json
{
  "success": true,
  "job_id": "job_1772613399524_xyz789",
  "total": 50,
  "message": "処理を開始しました"
}
```

**Cloudflare Workers制約**:
- CPU時間制限: 無料プラン10ms、有料プラン30ms（サブリクエストは別カウント）
- 全処理を逐次実行（並列処理不可）
- CloudConvert API呼び出しは外部リクエストのためCPU時間にカウントされない

**エラーハンドリング**:
- 予約が見つからない → results配列にエラー追加、次の予約へ
- CloudConvert変換タイムアウト（2分） → エラー追加
- R2アップロード失敗 → エラー追加
- 全体エラー → KVにfailedステータスを保存

**使用箇所**:
- 管理画面 > 帳票一括生成画面（admin-bulk-documents.html）
- ボタン: 一括生成開始ボタン

---

#### 35. 帳票一括生成ステータス取得

**エンドポイント**: `GET /api/v2/bulk-documents/status/:job_id`

**認証**: 不要

**参照テーブル**: なし（KVストレージから取得）

**書き込みテーブル**: なし

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| job_id | string | ○ | ジョブID |

**レスポンス例**:
```json
{
  "job_id": "job_1772613399524_xyz789",
  "status": "processing",
  "total": 50,
  "completed": 25,
  "errors": 2,
  "results": [
    {
      "booking_number": "BK20260304-001",
      "status": "success",
      "filename": "template_BK20260304-001_20260304.pdf",
      "file_id": 123,
      "error": null
    },
    {
      "booking_number": "BK20260304-002",
      "status": "error",
      "filename": null,
      "error": "予約が見つかりません"
    }
  ],
  "created_at": "2026-03-04T15:30:00.000Z"
}
```

**ステータス値**:
- `pending`: 処理待機中
- `processing`: 処理中
- `completed`: 処理完了
- `failed`: 処理失敗

**KVストレージ**:
- キー: `bulk-documents:{job_id}`
- TTL: 24時間（86400秒）

**使用箇所**:
- 管理画面 > 帳票一括生成画面（admin-bulk-documents.html）
- ボタン: ステータスポーリング（自動更新）

---

#### 36. マイページ参加者情報更新

**エンドポイント**: `POST /api/mypage/booking/:id/update-participants`

**認証**: 必要（セキュアトークン）

**パラメータ**:
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| id | integer | ○ | 予約ID |

**リクエストボディ**:
```json
{
  "token": "secure-token-12345",
  "participants": [ /* 参加者情報 */ ]
}
```

**レスポンス例**:
```json
{
  "success": true,
  "message": "参加者情報を更新しました"
}
```

**使用箇所**:
- お客様画面 > マイページ参加者情報編集
- ボタン: 「保存」ボタン

---

## 画面仕様

### 管理画面

#### 1. 予約一覧画面（bookings-list.html）

**URL**: `/bookings-list.html`

**機能**:
- 予約一覧の表示・検索
- 予約詳細へのリンク
- 予約編集へのリンク
- CSVエクスポート

**使用API**:
- `GET /api/v2/bookings` - 予約一覧取得
- `GET /api/bookings/export/csv` - CSVエクスポート

**操作ボタン**:
- 検索ボタン
- CSVエクスポートボタン
- 詳細ボタン（各予約行）
- 編集ボタン（各予約行）

---

#### 2. 予約詳細画面（bookings-detail.html）

**URL**: `/bookings-detail.html?id=BK20260304-001`

**機能**:
- 予約詳細情報の表示
- 予約明細の表示
- 支払い情報の表示・編集
- メッセージ管理
- メール履歴表示
- 予約キャンセル
- 返金処理
- 備考編集

**使用API**:
- `GET /api/v2/bookings/:booking_number` - 予約詳細取得
- `GET /api/v2/bookings/:booking_number/messages` - メッセージ一覧取得
- `GET /api/v2/bookings/:booking_number/emails` - メール一覧取得
- `POST /api/v2/bookings/:booking_number/messages` - メッセージ作成
- `PUT /api/v2/booking-messages/:id` - メッセージ更新
- `DELETE /api/v2/booking-messages/:id` - メッセージ削除
- `DELETE /api/v2/booking-emails/:id` - メール削除
- `PUT /api/v2/bookings/:booking_number/notes` - 備考更新
- `POST /api/bookings/:booking_number/cancel` - 予約キャンセル
- `POST /api/v2/bookings/:booking_number/refund` - 返金処理
- `PUT /api/v2/booking-payments/:id/status` - 支払いステータス更新
- `DELETE /api/v2/booking-payments/:id` - 支払い削除

**操作ボタン**:
- 編集ボタン
- 予約キャンセルボタン
- 返金処理ボタン
- 新規メッセージボタン
- メッセージ編集ボタン
- メッセージ削除ボタン
- メール削除ボタン
- 備考保存ボタン
- 支払いステータス更新ボタン
- 支払い削除ボタン

---

#### 3. 予約編集画面（bookings-edit.html）

**URL**: `/bookings-edit.html?id=BK20260304-001`

**機能**:
- 予約明細の編集
- 参加者情報の編集
- 参加者CSVアップロード/ダウンロード
- 数量変更
- 価格帯変更
- 参加日変更
- 別プランの追加

**使用API**:
- `GET /api/v2/bookings/:booking_number/edit-data` - 編集用データ取得
- `PUT /api/v2/booking-items/:item_id/participants` - 参加者情報更新
- `PUT /api/v2/booking-items/:item_id/quantity` - 数量変更
- `GET /api/v2/products/:product_id/prices` - 価格帯一覧取得
- `GET /api/v2/booking-items/:item_id/participants/template` - CSVテンプレート
- `POST /api/v2/booking-items/:item_id/participants/upload` - CSVアップロード
- `POST /api/v2/bookings/:booking_number/items` - 明細追加
- `POST /api/v2/booking-items` - カスタム商品作成

**操作ボタン**:
- 保存ボタン
- 価格帯変更ボタン
- 数量変更（inputフィールド）
- 参加日変更（inputフィールド）
- CSVテンプレートダウンロードボタン
- CSVアップロードボタン
- 別のプランを追加ボタン
- 商品選択確定ボタン
- カスタム商品作成ボタン

---

### お客様画面

#### 4. 商品詳細画面（product-detail.html）

**URL**: `/product-detail/skytree`

**機能**:
- イベント情報表示
- 商品一覧表示
- 在庫確認
- 日付選択
- 商品選択
- カート機能

**使用API**:
- `GET /api/events/by-url/:event_url` - イベント情報取得
- `GET /api/v1/products` - 商品一覧取得
- `GET /api/v1/products/:product_id/stocks` - 在庫一覧取得

**操作ボタン**:
- 日付選択カレンダー
- 商品選択ボタン
- 予約へ進むボタン

---

#### 5. 参加者情報入力画面（participant-info.html）

**URL**: `/participant-info.html`

**機能**:
- 予約者情報入力
- 参加者情報入力
- カスタムフィールド入力
- 会員登録オプション

**使用API**: なし（フロントエンドのみ、LocalStorageに保存）

**操作ボタン**:
- 次へボタン
- 戻るボタン

---

#### 6. 支払い方法選択画面（payment-method.html）

**URL**: `/payment-method.html`

**機能**:
- 決済方法選択
- 予約内容確認
- GMO決済連携
- 銀行振込予約作成

**使用API**:
- `POST /api/v2/bookings` - 予約作成（銀行振込）
- `POST /api/v2/gmo/get-payment-url` - GMO決済URL取得

**操作ボタン**:
- クレジットカードで支払うボタン
- コンビニで支払うボタン
- 銀行振込で予約するボタン
- 戻るボタン

---

#### 7. 決済コールバック画面（payment-callback.html）

**URL**: `/payment-callback?OrderID=xxx&Result=PAYSUCCESS`

**機能**:
- GMO決済結果受信
- 予約作成
- 予約完了画面へリダイレクト

**使用API**:
- `POST /api/v2/bookings/create-from-payment` - 決済完了後の予約作成

**操作ボタン**: なし（自動処理）

---

#### 8. 予約完了画面（booking-complete.html）

**URL**: `/booking-complete?booking_number=BK20260304-001`

**機能**:
- 予約完了メッセージ表示
- 予約番号表示
- マイページへのリンク

**使用API**: なし

**操作ボタン**:
- マイページへボタン
- トップページへボタン

---

#### 9. マイページ（mypage.html）

**URL**: `/mypage`

**機能**:
- メール認証（OTP）
- 予約一覧表示
- 予約詳細へのリンク

**使用API**:
- `POST /api/auth/send-otp` - OTP送信
- `POST /api/auth/verify-otp` - OTP認証
- `GET /api/mypage/bookings` - 予約一覧取得

**操作ボタン**:
- OTP送信ボタン
- ログインボタン
- 予約詳細ボタン

---

#### 10. マイページ予約詳細（mypage-booking-detail.html）

**URL**: `/mypage/booking/:id?token=xxx`

**機能**:
- 予約詳細表示
- 参加者情報編集
- メッセージ表示
- ファイルダウンロード

**使用API**:
- `GET /api/mypage/bookings/:booking_number` - 予約詳細取得
- `POST /api/mypage/booking/:id/update-participants` - 参加者情報更新
- `GET /api/v2/bookings/:booking_number/files/:file_id` - ファイルダウンロード

**操作ボタン**:
- 参加者情報編集ボタン
- 保存ボタン
- ファイルダウンロードボタン

---

## 補足情報

### 環境変数

```env
# データベース
D1_DATABASE_ID=your-database-id

# GMO決済
GMO_SHOP_ID=your-shop-id
GMO_SHOP_PASS=your-shop-pass
GMO_CONFIG_ID=your-config-id
GMO_API_URL=https://pt01.mul-pay.jp

# Basic認証（管理画面）
BASIC_AUTH_USER=admin
BASIC_AUTH_PASS=your-password

# アプリケーションモード
APP_MODE=all  # all / customer / admin
```

### セキュリティ

- 管理画面APIはすべてBasic認証が必要
- お客様向けAPIは認証不要（公開API）
- マイページAPIはOTP認証またはセキュアトークンが必要
- パスワードはbcryptでハッシュ化して保存
- GMO決済情報はJSON形式で暗号化保存

### パフォーマンス

- D1データベースはCloudflareエッジで動作
- 静的ファイルはCloudflare CDNでキャッシュ
- APIレスポンスは適切なキャッシュヘッダーを設定

---

**作成日**: 2026-03-04  
**バージョン**: 1.0  
**最終更新**: 2026-03-04
