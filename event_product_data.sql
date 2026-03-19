-- 1. categories
INSERT OR IGNORE INTO categories (id, name, display_order, enable_flg, created_at, modified_at) VALUES
(1, '展示会', 1, 1, datetime('now','localtime'), datetime('now','localtime')),
(2, '観光ツアー', 2, 1, datetime('now','localtime'), datetime('now','localtime')),
(3, 'セミナー・講演会', 3, 1, datetime('now','localtime'), datetime('now','localtime')),
(4, '体験イベント', 4, 1, datetime('now','localtime'), datetime('now','localtime')),
(5, 'スポーツイベント', 5, 1, datetime('now','localtime'), datetime('now','localtime'));
-- 2. events (イベント)
INSERT OR IGNORE INTO events (
  id, name, detail, contact, location, client_id, enable_flg, event_url, category,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  created_at, modified_at, image_url
) VALUES
(1, '東京モーターショー2026 来場者チケット', 
 '国内最大級の自動車展示会。最新モデルや未来のコンセプトカーが一堂に集結します。', 
 '問い合わせ先: 03-3333-4444',
 '東京ビッグサイト',
 1, 1, 
 'https://example.com/motorshow-2026',
 '1',
 '2026-01-15', '2026-02-28',
 '2026-03-01', '2026-03-10',
 datetime('now','localtime'), datetime('now','localtime'),
 'https://placehold.co/1920x600/dc2626/ffffff?text=Tokyo+Motor+Show+2026'),

(2, '富士山・箱根2日間観光ツアー',
 '富士山五合目と箱根温泉を巡る人気の観光コース。英語ガイド付き。',
 '問い合わせ先: 03-5555-1234',
 '東京駅集合',
 2, 1,
 'https://example.com/fujihakone-tour',
 '2',
 '2026-02-01', '2026-04-30',
 '2026-03-01', '2026-04-30',
 datetime('now','localtime'), datetime('now','localtime'),
 'https://placehold.co/1920x600/2563eb/ffffff?text=Mt.Fuji+Hakone+Tour'),

(3, 'AIビジネス活用セミナー 2026',
 '最新のAI技術をビジネスに活用する実践的なセミナー。事例紹介とハンズオン付き。',
 '問い合わせ先: 03-6666-8888',
 '六本木ヒルズ カンファレンスセンター',
 3, 1,
 'https://example.com/ai-business-seminar',
 '3',
 '2026-02-15', '2026-03-25',
 '2026-03-30', '2026-03-30',
 datetime('now','localtime'), datetime('now','localtime'),
 'https://placehold.co/1920x600/059669/ffffff?text=AI+Business+Seminar'),

(4, '東京スカイツリー®展望台入場券',
 '地上350mから東京の街を一望。日本一高い電波塔の展望台で特別な体験を。',
 '問い合わせ先: 03-7777-9999',
 '東京スカイツリー',
 1, 1,
 'https://example.com/skytree-ticket',
 '4',
 '2026-02-01', '2026-12-31',
 '2026-03-01', '2026-12-31',
 datetime('now','localtime'), datetime('now','localtime'),
 'https://placehold.co/1920x600/7c3aed/ffffff?text=Tokyo+Skytree'),

(5, '東京マラソン2026 エントリー',
 '都心を駆け抜ける国際マラソン大会。一般ランナーから世界トップアスリートまで参加。',
 '問い合わせ先: 03-8888-1111',
 '東京都庁前スタート',
 4, 1,
 'https://example.com/tokyo-marathon',
 '5',
 '2026-01-01', '2026-02-15',
 '2026-03-15', '2026-03-15',
 datetime('now','localtime'), datetime('now','localtime'),
 'https://placehold.co/1920x600/ea580c/ffffff?text=Tokyo+Marathon+2026');
-- 3. products (商品)
INSERT OR IGNORE INTO products (
  id, name, description, event_id, client_id, enable_flg, 
  sales_start, sales_end, closing_trade,
  created_at, modified_at, image_url
) VALUES
-- Event 1: Motor Show
(1, '一般入場券（平日）', '平日（月～金）に利用可能な一般入場券。全展示エリアをご覧いただけます。', 1, 1, 1, '2026-01-15', '2026-03-10', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/dc2626/ffffff?text=Weekday+Ticket'),

(2, '一般入場券（休日）', '土日祝日に利用可能な一般入場券。全展示エリアをご覧いただけます。', 1, 1, 1, '2026-01-15', '2026-03-10', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/dc2626/ffffff?text=Weekend+Ticket'),

(3, 'プレミアムパス', 'VIPラウンジ利用、優先入場、記念品付きの特別チケット。', 1, 1, 1, '2026-01-15', '2026-03-10', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/dc2626/ffffff?text=Premium+Pass'),

-- Event 2: Fuji-Hakone Tour
(4, '標準プラン（相部屋）', '富士山五合目、箱根温泉を巡る2日間。相部屋（2～4名）での宿泊プラン。朝昼夕食付き。', 2, 2, 1, '2026-02-01', '2026-04-30', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/2563eb/ffffff?text=Standard+Plan'),

(5, '個室プラン', '富士山五合目、箱根温泉を巡る2日間。個室での宿泊プラン。朝昼夕食付き。', 2, 2, 1, '2026-02-01', '2026-04-30', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/2563eb/ffffff?text=Private+Room'),

-- Event 3: AI Seminar
(6, '一般参加（1日券）', 'セミナー全セッション参加可能。資料・ランチ付き。', 3, 3, 1, '2026-02-15', '2026-03-25', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/059669/ffffff?text=1Day+Pass'),

(7, 'VIP参加（懇親会付き）', 'セミナー全セッション＋講師との懇親会参加。資料・ランチ・ディナー付き。', 3, 3, 1, '2026-02-15', '2026-03-25', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/059669/ffffff?text=VIP+Pass'),

-- Event 4: Skytree
(8, '展望デッキ入場券', '地上350mの天望デッキへの入場券。東京の街を一望できます。', 4, 1, 1, '2026-02-01', '2026-12-31', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/7c3aed/ffffff?text=Deck+Ticket'),

(9, '天望回廊セット券', '天望デッキ（350m）＋天望回廊（450m）のセット券。最高到達点から東京を眺望。', 4, 1, 1, '2026-02-01', '2026-12-31', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/7c3aed/ffffff?text=Corridor+Set'),

-- Event 5: Marathon
(10, 'フルマラソン エントリー', '東京マラソン フルマラソン（42.195km）のエントリー。完走証・記念Tシャツ付き。', 5, 4, 1, '2026-01-01', '2026-02-15', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/ea580c/ffffff?text=Full+Marathon'),

(11, '10kmラン エントリー', '東京マラソン 10kmランのエントリー。初心者の方にもおすすめ。記念Tシャツ付き。', 5, 4, 1, '2026-01-01', '2026-02-15', 0,
 datetime('now','localtime'), datetime('now','localtime'), 'https://placehold.co/800x600/ea580c/ffffff?text=10km+Run');
-- 4. product_stocks (在庫)
INSERT OR IGNORE INTO product_stocks (
  product_id, date, time_slot_label, stock, created_at, modified_at
) VALUES
-- Motor Show (3/1-3/10)
(1, '2026-03-03', '午前の部（9:00-12:00）', 500,  datetime('now','localtime'), datetime('now','localtime')),
(1, '2026-03-03', '午後の部（13:00-17:00）', 500,  datetime('now','localtime'), datetime('now','localtime')),
(1, '2026-03-04', '午前の部（9:00-12:00）', 500,  datetime('now','localtime'), datetime('now','localtime')),
(1, '2026-03-04', '午後の部（13:00-17:00）', 500,  datetime('now','localtime'), datetime('now','localtime')),
(2, '2026-03-08', '午前の部（9:00-12:00）', 800,  datetime('now','localtime'), datetime('now','localtime')),
(2, '2026-03-08', '午後の部（13:00-17:00）', 800,  datetime('now','localtime'), datetime('now','localtime')),
(2, '2026-03-09', '午前の部（9:00-12:00）', 800,  datetime('now','localtime'), datetime('now','localtime')),
(2, '2026-03-09', '午後の部（13:00-17:00）', 800,  datetime('now','localtime'), datetime('now','localtime')),
(3, '2026-03-08', 'VIPラウンジ（終日）', 50,  datetime('now','localtime'), datetime('now','localtime')),
(3, '2026-03-09', 'VIPラウンジ（終日）', 50,  datetime('now','localtime'), datetime('now','localtime')),

-- Fuji-Hakone Tour
(4, '2026-03-15', '2日間ツアー（3/15-16発）', 30,  datetime('now','localtime'), datetime('now','localtime')),
(4, '2026-03-22', '2日間ツアー（3/22-23発）', 30,  datetime('now','localtime'), datetime('now','localtime')),
(4, '2026-04-05', '2日間ツアー（4/5-6発）', 30,  datetime('now','localtime'), datetime('now','localtime')),
(5, '2026-03-15', '2日間ツアー（3/15-16発）', 15,  datetime('now','localtime'), datetime('now','localtime')),
(5, '2026-03-22', '2日間ツアー（3/22-23発）', 15,  datetime('now','localtime'), datetime('now','localtime')),
(5, '2026-04-05', '2日間ツアー（4/5-6発）', 15,  datetime('now','localtime'), datetime('now','localtime')),

-- AI Seminar (3/30 one day)
(6, '2026-03-30', 'セミナー（10:00-17:00）', 200,  datetime('now','localtime'), datetime('now','localtime')),
(7, '2026-03-30', 'VIP席（10:00-20:00）', 30,  datetime('now','localtime'), datetime('now','localtime')),

-- Skytree (year-round)
(8, '2026-03-20', '展望デッキ', 1000,  datetime('now','localtime'), datetime('now','localtime')),
(8, '2026-03-21', '展望デッキ', 1000,  datetime('now','localtime'), datetime('now','localtime')),
(8, '2026-03-22', '展望デッキ', 1000,  datetime('now','localtime'), datetime('now','localtime')),
(9, '2026-03-20', 'デッキ＋回廊セット', 500,  datetime('now','localtime'), datetime('now','localtime')),
(9, '2026-03-21', 'デッキ＋回廊セット', 500,  datetime('now','localtime'), datetime('now','localtime')),
(9, '2026-03-22', 'デッキ＋回廊セット', 500,  datetime('now','localtime'), datetime('now','localtime')),

-- Marathon (3/15 one day)
(10, '2026-03-15', 'フルマラソン', 30000,  datetime('now','localtime'), datetime('now','localtime')),
(11, '2026-03-15', '10kmラン', 10000,  datetime('now','localtime'), datetime('now','localtime'));

-- 5. product_prices (価格カテゴリ)
INSERT OR IGNORE INTO product_prices (
  product_id, category_name, price, created_at, modified_at
) VALUES
-- Motor Show
(1, '大人', 2000,  datetime('now','localtime'), datetime('now','localtime')),
(1, '学生', 1500,  datetime('now','localtime'), datetime('now','localtime')),
(1, '子供（小中学生）', 1000,  datetime('now','localtime'), datetime('now','localtime')),
(2, '大人', 2500,  datetime('now','localtime'), datetime('now','localtime')),
(2, '学生', 2000,  datetime('now','localtime'), datetime('now','localtime')),
(2, '子供（小中学生）', 1200,  datetime('now','localtime'), datetime('now','localtime')),
(3, 'プレミアム', 5000,  datetime('now','localtime'), datetime('now','localtime')),

-- Fuji-Hakone Tour
(4, '大人', 28000,  datetime('now','localtime'), datetime('now','localtime')),
(4, '子供（小学生）', 20000,  datetime('now','localtime'), datetime('now','localtime')),
(5, '大人', 38000,  datetime('now','localtime'), datetime('now','localtime')),
(5, '子供（小学生）', 28000,  datetime('now','localtime'), datetime('now','localtime')),

-- AI Seminar
(6, '一般', 15000,  datetime('now','localtime'), datetime('now','localtime')),
(6, '学生', 8000,  datetime('now','localtime'), datetime('now','localtime')),
(7, 'VIP', 25000,  datetime('now','localtime'), datetime('now','localtime')),

-- Skytree
(8, '大人', 2100,  datetime('now','localtime'), datetime('now','localtime')),
(8, '中高生', 1550,  datetime('now','localtime'), datetime('now','localtime')),
(8, '小学生', 950,  datetime('now','localtime'), datetime('now','localtime')),
(9, '大人', 3100,  datetime('now','localtime'), datetime('now','localtime')),
(9, '中高生', 2350,  datetime('now','localtime'), datetime('now','localtime')),
(9, '小学生', 1450,  datetime('now','localtime'), datetime('now','localtime')),

-- Marathon
(10, 'フルマラソン', 16200,  datetime('now','localtime'), datetime('now','localtime')),
(11, '10kmラン', 5600,  datetime('now','localtime'), datetime('now','localtime'));
