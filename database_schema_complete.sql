-- ====================================
-- イベント予約管理システム - 完全なデータベーススキーマ
-- 生成日時: 2026-01-28 10:00:43
-- 注意: このファイルは実際のデータベースから生成された完全版DDLです
-- ====================================

-- ====================================
-- テーブル定義
-- ====================================

-- ----------------------------------------
-- テーブル: accounts
-- ----------------------------------------
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
, expiration_date TEXT DEFAULT NULL, tel TEXT DEFAULT NULL, mobile TEXT DEFAULT NULL)
;

-- ----------------------------------------
-- テーブル: booking_items
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: bookings
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: branches
-- ----------------------------------------
CREATE TABLE branches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_code TEXT UNIQUE NOT NULL,
  branch_name TEXT NOT NULL,
  branch_full_name TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------------------
-- テーブル: categories
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: clients
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: customers
-- ----------------------------------------
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
  canceled_at TEXT
, branch_code TEXT)
;

-- ----------------------------------------
-- テーブル: event_form_fields
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: events
-- ----------------------------------------
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
  auto_reply_credit_refund TEXT,
  auto_reply_bank_deposit TEXT,
  auto_reply_bank_refund TEXT,
  auto_reply_convenience_deposit TEXT,
  auto_reply_convenience_refund TEXT,
  
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
  auto_reply_convenience_refund_en TEXT, parent_event_id INTEGER, event_type TEXT DEFAULT 'standalone', branch_code TEXT, image_url TEXT, payment_credit_card INTEGER DEFAULT 0, payment_bank_transfer INTEGER DEFAULT 0, payment_convenience_store INTEGER DEFAULT 0, cancel_policy TEXT, cancellation_policy_details TEXT, cancellation_days_1 INTEGER, cancellation_rate_1 INTEGER, cancellation_days_2 INTEGER, cancellation_rate_2 INTEGER, cancellation_days_3 INTEGER,
  FOREIGN KEY (client_id) REFERENCES clients(id)
)
;

-- ----------------------------------------
-- テーブル: members
-- ----------------------------------------
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
, mobile TEXT DEFAULT NULL)
;

-- ----------------------------------------
-- テーブル: option_bookings
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: option_categories
-- ----------------------------------------
CREATE TABLE option_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
)
;

-- ----------------------------------------
-- テーブル: option_forms
-- ----------------------------------------
CREATE TABLE option_forms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  form_type INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
)
;

-- ----------------------------------------
-- テーブル: option_inherited_products
-- ----------------------------------------
CREATE TABLE option_inherited_products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
)
;

-- ----------------------------------------
-- テーブル: option_prices
-- ----------------------------------------
CREATE TABLE option_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
)
;

-- ----------------------------------------
-- テーブル: option_shared_stock_pools
-- ----------------------------------------
CREATE TABLE option_shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pool_name TEXT NOT NULL,
  total_stock INTEGER DEFAULT 0,
  booked INTEGER DEFAULT 0,
  available INTEGER DEFAULT 0,
  event_id INTEGER,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
)
;

-- ----------------------------------------
-- テーブル: option_stocks
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: options
-- ----------------------------------------
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
  deleted_at TEXT, image_url TEXT,
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (option_category_id) REFERENCES option_categories(id)
)
;

-- ----------------------------------------
-- テーブル: organizers
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: prefs
-- ----------------------------------------
CREATE TABLE prefs (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
)
;

-- ----------------------------------------
-- テーブル: product_bookings
-- ----------------------------------------
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
  canceled_at TEXT, qr_code_url TEXT, pdf_file_url TEXT, price_items TEXT, remarks TEXT, participants TEXT, participation_date TEXT, payment_method TEXT, payment_date TEXT, payment_transaction_id TEXT, bank_transfer_info TEXT, convenience_store_info TEXT, survey_answers TEXT, organizer_id INTEGER, vendor_id INTEGER, branch_code TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (product_stock_id) REFERENCES product_stocks(id)
)
;

-- ----------------------------------------
-- テーブル: product_categories
-- ----------------------------------------
CREATE TABLE product_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
)
;

-- ----------------------------------------
-- テーブル: product_form_fields
-- ----------------------------------------
CREATE TABLE product_form_fields (
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
  modified_at TEXT DEFAULT (datetime('now','localtime'))
)
;

-- ----------------------------------------
-- テーブル: product_prices
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: product_shared_stock_pools
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: product_stocks
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: products
-- ----------------------------------------
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
  charge_description TEXT, image_url TEXT, form_field_settings TEXT DEFAULT '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}',
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (product_category_id) REFERENCES product_categories(id)
)
;

-- ----------------------------------------
-- テーブル: shared_stock_pools
-- ----------------------------------------
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
)
;

-- ----------------------------------------
-- テーブル: vendors
-- ----------------------------------------
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
)
;


-- ====================================
-- インデックス定義
-- ====================================

CREATE INDEX idx_accounts_account_type ON accounts(account_type);
CREATE INDEX idx_accounts_email ON accounts(email);
CREATE INDEX idx_accounts_expiration_date ON accounts(expiration_date);
CREATE INDEX idx_accounts_login_id ON accounts(login_id);
CREATE INDEX idx_accounts_mobile ON accounts(mobile);
CREATE INDEX idx_accounts_primary_branch ON accounts(primary_branch_code);
CREATE INDEX idx_accounts_tel ON accounts(tel);
CREATE INDEX idx_bookings_event_id ON bookings(event_id);
CREATE INDEX idx_bookings_member_id ON bookings(member_id);
CREATE INDEX idx_branches_code ON branches(branch_code);
CREATE INDEX idx_branches_enable ON branches(enable_flg);
CREATE INDEX idx_clients_email ON clients(email);
CREATE INDEX idx_clients_group_id ON clients(group_id);
CREATE INDEX idx_customers_branch_code ON customers(branch_code);
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_events_branch_code ON events(branch_code);
CREATE INDEX idx_events_client_id ON events(client_id);
CREATE INDEX idx_events_company_flg ON events(company_flg);
CREATE INDEX idx_events_deleted_at ON events(deleted_at);
CREATE INDEX idx_events_enable_flg ON events(enable_flg);
CREATE INDEX idx_events_event_type ON events(event_type);
CREATE INDEX idx_events_event_url ON events(event_url);
CREATE INDEX idx_events_parent_event_id ON events(parent_event_id);
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_members_mobile ON members(mobile);
CREATE INDEX idx_option_stocks_option_id ON option_stocks(option_id);
CREATE INDEX idx_options_event_id ON options(event_id);
CREATE INDEX idx_product_bookings_branch_code ON product_bookings(branch_code);
CREATE INDEX idx_product_bookings_created;
ON product_bookings(created_at);
CREATE INDEX idx_product_bookings_customer ON product_bookings(customer_id);
CREATE INDEX idx_product_bookings_customer_id ON product_bookings(customer_id);
CREATE INDEX idx_product_bookings_number;
ON product_bookings(booking_number);
CREATE INDEX idx_product_bookings_participation ON product_bookings(participation_date);
CREATE INDEX idx_product_bookings_payment ON product_bookings(payment_status);
CREATE INDEX idx_product_bookings_product ON product_bookings(product_id);
CREATE INDEX idx_product_bookings_product_id ON product_bookings(product_id);
CREATE INDEX idx_product_bookings_status ON product_bookings(booking_status);
CREATE INDEX idx_product_categories_name ON product_categories(name);
CREATE INDEX idx_product_form_fields_display_order;
ON product_form_fields(product_id, display_order);
CREATE INDEX idx_product_form_fields_parent;
ON product_form_fields(parent_field_id);
CREATE INDEX idx_product_form_fields_product_id;
ON product_form_fields(product_id);
CREATE INDEX idx_product_shared_stock_pools_pool_id;
ON product_shared_stock_pools(shared_stock_pool_id);
CREATE INDEX idx_product_shared_stock_pools_product_id;
ON product_shared_stock_pools(product_id);
CREATE INDEX idx_product_stocks_date ON product_stocks(date);
CREATE INDEX idx_product_stocks_product_id ON product_stocks(product_id);
CREATE INDEX idx_products_client_id ON products(client_id);
CREATE INDEX idx_products_enable_flg ON products(enable_flg);
CREATE INDEX idx_products_event_id ON products(event_id);
CREATE UNIQUE INDEX idx_products_event_name ON products(event_id, name);
CREATE INDEX idx_products_sales_end ON products(sales_end);
CREATE INDEX idx_products_sales_start ON products(sales_start);
CREATE INDEX idx_shared_stock_pools_enable;
ON shared_stock_pools(enable_flg);
CREATE INDEX idx_shared_stock_pools_pool_date;
ON shared_stock_pools(pool_name, pool_code, date);

-- スキーマ生成完了
