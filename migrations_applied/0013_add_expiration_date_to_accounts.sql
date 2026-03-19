-- アカウントテーブルに有効期限カラムを追加
-- 2026-01-19

-- 有効期限カラムを追加（TEXT型、NULL許可）
ALTER TABLE accounts ADD COLUMN expiration_date TEXT DEFAULT NULL;

-- インデックスを追加（有効期限での検索を高速化）
CREATE INDEX IF NOT EXISTS idx_accounts_expiration_date ON accounts(expiration_date);

-- 既存データにコメントを追加（必要に応じて）
-- UPDATE accounts SET expiration_date = '2026-12-31' WHERE expiration_date IS NULL AND enable_flg = 1;
