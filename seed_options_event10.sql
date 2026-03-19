-- イベントID=10: 福岡アジアンフードマーケット2025のオプションテストデータ
-- 開催期間: 2025-10-11～2025-10-13

-- オプションカテゴリ
INSERT OR IGNORE INTO option_categories (id, name, description) VALUES
(1, '飲み物', '各種ドリンクオプション'),
(2, 'お土産', 'イベント記念品・お土産'),
(3, '追加体験', '追加料理体験・レッスン'),
(4, '設備レンタル', '調理器具・設備のレンタル'),
(5, '食材追加', '追加食材・アレンジ用食材');

-- オプション1: アジアンドリンクセット
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'アジアンドリンクセット',
  'タイのタピオカミルクティー、ベトナムコーヒー、韓国のとうもろこし茶から1つ選べます',
  '冷たいドリンクと温かいドリンクがあります',
  1,
  '当日キャンセル不可',
  1
);

-- オプション2: プレミアムお茶セット
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'プレミアムお茶セット',
  '高級中国茶、台湾烏龍茶、ジャスミン茶の3種類セット',
  'ティーポット付き',
  1,
  '当日キャンセル不可',
  1
);

-- オプション3: アジアンビールセット
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'アジアンビールセット',
  'タイのシンハー、ベトナムのサイゴンビール、韓国のハイトから選べます（20歳以上限定）',
  '身分証明書の提示が必要です',
  1,
  '当日キャンセル不可',
  1
);

-- オプション4: フレッシュフルーツジュース
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'フレッシュフルーツジュース',
  'マンゴー、パッションフルーツ、ドラゴンフルーツなど季節のトロピカルフルーツジュース',
  '新鮮な果物を使用',
  1,
  '当日キャンセル不可',
  1
);

-- オプション5: オリジナルエプロン
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'オリジナルエプロン',
  'イベントロゴ入りオリジナルエプロン（お持ち帰り可能）',
  '3色から選べます（レッド・ブルー・グリーン）',
  2,
  '開催日の3日前までキャンセル無料',
  1
);

-- オプション6: アジアン調味料セット
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'アジアン調味料セット',
  'ナンプラー、オイスターソース、コチュジャン、豆板醤など5種類の調味料セット',
  '自宅で本格アジア料理が作れます',
  2,
  '開催日の3日前までキャンセル無料',
  1
);

-- オプション7: レシピブック
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'アジア料理レシピブック',
  '50種類以上のアジア料理レシピが掲載された書籍（オールカラー・写真付き）',
  '初心者でも作りやすいレシピを厳選',
  2,
  '開催日の3日前までキャンセル無料',
  1
);

-- オプション8: スパイスセット
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, '本格スパイスセット',
  'カレーパウダー、クミン、コリアンダー、ターメリックなど10種類のスパイスセット',
  '密閉容器入りで保存しやすい',
  2,
  '開催日の3日前までキャンセル無料',
  1
);

-- オプション9: 追加料理体験チケット
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, '追加料理体験チケット',
  'もう1つ別の料理体験に参加できるチケット（当日のみ有効）',
  '空席がある体験に限ります',
  3,
  '開催日の1日前までキャンセル無料',
  1
);

-- オプション10: プライベート調理レッスン
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'プライベート調理レッスン（30分）',
  'シェフによるマンツーマン調理レッスン（最大2名まで）',
  '事前予約制。空き状況により実施できない場合があります',
  3,
  '開催日の5日前までキャンセル無料',
  1
);

-- オプション11: デザート作り体験追加
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'デザート作り体験追加',
  'マンゴープリン、杏仁豆腐、タピオカデザートなどから1品作れます',
  '所要時間約30分',
  3,
  '当日キャンセル不可',
  1
);

-- オプション12: 調理器具レンタルセット
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, '調理器具レンタルセット',
  '蒸し器、中華鍋、専用包丁など本格調理器具のレンタル',
  '体験終了後に返却',
  4,
  '当日キャンセル不可',
  1
);

-- オプション13: カメラ・三脚レンタル
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'カメラ・三脚レンタル',
  '料理の撮影用カメラと三脚のレンタル（2時間）',
  '体験終了後に返却。破損の場合は弁償が必要です',
  4,
  '開催日の1日前までキャンセル無料',
  1
);

-- オプション14: プレミアム食材追加
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'プレミアム食材追加',
  '高級海老、特選牛肉、有機野菜などプレミアム食材に変更',
  '体験によって追加できる食材が異なります',
  5,
  '開催日の3日前までキャンセル無料',
  1
);

-- オプション15: ハーブ・野菜追加パック
INSERT INTO options (
  event_id, name, description, remarks,
  option_category_id,
  cancel_policy,
  enable_flg
) VALUES (
  10, 'ハーブ・野菜追加パック',
  'パクチー、レモングラス、バジル、唐辛子など新鮮なハーブと野菜',
  'お持ち帰り可能',
  5,
  '当日キャンセル不可',
  1
);

-- オプション在庫データ（イベント期間中の3日間）
-- オプション1: アジアンドリンクセット（各日50個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(1, '2025-10-11', 'アジアンドリンクセット', 500, 50, 50, 0, 1),
(1, '2025-10-12', 'アジアンドリンクセット', 500, 50, 50, 0, 1),
(1, '2025-10-13', 'アジアンドリンクセット', 500, 50, 50, 0, 1);

-- オプション2: プレミアムお茶セット（各日30個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(2, '2025-10-11', 'プレミアムお茶セット', 800, 30, 30, 0, 1),
(2, '2025-10-12', 'プレミアムお茶セット', 800, 30, 30, 0, 1),
(2, '2025-10-13', 'プレミアムお茶セット', 800, 30, 30, 0, 1);

-- オプション3: アジアンビールセット（各日40個・20歳以上限定）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(3, '2025-10-11', 'アジアンビールセット', 600, 40, 40, 0, 1),
(3, '2025-10-12', 'アジアンビールセット', 600, 40, 40, 0, 1),
(3, '2025-10-13', 'アジアンビールセット', 600, 40, 40, 0, 1);

-- オプション4: フレッシュフルーツジュース（各日60個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(4, '2025-10-11', 'フレッシュフルーツジュース', 400, 60, 60, 0, 1),
(4, '2025-10-12', 'フレッシュフルーツジュース', 400, 60, 60, 0, 1),
(4, '2025-10-13', 'フレッシュフルーツジュース', 400, 60, 60, 0, 1);

-- オプション5: オリジナルエプロン（各日100個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(5, '2025-10-11', 'オリジナルエプロン', 2000, 100, 100, 0, 1),
(5, '2025-10-12', 'オリジナルエプロン', 2000, 100, 100, 0, 1),
(5, '2025-10-13', 'オリジナルエプロン', 2000, 100, 100, 0, 1);

-- オプション6: アジアン調味料セット（各日80個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(6, '2025-10-11', 'アジアン調味料セット', 1500, 80, 80, 0, 1),
(6, '2025-10-12', 'アジアン調味料セット', 1500, 80, 80, 0, 1),
(6, '2025-10-13', 'アジアン調味料セット', 1500, 80, 80, 0, 1);

-- オプション7: レシピブック（各日50個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(7, '2025-10-11', 'アジア料理レシピブック', 2500, 50, 50, 0, 1),
(7, '2025-10-12', 'アジア料理レシピブック', 2500, 50, 50, 0, 1),
(7, '2025-10-13', 'アジア料理レシピブック', 2500, 50, 50, 0, 1);

-- オプション8: スパイスセット（各日70個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(8, '2025-10-11', '本格スパイスセット', 1800, 70, 70, 0, 1),
(8, '2025-10-12', '本格スパイスセット', 1800, 70, 70, 0, 1),
(8, '2025-10-13', '本格スパイスセット', 1800, 70, 70, 0, 1);

-- オプション9: 追加料理体験チケット（各日30個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(9, '2025-10-11', '追加料理体験チケット', 3000, 30, 30, 0, 1),
(9, '2025-10-12', '追加料理体験チケット', 3000, 30, 30, 0, 1),
(9, '2025-10-13', '追加料理体験チケット', 3000, 30, 30, 0, 1);

-- オプション10: プライベート調理レッスン（各日10枠）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(10, '2025-10-11', 'プライベート調理レッスン（30分）', 5000, 10, 10, 0, 1),
(10, '2025-10-12', 'プライベート調理レッスン（30分）', 5000, 10, 10, 0, 1),
(10, '2025-10-13', 'プライベート調理レッスン（30分）', 5000, 10, 10, 0, 1);

-- オプション11: デザート作り体験追加（各日40個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(11, '2025-10-11', 'デザート作り体験追加', 1200, 40, 40, 0, 1),
(11, '2025-10-12', 'デザート作り体験追加', 1200, 40, 40, 0, 1),
(11, '2025-10-13', 'デザート作り体験追加', 1200, 40, 40, 0, 1);

-- オプション12: 調理器具レンタルセット（各日20個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(12, '2025-10-11', '調理器具レンタルセット', 1000, 20, 20, 0, 1),
(12, '2025-10-12', '調理器具レンタルセット', 1000, 20, 20, 0, 1),
(12, '2025-10-13', '調理器具レンタルセット', 1000, 20, 20, 0, 1);

-- オプション13: カメラ・三脚レンタル（各日15個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(13, '2025-10-11', 'カメラ・三脚レンタル', 800, 15, 15, 0, 1),
(13, '2025-10-12', 'カメラ・三脚レンタル', 800, 15, 15, 0, 1),
(13, '2025-10-13', 'カメラ・三脚レンタル', 800, 15, 15, 0, 1);

-- オプション14: プレミアム食材追加（各日50個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(14, '2025-10-11', 'プレミアム食材追加', 2000, 50, 50, 0, 1),
(14, '2025-10-12', 'プレミアム食材追加', 2000, 50, 50, 0, 1),
(14, '2025-10-13', 'プレミアム食材追加', 2000, 50, 50, 0, 1);

-- オプション15: ハーブ・野菜追加パック（各日80個）
INSERT INTO option_stocks (option_id, date, stock_name, price, total_stock, available_stock, booked, enable_flg)
VALUES 
(15, '2025-10-11', 'ハーブ・野菜追加パック', 600, 80, 80, 0, 1),
(15, '2025-10-12', 'ハーブ・野菜追加パック', 600, 80, 80, 0, 1),
(15, '2025-10-13', 'ハーブ・野菜追加パック', 600, 80, 80, 0, 1);
