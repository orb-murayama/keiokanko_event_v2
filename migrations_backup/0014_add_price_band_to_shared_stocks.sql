-- マイグレーション: 共有在庫紐付けテーブルに価格帯カラムを追加
-- 日付: 2025-12-04
-- 説明: product_shared_stocks と option_shared_stocks に price_band カラムを追加
--       これにより、同じ共有在庫プールでも商品ごとに異なる価格帯を設定可能になる

-- 商品と共有在庫の紐付けテーブルに価格帯を追加
ALTER TABLE product_shared_stocks ADD COLUMN price_band TEXT;

-- オプションと共有在庫の紐付けテーブルに価格帯を追加
ALTER TABLE option_shared_stocks ADD COLUMN price_band TEXT;

-- インデックスを追加（価格帯での検索を高速化）
CREATE INDEX IF NOT EXISTS idx_product_shared_stocks_price_band ON product_shared_stocks(price_band);
CREATE INDEX IF NOT EXISTS idx_option_shared_stocks_price_band ON option_shared_stocks(price_band);

-- 使用例のコメント:
-- 同じ共有在庫プール（バス座席50席）を複数の価格帯で使用できます
-- 
-- 例: バスツアーのケース
-- shared_stock_pools: id=1, pool_name='バス座席', date='2025-12-25', total_stock=50
-- 
-- product_shared_stocks の設定:
-- - product_id=1, pool_id=1, price_band='A', stock_name='午前コース', consume_quantity=1
-- - product_id=1, pool_id=1, price_band='B', stock_name='午後コース', consume_quantity=1
-- - product_id=1, pool_id=1, price_band='C', stock_name='1日コース', consume_quantity=2
--
-- これにより:
-- - 午前コースを予約 → バス座席1席消費、A価格適用
-- - 午後コースを予約 → バス座席1席消費、B価格適用
-- - 1日コースを予約 → バス座席2席消費、C価格適用
