-- マスターデータ インポート用SQLファイル
-- accounts, organizers, clients, vendors, members, branches

-- ========================================
-- テーブル定義 (DDL)
-- ========================================

-- accountsテーブル
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

-- branchesテーブル
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

-- clientsテーブル
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

-- membersテーブル
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

-- organizersテーブル
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

-- vendorsテーブル
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

-- ========================================
-- データインポート
-- ========================================

-- accountsテーブルのデータ
INSERT OR REPLACE INTO accounts (id, login_id, password, person_name, email, client_id, role, enable_flg, created_at, modified_at, account_type, primary_branch_code, accessible_branches, expiration_date, tel, mobile) VALUES
  (1, 'admin', 'password123', '管理者太郎', 'admin@example.com', NULL, 'system_admin', 1, '2026-01-26 10:04:02', '2026-01-26 10:04:02', 'keio', NULL, NULL, NULL, '03-1111-2222', '080-1111-2222'),
  (2, 'user001', 'password123', '山田花子', 'yamada@example.com', NULL, 'admin', 1, '2026-01-26 10:04:02', '2026-01-26 10:04:02', 'keio', NULL, NULL, NULL, '03-2222-3333', '080-2222-3333'),
  (3, 'branch001', 'password123', '佐藤次郎', 'sato@example.com', NULL, 'branch', 1, '2026-01-26 10:04:02', '2026-01-26 10:04:02', 'keio', NULL, NULL, NULL, '06-3333-4444', '080-3333-4444'),
  (4, 'client001', 'password123', '田中三郎', 'tanaka@example.com', NULL, 'client', 1, '2026-01-26 10:04:02', '2026-01-26 10:05:18', 'keio', NULL, NULL, NULL, '052-4444-5555', '080-4444-5555'),
  (5, 'disabled001', 'password123', '無効ユーザー', 'disabled@example.com', NULL, 'admin', 0, '2026-01-26 10:04:02', '2026-01-26 10:04:02', 'keio', NULL, NULL, NULL, '03-5555-6666', '080-5555-6666');

-- branchesテーブルのデータ
INSERT OR REPLACE INTO branches (id, branch_code, branch_name, branch_full_name, display_order, enable_flg, created_at, modified_at) VALUES
  (1, 'HQ', '本社', '株式会社京王観光 本社', 0, 1, datetime('now', 'localtime'), datetime('now', 'localtime')),
  (2, 'SHINJUKU', '新宿支店', '株式会社京王観光 新宿支店', 1, 1, datetime('now', 'localtime'), datetime('now', 'localtime')),
  (3, 'SHIBUYA', '渋谷支店', '株式会社京王観光 渋谷支店', 2, 1, datetime('now', 'localtime'), datetime('now', 'localtime')),
  (4, 'CHOFU', '調布支店', '株式会社京王観光 調布支店', 3, 1, datetime('now', 'localtime'), datetime('now', 'localtime')),
  (5, 'TACHIKAWA', '立川支店', '株式会社京王観光 立川支店', 4, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

-- clientsテーブルのデータ
INSERT OR REPLACE INTO clients (id, name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, remarks, reg_flg, group_id, created_at, modified_at, client_code, position) VALUES
  (1, '株式会社テストクライアント', '山田太郎', '東京本社', '佐藤花子', '1000001', 13, '千代田区千代田1-1-1', '03-1234-5678', '03-1234-5679', 'test@example.com', 'password123', 'テストクライアント', 1, 1, '2026-01-26 09:56:51', '2026-01-26 09:56:51', 'TC001', '営業部長'),
  (2, '株式会社サンプル', '田中次郎', '大阪支店', '鈴木一郎', '5300001', 1, '大阪市北区梅田1-1-1', '06-2345-6789', '06-2345-6790', 'sample@example.com', 'password456', 'サンプルクライアント', 1, 1, '2026-01-26 09:56:51', '2026-01-26 09:56:51', 'SA001', '営業課長'),
  (3, '株式会社デモ', '高橋三郎', '名古屋支店', '伊藤美咲', '4600001', 23, '名古屋市中区栄1-1-1', '052-3456-7890', '052-3456-7891', 'demo@example.com', 'password789', 'デモクライアント', 1, 1, '2026-01-26 09:56:51', '2026-01-26 09:56:51', 'DM001', '部長');

-- membersテーブルのデータ
INSERT OR REPLACE INTO members (id, email, password_hash, family_name, first_name, family_kana, first_kana, last_name_en, first_name_en, sex, birth, zip, pref_id, addr, tel, enable_flg, created_at, modified_at, mobile) VALUES
  (1, 'member001@example.com', '$2b$10$abcdefghijklmnopqrstuv', '田中', '太郎', 'タナカ', 'タロウ', 'Tanaka', 'Taro', '男', '1990-01-15', '1500001', 13, '東京都渋谷区神宮前1-1-1', '03-1111-1111', 1, '2026-01-26 10:00:00', '2026-01-26 10:00:00', '090-1111-1111'),
  (2, 'member002@example.com', '$2b$10$abcdefghijklmnopqrstuv', '佐藤', '花子', 'サトウ', 'ハナコ', 'Sato', 'Hanako', '女', '1992-05-20', '1600001', 13, '東京都新宿区新宿2-2-2', '03-2222-2222', 1, '2026-01-26 10:00:00', '2026-01-26 10:00:00', '090-2222-2222'),
  (3, 'member003@example.com', '$2b$10$abcdefghijklmnopqrstuv', '鈴木', '次郎', 'スズキ', 'ジロウ', 'Suzuki', 'Jiro', '男', '1988-10-10', '5300001', 27, '大阪府大阪市北区梅田3-3-3', '06-3333-3333', 1, '2026-01-26 10:00:00', '2026-01-26 10:00:00', '090-3333-3333');

-- organizersテーブルのデータ
INSERT OR REPLACE INTO organizers (id, name, contactable_person, email, tel, branch_office, reg_flg, deleted_at, zip, pref_id, addr, fax, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, created_at, modified_at) VALUES
  (1, '京王観光イベント事業部', '山本太郎', 'event@keio-kanko.com', '03-1111-0000', '本社', 1, NULL, '1600023', 13, '東京都新宿区西新宿1-1-1', '03-1111-0001', 'password123', '平日9:00-18:00', '土日祝', '年末年始休業あり', '東京都知事登録旅行業第1-1111号', '一般社団法人日本旅行業協会', '正会員', '旅行業務取扱管理者', '田中一郎', '主催旅行事業部', '2026-01-26 09:50:00', '2026-01-26 09:50:00'),
  (2, '関西イベントプランニング', '佐々木花子', 'info@kansai-event.com', '06-2222-0000', '大阪本社', 1, NULL, '5300047', 27, '大阪府大阪市北区西天満2-2-2', '06-2222-0001', 'password456', '平日9:00-18:00', '土日祝', NULL, '大阪府知事登録旅行業第2-2222号', '一般社団法人全国旅行業協会', '正会員', '総合旅行業務取扱管理者', '鈴木次郎', '大規模イベント専門', '2026-01-26 09:50:00', '2026-01-26 09:50:00');

-- vendorsテーブルのデータ
INSERT OR REPLACE INTO vendors (id, name, contactable_person, email, tel, reg_flg, deleted_at, zip, pref_id, addr, fax, password, business_hours, closed_days, business_notes, remarks, created_at, modified_at) VALUES
  (1, '東京イベント会場', '高橋太郎', 'info@tokyo-venue.com', '03-3333-0000', 1, NULL, '1500013', 13, '東京都渋谷区恵比寿1-1-1', '03-3333-0001', 'password123', '平日9:00-21:00', '年中無休', '大型イベント対応可能', '最大収容人数5000名', '2026-01-26 09:55:00', '2026-01-26 09:55:00'),
  (2, '大阪コンベンションセンター', '伊藤花子', 'info@osaka-convention.com', '06-4444-0000', 1, NULL, '5300005', 27, '大阪府大阪市北区中之島2-2-2', '06-4444-0001', 'password456', '平日9:00-20:00', '月曜定休', '展示会・商談会対応', '国際会議対応可能', '2026-01-26 09:55:00', '2026-01-26 09:55:00'),
  (3, '横浜マリンホテル', '渡辺三郎', 'banquet@yokohama-marine.com', '045-5555-0000', 1, NULL, '2200012', 14, '神奈川県横浜市西区みなとみらい3-3-3', '045-5555-0001', 'password789', '24時間対応', '年中無休', '宿泊パック対応可能', '宴会場・会議室完備', '2026-01-26 09:55:00', '2026-01-26 09:55:00');
