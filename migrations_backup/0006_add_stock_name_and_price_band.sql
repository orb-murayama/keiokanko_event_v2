-- 在庫テーブルに在庫名と価格帯を追加

-- 商品在庫テーブルに在庫名と価格帯を追加
ALTER TABLE product_stocks ADD COLUMN stock_name TEXT; -- 在庫名（午前、11時～12時など）
ALTER TABLE product_stocks ADD COLUMN price_band TEXT; -- 価格帯記号（A, B, C, ...）

-- インデックスを追加
CREATE INDEX IF NOT EXISTS idx_product_stocks_price_band ON product_stocks(price_band);

-- オプション在庫テーブルに在庫名と価格帯を追加
ALTER TABLE option_stocks ADD COLUMN stock_name TEXT; -- 在庫名
ALTER TABLE option_stocks ADD COLUMN price_band TEXT; -- 価格帯記号

-- インデックスを追加
CREATE INDEX IF NOT EXISTS idx_option_stocks_price_band ON option_stocks(price_band);

-- 既存のUNIQUE制約を削除して、在庫名を含む新しい制約を作成
-- SQLiteではALTER TABLEでINDEXを削除できないため、後でアプリケーション側で対応
-- 注: product_id + date + stock_name + price_band の組み合わせでユニークにする必要がある
