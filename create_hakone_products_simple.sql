-- イベント2（箱根温泉リゾート）用の商品データを作成（簡略版）

-- 商品を作成
INSERT OR IGNORE INTO products (id, name, event_id, client_id, description, remarks, fee_include, fee_exclude, sales_start, sales_end, enable_flg, image_url) VALUES 
(101, '露天風呂付き特別室プラン', 2, 1,
'源泉かけ流しの露天風呂を備えた特別室で、プライベートな温泉時間をお楽しみいただけます。箱根の自然を眺めながら、ゆったりとお過ごしください。', 
'チェックイン: 15:00〜18:00\nチェックアウト: 〜10:00\n※チェックイン時間に遅れる場合は必ずご連絡ください。', 
'・2泊3日の宿泊\n・朝夕食付き（懐石料理）\n・露天風呂付き客室\n・箱根美術館入館券\n・箱根登山鉄道フリーパス', 
'・飲み物代\n・施設での追加サービス\n・交通費（箱根までの往復）\n・個人的な費用',
'2026-01-15', '2026-04-30',
1,
'https://placehold.co/400x300/4a90e2/ffffff?text=Special+Room');

INSERT OR IGNORE INTO products (id, name, event_id, client_id, description, remarks, fee_include, fee_exclude, sales_start, sales_end, enable_flg, image_url) VALUES 
(102, 'スタンダード和室プラン', 2, 1,
'伝統的な和室でくつろぎのひとときを。窓からは箱根の美しい自然が一望できます。リーズナブルな価格で温泉旅行をお楽しみいただけます。', 
'チェックイン: 15:00〜18:00\nチェックアウト: 〜10:00\n※お部屋は禁煙となります。', 
'・2泊3日の宿泊\n・朝夕食付き（和食膳）\n・大浴場利用\n・箱根美術館入館券\n・箱根登山鉄道フリーパス', 
'・飲み物代\n・施設での追加サービス\n・交通費（箱根までの往復）\n・個人的な費用',
'2026-01-15', '2026-04-30',
1,
'https://placehold.co/400x300/2ecc71/ffffff?text=Standard+Room');

-- 商品価格を作成
INSERT OR IGNORE INTO product_prices (product_id, price_name, category_name, price, price_band) VALUES 
(101, '大人料金', '大人', 45000, 'プレミアム'),
(101, '子供料金', '小学生', 30000, 'プレミアム'),
(101, '幼児料金', '幼児（食事・寝具あり）', 15000, 'プレミアム');

INSERT OR IGNORE INTO product_prices (product_id, price_name, category_name, price, price_band) VALUES 
(102, '大人料金', '大人', 28000, 'スタンダード'),
(102, '子供料金', '小学生', 18000, 'スタンダード'),
(102, '幼児料金', '幼児（食事・寝具あり）', 9000, 'スタンダード');

-- 商品在庫を作成（2026年4月1日〜7日）
-- 露天風呂付き特別室プラン（1日5室）
INSERT OR IGNORE INTO product_stocks (product_id, date, stock, booked, enable_flg) VALUES
(101, '2026-04-01', 5, 0, 1),
(101, '2026-04-02', 5, 0, 1),
(101, '2026-04-03', 5, 0, 1),
(101, '2026-04-04', 5, 0, 1),
(101, '2026-04-05', 5, 0, 1),
(101, '2026-04-06', 5, 0, 1),
(101, '2026-04-07', 5, 0, 1);

-- スタンダード和室プラン（1日10室）
INSERT OR IGNORE INTO product_stocks (product_id, date, stock, booked, enable_flg) VALUES
(102, '2026-04-01', 10, 0, 1),
(102, '2026-04-02', 10, 0, 1),
(102, '2026-04-03', 10, 0, 1),
(102, '2026-04-04', 10, 0, 1),
(102, '2026-04-05', 10, 0, 1),
(102, '2026-04-06', 10, 0, 1),
(102, '2026-04-07', 10, 0, 1);
