-- 価格帯機能の追加

-- product_pricesテーブルに価格帯フィールドを追加
ALTER TABLE product_prices ADD COLUMN price_band TEXT; -- A-Z
ALTER TABLE product_prices ADD COLUMN price_name TEXT; -- 表示名（大人、子供など）
ALTER TABLE product_prices ADD COLUMN display_order INTEGER DEFAULT 0; -- 表示順

-- 既存のproduct_pricesレコードにデフォルト値を設定
UPDATE product_prices SET price_band = 'A', display_order = 0 WHERE price_band IS NULL;
