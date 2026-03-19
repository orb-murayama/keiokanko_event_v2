-- クライアント（主催者）を追加
INSERT INTO clients (
  name, tel, email, password, group_id
) VALUES (
  '長岡観光コンベンション協会', 
  '0258-32-1187', 
  'info@nagaoka-navi.or.jp', 
  'password123',
  1
);

-- テストイベント
INSERT INTO events (
  name, name_en, detail, location, 
  event_start_date, event_end_date,
  category, contact, client_id, enable_flg, created_at
) VALUES (
  '長岡花火大会 2025', 
  'Nagaoka Fireworks Festival 2025',
  '日本三大花火大会の一つである長岡まつり大花火大会。信濃川河川敷で打ち上げられる大迫力の花火をお楽しみください。',
  '新潟県長岡市 信濃川河川敷',
  '2025-08-02',
  '2025-08-03',
  '1',
  'info@nagaoka-fireworks.jp',
  1,
  1,
  datetime('now')
);

-- 商品（座席タイプ）
INSERT INTO products (
  client_id, event_id, name, description,
  sales_start, sales_end, closing_trade,
  enable_flg, created_at
) VALUES (
  1, 1, 'マス席（4～5名用）',
  '4～5名様でご利用いただける桝席です。ゆったりと花火をお楽しみいただけます。',
  '2025-06-01', '2025-08-01', 0,
  1, datetime('now')
);

-- 価格帯
INSERT INTO product_prices (
  product_id, price_band, price_name, price, slot_number, created_at
) VALUES
  (1, 'A', '大人', 10000, 1, datetime('now')),
  (1, 'A', '子供', 7000, 2, datetime('now'));

-- 在庫
INSERT INTO product_stocks (
  product_id, date, stock_name, price_band,
  stock, booked, created_at
) VALUES
  (1, '2025-08-02', '1日目', 'A', 100, 0, datetime('now')),
  (1, '2025-08-03', '2日目', 'A', 100, 0, datetime('now'));
