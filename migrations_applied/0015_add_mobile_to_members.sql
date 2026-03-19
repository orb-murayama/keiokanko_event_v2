-- membersテーブルに携帯電話カラムを追加
-- 2026-01-21

-- 携帯電話カラムを追加（TEXT型、NULL許可）
ALTER TABLE members ADD COLUMN mobile TEXT DEFAULT NULL;

-- インデックスを追加（携帯電話での検索を高速化）
CREATE INDEX IF NOT EXISTS idx_members_mobile ON members(mobile);
