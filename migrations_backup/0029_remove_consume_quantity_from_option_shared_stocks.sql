-- オプション共有在庫テーブルから消費数カラムを削除
-- SQLiteではALTER TABLE DROP COLUMNが直接使えないため、テーブル再作成が必要

-- 1. 新しいテーブルを作成（consume_quantityなし）
CREATE TABLE IF NOT EXISTS option_shared_stocks_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  shared_stock_pool_id INTEGER NOT NULL,
  price INTEGER DEFAULT 0,
  stock_name TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (shared_stock_pool_id) REFERENCES shared_stock_pools(id),
  UNIQUE(option_id, shared_stock_pool_id)
);

-- 2. 既存データを新しいテーブルにコピー（consume_quantityを除く）
INSERT INTO option_shared_stocks_new (id, option_id, shared_stock_pool_id, price, stock_name, enable_flg, created_at, modified_at)
SELECT id, option_id, shared_stock_pool_id, price, stock_name, enable_flg, created_at, modified_at
FROM option_shared_stocks;

-- 3. 古いテーブルを削除
DROP TABLE option_shared_stocks;

-- 4. 新しいテーブルを元の名前にリネーム
ALTER TABLE option_shared_stocks_new RENAME TO option_shared_stocks;

-- 5. インデックスを再作成
CREATE INDEX IF NOT EXISTS idx_option_shared_stocks_option_id ON option_shared_stocks(option_id);
CREATE INDEX IF NOT EXISTS idx_option_shared_stocks_pool_id ON option_shared_stocks(shared_stock_pool_id);
CREATE INDEX IF NOT EXISTS idx_option_shared_stocks_enable_flg ON option_shared_stocks(enable_flg);
