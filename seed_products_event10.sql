-- イベントID=10: 福岡アジアンフードマーケット2025の商品テストデータ
-- 開催期間: 2025-10-11～2025-10-13
-- 場所: 福岡市博多区 ベイサイドプレイス

-- 商品1: タイ料理体験コース（日本語）
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2,
  cancellation_days_3, cancellation_rate_3
) VALUES (
  10, 4, 'タイ料理体験コース',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  'タイの伝統的な料理を楽しめる体験コースです。トムヤムクン、パッタイ、グリーンカレーなど本場の味をお楽しみいただけます。',
  '当日は動きやすい服装でお越しください',
  '食材費、レシピブック、エプロンレンタル',
  '飲み物、お土産',
  '開催日の7日前まで無料キャンセル可能',
  10,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  7, 0,
  3, 50,
  1, 100
);

-- 商品2: ベトナムフォー作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'ベトナムフォー作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  'ベトナムの伝統的な米麺料理「フォー」の作り方を学べます。スープの作り方から麺の茹で方まで丁寧に指導します。',
  '小学生以上からご参加いただけます',
  '食材費、レシピ、エプロンレンタル',
  '飲み物',
  '開催日の5日前まで無料キャンセル可能',
  8,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  5, 0,
  2, 80
);

-- 商品3: 韓国料理キムチ作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, '韓国料理キムチ作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  '韓国の伝統的な発酵食品キムチの作り方を学びます。作ったキムチはお持ち帰りいただけます（約1kg）。',
  '容器をご持参いただくとお持ち帰りしやすくなります',
  '食材費、容器、レシピ',
  '飲み物、追加容器',
  '開催日の3日前まで無料キャンセル可能',
  12,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  3, 0,
  1, 100
);

-- 商品4: インドカレー調理体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'インドカレー調理体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  '本格的なインドカレーの調理方法を学びます。スパイスの使い方からナンの焼き方まで詳しく指導します。',
  'スパイスの香りが強いため、衣服への付着にご注意ください',
  '食材費、スパイスセット、レシピ、エプロン',
  '飲み物',
  '開催日の7日前まで無料キャンセル可能',
  10,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  7, 0,
  3, 50
);

-- 商品5: 中華点心作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, '中華点心作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  '小籠包、餃子、シュウマイなど中華点心の作り方を学びます。蒸し器の使い方も丁寧に指導します。',
  '作った点心は試食できます',
  '食材費、レシピブック、エプロンレンタル',
  '飲み物、お土産',
  '開催日の5日前まで無料キャンセル可能',
  15,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  5, 0,
  2, 80
);

-- 商品6: アジア屋台フード食べ歩きツアー
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'アジア屋台フード食べ歩きツアー',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  '会場内のアジア各国の屋台を巡るガイド付きツアーです。5つの屋台で料理をお楽しみいただけます。',
  '歩きやすい靴でお越しください',
  'ガイド料、5つの屋台での料理、ドリンク1杯',
  '追加飲食、お土産',
  '開催日の3日前まで無料キャンセル可能',
  20,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  3, 0,
  1, 100
);

-- 商品7: アジアンスイーツ作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'アジアンスイーツ作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  'タイのマンゴースティッキーライス、ベトナムのチェーなど、アジアの伝統的なスイーツを作ります。',
  'お子様も楽しめる内容です',
  '食材費、レシピ、エプロンレンタル',
  '飲み物',
  '開催日の3日前まで無料キャンセル可能',
  12,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  3, 0,
  1, 100
);

-- 商品8: フィリピン料理アドボ作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'フィリピン料理アドボ作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  'フィリピンの国民食アドボの作り方を学びます。醤油とお酢を使った独特の煮込み料理です。',
  '試食あり',
  '食材費、レシピ、エプロン',
  '飲み物、お土産',
  '開催日の5日前まで無料キャンセル可能',
  8,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  5, 0,
  2, 80
);

-- 商品9: シンガポール料理チキンライス体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'シンガポール料理チキンライス体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  'シンガポールの名物料理チキンライスの作り方を学びます。ジンジャーソース、チリソース、ダークソースの3種類のタレも作ります。',
  '試食あり',
  '食材費、レシピブック、エプロン',
  '飲み物',
  '開催日の7日前まで無料キャンセル可能',
  10,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  7, 0,
  3, 50
);

-- 商品10: マレーシア料理ナシゴレン作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'マレーシア料理ナシゴレン作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  'マレーシアの炒めご飯ナシゴレンの作り方を学びます。サンバルソースの作り方も丁寧に指導します。',
  '辛いものが苦手な方は事前にお申し出ください',
  '食材費、レシピ、エプロン',
  '飲み物',
  '開催日の5日前まで無料キャンセル可能',
  12,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  5, 0,
  2, 80
);

-- 商品11: アジア各国お茶体験セミナー
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'アジア各国お茶体験セミナー',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  '中国茶、台湾茶、タイのバタフライピーティーなど、アジア各国のお茶を飲み比べます。お茶の淹れ方も学べます。',
  'お茶とお菓子をご用意しています',
  'お茶5種類、お菓子、資料',
  'お土産',
  '開催日の3日前まで無料キャンセル可能',
  15,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  3, 0,
  1, 100
);

-- 商品12: インドネシア料理ナシゴレン作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'インドネシア料理ルンダン作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  'インドネシアの伝統料理ルンダン（牛肉のココナッツミルク煮込み）の作り方を学びます。',
  '調理時間が長いため、時間に余裕を持ってご参加ください',
  '食材費、レシピブック、エプロン',
  '飲み物',
  '開催日の7日前まで無料キャンセル可能',
  8,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  7, 0,
  3, 50
);

-- 商品13: モンゴル料理ホーショール作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'モンゴル料理ホーショール作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  'モンゴルの揚げ餃子ホーショールの作り方を学びます。皮の作り方から揚げ方まで丁寧に指導します。',
  '試食あり',
  '食材費、レシピ、エプロン',
  '飲み物',
  '開催日の5日前まで無料キャンセル可能',
  10,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  5, 0,
  2, 80
);

-- 商品14: 台湾小籠包作り体験
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, '台湾小籠包作り体験',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  '台湾名物小籠包の作り方を学びます。薄い皮で肉汁たっぷりの餡を包む技術を習得できます。',
  '蒸したての小籠包を試食できます',
  '食材費、レシピブック、エプロンレンタル',
  '飲み物、お土産',
  '開催日の7日前まで無料キャンセル可能',
  12,
  1,
  1,
  '人',
  'per_person',
  '1名様あたりの料金',
  7, 0,
  3, 50
);

-- 商品15: アジアンフードマーケット全体験パス
INSERT INTO products (
  event_id, client_id, name,
  sales_start, sales_end,
  closing_trade,
  description, remarks,
  fee_include, fee_exclude,
  cancel_policy,
  purchase_limit,
  enable_flg,
  slot_type,
  price_unit,
  charge_type,
  charge_description,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  10, 4, 'アジアンフードマーケット全体験パス',
  '2025-01-01 00:00:00', '2026-12-31 23:59:59',
  3,
  '3日間すべての料理体験に参加できるお得なパスポートです。最大10種類の料理体験が可能です。',
  '事前予約制。各体験の予約は別途必要です',
  '全料理体験の参加権、特製エプロンプレゼント、レシピブック',
  '飲み物、お土産',
  '開催日の10日前まで無料キャンセル可能',
  5,
  1,
  0,
  '人',
  'per_person',
  '1名様あたりの料金',
  10, 0,
  5, 50
);
