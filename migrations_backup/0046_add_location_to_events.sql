-- イベントテーブルに場所フィールドを追加

ALTER TABLE events ADD COLUMN location TEXT DEFAULT NULL;
ALTER TABLE events ADD COLUMN location_en TEXT DEFAULT NULL;

-- インデックスを追加
CREATE INDEX IF NOT EXISTS idx_events_location ON events(location);
