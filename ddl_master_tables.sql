-- マスターデータ テーブル定義 (DDL)
-- accounts, organizers, clients, vendors, members, branches

-- ========================================
-- accountsテーブル
-- ========================================
CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  login_id TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  person_name TEXT NOT NULL,
  email TEXT NOT NULL,
  client_id INTEGER,
  role TEXT NOT NULL,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  account_type TEXT DEFAULT 'keio',
  primary_branch_code TEXT,
  accessible_branches TEXT,
  expiration_date TEXT DEFAULT NULL,
  tel TEXT DEFAULT NULL,
  mobile TEXT DEFAULT NULL
);

-- accountsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_accounts_login_id ON accounts(login_id);
CREATE INDEX IF NOT EXISTS idx_accounts_email ON accounts(email);
CREATE INDEX IF NOT EXISTS idx_accounts_role ON accounts(role);
CREATE INDEX IF NOT EXISTS idx_accounts_enable_flg ON accounts(enable_flg);

-- ========================================
-- branchesテーブル
-- ========================================
CREATE TABLE IF NOT EXISTS branches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_code TEXT UNIQUE NOT NULL,
  branch_name TEXT NOT NULL,
  branch_full_name TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- branchesテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_branches_branch_code ON branches(branch_code);
CREATE INDEX IF NOT EXISTS idx_branches_enable_flg ON branches(enable_flg);
CREATE INDEX IF NOT EXISTS idx_branches_display_order ON branches(display_order);

-- ========================================
-- clientsテーブル
-- ========================================
CREATE TABLE IF NOT EXISTS clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  contactable_person TEXT,
  branch_office TEXT,
  accounted_person TEXT,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  tel TEXT NOT NULL,
  fax TEXT,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  remarks TEXT,
  reg_flg INTEGER DEFAULT 1,
  group_id INTEGER NOT NULL DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  client_code TEXT,
  position TEXT
);

-- clientsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_clients_email ON clients(email);
CREATE INDEX IF NOT EXISTS idx_clients_client_code ON clients(client_code);
CREATE INDEX IF NOT EXISTS idx_clients_reg_flg ON clients(reg_flg);

-- ========================================
-- membersテーブル
-- ========================================
CREATE TABLE IF NOT EXISTS members (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  family_name TEXT NOT NULL,
  first_name TEXT NOT NULL,
  family_kana TEXT NOT NULL,
  first_kana TEXT NOT NULL,
  last_name_en TEXT,
  first_name_en TEXT,
  sex TEXT,
  birth DATE,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  tel TEXT NOT NULL,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  mobile TEXT DEFAULT NULL
);

-- membersテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_members_email ON members(email);
CREATE INDEX IF NOT EXISTS idx_members_enable_flg ON members(enable_flg);

-- ========================================
-- organizersテーブル
-- ========================================
CREATE TABLE IF NOT EXISTS organizers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  contactable_person TEXT,
  email TEXT,
  tel TEXT,
  branch_office TEXT,
  reg_flg INTEGER DEFAULT 1,
  deleted_at TEXT,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  fax TEXT,
  password TEXT,
  business_hours TEXT,
  closed_days TEXT,
  business_notes TEXT,
  registration_number TEXT,
  association_name TEXT,
  association_membership TEXT,
  travel_manager_title TEXT,
  travel_manager_name TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- organizersテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_organizers_email ON organizers(email);
CREATE INDEX IF NOT EXISTS idx_organizers_reg_flg ON organizers(reg_flg);
CREATE INDEX IF NOT EXISTS idx_organizers_deleted_at ON organizers(deleted_at);

-- ========================================
-- vendorsテーブル
-- ========================================
CREATE TABLE IF NOT EXISTS vendors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  contactable_person TEXT,
  email TEXT,
  tel TEXT,
  reg_flg INTEGER DEFAULT 1,
  deleted_at TEXT,
  zip TEXT,
  pref_id INTEGER,
  addr TEXT,
  fax TEXT,
  password TEXT,
  business_hours TEXT,
  closed_days TEXT,
  business_notes TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- vendorsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_vendors_email ON vendors(email);
CREATE INDEX IF NOT EXISTS idx_vendors_reg_flg ON vendors(reg_flg);
CREATE INDEX IF NOT EXISTS idx_vendors_deleted_at ON vendors(deleted_at);
