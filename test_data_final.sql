-- 最小限のテストデータ (正しいスキーマ)

-- 1. アカウント
INSERT OR IGNORE INTO accounts (id, login_id, password, person_name, email, role) VALUES
(1, 'admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '管理者', 'admin@example.com', 'admin');

-- 2. クライアント
INSERT OR IGNORE INTO clients (id, name, tel, email, password) VALUES
(1, 'テストクライアント', '03-1234-5678', 'client@example.com', 'password');

-- 3. 主催者
INSERT OR IGNORE INTO organizers (id, name) VALUES
(1, '京王ツアーズ');

-- 4. イベント (ID=2: 多摩サイクリング)
INSERT OR IGNORE INTO events (id, name, detail, contact, client_id, organizer_id, date_selection_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date) VALUES
(2, '多摩サイクリング', '多摩丘陵サイクリング', '問い合わせ先', 1, 1, 'button', 1,
  '2026-02-01 17:41:00', '2026-06-27 17:41:00', '2026-02-01', '2026-05-30');

-- 5. 商品 (ID=2, 3: 多摩サイクリング用)
INSERT OR IGNORE INTO products (id, client_id, event_id, name, sales_start, sales_end, closing_trade) VALUES
(2, 1, 2, '多摩丘陵サイクリングツアー', '2026-02-01', '2026-06-27', 0),
(3, 1, 2, '多摩丘陵サイクリングツアー（プレミアム）', '2026-02-01', '2026-06-27', 0);

-- 6. 商品価格
INSERT OR IGNORE INTO product_prices (product_id, price_band, price, category_name, slot_number) VALUES
(2, 'A', 10000, '大人', 1),
(2, 'A', 5000, '子供', 2),
(2, 'B', 12000, '大人', 1),
(2, 'B', 6000, '子供', 2),
(3, 'A', 10000, '大人', 1),
(3, 'A', 5000, '子供', 2),
(3, 'B', 12000, '大人', 1),
(3, 'B', 6000, '子供', 2);

-- 7. 商品在庫 (2月28日)
INSERT OR IGNORE INTO product_stocks (product_id, stock_name, date, price_band, stock, booked) VALUES
(2, '午前', '2026-02-28', 'A', 10, 0),
(2, '午後', '2026-02-28', 'B', 22, 0),
(3, '午前', '2026-02-28', 'A', 10, 0),
(3, '午後', '2026-02-28', 'B', 22, 0);

-- 8. オプションカテゴリー
INSERT OR IGNORE INTO option_categories (id, name) VALUES
(1, 'レンタル'),
(2, '保険'),
(3, '食事');

-- 9. オプション
INSERT OR IGNORE INTO options (id, event_id, name, description, option_category_id, enable_flg) VALUES
(1, 2, '電動アシスト自転車', '電動アシスト付き自転車のアップグレード', 1, 1),
(2, 2, 'サイクリング保険', '万が一の事故に備えた傷害保険', 2, 1),
(3, 2, '特製弁当（豪華版）', '地元食材を使った特製弁当にアップグレード', 3, 1);

-- 10. オプション価格
INSERT OR IGNORE INTO option_prices (option_id, price, category_name) VALUES
(1, 2000, '大人'),
(1, 2000, '子供'),
(2, 500, '大人'),
(2, 300, '子供'),
(3, 1500, '大人'),
(3, 1000, '子供');

-- 11. オプション在庫
INSERT OR IGNORE INTO option_stocks (option_id, stock_name, date, total_stock, available_stock, price, enable_flg, stock, booked) VALUES
(1, '電動アシスト自転車', '2026-02-28', 10, 10, 2000, 1, 10, 0),
(2, 'サイクリング保険', '2026-02-28', 30, 30, 500, 1, 30, 0),
(3, '特製弁当（豪華版）', '2026-02-28', 50, 50, 1500, 1, 50, 0);
