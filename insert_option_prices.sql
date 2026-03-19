-- オプション価格設定

-- 1. お弁当（梅） - 大人・子供料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(1, '大人', 1200, 1),
(1, '子供', 800, 2);

-- 2. お弁当（竹） - 大人・子供料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(2, '大人', 1500, 1),
(2, '子供', 1000, 2);

-- 3. お弁当（松） - 大人・子供料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(3, '大人', 2500, 1),
(3, '子供', 1800, 2);

-- 4. ペットボトル緑茶 - 共通料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(4, '共通', 150, 1);

-- 5. ペットボトルコーヒー - 共通料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(5, '共通', 200, 1);

-- 6. 東京スカイツリーキーホルダー - 共通料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(6, '共通', 800, 1);

-- 7. 東京名物せんべい詰め合わせ - 共通料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(7, '共通', 1000, 1);

-- 8. 浅草人力車体験（15分） - 1台料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(8, '1台', 3000, 1);

-- 9. 茶道体験 - 大人・子供料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(9, '大人', 2000, 1),
(9, '子供', 1500, 2);

-- 10. ホテル送迎サービス - 1台料金
INSERT INTO option_prices (option_id, price_category, price, display_order) VALUES
(10, '1台', 5000, 1);
