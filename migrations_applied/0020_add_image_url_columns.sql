-- マイグレーション: 画像URL関連カラムの追加
-- 作成日: 2026-02-12
-- 説明: products, events, optionsテーブルにimage_urlカラムを追加

-- productsテーブルにimage_urlカラム追加
ALTER TABLE products ADD COLUMN image_url TEXT;

-- eventsテーブルにimage_urlカラム追加
ALTER TABLE events ADD COLUMN image_url TEXT;

-- optionsテーブルにimage_urlカラム追加
ALTER TABLE options ADD COLUMN image_url TEXT;
