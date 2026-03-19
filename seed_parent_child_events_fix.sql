-- 親子イベントのテストデータ（修正版）

-- 親イベント: 東京モーターショー2025 を新規作成
INSERT INTO events (
  name, detail, location, contact,
  event_url, event_type, parent_event_id,
  event_start_date, event_end_date,
  registration_start_date, registration_end_date,
  organizer_id, client_id, customer_client_id,
  enable_flg, date_selection_type
) VALUES (
  '東京モーターショー2025',
  '日本最大級のモーターショー。最新のクルマと未来のモビリティが集結します。',
  '東京ビッグサイト',
  'contact@motorshow.jp',
  'https://example.com/motorshow-2025',
  'parent',
  NULL,
  '2025-10-01',
  '2025-10-10',
  '2025-05-01 00:00:00',
  '2025-10-10 18:00:00',
  1,
  1,
  1,
  1,
  'button'
);

-- 親イベントのIDを取得（最後に挿入されたID）
-- SQLiteでは last_insert_rowid() を使う

-- 既存の子イベントのparent_event_idを更新
-- 新しく作成した親イベントのIDに紐付ける（IDは13になるはず）
UPDATE events 
SET parent_event_id = (SELECT MAX(id) FROM events WHERE event_type = 'parent' AND name = '東京モーターショー2025')
WHERE id IN (11, 12);

-- イベントID 1（東京マラソン2025）は standalone に戻す
UPDATE events 
SET event_type = 'standalone', parent_event_id = NULL
WHERE id = 1;
