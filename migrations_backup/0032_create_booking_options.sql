-- 予約オプション（明細）テーブル作成
CREATE TABLE IF NOT EXISTS booking_options (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  item_type TEXT NOT NULL DEFAULT 'option', -- 'main' or 'option'
  item_name TEXT NOT NULL,
  price INTEGER NOT NULL DEFAULT 0,
  quantity INTEGER NOT NULL DEFAULT 1,
  subtotal INTEGER NOT NULL DEFAULT 0,
  enable_flg INTEGER NOT NULL DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_id) REFERENCES product_bookings(id)
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_booking_options_booking_id ON booking_options(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_options_item_type ON booking_options(item_type);
CREATE INDEX IF NOT EXISTS idx_booking_options_enable_flg ON booking_options(enable_flg);
