-- 予約管理テストデータ
-- このSQLファイルは予約管理画面のテストデータを作成します

-- ====================================
-- 1. テスト用顧客データ
-- ====================================

-- 顧客1: 山田太郎（東京）
INSERT OR IGNORE INTO customers (
  id, family_name, first_name, family_kana, first_kana, 
  sex, birth, mobile, tel, email, 
  zip, pref_id, city, addr, bldg,
  company_name, department_name, branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  1, '山田', '太郎', 'ヤマダ', 'タロウ',
  1, '1985-03-15', '090-1234-5678', '03-1234-5678', 'yamada.taro@example.com',
  '100-0001', 13, '千代田区', '丸の内1-1-1', 'ABCビル3F',
  '株式会社サンプル商事', '営業部', '001',
  1, datetime('now', 'localtime', '-30 days'), datetime('now', 'localtime', '-30 days')
);

-- 顧客2: 佐藤花子（大阪）
INSERT OR IGNORE INTO customers (
  id, family_name, first_name, family_kana, first_kana,
  sex, birth, mobile, tel, email,
  zip, pref_id, city, addr,
  company_name, branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  2, '佐藤', '花子', 'サトウ', 'ハナコ',
  2, '1990-07-20', '080-2345-6789', '06-2345-6789', 'sato.hanako@example.com',
  '530-0001', 27, '大阪市北区', '梅田2-2-2',
  '株式会社テスト企画', '002',
  1, datetime('now', 'localtime', '-25 days'), datetime('now', 'localtime', '-25 days')
);

-- 顧客3: 鈴木一郎（福岡）
INSERT OR IGNORE INTO customers (
  id, family_name, first_name, family_kana, first_kana,
  sex, birth, mobile, email,
  zip, pref_id, city, addr,
  branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  3, '鈴木', '一郎', 'スズキ', 'イチロウ',
  1, '1988-11-10', '090-3456-7890', 'suzuki.ichiro@example.com',
  '810-0001', 40, '福岡市中央区', '天神3-3-3',
  '003',
  1, datetime('now', 'localtime', '-20 days'), datetime('now', 'localtime', '-20 days')
);

-- 顧客4: 高橋美咲（北海道）
INSERT OR IGNORE INTO customers (
  id, family_name, first_name, family_kana, first_kana,
  sex, birth, mobile, email,
  zip, pref_id, city, addr,
  branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  4, '高橋', '美咲', 'タカハシ', 'ミサキ',
  2, '1992-05-25', '080-4567-8901', 'takahashi.misaki@example.com',
  '060-0001', 1, '札幌市中央区', '北1条西4-4-4',
  '004',
  1, datetime('now', 'localtime', '-15 days'), datetime('now', 'localtime', '-15 days')
);

-- 顧客5: 田中健太（京都）
INSERT OR IGNORE INTO customers (
  id, family_name, first_name, family_kana, first_kana,
  sex, birth, mobile, email,
  zip, pref_id, city, addr,
  branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  5, '田中', '健太', 'タナカ', 'ケンタ',
  1, '1995-09-08', '090-5678-9012', 'tanaka.kenta@example.com',
  '600-8216', 26, '京都市下京区', '烏丸通四条下ル',
  '005',
  1, datetime('now', 'localtime', '-10 days'), datetime('now', 'localtime', '-10 days')
);

-- 顧客6: 伊藤さくら（沖縄）
INSERT OR IGNORE INTO customers (
  id, family_name, first_name, family_kana, first_kana,
  sex, birth, mobile, email,
  zip, pref_id, city, addr,
  branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  6, '伊藤', 'さくら', 'イトウ', 'サクラ',
  2, '1987-12-15', '080-6789-0123', 'ito.sakura@example.com',
  '900-0015', 47, '那覇市', '久茂地5-5-5',
  '002',
  1, datetime('now', 'localtime', '-8 days'), datetime('now', 'localtime', '-8 days')
);

-- ====================================
-- 2. 予約データ（product_bookings）
-- ====================================

-- 予約1: 東京サマーフェスティバル - 一般入場券（確定・支払い完了）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method, payment_date, payment_transaction_id,
  participants, price_items, remarks, branch_code,
  qr_code_url, pdf_file_url,
  enable_flg, created_at, modified_at
) VALUES (
  1, 'BK20240201-001', 1, 1, NULL,
  5000, 2, 'confirmed', 'completed',
  '2024-08-15', 'credit_card', datetime('now', 'localtime', '-28 days'), 'TXN-20240201-001',
  '[{"name":"山田太郎","age":39,"gender":"男性"},{"name":"山田花子","age":37,"gender":"女性"}]',
  '[{"name":"一般入場券","price":2500,"quantity":2,"subtotal":5000}]',
  '家族での参加です。よろしくお願いします。', '001',
  'https://example.com/qr/BK20240201-001.png', 'https://example.com/pdf/BK20240201-001.pdf',
  1, datetime('now', 'localtime', '-30 days'), datetime('now', 'localtime', '-28 days')
);

-- 予約2: 東京サマーフェスティバル - VIP入場券（予約済み・未払い）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method,
  participants, price_items, remarks, branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  2, 'BK20240202-001', 2, 2, NULL,
  10000, 1, 'reserved', 'pending',
  '2024-08-15', 'bank_transfer',
  '[{"name":"佐藤花子","age":34,"gender":"女性"}]',
  '[{"name":"VIP入場券","price":10000,"quantity":1,"subtotal":10000}]',
  'VIP席希望です', '002',
  1, datetime('now', 'localtime', '-25 days'), datetime('now', 'localtime', '-25 days')
);

-- 予約3: 大阪マラソン - フルマラソン（確定・支払い完了）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method, payment_date, payment_transaction_id,
  participants, price_items, branch_code,
  qr_code_url, pdf_file_url,
  enable_flg, created_at, modified_at
) VALUES (
  3, 'BK20240203-001', 3, 3, NULL,
  8000, 1, 'confirmed', 'completed',
  '2024-09-10', 'credit_card', datetime('now', 'localtime', '-18 days'), 'TXN-20240203-001',
  '[{"name":"鈴木一郎","age":36,"gender":"男性"}]',
  '[{"name":"フルマラソン参加費","price":8000,"quantity":1,"subtotal":8000}]',
  '003',
  'https://example.com/qr/BK20240203-001.png', 'https://example.com/pdf/BK20240203-001.pdf',
  1, datetime('now', 'localtime', '-20 days'), datetime('now', 'localtime', '-18 days')
);

-- 予約4: 大阪マラソン - ハーフマラソン（キャンセル）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method, payment_date, payment_transaction_id,
  participants, price_items, remarks, branch_code,
  canceled_at,
  enable_flg, created_at, modified_at
) VALUES (
  4, 'BK20240204-001', 4, 4, NULL,
  5000, 1, 'canceled', 'completed',
  '2024-09-10', 'credit_card', datetime('now', 'localtime', '-14 days'), 'TXN-20240204-001',
  '[{"name":"高橋美咲","age":32,"gender":"女性"}]',
  '[{"name":"ハーフマラソン参加費","price":5000,"quantity":1,"subtotal":5000}]',
  '体調不良のためキャンセルします', '004',
  datetime('now', 'localtime', '-5 days'),
  1, datetime('now', 'localtime', '-15 days'), datetime('now', 'localtime', '-5 days')
);

-- 予約5: 京都クラシックコンサート - S席（確定・支払い完了）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method, payment_date, payment_transaction_id,
  participants, price_items, remarks, branch_code,
  qr_code_url, pdf_file_url,
  enable_flg, created_at, modified_at
) VALUES (
  5, 'BK20240205-001', 5, 5, NULL,
  15000, 2, 'confirmed', 'completed',
  '2024-10-05', 'convenience_store', datetime('now', 'localtime', '-8 days'), 'TXN-20240205-001',
  '[{"name":"田中健太","age":29,"gender":"男性"},{"name":"田中由美","age":28,"gender":"女性"}]',
  '[{"name":"S席チケット","price":7500,"quantity":2,"subtotal":15000}]',
  'カップルで参加します', '005',
  'https://example.com/qr/BK20240205-001.png', 'https://example.com/pdf/BK20240205-001.pdf',
  1, datetime('now', 'localtime', '-10 days'), datetime('now', 'localtime', '-8 days')
);

-- 予約6: 北海道グルメフェア（予約済み・未払い）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method,
  participants, price_items, remarks, branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  6, 'BK20240206-001', 4, 6, NULL,
  3000, 3, 'reserved', 'pending',
  '2024-11-20', 'bank_transfer',
  '[{"name":"高橋美咲","age":32,"gender":"女性"},{"name":"高橋太郎","age":35,"gender":"男性"},{"name":"高橋花子","age":8,"gender":"女性"}]',
  '[{"name":"グルメフェア入場券","price":1000,"quantity":3,"subtotal":3000}]',
  '家族3人で参加します', '004',
  1, datetime('now', 'localtime', '-7 days'), datetime('now', 'localtime', '-7 days')
);

-- 予約7: 沖縄リゾートツアー（確定・支払い完了）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method, payment_date, payment_transaction_id,
  participants, price_items, remarks, branch_code,
  qr_code_url, pdf_file_url,
  enable_flg, created_at, modified_at
) VALUES (
  7, 'BK20240207-001', 6, 7, NULL,
  50000, 2, 'confirmed', 'completed',
  '2024-12-15', 'credit_card', datetime('now', 'localtime', '-6 days'), 'TXN-20240207-001',
  '[{"name":"伊藤さくら","age":37,"gender":"女性"},{"name":"伊藤大輔","age":40,"gender":"男性"}]',
  '[{"name":"沖縄リゾート2泊3日","price":25000,"quantity":2,"subtotal":50000}]',
  '記念日旅行です。楽しみにしています！', '002',
  'https://example.com/qr/BK20240207-001.png', 'https://example.com/pdf/BK20240207-001.pdf',
  1, datetime('now', 'localtime', '-8 days'), datetime('now', 'localtime', '-6 days')
);

-- 予約8: 東京サマーフェスティバル - 一般入場券（予約済み・未払い）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method,
  participants, price_items, branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  8, 'BK20240208-001', 1, 1, NULL,
  7500, 3, 'reserved', 'pending',
  '2024-08-16', 'credit_card',
  '[{"name":"山田太郎","age":39,"gender":"男性"},{"name":"山田花子","age":37,"gender":"女性"},{"name":"山田太郎","age":10,"gender":"男性"}]',
  '[{"name":"一般入場券","price":2500,"quantity":3,"subtotal":7500}]',
  '001',
  1, datetime('now', 'localtime', '-3 days'), datetime('now', 'localtime', '-3 days')
);

-- 予約9: 大阪マラソン - フルマラソン（予約済み・支払い失敗）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method,
  participants, price_items, remarks, branch_code,
  enable_flg, created_at, modified_at
) VALUES (
  9, 'BK20240209-001', 2, 3, NULL,
  8000, 1, 'reserved', 'failed',
  '2024-09-10', 'credit_card',
  '[{"name":"佐藤花子","age":34,"gender":"女性"}]',
  '[{"name":"フルマラソン参加費","price":8000,"quantity":1,"subtotal":8000}]',
  'クレジットカード決済エラーが発生しました', '002',
  1, datetime('now', 'localtime', '-2 days'), datetime('now', 'localtime', '-2 days')
);

-- 予約10: 京都クラシックコンサート - A席（確定・支払い完了）
INSERT OR IGNORE INTO product_bookings (
  id, booking_number, customer_id, product_id, product_stock_id,
  price, quantity, booking_status, payment_status,
  participation_date, payment_method, payment_date, payment_transaction_id,
  participants, price_items, branch_code,
  qr_code_url, pdf_file_url,
  enable_flg, created_at, modified_at
) VALUES (
  10, 'BK20240210-001', 3, 8, NULL,
  10000, 2, 'confirmed', 'completed',
  '2024-10-05', 'credit_card', datetime('now', 'localtime', '-1 days'), 'TXN-20240210-001',
  '[{"name":"鈴木一郎","age":36,"gender":"男性"},{"name":"鈴木京子","age":34,"gender":"女性"}]',
  '[{"name":"A席チケット","price":5000,"quantity":2,"subtotal":10000}]',
  '003',
  'https://example.com/qr/BK20240210-001.png', 'https://example.com/pdf/BK20240210-001.pdf',
  1, datetime('now', 'localtime', '-1 days'), datetime('now', 'localtime', '-1 days')
);

-- ====================================
-- 確認用クエリ（実行しない - 参考用）
-- ====================================

-- 顧客データ確認
-- SELECT id, family_name, first_name, email, branch_code FROM customers WHERE id BETWEEN 1 AND 6;

-- 予約データ確認
-- SELECT 
--   pb.id, pb.booking_number, pb.booking_status, pb.payment_status,
--   (c.family_name || ' ' || c.first_name) as customer_name,
--   e.name as event_name, p.name as product_name,
--   pb.price, pb.quantity, pb.branch_code
-- FROM product_bookings pb
-- LEFT JOIN customers c ON pb.customer_id = c.id
-- LEFT JOIN products p ON pb.product_id = p.id
-- LEFT JOIN events e ON p.event_id = e.id
-- WHERE pb.id BETWEEN 1 AND 10
-- ORDER BY pb.created_at DESC;

-- ステータス別件数確認
-- SELECT booking_status, COUNT(*) as count FROM product_bookings WHERE id BETWEEN 1 AND 10 GROUP BY booking_status;
-- SELECT payment_status, COUNT(*) as count FROM product_bookings WHERE id BETWEEN 1 AND 10 GROUP BY payment_status;
