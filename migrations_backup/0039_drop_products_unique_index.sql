-- 商品名のUNIQUE制約を削除
-- 同じイベント内で同じ商品名を許可するため
DROP INDEX IF EXISTS idx_products_event_name;

-- 検索用の通常インデックスを作成（UNIQUEではない）
CREATE INDEX IF NOT EXISTS idx_products_event_id_name ON products(event_id, name);
