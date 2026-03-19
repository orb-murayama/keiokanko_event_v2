-- マイグレーション: 共有在庫プール機能の追加
-- 日付: 2025-12-04
-- 説明: 複数の商品・オプション間で在庫を共有できる共有在庫プール機能を追加

-- 共有在庫プールテーブル
-- 複数の商品やオプションで共通の在庫を管理するためのプール
CREATE TABLE IF NOT EXISTS shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pool_name TEXT NOT NULL,                    -- プール名（例: "バス座席", "駐車場"）
  pool_code TEXT,                             -- プールコード（一意識別子）
  description TEXT,                           -- 説明
  date TEXT NOT NULL,                         -- 対象日（YYYY-MM-DD）
  time_slot_start TEXT,                       -- 時間帯開始（HH:MM）
  time_slot_end TEXT,                         -- 時間帯終了（HH:MM）
  time_slot_label TEXT,                       -- 時間帯ラベル（例: "午前の部"）
  total_stock INTEGER NOT NULL DEFAULT 0,     -- 総在庫数
  booked INTEGER NOT NULL DEFAULT 0,          -- 予約済数
  available_stock INTEGER GENERATED ALWAYS AS (total_stock - booked) VIRTUAL, -- 利用可能在庫（仮想カラム）
  enable_flg INTEGER DEFAULT 1,               -- 0:無効 1:有効
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_shared_stock_pools_date ON shared_stock_pools(date);
CREATE INDEX IF NOT EXISTS idx_shared_stock_pools_pool_code ON shared_stock_pools(pool_code);
CREATE INDEX IF NOT EXISTS idx_shared_stock_pools_enable_flg ON shared_stock_pools(enable_flg);

-- 商品と共有在庫プールの紐付けテーブル
-- 商品がどの共有在庫プールを使用するかを定義
CREATE TABLE IF NOT EXISTS product_shared_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,                -- 商品ID
  shared_stock_pool_id INTEGER NOT NULL,      -- 共有在庫プールID
  stock_name TEXT,                            -- この商品での在庫の表示名（オプショナル）
  consume_quantity INTEGER DEFAULT 1,         -- 1予約あたりの消費在庫数（デフォルト: 1）
  priority INTEGER DEFAULT 0,                 -- 優先度（複数プール使用時の順序）
  enable_flg INTEGER DEFAULT 1,               -- 0:無効 1:有効
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  FOREIGN KEY (shared_stock_pool_id) REFERENCES shared_stock_pools(id) ON DELETE CASCADE
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_product_shared_stocks_product_id ON product_shared_stocks(product_id);
CREATE INDEX IF NOT EXISTS idx_product_shared_stocks_pool_id ON product_shared_stocks(shared_stock_pool_id);
CREATE INDEX IF NOT EXISTS idx_product_shared_stocks_enable_flg ON product_shared_stocks(enable_flg);

-- オプションと共有在庫プールの紐付けテーブル
-- オプションがどの共有在庫プールを使用するかを定義
CREATE TABLE IF NOT EXISTS option_shared_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,                 -- オプションID
  shared_stock_pool_id INTEGER NOT NULL,      -- 共有在庫プールID
  stock_name TEXT,                            -- このオプションでの在庫の表示名（オプショナル）
  consume_quantity INTEGER DEFAULT 1,         -- 1予約あたりの消費在庫数（デフォルト: 1）
  priority INTEGER DEFAULT 0,                 -- 優先度（複数プール使用時の順序）
  enable_flg INTEGER DEFAULT 1,               -- 0:無効 1:有効
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id) ON DELETE CASCADE,
  FOREIGN KEY (shared_stock_pool_id) REFERENCES shared_stock_pools(id) ON DELETE CASCADE
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_option_shared_stocks_option_id ON option_shared_stocks(option_id);
CREATE INDEX IF NOT EXISTS idx_option_shared_stocks_pool_id ON option_shared_stocks(shared_stock_pool_id);
CREATE INDEX IF NOT EXISTS idx_option_shared_stocks_enable_flg ON option_shared_stocks(enable_flg);

-- サンプルデータ
-- 共有在庫プールの例: バスツアー用の座席
INSERT INTO shared_stock_pools (pool_name, pool_code, description, date, time_slot_start, time_slot_end, time_slot_label, total_stock, booked)
VALUES 
  ('バス座席プール', 'BUS_SEATS_001', '観光バス50人乗り', '2025-12-25', '09:00', '17:00', '1日ツアー', 50, 0),
  ('駐車場プール', 'PARKING_001', '第1駐車場', '2025-12-25', NULL, NULL, NULL, 30, 0);

-- 既存の商品（ID=1）をバス座席プールに紐付け（例）
-- INSERT INTO product_shared_stocks (product_id, shared_stock_pool_id, stock_name, consume_quantity)
-- VALUES (1, 1, 'バス座席', 1);
