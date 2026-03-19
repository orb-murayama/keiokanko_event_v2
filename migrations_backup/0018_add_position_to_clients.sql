-- マイグレーション: clientsテーブルに役職カラムを追加

ALTER TABLE clients ADD COLUMN position TEXT;
