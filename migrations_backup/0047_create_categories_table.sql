-- カテゴリマスターテーブルを作成

CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  display_order INTEGER NOT NULL,
  enable_flg INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime'))
);

-- インデックスを作成
CREATE INDEX IF NOT EXISTS idx_categories_display_order ON categories(display_order);
CREATE INDEX IF NOT EXISTS idx_categories_enable_flg ON categories(enable_flg);
