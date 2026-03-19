-- マイグレーション: 料金単位・説明フィールドの追加
-- 日付: 2025-11-25
-- 説明: productsテーブルに料金単位、料金タイプ、料金説明のカラムを追加

-- productsテーブルに新しいカラムを追加
ALTER TABLE products ADD COLUMN price_unit TEXT DEFAULT '人';
ALTER TABLE products ADD COLUMN charge_type TEXT DEFAULT 'per_person';
ALTER TABLE products ADD COLUMN charge_description TEXT;

-- 既存のレコードにデフォルト値を設定
UPDATE products SET price_unit = '人' WHERE price_unit IS NULL;
UPDATE products SET charge_type = 'per_person' WHERE charge_type IS NULL;
