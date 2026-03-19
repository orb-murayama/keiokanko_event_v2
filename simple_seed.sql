-- シンプルなテストイベント
INSERT INTO events (
  name, name_en, detail, location, 
  event_start_date, event_end_date,
  category, contact, enable_flg, created_at
) VALUES (
  '長岡花火大会 2025', 
  'Nagaoka Fireworks Festival 2025',
  '日本三大花火大会の一つである長岡まつり大花火大会。信濃川河川敷で打ち上げられる大迫力の花火をお楽しみください。',
  '新潟県長岡市 信濃川河川敷',
  '2025-08-02',
  '2025-08-03',
  1,
  'info@nagaoka-fireworks.jp',
  1,
  datetime('now')
);

-- 商品（座席タイプ）
INSERT INTO products (
  event_id, name, name_en, description,
  type, enable_flg, created_at
) VALUES (
  1, 'マス席（4～5名用）', 'Box Seat (4-5 persons)',
  '4～5名様でご利用いただける桝席です。ゆったりと花火をお楽しみいただけます。',
  'ticket', 1, datetime('now')
);

-- 価格帯
INSERT INTO product_prices (
  product_id, price_band_code, price_name, price, slot, enable_flg, created_at
) VALUES
  (1, 'A', '大人', 10000, 1, 1, datetime('now')),
  (1, 'A', '子供', 7000, 2, 1, datetime('now'));

-- 在庫
INSERT INTO product_stocks (
  product_id, stock_date, stock_name, price_band_code,
  total_stock, reserved_stock, enable_flg, created_at
) VALUES
  (1, '2025-08-02', '1日目', 'A', 100, 0, 1, datetime('now')),
  (1, '2025-08-03', '2日目', 'A', 100, 0, 1, datetime('now'));

-- オプション
INSERT INTO options (
  event_id, name, name_en, description, price,
  type, enable_flg, created_at
) VALUES
  (1, 'お弁当（松）', 'Lunch Box (Special)', '特製お弁当', 3000, 'food', 1, datetime('now')),
  (1, '駐車場', 'Parking', '普通車用駐車場', 2000, 'parking', 1, datetime('now'));
