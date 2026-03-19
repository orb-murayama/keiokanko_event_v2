-- 予約ファイル管理テーブル
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

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_booking_files_booking_number ON booking_files(booking_number);
CREATE INDEX IF NOT EXISTS idx_booking_files_file_key ON booking_files(file_key);
