-- 外部キー制約を一時的に無効化
PRAGMA foreign_keys = OFF;

-- 親イベント: 東京モーターショー2025
INSERT INTO events (
  id, name, detail, location, contact, event_url,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  client_id, customer_client_id, organizer_id,
  enable_flg, event_type, branch_code,
  created_at, modified_at
) VALUES (
  20,
  '東京モーターショー2025',
  '日本最大級のモーターショー',
  '東京ビッグサイト',
  'motorshow@example.com',
  'https://example.com/motorshow-2025',
  '2025-03-01',
  '2025-03-10',
  '2025-01-01 00:00:00',
  '2025-02-20 23:59:59',
  1, 1, 1,
  1, 'parent', '01',
  datetime('now'), datetime('now')
);

-- 子イベント1: 出展者登録
INSERT INTO events (
  id, name, detail, location, contact, event_url,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  client_id, customer_client_id, organizer_id,
  enable_flg, event_type, parent_event_id, branch_code,
  created_at, modified_at
) VALUES (
  21,
  '東京モーターショー2025 - 出展者登録',
  '出展者向け登録',
  '東京ビッグサイト',
  'exhibitor@example.com',
  'https://example.com/motorshow-2025-exhibitor',
  '2025-03-01',
  '2025-03-10',
  '2024-12-01 00:00:00',
  '2025-02-10 23:59:59',
  1, 1, 1,
  1, 'child', 20, '01',
  datetime('now'), datetime('now')
);

-- 子イベント2: 来場者チケット
INSERT INTO events (
  id, name, detail, location, contact, event_url,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  client_id, customer_client_id, organizer_id,
  enable_flg, event_type, parent_event_id, branch_code,
  created_at, modified_at
) VALUES (
  22,
  '東京モーターショー2025 - 来場者チケット',
  '一般来場者向けチケット',
  '東京ビッグサイト',
  'ticket@example.com',
  'https://example.com/motorshow-2025-ticket',
  '2025-03-01',
  '2025-03-10',
  '2025-01-15 00:00:00',
  '2025-02-28 23:59:59',
  1, 1, 1,
  1, 'child', 20, '01',
  datetime('now'), datetime('now')
);

-- テストイベント（東京南支店）
INSERT INTO events (
  id, name, detail, location, contact, event_url,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  client_id, customer_client_id, organizer_id,
  enable_flg, event_type, branch_code,
  created_at, modified_at
) VALUES (
  23,
  'テストイベント（支店追加テスト）',
  '東京南支店担当のテストイベント',
  '東京都',
  'test@example.com',
  'https://example.com/test-branch-02',
  '2025-07-01',
  '2025-07-31',
  '2025-06-01 00:00:00',
  '2025-06-30 23:59:59',
  1, 1, 1,
  1, 'standalone', '02',
  datetime('now'), datetime('now')
);

-- 商品1: 出展者ブース（標準）
INSERT INTO products (
  id, client_id, event_id, name, sales_start, sales_end,
  description, enable_flg, created_at, modified_at
) VALUES (
  201, 1, 21, '出展者ブース（標準）', '2024-12-01 00:00:00', '2025-02-10 23:59:59',
  '3m×3mの標準ブース（300,000円）', 1, datetime('now'), datetime('now')
);

-- 商品2: 出展者ブース（大型）
INSERT INTO products (
  id, client_id, event_id, name, sales_start, sales_end,
  description, enable_flg, created_at, modified_at
) VALUES (
  202, 1, 21, '出展者ブース（大型）', '2024-12-01 00:00:00', '2025-02-10 23:59:59',
  '6m×6mの大型ブース（800,000円）', 1, datetime('now'), datetime('now')
);

-- 商品3: 出展者ブース（プレミアム）
INSERT INTO products (
  id, client_id, event_id, name, sales_start, sales_end,
  description, enable_flg, created_at, modified_at
) VALUES (
  203, 1, 21, '出展者ブース（プレミアム）', '2024-12-01 00:00:00', '2025-02-10 23:59:59',
  '特等席の大型ブース（1,500,000円）', 1, datetime('now'), datetime('now')
);

-- 商品4: 一般入場券
INSERT INTO products (
  id, client_id, event_id, name, sales_start, sales_end,
  description, enable_flg, created_at, modified_at
) VALUES (
  204, 1, 22, '一般入場券', '2025-01-15 00:00:00', '2025-02-28 23:59:59',
  '1日入場券（2,000円）', 1, datetime('now'), datetime('now')
);

-- 商品5: プレミアム入場券
INSERT INTO products (
  id, client_id, event_id, name, sales_start, sales_end,
  description, enable_flg, created_at, modified_at
) VALUES (
  205, 1, 22, 'プレミアム入場券', '2025-01-15 00:00:00', '2025-02-28 23:59:59',
  '特典付き入場券（5,000円）', 1, datetime('now'), datetime('now')
);

-- 外部キー制約を再有効化
PRAGMA foreign_keys = ON;
