-- イベントテーブルに日付選択タイプフィールドを追加

ALTER TABLE events ADD COLUMN date_selection_type TEXT DEFAULT 'button';
-- 'button': ボタン選択, 'calendar': カレンダー選択

-- インデックスを追加
CREATE INDEX IF NOT EXISTS idx_events_date_selection_type ON events(date_selection_type);
