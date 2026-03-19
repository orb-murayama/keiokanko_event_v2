-- オプション管理のテストデータ作成（イベントID=3に紐付け）

-- 1. 昼食オプション - お弁当（梅）
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, 'お弁当（梅）', '和風のお弁当です。彩り豊かな季節の食材を使用しています。', 'アレルギー対応不可', 1, 1, NULL);

-- 2. 昼食オプション - お弁当（竹）
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, 'お弁当（竹）', '洋風のお弁当です。ボリューム満点のメインディッシュ付き。', 'ベジタリアン対応可', 1, 1, NULL);

-- 3. 昼食オプション - お弁当（松）
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, 'お弁当（松）', '特選和牛を使った豪華なお弁当です。', '前日までの予約が必要', 1, 1, NULL);

-- 4. 飲み物オプション - ペットボトル緑茶
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, 'ペットボトル緑茶', '500mlのペットボトル緑茶。', NULL, 2, 1, NULL);

-- 5. 飲み物オプション - ペットボトルコーヒー
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, 'ペットボトルコーヒー', '500mlのペットボトルコーヒー（無糖・微糖から選択可）。', NULL, 2, 1, NULL);

-- 6. お土産オプション - 東京スカイツリーキーホルダー
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, '東京スカイツリーキーホルダー', '東京スカイツリーの形をした可愛いキーホルダーです。', 'カラー：シルバー、ゴールド', 3, 1, NULL);

-- 7. お土産オプション - 東京名物せんべい詰め合わせ
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, '東京名物せんべい詰め合わせ', '東京銘菓のせんべい詰め合わせ。10枚入り。', '賞味期限：製造日より60日', 3, 1, NULL);

-- 8. 体験オプション - 浅草人力車体験（15分）
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, '浅草人力車体験（15分）', '浅草の街を人力車で巡る体験です。プロのガイドが観光名所を案内します。', '2名まで同乗可能', 4, 1, NULL);

-- 9. 体験オプション - 茶道体験
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, '茶道体験', '本格的な茶道体験。抹茶と和菓子付き。所要時間：約45分。', '英語通訳付き', 4, 1, NULL);

-- 10. 交通オプション - ホテル送迎サービス
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, 'ホテル送迎サービス', '都内主要ホテルからの往復送迎サービス。', '前日12時までの予約が必要', 5, 1, NULL);

-- オプション価格設定（大人・子供料金）

-- 1. お弁当（梅）
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES (last_insert_rowid(), '大人', 1200, 1);

INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES (last_insert_rowid(), '子供', 800, 2);

-- 現在の option_id を取得
-- 2. お弁当（竹）
INSERT INTO options (event_id, name, description, remarks, option_category_id, enable_flg, image_url)
VALUES (3, 'お弁当（竹）価格用', '洋風のお弁当です。ボリューム満点のメインディッシュ付き。', 'ベジタリアン対応可', 1, 1, NULL);

INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = 'お弁当（竹）' AND event_id = 3), '大人', 1500, 1);

INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = 'お弁当（竹）' AND event_id = 3), '子供', 1000, 2);

-- 3. お弁当（松）
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = 'お弁当（松）' AND event_id = 3), '大人', 2500, 1);

INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = 'お弁当（松）' AND event_id = 3), '子供', 1800, 2);

-- 4. ペットボトル緑茶（価格区分なし）
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = 'ペットボトル緑茶' AND event_id = 3), '共通', 150, 1);

-- 5. ペットボトルコーヒー（価格区分なし）
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = 'ペットボトルコーヒー' AND event_id = 3), '共通', 200, 1);

-- 6. 東京スカイツリーキーホルダー（価格区分なし）
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = '東京スカイツリーキーホルダー' AND event_id = 3), '共通', 800, 1);

-- 7. 東京名物せんべい詰め合わせ（価格区分なし）
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = '東京名物せんべい詰め合わせ' AND event_id = 3), '共通', 1000, 1);

-- 8. 浅草人力車体験（15分）
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = '浅草人力車体験（15分）' AND event_id = 3), '1台', 3000, 1);

-- 9. 茶道体験
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = '茶道体験' AND event_id = 3), '大人', 2000, 1);

INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = '茶道体験' AND event_id = 3), '子供', 1500, 2);

-- 10. ホテル送迎サービス（価格区分なし）
INSERT INTO option_prices (option_id, price_category, price, display_order)
VALUES ((SELECT id FROM options WHERE name = 'ホテル送迎サービス' AND event_id = 3), '1台', 5000, 1);

-- オプション在庫設定（各日付ごと）
-- 2026年2月15日から2026年2月24日まで（10日間）の在庫を設定

-- 各オプションの在庫を設定
-- 1. お弁当（梅）
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-15', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-16', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-17', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-18', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-19', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-20', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-21', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-22', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-23', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, '2026-02-24', 50, 0 FROM options WHERE name = 'お弁当（梅）' AND event_id = 3;

-- 2. お弁当（竹）- 簡略版（全日同一在庫）
INSERT INTO option_stocks (option_id, stock_date, available_stock, reserved_stock)
SELECT id, date('2026-02-15', '+0 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+1 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+2 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+3 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+4 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+5 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+6 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+7 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+8 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3
UNION ALL SELECT id, date('2026-02-15', '+9 days'), 40, 0 FROM options WHERE name = 'お弁当（竹）' AND event_id = 3;
