-- 商品テーブルに取消条件フィールドを追加

-- 取消条件1（営業日数と取消料率）
ALTER TABLE products ADD COLUMN cancellation_days_1 INTEGER DEFAULT NULL;
ALTER TABLE products ADD COLUMN cancellation_rate_1 INTEGER DEFAULT NULL;

-- 取消条件2
ALTER TABLE products ADD COLUMN cancellation_days_2 INTEGER DEFAULT NULL;
ALTER TABLE products ADD COLUMN cancellation_rate_2 INTEGER DEFAULT NULL;

-- 取消条件3
ALTER TABLE products ADD COLUMN cancellation_days_3 INTEGER DEFAULT NULL;
ALTER TABLE products ADD COLUMN cancellation_rate_3 INTEGER DEFAULT NULL;

-- 取消条件4
ALTER TABLE products ADD COLUMN cancellation_days_4 INTEGER DEFAULT NULL;
ALTER TABLE products ADD COLUMN cancellation_rate_4 INTEGER DEFAULT NULL;

-- 取消条件5
ALTER TABLE products ADD COLUMN cancellation_days_5 INTEGER DEFAULT NULL;
ALTER TABLE products ADD COLUMN cancellation_rate_5 INTEGER DEFAULT NULL;
