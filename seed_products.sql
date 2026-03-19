-- 商品テストデータ

-- 商品カテゴリーの作成
INSERT OR REPLACE INTO product_categories (id, name, description) VALUES 
(1, 'チケット', 'イベント入場券やコンサートチケット'),
(2, 'スポーツ参加', 'マラソンや競技大会への参加権'),
(3, 'コンサート', 'コンサートやライブのチケット'),
(4, 'グルメ', '食べ歩きチケットや食事プラン'),
(5, 'ツアー', '旅行パッケージやツアープラン'),
(6, 'セミナー', 'ビジネスセミナーや講座'),
(7, '教室', 'プログラミング教室や体験教室'),
(8, 'リトリート', 'ヨガや瞑想のリトリート'),
(9, 'エンターテイメント', 'お笑いライブやショー'),
(10, 'ショッピング', 'セールやショッピングイベント');

-- 1. 東京サマーフェスティバル2024の商品
INSERT OR REPLACE INTO products (
  id, client_id, event_id, name, 
  sales_start, sales_end, closing_trade,
  product_category_id, description, remarks,
  fee_include, fee_exclude, cancel_policy,
  purchase_limit, enable_flg,
  slot_type, price_unit, charge_type, charge_description,
  common_names
) VALUES 
(1, 1, 1, '一般入場券',
 '2024-06-01 00:00:00', '2024-08-14 23:59:59', 0,
 1, '東京サマーフェスティバル2024の一般入場券です。', '当日受付でチケットと引き換え',
 '入場料', '', 'イベント3日前まで全額返金、以降返金不可',
 10, 1,
 0, '人', 'per_person', '1名様あたりの料金',
 '[{"name":"大人","description":"13歳以上"},{"name":"子供","description":"6〜12歳"},{"name":"幼児","description":"3〜5歳"}]'),

(2, 1, 1, 'VIP入場券',
 '2024-06-01 00:00:00', '2024-08-14 23:59:59', 0,
 1, '東京サマーフェスティバル2024のVIP入場券です。特設席とドリンク付き。', 'VIPラウンジ利用可',
 '入場料、ドリンク1杯', '食事', 'イベント7日前まで全額返金、以降返金不可',
 5, 1,
 0, '人', 'per_person', '1名様あたりの料金',
 '[{"name":"大人","description":"13歳以上"}]'),

-- 2. 大阪マラソン大会2024の商品
(3, 1, 2, 'フルマラソン参加',
 '2024-08-01 00:00:00', '2024-11-05 23:59:59', 0,
 2, '大阪マラソン大会2024のフルマラソン参加権です。', '参加Tシャツ、完走メダル付き',
 '参加費、記録証', '食事', '申込後の返金不可',
 1, 1,
 0, '人', 'per_person', '1名様あたりの料金',
 '[{"name":"一般","description":""},{"name":"学生","description":"学生証提示必須"}]'),

(4, 1, 2, 'ハーフマラソン参加',
 '2024-08-01 00:00:00', '2024-11-05 23:59:59', 0,
 2, '大阪マラソン大会2024のハーフマラソン参加権です。', '参加Tシャツ、完走メダル付き',
 '参加費、記録証', '食事', '申込後の返金不可',
 1, 1,
 0, '人', 'per_person', '1名様あたりの料金',
 '[{"name":"一般","description":""}]'),

-- 3. 京都クラシックコンサートの商品
(5, 1, 3, 'S席',
 '2024-09-01 00:00:00', '2024-12-19 23:59:59', 0,
 3, '京都クラシックコンサートのS席チケットです。最前列エリア。', 'パンフレット付き',
 'コンサート入場料、パンフレット', '', 'コンサート7日前まで全額返金、以降50%返金',
 4, 1,
 0, '人', 'per_person', '1名様あたりの料金',
 '[{"name":"大人","description":""}]'),

(6, 1, 3, 'A席',
 '2024-09-01 00:00:00', '2024-12-19 23:59:59', 0,
 3, '京都クラシックコンサートのA席チケットです。', '',
 'コンサート入場料', 'パンフレット', 'コンサート7日前まで全額返金、以降50%返金',
 8, 1,
 0, '人', 'per_person', '1名様あたりの料金',
 '[{"name":"大人","description":""}]'),

-- 4. 北海道グルメフェア2024の商品
(7, 2, 4, '食べ歩きチケット（5枚綴り）',
 '2024-06-01 00:00:00', '2024-07-16 23:59:59', 0,
 4, '北海道グルメフェア2024の食べ歩きチケットです。各店舗で1枚ずつ利用可能。', '有効期限：イベント期間中のみ',
 'チケット5枚', '', 'イベント前日まで全額返金、当日返金不可',
 20, 1,
 0, 'セット', 'per_set', '1セットあたりの料金',
 '[{"name":"通常","description":""}]'),

(8, 2, 4, '海鮮BBQセット',
 '2024-06-15 00:00:00', '2024-07-16 23:59:59', 0,
 4, '北海道グルメフェア2024の海鮮BBQセット。蟹、ホタテ、エビ等。', '2-3名様分',
 '食材、BBQ器具レンタル', '飲み物', 'イベント3日前まで全額返金、以降返金不可',
 10, 1,
 0, 'セット', 'per_set', '1セットあたりの料金',
 '[{"name":"通常","description":""}]'),

-- 5. 沖縄リゾートツアーの商品
(9, 2, 5, '3泊4日プラン',
 '2024-09-01 00:00:00', '2025-03-25 23:59:59', 0,
 5, '沖縄リゾートツアーの3泊4日プランです。', 'ホテル、朝食付き',
 '往復航空券、ホテル宿泊費、朝食', '昼食、夕食、アクティビティ', '出発30日前まで全額返金、以降50%返金',
 2, 1,
 0, '人', 'per_person', '1名様あたりの料金',
 '[{"name":"大人","description":"12歳以上"},{"name":"子供","description":"6〜11歳"}]'),

(10, 2, 5, '5泊6日プラン',
 '2024-09-01 00:00:00', '2025-03-25 23:59:59', 0,
 5, '沖縄リゾートツアーの5泊6日プランです。', 'ホテル、朝食付き、レンタカー付き',
 '往復航空券、ホテル宿泊費、朝食、レンタカー', '昼食、夕食、アクティビティ', '出発30日前まで全額返金、以降50%返金',
 2, 1,
 0, '人', 'per_person', '1名様あたりの料金',
 '[{"name":"大人","description":"12歳以上"},{"name":"子供","description":"6〜11歳"}]');

-- 商品価格のテストデータ（価格帯別の価格設定）
-- 商品1: 一般入場券（価格帯A, B, Cで大人・子供・幼児の価格設定）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  -- 価格帯A（早期割引）
  (1, 'A', 'A-名称1', '大人', 2500, 1, 0),
  (1, 'A', 'A-名称2', '子供', 1500, 2, 0),
  (1, 'A', 'A-名称3', '幼児', 1000, 3, 0),
  -- 価格帯B（通常価格）
  (1, 'B', 'B-名称1', '大人', 3000, 1, 1),
  (1, 'B', 'B-名称2', '子供', 2000, 2, 1),
  (1, 'B', 'B-名称3', '幼児', 1500, 3, 1),
  -- 価格帯C（当日価格）
  (1, 'C', 'C-名称1', '大人', 3500, 1, 2),
  (1, 'C', 'C-名称2', '子供', 2500, 2, 2),
  (1, 'C', 'C-名称3', '幼児', 2000, 3, 2);

-- 商品2: VIP入場券（価格帯Aのみ、大人のみ）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (2, 'A', 'A-名称1', '大人', 10000, 1, 0);

-- 商品3: フルマラソン参加（価格帯A, Bで一般・学生の価格設定）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (3, 'A', 'A-名称1', '一般', 8000, 1, 0),
  (3, 'A', 'A-名称2', '学生', 5000, 2, 0),
  (3, 'B', 'B-名称1', '一般', 10000, 1, 1),
  (3, 'B', 'B-名称2', '学生', 7000, 2, 1);

-- 商品4: ハーフマラソン参加（価格帯Aのみ）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (4, 'A', 'A-名称1', '一般', 5000, 1, 0);

-- 商品5: S席（価格帯Aのみ）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (5, 'A', 'A-名称1', '大人', 12000, 1, 0);

-- 商品6: A席（価格帯Aのみ）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (6, 'A', 'A-名称1', '大人', 8000, 1, 0);

-- 商品7: 食べ歩きチケット（価格帯Aのみ）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (7, 'A', 'A-名称1', '通常', 3000, 1, 0);

-- 商品8: 海鮮BBQセット（価格帯Aのみ）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (8, 'A', 'A-名称1', '通常', 6000, 1, 0);

-- 商品9: 3泊4日プラン（価格帯A, Bで大人・子供の価格設定）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (9, 'A', 'A-名称1', '大人', 80000, 1, 0),
  (9, 'A', 'A-名称2', '子供', 50000, 2, 0),
  (9, 'B', 'B-名称1', '大人', 100000, 1, 1),
  (9, 'B', 'B-名称2', '子供', 70000, 2, 1);

-- 商品10: 5泊6日プラン（価格帯A, Bで大人・子供の価格設定）
INSERT OR REPLACE INTO product_prices (product_id, price_band, category_name, price_name, price, slot_number, display_order) VALUES
  (10, 'A', 'A-名称1', '大人', 120000, 1, 0),
  (10, 'A', 'A-名称2', '子供', 80000, 2, 0),
  (10, 'B', 'B-名称1', '大人', 150000, 1, 1),
  (10, 'B', 'B-名称2', '子供', 100000, 2, 1);
