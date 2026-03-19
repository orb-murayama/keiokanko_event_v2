-- 時間枠対応のためのスキーマ変更

-- 商品テーブルに時間枠タイプフィールドを追加
ALTER TABLE products ADD COLUMN slot_type INTEGER DEFAULT 0; -- 0:日単位 1:時間枠単位

-- 商品在庫テーブルに時間枠フィールドを追加
ALTER TABLE product_stocks ADD COLUMN time_slot_start TEXT; -- HH:MM
ALTER TABLE product_stocks ADD COLUMN time_slot_end TEXT;   -- HH:MM
ALTER TABLE product_stocks ADD COLUMN time_slot_label TEXT;  -- 表示用ラベル（例：午前、午後）

-- 既存のユニークインデックスを削除
DROP INDEX IF EXISTS idx_product_stocks_product_date;

-- 新しいユニークインデックス（商品×日付×時間枠開始で一意）
CREATE UNIQUE INDEX idx_product_stocks_product_date_time 
ON product_stocks(product_id, date, time_slot_start);
