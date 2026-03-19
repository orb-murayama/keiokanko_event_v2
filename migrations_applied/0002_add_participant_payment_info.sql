-- マイグレーション: 参加者情報、決済情報、設問回答などを追加

-- 参加者情報（JSON形式で複数参加者を保存）
ALTER TABLE product_bookings ADD COLUMN participants TEXT;

-- 参加日
ALTER TABLE product_bookings ADD COLUMN participation_date TEXT;

-- 決済手段 (credit_card, bank_transfer, convenience_store)
ALTER TABLE product_bookings ADD COLUMN payment_method TEXT;

-- 決済日時
ALTER TABLE product_bookings ADD COLUMN payment_date TEXT;

-- 決済番号（クレジットカード）
ALTER TABLE product_bookings ADD COLUMN payment_transaction_id TEXT;

-- 銀行振込情報（JSON形式）
ALTER TABLE product_bookings ADD COLUMN bank_transfer_info TEXT;

-- コンビニ決済情報（JSON形式）
ALTER TABLE product_bookings ADD COLUMN convenience_store_info TEXT;

-- 設問回答（JSON形式）
ALTER TABLE product_bookings ADD COLUMN survey_answers TEXT;

-- 主催者ID
ALTER TABLE product_bookings ADD COLUMN organizer_id INTEGER;

-- 販売者ID
ALTER TABLE product_bookings ADD COLUMN vendor_id INTEGER;
