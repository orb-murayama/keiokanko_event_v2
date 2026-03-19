-- ワンタイムパスワード（OTP）テーブル
CREATE TABLE IF NOT EXISTS otp_codes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  code TEXT NOT NULL,
  expires_at DATETIME NOT NULL,
  is_used INTEGER DEFAULT 0,
  attempt_count INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  used_at DATETIME
);

-- インデックス作成（検索性能向上）
CREATE INDEX IF NOT EXISTS idx_otp_email ON otp_codes(email);
CREATE INDEX IF NOT EXISTS idx_otp_code ON otp_codes(code);
CREATE INDEX IF NOT EXISTS idx_otp_expires ON otp_codes(expires_at);
