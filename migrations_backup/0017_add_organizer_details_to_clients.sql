-- マイグレーション: 主催者詳細情報をclientsテーブルに追加

-- 営業時間
ALTER TABLE clients ADD COLUMN business_hours TEXT;

-- 定休日
ALTER TABLE clients ADD COLUMN closed_days TEXT;

-- 備考（窓口受付に関する注意事項など）
ALTER TABLE clients ADD COLUMN business_notes TEXT;

-- 観光庁登録番号
ALTER TABLE clients ADD COLUMN registration_number TEXT;

-- 協会名（JATAなど）
ALTER TABLE clients ADD COLUMN association_name TEXT;

-- 協会会員情報
ALTER TABLE clients ADD COLUMN association_membership TEXT;

-- 旅行業務取扱管理者名
ALTER TABLE clients ADD COLUMN travel_manager_name TEXT;

-- 旅行業務取扱管理者役職
ALTER TABLE clients ADD COLUMN travel_manager_title TEXT;
