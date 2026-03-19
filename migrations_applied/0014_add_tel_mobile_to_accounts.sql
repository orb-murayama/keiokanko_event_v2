-- アカウントテーブルに電話番号カラムを追加
-- 2026-01-21

-- 電話番号カラムを追加（TEXT型、NULL許可）
ALTER TABLE accounts ADD COLUMN tel TEXT DEFAULT NULL;

-- 携帯電話カラムを追加（TEXT型、NULL許可）
ALTER TABLE accounts ADD COLUMN mobile TEXT DEFAULT NULL;

-- インデックスを追加（電話番号での検索を高速化）
CREATE INDEX IF NOT EXISTS idx_accounts_tel ON accounts(tel);
CREATE INDEX IF NOT EXISTS idx_accounts_mobile ON accounts(mobile);
