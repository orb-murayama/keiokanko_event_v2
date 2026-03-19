-- シードデータ（テスト用）

PRAGMA foreign_keys = OFF;

-- カテゴリ
INSERT OR IGNORE INTO categories (id, name) VALUES (1, '展示会');

-- クライアント
INSERT OR IGNORE INTO clients (id, name) VALUES (1, 'テスト企業A');

-- イベント
INSERT OR REPLACE INTO events (id, name, detail, contact, location, client_id, enable_flg, event_url, category, date_selection_type, registration_start_date, registration_end_date, event_start_date, event_end_date, image_url) 
VALUES (22, '東京モーターショー2025 - 来場者チケット', '一般来場者向けチケット', 'ticket@example.com', '東京ビッグサイト', 1, 1, 'https://example.com/motorshow-2025-ticket', '1', 'button', '2025-01-15 00:00:00', '2025-02-28 23:59:59', '2025-03-01', '2025-03-10', 'https://placehold.co/1920x600/dc2626/ffffff?text=Tokyo+Motor+Show+2025');

-- 商品
INSERT OR REPLACE INTO products (id, name, description, event_id, client_id, enable_flg) VALUES (204, '一般入場券', '1日入場券', 22, 1, 1);
INSERT OR REPLACE INTO products (id, name, description, event_id, client_id, enable_flg) VALUES (205, 'プレミアム入場券', '特典付き入場券', 22, 1, 1);

-- 商品価格
INSERT OR REPLACE INTO product_prices (id, product_id, price, category_name, slot_number) VALUES (1, 204, 1000, 'A-名称1', 1);
INSERT OR REPLACE INTO product_prices (id, product_id, price, category_name, slot_number) VALUES (2, 204, 500, 'A-名称2', 1);
INSERT OR REPLACE INTO product_prices (id, product_id, price, category_name, slot_number) VALUES (3, 205, 1500, 'P-名称1', 1);
INSERT OR REPLACE INTO product_prices (id, product_id, price, category_name, slot_number) VALUES (4, 205, 800, 'P-名称2', 1);

-- 在庫
INSERT OR REPLACE INTO product_stocks (id, product_id, date, stock_name, price_band, stock, booked) VALUES (1, 204, '2026-01-14', '午前の部', 'A', 100, 0);
INSERT OR REPLACE INTO product_stocks (id, product_id, date, stock_name, price_band, stock, booked) VALUES (2, 204, '2026-01-14', '午後の部', 'A', 100, 0);
INSERT OR REPLACE INTO product_stocks (id, product_id, date, stock_name, price_band, stock, booked) VALUES (7, 205, '2026-01-14', 'VIPラウンジ', 'P', 50, 0);

PRAGMA foreign_keys = ON;
