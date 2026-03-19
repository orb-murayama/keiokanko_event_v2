-- Migration 0030: Create otp_codes table for customer OTP authentication
-- Created: 2026-03-02

-- Create otp_codes table for customer login OTP
CREATE TABLE IF NOT EXISTS otp_codes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  code TEXT NOT NULL,
  expires_at DATETIME NOT NULL,
  is_used INTEGER DEFAULT 0,
  used_at DATETIME,
  session_token TEXT UNIQUE,
  attempt_count INTEGER DEFAULT 0,
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_otp_codes_email ON otp_codes(email);
CREATE INDEX IF NOT EXISTS idx_otp_codes_session_token ON otp_codes(session_token);
CREATE INDEX IF NOT EXISTS idx_otp_codes_code ON otp_codes(code);
