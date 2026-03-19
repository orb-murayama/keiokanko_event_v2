# 商品管理データベーススキーマ仕様書

**バージョン**: 1.0  
**作成日**: 2026-02-05  
**最終更新**: 2026-02-05

---

## 目次

1. [概要](#概要)
2. [ER図](#er図)
3. [テーブル一覧](#テーブル一覧)
4. [テーブル詳細](#テーブル詳細)
5. [インデックス](#インデックス)
6. [制約・ルール](#制約ルール)
7. [関連ドキュメント](#関連ドキュメント)
8. [変更履歴](#変更履歴)

---

## 概要

商品管理データベースは、イベントに紐づく商品（チケット・ツアーパッケージ等）の管理に必要なテーブル群です。商品情報、価格設定、在庫管理、共有在庫プール、カスタムフォーム設定、予約情報を格納します。

**主要機能**:
- 商品マスタ管理
- 価格帯・在庫管理
- 共有在庫プール機能
- カスタムフォーム項目設定
- 予約・支払い管理

**テーブル総数**: 8テーブル

---

## ER図

```
┌─────────────────┐
│ product_        │
│ categories      │
└────────┬────────┘
         │
         │ 1:N
         │
┌────────▼────────────────────────┐
│ products                        │
│ ・基本情報                       │
│ ・販売期間                       │
│ ・キャンセルポリシー              │
└─┬───────┬──────────┬────────────┘
  │       │          │
  │ 1:N   │ 1:N      │ 1:N
  │       │          │
┌─▼──────────┐ ┌─▼─────────────┐ ┌─▼────────────────┐
│ product_   │ │ product_      │ │ product_         │
│ prices     │ │ stocks        │ │ form_fields      │
│ ・価格帯   │ │ ・日別在庫    │ │ ・カスタム項目   │
└────────────┘ └───────┬───────┘ └──────────────────┘
                       │
                       │ N:1
                       │
              ┌────────▼─────────────┐
              │ shared_stock_pools   │
              │ ・共有在庫プール      │
              └──────────┬───────────┘
                         │
                         │ N:N
                         │
              ┌──────────▼──────────────────┐
              │ product_shared_stock_pools  │
              │ ・商品と共有在庫のリンク      │
              └─────────────────────────────┘

┌─────────────────────────────┐
│ product_bookings            │
│ ・予約情報                   │
│ ・支払い情報                 │
│ ・参加者情報                 │
└─────────────────────────────┘
```

---

## テーブル一覧

| テーブル名 | 説明 | 主な用途 |
|-----------|------|---------|
| `product_categories` | 商品カテゴリ | 商品の分類管理 |
| `products` | 商品マスタ | 商品の基本情報・販売条件 |
| `product_prices` | 商品価格 | 価格帯・料金設定 |
| `product_stocks` | 商品在庫 | 日別・タイムスロット別在庫 |
| `product_form_fields` | 商品フォーム項目 | カスタム入力フォーム設定 |
| `shared_stock_pools` | 共有在庫プール | 複数商品で共有する在庫 |
| `product_shared_stock_pools` | 商品-共有在庫リンク | 商品と共有在庫の紐付け |
| `product_bookings` | 商品予約 | 予約・支払い・参加者情報 |

---

## テーブル詳細

### 1. product_categories（商品カテゴリ）

商品の分類を管理するマスタテーブル。

#### スキーマ

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | カテゴリID（主キー） |
| `name` | TEXT | NO | - | カテゴリ名 |
| `description` | TEXT | YES | NULL | 説明 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### インデックス

```sql
CREATE INDEX idx_product_categories_name ON product_categories(name);
```

#### サンプルデータ

```sql
INSERT INTO product_categories (name, description) VALUES
  ('入場券', 'イベントへの入場チケット'),
  ('ツアーパッケージ', '体験型ツアー商品'),
  ('オプション', 'お弁当・駐車場等のオプション商品');
```

---

### 2. products（商品マスタ）

商品の基本情報と販売条件を管理するメインテーブル。

#### スキーマ

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 商品ID（主キー） |
| `client_id` | INTEGER | NO | - | クライアントID |
| `event_id` | INTEGER | NO | - | イベントID |
| `name` | TEXT | NO | - | 商品名 |
| `sales_start` | TEXT | NO | - | 販売開始日（YYYY-MM-DD） |
| `sales_end` | TEXT | NO | - | 販売終了日（YYYY-MM-DD） |
| `closing_trade` | INTEGER | NO | 0 | クロージング取引（0: なし, 1: あり） |
| `product_category_id` | INTEGER | YES | NULL | 商品カテゴリID |
| `description` | TEXT | YES | NULL | 商品説明 |
| `remarks` | TEXT | YES | NULL | 備考 |
| `fee_include` | TEXT | YES | NULL | 料金に含まれるもの |
| `fee_exclude` | TEXT | YES | NULL | 料金に含まれないもの |
| `cancel_policy` | TEXT | YES | NULL | キャンセルポリシー |
| `purchase_limit` | INTEGER | YES | NULL | 購入上限数 |
| `deposit_address` | TEXT | YES | NULL | 振込先情報 |
| `note` | TEXT | YES | NULL | 特記事項 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `slot_type` | INTEGER | YES | 0 | スロットタイプ |
| `deleted_at` | TEXT | YES | NULL | 削除日時（論理削除） |
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
| `common_names` | TEXT | YES | NULL | 共通名称設定（JSON配列） |
| `cancellation_policy_details` | TEXT | YES | NULL | キャンセル料金詳細（JSON配列） |
| `price_unit` | TEXT | YES | '人' | 価格単位 |
| `charge_type` | TEXT | YES | 'per_person' | 料金タイプ |
| `charge_description` | TEXT | YES | NULL | 料金説明 |
| `image_url` | TEXT | YES | NULL | 商品画像URL |
| `form_field_settings` | TEXT | YES | '{"name_kanji":true,...}' | フォーム項目設定（JSON） |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (client_id) REFERENCES clients(id)
FOREIGN KEY (event_id) REFERENCES events(id)
FOREIGN KEY (product_category_id) REFERENCES product_categories(id)
```

#### インデックス

```sql
CREATE INDEX idx_products_event_id ON products(event_id);
CREATE INDEX idx_products_client_id ON products(client_id);
CREATE INDEX idx_products_category_id ON products(product_category_id);
CREATE INDEX idx_products_deleted_at ON products(deleted_at);
CREATE INDEX idx_products_enable_flg ON products(enable_flg);
```

#### JSON形式フィールド

**common_names（共通名称設定）**:
```json
[
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
]
```

**cancellation_policy_details（キャンセル料金詳細）**:
```json
[
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
]
```

**form_field_settings（フォーム項目設定）**:
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

---

### 3. product_prices（商品価格）

商品の価格帯・料金設定を管理するテーブル。

#### スキーマ

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 価格ID（主キー） |
| `product_id` | INTEGER | NO | - | 商品ID |
| `price` | INTEGER | NO | - | 価格（円） |
| `category_name` | TEXT | YES | NULL | カテゴリ名 |
| `price_band` | TEXT | YES | NULL | 価格帯（A, B, C等） |
| `price_name` | TEXT | YES | NULL | 価格名称（大人、子供等） |
| `display_order` | INTEGER | YES | 0 | 表示順 |
| `slot_number` | INTEGER | YES | 1 | スロット番号 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (product_id) REFERENCES products(id)
```

#### インデックス

```sql
CREATE INDEX idx_product_prices_product_id ON product_prices(product_id);
CREATE INDEX idx_product_prices_price_band ON product_prices(price_band);
```

#### サンプルデータ

```sql
INSERT INTO product_prices (product_id, price, price_band, category_name, price_name, slot_number, display_order) VALUES
  (1, 5000, 'A', 'A-大人', '大人', 1, 0),
  (1, 3000, 'A', 'A-子供', '子供', 1, 1),
  (1, 4000, 'A', 'A-シニア', 'シニア', 1, 2);
```

---

### 4. product_stocks（商品在庫）

商品の日別・タイムスロット別在庫を管理するテーブル。

#### スキーマ

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 在庫ID（主キー） |
| `product_id` | INTEGER | NO | - | 商品ID |
| `date` | TEXT | NO | - | 日付（YYYY-MM-DD） |
| `stock` | INTEGER | NO | 0 | 在庫数 |
| `booked` | INTEGER | NO | 0 | 予約済み数 |
| `time_slot_start` | TEXT | YES | NULL | タイムスロット開始時刻（HH:MM） |
| `time_slot_end` | TEXT | YES | NULL | タイムスロット終了時刻（HH:MM） |
| `time_slot_label` | TEXT | YES | NULL | タイムスロットラベル（午前の部等） |
| `stock_name` | TEXT | YES | NULL | 在庫名 |
| `shared_pool_id` | INTEGER | YES | NULL | 共有在庫プールID |
| `price_band` | TEXT | YES | NULL | 価格帯 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (product_id) REFERENCES products(id)
```

#### インデックス

```sql
CREATE INDEX idx_product_stocks_product_id ON product_stocks(product_id);
CREATE INDEX idx_product_stocks_date ON product_stocks(date);
CREATE INDEX idx_product_stocks_price_band ON product_stocks(price_band);
CREATE INDEX idx_product_stocks_shared_pool_id ON product_stocks(shared_pool_id);
```

#### 計算ロジック

**利用可能在庫数** = `stock` - `booked`

#### サンプルデータ

```sql
INSERT INTO product_stocks (product_id, date, stock, booked, time_slot_start, time_slot_end, time_slot_label, stock_name, price_band) VALUES
  (1, '2024-08-01', 100, 25, '10:00', '12:00', '午前の部', '一般', 'A'),
  (1, '2024-08-01', 100, 40, '14:00', '16:00', '午後の部', '一般', 'A');
```

---

### 5. product_form_fields（商品フォーム項目）

商品ごとのカスタム入力フォーム項目を管理するテーブル。

#### スキーマ

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | フォーム項目ID（主キー） |
| `product_id` | INTEGER | NO | - | 商品ID |
| `field_type` | TEXT | NO | - | フィールドタイプ（text/textarea/select/radio/checkbox/date/file） |
| `field_name` | TEXT | NO | - | フィールド名（英数字） |
| `field_label` | TEXT | NO | - | フィールドラベル（画面表示名） |
| `field_options` | TEXT | YES | NULL | 選択肢（JSON配列） |
| `is_required` | INTEGER | YES | 0 | 必須フラグ（0: 任意, 1: 必須） |
| `description` | TEXT | YES | NULL | 説明文 |
| `display_order` | INTEGER | YES | 0 | 表示順 |
| `placeholder` | TEXT | YES | NULL | プレースホルダー |
| `parent_field_id` | INTEGER | YES | NULL | 親フィールドID（条件表示） |
| `parent_condition` | TEXT | YES | NULL | 親フィールドの条件値 |
| `indent_level` | INTEGER | YES | 0 | インデントレベル（0-3） |
| `category` | INTEGER | YES | 1 | 区分（1: 商品, 2: 参加者毎） |
| `validation_rule` | TEXT | YES | NULL | バリデーションルール |
| `default_value` | TEXT | YES | NULL | デフォルト値 |
| `help_text` | TEXT | YES | NULL | ヘルプテキスト |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (product_id) REFERENCES products(id)
```

#### インデックス

```sql
CREATE INDEX idx_product_form_fields_product_id ON product_form_fields(product_id);
CREATE INDEX idx_product_form_fields_display_order ON product_form_fields(display_order);
CREATE INDEX idx_product_form_fields_category ON product_form_fields(category);
```

#### フィールドタイプ

| タイプ | 説明 | field_options必須 |
|-------|------|------------------|
| `text` | テキスト入力 | 不要 |
| `textarea` | テキストエリア | 不要 |
| `select` | プルダウン | 必要 |
| `radio` | ラジオボタン | 必要 |
| `checkbox` | チェックボックス | 必要 |
| `date` | カレンダー | 不要 |
| `file` | ファイルアップロード | 不要 |

#### 区分（category）

| 値 | 説明 | 用途 |
|----|------|------|
| `1` | 商品 | 商品全体で1回だけ入力するフィールド（例：代表者名、連絡先） |
| `2` | 参加者毎 | 参加者ごとに繰り返し入力するフィールド（例：参加者氏名、年齢） |

#### サンプルデータ

```sql
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, placeholder, category) VALUES
  (1, 'text', 'full_name', 'お名前', NULL, 1, 'フルネームをご入力ください', 0, '例：山田太郎', 1),
  (1, 'radio', 'category', '区分', '["商品","参加者毎"]', 1, 'このフォームを表示する場所を選択してください', 1, NULL, 1),
  (1, 'select', 'age_group', '年齢区分', '["大人","子供","シニア"]', 1, NULL, 2, '選択してください', 2);
```

---

### 6. shared_stock_pools（共有在庫プール）

複数商品で共有する在庫プールを管理するテーブル。

#### スキーマ

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | プールID（主キー） |
| `pool_name` | TEXT | NO | - | プール名 |
| `pool_code` | TEXT | YES | NULL | プールコード |
| `description` | TEXT | YES | NULL | 説明 |
| `date` | TEXT | NO | - | 日付（YYYY-MM-DD） |
| `time_slot_start` | TEXT | YES | NULL | タイムスロット開始時刻（HH:MM） |
| `time_slot_end` | TEXT | YES | NULL | タイムスロット終了時刻（HH:MM） |
| `time_slot_label` | TEXT | YES | NULL | タイムスロットラベル |
| `total_stock` | INTEGER | YES | 0 | 総在庫数 |
| `booked` | INTEGER | YES | 0 | 予約済み数 |
| `available_stock` | INTEGER | VIRTUAL | total_stock - booked | 利用可能在庫数（仮想カラム） |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### インデックス

```sql
CREATE INDEX idx_shared_stock_pools_date ON shared_stock_pools(date);
CREATE INDEX idx_shared_stock_pools_pool_code ON shared_stock_pools(pool_code);
CREATE INDEX idx_shared_stock_pools_enable_flg ON shared_stock_pools(enable_flg);
```

#### 仮想カラム

**available_stock（利用可能在庫数）**:
```sql
GENERATED ALWAYS AS (total_stock - booked) VIRTUAL
```

#### サンプルデータ

```sql
INSERT INTO shared_stock_pools (pool_name, pool_code, description, date, time_slot_start, time_slot_end, time_slot_label, total_stock, booked, enable_flg) VALUES
  ('共有在庫プールA', 'POOL-A', 'ツアーA・Bで共有', '2024-08-01', '10:00', '12:00', '午前の部', 200, 50, 1);
```

---

### 7. product_shared_stock_pools（商品-共有在庫リンク）

商品と共有在庫プールの紐付けを管理する中間テーブル。

#### スキーマ

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | リンクID（主キー） |
| `product_id` | INTEGER | NO | - | 商品ID |
| `shared_stock_pool_id` | INTEGER | NO | - | 共有在庫プールID |
| `stock_name` | TEXT | YES | NULL | 在庫名 |
| `price_band` | TEXT | YES | NULL | 価格帯 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `priority` | INTEGER | YES | 0 | 優先度 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (product_id) REFERENCES products(id)
FOREIGN KEY (shared_stock_pool_id) REFERENCES shared_stock_pools(id)
```

#### インデックス

```sql
CREATE INDEX idx_product_shared_stock_pools_product_id ON product_shared_stock_pools(product_id);
CREATE INDEX idx_product_shared_stock_pools_pool_id ON product_shared_stock_pools(shared_stock_pool_id);
CREATE UNIQUE INDEX idx_product_shared_stock_pools_unique ON product_shared_stock_pools(product_id, shared_stock_pool_id);
```

#### サンプルデータ

```sql
INSERT INTO product_shared_stock_pools (product_id, shared_stock_pool_id, stock_name, price_band, enable_flg, priority) VALUES
  (1, 1, '一般', 'A', 1, 0),
  (2, 1, '一般', 'A', 1, 0);
```

---

### 8. product_bookings（商品予約）

商品の予約情報、支払い情報、参加者情報を管理するテーブル。

#### スキーマ

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 予約ID（主キー） |
| `booking_number` | TEXT | YES | NULL | 予約番号 |
| `customer_id` | INTEGER | NO | - | 顧客ID |
| `product_id` | INTEGER | NO | - | 商品ID |
| `product_stock_id` | INTEGER | YES | NULL | 商品在庫ID |
| `price` | INTEGER | NO | - | 金額（円） |
| `quantity` | INTEGER | NO | 1 | 数量 |
| `booking_status` | TEXT | YES | 'reserved' | 予約ステータス（reserved/confirmed/canceled） |
| `payment_status` | TEXT | YES | 'pending' | 支払いステータス（pending/completed/failed） |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `canceled_at` | TEXT | YES | NULL | キャンセル日時 |
| `qr_code_url` | TEXT | YES | NULL | QRコードURL |
| `pdf_file_url` | TEXT | YES | NULL | PDFファイルURL |
| `price_items` | TEXT | YES | NULL | 価格明細（JSON） |
| `remarks` | TEXT | YES | NULL | 備考 |
| `participants` | TEXT | YES | NULL | 参加者情報（JSON） |
| `participation_date` | TEXT | YES | NULL | 参加日（YYYY-MM-DD） |
| `payment_method` | TEXT | YES | NULL | 支払い方法 |
| `payment_date` | TEXT | YES | NULL | 支払い日時 |
| `payment_transaction_id` | TEXT | YES | NULL | 決済トランザクションID |
| `bank_transfer_info` | TEXT | YES | NULL | 銀行振込情報（JSON） |
| `convenience_store_info` | TEXT | YES | NULL | コンビニ決済情報（JSON） |
| `survey_answers` | TEXT | YES | NULL | アンケート回答（JSON） |
| `organizer_id` | INTEGER | YES | NULL | 主催者ID |
| `vendor_id` | INTEGER | YES | NULL | ベンダーID |
| `branch_code` | TEXT | YES | NULL | 支店コード |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (customer_id) REFERENCES customers(id)
FOREIGN KEY (product_id) REFERENCES products(id)
FOREIGN KEY (product_stock_id) REFERENCES product_stocks(id)
```

#### インデックス

```sql
CREATE INDEX idx_product_bookings_customer_id ON product_bookings(customer_id);
CREATE INDEX idx_product_bookings_product_id ON product_bookings(product_id);
CREATE INDEX idx_product_bookings_booking_number ON product_bookings(booking_number);
CREATE INDEX idx_product_bookings_booking_status ON product_bookings(booking_status);
CREATE INDEX idx_product_bookings_payment_status ON product_bookings(payment_status);
CREATE INDEX idx_product_bookings_participation_date ON product_bookings(participation_date);
```

#### JSON形式フィールド

**price_items（価格明細）**:
```json
[
  {
    "name": "大人",
    "price": 5000,
    "quantity": 2,
    "subtotal": 10000
  },
  {
    "name": "子供",
    "price": 3000,
    "quantity": 1,
    "subtotal": 3000
  }
]
```

**participants（参加者情報）**:
```json
[
  {
    "name": "山田太郎",
    "age": 35,
    "gender": "男性"
  },
  {
    "name": "山田花子",
    "age": 8,
    "gender": "女性"
  }
]
```

---

## インデックス

### 推奨インデックス一覧

```sql
-- product_categories
CREATE INDEX idx_product_categories_name ON product_categories(name);

-- products
CREATE INDEX idx_products_event_id ON products(event_id);
CREATE INDEX idx_products_client_id ON products(client_id);
CREATE INDEX idx_products_category_id ON products(product_category_id);
CREATE INDEX idx_products_deleted_at ON products(deleted_at);
CREATE INDEX idx_products_enable_flg ON products(enable_flg);

-- product_prices
CREATE INDEX idx_product_prices_product_id ON product_prices(product_id);
CREATE INDEX idx_product_prices_price_band ON product_prices(price_band);

-- product_stocks
CREATE INDEX idx_product_stocks_product_id ON product_stocks(product_id);
CREATE INDEX idx_product_stocks_date ON product_stocks(date);
CREATE INDEX idx_product_stocks_price_band ON product_stocks(price_band);
CREATE INDEX idx_product_stocks_shared_pool_id ON product_stocks(shared_pool_id);

-- product_form_fields
CREATE INDEX idx_product_form_fields_product_id ON product_form_fields(product_id);
CREATE INDEX idx_product_form_fields_display_order ON product_form_fields(display_order);
CREATE INDEX idx_product_form_fields_category ON product_form_fields(category);

-- shared_stock_pools
CREATE INDEX idx_shared_stock_pools_date ON shared_stock_pools(date);
CREATE INDEX idx_shared_stock_pools_pool_code ON shared_stock_pools(pool_code);
CREATE INDEX idx_shared_stock_pools_enable_flg ON shared_stock_pools(enable_flg);

-- product_shared_stock_pools
CREATE INDEX idx_product_shared_stock_pools_product_id ON product_shared_stock_pools(product_id);
CREATE INDEX idx_product_shared_stock_pools_pool_id ON product_shared_stock_pools(shared_stock_pool_id);
CREATE UNIQUE INDEX idx_product_shared_stock_pools_unique ON product_shared_stock_pools(product_id, shared_stock_pool_id);

-- product_bookings
CREATE INDEX idx_product_bookings_customer_id ON product_bookings(customer_id);
CREATE INDEX idx_product_bookings_product_id ON product_bookings(product_id);
CREATE INDEX idx_product_bookings_booking_number ON product_bookings(booking_number);
CREATE INDEX idx_product_bookings_booking_status ON product_bookings(booking_status);
CREATE INDEX idx_product_bookings_payment_status ON product_bookings(payment_status);
CREATE INDEX idx_product_bookings_participation_date ON product_bookings(participation_date);
```

---

## 制約・ルール

### 1. 論理削除

**対象テーブル**: `products`

削除時は `deleted_at` に削除日時を設定し、物理削除は行わない。

```sql
UPDATE products SET deleted_at = datetime('now', 'localtime') WHERE id = ?;
```

### 2. 有効フラグ

**対象テーブル**: `products`, `shared_stock_pools`, `product_shared_stock_pools`, `product_bookings`

`enable_flg` を使用した論理的な無効化が可能。

- `0`: 無効（非表示・非アクティブ）
- `1`: 有効（表示・アクティブ）

### 3. 在庫管理ロジック

#### 利用可能在庫の計算

```
利用可能在庫数 = stock - booked
```

#### 共有在庫プールの場合

```
利用可能在庫数 = total_stock - booked (VIRTUAL COLUMN)
```

### 4. 価格帯（price_band）

価格帯は商品によって自由に設定可能（A, B, C, VIP等）。在庫管理と連携するため、一貫性を保つ必要がある。

### 5. タイムスロット

開始時刻・終了時刻・ラベルの3つの組み合わせでタイムスロットを管理。

**例**:
- `time_slot_start`: "10:00"
- `time_slot_end`: "12:00"
- `time_slot_label`: "午前の部"

### 6. JSON形式データ

以下のカラムはJSON形式で格納：
- `products.common_names`
- `products.cancellation_policy_details`
- `products.form_field_settings`
- `product_form_fields.field_options`
- `product_bookings.price_items`
- `product_bookings.participants`
- `product_bookings.bank_transfer_info`
- `product_bookings.convenience_store_info`
- `product_bookings.survey_answers`

### 7. カスタムフォームの区分（category）

**区分 1（商品）**: 商品全体で1回だけ入力するフィールド
- 例：代表者名、連絡先、支払い方法

**区分 2（参加者毎）**: 参加者ごとに繰り返し入力するフィールド
- 例：参加者氏名、年齢、性別

### 8. 条件付き表示

`product_form_fields.parent_field_id` と `parent_condition` を使用して、親フィールドの値に応じた動的な表示制御が可能。

**例**:
- 親フィールド: "参加経験" (radio: "初めて", "2回目以降")
- 子フィールド: "初めての方へのアンケート" (parent_condition: "初めて")

---

## 関連ドキュメント

- [API_SPEC_PRODUCT_MANAGEMENT.md](./API_SPEC_PRODUCT_MANAGEMENT.md) - 商品管理API仕様書
- [database_schema_complete.sql](./database_schema_complete.sql) - 完全なデータベーススキーマSQL

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|---------|
| 1.0 | 2026-02-05 | 初版作成 |

---

## 問い合わせ

データベーススキーマに関するお問い合わせは、開発チームまでご連絡ください。
