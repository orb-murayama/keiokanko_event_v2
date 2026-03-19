-- マイグレーション: アカウント管理用のテーブルを作成

CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER,
  login_id TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  person_name TEXT NOT NULL,
  email TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'general',
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (client_id) REFERENCES clients(id)
);

-- インデックス作成
CREATE INDEX idx_accounts_client_id ON accounts(client_id);
CREATE INDEX idx_accounts_login_id ON accounts(login_id);
CREATE INDEX idx_accounts_role ON accounts(role);
