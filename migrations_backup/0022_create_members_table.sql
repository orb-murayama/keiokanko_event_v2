-- 会員管理テーブル
CREATE TABLE IF NOT EXISTS members (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  last_name TEXT NOT NULL,
  first_name TEXT NOT NULL,
  last_name_roma TEXT,
  first_name_roma TEXT,
  last_name_en TEXT,
  first_name_en TEXT,
  gender TEXT CHECK(gender IN ('male', 'female', 'other', '')),
  birth_date TEXT,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  tel TEXT NOT NULL,
  enable_flg INTEGER NOT NULL DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (pref_id) REFERENCES prefs(id)
);

-- メールアドレスでの検索用インデックス
CREATE INDEX IF NOT EXISTS idx_members_email ON members(email);

-- 姓名での検索用インデックス
CREATE INDEX IF NOT EXISTS idx_members_name ON members(last_name, first_name);

-- 有効フラグでの検索用インデックス
CREATE INDEX IF NOT EXISTS idx_members_enable_flg ON members(enable_flg);
