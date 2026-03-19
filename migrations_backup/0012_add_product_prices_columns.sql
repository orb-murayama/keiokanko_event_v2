-- マイグレーション: product_pricesテーブルにband, descriptionカラムを追加
-- 日付: 2025-11-25
-- 説明: product_pricesテーブルに不足しているカラムを追加

-- product_pricesテーブルに新しいカラムを追加
ALTER TABLE product_prices ADD COLUMN band TEXT;
ALTER TABLE product_prices ADD COLUMN description TEXT;

-- 既存レコードのbandカラムにprice_bandの値をコピー
UPDATE product_prices SET band = price_band WHERE band IS NULL;
