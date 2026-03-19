-- マイグレーション: 設問ツリー機能の追加
-- 日付: 2025-11-25
-- 説明: event_form_fieldsテーブルに親子関係のカラムを追加

-- 親フィールドID（このフィールドが依存する親フィールド）
ALTER TABLE event_form_fields ADD COLUMN parent_field_id INTEGER;

-- 親フィールドの条件値（この値が選択された場合に表示）
ALTER TABLE event_form_fields ADD COLUMN parent_condition TEXT;

-- インデント レベル（表示時の階層を示す、0=ルート）
ALTER TABLE event_form_fields ADD COLUMN indent_level INTEGER DEFAULT 0;

-- インデックス追加
CREATE INDEX IF NOT EXISTS idx_form_fields_parent ON event_form_fields(parent_field_id);
CREATE INDEX IF NOT EXISTS idx_form_fields_event_order ON event_form_fields(event_id, display_order);

-- 既存データにデフォルト値を設定
UPDATE event_form_fields SET indent_level = 0 WHERE indent_level IS NULL;
