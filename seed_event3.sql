-- 最小限のテストデータ
-- イベントID=3用

-- 1. 会員データ（既存を想定）
INSERT OR IGNORE INTO members (id, email, password_hash, family_name, first_name, family_kana, first_kana, tel, created_at) 
VALUES (10, 'ikeura@orb-japan.co.jp', 'dummy_hash', '池浦', '太郎', 'イケウラ', 'タロウ', '09012345678', datetime('now', 'localtime'));

-- 2. クライアント
INSERT OR IGNORE INTO clients (id, name) VALUES (1, 'テスト企業');

-- 3. イベント（ID=3: 東京1日観光ツアー）
INSERT OR REPLACE INTO events (
  id, name, detail, contact, location, client_id, enable_flg, 
  event_url, category, date_selection_type, 
  registration_start_date, registration_end_date, 
  event_start_date, event_end_date, image_url
) VALUES (
  3, 
  '東京1日観光ツアー 英語ガイド付き',
  '英語ガイド付きで東京の主要観光スポットを巡る1日ツアーです。少人数制で快適にご参加いただけます。

【ツアー内容】
- 浅草寺（雷門・仲見世通り）
- スカイツリー展望台（天望デッキ）
- 皇居外苑（二重橋）
- 明治神宮
- 原宿・竹下通り
- 渋谷スクランブル交差点

【スケジュール】
09:00 新宿集合
09:30-11:00 浅草観光
11:30-12:30 スカイツリー
12:30-13:30 ランチ（日本料理）
14:00-14:45 皇居外苑
15:00-15:45 明治神宮
16:00-16:30 原宿散策
16:45-17:15 渋谷散策
17:30 新宿解散',
  'tour@example.com',
  '東京都内',
  1,
  1,
  'https://example.com/tokyo-tour',
  '1',
  'calendar',
  '2026-01-01 00:00:00',
  '2026-12-31 23:59:59',
  '2026-01-01',
  '2026-12-31',
  'https://placehold.co/1920x600/047857/ffffff?text=Tokyo+1-Day+Tour'
);

-- 4. 商品（東京観光ツアー用）
INSERT OR REPLACE INTO products (id, name, description, event_id, client_id, enable_flg, image_url) 
VALUES (
  1, 
  '東京1日観光ツアー',
  '英語ガイド付きの東京1日観光ツアーです。浅草、スカイツリー、皇居、明治神宮、原宿、渋谷を巡ります。',
  3, 
  1, 
  1,
  'https://placehold.co/800x600/047857/ffffff?text=Tokyo+Tour'
);

-- 5. 価格帯
INSERT OR REPLACE INTO product_prices (id, product_id, price, category_name, common_name, slot_number) 
VALUES 
  (1, 1, 8000, 'スタンダード-大人', '大人', 1),
  (2, 1, 6000, 'スタンダード-子供', '子供', 2),
  (3, 1, 12000, 'プレミアム-大人', '大人', 1),
  (4, 1, 10000, 'プレミアム-子供', '子供', 2);

-- 6. 在庫（3月の複数日程）
INSERT OR REPLACE INTO product_stocks (id, product_id, date, stock_name, price_band, stock, booked) 
VALUES 
  (1, 1, '2026-02-20', 'スタンダードプラン', 'スタンダード', 20, 0),
  (2, 1, '2026-02-21', 'スタンダードプラン', 'スタンダード', 20, 0),
  (3, 1, '2026-02-22', 'スタンダードプラン', 'スタンダード', 20, 0),
  (4, 1, '2026-03-01', 'スタンダードプラン', 'スタンダード', 20, 0),
  (5, 1, '2026-03-02', 'スタンダードプラン', 'スタンダード', 20, 0),
  (6, 1, '2026-03-03', 'スタンダードプラン', 'スタンダード', 20, 0),
  (7, 1, '2026-03-01', 'プレミアムプラン', 'プレミアム', 10, 0),
  (8, 1, '2026-03-02', 'プレミアムプラン', 'プレミアム', 10, 0),
  (9, 1, '2026-03-03', 'プレミアムプラン', 'プレミアム', 10, 0);

-- 7. オプション（お弁当）
INSERT OR REPLACE INTO options (id, name, description, event_id, enable_flg, image_url) 
VALUES (
  1,
  '特選お弁当',
  '東京の老舗料亭が作る特選お弁当です。',
  3,
  1,
  'https://placehold.co/400x300/ef4444/ffffff?text=Special+Bento'
);

-- 8. オプション価格
INSERT OR REPLACE INTO option_prices (id, option_id, price, category_name, slot_number) 
VALUES 
  (1, 1, 2500, '1個', 1),
  (2, 1, 4800, '2個セット', 2);

-- 9. オプション在庫
INSERT OR REPLACE INTO option_stocks (id, option_id, date, stock_name, stock, booked) 
VALUES 
  (1, 1, '2026-02-20', 'お弁当在庫', 0, 0),
  (2, 1, '2026-02-21', 'お弁当在庫', 100, 0),
  (3, 1, '2026-02-22', 'お弁当在庫', 100, 0),
  (4, 1, '2026-03-01', 'お弁当在庫', 100, 0),
  (5, 1, '2026-03-02', 'お弁当在庫', 100, 0),
  (6, 1, '2026-03-03', 'お弁当在庫', 100, 0);
