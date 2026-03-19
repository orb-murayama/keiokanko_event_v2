-- ================================================
-- データベース全テーブルDDL
-- 作成日: 2026-02-17
-- データベース: webapp-production (D1)
-- ================================================

-- pragma設定
PRAGMA foreign_keys = ON;
PRAGMA defer_foreign_keys = TRUE;

-- ================================================
-- アカウント・認証関連テーブル
-- ================================================

-- アカウントテーブル
CREATE TABLE IF NOT EXISTS accounts (
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
  accessible_branches TEXT,
  expiration_date TEXT DEFAULT NULL,
  tel TEXT DEFAULT NULL,
  mobile TEXT DEFAULT NULL
);

-- 会員テーブル
CREATE TABLE IF NOT EXISTS members (
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
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  mobile TEXT DEFAULT NULL
);

-- 顧客テーブル
CREATE TABLE IF NOT EXISTS customers (
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
  branch_code TEXT,
  address TEXT
);

-- ================================================
-- 組織・拠点関連テーブル
-- ================================================

-- 支店テーブル
CREATE TABLE IF NOT EXISTS branches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_code TEXT UNIQUE NOT NULL,
  branch_name TEXT NOT NULL,
  branch_full_name TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- クライアントテーブル
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
  group_id INTEGER NOT NULL DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  client_code TEXT,
  position TEXT
);

-- 主催者テーブル
CREATE TABLE IF NOT EXISTS organizers (
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

-- 販売会社テーブル
CREATE TABLE IF NOT EXISTS vendors (
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

-- 都道府県テーブル
CREATE TABLE IF NOT EXISTS prefs (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

-- ================================================
-- イベント・カテゴリー関連テーブル
-- ================================================

-- カテゴリーテーブル
CREATE TABLE IF NOT EXISTS categories (
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

-- イベントテーブル
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
  company_flg INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  payment_flg INTEGER DEFAULT 0,
  payment_cd TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
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
  name_en TEXT,
  detail_en TEXT,
  location_en TEXT,
  contact_en TEXT,
  remarks_en TEXT,
  thanks_msg_en TEXT,
  organizer_id INTEGER,
  admin_login_start_date TEXT,
  admin_login_end_date TEXT,
  admin_cc_email TEXT,
  sender_name TEXT,
  sender_email TEXT,
  email_signature TEXT,
  email_signature_en TEXT,
  bank_name TEXT,
  bank_branch TEXT,
  bank_account_type TEXT,
  bank_account_number TEXT,
  bank_account_name TEXT,
  bank_transfer_deadline INTEGER,
  store_code TEXT,
  convenience_payment_deadline INTEGER,
  available_convenience_stores TEXT,
  credit_fee_percentage REAL,
  credit_fee_fixed INTEGER,
  bank_fee_percentage REAL,
  bank_fee_fixed INTEGER,
  convenience_fee_percentage REAL,
  convenience_fee_fixed INTEGER,
  form_field_settings TEXT,
  auto_reply_enabled INTEGER DEFAULT 0,
  auto_reply_credit_payment TEXT,
  auto_reply_bank_payment TEXT,
  auto_reply_convenience_payment TEXT,
  auto_reply_credit_cancel TEXT,
  auto_reply_bank_cancel TEXT,
  auto_reply_convenience_cancel TEXT,
  image_url TEXT
);

-- イベント担当者テーブル
CREATE TABLE IF NOT EXISTS event_staff (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  UNIQUE(event_id, account_id)
);

-- イベントフォームフィールドテーブル
CREATE TABLE IF NOT EXISTS event_form_fields (
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

-- ================================================
-- 商品関連テーブル
-- ================================================

-- 商品カテゴリーテーブル
CREATE TABLE IF NOT EXISTS product_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- 商品テーブル
CREATE TABLE IF NOT EXISTS products (
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
  common_names TEXT,
  cancellation_policy_details TEXT,
  price_unit TEXT DEFAULT '人',
  charge_type TEXT DEFAULT 'per_person',
  charge_description TEXT,
  form_field_settings TEXT DEFAULT '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}',
  image_url TEXT,
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (product_category_id) REFERENCES product_categories(id)
);

-- 商品価格テーブル
CREATE TABLE IF NOT EXISTS product_prices (
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

-- 商品在庫テーブル
CREATE TABLE IF NOT EXISTS product_stocks (
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

-- 商品フォームフィールドテーブル
CREATE TABLE IF NOT EXISTS product_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
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
  validation_rule TEXT,
  default_value TEXT,
  help_text TEXT,
  created_at TEXT DEFAULT (datetime('now','localtime')),
  modified_at TEXT DEFAULT (datetime('now','localtime')),
  category INTEGER DEFAULT 1
);

-- 共有在庫プールテーブル
CREATE TABLE IF NOT EXISTS shared_stock_pools (
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

-- 商品共有在庫プールテーブル
CREATE TABLE IF NOT EXISTS product_shared_stock_pools (
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

-- ================================================
-- オプション関連テーブル
-- ================================================

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
  deleted_at TEXT,
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (option_category_id) REFERENCES option_categories(id)
);

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

-- オプション在庫テーブル
CREATE TABLE IF NOT EXISTS option_stocks (
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

-- オプションフォームテーブル
CREATE TABLE IF NOT EXISTS option_forms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  form_type INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);

-- オプション継承商品テーブル
CREATE TABLE IF NOT EXISTS option_inherited_products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- オプション共有在庫プールテーブル
CREATE TABLE IF NOT EXISTS option_shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pool_name TEXT NOT NULL,
  total_stock INTEGER DEFAULT 0,
  booked INTEGER DEFAULT 0,
  available INTEGER DEFAULT 0,
  event_id INTEGER,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- ================================================
-- 予約関連テーブル
-- ================================================

-- 予約テーブル
CREATE TABLE IF NOT EXISTS bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT UNIQUE NOT NULL,
  customer_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  status TEXT DEFAULT 'active',
  booker_name TEXT,
  booker_email TEXT,
  booker_phone TEXT,
  additional_info TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (event_id) REFERENCES events(id)
);

-- 予約明細テーブル
CREATE TABLE IF NOT EXISTS booking_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  payment_id INTEGER,
  item_type TEXT NOT NULL,
  item_id INTEGER NOT NULL,
  item_name TEXT NOT NULL,
  stock_id INTEGER,
  price_category TEXT,
  quantity INTEGER DEFAULT 1,
  unit_price INTEGER NOT NULL,
  subtotal INTEGER NOT NULL,
  participation_date TEXT,
  participants TEXT,
  status TEXT DEFAULT 'active',
  canceled_at TEXT,
  cancel_reason TEXT,
  refund_amount INTEGER DEFAULT 0,
  item_details TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (payment_id) REFERENCES booking_payments(id)
);

-- 予約支払いテーブル
CREATE TABLE IF NOT EXISTS booking_payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,
  payment_number TEXT UNIQUE NOT NULL,
  payment_type TEXT NOT NULL DEFAULT 'immediate',
  payment_method TEXT NOT NULL,
  payment_status TEXT DEFAULT 'pending',
  amount INTEGER NOT NULL,
  refunded_amount INTEGER DEFAULT 0,
  net_amount INTEGER GENERATED ALWAYS AS (amount - refunded_amount) STORED,
  payment_date TEXT,
  payment_due_date TEXT,
  refund_date TEXT,
  payment_transaction_id TEXT,
  payment_details TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_number) REFERENCES bookings(booking_number)
);

-- 商品予約テーブル
CREATE TABLE IF NOT EXISTS product_bookings (
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

-- 返金履歴テーブル
CREATE TABLE IF NOT EXISTS refund_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  payment_id INTEGER NOT NULL,
  booking_item_id INTEGER,
  refund_amount INTEGER NOT NULL,
  refund_method TEXT,
  refund_date TEXT DEFAULT (datetime('now', 'localtime')),
  refund_transaction_id TEXT,
  refund_reason TEXT,
  refund_details TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (payment_id) REFERENCES booking_payments(id),
  FOREIGN KEY (booking_item_id) REFERENCES booking_items(id)
);

-- ================================================
-- メール・メッセージ関連テーブル
-- ================================================

-- メールテンプレートテーブル
CREATE TABLE IF NOT EXISTS email_templates (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  template_name TEXT NOT NULL UNIQUE,
  description TEXT,
  from_email TEXT NOT NULL,
  bcc_email TEXT,
  subject_template TEXT NOT NULL,
  body_template TEXT NOT NULL,
  is_active INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime'))
);

-- 予約メールテーブル
CREATE TABLE IF NOT EXISTS booking_emails (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,
  from_email TEXT NOT NULL,
  to_email TEXT NOT NULL,
  bcc_email TEXT,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  scheduled_send_at DATETIME NOT NULL,
  send_status TEXT DEFAULT 'pending',
  sent_at DATETIME,
  error_message TEXT,
  template_id INTEGER,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (template_id) REFERENCES email_templates(id)
);

-- 予約メッセージテーブル
CREATE TABLE IF NOT EXISTS booking_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  booking_number TEXT NOT NULL,
  recipient_email TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  scheduled_send_at TEXT NOT NULL,
  sent_at TEXT,
  send_status TEXT DEFAULT 'pending',
  display_on_mypage INTEGER DEFAULT 1,
  created_by TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

-- ================================================
-- ファイル管理関連テーブル
-- ================================================

-- 予約ファイルテーブル
CREATE TABLE IF NOT EXISTS booking_files (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,
  file_key TEXT NOT NULL,
  original_filename TEXT NOT NULL,
  display_filename TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  download_limit INTEGER DEFAULT 0,
  download_count INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_number) REFERENCES bookings(booking_number)
);

-- ================================================
-- マイグレーション管理テーブル
-- ================================================

-- マイグレーションテーブル
CREATE TABLE IF NOT EXISTS d1_migrations(
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  name       TEXT UNIQUE,
  applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- ================================================
-- インデックス作成
-- ================================================

-- アカウント関連インデックス
CREATE INDEX IF NOT EXISTS idx_accounts_login_id ON accounts(login_id);
CREATE INDEX IF NOT EXISTS idx_accounts_email ON accounts(email);
CREATE INDEX IF NOT EXISTS idx_accounts_role ON accounts(role);

-- 予約関連インデックス
CREATE INDEX IF NOT EXISTS idx_bookings_customer_id ON bookings(customer_id);
CREATE INDEX IF NOT EXISTS idx_bookings_event_id ON bookings(event_id);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_number ON bookings(booking_number);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

-- 予約明細インデックス
CREATE INDEX IF NOT EXISTS idx_booking_items_booking_id ON booking_items(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_payment_id ON booking_items(payment_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_item_type ON booking_items(item_type);

-- 予約支払いインデックス
CREATE INDEX IF NOT EXISTS idx_booking_payments_booking_number ON booking_payments(booking_number);
CREATE INDEX IF NOT EXISTS idx_booking_payments_payment_number ON booking_payments(payment_number);
CREATE INDEX IF NOT EXISTS idx_booking_payments_payment_status ON booking_payments(payment_status);

-- 商品関連インデックス
CREATE INDEX IF NOT EXISTS idx_products_event_id ON products(event_id);
CREATE INDEX IF NOT EXISTS idx_products_client_id ON products(client_id);
CREATE INDEX IF NOT EXISTS idx_product_stocks_product_id ON product_stocks(product_id);
CREATE INDEX IF NOT EXISTS idx_product_stocks_date ON product_stocks(date);

-- オプション関連インデックス
CREATE INDEX IF NOT EXISTS idx_options_event_id ON options(event_id);
CREATE INDEX IF NOT EXISTS idx_option_stocks_option_id ON option_stocks(option_id);

-- イベント関連インデックス
CREATE INDEX IF NOT EXISTS idx_events_client_id ON events(client_id);
CREATE INDEX IF NOT EXISTS idx_events_category ON events(category);
CREATE INDEX IF NOT EXISTS idx_event_staff_event_id ON event_staff(event_id);
CREATE INDEX IF NOT EXISTS idx_event_staff_account_id ON event_staff(account_id);

-- 顧客関連インデックス
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_members_email ON members(email);

-- ================================================
-- DDL作成完了
-- ================================================
