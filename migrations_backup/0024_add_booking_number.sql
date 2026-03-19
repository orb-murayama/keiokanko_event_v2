-- product_bookingsテーブルに予約番号カラムを追加
ALTER TABLE product_bookings ADD COLUMN booking_number TEXT;

-- 予約番号でのインデックスを作成
CREATE INDEX IF NOT EXISTS idx_product_bookings_booking_number ON product_bookings(booking_number);

-- 予約番号はアプリケーション側で生成
-- フォーマット: {イベントID}-{クライアントID}-{6桁シーケンス}
-- 例: 1-CLI001-000001
