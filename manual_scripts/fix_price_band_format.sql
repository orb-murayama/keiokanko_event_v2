-- 価格帯フォーマット修正スクリプト
-- 管理画面は「A-名称1」形式を想定しているため、既存の価格データを修正

-- 商品8（東京スカイツリー 展望デッキ入場券）
DELETE FROM product_prices WHERE product_id = 8;
INSERT INTO product_prices (product_id, price, category_name, price_band, slot_number, created_at, modified_at) 
VALUES 
(8, 2100, 'A-名称1', 'A', 1, datetime('now', 'localtime'), datetime('now', 'localtime')),
(8, 1550, 'A-名称2', 'A', 2, datetime('now', 'localtime'), datetime('now', 'localtime')),
(8, 950, 'A-名称3', 'A', 3, datetime('now', 'localtime'), datetime('now', 'localtime'));

UPDATE products 
SET common_names = '[{"name":"大人","description":"大人料金","label":"名称1"},{"name":"中高生","description":"中高生料金","label":"名称2"},{"name":"小学生","description":"小学生料金","label":"名称3"}]',
    modified_at = datetime('now', 'localtime')
WHERE id = 8;

-- 商品9（東京スカイツリー 天望回廊セット券）
DELETE FROM product_prices WHERE product_id = 9;
INSERT INTO product_prices (product_id, price, category_name, price_band, slot_number, created_at, modified_at) 
VALUES 
(9, 3100, 'A-名称1', 'A', 1, datetime('now', 'localtime'), datetime('now', 'localtime')),
(9, 2350, 'A-名称2', 'A', 2, datetime('now', 'localtime'), datetime('now', 'localtime')),
(9, 1450, 'A-名称3', 'A', 3, datetime('now', 'localtime'), datetime('now', 'localtime'));

UPDATE products 
SET common_names = '[{"name":"大人","description":"大人料金","label":"名称1"},{"name":"中高生","description":"中高生料金","label":"名称2"},{"name":"小学生","description":"小学生料金","label":"名称3"}]',
    modified_at = datetime('now', 'localtime')
WHERE id = 9;

SELECT '✅ Price band format fixed for products 8 and 9' as result;
