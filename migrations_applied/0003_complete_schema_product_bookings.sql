-- ========================================
-- イベント予約管理システム 完全版マイグレーション
-- Cloudflare D1 (SQLite) 用
-- 
-- 作成日: 2025-12-26
-- このファイルは全テーブル＋最新のproduct_bookingsテーブル定義を含む完全版です
-- 
-- 使用方法:
-- 1. 既存データベースをバックアップ
-- 2. データベースを削除または新規作成
-- 3. このマイグレーションを実行
-- 
-- npx wrangler d1 execute webapp-production --local --file=migrations/0003_complete_schema.sql
-- ========================================

-- このマイグレーションは0000_consolidated_schema.sqlをベースに、
-- product_bookingsテーブルに以下のカラムを追加した完全版です:
-- - qr_code_url (QRコード画像URL)
-- - pdf_file_url (PDFファイルURL)
-- - price_items (価格項目JSON)
-- - remarks (備考)
-- - participants (参加者情報JSON)
-- - participation_date (参加日)
-- - payment_method (決済手段)
-- - payment_date (決済日時)
-- - payment_transaction_id (決済番号)
-- - bank_transfer_info (銀行振込情報JSON)
-- - convenience_store_info (コンビニ決済情報JSON)
-- - survey_answers (設問回答JSON)
-- - organizer_id (主催者ID)
-- - vendor_id (販売者ID)

-- 注意: このファイルは完全なスキーマ定義のため、
--      既存のデータベースに対して実行する場合は、
--      0001と0002のマイグレーションを個別に実行してください。

-- ========================================
-- product_bookings テーブル（完全版）
-- ========================================
-- 既存のテーブルを削除して再作成する場合のみ実行
-- DROP TABLE IF EXISTS product_bookings;

CREATE TABLE IF NOT EXISTS product_bookings (
  -- 基本情報
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT,
  customer_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  product_stock_id INTEGER,
  price INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  
  -- ステータス
  booking_status TEXT DEFAULT 'reserved',  -- reserved, confirmed, cancelled
  payment_status TEXT DEFAULT 'pending',   -- pending, paid, refunded, failed
  enable_flg INTEGER DEFAULT 1,
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,
  
  -- ファイル関連（マイグレーション0001で追加）
  qr_code_url TEXT,        -- QRコード画像URL
  pdf_file_url TEXT,       -- PDFファイルURL
  price_items TEXT,        -- 価格項目（JSON形式）
  remarks TEXT,            -- 備考
  
  -- 参加者・決済情報（マイグレーション0002で追加）
  participants TEXT,                 -- 参加者情報（JSON形式）
  participation_date TEXT,           -- 参加日
  payment_method TEXT,               -- 決済手段: credit_card, bank_transfer, convenience_store
  payment_date TEXT,                 -- 決済日時
  payment_transaction_id TEXT,       -- 決済番号（クレジットカード用）
  bank_transfer_info TEXT,           -- 銀行振込情報（JSON形式）
  convenience_store_info TEXT,       -- コンビニ決済情報（JSON形式）
  survey_answers TEXT,               -- 設問回答（JSON形式）
  organizer_id INTEGER,              -- 主催者ID
  vendor_id INTEGER,                 -- 販売者ID
  
  -- 外部キー制約
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (product_stock_id) REFERENCES product_stocks(id),
  FOREIGN KEY (organizer_id) REFERENCES organizers(id),
  FOREIGN KEY (vendor_id) REFERENCES vendors(id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_product_bookings_number ON product_bookings(booking_number);
CREATE INDEX IF NOT EXISTS idx_product_bookings_created ON product_bookings(created_at);
CREATE INDEX IF NOT EXISTS idx_product_bookings_customer ON product_bookings(customer_id);
CREATE INDEX IF NOT EXISTS idx_product_bookings_product ON product_bookings(product_id);
CREATE INDEX IF NOT EXISTS idx_product_bookings_status ON product_bookings(booking_status);
CREATE INDEX IF NOT EXISTS idx_product_bookings_payment ON product_bookings(payment_status);
CREATE INDEX IF NOT EXISTS idx_product_bookings_participation ON product_bookings(participation_date);

-- ========================================
-- 使用例: 参加者情報のJSON構造
-- ========================================
-- participants = '[
--   {
--     "name": "田中 太郎",
--     "kana": "タナカ タロウ",
--     "age": 35,
--     "gender": "male",
--     "email": "tanaka@example.com",
--     "tel": "090-1111-1111"
--   }
-- ]'

-- ========================================
-- 使用例: 価格項目のJSON構造
-- ========================================
-- price_items = '[
--   {
--     "name": "フルマラソン参加券",
--     "price": 15000,
--     "quantity": 1,
--     "isMain": true
--   },
--   {
--     "name": "記録証明書",
--     "price": 1000,
--     "quantity": 1,
--     "isMain": false
--   }
-- ]'

-- ========================================
-- 使用例: 銀行振込情報のJSON構造
-- ========================================
-- bank_transfer_info = '{
--   "bank_name": "みずほ銀行",
--   "branch_name": "東京支店",
--   "account_type": "普通",
--   "account_number": "1234567",
--   "account_holder": "株式会社イベント企画",
--   "transfer_deadline": "2025-12-30"
-- }'

-- ========================================
-- 使用例: コンビニ決済情報のJSON構造
-- ========================================
-- convenience_store_info = '{
--   "store_name": "セブンイレブン",
--   "payment_code": "12345-67890-11111",
--   "payment_deadline": "2025-12-31"
-- }'

-- ========================================
-- 使用例: 設問回答のJSON構造
-- ========================================
-- survey_answers = '[
--   {
--     "question": "参加動機をお聞かせください",
--     "answer": "健康のためにマラソンを始めたいと思い、参加を決めました。"
--   }
-- ]'
