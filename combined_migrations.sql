-- イベント予約管理システム データベーススキーマ
-- Cloudflare D1 (SQLite) 用

-- クライアント（主催者）テーブル
CREATE TABLE IF NOT EXISTS clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  contactable_person TEXT,
  branch_office TEXT,
  accounted_person TEXT,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  tel TEXT NOT NULL,
  fax TEXT,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  remarks TEXT,
  reg_flg INTEGER DEFAULT 1,
  group_id INTEGER NOT NULL DEFAULT 1, -- 1:主催者 2:管理者
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

CREATE INDEX idx_clients_email ON clients(email);
CREATE INDEX idx_clients_group_id ON clients(group_id);

-- イベント管理テーブル
CREATE TABLE IF NOT EXISTS events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  detail TEXT,
  contact TEXT NOT NULL,
  remarks TEXT,
  question TEXT,
  postage INTEGER DEFAULT 0,
  thanks_msg TEXT,
  note TEXT,
  client_id INTEGER NOT NULL,
  company_flg INTEGER DEFAULT 0, -- 0:個人向け 1:法人向け
  enable_flg INTEGER DEFAULT 1, -- 0:無効 1:有効
  payment_flg INTEGER DEFAULT 0, -- 0:振込 1:クレジット 2:その他
  payment_cd TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE INDEX idx_events_client_id ON events(client_id);
CREATE INDEX idx_events_enable_flg ON events(enable_flg);
CREATE INDEX idx_events_company_flg ON events(company_flg);

-- 商品カテゴリーテーブル
CREATE TABLE IF NOT EXISTS product_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- 商品管理テーブル
CREATE TABLE IF NOT EXISTS products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  sales_start TEXT NOT NULL, -- YYYY-MM-DD HH:MM:SS
  sales_end TEXT NOT NULL,
  closing_trade INTEGER NOT NULL DEFAULT 0, -- 締切日（何日前）
  product_category_id INTEGER,
  description TEXT,
  remarks TEXT,
  fee_include TEXT, -- 料金に含まれるもの
  fee_exclude TEXT, -- 料金に含まれないもの
  cancel_policy TEXT, -- キャンセルポリシー
  purchase_limit INTEGER, -- 申込上限数
  deposit_address TEXT, -- 振込先
  note TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (product_category_id) REFERENCES product_categories(id)
);

CREATE INDEX idx_products_event_id ON products(event_id);
CREATE INDEX idx_products_client_id ON products(client_id);
CREATE INDEX idx_products_enable_flg ON products(enable_flg);
CREATE INDEX idx_products_sales_start ON products(sales_start);
CREATE INDEX idx_products_sales_end ON products(sales_end);
CREATE UNIQUE INDEX idx_products_event_name ON products(event_id, name);

-- 商品価格テーブル
CREATE TABLE IF NOT EXISTS product_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT, -- 価格カテゴリー名（例：大人、子供、シニア等）
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_product_prices_product_id ON product_prices(product_id);

-- 商品在庫テーブル
CREATE TABLE IF NOT EXISTS product_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  date TEXT NOT NULL, -- YYYY-MM-DD
  stock INTEGER NOT NULL DEFAULT 0,
  booked INTEGER NOT NULL DEFAULT 0, -- 予約済数
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_product_stocks_product_id ON product_stocks(product_id);
CREATE INDEX idx_product_stocks_date ON product_stocks(date);
CREATE UNIQUE INDEX idx_product_stocks_product_date ON product_stocks(product_id, date);

-- オプションカテゴリーテーブル
CREATE TABLE IF NOT EXISTS option_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- オプションテーブル
CREATE TABLE IF NOT EXISTS options (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  remarks TEXT,
  option_category_id INTEGER NOT NULL,
  cancel_policy TEXT,
  note TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (option_category_id) REFERENCES option_categories(id)
);

CREATE INDEX idx_options_event_id ON options(event_id);
CREATE INDEX idx_options_enable_flg ON options(enable_flg);

-- オプション-商品紐付けテーブル
CREATE TABLE IF NOT EXISTS option_inherited_products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_option_inherited_products_option_id ON option_inherited_products(option_id);
CREATE INDEX idx_option_inherited_products_product_id ON option_inherited_products(product_id);
CREATE UNIQUE INDEX idx_option_inherited_products_unique ON option_inherited_products(option_id, product_id);

-- オプション価格テーブル
CREATE TABLE IF NOT EXISTS option_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);

CREATE INDEX idx_option_prices_option_id ON option_prices(option_id);

-- オプション在庫テーブル
CREATE TABLE IF NOT EXISTS option_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  date TEXT, -- YYYY-MM-DD (日付指定なしの場合はNULL)
  stock INTEGER NOT NULL DEFAULT 0,
  booked INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);

CREATE INDEX idx_option_stocks_option_id ON option_stocks(option_id);
CREATE INDEX idx_option_stocks_date ON option_stocks(date);

-- オプションフォーム設定テーブル
CREATE TABLE IF NOT EXISTS option_forms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  form_type INTEGER NOT NULL, -- 1:数量入力 2:単一選択 3:複数選択
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);

CREATE INDEX idx_option_forms_option_id ON option_forms(option_id);

-- 顧客（申込者）テーブル
CREATE TABLE IF NOT EXISTS customers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  family_name TEXT,
  first_name TEXT,
  family_kana TEXT,
  first_kana TEXT,
  sex INTEGER, -- 0:男性 1:女性
  birth TEXT, -- YYYY-MM-DD
  mobile TEXT,
  tel TEXT,
  fax TEXT,
  email TEXT,
  zip TEXT,
  pref_id INTEGER,
  city TEXT,
  addr TEXT,
  bldg TEXT,
  payment TEXT,
  answer TEXT,
  remark TEXT,
  mailme_flg INTEGER DEFAULT 0, -- メール配信希望フラグ
  contact TEXT,
  company_name TEXT,
  department_name TEXT,
  free1 TEXT,
  free2 TEXT,
  free3 TEXT,
  free4 TEXT,
  free5 TEXT,
  free6 TEXT,
  agent_number TEXT, -- 法人向け商品の認証キーワード
  enable_flg INTEGER DEFAULT 1,
  payment_select INTEGER DEFAULT 0,
  payment_status INTEGER DEFAULT 0, -- 0:未払い 1:支払済
  uniqid TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT
);

CREATE INDEX idx_customers_family_name ON customers(family_name);
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_enable_flg ON customers(enable_flg);

-- 商品予約テーブル
CREATE TABLE IF NOT EXISTS product_bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  product_stock_id INTEGER,
  price INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  enable_flg INTEGER DEFAULT 1, -- 0:キャンセル済 1:有効
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (product_stock_id) REFERENCES product_stocks(id)
);

CREATE INDEX idx_product_bookings_customer_id ON product_bookings(customer_id);
CREATE INDEX idx_product_bookings_product_id ON product_bookings(product_id);
CREATE INDEX idx_product_bookings_enable_flg ON product_bookings(enable_flg);

-- オプション予約テーブル
CREATE TABLE IF NOT EXISTS option_bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  option_id INTEGER NOT NULL,
  option_stock_id INTEGER,
  price INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (option_stock_id) REFERENCES option_stocks(id)
);

CREATE INDEX idx_option_bookings_customer_id ON option_bookings(customer_id);
CREATE INDEX idx_option_bookings_option_id ON option_bookings(option_id);
CREATE INDEX idx_option_bookings_enable_flg ON option_bookings(enable_flg);

-- 都道府県マスタ
CREATE TABLE IF NOT EXISTS prefs (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

-- 都道府県データの挿入
INSERT OR IGNORE INTO prefs (id, name) VALUES
(1, '北海道'), (2, '青森県'), (3, '岩手県'), (4, '宮城県'), (5, '秋田県'),
(6, '山形県'), (7, '福島県'), (8, '茨城県'), (9, '栃木県'), (10, '群馬県'),
(11, '埼玉県'), (12, '千葉県'), (13, '東京都'), (14, '神奈川県'), (15, '新潟県'),
(16, '富山県'), (17, '石川県'), (18, '福井県'), (19, '山梨県'), (20, '長野県'),
(21, '岐阜県'), (22, '静岡県'), (23, '愛知県'), (24, '三重県'), (25, '滋賀県'),
(26, '京都府'), (27, '大阪府'), (28, '兵庫県'), (29, '奈良県'), (30, '和歌山県'),
(31, '鳥取県'), (32, '島根県'), (33, '岡山県'), (34, '広島県'), (35, '山口県'),
(36, '徳島県'), (37, '香川県'), (38, '愛媛県'), (39, '高知県'), (40, '福岡県'),
(41, '佐賀県'), (42, '長崎県'), (43, '熊本県'), (44, '大分県'), (45, '宮崎県'),
(46, '鹿児島県'), (47, '沖縄県');

-- 初期カテゴリーデータ
INSERT OR IGNORE INTO product_categories (id, name, description) VALUES
(1, 'マス席', 'マス形式の座席'),
(2, '団体席', '団体向けの座席'),
(3, 'テニスコート席', 'テニスコート形式の座席'),
(4, '個人席', '個人向けの座席');

INSERT OR IGNORE INTO option_categories (id, name, description) VALUES
(1, '駐車場', '駐車場関連オプション'),
(2, 'お弁当', 'お弁当関連オプション'),
(3, 'シャトルバス', 'シャトルバス関連オプション'),
(4, 'その他', 'その他のオプション');
-- 時間枠対応のためのスキーマ変更

-- 商品テーブルに時間枠タイプフィールドを追加
ALTER TABLE products ADD COLUMN slot_type INTEGER DEFAULT 0; -- 0:日単位 1:時間枠単位

-- 商品在庫テーブルに時間枠フィールドを追加
ALTER TABLE product_stocks ADD COLUMN time_slot_start TEXT; -- HH:MM
ALTER TABLE product_stocks ADD COLUMN time_slot_end TEXT;   -- HH:MM
ALTER TABLE product_stocks ADD COLUMN time_slot_label TEXT;  -- 表示用ラベル（例：午前、午後）

-- 既存のユニークインデックスを削除
DROP INDEX IF EXISTS idx_product_stocks_product_date;

-- 新しいユニークインデックス（商品×日付×時間枠開始で一意）
CREATE UNIQUE INDEX idx_product_stocks_product_date_time 
ON product_stocks(product_id, date, time_slot_start);
-- 価格帯機能の追加

-- product_pricesテーブルに価格帯フィールドを追加
ALTER TABLE product_prices ADD COLUMN price_band TEXT; -- A-Z
ALTER TABLE product_prices ADD COLUMN price_name TEXT; -- 表示名（大人、子供など）
ALTER TABLE product_prices ADD COLUMN display_order INTEGER DEFAULT 0; -- 表示順

-- 既存のproduct_pricesレコードにデフォルト値を設定
UPDATE product_prices SET price_band = 'A', display_order = 0 WHERE price_band IS NULL;
-- 価格帯システムを5枠固定スロットシステムに変更

-- slot_number カラムを追加（1-5の固定スロット番号）
ALTER TABLE product_prices ADD COLUMN slot_number INTEGER DEFAULT 1;

-- 既存データを第1スロットに設定
UPDATE product_prices SET slot_number = 1 WHERE slot_number IS NULL OR slot_number = 0;

-- price_band は A-Z の選択式
-- price_name は各スロットの名称（例：大人、子供、幼児、60歳以上、70歳以上）
-- slot_number は 1-5 の固定枠
-- display_order は表示順（slot_numberと同じ値を推奨）

-- コメント：
-- 商品登録時に5枠固定で価格帯を設定
-- 各枠（slot_number 1-5）に対して：
--   - 価格帯記号（price_band: A-Z）を選択
--   - 価格帯名称（price_name: 大人、子供など）を入力
--   - 価格（price）を入力
-- 価格帯システムを再設計
-- 価格帯（A-Z）ごとに複数の名称（大人、子供など）を持つ構造に変更

-- 古いカラムの意味を変更
-- price_band: 価格帯記号（A, B, C, ...）
-- price_name: 名称枠の名前（大人、子供、幼児、シニア、80歳以上など）
-- slot_number: 同一価格帯内での名称の順番（1-5）

-- 例：
-- 価格帯A - 大人: price_band='A', price_name='大人', slot_number=1, price=10000
-- 価格帯A - 子供: price_band='A', price_name='子供', slot_number=2, price=7000
-- 価格帯A - 幼児: price_band='A', price_name='幼児', slot_number=3, price=5000
-- 価格帯B - 大人: price_band='B', price_name='大人', slot_number=1, price=10000
-- 価格帯B - 子供: price_band='B', price_name='子供', slot_number=2, price=7000

-- 既存データのクリーンアップ（開発環境のみ）
UPDATE product_prices SET price_band = 'A' WHERE price_band IS NULL OR price_band = '';
UPDATE product_prices SET slot_number = 1 WHERE slot_number IS NULL OR slot_number = 0;

-- インデックスを追加（価格帯とスロット番号でのクエリを高速化）
CREATE INDEX IF NOT EXISTS idx_product_prices_band_slot ON product_prices(product_id, price_band, slot_number);
-- 在庫テーブルに在庫名と価格帯を追加

-- 商品在庫テーブルに在庫名と価格帯を追加
ALTER TABLE product_stocks ADD COLUMN stock_name TEXT; -- 在庫名（午前、11時～12時など）
ALTER TABLE product_stocks ADD COLUMN price_band TEXT; -- 価格帯記号（A, B, C, ...）

-- インデックスを追加
CREATE INDEX IF NOT EXISTS idx_product_stocks_price_band ON product_stocks(price_band);

-- オプション在庫テーブルに在庫名と価格帯を追加
ALTER TABLE option_stocks ADD COLUMN stock_name TEXT; -- 在庫名
ALTER TABLE option_stocks ADD COLUMN price_band TEXT; -- 価格帯記号

-- インデックスを追加
CREATE INDEX IF NOT EXISTS idx_option_stocks_price_band ON option_stocks(price_band);

-- 既存のUNIQUE制約を削除して、在庫名を含む新しい制約を作成
-- SQLiteではALTER TABLEでINDEXを削除できないため、後でアプリケーション側で対応
-- 注: product_id + date + stock_name + price_band の組み合わせでユニークにする必要がある
-- イベント申込フォームフィールド設定テーブル

CREATE TABLE IF NOT EXISTS event_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  field_type TEXT NOT NULL, -- 'select', 'checkbox', 'radio', 'text', 'textarea', 'file', 'date'
  field_name TEXT NOT NULL, -- フィールド名（例：gender, age_group）
  field_label TEXT NOT NULL, -- 項目名（例：性別、年齢層）
  field_options TEXT, -- 選択肢（JSON形式: ["選択肢1", "選択肢2", ...]）
  is_required INTEGER DEFAULT 0, -- 0:任意 1:必須
  description TEXT, -- 説明文
  display_order INTEGER DEFAULT 0, -- 表示順
  placeholder TEXT, -- プレースホルダー
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (event_id) REFERENCES events(id)
);

CREATE INDEX IF NOT EXISTS idx_event_form_fields_event_id ON event_form_fields(event_id);
CREATE INDEX IF NOT EXISTS idx_event_form_fields_display_order ON event_form_fields(display_order);

-- サンプルデータ
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, description, display_order) VALUES
(1, 'text', 'company_name', '会社名', NULL, 0, '法人の方のみご記入ください', 1),
(1, 'select', 'age_group', '年齢層', '["20歳未満", "20代", "30代", "40代", "50代", "60歳以上"]', 1, 'ご来場者の年齢層をお選びください', 2),
(1, 'radio', 'participation_count', '参加人数', '["1名", "2名", "3-5名", "6名以上"]', 1, NULL, 3),
(1, 'checkbox', 'interests', '興味のあるプログラム', '["花火大会", "屋台グルメ", "音楽ライブ", "子供向けイベント"]', 0, '複数選択可能です', 4),
(1, 'textarea', 'special_requests', 'ご要望・お問い合わせ', NULL, 0, 'アレルギーや車椅子の利用など、特別なご要望がございましたらご記入ください', 5),
(1, 'date', 'preferred_date', '希望日', NULL, 0, '複数日程がある場合、ご希望の日付をお選びください', 6);
-- 予約時のカスタムフォームフィールド回答テーブル
CREATE TABLE IF NOT EXISTS booking_form_responses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  field_id INTEGER NOT NULL,
  field_name TEXT NOT NULL,
  field_value TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (field_id) REFERENCES event_form_fields(id)
);

CREATE INDEX idx_booking_form_responses_customer_id ON booking_form_responses(customer_id);
CREATE INDEX idx_booking_form_responses_event_id ON booking_form_responses(event_id);
CREATE INDEX idx_booking_form_responses_field_id ON booking_form_responses(field_id);
-- マイグレーション: 料金単位・説明フィールドの追加
-- 日付: 2025-11-25
-- 説明: productsテーブルに料金単位、料金タイプ、料金説明のカラムを追加

-- productsテーブルに新しいカラムを追加
ALTER TABLE products ADD COLUMN price_unit TEXT DEFAULT '人';
ALTER TABLE products ADD COLUMN charge_type TEXT DEFAULT 'per_person';
ALTER TABLE products ADD COLUMN charge_description TEXT;

-- 既存のレコードにデフォルト値を設定
UPDATE products SET price_unit = '人' WHERE price_unit IS NULL;
UPDATE products SET charge_type = 'per_person' WHERE charge_type IS NULL;
-- マイグレーション: 設問ツリー機能の追加
-- 日付: 2025-11-25
-- 説明: event_form_fieldsテーブルに親子関係のカラムを追加

-- 親フィールドID（このフィールドが依存する親フィールド）
ALTER TABLE event_form_fields ADD COLUMN parent_field_id INTEGER;

-- 親フィールドの条件値（この値が選択された場合に表示）
ALTER TABLE event_form_fields ADD COLUMN parent_condition TEXT;

-- インデント レベル（表示時の階層を示す、0=ルート）
ALTER TABLE event_form_fields ADD COLUMN indent_level INTEGER DEFAULT 0;

-- インデックス追加
CREATE INDEX IF NOT EXISTS idx_form_fields_parent ON event_form_fields(parent_field_id);
CREATE INDEX IF NOT EXISTS idx_form_fields_event_order ON event_form_fields(event_id, display_order);

-- 既存データにデフォルト値を設定
UPDATE event_form_fields SET indent_level = 0 WHERE indent_level IS NULL;
-- ワンタイムパスワード（OTP）テーブル
CREATE TABLE IF NOT EXISTS otp_codes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  code TEXT NOT NULL,
  expires_at DATETIME NOT NULL,
  is_used INTEGER DEFAULT 0,
  attempt_count INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  used_at DATETIME
);

-- インデックス作成（検索性能向上）
CREATE INDEX IF NOT EXISTS idx_otp_email ON otp_codes(email);
CREATE INDEX IF NOT EXISTS idx_otp_code ON otp_codes(code);
CREATE INDEX IF NOT EXISTS idx_otp_expires ON otp_codes(expires_at);
-- マイグレーション: product_pricesテーブルにband, descriptionカラムを追加
-- 日付: 2025-11-25
-- 説明: product_pricesテーブルに不足しているカラムを追加

-- product_pricesテーブルに新しいカラムを追加
ALTER TABLE product_prices ADD COLUMN band TEXT;
ALTER TABLE product_prices ADD COLUMN description TEXT;

-- 既存レコードのbandカラムにprice_bandの値をコピー
UPDATE product_prices SET band = price_band WHERE band IS NULL;
