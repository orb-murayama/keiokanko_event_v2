-- product_bookingsテーブルに詳細情報カラムを追加

-- 予約ステータス: reserved(予約済み), canceled(取消)
ALTER TABLE product_bookings ADD COLUMN booking_status TEXT DEFAULT 'reserved';

-- 決済ステータス: paid(決済済み), pending(決済待ち), cancel_fee_paid(取消料決済済み)
ALTER TABLE product_bookings ADD COLUMN payment_status TEXT DEFAULT 'pending';

-- 決済手段
ALTER TABLE product_bookings ADD COLUMN payment_method TEXT;

-- 決済金額
ALTER TABLE product_bookings ADD COLUMN payment_amount INTEGER;

-- 取消料
ALTER TABLE product_bookings ADD COLUMN cancel_fee INTEGER DEFAULT 0;

-- サービス日
ALTER TABLE product_bookings ADD COLUMN service_date TEXT;

-- 時間帯
ALTER TABLE product_bookings ADD COLUMN service_time TEXT;

-- 申込者情報（JSON形式で保存）
ALTER TABLE product_bookings ADD COLUMN applicant_info TEXT;

-- 申込情報（カスタムフィールド、JSON形式で保存）
ALTER TABLE product_bookings ADD COLUMN booking_fields TEXT;

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_product_bookings_booking_status ON product_bookings(booking_status);
CREATE INDEX IF NOT EXISTS idx_product_bookings_payment_status ON product_bookings(payment_status);
CREATE INDEX IF NOT EXISTS idx_product_bookings_service_date ON product_bookings(service_date);
