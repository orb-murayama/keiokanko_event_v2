-- booking_messagesテーブルを再作成
DROP TABLE IF EXISTS booking_messages;
CREATE TABLE booking_messages (
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
  created_at TEXT DEFAULT (datetime('now','localtime')),
  modified_at TEXT DEFAULT (datetime('now','localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE INDEX idx_booking_messages_booking_id ON booking_messages(booking_id);
CREATE INDEX idx_booking_messages_booking_number ON booking_messages(booking_number);

-- booking_filesテーブルを再作成
DROP TABLE IF EXISTS booking_files;
CREATE TABLE booking_files (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  booking_number TEXT NOT NULL,
  file_key TEXT NOT NULL,
  original_filename TEXT NOT NULL,
  display_filename TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  download_limit INTEGER DEFAULT 0,
  download_count INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now','localtime')),
  modified_at TEXT DEFAULT (datetime('now','localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE INDEX idx_booking_files_booking_id ON booking_files(booking_id);
CREATE INDEX idx_booking_files_booking_number ON booking_files(booking_number);

-- booking_paymentsテーブルを再作成
DROP TABLE IF EXISTS booking_payments;
CREATE TABLE booking_payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  booking_number TEXT NOT NULL,
  payment_number TEXT UNIQUE NOT NULL,
  payment_type TEXT NOT NULL,
  payment_method TEXT NOT NULL,
  payment_status TEXT DEFAULT 'pending',
  amount INTEGER NOT NULL,
  net_amount INTEGER,
  fee_amount INTEGER,
  tax_amount INTEGER,
  gmo_order_id TEXT,
  gmo_access_id TEXT,
  gmo_access_pass TEXT,
  gmo_transaction_id TEXT,
  refund_amount INTEGER DEFAULT 0,
  refund_status TEXT,
  refund_date TEXT,
  payment_date TEXT,
  created_at TEXT DEFAULT (datetime('now','localtime')),
  modified_at TEXT DEFAULT (datetime('now','localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE INDEX idx_booking_payments_booking_id ON booking_payments(booking_id);
CREATE INDEX idx_booking_payments_booking_number ON booking_payments(booking_number);
CREATE INDEX idx_booking_payments_payment_number ON booking_payments(payment_number);
