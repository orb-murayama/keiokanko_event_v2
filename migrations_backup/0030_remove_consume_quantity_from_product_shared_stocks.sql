-- 商品共有在庫テーブルから消費数カラムを削除
-- SQLiteではALTER TABLE DROP COLUMNが直接使えないため、テーブル再作成が必要

-- 1. 新しいテーブルを作成（consume_quantity, priorityなし）
CREATE TABLE IF NOT EXISTS product_shared_stocks_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  shared_stock_pool_id INTEGER NOT NULL,
  stock_name TEXT,
  price_band TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (shared_stock_pool_id) REFERENCES shared_stock_pools(id),
  UNIQUE(product_id, shared_stock_pool_id)
);

-- 2. 既存データを新しいテーブルにコピー（consume_quantity, priorityを除く、重複排除）
INSERT INTO product_shared_stocks_new (id, product_id, shared_stock_pool_id, stock_name, price_band, enable_flg, created_at, modified_at)
SELECT MIN(id) as id, product_id, shared_stock_pool_id, 
       MAX(stock_name) as stock_name, 
       MAX(price_band) as price_band, 
       MAX(enable_flg) as enable_flg, 
       MIN(created_at) as created_at, 
       MAX(modified_at) as modified_at
FROM product_shared_stocks
GROUP BY product_id, shared_stock_pool_id;

-- 3. 古いテーブルを削除
DROP TABLE product_shared_stocks;

-- 4. 新しいテーブルを元の名前にリネーム
ALTER TABLE product_shared_stocks_new RENAME TO product_shared_stocks;

-- 5. インデックスを再作成
CREATE INDEX IF NOT EXISTS idx_product_shared_stocks_product_id ON product_shared_stocks(product_id);
CREATE INDEX IF NOT EXISTS idx_product_shared_stocks_pool_id ON product_shared_stocks(shared_stock_pool_id);
CREATE INDEX IF NOT EXISTS idx_product_shared_stocks_enable_flg ON product_shared_stocks(enable_flg);
