-- 外部キー制約を一時的に無効化
PRAGMA foreign_keys = OFF;

-- 親子イベントと商品のサンプルデータ（簡易版）

-- ========================================
-- 1. 親イベント: 東京モーターショー2025
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  20,
  '東京モーターショー2025',
  '日本最大級の自動車展示会。最新モデルや次世代技術を一堂に展示します。',
  '東京ビッグサイト',
  'info@motorshow2025.jp',
  'https://example.com/motorshow-2025',
  'parent',
  NULL,
  '2025-10-01',
  '2025-10-10',
  '2025-05-01 00:00:00',
  '2025-09-30 23:59:59',
  1,
  1,
  1,
  1,
  'button'
);

-- ========================================
-- 2. 子イベント1: 出展者登録
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  21,
  '東京モーターショー2025 - 出展者登録',
  '東京モーターショー2025の出展者向け登録です。ブース申込みと出展料金のお支払いをお願いします。',
  '東京ビッグサイト',
  'exhibitor@motorshow2025.jp',
  'https://example.com/motorshow-2025-exhibitor',
  'child',
  20,
  '2025-10-01',
  '2025-10-10',
  '2025-05-01 00:00:00',
  '2025-08-31 23:59:59',
  1,
  1,
  1,
  1,
  'button'
);

-- 出展者向け商品
INSERT OR IGNORE INTO products (
  id, event_id, name, description, enable_flg, slot_type, client_id
) VALUES 
(101, 21, 'スタンダードブース（3m×3m）', '基本的な展示ブース。壁面パネル、照明、電源込み。', 1, 'none', 1),
(102, 21, 'プレミアムブース（6m×6m）', '広々とした展示ブース。特等エリアに配置、追加照明・電源付き。', 1, 'none', 1),
(103, 21, 'コーナーブース（4m×4m）', '角地の目立つブース。2面展示可能、追加看板設置可。', 1, 'none', 1);

-- 出展者向け商品価格
INSERT OR IGNORE INTO product_prices (product_id, price, price_name, display_order) VALUES
(101, 500000, '基本プラン', 1),
(102, 1200000, '基本プラン', 1),
(103, 800000, '基本プラン', 1);

-- ========================================
-- 3. 子イベント2: 来場者チケット
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  22,
  '東京モーターショー2025 - 来場者チケット',
  '東京モーターショー2025の来場者向けチケット販売です。一般入場券と特別観覧席をご用意しています。',
  '東京ビッグサイト',
  'visitor@motorshow2025.jp',
  'https://example.com/motorshow-2025-visitor',
  'child',
  20,
  '2025-10-01',
  '2025-10-10',
  '2025-06-01 00:00:00',
  '2025-10-10 18:00:00',
  1,
  1,
  1,
  1,
  'calendar'
);

-- 来場者向け商品
INSERT OR IGNORE INTO products (
  id, event_id, name, description, enable_flg, slot_type, client_id
) VALUES 
(201, 22, '一般入場券（1日券）', '会期中の1日有効な入場券。全展示エリア観覧可能。', 1, 'date', 1),
(202, 22, '通し券（全日程）', '会期中すべての日程で入場可能。何度でもご来場いただけます。', 1, 'none', 1),
(203, 22, 'VIP入場券（1日券）', '専用ラウンジ利用可、優先入場、記念品付き。', 1, 'date', 1);

-- 来場者向け商品価格
INSERT OR IGNORE INTO product_prices (product_id, price, price_name, display_order) VALUES
(201, 3000, '1日券', 1),
(202, 15000, '通し券', 1),
(203, 15000, 'VIP 1日券', 1);

-- ========================================
-- 4. 親イベント: 大阪テックカンファレンス2025
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  30,
  '大阪テックカンファレンス2025',
  '最新テクノロジーとビジネスイノベーションの祭典。AI、IoT、ブロックチェーンなど最先端技術を紹介。',
  'インテックス大阪',
  'info@osakatech2025.jp',
  'https://example.com/osaka-tech-2025',
  'parent',
  NULL,
  '2025-11-15',
  '2025-11-17',
  '2025-06-01 00:00:00',
  '2025-11-10 23:59:59',
  1,
  1,
  1,
  1,
  'button'
);

-- ========================================
-- 5. 子イベント1: 企業ブース出展
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  31,
  '大阪テックカンファレンス2025 - 企業ブース出展',
  '企業・スタートアップ向け出展プラン。製品・サービスのデモンストレーション、名刺交換、商談が可能です。',
  'インテックス大阪',
  'booth@osakatech2025.jp',
  'https://example.com/osaka-tech-2025-booth',
  'child',
  30,
  '2025-11-15',
  '2025-11-17',
  '2025-06-01 00:00:00',
  '2025-10-31 23:59:59',
  1,
  1,
  1,
  1,
  'button'
);

-- 企業ブース商品
INSERT OR IGNORE INTO products (
  id, event_id, name, description, enable_flg, slot_type, client_id
) VALUES 
(301, 31, 'スタートアップブース（2m×2m）', '新興企業向け小型ブース。テーブル1台、椅子2脚付き。', 1, 'none', 1),
(302, 31, 'スタンダードブース（3m×3m）', '標準的な展示ブース。デモ用電源、Wi-Fi完備。', 1, 'none', 1),
(303, 31, 'プレミアムブース（5m×5m）', '大型展示ブース。メインホール配置、追加照明付き。', 1, 'none', 1);

-- 企業ブース商品価格
INSERT OR IGNORE INTO product_prices (product_id, price, price_name, display_order) VALUES
(301, 200000, '基本プラン', 1),
(302, 400000, '基本プラン', 1),
(303, 900000, '基本プラン', 1);

-- ========================================
-- 6. 子イベント2: カンファレンス参加
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  32,
  '大阪テックカンファレンス2025 - カンファレンス参加',
  'セミナー・ワークショップへの参加チケット。業界トップリーダーの講演を聴講できます。',
  'インテックス大阪',
  'conference@osakatech2025.jp',
  'https://example.com/osaka-tech-2025-conference',
  'child',
  30,
  '2025-11-15',
  '2025-11-17',
  '2025-07-01 00:00:00',
  '2025-11-15 09:00:00',
  1,
  1,
  1,
  1,
  'calendar'
);

-- カンファレンス参加商品
INSERT OR IGNORE INTO products (
  id, event_id, name, description, enable_flg, slot_type, client_id
) VALUES 
(401, 32, '1日参加チケット', '選択した1日分のすべてのセッションに参加可能。', 1, 'date', 1),
(402, 32, '全日程パス（3日間）', '3日間すべてのセッション参加可能。特典資料付き。', 1, 'none', 1),
(403, 32, 'VIP全日程パス', '全セッション参加＋VIPラウンジ利用＋懇親会参加券付き。', 1, 'none', 1);

-- カンファレンス参加商品価格
INSERT OR IGNORE INTO product_prices (product_id, price, price_name, display_order) VALUES
(401, 25000, '1日券', 1),
(402, 60000, '3日間通し券', 1),
(403, 150000, 'VIPパス', 1);

-- ========================================
-- 7. 親イベント: 福岡グルメフェスティバル2025
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  40,
  '福岡グルメフェスティバル2025',
  '九州・福岡の食文化を堪能できる大型グルメイベント。全国の名店が集結します。',
  'マリンメッセ福岡',
  'info@fukuokagourmet2025.jp',
  'https://example.com/fukuoka-gourmet-2025',
  'parent',
  NULL,
  '2025-09-20',
  '2025-09-23',
  '2025-05-01 00:00:00',
  '2025-09-20 23:59:59',
  1,
  1,
  1,
  1,
  'button'
);

-- ========================================
-- 8. 子イベント1: 出店者登録
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  41,
  '福岡グルメフェスティバル2025 - 出店者登録',
  '飲食店・食品メーカー向けの出店プラン。ブース設営、電源、給排水設備を提供します。',
  'マリンメッセ福岡',
  'vendor@fukuokagourmet2025.jp',
  'https://example.com/fukuoka-gourmet-2025-vendor',
  'child',
  40,
  '2025-09-20',
  '2025-09-23',
  '2025-05-01 00:00:00',
  '2025-08-31 23:59:59',
  1,
  1,
  1,
  1,
  'button'
);

-- 出店者向け商品
INSERT OR IGNORE INTO products (
  id, event_id, name, description, enable_flg, slot_type, client_id
) VALUES 
(501, 41, '屋台ブース（3m×3m）', '標準的な屋台スペース。テント、テーブル、電源付き。', 1, 'none', 1),
(502, 41, 'プレミアムブース（5m×5m）', 'メインエリアの大型ブース。給排水設備、ガス設備付き。', 1, 'none', 1),
(503, 41, 'キッチンカー出店枠', 'キッチンカーでの出店。電源・排水設備利用可。', 1, 'none', 1);

-- 出店者向け商品価格
INSERT OR IGNORE INTO product_prices (product_id, price, price_name, display_order) VALUES
(501, 150000, '基本プラン', 1),
(502, 350000, '基本プラン', 1),
(503, 200000, '基本プラン', 1);

-- ========================================
-- 9. 子イベント2: 来場者チケット
-- ========================================
INSERT OR IGNORE INTO events (
  id, name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  42,
  '福岡グルメフェスティバル2025 - 来場者チケット',
  '一般来場者向け入場券。各ブースでの飲食は別途お支払いください。',
  'マリンメッセ福岡',
  'ticket@fukuokagourmet2025.jp',
  'https://example.com/fukuoka-gourmet-2025-ticket',
  'child',
  40,
  '2025-09-20',
  '2025-09-23',
  '2025-06-01 00:00:00',
  '2025-09-23 18:00:00',
  1,
  1,
  1,
  1,
  'calendar'
);

-- 来場者向け商品
INSERT OR IGNORE INTO products (
  id, event_id, name, description, enable_flg, slot_type, client_id
) VALUES 
(601, 42, '一般入場券（1日券）', '選択した1日のみ入場可能。再入場可。', 1, 'date', 1),
(602, 42, '通し券（4日間）', '全日程入場可能。お得な通し券。', 1, 'none', 1),
(603, 42, 'VIP入場券（1日券）', '専用ラウンジ、優先入場、特別試食会招待付き。', 1, 'date', 1);

-- 来場者向け商品価格
INSERT OR IGNORE INTO product_prices (product_id, price, price_name, display_order) VALUES
(601, 2000, '1日券', 1),
(602, 6000, '4日間通し券', 1),
(603, 10000, 'VIP 1日券', 1);

-- 外部キー制約を再度有効化
PRAGMA foreign_keys = ON;
