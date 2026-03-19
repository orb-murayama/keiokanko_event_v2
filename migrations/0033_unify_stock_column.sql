-- マイグレーション: 全テーブルで stock カラムに統一
-- 日付: 2026-03-13
-- 目的: shared_stock_pools, option_stocks, product_stocks 全てで stock カラムを使用

-- 1. shared_stock_pools に stock カラムを追加
ALTER TABLE shared_stock_pools ADD COLUMN stock INTEGER DEFAULT 0;

-- 2. 既存の total_stock の値を stock にコピー
UPDATE shared_stock_pools SET stock = total_stock;

-- 3. option_stocks で stock が 0 の場合、total_stock の値をコピー（すでに実行済みだが念のため）
UPDATE option_stocks SET stock = total_stock WHERE stock = 0 AND total_stock > 0;
