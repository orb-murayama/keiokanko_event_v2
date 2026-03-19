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
