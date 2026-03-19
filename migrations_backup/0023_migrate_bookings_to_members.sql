-- Step 1: product_bookingsテーブルに新しいmember_idカラムを追加
ALTER TABLE product_bookings ADD COLUMN member_id INTEGER;

-- Step 2: 新しいインデックスを作成
CREATE INDEX IF NOT EXISTS idx_product_bookings_member_id ON product_bookings(member_id);

-- Note: 既存のcustomer_idカラムは互換性のため残しますが、今後はmember_idを使用します
-- 将来的にデータ移行が完了したら、customer_idカラムとcustomersテーブルを削除できます
