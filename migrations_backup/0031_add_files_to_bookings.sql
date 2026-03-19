-- 予約テーブルにQRコードとPDFファイルのカラムを追加
ALTER TABLE product_bookings ADD COLUMN qr_code_url TEXT;
ALTER TABLE product_bookings ADD COLUMN pdf_file_url TEXT;

-- インデックスを作成
CREATE INDEX IF NOT EXISTS idx_product_bookings_qr_code ON product_bookings(qr_code_url);
CREATE INDEX IF NOT EXISTS idx_product_bookings_pdf_file ON product_bookings(pdf_file_url);
