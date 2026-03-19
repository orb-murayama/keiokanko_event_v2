-- テストデータ投入

-- 1. アカウント (正しいスキーマ)
INSERT OR IGNORE INTO accounts (id, login_id, password, person_name, email, role, created_at) VALUES
(1, 'admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '管理者', 'admin@example.com', 'admin', datetime('now'));

-- 2. 主催者
INSERT OR IGNORE INTO organizers (id, name, created_at) VALUES
(1, '京王ツアーズ', datetime('now'));

-- 3. イベント (ID=2: 多摩サイクリング)
INSERT OR IGNORE INTO events (id, name, organizer_id, description, start_date, end_date, reception_start_at, reception_end_at, date_selection_type, enable_flg, created_at) VALUES
(2, '多摩サイクリング', 1, '多摩丘陵サイクリング', '2026-02-01', '2026-05-30', '2026-02-01 17:41:00', '2026-06-27 17:41:00', 'button', 1, datetime('now'));

-- 4. 商品 (ID=2, 3: 多摩サイクリング用)
INSERT OR IGNORE INTO products (id, event_id, name, created_at) VALUES
(2, 2, '多摩丘陵サイクリングツアー', datetime('now')),
(3, 2, '多摩丘陵サイクリングツアー（プレミアム）', datetime('now'));

-- 5. 商品価格
INSERT OR IGNORE INTO product_prices (product_id, price_band, price, category_name, slot, created_at) VALUES
(2, 'A', 10000, '大人', 1, datetime('now')),
(2, 'A', 5000, '子供', 2, datetime('now')),
(2, 'B', 12000, '大人', 1, datetime('now')),
(2, 'B', 6000, '子供', 2, datetime('now')),
(3, 'A', 10000, '大人', 1, datetime('now')),
(3, 'A', 5000, '子供', 2, datetime('now')),
(3, 'B', 12000, '大人', 1, datetime('now')),
(3, 'B', 6000, '子供', 2, datetime('now'));

-- 6. 商品在庫 (2月分のみ)
INSERT OR IGNORE INTO product_stocks (product_id, stock_name, date, price_band, total_stock, available_stock, created_at) VALUES
(2, '午前', '2026-02-28', 'A', 10, 10, datetime('now')),
(2, '午後', '2026-02-28', 'B', 22, 22, datetime('now')),
(3, '午前', '2026-02-28', 'A', 10, 10, datetime('now')),
(3, '午後', '2026-02-28', 'B', 22, 22, datetime('now'));

-- 7. オプションカテゴリー
INSERT OR IGNORE INTO option_categories (id, name, created_at) VALUES
(1, 'レンタル', datetime('now')),
(2, '保険', datetime('now')),
(3, '食事', datetime('now'));

-- 8. オプション
INSERT OR IGNORE INTO options (id, event_id, name, description, option_category_id, enable_flg, created_at) VALUES
(1, 2, '電動アシスト自転車', '電動アシスト付き自転車のアップグレード', 1, 1, datetime('now')),
(2, 2, 'サイクリング保険', '万が一の事故に備えた傷害保険', 2, 1, datetime('now')),
(3, 2, '特製弁当（豪華版）', '地元食材を使った特製弁当にアップグレード', 3, 1, datetime('now'));

-- 9. オプション価格
INSERT OR IGNORE INTO option_prices (option_id, price, category_name, created_at) VALUES
(1, 2000, '大人', datetime('now')),
(1, 2000, '子供', datetime('now')),
(2, 500, '大人', datetime('now')),
(2, 300, '子供', datetime('now')),
(3, 1500, '大人', datetime('now')),
(3, 1000, '子供', datetime('now'));

-- 10. オプション在庫
INSERT OR IGNORE INTO option_stocks (option_id, stock_name, date, total_stock, available_stock, price, enable_flg, created_at) VALUES
(1, '電動アシスト自転車', '2026-02-28', 10, 10, 2000, 1, datetime('now')),
(2, 'サイクリング保険', '2026-02-28', 30, 30, 500, 1, datetime('now')),
(3, '特製弁当（豪華版）', '2026-02-28', 50, 50, 1500, 1, datetime('now'));
