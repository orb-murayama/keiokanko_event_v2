-- 予約添付ファイルテーブル
CREATE TABLE IF NOT EXISTS booking_files (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  booking_number TEXT NOT NULL,
  file_key TEXT NOT NULL,              -- R2のファイルキー (例: bookings/BK20260209-001/file_abc123.pdf)
  original_filename TEXT NOT NULL,      -- 実際のファイル名
  display_filename TEXT NOT NULL,       -- ユーザーに表示するファイル名
  file_size INTEGER NOT NULL,           -- ファイルサイズ（バイト）
  mime_type TEXT DEFAULT 'application/pdf',
  download_limit INTEGER DEFAULT 0,     -- ダウンロード回数制限（0=無制限）
  download_count INTEGER DEFAULT 0,     -- 現在のダウンロード回数
  display_order INTEGER DEFAULT 0,      -- 表示順序
  uploaded_by TEXT,                     -- アップロード者
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_booking_files_booking ON booking_files(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_files_number ON booking_files(booking_number);
CREATE INDEX IF NOT EXISTS idx_booking_files_key ON booking_files(file_key);
