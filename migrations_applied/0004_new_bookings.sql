-- ============================================
-- マイグレーション: 新予約管理システム
-- バージョン: 0004
-- 作成日: 2026-02-06
-- 
-- 概要:
-- - 新しい予約管理テーブル（bookings, booking_payments, booking_items, refund_history）を作成
-- - 既存のproduct_bookingsテーブルは残す（レガシーデータ用）
-- - ビューを作成して予約一覧・決済一覧を取得しやすくする
-- ============================================

-- ============================================
-- 1. bookings（予約グループ）
-- ============================================
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

CREATE INDEX IF NOT EXISTS idx_bookings_number ON bookings(booking_number);
CREATE INDEX IF NOT EXISTS idx_bookings_customer ON bookings(customer_id);
CREATE INDEX IF NOT EXISTS idx_bookings_event ON bookings(event_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_created ON bookings(created_at);

-- ============================================
-- 2. booking_payments（決済情報）
-- ============================================
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

CREATE INDEX IF NOT EXISTS idx_booking_payments_number ON booking_payments(payment_number);
CREATE INDEX IF NOT EXISTS idx_booking_payments_booking ON booking_payments(booking_number);
CREATE INDEX IF NOT EXISTS idx_booking_payments_status ON booking_payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_booking_payments_method ON booking_payments(payment_method);
CREATE INDEX IF NOT EXISTS idx_booking_payments_transaction ON booking_payments(payment_transaction_id);
CREATE INDEX IF NOT EXISTS idx_booking_payments_date ON booking_payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_booking_payments_due ON booking_payments(payment_due_date);

-- ============================================
-- 3. booking_items（予約明細）
-- ============================================
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

CREATE INDEX IF NOT EXISTS idx_booking_items_booking ON booking_items(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_payment ON booking_items(payment_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_type_id ON booking_items(item_type, item_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_status ON booking_items(status);
CREATE INDEX IF NOT EXISTS idx_booking_items_participation ON booking_items(participation_date);

-- ============================================
-- 4. refund_history（返金履歴）
-- ============================================
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

CREATE INDEX IF NOT EXISTS idx_refund_history_payment ON refund_history(payment_id);
CREATE INDEX IF NOT EXISTS idx_refund_history_item ON refund_history(booking_item_id);
CREATE INDEX IF NOT EXISTS idx_refund_history_date ON refund_history(refund_date);
CREATE INDEX IF NOT EXISTS idx_refund_history_reason ON refund_history(refund_reason);

-- ============================================
-- ビュー: 予約一覧
-- ============================================
CREATE VIEW IF NOT EXISTS v_bookings_list AS
SELECT 
  b.id,
  b.booking_number,
  b.customer_id,
  c.family_name || ' ' || c.first_name AS customer_name,
  c.email AS customer_email,
  c.mobile AS customer_phone,
  b.event_id,
  e.name AS event_name,
  b.status AS booking_status,
  b.booker_name,
  b.booker_email,
  b.booker_phone,
  
  (
    SELECT bp.payment_status
    FROM booking_payments bp
    WHERE bp.booking_number = b.booking_number
    ORDER BY bp.created_at DESC
    LIMIT 1
  ) AS latest_payment_status,
  
  (
    SELECT COALESCE(SUM(bp.net_amount), 0)
    FROM booking_payments bp
    WHERE bp.booking_number = b.booking_number
  ) AS total_amount,
  
  (
    SELECT COALESCE(SUM(bp.refunded_amount), 0)
    FROM booking_payments bp
    WHERE bp.booking_number = b.booking_number
  ) AS total_refunded,
  
  b.created_at,
  b.modified_at
FROM bookings b
LEFT JOIN customers c ON b.customer_id = c.id
LEFT JOIN events e ON b.event_id = e.id;

-- ============================================
-- ビュー: 決済一覧
-- ============================================
CREATE VIEW IF NOT EXISTS v_booking_payments_list AS
SELECT 
  bp.id,
  bp.booking_number,
  bp.payment_number,
  bp.payment_type,
  bp.payment_method,
  bp.payment_status,
  bp.amount,
  bp.refunded_amount,
  bp.net_amount,
  bp.payment_date,
  bp.payment_due_date,
  bp.refund_date,
  bp.payment_transaction_id,
  
  (
    SELECT COUNT(*)
    FROM booking_items bi
    WHERE bi.payment_id = bp.id
  ) AS item_count,
  
  (
    SELECT COALESCE(SUM(bi.quantity), 0)
    FROM booking_items bi
    WHERE bi.payment_id = bp.id
      AND bi.status = 'active'
  ) AS total_participants,
  
  bp.created_at,
  bp.modified_at
FROM booking_payments bp;
