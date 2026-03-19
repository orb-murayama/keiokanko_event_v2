-- オプション価格に大人/子供カテゴリーを追加

-- 既存の価格を削除
DELETE FROM option_prices WHERE option_id IN (1, 2, 3);

-- オプション1: 電動アシスト自転車 - 一律2000円
INSERT INTO option_prices (option_id, price, category_name) VALUES
(1, 2000, '大人'),
(1, 2000, '子供');

-- オプション2: サイクリング保険 - 大人500円、子供300円
INSERT INTO option_prices (option_id, price, category_name) VALUES
(2, 500, '大人'),
(2, 300, '子供');

-- オプション3: 特製弁当 - 大人1500円、子供1000円
INSERT INTO option_prices (option_id, price, category_name) VALUES
(3, 1500, '大人'),
(3, 1000, '子供');
