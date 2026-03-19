-- ========================================
-- productsテーブルからキャンセルポリシーカラムを削除
-- ========================================

-- 外部キー制約を一時的に無効化
PRAGMA foreign_keys = OFF;

-- Step 1: 既存データのクリーンアップ（商品のキャンセルポリシーをクリア）
UPDATE products 
SET 
  cancel_policy = NULL,
  cancellation_policy_details = NULL,
  cancellation_days_1 = NULL,
  cancellation_rate_1 = NULL,
  cancellation_days_2 = NULL,
  cancellation_rate_2 = NULL,
  cancellation_days_3 = NULL,
  cancellation_rate_3 = NULL,
  cancellation_days_4 = NULL,
  cancellation_rate_4 = NULL,
  cancellation_days_5 = NULL,
  cancellation_rate_5 = NULL
WHERE 1=1;

-- Step 2: 一時テーブルを作成（キャンセルポリシーカラムを除く）
CREATE TABLE products_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  sales_start TEXT NOT NULL,
  sales_end TEXT NOT NULL,
  closing_trade INTEGER NOT NULL DEFAULT 0,
  product_category_id INTEGER,
  description TEXT,
  remarks TEXT,
  fee_include TEXT,
  fee_exclude TEXT,
  purchase_limit INTEGER,
  deposit_address TEXT,
  note TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  slot_type INTEGER DEFAULT 0,
  deleted_at TEXT,
  common_names TEXT,
  price_unit TEXT DEFAULT '人',
  charge_type TEXT DEFAULT 'per_person',
  charge_description TEXT,
  image_url TEXT,
  form_field_settings TEXT,
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (product_category_id) REFERENCES product_categories(id)
);

-- Step 3: 既存データを新しいテーブルにコピー
INSERT INTO products_new (
  id, client_id, event_id, name, sales_start, sales_end, closing_trade,
  product_category_id, description, remarks, fee_include, fee_exclude,
  purchase_limit, deposit_address, note, enable_flg, created_at, modified_at,
  slot_type, deleted_at, common_names, price_unit, charge_type,
  charge_description, image_url, form_field_settings
)
SELECT 
  id, client_id, event_id, name, sales_start, sales_end, closing_trade,
  product_category_id, description, remarks, fee_include, fee_exclude,
  purchase_limit, deposit_address, note, enable_flg, created_at, modified_at,
  slot_type, deleted_at, common_names, price_unit, charge_type,
  charge_description, image_url, form_field_settings
FROM products;

-- Step 4: 古いテーブルを削除
DROP TABLE products;

-- Step 5: 新しいテーブルをリネーム
ALTER TABLE products_new RENAME TO products;

-- Step 6: インデックスを再作成
CREATE INDEX IF NOT EXISTS idx_products_event_id ON products(event_id);
CREATE INDEX IF NOT EXISTS idx_products_client_id ON products(client_id);
CREATE INDEX IF NOT EXISTS idx_products_enable_flg ON products(enable_flg);
CREATE INDEX IF NOT EXISTS idx_products_sales_start ON products(sales_start);
CREATE INDEX IF NOT EXISTS idx_products_sales_end ON products(sales_end);
CREATE UNIQUE INDEX IF NOT EXISTS idx_products_event_name ON products(event_id, name);

-- 外部キー制約を再度有効化
PRAGMA foreign_keys = ON;
