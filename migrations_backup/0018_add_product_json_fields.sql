-- Add JSON fields for product common names and cancellation policy
-- Migration: 0018_add_product_json_fields.sql

-- 共通名称設定をJSON形式で保存
ALTER TABLE products ADD COLUMN common_names TEXT;

-- 取消条件設定をJSON形式で保存
ALTER TABLE products ADD COLUMN cancellation_policy_details TEXT;

-- 既存データのデフォルト値設定（空のJSON配列）
UPDATE products SET common_names = '[]' WHERE common_names IS NULL;
UPDATE products SET cancellation_policy_details = '[]' WHERE cancellation_policy_details IS NULL;
