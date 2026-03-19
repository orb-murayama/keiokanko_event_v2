-- オプション専用在庫テーブル
CREATE TABLE IF NOT EXISTS option_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  date TEXT NOT NULL,
  stock_name TEXT,
  total_stock INTEGER NOT NULL DEFAULT 0,
  booked INTEGER NOT NULL DEFAULT 0,
  available_stock INTEGER NOT NULL DEFAULT 0,
  enable_flg INTEGER NOT NULL DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id),
  UNIQUE(option_id, date, stock_name)
);

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_option_stocks_option_id ON option_stocks(option_id);
CREATE INDEX IF NOT EXISTS idx_option_stocks_date ON option_stocks(date);
CREATE INDEX IF NOT EXISTS idx_option_stocks_enable_flg ON option_stocks(enable_flg);
