-- 決済テーブルの構造変更
-- refunded_amount と net_amount カラムを削除

-- SQLiteはALTER TABLE DROP COLUMNをサポートしていないため、
-- テーブルを再作成する方法を使用

-- 1. 新しいテーブル構造を作成
CREATE TABLE booking_payments_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,
  payment_number TEXT UNIQUE NOT NULL,
  payment_type TEXT NOT NULL, -- 'immediate', 'deferred', 'refund'
  payment_method TEXT, -- 'credit_card', 'bank_transfer', 'cash', 'refund', etc.
  payment_status TEXT NOT NULL, -- 'pending', 'completed', 'canceled', 'refund_pending', 'refunded'
  amount INTEGER NOT NULL,
  payment_date DATETIME,
  payment_due_date DATETIME,
  refund_date DATETIME,
  payment_transaction_id TEXT,
  payment_details TEXT,
  remarks TEXT,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_number) REFERENCES bookings(booking_number)
);

-- 2. 既存データをコピー（refunded_amount と net_amount を除く）
INSERT INTO booking_payments_new (
  id,
  booking_number,
  payment_number,
  payment_type,
  payment_method,
  payment_status,
  amount,
  payment_date,
  payment_due_date,
  refund_date,
  payment_transaction_id,
  payment_details,
  remarks,
  created_at,
  modified_at
)
SELECT 
  id,
  booking_number,
  payment_number,
  payment_type,
  payment_method,
  payment_status,
  amount,
  payment_date,
  payment_due_date,
  refund_date,
  payment_transaction_id,
  payment_details,
  remarks,
  created_at,
  modified_at
FROM booking_payments;

-- 3. 古いテーブルを削除
DROP TABLE booking_payments;

-- 4. 新しいテーブルをリネーム
ALTER TABLE booking_payments_new RENAME TO booking_payments;

-- 5. インデックスを再作成
CREATE INDEX idx_booking_payments_booking_number ON booking_payments(booking_number);
CREATE INDEX idx_booking_payments_payment_status ON booking_payments(payment_status);
CREATE INDEX idx_booking_payments_payment_type ON booking_payments(payment_type);
