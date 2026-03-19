-- マイグレーション: product_bookingsテーブルにファイル関連カラムを追加

-- QRコードURL
ALTER TABLE product_bookings ADD COLUMN qr_code_url TEXT;

-- PDFファイルURL
ALTER TABLE product_bookings ADD COLUMN pdf_file_url TEXT;

-- 価格項目（JSON形式で複数の価格項目を保存）
ALTER TABLE product_bookings ADD COLUMN price_items TEXT;

-- 備考
ALTER TABLE product_bookings ADD COLUMN remarks TEXT;
