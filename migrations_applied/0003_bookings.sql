-- ====================================
-- 予約管理システム マイグレーション DDL（簡略版）
-- ====================================
-- 作成日: 2026-02-06
-- 用途: 新規環境でのテーブル作成（インデックスとビューを含む）
-- 実行方法: npx wrangler d1 execute webapp-production --local --file=./migrations/0003_bookings.sql
-- ====================================

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
  branch_code TEXT
);

CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_customers_branch_code ON customers(branch_code);

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

CREATE INDEX IF NOT EXISTS idx_product_bookings_customer_id ON product_bookings(customer_id);
CREATE INDEX IF NOT EXISTS idx_product_bookings_product_id ON product_bookings(product_id);
CREATE INDEX IF NOT EXISTS idx_product_bookings_booking_number ON product_bookings(booking_number);
CREATE INDEX IF NOT EXISTS idx_product_bookings_booking_status ON product_bookings(booking_status);
CREATE INDEX IF NOT EXISTS idx_product_bookings_payment_status ON product_bookings(payment_status);
CREATE INDEX IF NOT EXISTS idx_product_bookings_created_at ON product_bookings(created_at);
CREATE INDEX IF NOT EXISTS idx_product_bookings_participation_date ON product_bookings(participation_date);
CREATE INDEX IF NOT EXISTS idx_product_bookings_branch_code ON product_bookings(branch_code);

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

CREATE INDEX IF NOT EXISTS idx_option_bookings_customer_id ON option_bookings(customer_id);
CREATE INDEX IF NOT EXISTS idx_option_bookings_option_id ON option_bookings(option_id);

-- 統合予約テーブル
CREATE TABLE IF NOT EXISTS bookings (
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

CREATE INDEX IF NOT EXISTS idx_bookings_member_id ON bookings(member_id);
CREATE INDEX IF NOT EXISTS idx_bookings_event_id ON bookings(event_id);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_number ON bookings(booking_number);

-- 予約明細テーブル
CREATE TABLE IF NOT EXISTS booking_items (
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

CREATE INDEX IF NOT EXISTS idx_booking_items_booking_id ON booking_items(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_item ON booking_items(item_type, item_id);

-- 予約一覧ビュー
CREATE VIEW IF NOT EXISTS v_product_bookings_list AS
SELECT 
  pb.id,
  pb.booking_number,
  pb.booking_status,
  pb.payment_status,
  pb.price,
  pb.quantity,
  pb.participation_date,
  pb.branch_code,
  pb.created_at,
  pb.modified_at,
  pb.canceled_at,
  (c.family_name || ' ' || c.first_name) as customer_name,
  c.email as customer_email,
  c.mobile as customer_phone,
  p.name as product_name,
  p.id as product_id,
  e.name as event_name,
  e.id as event_id,
  e.client_id
FROM product_bookings pb
LEFT JOIN customers c ON pb.customer_id = c.id
LEFT JOIN products p ON pb.product_id = p.id
LEFT JOIN events e ON p.event_id = e.id
WHERE pb.enable_flg = 1;
