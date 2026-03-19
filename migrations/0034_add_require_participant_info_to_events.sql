-- Add require_participant_info column to events table
-- 参加者情報入力の要否をイベントごとに設定可能にする

ALTER TABLE events ADD COLUMN require_participant_info INTEGER DEFAULT 0;

-- Comment: 
-- 0 = 参加者情報入力不要（デフォルト）
-- 1 = 参加者情報入力必須
