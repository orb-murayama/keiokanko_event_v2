-- テスト用予約データ作成

-- まずcustomersテーブルにダミーデータを作成（外部キー制約のため）
INSERT OR IGNORE INTO customers (id, family_name, first_name, email, tel) 
VALUES (1, 'ダミー', '顧客', 'dummy@example.com', '00-0000-0000');

-- product_bookingsにテストデータを挿入
INSERT OR IGNORE INTO product_bookings (
  id, customer_id, member_id, product_id, price, quantity, 
  booking_status, payment_status, payment_method, payment_amount,
  service_date, service_time,
  applicant_info, booking_fields,
  enable_flg, created_at
) VALUES (
  999, 1, 1, 1, 15000, 2,
  'reserved', 'paid', 'クレジットカード', 30000,
  '2025-02-15', '10:00-12:00',
  '{"last_name":"山田","first_name":"太郎","tel":"03-1234-5678","zip":"100-0001","pref":"東京都","addr":"千代田区千代田1-1-1","birth_date":"1985-03-15"}',
  '[{"label":"参加目的","value":"観光"},{"label":"アレルギー","value":"なし"}]',
  1, datetime('now', 'localtime')
);
