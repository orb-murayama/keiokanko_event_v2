-- 親子イベントのテストデータ
-- 親イベント: 東京モーターショー2025
UPDATE events SET 
  event_type = 'parent',
  parent_event_id = NULL
WHERE id = 1;

-- 子イベント1: 出展者登録
INSERT INTO events (
  name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  '東京モーターショー2025 - 出展者登録',
  '東京モーターショー2025の出展者向け登録です。ブース申込みと出展料金のお支払いをお願いします。',
  '東京ビッグサイト',
  'contact@motorshow.jp',
  'https://example.com/motorshow-2025-exhibitor',
  'child',
  1,
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

-- 子イベント2: 来場者チケット
INSERT INTO events (
  name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  '東京モーターショー2025 - 来場者チケット',
  '東京モーターショー2025の来場者向けチケット販売です。一般入場券と特別観覧席をご用意しています。',
  '東京ビッグサイト',
  'contact@motorshow.jp',
  'https://example.com/motorshow-2025-visitor',
  'child',
  1,
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
