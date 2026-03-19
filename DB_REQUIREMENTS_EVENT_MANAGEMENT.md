# イベント管理 データベース要件仕様書

**バージョン**: 1.0  
**作成日**: 2026-01-28  
**対象システム**: イベント予約管理システム

---

## 目次

1. [概要](#概要)
2. [データベース設計方針](#データベース設計方針)
3. [テーブル仕様](#テーブル仕様)
4. [ER図](#er図)
5. [データ整合性ルール](#データ整合性ルール)
6. [パフォーマンス要件](#パフォーマンス要件)
7. [セキュリティ要件](#セキュリティ要件)
8. [バックアップ・リカバリ要件](#バックアップリカバリ要件)

---

## 概要

### システム概要
イベント予約管理システムのイベント管理機能に関連するデータベース要件を定義します。

### データベース基本情報
- **DBMS**: Cloudflare D1 (SQLite互換)
- **文字コード**: UTF-8
- **タイムゾーン**: Asia/Tokyo (JST)
- **日時形式**: `YYYY-MM-DD HH:MM:SS`
- **論理削除**: 使用（deleted_atカラム）

---

## データベース設計方針

### 1. 正規化
- 第3正規形を基本とする
- パフォーマンスが必要な場合は非正規化を検討

### 2. 命名規則
- テーブル名: 複数形の英小文字（例: `events`, `products`）
- カラム名: スネークケース（例: `event_url`, `created_at`）
- 外部キー: `{参照先テーブル}_id`（例: `client_id`, `event_id`）
- フラグ: `{名前}_flg`（例: `enable_flg`, `payment_flg`）

### 3. 論理削除
- 物理削除は行わず、`deleted_at`カラムで論理削除を実装
- `deleted_at IS NULL`で有効データを取得

### 4. タイムスタンプ
- すべてのテーブルに`created_at`と`modified_at`を設け、自動更新

### 5. デフォルト値
- 必要に応じてデフォルト値を設定
- 日時系は`datetime('now', 'localtime')`を使用

---

## テーブル仕様

### 1. events（イベント）

#### 概要
イベントの基本情報を管理するメインテーブル。

#### テーブル定義

```sql
CREATE TABLE events (
  -- 基本情報
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,                    -- イベント名
  detail TEXT,                           -- イベント詳細
  location TEXT,                         -- 開催場所
  contact TEXT NOT NULL,                 -- 連絡先
  remarks TEXT,                          -- 備考
  thanks_msg TEXT,                       -- お礼メッセージ
  
  -- 多言語対応
  name_en TEXT,                          -- イベント名（英語）
  detail_en TEXT,                        -- イベント詳細（英語）
  location_en TEXT,                      -- 開催場所（英語）
  contact_en TEXT,                       -- 連絡先（英語）
  remarks_en TEXT,                       -- 備考（英語）
  thanks_msg_en TEXT,                    -- お礼メッセージ（英語）
  
  -- 組織関連
  client_id INTEGER NOT NULL,            -- クライアントID（FK）
  customer_client_id INTEGER,            -- 顧客クライアントID
  organizer_id INTEGER,                  -- 主催者ID
  vendor_id INTEGER,                     -- ベンダーID
  branch_code TEXT,                      -- 支店コード
  
  -- フラグ
  enable_flg INTEGER DEFAULT 1,          -- 有効フラグ（0:無効, 1:有効）
  payment_flg INTEGER DEFAULT 0,         -- 決済フラグ（0:無料, 1:有料）
  
  -- イベント設定
  event_url TEXT,                        -- イベントURL（一意）
  category TEXT,                         -- カテゴリ
  date_selection_type TEXT DEFAULT 'single',  -- 日付選択タイプ
  event_type TEXT DEFAULT 'standalone',  -- イベントタイプ
  parent_event_id INTEGER,               -- 親イベントID
  
  -- 日程
  event_start_date TEXT,                 -- 開催開始日
  event_end_date TEXT,                   -- 開催終了日
  registration_start_date TEXT,          -- 受付開始日
  registration_end_date TEXT,            -- 受付終了日
  admin_login_start_date TEXT,           -- 管理者ログイン開始日
  admin_login_end_date TEXT,             -- 管理者ログイン終了日
  
  -- メール設定
  admin_email TEXT,                      -- 管理者メールアドレス
  admin_cc_email TEXT,                   -- 管理者CCメールアドレス
  sender_name TEXT,                      -- 送信者名
  sender_email TEXT,                     -- 送信者メールアドレス
  email_signature TEXT,                  -- メール署名
  email_signature_en TEXT,               -- メール署名（英語）
  
  -- 決済設定
  payment_methods TEXT,                  -- 決済方法
  payment_credit_card INTEGER DEFAULT 0, -- クレジットカード決済有効
  payment_bank_transfer INTEGER DEFAULT 0,     -- 銀行振込決済有効
  payment_convenience_store INTEGER DEFAULT 0, -- コンビニ決済有効
  
  -- 銀行振込設定
  bank_name TEXT,                        -- 銀行名
  bank_branch TEXT,                      -- 支店名
  bank_account_type TEXT,                -- 口座種別
  bank_account_number TEXT,              -- 口座番号
  bank_account_name TEXT,                -- 口座名義
  bank_transfer_deadline INTEGER,        -- 銀行振込期限（日数）
  
  -- コンビニ決済設定
  store_code TEXT,                       -- 店舗コード
  convenience_payment_deadline INTEGER,  -- コンビニ決済期限（日数）
  available_convenience_stores TEXT,     -- 利用可能なコンビニ（JSON配列）
  
  -- 手数料設定
  credit_fee_type TEXT,                  -- クレジット手数料タイプ
  credit_fee_percentage REAL,            -- クレジット手数料率（%）
  credit_fee_fixed INTEGER,              -- クレジット手数料固定額
  bank_fee_type TEXT,                    -- 銀行振込手数料タイプ
  bank_fee_percentage REAL,              -- 銀行振込手数料率（%）
  bank_fee_fixed INTEGER,                -- 銀行振込手数料固定額
  convenience_fee_type TEXT,             -- コンビニ決済手数料タイプ
  convenience_fee_percentage REAL,       -- コンビニ決済手数料率（%）
  convenience_fee_fixed INTEGER,         -- コンビニ決済手数料固定額
  
  -- キャンセルポリシー
  cancel_policy TEXT,                    -- キャンセルポリシー
  cancellation_policy_details TEXT,      -- キャンセルポリシー詳細
  cancellation_days_1 INTEGER,           -- キャンセル期限1（日数）
  cancellation_rate_1 INTEGER,           -- キャンセル料率1（%）
  cancellation_days_2 INTEGER,           -- キャンセル期限2（日数）
  cancellation_rate_2 INTEGER,           -- キャンセル料率2（%）
  
  -- フォーム設定
  form_field_settings TEXT,              -- フォーム設定（JSON）
  
  -- 自動返信メール設定
  auto_reply_enabled INTEGER DEFAULT 0,  -- 自動返信有効フラグ
  auto_reply_credit_payment TEXT,        -- クレジット決済完了メール本文
  auto_reply_bank_payment TEXT,          -- 銀行振込案内メール本文
  auto_reply_convenience_payment TEXT,   -- コンビニ決済案内メール本文
  auto_reply_credit_cancel TEXT,         -- クレジット決済キャンセルメール本文
  auto_reply_bank_cancel TEXT,           -- 銀行振込キャンセルメール本文
  auto_reply_convenience_cancel TEXT,    -- コンビニ決済キャンセルメール本文
  auto_reply_credit_refund TEXT,         -- クレジット返金メール本文
  auto_reply_bank_deposit TEXT,          -- 銀行入金確認メール本文
  auto_reply_bank_refund TEXT,           -- 銀行振込返金メール本文
  auto_reply_convenience_deposit TEXT,   -- コンビニ入金確認メール本文
  auto_reply_convenience_refund TEXT,    -- コンビニ決済返金メール本文
  
  -- 自動返信メール設定（英語）
  auto_reply_credit_payment_en TEXT,
  auto_reply_bank_payment_en TEXT,
  auto_reply_convenience_payment_en TEXT,
  auto_reply_credit_cancel_en TEXT,
  auto_reply_bank_cancel_en TEXT,
  auto_reply_convenience_cancel_en TEXT,
  auto_reply_credit_refund_en TEXT,
  auto_reply_bank_deposit_en TEXT,
  auto_reply_bank_refund_en TEXT,
  auto_reply_convenience_deposit_en TEXT,
  auto_reply_convenience_refund_en TEXT,
  
  -- その他
  image_url TEXT,                        -- イベント画像URL
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  deleted_at TEXT,                       -- 削除日時（論理削除）
  
  -- 外部キー制約
  FOREIGN KEY (client_id) REFERENCES clients(id)
);
```

#### インデックス

```sql
CREATE INDEX idx_events_client_id ON events(client_id);
CREATE INDEX idx_events_event_url ON events(event_url);
CREATE INDEX idx_events_category ON events(category);
CREATE INDEX idx_events_enable_flg ON events(enable_flg);
CREATE INDEX idx_events_deleted_at ON events(deleted_at);
CREATE INDEX idx_events_parent_event_id ON events(parent_event_id);
CREATE INDEX idx_events_event_start_date ON events(event_start_date);
CREATE INDEX idx_events_registration_dates ON events(registration_start_date, registration_end_date);
```

#### カラム説明

##### 基本情報
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| id | INTEGER | NO | AUTO_INCREMENT | イベントID | 主キー |
| name | TEXT | NO | - | イベント名 | 必須 |
| detail | TEXT | YES | - | イベント詳細 | HTML可 |
| location | TEXT | YES | - | 開催場所 | |
| contact | TEXT | NO | - | 連絡先 | 必須、メール or 電話 |
| remarks | TEXT | YES | - | 備考 | 注意事項など |
| thanks_msg | TEXT | YES | - | お礼メッセージ | 予約完了画面に表示 |

##### 多言語対応
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| name_en | TEXT | YES | - | イベント名（英語） | |
| detail_en | TEXT | YES | - | イベント詳細（英語） | |
| location_en | TEXT | YES | - | 開催場所（英語） | |
| contact_en | TEXT | YES | - | 連絡先（英語） | |
| remarks_en | TEXT | YES | - | 備考（英語） | |
| thanks_msg_en | TEXT | YES | - | お礼メッセージ（英語） | |

##### 組織関連
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| client_id | INTEGER | NO | - | クライアントID | 必須、FK to clients(id) |
| customer_client_id | INTEGER | YES | - | 顧客クライアントID | FK to clients(id) |
| organizer_id | INTEGER | YES | - | 主催者ID | FK to organizers(id) |
| vendor_id | INTEGER | YES | - | ベンダーID | FK to vendors(id) |
| branch_code | TEXT | YES | - | 支店コード | FK to branches(code) |

##### フラグ
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| enable_flg | INTEGER | NO | 1 | 有効フラグ | 0:無効, 1:有効 |
| payment_flg | INTEGER | NO | 0 | 決済フラグ | 0:無料, 1:有料 |

##### イベント設定
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| event_url | TEXT | YES | - | イベントURL | 一意、URLの一部として使用 |
| category | TEXT | YES | - | カテゴリ | 音楽、スポーツ、展示会など |
| date_selection_type | TEXT | YES | 'single' | 日付選択タイプ | single/button/calendar |
| event_type | TEXT | YES | 'standalone' | イベントタイプ | standalone/parent/child |
| parent_event_id | INTEGER | YES | - | 親イベントID | event_type=childの場合に設定 |

##### 日程
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| event_start_date | TEXT | YES | - | 開催開始日 | YYYY-MM-DD形式 |
| event_end_date | TEXT | YES | - | 開催終了日 | YYYY-MM-DD形式 |
| registration_start_date | TEXT | YES | - | 受付開始日 | YYYY-MM-DD形式 |
| registration_end_date | TEXT | YES | - | 受付終了日 | YYYY-MM-DD形式 |
| admin_login_start_date | TEXT | YES | - | 管理者ログイン開始日 | YYYY-MM-DD形式 |
| admin_login_end_date | TEXT | YES | - | 管理者ログイン終了日 | YYYY-MM-DD形式 |

##### メール設定
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| admin_email | TEXT | YES | - | 管理者メールアドレス | 予約通知先 |
| admin_cc_email | TEXT | YES | - | 管理者CCメールアドレス | 複数の場合はカンマ区切り |
| sender_name | TEXT | YES | - | 送信者名 | メールの差出人名 |
| sender_email | TEXT | YES | - | 送信者メールアドレス | メールの差出人アドレス |
| email_signature | TEXT | YES | - | メール署名 | メール本文末尾に追加 |
| email_signature_en | TEXT | YES | - | メール署名（英語） | |

##### 決済設定
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| payment_methods | TEXT | YES | - | 決済方法 | 旧フィールド（非推奨） |
| payment_credit_card | INTEGER | NO | 0 | クレジットカード決済有効 | 0:無効, 1:有効 |
| payment_bank_transfer | INTEGER | NO | 0 | 銀行振込決済有効 | 0:無効, 1:有効 |
| payment_convenience_store | INTEGER | NO | 0 | コンビニ決済有効 | 0:無効, 1:有効 |

##### 銀行振込設定
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| bank_name | TEXT | YES | - | 銀行名 | |
| bank_branch | TEXT | YES | - | 支店名 | |
| bank_account_type | TEXT | YES | - | 口座種別 | 普通/当座 |
| bank_account_number | TEXT | YES | - | 口座番号 | |
| bank_account_name | TEXT | YES | - | 口座名義 | |
| bank_transfer_deadline | INTEGER | YES | - | 銀行振込期限 | 日数 |

##### コンビニ決済設定
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| store_code | TEXT | YES | - | 店舗コード | 決済代行会社の店舗コード |
| convenience_payment_deadline | INTEGER | YES | - | コンビニ決済期限 | 日数 |
| available_convenience_stores | TEXT | YES | - | 利用可能なコンビニ | JSON配列 ["セブンイレブン","ファミリーマート"] |

##### 手数料設定
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| credit_fee_type | TEXT | YES | - | クレジット手数料タイプ | none/percentage/fixed/both |
| credit_fee_percentage | REAL | YES | - | クレジット手数料率 | パーセント（%） |
| credit_fee_fixed | INTEGER | YES | - | クレジット手数料固定額 | 円 |
| bank_fee_type | TEXT | YES | - | 銀行振込手数料タイプ | none/percentage/fixed/both |
| bank_fee_percentage | REAL | YES | - | 銀行振込手数料率 | パーセント（%） |
| bank_fee_fixed | INTEGER | YES | - | 銀行振込手数料固定額 | 円 |
| convenience_fee_type | TEXT | YES | - | コンビニ決済手数料タイプ | none/percentage/fixed/both |
| convenience_fee_percentage | REAL | YES | - | コンビニ決済手数料率 | パーセント（%） |
| convenience_fee_fixed | INTEGER | YES | - | コンビニ決済手数料固定額 | 円 |

##### キャンセルポリシー
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| cancel_policy | TEXT | YES | - | キャンセルポリシー | standard/custom/none |
| cancellation_policy_details | TEXT | YES | - | キャンセルポリシー詳細 | 自由記述 |
| cancellation_days_1 | INTEGER | YES | - | キャンセル期限1 | 日数（開催日の○日前） |
| cancellation_rate_1 | INTEGER | YES | - | キャンセル料率1 | パーセント（%） |
| cancellation_days_2 | INTEGER | YES | - | キャンセル期限2 | 日数（開催日の○日前） |
| cancellation_rate_2 | INTEGER | YES | - | キャンセル料率2 | パーセント（%） |

##### フォーム設定
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| form_field_settings | TEXT | YES | - | フォーム設定 | JSON形式 |

**form_field_settings JSON形式**:
```json
{
  "name_kanji": true,
  "name_kana": true,
  "name_roma": false,
  "address": true,
  "tel": true,
  "birth_date": false,
  "age": false
}
```

##### 自動返信メール設定
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| auto_reply_enabled | INTEGER | NO | 0 | 自動返信有効フラグ | 0:無効, 1:有効 |
| auto_reply_credit_payment | TEXT | YES | - | クレジット決済完了メール本文 | |
| auto_reply_bank_payment | TEXT | YES | - | 銀行振込案内メール本文 | |
| auto_reply_convenience_payment | TEXT | YES | - | コンビニ決済案内メール本文 | |
| auto_reply_credit_cancel | TEXT | YES | - | クレジット決済キャンセルメール本文 | |
| auto_reply_bank_cancel | TEXT | YES | - | 銀行振込キャンセルメール本文 | |
| auto_reply_convenience_cancel | TEXT | YES | - | コンビニ決済キャンセルメール本文 | |
| auto_reply_credit_refund | TEXT | YES | - | クレジット返金メール本文 | |
| auto_reply_bank_deposit | TEXT | YES | - | 銀行入金確認メール本文 | |
| auto_reply_bank_refund | TEXT | YES | - | 銀行振込返金メール本文 | |
| auto_reply_convenience_deposit | TEXT | YES | - | コンビニ入金確認メール本文 | |
| auto_reply_convenience_refund | TEXT | YES | - | コンビニ決済返金メール本文 | |

（英語版も同様）

##### その他
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| image_url | TEXT | YES | - | イベント画像URL | |

##### タイムスタンプ
| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| created_at | TEXT | NO | datetime('now','localtime') | 作成日時 | 自動設定 |
| modified_at | TEXT | NO | datetime('now','localtime') | 更新日時 | 自動更新 |
| deleted_at | TEXT | YES | - | 削除日時 | 論理削除 |

---

### 2. event_form_fields（イベントフォームフィールド）

#### 概要
イベント固有の追加フォームフィールドを管理するテーブル。

#### テーブル定義

```sql
CREATE TABLE event_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,             -- イベントID（FK）
  field_type TEXT NOT NULL,              -- フィールドタイプ
  field_name TEXT NOT NULL,              -- フィールド名
  field_label TEXT NOT NULL,             -- フィールドラベル
  field_options TEXT,                    -- 選択肢（JSON）
  is_required INTEGER DEFAULT 0,         -- 必須フラグ
  description TEXT,                      -- 説明
  display_order INTEGER DEFAULT 0,       -- 表示順序
  placeholder TEXT,                      -- プレースホルダー
  parent_field_id INTEGER,               -- 親フィールドID
  parent_condition TEXT,                 -- 親フィールド条件
  indent_level INTEGER DEFAULT 0,        -- インデントレベル
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (event_id) REFERENCES events(id)
);
```

#### インデックス

```sql
CREATE INDEX idx_event_form_fields_event_id ON event_form_fields(event_id);
CREATE INDEX idx_event_form_fields_display_order ON event_form_fields(display_order);
```

#### カラム説明

| カラム | 型 | NULL | デフォルト | 説明 | 備考 |
|--------|-----|------|-----------|------|------|
| id | INTEGER | NO | AUTO_INCREMENT | フィールドID | 主キー |
| event_id | INTEGER | NO | - | イベントID | FK to events(id) |
| field_type | TEXT | NO | - | フィールドタイプ | text/textarea/select/radio/checkbox/date/email/tel |
| field_name | TEXT | NO | - | フィールド名 | プログラム用の識別名 |
| field_label | TEXT | NO | - | フィールドラベル | 画面表示用ラベル |
| field_options | TEXT | YES | - | 選択肢 | JSON配列 ["選択肢1", "選択肢2"] |
| is_required | INTEGER | NO | 0 | 必須フラグ | 0:任意, 1:必須 |
| description | TEXT | YES | - | 説明 | フィールドの説明文 |
| display_order | INTEGER | NO | 0 | 表示順序 | 昇順で表示 |
| placeholder | TEXT | YES | - | プレースホルダー | 入力欄のヒント |
| parent_field_id | INTEGER | YES | - | 親フィールドID | 条件付き表示の親 |
| parent_condition | TEXT | YES | - | 親フィールド条件 | 親フィールドの値 |
| indent_level | INTEGER | NO | 0 | インデントレベル | 階層表示用 |
| created_at | TEXT | NO | datetime('now','localtime') | 作成日時 | |
| modified_at | TEXT | NO | datetime('now','localtime') | 更新日時 | |

---

## ER図

```
┌─────────────────────┐
│     clients         │
│  (クライアント)      │
└──────┬──────────────┘
       │ 1
       │
       │ N
┌──────▼──────────────┐      ┌─────────────────────┐
│     events          │ 1    │  event_form_fields  │
│   (イベント)         ├──────┤ (フォームフィールド) │
└──────┬──────────────┘  N   └─────────────────────┘
       │ 1
       │
       │ N
┌──────▼──────────────┐
│    products         │
│    (商品)           │
└─────────────────────┘
       │ 1
       │
       │ N
┌──────▼──────────────┐
│  product_stocks     │
│   (商品在庫)         │
└─────────────────────┘

┌─────────────────────┐
│   organizers        │
│   (主催者)          │
└──────┬──────────────┘
       │ 1
       │
       │ N
       ▼
     events

┌─────────────────────┐
│    vendors          │
│   (ベンダー)         │
└──────┬──────────────┘
       │ 1
       │
       │ N
       ▼
     events

┌─────────────────────┐
│    branches         │
│    (支店)           │
└──────┬──────────────┘
       │ 1
       │
       │ N
       ▼
     events
```

---

## データ整合性ルール

### 1. 必須項目
- `events.name`: イベント名は必須
- `events.contact`: 連絡先は必須
- `events.client_id`: クライアントIDは必須
- `events.event_url`: イベントURLは必須で一意
- `events.event_start_date`, `events.event_end_date`: 開催期間は必須
- `events.registration_start_date`, `events.registration_end_date`: 受付期間は必須

### 2. 一意性制約
- `events.event_url`: 同じURLのイベントは作成不可

### 3. 外部キー制約
- `events.client_id` → `clients.id`
- `events.organizer_id` → `organizers.id`
- `events.vendor_id` → `vendors.id`
- `event_form_fields.event_id` → `events.id`

### 4. チェック制約
- `events.enable_flg`: 0 or 1
- `events.payment_flg`: 0 or 1
- `events.event_start_date` <= `events.event_end_date`
- `events.registration_start_date` <= `events.registration_end_date`
- `events.cancellation_rate_1`: 0 ~ 100
- `events.cancellation_rate_2`: 0 ~ 100

### 5. 論理削除
- `events.deleted_at IS NULL`: 有効なイベント
- `events.deleted_at IS NOT NULL`: 削除済みイベント

---

## パフォーマンス要件

### 1. 応答時間
- イベント一覧取得: 500ms以内
- イベント詳細取得: 200ms以内
- イベント作成: 1秒以内
- イベント更新: 1秒以内

### 2. 同時実行
- 最大同時アクセス数: 100ユーザー
- 最大同時書き込み: 10トランザクション

### 3. インデックス戦略
- 頻繁に検索されるカラムにインデックスを作成
- 複合インデックスは検索パターンに応じて作成

---

## セキュリティ要件

### 1. アクセス制御
- すべての管理APIは認証必須
- 参照系APIは一部公開可能

### 2. データ保護
- 個人情報は暗号化して保存（検討中）
- クレジットカード情報は保存しない（決済代行サービス利用）

### 3. SQLインジェクション対策
- すべてのクエリでプリペアドステートメントを使用
- バインドパラメータの使用を徹底

### 4. 論理削除
- 物理削除は行わず、deleted_atで論理削除
- 監査ログとして履歴を保持

---

## バックアップ・リカバリ要件

### 1. バックアップ
- **頻度**: 1日1回（深夜）
- **保存期間**: 30日間
- **保存場所**: Cloudflare R2バケット

### 2. リカバリ
- **RPO（目標復旧時点）**: 24時間以内
- **RTO（目標復旧時間）**: 4時間以内

### 3. テスト
- バックアップからのリストア試験: 月1回実施

---

## マイグレーション

### 1. マイグレーションファイル
- `migrations/`ディレクトリに管理
- ファイル名: `0001_description.sql`形式

### 2. 適用方法

**ローカル環境**:
```bash
npx wrangler d1 migrations apply webapp-production --local
```

**本番環境**:
```bash
npx wrangler d1 migrations apply webapp-production --remote
```

---

## 関連ドキュメント

- [API仕様書](./API_SPEC_EVENT_MANAGEMENT.md)
- [データベーススキーマ完全版](./DATABASE_SCHEMA_COMPLETE.md)
- [データベーススキーマSQL](./database_schema_complete.sql)

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|---------|
| 1.0 | 2026-01-28 | 初版作成 |

---

## お問い合わせ

データベース仕様に関するお問い合わせは、開発チームまでご連絡ください。
