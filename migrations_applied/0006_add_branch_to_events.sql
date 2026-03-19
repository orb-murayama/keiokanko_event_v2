-- イベントテーブルに担当支店カラムを追加
ALTER TABLE events ADD COLUMN branch_code TEXT;

-- インデックスを作成
CREATE INDEX IF NOT EXISTS idx_events_branch_code ON events(branch_code);

-- 既存のイベントにデフォルト値を設定（任意: 東京中央支店）
UPDATE events SET branch_code = '01' WHERE branch_code IS NULL AND id > 0;
