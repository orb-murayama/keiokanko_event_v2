-- ========================================
-- イベント予約管理システム - 現在のDBスキーマ
-- Cloudflare D1 (SQLite) 用
-- 
-- 生成日時: 2026-01-19
-- 全29テーブル + インデックス
-- ========================================

-- ========================================
-- 1. accounts - アカウント管理テーブル
-- ========================================
CREATE TABLE accounts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  login_id TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  person_name TEXT NOT NULL,
  email TEXT NOT NULL,
  client_id INTEGER,
  role TEXT NOT NULL,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  account_type TEXT DEFAULT 'keio',
  primary_branch_code TEXT,
  accessible_branches TEXT
);

CREATE INDEX idx_accounts_account_type ON accounts(account_type);
CREATE INDEX idx_accounts_email ON accounts(email);
CREATE INDEX idx_accounts_login_id ON accounts(login_id);
CREATE INDEX idx_accounts_primary_branch ON accounts(primary_branch_code);

-- ========================================
-- 2. booking_items - 予約明細テーブル
-- ========================================
CREATE TABLE booking_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  item_type TEXT NOT NULL,
  item_id INTEGER NOT NULL,
  item_name TEXT NOT NULL,
  stock_id INTEGER,
  price_category TEXT,
  quantity INTEGER NOT NULL,
  unit_price INTEGER NOT NULL,
  subtotal INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

-- ========================================
-- 3. bookings - 予約管理テーブル
-- ========================================
CREATE TABLE bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT UNIQUE NOT NULL,
  member_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  booking_date DATE NOT NULL,
  total_amount INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  payment_method TEXT,
  payment_status TEXT DEFAULT 'unpaid',
  is_proxy BOOLEAN DEFAULT 0,
  booker_family_name TEXT NOT NULL,
  booker_first_name TEXT NOT NULL,
  booker_family_kana TEXT NOT NULL,
  booker_first_kana TEXT NOT NULL,
  booker_tel TEXT NOT NULL,
  booker_email TEXT NOT NULL,
  booker_zip TEXT NOT NULL,
  booker_addr TEXT NOT NULL,
  booker_emergency_contact TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (member_id) REFERENCES members(id),
  FOREIGN KEY (event_id) REFERENCES events(id)
);

CREATE INDEX idx_bookings_event_id ON bookings(event_id);
CREATE INDEX idx_bookings_member_id ON bookings(member_id);

-- ========================================
-- 4. branches - 支店マスタテーブル
-- ========================================
CREATE TABLE branches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_code TEXT UNIQUE NOT NULL,
  branch_name TEXT NOT NULL,
  branch_full_name TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_branches_code ON branches(branch_code);
CREATE INDEX idx_branches_enable ON branches(enable_flg);

-- ========================================
-- 5. categories - カテゴリーテーブル
-- ========================================
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  slug TEXT UNIQUE,
  description TEXT,
  parent_id INTEGER,
  display_order INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- ========================================
-- 6. clients - クライアント（主催者）テーブル
-- ========================================
CREATE TABLE clients (
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
  group_id INTEGER NOT NULL DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  client_code TEXT,
  position TEXT
);

CREATE INDEX idx_clients_email ON clients(email);
CREATE INDEX idx_clients_group_id ON clients(group_id);

-- ========================================
-- 7. customers - 顧客テーブル
-- ========================================
CREATE TABLE customers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  family_name TEXT,
  first_name TEXT,
  family_kana TEXT,
  first_kana TEXT,
  sex INTEGER,
  birth TEXT,
  mobile TEXT,
  tel TEXT,
  fax TEXT,
  email TEXT,
  zip TEXT,
  pref_id INTEGER,
  city TEXT,
  addr TEXT,
  bldg TEXT,
  password TEXT,
  payment TEXT,
  answer TEXT,
  remark TEXT,
  mailme_flg INTEGER DEFAULT 0,
  contact TEXT,
  company_name TEXT,
  department_name TEXT,
  free1 TEXT,
  free2 TEXT,
  free3 TEXT,
  free4 TEXT,
  free5 TEXT,
  free6 TEXT,
  agent_number TEXT,
  enable_flg INTEGER DEFAULT 1,
  payment_select INTEGER DEFAULT 0,
  payment_status INTEGER DEFAULT 0,
  uniqid TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,
  branch_code TEXT
);

CREATE INDEX idx_customers_branch_code ON customers(branch_code);
CREATE INDEX idx_customers_email ON customers(email);

-- ========================================
-- 8. event_form_fields - イベントフォームフィールドテーブル
-- ========================================
CREATE TABLE event_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  field_type TEXT NOT NULL,
  field_name TEXT NOT NULL,
  field_label TEXT NOT NULL,
  field_options TEXT,
  is_required INTEGER DEFAULT 0,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  placeholder TEXT,
  parent_field_id INTEGER,
  parent_condition TEXT,
  indent_level INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (event_id) REFERENCES events(id)
);

-- ========================================
-- 9. events - イベント管理テーブル（86+カラム）
-- ========================================
CREATE TABLE events (
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
  company_flg INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  payment_flg INTEGER DEFAULT 0,
  payment_cd TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  -- 基本情報拡張
  customer_client_id INTEGER,
  vendor_id INTEGER,
  event_url TEXT,
  category TEXT,
  deleted_at TEXT,
  date_selection_type TEXT DEFAULT 'single',
  location TEXT,
  payment_methods TEXT,
  credit_fee_type TEXT,
  bank_fee_type TEXT,
  convenience_fee_type TEXT,
  registration_start_date TEXT,
  registration_end_date TEXT,
  event_start_date TEXT,
  event_end_date TEXT,
  admin_email TEXT,
  admin_name TEXT,
  -- 英語版フィールド
  name_en TEXT,
  detail_en TEXT,
  location_en TEXT,
  contact_en TEXT,
  remarks_en TEXT,
  thanks_msg_en TEXT,
  -- 主催者・管理者情報
  organizer_id INTEGER,
  admin_login_start_date TEXT,
  admin_login_end_date TEXT,
  admin_cc_email TEXT,
  sender_name TEXT,
  sender_email TEXT,
  email_signature TEXT,
  email_signature_en TEXT,
  -- 銀行振込情報
  bank_name TEXT,
  bank_branch TEXT,
  bank_account_type TEXT,
  bank_account_number TEXT,
  bank_account_name TEXT,
  bank_transfer_deadline INTEGER,
  -- コンビニ決済情報
  store_code TEXT,
  convenience_payment_deadline INTEGER,
  available_convenience_stores TEXT,
  -- 手数料設定
  credit_fee_percentage REAL,
  credit_fee_fixed INTEGER,
  bank_fee_percentage REAL,
  bank_fee_fixed INTEGER,
  convenience_fee_percentage REAL,
  convenience_fee_fixed INTEGER,
  -- フォーム設定
  form_field_settings TEXT,
  -- 自動返信メール設定
  auto_reply_enabled INTEGER DEFAULT 0,
  auto_reply_credit_payment TEXT,
  auto_reply_bank_payment TEXT,
  auto_reply_convenience_payment TEXT,
  auto_reply_credit_cancel TEXT,
  auto_reply_bank_cancel TEXT,
  auto_reply_convenience_cancel TEXT,
  auto_reply_credit_refund TEXT,
  auto_reply_bank_deposit TEXT,
  auto_reply_bank_refund TEXT,
  auto_reply_convenience_deposit TEXT,
  auto_reply_convenience_refund TEXT,
  -- 自動返信メール（英語版）
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
  -- 追加カラム
  parent_event_id INTEGER,
  event_type TEXT DEFAULT 'standalone',
  branch_code TEXT,
  image_url TEXT,
  payment_credit_card INTEGER DEFAULT 0,
  payment_bank_transfer INTEGER DEFAULT 0,
  payment_convenience_store INTEGER DEFAULT 0,
  FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE INDEX idx_events_branch_code ON events(branch_code);
CREATE INDEX idx_events_client_id ON events(client_id);
CREATE INDEX idx_events_company_flg ON events(company_flg);
CREATE INDEX idx_events_deleted_at ON events(deleted_at);
CREATE INDEX idx_events_enable_flg ON events(enable_flg);
CREATE INDEX idx_events_event_type ON events(event_type);
CREATE INDEX idx_events_event_url ON events(event_url);
CREATE INDEX idx_events_parent_event_id ON events(parent_event_id);

-- ========================================
-- 10. members - 会員テーブル
-- ========================================
CREATE TABLE members (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  family_name TEXT NOT NULL,
  first_name TEXT NOT NULL,
  family_kana TEXT NOT NULL,
  first_kana TEXT NOT NULL,
  last_name_en TEXT,
  first_name_en TEXT,
  sex TEXT,
  birth DATE,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  tel TEXT NOT NULL,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

CREATE INDEX idx_members_email ON members(email);

-- ========================================
-- 11. option_bookings - オプション予約テーブル
-- ========================================
CREATE TABLE option_bookings (
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

-- ========================================
-- 12. option_categories - オプションカテゴリーテーブル
-- ========================================
CREATE TABLE option_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- ========================================
-- 13. option_forms - オプションフォームテーブル
-- ========================================
CREATE TABLE option_forms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  form_type INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);

-- ========================================
-- 14. option_inherited_products - オプション継承商品テーブル
-- ========================================
CREATE TABLE option_inherited_products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ========================================
-- 15. option_prices - オプション価格テーブル
-- ========================================
CREATE TABLE option_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);

-- ========================================
-- 16. option_shared_stock_pools - オプション共有在庫プールテーブル
-- ========================================
CREATE TABLE option_shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pool_name TEXT NOT NULL,
  total_stock INTEGER DEFAULT 0,
  booked INTEGER DEFAULT 0,
  available INTEGER DEFAULT 0,
  event_id INTEGER,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- ========================================
-- 17. option_stocks - オプション在庫テーブル
-- ========================================
CREATE TABLE option_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  date TEXT,
  stock INTEGER NOT NULL DEFAULT 0,
  booked INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  stock_name TEXT,
  price INTEGER,
  total_stock INTEGER DEFAULT 0,
  available_stock INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  shared_pool_id INTEGER,
  FOREIGN KEY (option_id) REFERENCES options(id)
);

CREATE INDEX idx_option_stocks_option_id ON option_stocks(option_id);

-- ========================================
-- 18. options - オプション管理テーブル
-- ========================================
CREATE TABLE options (
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
  deleted_at TEXT,
  image_url TEXT,
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (option_category_id) REFERENCES option_categories(id)
);

CREATE INDEX idx_options_event_id ON options(event_id);

-- ========================================
-- 19. organizers - 主催者テーブル
-- ========================================
CREATE TABLE organizers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  contactable_person TEXT,
  email TEXT,
  tel TEXT,
  branch_office TEXT,
  reg_flg INTEGER DEFAULT 1,
  deleted_at TEXT,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  fax TEXT,
  password TEXT,
  business_hours TEXT,
  closed_days TEXT,
  business_notes TEXT,
  registration_number TEXT,
  association_name TEXT,
  association_membership TEXT,
  travel_manager_title TEXT,
  travel_manager_name TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- ========================================
-- 20. prefs - 都道府県マスタテーブル
-- ========================================
CREATE TABLE prefs (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

-- ========================================
-- 21. product_bookings - 商品予約テーブル
-- ========================================
CREATE TABLE product_bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT,
  customer_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  product_stock_id INTEGER,
  price INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  booking_status TEXT DEFAULT 'reserved',
  payment_status TEXT DEFAULT 'pending',
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,
  qr_code_url TEXT,
  pdf_file_url TEXT,
  price_items TEXT,
  remarks TEXT,
  participants TEXT,
  participation_date TEXT,
  payment_method TEXT,
  payment_date TEXT,
  payment_transaction_id TEXT,
  bank_transfer_info TEXT,
  convenience_store_info TEXT,
  survey_answers TEXT,
  organizer_id INTEGER,
  vendor_id INTEGER,
  branch_code TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (product_stock_id) REFERENCES product_stocks(id)
);

CREATE INDEX idx_product_bookings_branch_code ON product_bookings(branch_code);
CREATE INDEX idx_product_bookings_created ON product_bookings(created_at);
CREATE INDEX idx_product_bookings_customer ON product_bookings(customer_id);
CREATE INDEX idx_product_bookings_customer_id ON product_bookings(customer_id);
CREATE INDEX idx_product_bookings_number ON product_bookings(booking_number);
CREATE INDEX idx_product_bookings_participation ON product_bookings(participation_date);
CREATE INDEX idx_product_bookings_payment ON product_bookings(payment_status);
CREATE INDEX idx_product_bookings_product ON product_bookings(product_id);
CREATE INDEX idx_product_bookings_product_id ON product_bookings(product_id);
CREATE INDEX idx_product_bookings_status ON product_bookings(booking_status);

-- ========================================
-- 22. product_categories - 商品カテゴリーテーブル
-- ========================================
CREATE TABLE product_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- ========================================
-- 23. product_prices - 商品価格テーブル
-- ========================================
CREATE TABLE product_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  price_band TEXT,
  price_name TEXT,
  display_order INTEGER DEFAULT 0,
  slot_number INTEGER DEFAULT 1,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ========================================
-- 24. product_shared_stock_pools - 商品共有在庫プールテーブル
-- ========================================
CREATE TABLE product_shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  shared_stock_pool_id INTEGER NOT NULL,
  stock_name TEXT,
  price_band TEXT,
  enable_flg INTEGER DEFAULT 1,
  priority INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (shared_stock_pool_id) REFERENCES shared_stock_pools(id)
);

CREATE INDEX idx_product_shared_stock_pools_pool_id ON product_shared_stock_pools(shared_stock_pool_id);
CREATE INDEX idx_product_shared_stock_pools_product_id ON product_shared_stock_pools(product_id);

-- ========================================
-- 25. product_stocks - 商品在庫テーブル
-- ========================================
CREATE TABLE product_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  date TEXT NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0,
  booked INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  time_slot_start TEXT,
  time_slot_end TEXT,
  time_slot_label TEXT,
  stock_name TEXT,
  shared_pool_id INTEGER,
  price_band TEXT,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_product_stocks_date ON product_stocks(date);
CREATE INDEX idx_product_stocks_product_id ON product_stocks(product_id);

-- ========================================
-- 26. products - 商品管理テーブル
-- ========================================
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  sales_start TEXT NOT NULL,
  sales_end TEXT NOT NULL,
  closing_trade INTEGER NOT NULL DEFAULT 0,
  product_category_id INTEGER,
  description TEXT,
  remarks TEXT,
  fee_include TEXT,
  fee_exclude TEXT,
  cancel_policy TEXT,
  purchase_limit INTEGER,
  deposit_address TEXT,
  note TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  slot_type INTEGER DEFAULT 0,
  deleted_at TEXT,
  -- キャンセルポリシー詳細
  cancellation_days_1 INTEGER,
  cancellation_rate_1 INTEGER,
  cancellation_days_2 INTEGER,
  cancellation_rate_2 INTEGER,
  cancellation_days_3 INTEGER,
  cancellation_rate_3 INTEGER,
  cancellation_days_4 INTEGER,
  cancellation_rate_4 INTEGER,
  cancellation_days_5 INTEGER,
  cancellation_rate_5 INTEGER,
  -- 価格・課金設定
  common_names TEXT,
  cancellation_policy_details TEXT,
  price_unit TEXT DEFAULT '人',
  charge_type TEXT DEFAULT 'per_person',
  charge_description TEXT,
  image_url TEXT,
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (product_category_id) REFERENCES product_categories(id)
);

CREATE INDEX idx_products_client_id ON products(client_id);
CREATE INDEX idx_products_enable_flg ON products(enable_flg);
CREATE INDEX idx_products_event_id ON products(event_id);
CREATE UNIQUE INDEX idx_products_event_name ON products(event_id, name);
CREATE INDEX idx_products_sales_end ON products(sales_end);
CREATE INDEX idx_products_sales_start ON products(sales_start);

-- ========================================
-- 27. shared_stock_pools - 共有在庫プールテーブル（日付・時間帯別管理）
-- ========================================
CREATE TABLE shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pool_name TEXT NOT NULL,
  pool_code TEXT,
  description TEXT,
  date TEXT NOT NULL,
  time_slot_start TEXT,
  time_slot_end TEXT,
  time_slot_label TEXT,
  total_stock INTEGER DEFAULT 0,
  booked INTEGER DEFAULT 0,
  available_stock INTEGER GENERATED ALWAYS AS (total_stock - booked) VIRTUAL,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

CREATE INDEX idx_shared_stock_pools_enable ON shared_stock_pools(enable_flg);
CREATE INDEX idx_shared_stock_pools_pool_date ON shared_stock_pools(pool_name, pool_code, date);

-- ========================================
-- 28. vendors - 販売業者テーブル
-- ========================================
CREATE TABLE vendors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  contactable_person TEXT,
  email TEXT,
  tel TEXT,
  reg_flg INTEGER DEFAULT 1,
  deleted_at TEXT,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  fax TEXT,
  password TEXT,
  business_hours TEXT,
  closed_days TEXT,
  business_notes TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- ========================================
-- マスタデータ
-- ========================================

-- 都道府県マスタデータ（47都道府県）
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

-- 支店マスタデータ（18支店）
INSERT OR IGNORE INTO branches (branch_code, branch_name, branch_full_name, display_order) VALUES
('01', '東京中央支店', '東京中央支店:01', 1),
('02', '東京南支店', '東京南支店:02', 2),
('03', '東京東支店', '東京東支店:03', 3),
('04', 'イベント＆ツアー センター', 'イベント＆ツアー センター:04', 4),
('05', 'さいたま支店', 'さいたま支店:05', 5),
('06', '調布支店', '調布支店:06', 6),
('07', '立川支店', '立川支店:07', 7),
('08', '八王子支店', '八王子支店:08', 8),
('09', '神奈川北支店', '神奈川北支店:09', 9),
('10', '町田営業所', '町田営業所:10', 10),
('11', '団体旅行営業部スポーツセールス担当', '団体旅行営業部スポーツセールス担当:11', 11),
('12', '札幌支店', '札幌支店:12', 12),
('13', '仙台支店', '仙台支店:13', 13),
('14', '大阪支店', '大阪支店:14', 14),
('15', '大阪西支店', '大阪西支店:15', 15),
('16', '福岡支店', '福岡支店:16', 16),
('17', '旅行事業部', '旅行事業部:17', 17),
('18', '経営管理部', '経営管理部:18', 18);
