-- イベントテーブルに販売会社IDを追加

ALTER TABLE events ADD COLUMN vendor_id INTEGER;

-- 外部キー用のインデックス作成
CREATE INDEX IF NOT EXISTS idx_events_vendor_id ON events(vendor_id);

-- 外部キー制約のコメント（SQLiteでは実際には制約は作成されない）
-- FOREIGN KEY (vendor_id) REFERENCES vendors(id)
