-- ============================================
-- 商品テストデータ（イベントID: 3 東京1日観光ツアー）
-- 生成日時: 2026-02-12
-- ============================================

-- 商品1: スタンダードプラン（日帰り）
INSERT INTO products (
  client_id, event_id, name,
  sales_start, sales_end, closing_trade,
  product_category_id, description, remarks,
  fee_include, fee_exclude,
  cancel_policy, purchase_limit,
  enable_flg, slot_type,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2,
  cancellation_days_3, cancellation_rate_3,
  price_unit, charge_type, charge_description,
  form_field_settings
) VALUES (
  3, 3, '東京1日観光ツアー スタンダードプラン',
  '2026-01-01', '2026-12-20', 0,
  NULL,
  '英語ガイド付きで東京の主要観光スポットを巡る1日ツアーです。
少人数制で快適にご参加いただけます。

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
  '雨天決行。悪天候の場合は一部スケジュールを変更する場合があります。
歩きやすい靴でご参加ください。',
  '・英語ガイド料
・貸切バス代
・スカイツリー展望台入場料（天望デッキ350m）
・ランチ（日本料理コース）
・旅行保険',
  '・天望回廊（450m）追加入場料
・個人的なお買い物代
・飲み物（ランチ時の飲み物は含む）',
  'キャンセル料は7日前まで無料、6-3日前30%、2-1日前50%、当日100%',
  20,
  1, 0,
  7, 0,
  3, 30,
  2, 50,
  '人', 'per_person', '1名様あたりの料金',
  '{"name_kanji":true,"name_kana":true,"name_roma":true,"address":false,"tel":true,"birth_date":false,"age":false}'
);

-- 商品1の価格（大人・子供）
INSERT INTO product_prices (product_id, price, category_name, price_name, display_order) VALUES
(1, 12000, '大人', '大人（13歳以上）', 1),
(1, 8000, '子供', '子供（6-12歳）', 2),
(1, 0, '幼児', '幼児（5歳以下・座席なし）', 3);

-- 商品1の在庫（日付選択型・各日20名まで）
-- 1月の土日
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(1, '2026-01-03', 20, 0),
(1, '2026-01-04', 20, 0),
(1, '2026-01-10', 20, 0),
(1, '2026-01-11', 20, 0),
(1, '2026-01-17', 20, 0),
(1, '2026-01-18', 20, 0),
(1, '2026-01-24', 20, 0),
(1, '2026-01-25', 20, 0),
(1, '2026-01-31', 20, 0);

-- 2月の土日
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(1, '2026-02-01', 20, 0),
(1, '2026-02-07', 20, 0),
(1, '2026-02-08', 20, 0),
(1, '2026-02-14', 20, 0),
(1, '2026-02-15', 20, 0),
(1, '2026-02-21', 20, 0),
(1, '2026-02-22', 20, 0),
(1, '2026-02-28', 20, 0);

-- 3月の土日
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(1, '2026-03-01', 20, 0),
(1, '2026-03-07', 20, 0),
(1, '2026-03-08', 20, 0),
(1, '2026-03-14', 20, 0),
(1, '2026-03-15', 20, 0),
(1, '2026-03-21', 20, 0),
(1, '2026-03-22', 20, 0),
(1, '2026-03-28', 20, 0),
(1, '2026-03-29', 20, 0);

-- 4月の土日
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(1, '2026-04-04', 20, 0),
(1, '2026-04-05', 20, 0),
(1, '2026-04-11', 20, 0),
(1, '2026-04-12', 20, 0),
(1, '2026-04-18', 20, 0),
(1, '2026-04-19', 20, 0),
(1, '2026-04-25', 20, 0),
(1, '2026-04-26', 20, 0);

-- 商品2: プレミアムプラン（スカイツリー天望回廊付き）
INSERT INTO products (
  client_id, event_id, name,
  sales_start, sales_end, closing_trade,
  product_category_id, description, remarks,
  fee_include, fee_exclude,
  cancel_policy, purchase_limit,
  enable_flg, slot_type,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2,
  cancellation_days_3, cancellation_rate_3,
  price_unit, charge_type, charge_description,
  form_field_settings
) VALUES (
  3, 3, '東京1日観光ツアー プレミアムプラン',
  '2026-01-01', '2026-12-20', 0,
  NULL,
  'スタンダードプランにスカイツリー天望回廊（450m）入場を追加したプレミアムプランです。
より高い場所から東京の絶景をお楽しみいただけます。

【ツアー内容】
スタンダードプランの内容に加えて：
- スカイツリー天望回廊（450m）入場
- プレミアムランチ（特選日本料理コース）
- オリジナルお土産付き

【スケジュール】
09:00 新宿集合
09:30-11:00 浅草観光
11:30-13:00 スカイツリー（天望デッキ＋天望回廊）
13:00-14:00 プレミアムランチ
14:30-15:15 皇居外苑
15:30-16:15 明治神宮
16:30-17:00 原宿散策
17:15-17:45 渋谷散策
18:00 新宿解散',
  '雨天決行。
少人数制（最大12名）で特別な体験をお約束します。',
  '・英語ガイド料
・貸切バス代
・スカイツリー展望台入場料（天望デッキ＋天望回廊）
・プレミアムランチ（特選日本料理コース・ドリンク付き）
・オリジナルお土産
・旅行保険',
  '・個人的なお買い物代',
  'キャンセル料は7日前まで無料、6-3日前30%、2-1日前50%、当日100%',
  12,
  1, 0,
  7, 0,
  3, 30,
  2, 50,
  '人', 'per_person', '1名様あたりの料金',
  '{"name_kanji":true,"name_kana":true,"name_roma":true,"address":false,"tel":true,"birth_date":false,"age":false}'
);

-- 商品2の価格（大人・子供）
INSERT INTO product_prices (product_id, price, category_name, price_name, display_order) VALUES
(2, 18000, '大人', '大人（13歳以上）', 1),
(2, 12000, '子供', '子供（6-12歳）', 2),
(2, 0, '幼児', '幼児（5歳以下・座席なし）', 3);

-- 商品2の在庫（日付選択型・各日12名まで）
-- 1月の土日
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(2, '2026-01-03', 12, 0),
(2, '2026-01-04', 12, 0),
(2, '2026-01-10', 12, 0),
(2, '2026-01-11', 12, 0),
(2, '2026-01-17', 12, 0),
(2, '2026-01-18', 12, 0),
(2, '2026-01-24', 12, 0),
(2, '2026-01-25', 12, 0),
(2, '2026-01-31', 12, 0);

-- 2月の土日
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(2, '2026-02-01', 12, 0),
(2, '2026-02-07', 12, 0),
(2, '2026-02-08', 12, 0),
(2, '2026-02-14', 12, 0),
(2, '2026-02-15', 12, 0),
(2, '2026-02-21', 12, 0),
(2, '2026-02-22', 12, 0),
(2, '2026-02-28', 12, 0);

-- 3月の土日
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(2, '2026-03-01', 12, 0),
(2, '2026-03-07', 12, 0),
(2, '2026-03-08', 12, 0),
(2, '2026-03-14', 12, 0),
(2, '2026-03-15', 12, 0),
(2, '2026-03-21', 12, 0),
(2, '2026-03-22', 12, 0),
(2, '2026-03-28', 12, 0),
(2, '2026-03-29', 12, 0);

-- 4月の土日
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(2, '2026-04-04', 12, 0),
(2, '2026-04-05', 12, 0),
(2, '2026-04-11', 12, 0),
(2, '2026-04-12', 12, 0),
(2, '2026-04-18', 12, 0),
(2, '2026-04-19', 12, 0),
(2, '2026-04-25', 12, 0),
(2, '2026-04-26', 12, 0);

-- 商品3: プライベートツアー（貸切）
INSERT INTO products (
  client_id, event_id, name,
  sales_start, sales_end, closing_trade,
  product_category_id, description, remarks,
  fee_include, fee_exclude,
  cancel_policy, purchase_limit,
  enable_flg, slot_type,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2,
  cancellation_days_3, cancellation_rate_3,
  price_unit, charge_type, charge_description,
  form_field_settings
) VALUES (
  3, 3, '東京プライベート観光ツアー（貸切）',
  '2026-01-01', '2026-12-20', 3,
  NULL,
  'お客様のグループだけの完全プライベートツアーです。
ご希望に合わせて訪問先やスケジュールをカスタマイズできます。

【基本プラン内容】
- 専属英語ガイド
- 貸切車両（1-6名様まで）
- 8時間のツアー
- スカイツリー天望回廊入場付き
- プレミアムランチ

【カスタマイズ可能】
- 訪問先の変更・追加
- 出発時刻の調整
- ランチ場所の選択
- ショッピング時間の延長
など、ご要望をお聞かせください。

【おすすめの訪問先】
- 浅草寺・仲見世
- スカイツリー
- 皇居
- 明治神宮
- 築地場外市場
- お台場
- 秋葉原
- 六本木ヒルズ
など、お好きな場所を選択できます。',
  '3日前までの事前予約制。
ご希望の訪問先がある場合は予約時にお知らせください。',
  '・専属英語ガイド（8時間）
・貸切車両（1-6名様）
・スカイツリー天望回廊入場料
・プレミアムランチ（お一人様）
・旅行保険
・駐車料金',
  '・入場料（ランチ・スカイツリー以外）
・個人的なお買い物代
・追加の飲食代',
  'キャンセル料は14日前まで無料、13-7日前20%、6-3日前30%、2-1日前50%、当日100%',
  6,
  1, 0,
  14, 0,
  7, 20,
  3, 30,
  'グループ', 'per_group', '1グループ（1-6名様）あたりの料金',
  '{"name_kanji":true,"name_kana":true,"name_roma":true,"address":true,"tel":true,"birth_date":false,"age":false}'
);

-- 商品3の価格（グループ単位）
INSERT INTO product_prices (product_id, price, category_name, price_name, display_order) VALUES
(3, 80000, '1-2名', '1-2名様', 1),
(3, 100000, '3-4名', '3-4名様', 2),
(3, 120000, '5-6名', '5-6名様', 3);

-- 商品3の在庫（日付選択型・各日3組まで）
-- 1月
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(3, '2026-01-05', 3, 0),
(3, '2026-01-12', 3, 0),
(3, '2026-01-19', 3, 0),
(3, '2026-01-26', 3, 0);

-- 2月
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(3, '2026-02-02', 3, 0),
(3, '2026-02-09', 3, 0),
(3, '2026-02-16', 3, 0),
(3, '2026-02-23', 3, 0);

-- 3月
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(3, '2026-03-02', 3, 0),
(3, '2026-03-09', 3, 0),
(3, '2026-03-16', 3, 0),
(3, '2026-03-23', 3, 0),
(3, '2026-03-30', 3, 0);

-- 4月
INSERT INTO product_stocks (product_id, date, stock, booked) VALUES
(3, '2026-04-06', 3, 0),
(3, '2026-04-13', 3, 0),
(3, '2026-04-20', 3, 0),
(3, '2026-04-27', 3, 0);

-- 商品フォームフィールド（共通アンケート）
INSERT INTO product_form_fields (
  product_id, field_type, field_name, field_label,
  is_required, description, display_order, category
) VALUES
-- 商品1のフォーム
(1, 'radio', 'dietary_restrictions', 'Dietary Restrictions / 食事制限', 0, 'Please let us know if you have any dietary restrictions', 1, 1),
(1, 'textarea', 'special_requests', 'Special Requests / 特別なご要望', 0, 'Any special requests or requirements', 2, 1),
(1, 'text', 'hotel_name', 'Hotel Name (if pickup needed) / ホテル名（送迎希望の場合）', 0, 'If you need hotel pickup, please provide your hotel name', 3, 1),

-- 商品2のフォーム
(2, 'radio', 'dietary_restrictions', 'Dietary Restrictions / 食事制限', 0, 'Please let us know if you have any dietary restrictions', 1, 1),
(2, 'textarea', 'special_requests', 'Special Requests / 特別なご要望', 0, 'Any special requests or requirements', 2, 1),
(2, 'text', 'hotel_name', 'Hotel Name (if pickup needed) / ホテル名（送迎希望の場合）', 0, 'If you need hotel pickup, please provide your hotel name', 3, 1),

-- 商品3のフォーム
(3, 'textarea', 'preferred_destinations', 'Preferred Destinations / 希望訪問先', 1, 'Please list the places you would like to visit', 1, 1),
(3, 'text', 'preferred_start_time', 'Preferred Start Time / 希望開始時刻', 0, 'What time would you like to start? (e.g., 09:00)', 2, 1),
(3, 'radio', 'dietary_restrictions', 'Dietary Restrictions / 食事制限', 0, 'Please let us know if you have any dietary restrictions', 3, 1),
(3, 'textarea', 'special_requests', 'Special Requests / 特別なご要望', 0, 'Any other special requests or requirements', 4, 1),
(3, 'text', 'hotel_name', 'Hotel Name (for pickup) / ホテル名（送迎用）', 1, 'We will pick you up from your hotel', 5, 1);

-- フォームフィールドのオプション設定
UPDATE product_form_fields SET field_options = '["No restrictions / なし","Vegetarian / ベジタリアン","Vegan / ヴィーガン","Halal / ハラル","Gluten-free / グルテンフリー","Other / その他"]' WHERE field_name = 'dietary_restrictions';
