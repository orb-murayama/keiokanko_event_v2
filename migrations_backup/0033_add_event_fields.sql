-- イベントテーブルに詳細フィールドを追加

-- 基本情報
ALTER TABLE events ADD COLUMN event_url TEXT;
ALTER TABLE events ADD COLUMN category TEXT;
ALTER TABLE events ADD COLUMN event_start_date TEXT;
ALTER TABLE events ADD COLUMN event_end_date TEXT;
ALTER TABLE events ADD COLUMN registration_start_date TEXT;
ALTER TABLE events ADD COLUMN registration_end_date TEXT;
ALTER TABLE events ADD COLUMN cancel_deadline TEXT;
ALTER TABLE events ADD COLUMN admin_login_start_date TEXT;
ALTER TABLE events ADD COLUMN admin_login_end_date TEXT;

-- メール関連
ALTER TABLE events ADD COLUMN admin_email TEXT;
ALTER TABLE events ADD COLUMN admin_cc_email TEXT;
ALTER TABLE events ADD COLUMN sender_name TEXT;
ALTER TABLE events ADD COLUMN sender_email TEXT;
ALTER TABLE events ADD COLUMN email_signature TEXT;
ALTER TABLE events ADD COLUMN contact_info TEXT;

-- 決済関連
ALTER TABLE events ADD COLUMN store_code TEXT;
ALTER TABLE events ADD COLUMN bank_transfer_deadline INTEGER DEFAULT 7;
ALTER TABLE events ADD COLUMN convenience_payment_deadline INTEGER DEFAULT 7;
ALTER TABLE events ADD COLUMN available_convenience_stores TEXT;

-- 決済手数料（クレジットカード）
ALTER TABLE events ADD COLUMN credit_fee_enabled INTEGER DEFAULT 0;
ALTER TABLE events ADD COLUMN credit_fee_type TEXT DEFAULT 'none';
ALTER TABLE events ADD COLUMN credit_fee_percentage REAL DEFAULT 0;
ALTER TABLE events ADD COLUMN credit_fee_fixed INTEGER DEFAULT 0;

-- 決済手数料（銀行振込）
ALTER TABLE events ADD COLUMN bank_fee_enabled INTEGER DEFAULT 0;
ALTER TABLE events ADD COLUMN bank_fee_type TEXT DEFAULT 'none';
ALTER TABLE events ADD COLUMN bank_fee_percentage REAL DEFAULT 0;
ALTER TABLE events ADD COLUMN bank_fee_fixed INTEGER DEFAULT 0;

-- 決済手数料（コンビニ）
ALTER TABLE events ADD COLUMN convenience_fee_enabled INTEGER DEFAULT 0;
ALTER TABLE events ADD COLUMN convenience_fee_type TEXT DEFAULT 'none';
ALTER TABLE events ADD COLUMN convenience_fee_percentage REAL DEFAULT 0;
ALTER TABLE events ADD COLUMN convenience_fee_fixed INTEGER DEFAULT 0;

-- オートリプライメール設定
ALTER TABLE events ADD COLUMN auto_reply_enabled INTEGER DEFAULT 1;

-- 決済完了時
ALTER TABLE events ADD COLUMN auto_reply_credit_payment TEXT;
ALTER TABLE events ADD COLUMN auto_reply_bank_payment TEXT;
ALTER TABLE events ADD COLUMN auto_reply_convenience_payment TEXT;

-- 取消時
ALTER TABLE events ADD COLUMN auto_reply_credit_cancel TEXT;
ALTER TABLE events ADD COLUMN auto_reply_bank_cancel TEXT;
ALTER TABLE events ADD COLUMN auto_reply_convenience_cancel TEXT;

-- その他自動送信メール
ALTER TABLE events ADD COLUMN auto_reply_credit_refund TEXT;
ALTER TABLE events ADD COLUMN auto_reply_bank_deposit TEXT;
ALTER TABLE events ADD COLUMN auto_reply_bank_refund TEXT;
ALTER TABLE events ADD COLUMN auto_reply_convenience_deposit TEXT;
ALTER TABLE events ADD COLUMN auto_reply_convenience_refund TEXT;

-- インデックス追加
CREATE INDEX IF NOT EXISTS idx_events_event_start_date ON events(event_start_date);
CREATE INDEX IF NOT EXISTS idx_events_event_end_date ON events(event_end_date);
CREATE INDEX IF NOT EXISTS idx_events_registration_start_date ON events(registration_start_date);
CREATE INDEX IF NOT EXISTS idx_events_registration_end_date ON events(registration_end_date);
CREATE INDEX IF NOT EXISTS idx_events_category ON events(category);
