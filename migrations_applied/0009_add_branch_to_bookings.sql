-- 予約管理に担当支店情報を追加

-- product_bookingsテーブルに担当支店コードを追加
ALTER TABLE product_bookings ADD COLUMN branch_code TEXT;

-- customersテーブルに担当支店コードを追加
ALTER TABLE customers ADD COLUMN branch_code TEXT;

-- インデックスを作成（検索パフォーマンス向上）
CREATE INDEX IF NOT EXISTS idx_product_bookings_branch_code ON product_bookings(branch_code);
CREATE INDEX IF NOT EXISTS idx_customers_branch_code ON customers(branch_code);
