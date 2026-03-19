PRAGMA defer_foreign_keys=TRUE;
CREATE TABLE accounts (
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
INSERT INTO "accounts" VALUES(1,'admin','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','システム管理者','admin@keio-kanko.co.jp',NULL,'admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio',NULL,NULL,NULL,'03-1234-5678','090-1234-5678');
INSERT INTO "accounts" VALUES(2,'keio_honsha','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','本社管理者','honsha@keio-kanko.co.jp',NULL,'branch',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','HON','["HON","SHI","TAC","HNO"]',NULL,'03-1234-5678','090-1111-2222');
INSERT INTO "accounts" VALUES(3,'keio_shinjuku','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','新宿支店担当','shinjuku@keio-kanko.co.jp',NULL,'branch',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','SHI','["SHI"]',NULL,'03-2345-6789','090-2222-3333');
INSERT INTO "accounts" VALUES(4,'keio_tachikawa','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','立川支店担当','tachikawa@keio-kanko.co.jp',NULL,'branch',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','TAC','["TAC"]',NULL,'042-1234-5678','090-3333-4444');
INSERT INTO "accounts" VALUES(5,'keio_hachioji','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','八王子支店担当','hachioji@keio-kanko.co.jp',NULL,'branch',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','HNO','["HNO"]',NULL,'042-2345-6789','090-4444-5555');
INSERT INTO "accounts" VALUES(6,'client_keio','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','田中太郎','tanaka@keio-kanko.co.jp',1,'client_admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','client',NULL,NULL,'2025-12-31','03-1234-5678','090-5555-6666');
INSERT INTO "accounts" VALUES(7,'client_tabinotomo','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','鈴木一郎','suzuki@tabinotomo.co.jp',2,'client_admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','client',NULL,NULL,'2025-12-31','03-2345-6789','090-6666-7777');
INSERT INTO "accounts" VALUES(8,'client_global','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','Michael Smith','smith@globaltours.com',3,'client_admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','client',NULL,NULL,'2025-12-31','03-3456-7890','090-7777-8888');
INSERT INTO "accounts" VALUES(9,'organizer_keio_tours','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','山田太郎','yamada@keio-tours.co.jp',NULL,'organizer',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','organizer',NULL,NULL,'2025-12-31','03-1111-2222','090-8888-9999');
INSERT INTO "accounts" VALUES(10,'organizer_tama','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','佐藤花子','sato@tama-tourism.jp',NULL,'organizer',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','organizer',NULL,NULL,'2025-12-31','042-2222-3333','090-9999-0000');

CREATE TABLE event_staff (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(event_id, account_id),
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);
CREATE INDEX idx_event_staff_event_id ON event_staff(event_id);
CREATE INDEX idx_event_staff_account_id ON event_staff(account_id);
