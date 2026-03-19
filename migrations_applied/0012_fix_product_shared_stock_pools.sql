-- product_shared_stock_poolsテーブルを正しい構造に修正
-- このテーブルは商品と共有在庫プールの関連を管理します

DROP TABLE IF EXISTS product_shared_stock_pools;

CREATE TABLE product_shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  shared_stock_pool_id INTEGER NOT NULL,
  stock_name TEXT,
  price_band TEXT,
  enable_flg INTEGER DEFAULT 1,
  priority INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (shared_stock_pool_id) REFERENCES shared_stock_pools(id)
);

CREATE INDEX IF NOT EXISTS idx_product_shared_stock_pools_product_id 
  ON product_shared_stock_pools(product_id);
CREATE INDEX IF NOT EXISTS idx_product_shared_stock_pools_pool_id 
  ON product_shared_stock_pools(shared_stock_pool_id);
