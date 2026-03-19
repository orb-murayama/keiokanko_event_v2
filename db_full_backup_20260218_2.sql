-- Full Database Backup
-- Generated: 2026-02-18 09:17:54
-- Database: webapp-production (local)
-- Tables: 39


-- Table: _cf_METADATA
CREATE TABLE _cf_METADATA (
        key INTEGER PRIMARY KEY,
        value BLOB
      );

INSERT INTO "_cf_METADATA" VALUES (2,396);


-- Table: accounts
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

INSERT INTO "accounts" VALUES (1,'admin','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','システム管理者','admin@keio-kanko.co.jp',NULL,'admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio',NULL,NULL,NULL,'03-1234-5678','090-1234-5678');
INSERT INTO "accounts" VALUES (2,'keio_honsha','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','本社管理者','honsha@keio-kanko.co.jp',NULL,'staff',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','HON','["HON","SHI","TAC","HNO"]',NULL,'03-1234-5678','090-1111-2222');
INSERT INTO "accounts" VALUES (3,'keio_shinjuku','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','新宿支店担当','shinjuku@keio-kanko.co.jp',NULL,'staff',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','SHI','["SHI"]',NULL,'03-2345-6789','090-2222-3333');
INSERT INTO "accounts" VALUES (4,'keio_tachikawa','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','立川支店担当','tachikawa@keio-kanko.co.jp',NULL,'staff',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','TAC','["TAC"]',NULL,'042-1234-5678','090-3333-4444');
INSERT INTO "accounts" VALUES (5,'keio_hachioji','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','八王子支店担当','hachioji@keio-kanko.co.jp',NULL,'branch',1,'2026-02-12 07:16:29','2026-02-18 00:51:31','keio','HON','["HON","HNO"]',NULL,'042-2345-6789','090-4444-5555');
INSERT INTO "accounts" VALUES (6,'client_keio','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','田中太郎','tanaka@keio-kanko.co.jp',NULL,'branch',1,'2026-02-12 07:16:29','2026-02-18 00:51:05','keio','HON',NULL,'2025-12-31','03-1234-5678','090-5555-6666');
INSERT INTO "accounts" VALUES (7,'client_tabinotomo','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','鈴木一郎','suzuki@tabinotomo.co.jp',2,'client_admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','client',NULL,NULL,'2025-12-31','03-2345-6789','090-6666-7777');
INSERT INTO "accounts" VALUES (8,'client_global','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','Michael Smith','smith@globaltours.com',3,'client_admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','client',NULL,NULL,'2025-12-31','03-3456-7890','090-7777-8888');
INSERT INTO "accounts" VALUES (9,'organizer_keio_tours','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','山田太郎','yamada@keio-tours.co.jp',NULL,'organizer',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','organizer',NULL,NULL,'2025-12-31','03-1111-2222','090-8888-9999');
INSERT INTO "accounts" VALUES (10,'organizer_tama','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','佐藤花子','sato@tama-tourism.jp',NULL,'organizer',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','organizer',NULL,NULL,'2025-12-31','042-2222-3333','090-9999-0000');


-- Table: booking_emails
CREATE TABLE booking_emails (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,
  from_email TEXT NOT NULL,
  to_email TEXT NOT NULL,
  bcc_email TEXT,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  scheduled_send_at DATETIME NOT NULL,
  send_status TEXT DEFAULT 'pending',
  sent_at DATETIME,
  error_message TEXT,
  template_id INTEGER,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (template_id) REFERENCES email_templates(id)
);

INSERT INTO "booking_emails" VALUES (2,'BK20260216-001','noreply@example.com','suzuki.hanako@example.com','admin@example.com','【東京1日観光ツアー 英語ガイド付き】ご予約確認','鈴木花子 様

ご予約ありがとうございます。
予約番号: BK20260216-001','2026-02-13 10:00:00','pending',NULL,NULL,NULL,'2026-02-12 08:53:34','2026-02-12 08:53:34');
INSERT INTO "booking_emails" VALUES (3,'BK20260215-001','noreply@example.com','yamada.taro@example.com',NULL,'【東京1日観光ツアー 英語ガイド付き】ご予約確認','山田太郎 様

この度は東京1日観光ツアー 英語ガイド付きにお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: BK20260215-001
イベント名: 東京1日観光ツアー 英語ガイド付き
開催期間: 2026-01-01 〜 2026-12-31

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。','2026-02-13 10:00:00','pending',NULL,NULL,1,'2026-02-12 08:55:42','2026-02-12 08:55:42');
INSERT INTO "booking_emails" VALUES (4,'BK20260215-001','noreply@example.com','yamada.taro@example.com',NULL,'【東京1日観光ツアー 英語ガイド付き】ご予約確認','山田太郎 様

この度は東京1日観光ツアー 英語ガイド付きにお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: BK20260215-001
イベント名: 東京1日観光ツアー 英語ガイド付き
開催期間: 2026-01-01 〜 2026-12-31

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。','2026-02-13 10:00:00','pending',NULL,NULL,1,'2026-02-12 08:58:36','2026-02-12 08:58:36');
INSERT INTO "booking_emails" VALUES (5,'BK20260215-001','noreply@example.com','yamada.taro@example.com',NULL,'【東京1日観光ツアー 英語ガイド付き】ご予約確認','山田太郎 様

この度は東京1日観光ツアー 英語ガイド付きにお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: BK20260215-001
イベント名: 東京1日観光ツアー 英語ガイド付き
開催期間: 2026-01-01 〜 2026-12-31

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。','2026-02-13 10:00:00','pending',NULL,NULL,1,'2026-02-12 09:03:14','2026-02-12 09:03:14');
INSERT INTO "booking_emails" VALUES (6,'BK20260215-001','noreply@example.com','yamada.taro@example.com',NULL,'【東京1日観光ツアー 英語ガイド付き】ご予約確認','山田太郎 様

この度は東京1日観光ツアー 英語ガイド付きにお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: BK20260215-001
イベント名: 東京1日観光ツアー 英語ガイド付き
開催期間: 2026-01-01 〜 2026-12-31

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。','2026-02-13 10:00:00','pending',NULL,NULL,1,'2026-02-12 09:05:54','2026-02-12 09:05:54');


-- Table: booking_files
CREATE TABLE booking_files (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,
  file_key TEXT NOT NULL,
  original_filename TEXT NOT NULL,
  display_filename TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  download_limit INTEGER DEFAULT 0,
  download_count INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_number) REFERENCES bookings(booking_number)
);

INSERT INTO "booking_files" VALUES (1,'BK20260215-001','documents/1770885342228-領収書テンプレート_BK20260215-001_20260212.pdf','領収書テンプレート_BK20260215-001_20260212.pdf','領収書テンプレート_BK20260215-001_20260212.pdf',223289,1,0,'2026-02-12 08:35:42','2026-02-12 08:35:51');


-- Table: booking_items
CREATE TABLE booking_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  payment_id INTEGER,
  
  
  item_type TEXT NOT NULL,
  item_id INTEGER NOT NULL,
  item_name TEXT NOT NULL,
  stock_id INTEGER,
  price_category TEXT,
  
  
  quantity INTEGER DEFAULT 1,
  unit_price INTEGER NOT NULL,
  subtotal INTEGER NOT NULL,
  
  
  participation_date TEXT,
  
  
  participants TEXT,
  
  
  status TEXT DEFAULT 'active',
  canceled_at TEXT,
  cancel_reason TEXT,
  refund_amount INTEGER DEFAULT 0,
  
  
  item_details TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (payment_id) REFERENCES booking_payments(id)
);

INSERT INTO "booking_items" VALUES (1,1,1,'product',1,'東京1日観光ツアー スタンダードプラン',5,'大人',2,12000,24000,'2026-03-15','[{"lastname":"山田","firstname":"太郎","age":"","gender":"","email":"","phone":"","birth":"","custom_fields":{}},{"lastname":"山田","firstname":"ハナコ","age":30,"gender":"女性","email":"","phone":"","birth":"","custom_fields":{}}]','active',NULL,NULL,0,'{"price_name":"大人（13歳以上）"}','','2026-02-15 10:35:00','2026-02-12 09:39:27');
INSERT INTO "booking_items" VALUES (2,1,1,'product',1,'東京1日観光ツアー スタンダードプラン',5,'子供',1,8000,8000,'2026-03-15','[{"lastname":"山田","firstname":"一郎","age":22,"gender":"","email":"","phone":"","birth":"","custom_fields":{}}]','active',NULL,NULL,0,'{"price_name":"子供（6-12歳）"}','','2026-02-15 10:35:00','2026-02-12 09:39:28');
INSERT INTO "booking_items" VALUES (3,2,2,'product',2,'東京1日観光ツアー プレミアムプラン',40,'大人',1,18000,18000,'2026-03-22','鈴木花子','active',NULL,NULL,0,'{"price_name":"大人（13歳以上）"}','','2026-02-16 14:20:00','2026-02-16 14:20:00');
INSERT INTO "booking_items" VALUES (4,3,3,'product',3,'東京プライベート観光ツアー（貸切）',52,'3-4名',1,100000,100000,'2026-04-05','田中一郎、田中美咲、田中太郎、田中花子','active',NULL,NULL,0,'{"price_name":"3-4名様"}','','2026-02-17 09:20:00','2026-02-17 09:20:00');
INSERT INTO "booking_items" VALUES (5,4,4,'product',1,'東京1日観光ツアー スタンダードプラン',11,'大人',2,12000,24000,'2026-02-23','渡辺優希、渡辺健二','cancelled','2026-02-20 11:30:00','急用のため',16800,'{"price_name":"大人（13歳以上）","cancellation_rate":30}','','2026-02-18 16:50:00','2026-02-20 11:30:00');
INSERT INTO "booking_items" VALUES (6,5,5,'product',1,'東京1日観光ツアー スタンダードプラン',18,'大人',2,12000,24000,'2026-03-29','伊藤健二、伊藤愛','active',NULL,NULL,0,'{"price_name":"大人（13歳以上）"}','','2026-02-19 13:10:00','2026-02-19 13:10:00');
INSERT INTO "booking_items" VALUES (7,5,5,'product',1,'東京1日観光ツアー スタンダードプラン',18,'子供',2,8000,16000,'2026-03-29','伊藤太郎、伊藤花子','active',NULL,NULL,0,'{"price_name":"子供（6-12歳）","allergy":"卵・小麦"}','','2026-02-19 13:10:00','2026-02-19 13:10:00');
INSERT INTO "booking_items" VALUES (8,5,5,'product',1,'東京1日観光ツアー スタンダードプラン',18,'幼児',1,0,0,'2026-03-29','伊藤結衣','active',NULL,NULL,0,'{"price_name":"幼児（5歳以下・座席なし）"}','','2026-02-19 13:10:00','2026-02-19 13:10:00');
INSERT INTO "booking_items" VALUES (9,1,NULL,'product',2,'東京1日観光ツアー プレミアムプラン',NULL,NULL,1,18000,18000,'2026-02-14','[{"lastname":"ヤマダ","firstname":"タロウ","age":"","gender":"","email":"","phone":"","birth":"","custom_fields":{"Dietary Restrictions / 食事制限":"No restrictions / なし","Special Requests / 特別なご要望":"ああああ","Hotel Name (if pickup needed) / ホテル名（送迎希望の場合）":"ざざ"}}]','active',NULL,NULL,0,NULL,NULL,'2026-02-12 08:07:31','2026-02-12 09:39:28');


-- Table: booking_messages
CREATE TABLE booking_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  booking_number TEXT NOT NULL,
  recipient_email TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  scheduled_send_at TEXT NOT NULL,
  sent_at TEXT,
  send_status TEXT DEFAULT 'pending',
  display_on_mypage INTEGER DEFAULT 1,
  created_by TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);


-- Table: booking_payments
CREATE TABLE booking_payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,
  payment_number TEXT UNIQUE NOT NULL,
  
  
  payment_type TEXT NOT NULL DEFAULT 'immediate',
  payment_method TEXT NOT NULL,
  payment_status TEXT DEFAULT 'pending',
  
  
  amount INTEGER NOT NULL,
  refunded_amount INTEGER DEFAULT 0,
  net_amount INTEGER GENERATED ALWAYS AS (amount - refunded_amount) STORED,
  
  
  payment_date TEXT,
  payment_due_date TEXT,
  refund_date TEXT,
  
  
  payment_transaction_id TEXT,
  payment_details TEXT,
  
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_number) REFERENCES bookings(booking_number)
);


-- Table: bookings
CREATE TABLE bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT UNIQUE NOT NULL,
  customer_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  status TEXT DEFAULT 'active',
  
  
  booker_name TEXT,
  booker_email TEXT,
  booker_phone TEXT,
  
  
  additional_info TEXT,
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')), secure_token TEXT, token_expires_at DATETIME, gmo_order_id TEXT, gmo_access_id TEXT, gmo_access_pass TEXT, is_new_member INTEGER DEFAULT 0,
  
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (event_id) REFERENCES events(id)
);

INSERT INTO "bookings" VALUES (1,'BK20260215-001',1,3,'confirmed','山田太郎','yamada.taro@example.com','090-1234-5678',NULL,NULL,'2026-02-15 10:30:00','2026-02-15 10:30:00',NULL,NULL,NULL,NULL,NULL,0);
INSERT INTO "bookings" VALUES (2,'BK20260216-001',2,3,'confirmed','鈴木花子','suzuki.hanako@example.com','090-2345-6789',NULL,NULL,'2026-02-16 10:30:00','2026-02-16 10:30:00',NULL,NULL,NULL,NULL,NULL,0);
INSERT INTO "bookings" VALUES (3,'BK20260217-001',3,3,'pending','田中一郎','tanaka.ichiro@example.com','090-3456-7890',NULL,NULL,'2026-02-17 10:30:00','2026-02-17 10:30:00',NULL,NULL,NULL,NULL,NULL,0);
INSERT INTO "bookings" VALUES (4,'BK20260218-001',4,3,'cancelled','渡辺優希','watanabe.yuki@example.com','080-4567-8901','急用のためキャンセルさせていただきます。','キャンセル料30%適用','2026-02-18 16:45:00','2026-02-20 11:30:00',NULL,NULL,NULL,NULL,NULL,0);
INSERT INTO "bookings" VALUES (5,'BK20260219-001',5,3,'pending','伊藤健二','ito.kenji@example.com','090-5678-9012','子供の食事でアレルギー対応をお願いします（卵・小麦）。幼児は座席不要です。','','2026-02-19 13:10:00','2026-02-19 13:10:00',NULL,NULL,NULL,NULL,NULL,0);


-- Table: branches
CREATE TABLE branches (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_code TEXT UNIQUE NOT NULL,
  branch_name TEXT NOT NULL,
  branch_full_name TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO "branches" VALUES (1,'HON','本社','京王観光本社',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "branches" VALUES (2,'SHI','新宿','京王観光新宿支店',2,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "branches" VALUES (3,'TAC','立川','京王観光立川支店',3,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "branches" VALUES (4,'HNO','八王子','京王観光八王子支店',4,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "branches" VALUES (5,'CHO','調布','京王観光調布支店',5,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "branches" VALUES (6,'FUC','府中','京王観光府中支店',6,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "branches" VALUES (7,'SAN','三鷹','京王観光三鷹支店',7,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "branches" VALUES (8,'KOK','国分寺','京王観光国分寺支店',8,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "branches" VALUES (9,'01','東京中央支店','東京中央支店:01',1,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (10,'02','東京南支店','東京南支店:02',2,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (11,'03','東京東支店','東京東支店:03',3,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (12,'04','イベント＆ツアー センター','イベント＆ツアー センター:04',4,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (13,'05','さいたま支店','さいたま支店:05',5,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (14,'06','調布支店','調布支店:06',6,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (15,'07','立川支店','立川支店:07',7,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (16,'08','八王子支店','八王子支店:08',8,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (17,'09','神奈川北支店','神奈川北支店:09',9,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (18,'10','町田営業所','町田営業所:10',10,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (19,'11','団体旅行営業部スポーツセールス担当','団体旅行営業部スポーツセールス担当:11',11,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (20,'12','札幌支店','札幌支店:12',12,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (21,'13','仙台支店','仙台支店:13',13,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (22,'14','大阪支店','大阪支店:14',14,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (23,'15','大阪西支店','大阪西支店:15',15,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (24,'16','福岡支店','福岡支店:16',16,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (25,'17','旅行事業部','旅行事業部:17',17,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO "branches" VALUES (26,'18','経営管理部','経営管理部:18',18,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');


-- Table: categories
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  slug TEXT UNIQUE,
  description TEXT,
  parent_id INTEGER,
  display_order INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);


-- Table: clients
CREATE TABLE clients (
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

INSERT INTO "clients" VALUES (1,'京王観光株式会社','田中太郎','本社','経理部 山田花子','160-0023',13,'新宿区西新宿1-1-1','03-1234-5678','03-1234-5679','tanaka@keio-kanko.co.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','主要取引先',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI001','営業部長');
INSERT INTO "clients" VALUES (2,'株式会社旅の友','鈴木一郎','東京支店','営業部 佐藤次郎','100-0001',13,'千代田区千代田1-1','03-2345-6789','03-2345-6780','suzuki@tabinotomo.co.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','VIP顧客',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI002','支店長');
INSERT INTO "clients" VALUES (3,'グローバルツアーズ','Michael Smith','日本支社','Finance Team','105-0001',13,'港区虎ノ門2-2-2','03-3456-7890','03-3456-7891','smith@globaltours.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','海外顧客',1,2,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI003','Manager');
INSERT INTO "clients" VALUES (4,'日本トラベル協会','高橋美咲','事務局','総務課 伊藤健太','150-0001',13,'渋谷区神宮前3-3-3','03-4567-8901','03-4567-8902','takahashi@jta.or.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','協会関係',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI004','事務局長');
INSERT INTO "clients" VALUES (5,'エコツーリズム推進協議会','中村環','企画部','企画課 小林緑','102-0072',13,'千代田区飯田橋4-4-4','03-5678-9012','03-5678-9013','nakamura@eco-tourism.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','エコツアー専門',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI005','企画部長');


-- Table: d1_migrations
CREATE TABLE d1_migrations(
		id         INTEGER PRIMARY KEY AUTOINCREMENT,
		name       TEXT UNIQUE,
		applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

INSERT INTO "d1_migrations" VALUES (1,'0000_consolidated_schema.sql','2026-02-18 08:23:01');
INSERT INTO "d1_migrations" VALUES (2,'0003_drop_customers_table.sql','2026-02-18 08:23:01');
INSERT INTO "d1_migrations" VALUES (3,'0022_mark_all_migrations_applied.sql','2026-02-18 08:23:02');
INSERT INTO "d1_migrations" VALUES (4,'0023_create_event_staff_table.sql','2026-02-18 08:23:02');
INSERT INTO "d1_migrations" VALUES (5,'0024_add_image_url_to_products.sql','2026-02-18 08:23:03');
INSERT INTO "d1_migrations" VALUES (6,'0025_add_image_url_to_events.sql','2026-02-18 08:23:03');
INSERT INTO "d1_migrations" VALUES (7,'0026_add_image_url_to_options.sql','2026-02-18 08:25:34');
INSERT INTO "d1_migrations" VALUES (8,'0027_add_member_auth_fields.sql','2026-02-18 08:25:36');
INSERT INTO "d1_migrations" VALUES (9,'0028_create_otp_tokens.sql','2026-02-18 08:25:37');
INSERT INTO "d1_migrations" VALUES (10,'0029_add_booking_gmo_fields.sql','2026-02-18 08:28:43');
INSERT INTO "d1_migrations" VALUES (11,'0030_create_gmo_payment_logs.sql','2026-02-18 08:36:05');


-- Table: email_templates
CREATE TABLE email_templates (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  template_name TEXT NOT NULL UNIQUE,
  description TEXT,
  from_email TEXT NOT NULL,
  bcc_email TEXT,
  subject_template TEXT NOT NULL,
  body_template TEXT NOT NULL,
  is_active INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime'))
);

INSERT INTO "email_templates" VALUES (1,'予約確認メール','お客様への予約確認メール','noreply@example.com',NULL,'【{{event_name}}】ご予約確認','{{booker_name}} 様

この度は{{event_name}}にお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: {{booking_number}}
イベント名: {{event_name}}
開催期間: {{event_start_date}} 〜 {{event_end_date}}

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。',1,'2026-02-18 08:23:01','2026-02-18 08:23:01');


-- Table: event_form_fields
CREATE TABLE event_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  field_type TEXT NOT NULL,
  field_name TEXT NOT NULL,
  field_label TEXT NOT NULL,
  field_options TEXT,
  is_required INTEGER DEFAULT 0,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  placeholder TEXT,
  parent_field_id INTEGER,
  parent_condition TEXT,
  indent_level INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (event_id) REFERENCES events(id)
);


-- Table: event_staff
CREATE TABLE event_staff (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  account_id INTEGER NOT NULL,
  assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  UNIQUE(event_id, account_id)
);


-- Table: events
CREATE TABLE events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  detail TEXT,
  contact TEXT NOT NULL,
  remarks TEXT,
  question TEXT,
  postage INTEGER DEFAULT 0,
  thanks_msg TEXT,
  note TEXT,
  client_id INTEGER NOT NULL,
  company_flg INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  payment_flg INTEGER DEFAULT 0,
  payment_cd TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  
  customer_client_id INTEGER,
  vendor_id INTEGER,
  event_url TEXT,
  category TEXT,
  deleted_at TEXT,
  date_selection_type TEXT DEFAULT 'single',
  location TEXT,
  payment_methods TEXT,
  credit_fee_type TEXT,
  bank_fee_type TEXT,
  convenience_fee_type TEXT,
  registration_start_date TEXT,
  registration_end_date TEXT,
  event_start_date TEXT,
  event_end_date TEXT,
  admin_email TEXT,
  admin_name TEXT,
  
  
  name_en TEXT,
  detail_en TEXT,
  location_en TEXT,
  contact_en TEXT,
  remarks_en TEXT,
  thanks_msg_en TEXT,
  
  
  organizer_id INTEGER,
  admin_login_start_date TEXT,
  admin_login_end_date TEXT,
  admin_cc_email TEXT,
  sender_name TEXT,
  sender_email TEXT,
  email_signature TEXT,
  email_signature_en TEXT,
  
  
  bank_name TEXT,
  bank_branch TEXT,
  bank_account_type TEXT,
  bank_account_number TEXT,
  bank_account_name TEXT,
  bank_transfer_deadline INTEGER,
  
  
  store_code TEXT,
  convenience_payment_deadline INTEGER,
  available_convenience_stores TEXT,
  
  
  credit_fee_percentage REAL,
  credit_fee_fixed INTEGER,
  bank_fee_percentage REAL,
  bank_fee_fixed INTEGER,
  convenience_fee_percentage REAL,
  convenience_fee_fixed INTEGER,
  
  
  form_field_settings TEXT,
  
  
  auto_reply_enabled INTEGER DEFAULT 0,
  auto_reply_credit_payment TEXT,
  auto_reply_bank_payment TEXT,
  auto_reply_convenience_payment TEXT,
  auto_reply_credit_cancel TEXT,
  auto_reply_bank_cancel TEXT,
  auto_reply_convenience_cancel TEXT,
  auto_reply_credit_refund TEXT,
  auto_reply_bank_deposit TEXT,
  auto_reply_bank_refund TEXT,
  auto_reply_convenience_deposit TEXT,
  auto_reply_convenience_refund TEXT,
  
  
  auto_reply_credit_payment_en TEXT,
  auto_reply_bank_payment_en TEXT,
  auto_reply_convenience_payment_en TEXT,
  auto_reply_credit_cancel_en TEXT,
  auto_reply_bank_cancel_en TEXT,
  auto_reply_convenience_cancel_en TEXT,
  auto_reply_credit_refund_en TEXT,
  auto_reply_bank_deposit_en TEXT,
  auto_reply_bank_refund_en TEXT,
  auto_reply_convenience_deposit_en TEXT,
  auto_reply_convenience_refund_en TEXT,
  
  
  parent_event_id INTEGER,
  event_type TEXT DEFAULT 'standalone',
  
  
  payment_credit_card INTEGER DEFAULT 0,
  payment_bank_transfer INTEGER DEFAULT 0,
  payment_convenience_store INTEGER DEFAULT 0,
  
  
  cancel_policy TEXT,
  cancellation_policy_details TEXT,
  cancellation_days_1 INTEGER,
  cancellation_rate_1 INTEGER,
  cancellation_days_2 INTEGER,
  cancellation_rate_2 INTEGER,
  cancellation_days_3 INTEGER,
  cancellation_rate_3 INTEGER, image_url TEXT,
  
  FOREIGN KEY (client_id) REFERENCES clients(id)
);

INSERT INTO "events" VALUES (1,'富士山登山ツアー2026夏','日本最高峰・富士山（標高3,776m）への登頂を目指す1泊2日のツアーです。
経験豊富なガイドが同行し、初心者の方でも安心してご参加いただけます。
山小屋での宿泊、往復バス、登山保険が含まれています。

【スケジュール】
1日目：新宿集合 → バスで富士山五合目へ → 登山開始 → 山小屋泊
2日目：早朝出発 → 山頂でご来光 → 下山 → 温泉入浴 → 新宿解散

【含まれるもの】
- 往復バス代
- ガイド料
- 山小屋宿泊費（1泊2食付）
- 登山保険
- 温泉入浴券','京王グループツアーズ
TEL: 03-1111-2222
Email: yamada@keio-tours.co.jp
受付時間: 平日9:00-18:00','登山経験のある方のご参加を推奨します。
高山病のリスクがありますので、体調管理に十分ご注意ください。','登山経験はありますか？（初めて・1-2回・3回以上）
登山靴はお持ちですか？（持っている・レンタル希望）
食物アレルギーはありますか？',0,'この度は富士山登山ツアーにお申込みいただき、誠にありがとうございます。
日本最高峰の絶景を、安全に楽しんでいただけるよう全力でサポートいたします。
当日お会いできることを楽しみにしております。','悪天候時は中止または日程変更となります。
装備リストは別途お送りします。',1,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',1,NULL,'fujisan-2026-summer','登山・トレッキング',NULL,'single','山梨県富士吉田市 富士山','credit,bank,convenience','percentage','customer','fixed','2026-03-01','2026-07-31','2026-08-01','2026-08-31','yamada@keio-tours.co.jp','山田太郎',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-15','2026-09-30',NULL,'京王グループツアーズ','info@keio-tours.co.jp','━━━━━━━━━━━━━━━━━━━━
京王グループツアーズ
〒160-0023 東京都新宿区西新宿1-10-1
TEL: 03-1111-2222 / FAX: 03-1111-2223
Email: info@keio-tours.co.jp
━━━━━━━━━━━━━━━━━━━━','KEIO GROUP TOURS
1-10-1 Nishi-Shinjuku, Shinjuku-ku, Tokyo
TEL: +81-3-1111-2222
Email: info@keio-tours.co.jp','みずほ銀行','新宿支店','普通','1234567','ケイオウグループツアーズ',7,'KEIO001',7,'["セブンイレブン","ファミリーマート","ローソン"]',3.5,0,0.0,330,0.0,330,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":true,"age":false}',1,'ご予約ありがとうございます。
決済が完了次第、詳細な行程表と装備リストをお送りいたします。','ご予約ありがとうございます。
お振込確認後、詳細な行程表と装備リストをお送りいたします。
振込期限: お申込みから7日以内',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,1,NULL,'■キャンセル料について
出発日の21日前まで：無料
20日前～8日前：旅行代金の20%
7日前～2日前：旅行代金の30%
前日：旅行代金の40%
当日・無連絡不参加：旅行代金の100%',21,0,8,20,2,30,NULL);
INSERT INTO "events" VALUES (2,'箱根温泉リゾート 春の特別プラン','春の箱根を満喫する2泊3日の温泉リゾートステイ。
名湯として知られる箱根温泉で、日頃の疲れを癒しませんか？

【プランの特徴】
- 源泉かけ流しの露天風呂付き客室
- 地元食材を使った懐石料理（夕朝食付）
- 箱根美術館入館券付き
- 箱根登山鉄道フリーパス付き

【おすすめポイント】
春の箱根は桜や新緑が美しく、気候も穏やかで観光に最適です。
芦ノ湖遊覧、大涌谷見学など周辺観光も充実しています。','箱根温泉旅館組合
TEL: 0460-4444-5555
Email: tanaka@hakone-onsen.or.jp
受付時間: 9:00-18:00','お子様連れ歓迎。お部屋タイプは予約時にご相談ください。',NULL,0,'箱根温泉リゾートへようこそ。
ごゆっくりお寛ぎいただき、心身ともにリフレッシュしていただければ幸いです。
スタッフ一同、心よりお待ちしております。','土日祝日は混雑が予想されます。平日のご利用をおすすめします。',2,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',2,NULL,'hakone-spring-2026','温泉・宿泊',NULL,'single','神奈川県足柄下郡箱根町','credit,bank','percentage','customer',NULL,'2026-01-15','2026-04-30','2026-04-01','2026-05-31','tanaka@hakone-onsen.or.jp','田中温子',NULL,NULL,NULL,NULL,NULL,NULL,4,'2026-01-10','2026-06-30',NULL,'箱根温泉旅館組合','info@hakone-onsen.or.jp','━━━━━━━━━━━━━━━━━━━━
箱根温泉旅館組合
〒250-0311 神奈川県足柄下郡箱根町湯本茶屋6-6-6
TEL: 0460-4444-5555
Email: info@hakone-onsen.or.jp
━━━━━━━━━━━━━━━━━━━━',NULL,'横浜銀行','箱根支店','普通','2345678','ハコネオンセンリョカンクミアイ',10,NULL,NULL,NULL,3.0,NULL,0.0,330,NULL,NULL,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}',1,'ご予約ありがとうございます。
チェックイン時間は15:00以降、チェックアウトは10:00までとなります。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,0,NULL,'■キャンセル料について
宿泊日の14日前まで：無料
13日前～7日前：宿泊料金の20%
6日前～2日前：宿泊料金の30%
前日：宿泊料金の50%
当日・無連絡不参加：宿泊料金の100%',14,0,7,20,NULL,NULL,NULL);
INSERT INTO "events" VALUES (3,'東京1日観光ツアー 英語ガイド付き','英語ガイド付きで巡る東京の名所を巡る1日ツアー。
外国人観光客にも大人気のコースです。

【訪問先】
- 浅草寺（雷門、仲見世通り散策）
- スカイツリー（展望台入場）
- 皇居外苑（二重橋見学）
- 明治神宮
- 原宿・竹下通り散策
- 渋谷スクランブル交差点

【含まれるもの】
- 英語ガイド
- 貸切バス代
- スカイツリー展望台入場料
- 昼食（日本料理）','東京シティガイド協会
TEL: 03-5555-6666
Email: johnson@tokyo-guide.org
Hours: 9:00-17:00','英語対応可能。日本語ガイドをご希望の場合はお問い合わせください。',NULL,0,'Thank you for booking Tokyo City Tour!
We look forward to showing you the best of Tokyo.',NULL,3,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-18 08:48:44',NULL,NULL,'tokyo-city-tour-2026',NULL,NULL,'button','東京都内各所','0.0','percentage','fixed','fixed','2026-01-01T00:00','2026-12-31T00:00','2026-01-01','2026-12-31','johnson@tokyo-guide.org',NULL,'Tokyo City Tour with English Guide','Full-day sightseeing tour of Tokyo with professional English-speaking guide.

Highlights:
- Sensoji Temple (Asakusa)
- Tokyo Skytree Observatory
- Imperial Palace East Gardens
- Meiji Shrine
- Harajuku & Shibuya

Includes:
- English-speaking guide
- Private coach
- Skytree admission
- Japanese lunch','Tokyo Metropolitan Area',NULL,NULL,NULL,5,NULL,NULL,NULL,'Tokyo City Guide','info@tokyo-guide.org','━━━━━━━━━━━━━━━━━━━━
東京シティガイド協会
〒100-0005 東京都千代田区丸の内1-7-7
TEL: 03-5555-6666
Email: info@tokyo-guide.org
━━━━━━━━━━━━━━━━━━━━','Tokyo City Guide Association
1-7-7 Marunouchi, Chiyoda-ku, Tokyo
TEL: +81-3-5555-6666
Email: info@tokyo-guide.org','三菱UFJ銀行','東京営業部','普通','3456789','トウキョウシティガイドキョウカイ',5,NULL,7,'seven_eleven,family_mart,lawson',3.5,0,0.0,330,0.0,330,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'https://placehold.co/1920x600/1e40af/ffffff?text=Tokyo+City+Tour');
INSERT INTO "events" VALUES (4,'多摩丘陵サイクリング 紅葉満喫コース','秋の多摩丘陵を自転車で巡る日帰りツアー。
紅葉の名所を訪れながら、地元グルメも楽しめます。

【コース概要】
立川駅集合 → 昭和記念公園（銀杏並木）→ 多摩湖サイクリングロード → 
野山北公園（昼食）→ 狭山丘陵（トトロの森）→ 立川駅解散

【距離】約30km（初心者でも走りやすいコース）
【所要時間】約6時間（休憩含む）

【含まれるもの】
- スポーツサイクルレンタル（電動アシスト可）
- ヘルメット、グローブレンタル
- サイクリングガイド
- 昼食（地元食材を使ったお弁当）
- 保険
- ドリンク','多摩地域観光推進協議会
TEL: 042-2222-3333
Email: sato@tama-tourism.jp
受付時間: 平日9:00-17:00','自転車に乗れる方が対象です。
雨天の場合は中止となり、全額返金いたします。',NULL,0,'多摩丘陵の美しい紅葉と、地域の魅力をお楽しみください。
安全運転で、気持ちの良いサイクリングをお楽しみいただけます。','電動アシスト自転車をご希望の方は予約時にお申し出ください（追加料金なし）。',4,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',4,NULL,'tama-cycling-autumn-2026','サイクリング・アウトドア',NULL,'single','東京都立川市・武蔵村山市周辺','credit,bank','percentage','customer',NULL,'2026-08-01','2026-10-31','2026-10-15','2026-11-30','sato@tama-tourism.jp','佐藤花子',NULL,NULL,NULL,NULL,NULL,NULL,2,'2026-07-01','2026-12-31',NULL,'多摩地域観光推進協議会','info@tama-tourism.jp','━━━━━━━━━━━━━━━━━━━━
多摩地域観光推進協議会
〒190-0012 東京都立川市曙町2-1-1
TEL: 042-2222-3333
Email: info@tama-tourism.jp
━━━━━━━━━━━━━━━━━━━━',NULL,'きらぼし銀行','立川支店','普通','4567890','タマチイキカンコウスイシンキョウギカイ',7,NULL,NULL,NULL,3.5,NULL,NULL,330,NULL,NULL,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":false,"tel":true,"birth_date":true,"age":false}',1,'ご予約ありがとうございます。
当日は動きやすい服装と、タオル・飲み物をお持ちください。','ご予約ありがとうございます。
お振込確認後、集合場所の詳細地図をお送りいたします。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,0,NULL,'■キャンセル料について
実施日の7日前まで：無料
6日前～3日前：参加費の30%
2日前～前日：参加費の50%
当日・無連絡不参加：参加費の100%',7,0,3,30,NULL,NULL,NULL);
INSERT INTO "events" VALUES (5,'里山エコツーリズム 自然体験プログラム','都心から1時間、里山で自然とふれあう1日体験プログラム。
環境保護と観光を両立させたエコツーリズムの入門編です。

【プログラム内容】
午前：
- 里山ガイドウォーク（約2時間）
- 野鳥観察体験
- 森林セラピー

午後：
- 農業体験（季節の野菜収穫）
- 地元食材を使った昼食作り
- 環境保全ワークショップ

【学べること】
- 里山の生態系
- 持続可能な観光のあり方
- 地域資源の活用方法
- 生物多様性の重要性

【対象】
小学生から大人まで。ファミリーでの参加も大歓迎です。','エコツーリズム推進協議会
TEL: 03-5678-9012
Email: nakamura@eco-tourism.jp
受付時間: 平日9:00-17:00','小学生以下のお子様は保護者同伴でご参加ください。
汚れてもよい服装、長靴または運動靴でお越しください。',NULL,0,'エコツーリズム体験プログラムへようこそ。
自然との共生、持続可能な社会について、楽しく学んでいただけます。
皆様のご参加を心よりお待ちしております。','悪天候時は屋内プログラムに変更します（中止の場合は全額返金）。
季節によって体験内容が異なります。',5,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',5,NULL,'eco-tourism-2026','エコツアー・体験',NULL,'single','東京都・埼玉県 里山エリア','credit,bank,convenience','percentage','customer','fixed','2026-02-01','2026-09-30','2026-04-01','2026-10-31','nakamura@eco-tourism.jp','中村環',NULL,NULL,NULL,NULL,NULL,NULL,2,'2026-01-15','2026-11-30',NULL,'エコツーリズム推進協議会','info@eco-tourism.jp','━━━━━━━━━━━━━━━━━━━━
エコツーリズム推進協議会
〒102-0072 東京都千代田区飯田橋4-4-4
TEL: 03-5678-9012
Email: info@eco-tourism.jp
━━━━━━━━━━━━━━━━━━━━',NULL,'三井住友銀行','飯田橋支店','普通','5678901','エコツーリズムスイシンキョウギカイ',7,'ECO001',7,'["セブンイレブン","ファミリーマート","ローソン"]',3.0,NULL,NULL,330,NULL,330,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":true,"age":true}',1,'ご予約ありがとうございます。
当日は汚れてもよい服装と、タオル・着替えをお持ちください。
集合場所は事前にメールでお知らせいたします。','ご予約ありがとうございます。
お振込確認後、詳細な行程表と持ち物リストをお送りいたします。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,1,NULL,'■キャンセル料について
実施日の14日前まで：無料
13日前～7日前：参加費の20%
6日前～3日前：参加費の30%
2日前～前日：参加費の50%
当日・無連絡不参加：参加費の100%',14,0,7,20,3,30,NULL);


-- Table: gmo_payment_logs
CREATE TABLE gmo_payment_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  
  
  event_type TEXT NOT NULL,                    
  
  
  gmo_order_id TEXT,
  gmo_transaction_id TEXT,
  gmo_status TEXT,                             
  
  
  request_params TEXT,
  response_params TEXT,
  
  
  error_code TEXT,
  error_message TEXT,
  
  
  ip_address TEXT,
  user_agent TEXT,
  
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);


-- Table: members
CREATE TABLE members (
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
, email_verified INTEGER DEFAULT 0, last_login_at DATETIME);

INSERT INTO "members" VALUES (1,'yamada.taro@example.com','$2a$10$XYZ...','山田','太郎','ヤマダ','タロウ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'03-1234-5678',1,'2026-02-15 10:00:00','2026-02-15 10:00:00','090-1234-5678',0,NULL);
INSERT INTO "members" VALUES (2,'suzuki.hanako@example.com','$2a$10$ABC...','鈴木','花子','スズキ','ハナコ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'03-2345-6789',1,'2026-02-16 10:00:00','2026-02-16 10:00:00','090-2345-6789',0,NULL);
INSERT INTO "members" VALUES (3,'tanaka.ichiro@example.com','$2a$10$DEF...','田中','一郎','タナカ','イチロウ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'03-3456-7890',1,'2026-02-17 10:00:00','2026-02-17 10:00:00','090-3456-7890',0,NULL);
INSERT INTO "members" VALUES (4,'watanabe.yuki@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','渡辺','優希','ワタナベ','ユウキ','Watanabe','Yuki','女性','1995-03-10','190-0012',13,'立川市曙町4-4-4 コーポD 404','042-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-4567-8901',0,NULL);
INSERT INTO "members" VALUES (5,'ito.kenji@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','伊藤','健二','イトウ','ケンジ','Ito','Kenji','男性','1982-07-25','105-0001',13,'港区虎ノ門5-5-5 タワーE 505','03-4567-8901',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-5678-9012',0,NULL);
INSERT INTO "members" VALUES (6,'kobayashi.ai@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','小林','愛','コバヤシ','アイ','Kobayashi','Ai','女性','1988-11-30','102-0072',13,'千代田区飯田橋6-6-6 マンションF 606','03-5678-9012',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-6789-0123',0,NULL);
INSERT INTO "members" VALUES (7,'sato.makoto@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','佐藤','誠','サトウ','マコト','Sato','Makoto','男性','1975-02-18','250-0311',14,'足柄下郡箱根町湯本7-7-7','0460-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-7890-1234',0,NULL);
INSERT INTO "members" VALUES (8,'takahashi.misa@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','高橋','美咲','タカハシ','ミサ','Takahashi','Misa','女性','1992-06-12','403-0005',19,'富士吉田市上吉田8-8-8','0555-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-8901-2345',0,NULL);
INSERT INTO "members" VALUES (9,'nakamura.jun@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','中村','潤','ナカムラ','ジュン','Nakamura','Jun','男性','1987-09-08','180-0004',13,'武蔵野市吉祥寺本町9-9-9','0422-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-9012-3456',0,NULL);
INSERT INTO "members" VALUES (10,'yamamoto.yui@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','山本','結衣','ヤマモト','ユイ','Yamamoto','Yui','女性','1998-01-22','183-0055',13,'府中市府中町10-10-10','042-2345-6789',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-0123-4567',0,NULL);


-- Table: option_bookings
CREATE TABLE option_bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  option_id INTEGER NOT NULL,
  option_stock_id INTEGER,
  price INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (option_stock_id) REFERENCES option_stocks(id)
);


-- Table: option_categories
CREATE TABLE option_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);


-- Table: option_forms
CREATE TABLE option_forms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  form_type INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);


-- Table: option_inherited_products
CREATE TABLE option_inherited_products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);


-- Table: option_prices
CREATE TABLE option_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);


-- Table: option_shared_stock_pools
CREATE TABLE option_shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pool_name TEXT NOT NULL,
  total_stock INTEGER DEFAULT 0,
  booked INTEGER DEFAULT 0,
  available INTEGER DEFAULT 0,
  event_id INTEGER,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);


-- Table: option_stocks
CREATE TABLE option_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  date TEXT,
  stock INTEGER NOT NULL DEFAULT 0,
  booked INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  stock_name TEXT,
  price INTEGER,
  total_stock INTEGER DEFAULT 0,
  available_stock INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  shared_pool_id INTEGER,
  FOREIGN KEY (option_id) REFERENCES options(id)
);


-- Table: options
CREATE TABLE options (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  remarks TEXT,
  option_category_id INTEGER NOT NULL,
  cancel_policy TEXT,
  note TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  deleted_at TEXT, image_url TEXT,
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (option_category_id) REFERENCES option_categories(id)
);


-- Table: organizers
CREATE TABLE organizers (
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

INSERT INTO "organizers" VALUES (1,'京王グループツアーズ','山田太郎','yamada@keio-tours.co.jp','03-1111-2222','新宿本社',1,NULL,'160-0023',13,'新宿区西新宿1-10-1','03-1111-2223',NULL,'平日9:00-18:00','土日祝','各種ツアー企画・運営','T-001-12345','日本旅行業協会','JATA会員','旅行業務取扱管理者','山田太郎','メイン主催者','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "organizers" VALUES (2,'多摩地域観光推進協議会','佐藤花子','sato@tama-tourism.jp','042-2222-3333','立川事務所',1,NULL,'190-0012',13,'立川市曙町2-1-1','042-2222-3334',NULL,'平日9:00-17:00','土日祝','多摩地域の観光振興','T-002-23456','多摩観光連盟','理事会員','事務局長','佐藤花子','地域密着型','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "organizers" VALUES (3,'富士山ネイチャーツアーズ','鈴木登','suzuki@fujisan-nature.jp','0555-3333-4444','富士吉田営業所',1,NULL,'403-0005',19,'富士吉田市上吉田5-5-5','0555-3333-4445',NULL,'8:00-19:00','不定休','富士山周辺ツアー専門','T-003-34567','山梨県旅行業協会','正会員','総合旅行業務取扱管理者','鈴木登','富士山エリア専門','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "organizers" VALUES (4,'箱根温泉旅館組合','田中温子','tanaka@hakone-onsen.or.jp','0460-4444-5555','箱根湯本事務局',1,NULL,'250-0311',14,'足柄下郡箱根町湯本茶屋6-6-6','0460-4444-5556',NULL,'9:00-18:00','年末年始','箱根温泉地域の観光振興','T-004-45678','箱根観光協会','組合員','組合長','田中温子','温泉旅館組合','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "organizers" VALUES (5,'東京シティガイド協会','Emily Johnson','johnson@tokyo-guide.org','03-5555-6666','東京支部',1,NULL,'100-0005',13,'千代田区丸の内1-7-7','03-5555-6667',NULL,'9:00-17:00','土日祝','東京観光ガイド事業','T-005-56789','全国通訳案内士協会','認定団体','Director','Emily Johnson','英語ガイド専門','2026-02-12 07:16:29','2026-02-12 07:16:29');


-- Table: otp_tokens
CREATE TABLE otp_tokens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  
  email TEXT NOT NULL,
  otp_code TEXT NOT NULL,
  
  expires_at DATETIME NOT NULL,
  used_at DATETIME,
  
  session_token TEXT UNIQUE,
  
  ip_address TEXT,
  user_agent TEXT,
  attempts INTEGER DEFAULT 0,
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: prefs
CREATE TABLE prefs (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

INSERT INTO "prefs" VALUES (1,'北海道');
INSERT INTO "prefs" VALUES (2,'青森県');
INSERT INTO "prefs" VALUES (3,'岩手県');
INSERT INTO "prefs" VALUES (4,'宮城県');
INSERT INTO "prefs" VALUES (5,'秋田県');
INSERT INTO "prefs" VALUES (6,'山形県');
INSERT INTO "prefs" VALUES (7,'福島県');
INSERT INTO "prefs" VALUES (8,'茨城県');
INSERT INTO "prefs" VALUES (9,'栃木県');
INSERT INTO "prefs" VALUES (10,'群馬県');
INSERT INTO "prefs" VALUES (11,'埼玉県');
INSERT INTO "prefs" VALUES (12,'千葉県');
INSERT INTO "prefs" VALUES (13,'東京都');
INSERT INTO "prefs" VALUES (14,'神奈川県');
INSERT INTO "prefs" VALUES (15,'新潟県');
INSERT INTO "prefs" VALUES (16,'富山県');
INSERT INTO "prefs" VALUES (17,'石川県');
INSERT INTO "prefs" VALUES (18,'福井県');
INSERT INTO "prefs" VALUES (19,'山梨県');
INSERT INTO "prefs" VALUES (20,'長野県');
INSERT INTO "prefs" VALUES (21,'岐阜県');
INSERT INTO "prefs" VALUES (22,'静岡県');
INSERT INTO "prefs" VALUES (23,'愛知県');
INSERT INTO "prefs" VALUES (24,'三重県');
INSERT INTO "prefs" VALUES (25,'滋賀県');
INSERT INTO "prefs" VALUES (26,'京都府');
INSERT INTO "prefs" VALUES (27,'大阪府');
INSERT INTO "prefs" VALUES (28,'兵庫県');
INSERT INTO "prefs" VALUES (29,'奈良県');
INSERT INTO "prefs" VALUES (30,'和歌山県');
INSERT INTO "prefs" VALUES (31,'鳥取県');
INSERT INTO "prefs" VALUES (32,'島根県');
INSERT INTO "prefs" VALUES (33,'岡山県');
INSERT INTO "prefs" VALUES (34,'広島県');
INSERT INTO "prefs" VALUES (35,'山口県');
INSERT INTO "prefs" VALUES (36,'徳島県');
INSERT INTO "prefs" VALUES (37,'香川県');
INSERT INTO "prefs" VALUES (38,'愛媛県');
INSERT INTO "prefs" VALUES (39,'高知県');
INSERT INTO "prefs" VALUES (40,'福岡県');
INSERT INTO "prefs" VALUES (41,'佐賀県');
INSERT INTO "prefs" VALUES (42,'長崎県');
INSERT INTO "prefs" VALUES (43,'熊本県');
INSERT INTO "prefs" VALUES (44,'大分県');
INSERT INTO "prefs" VALUES (45,'宮崎県');
INSERT INTO "prefs" VALUES (46,'鹿児島県');
INSERT INTO "prefs" VALUES (47,'沖縄県');


-- Table: product_bookings
CREATE TABLE product_bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT,
  customer_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  product_stock_id INTEGER,
  price INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  booking_status TEXT DEFAULT 'reserved',
  payment_status TEXT DEFAULT 'pending',
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,
  qr_code_url TEXT,
  pdf_file_url TEXT,
  price_items TEXT,
  remarks TEXT,
  participants TEXT,
  participation_date TEXT,
  payment_method TEXT,
  payment_date TEXT,
  payment_transaction_id TEXT,
  bank_transfer_info TEXT,
  convenience_store_info TEXT,
  survey_answers TEXT,
  organizer_id INTEGER,
  vendor_id INTEGER,
  branch_code TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (product_stock_id) REFERENCES product_stocks(id)
);


-- Table: product_categories
CREATE TABLE product_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);


-- Table: product_form_fields
CREATE TABLE product_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  field_type TEXT NOT NULL,
  field_name TEXT NOT NULL,
  field_label TEXT NOT NULL,
  field_options TEXT,
  is_required INTEGER DEFAULT 0,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  placeholder TEXT,
  parent_field_id INTEGER,
  parent_condition TEXT,
  indent_level INTEGER DEFAULT 0,
  validation_rule TEXT,
  default_value TEXT,
  help_text TEXT,
  created_at TEXT DEFAULT (datetime('now','localtime')),
  modified_at TEXT DEFAULT (datetime('now','localtime')),
  category INTEGER DEFAULT 1
);

INSERT INTO "product_form_fields" VALUES (1,1,'radio','dietary_restrictions','Dietary Restrictions / 食事制限','["No restrictions / なし","Vegetarian / ベジタリアン","Vegan / ヴィーガン","Halal / ハラル","Gluten-free / グルテンフリー","Other / その他"]',0,'Please let us know if you have any dietary restrictions',1,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO "product_form_fields" VALUES (2,1,'textarea','special_requests','Special Requests / 特別なご要望',NULL,0,'Any special requests or requirements',2,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO "product_form_fields" VALUES (3,1,'text','hotel_name','Hotel Name (if pickup needed) / ホテル名（送迎希望の場合）',NULL,0,'If you need hotel pickup, please provide your hotel name',3,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO "product_form_fields" VALUES (4,2,'radio','dietary_restrictions','Dietary Restrictions / 食事制限','["No restrictions / なし","Vegetarian / ベジタリアン","Vegan / ヴィーガン","Halal / ハラル","Gluten-free / グルテンフリー","Other / その他"]',0,'Please let us know if you have any dietary restrictions',0,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 09:20:14',2);
INSERT INTO "product_form_fields" VALUES (5,2,'textarea','special_requests','Special Requests / 特別なご要望',NULL,0,'Any special requests or requirements',1,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 09:20:14',2);
INSERT INTO "product_form_fields" VALUES (6,2,'text','hotel_name','Hotel Name (if pickup needed) / ホテル名（送迎希望の場合）',NULL,0,'If you need hotel pickup, please provide your hotel name',2,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 09:20:14',2);
INSERT INTO "product_form_fields" VALUES (7,3,'textarea','preferred_destinations','Preferred Destinations / 希望訪問先',NULL,1,'Please list the places you would like to visit',1,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO "product_form_fields" VALUES (8,3,'text','preferred_start_time','Preferred Start Time / 希望開始時刻',NULL,0,'What time would you like to start? (e.g., 09:00)',2,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO "product_form_fields" VALUES (9,3,'radio','dietary_restrictions','Dietary Restrictions / 食事制限','["No restrictions / なし","Vegetarian / ベジタリアン","Vegan / ヴィーガン","Halal / ハラル","Gluten-free / グルテンフリー","Other / その他"]',0,'Please let us know if you have any dietary restrictions',3,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO "product_form_fields" VALUES (10,3,'textarea','special_requests','Special Requests / 特別なご要望',NULL,0,'Any other special requests or requirements',4,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO "product_form_fields" VALUES (11,3,'text','hotel_name','Hotel Name (for pickup) / ホテル名（送迎用）',NULL,1,'We will pick you up from your hotel',5,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);


-- Table: product_prices
CREATE TABLE product_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  price_band TEXT,
  price_name TEXT,
  display_order INTEGER DEFAULT 0,
  slot_number INTEGER DEFAULT 1,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO "product_prices" VALUES (12,3,10000,'A-名称1','2026-02-12 07:41:18','2026-02-12 07:41:18','A','大人',0,1);
INSERT INTO "product_prices" VALUES (13,3,8000,'A-名称2','2026-02-12 07:41:18','2026-02-12 07:41:18','A','子供',0,2);
INSERT INTO "product_prices" VALUES (14,1,7900,'A-名称1','2026-02-18 08:49:55','2026-02-18 08:49:55','A','大人',0,1);
INSERT INTO "product_prices" VALUES (15,1,4900,'A-名称2','2026-02-18 08:49:55','2026-02-18 08:49:55','A','子供',0,2);
INSERT INTO "product_prices" VALUES (16,1,8900,'B-名称1','2026-02-18 08:49:55','2026-02-18 08:49:55','B','大人',1,1);
INSERT INTO "product_prices" VALUES (17,1,6500,'B-名称2','2026-02-18 08:49:55','2026-02-18 08:49:55','B','子供',1,2);
INSERT INTO "product_prices" VALUES (18,2,6000,'A-名称1','2026-02-18 08:50:55','2026-02-18 08:50:55','A','弁当付き',0,1);
INSERT INTO "product_prices" VALUES (19,2,5000,'A-名称2','2026-02-18 08:50:55','2026-02-18 08:50:55','A','弁当なし',0,2);


-- Table: product_shared_stock_pools
CREATE TABLE product_shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  shared_stock_pool_id INTEGER NOT NULL,
  stock_name TEXT,
  price_band TEXT,
  enable_flg INTEGER DEFAULT 1,
  priority INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (shared_stock_pool_id) REFERENCES shared_stock_pools(id)
);


-- Table: product_stocks
CREATE TABLE product_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  date TEXT NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0,
  booked INTEGER NOT NULL DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  time_slot_start TEXT,
  time_slot_end TEXT,
  time_slot_label TEXT,
  stock_name TEXT,
  shared_pool_id INTEGER,
  price_band TEXT,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO "product_stocks" VALUES (1,1,'2026-01-03',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (2,1,'2026-01-04',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (3,1,'2026-01-10',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (4,1,'2026-01-11',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (5,1,'2026-01-17',20,2,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (6,1,'2026-01-18',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (7,1,'2026-01-24',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (8,1,'2026-01-25',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (9,1,'2026-01-31',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (10,1,'2026-02-01',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (11,1,'2026-02-07',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (12,1,'2026-02-08',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (13,1,'2026-02-14',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (14,1,'2026-02-15',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (15,1,'2026-02-21',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (16,1,'2026-02-22',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (17,1,'2026-02-28',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (18,1,'2026-03-01',20,2,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (19,1,'2026-03-07',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (20,1,'2026-03-08',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (21,1,'2026-03-14',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (22,1,'2026-03-15',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (23,1,'2026-03-21',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (24,1,'2026-03-22',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (25,1,'2026-03-28',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (26,1,'2026-03-29',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (27,1,'2026-04-04',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (28,1,'2026-04-05',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (29,1,'2026-04-11',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (30,1,'2026-04-12',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (31,1,'2026-04-18',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (32,1,'2026-04-19',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (33,1,'2026-04-25',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (34,1,'2026-04-26',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (35,2,'2026-01-03',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (36,2,'2026-01-04',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (37,2,'2026-01-10',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (38,2,'2026-01-11',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (39,2,'2026-01-17',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (40,2,'2026-01-18',12,1,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (41,2,'2026-01-24',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (42,2,'2026-01-25',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (43,2,'2026-01-31',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (44,2,'2026-02-01',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (45,2,'2026-02-07',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (46,2,'2026-02-08',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (47,2,'2026-02-14',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (48,2,'2026-02-15',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (49,2,'2026-02-21',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (50,2,'2026-02-22',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (51,2,'2026-02-28',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (52,2,'2026-03-01',12,1,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (53,2,'2026-03-07',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (54,2,'2026-03-08',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (55,2,'2026-03-14',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (56,2,'2026-03-15',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (57,2,'2026-03-21',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (58,2,'2026-03-22',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (59,2,'2026-03-28',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (60,2,'2026-03-29',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (61,2,'2026-04-04',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (62,2,'2026-04-05',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (63,2,'2026-04-11',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (64,2,'2026-04-12',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (65,2,'2026-04-18',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (66,2,'2026-04-19',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (67,2,'2026-04-25',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (68,2,'2026-04-26',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (69,3,'2026-01-05',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (70,3,'2026-01-12',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (71,3,'2026-01-19',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (72,3,'2026-01-26',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (73,3,'2026-02-02',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (74,3,'2026-02-09',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (75,3,'2026-02-16',3,0,'2026-02-12 07:32:20','2026-02-12 07:50:30',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (76,3,'2026-02-23',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (77,3,'2026-03-02',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (78,3,'2026-03-09',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (79,3,'2026-03-16',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (80,3,'2026-03-23',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (81,3,'2026-03-30',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (82,3,'2026-04-06',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (83,3,'2026-04-13',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (84,3,'2026-04-20',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (85,3,'2026-04-27',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_stocks" VALUES (86,3,'2026-02-14',10,0,'2026-02-12 07:50:46','2026-02-12 07:50:46',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (87,1,'2026-02-18',11,0,'2026-02-18 08:51:38','2026-02-18 08:51:38',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (88,1,'2026-02-19',11,0,'2026-02-18 08:51:38','2026-02-18 08:51:38',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (89,1,'2026-02-20',11,0,'2026-02-18 08:51:38','2026-02-18 08:51:38',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (90,1,'2026-02-21',11,0,'2026-02-18 08:51:39','2026-02-18 08:51:39',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (91,1,'2026-02-22',11,0,'2026-02-18 08:51:39','2026-02-18 08:51:39',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (92,1,'2026-02-23',11,0,'2026-02-18 08:51:39','2026-02-18 08:51:39',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (93,1,'2026-02-24',11,0,'2026-02-18 08:51:39','2026-02-18 08:51:39',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (94,1,'2026-02-25',11,0,'2026-02-18 08:51:40','2026-02-18 08:51:40',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (95,1,'2026-02-26',11,0,'2026-02-18 08:51:40','2026-02-18 08:51:40',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (96,1,'2026-02-27',11,0,'2026-02-18 08:51:40','2026-02-18 08:51:40',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (97,1,'2026-02-28',11,0,'2026-02-18 08:51:40','2026-02-18 08:51:40',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (98,1,'2026-03-01',11,0,'2026-02-18 08:51:41','2026-02-18 08:51:41',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (99,1,'2026-03-02',11,0,'2026-02-18 08:51:41','2026-02-18 08:51:41',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (100,1,'2026-03-03',11,0,'2026-02-18 08:51:41','2026-02-18 08:51:41',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (101,1,'2026-03-04',11,0,'2026-02-18 08:51:41','2026-02-18 08:51:41',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (102,1,'2026-03-05',11,0,'2026-02-18 08:51:42','2026-02-18 08:51:42',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (103,1,'2026-03-06',11,0,'2026-02-18 08:51:42','2026-02-18 08:51:42',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (104,1,'2026-03-07',11,0,'2026-02-18 08:51:42','2026-02-18 08:51:42',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (105,1,'2026-03-08',11,0,'2026-02-18 08:51:42','2026-02-18 08:51:42',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (106,1,'2026-03-09',11,0,'2026-02-18 08:51:42','2026-02-18 08:51:42',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (107,1,'2026-03-10',11,0,'2026-02-18 08:51:43','2026-02-18 08:51:43',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (108,1,'2026-03-11',11,0,'2026-02-18 08:51:43','2026-02-18 08:51:43',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (109,1,'2026-03-12',11,0,'2026-02-18 08:51:43','2026-02-18 08:51:43',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (110,1,'2026-03-13',11,0,'2026-02-18 08:51:43','2026-02-18 08:51:43',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (111,1,'2026-03-14',11,0,'2026-02-18 08:51:44','2026-02-18 08:51:44',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (112,1,'2026-03-15',11,0,'2026-02-18 08:51:44','2026-02-18 08:51:44',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (113,1,'2026-03-16',11,0,'2026-02-18 08:51:44','2026-02-18 08:51:44',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (114,1,'2026-03-17',11,0,'2026-02-18 08:51:44','2026-02-18 08:51:44',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (115,1,'2026-03-18',11,0,'2026-02-18 08:51:45','2026-02-18 08:51:45',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (116,1,'2026-03-19',11,0,'2026-02-18 08:51:45','2026-02-18 08:51:45',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (117,1,'2026-03-20',11,0,'2026-02-18 08:51:45','2026-02-18 08:51:45',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (118,1,'2026-03-21',11,0,'2026-02-18 08:51:45','2026-02-18 08:51:45',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (119,1,'2026-03-22',11,0,'2026-02-18 08:51:46','2026-02-18 08:51:46',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (120,1,'2026-03-23',11,0,'2026-02-18 08:51:46','2026-02-18 08:51:46',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (121,1,'2026-03-24',11,0,'2026-02-18 08:51:46','2026-02-18 08:51:46',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (122,1,'2026-03-25',11,0,'2026-02-18 08:51:46','2026-02-18 08:51:46',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (123,1,'2026-03-26',11,0,'2026-02-18 08:51:47','2026-02-18 08:51:47',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (124,1,'2026-03-27',11,0,'2026-02-18 08:51:47','2026-02-18 08:51:47',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (125,1,'2026-03-28',11,0,'2026-02-18 08:51:47','2026-02-18 08:51:47',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (126,1,'2026-03-29',11,0,'2026-02-18 08:51:47','2026-02-18 08:51:47',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (127,1,'2026-03-30',11,0,'2026-02-18 08:51:47','2026-02-18 08:51:47',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (128,1,'2026-03-31',11,0,'2026-02-18 08:51:48','2026-02-18 08:51:48',NULL,NULL,NULL,'午前',NULL,'A');
INSERT INTO "product_stocks" VALUES (129,1,'2026-02-18',22,0,'2026-02-18 08:52:07','2026-02-18 08:52:07',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (130,1,'2026-02-19',22,0,'2026-02-18 08:52:07','2026-02-18 08:52:07',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (131,1,'2026-02-20',22,0,'2026-02-18 08:52:08','2026-02-18 08:52:08',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (132,1,'2026-02-21',22,0,'2026-02-18 08:52:08','2026-02-18 08:52:08',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (133,1,'2026-02-22',22,0,'2026-02-18 08:52:08','2026-02-18 08:52:08',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (134,1,'2026-02-23',22,0,'2026-02-18 08:52:08','2026-02-18 08:52:08',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (135,1,'2026-02-24',22,0,'2026-02-18 08:52:09','2026-02-18 08:52:09',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (136,1,'2026-02-25',22,0,'2026-02-18 08:52:09','2026-02-18 08:52:09',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (137,1,'2026-02-26',22,0,'2026-02-18 08:52:09','2026-02-18 08:52:09',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (138,1,'2026-02-27',22,0,'2026-02-18 08:52:09','2026-02-18 08:52:09',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (139,1,'2026-02-28',22,0,'2026-02-18 08:52:09','2026-02-18 08:52:09',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (140,1,'2026-03-01',22,0,'2026-02-18 08:52:10','2026-02-18 08:52:10',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (141,1,'2026-03-02',22,0,'2026-02-18 08:52:10','2026-02-18 08:52:10',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (142,1,'2026-03-03',22,0,'2026-02-18 08:52:10','2026-02-18 08:52:10',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (143,1,'2026-03-04',22,0,'2026-02-18 08:52:10','2026-02-18 08:52:10',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (144,1,'2026-03-05',22,0,'2026-02-18 08:52:11','2026-02-18 08:52:11',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (145,1,'2026-03-06',22,0,'2026-02-18 08:52:11','2026-02-18 08:52:11',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (146,1,'2026-03-07',22,0,'2026-02-18 08:52:11','2026-02-18 08:52:11',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (147,1,'2026-03-08',22,0,'2026-02-18 08:52:11','2026-02-18 08:52:11',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (148,1,'2026-03-09',22,0,'2026-02-18 08:52:12','2026-02-18 08:52:12',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (149,1,'2026-03-10',22,0,'2026-02-18 08:52:12','2026-02-18 08:52:12',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (150,1,'2026-03-11',22,0,'2026-02-18 08:52:12','2026-02-18 08:52:12',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (151,1,'2026-03-12',22,0,'2026-02-18 08:52:12','2026-02-18 08:52:12',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (152,1,'2026-03-13',22,0,'2026-02-18 08:52:13','2026-02-18 08:52:13',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (153,1,'2026-03-14',22,0,'2026-02-18 08:52:13','2026-02-18 08:52:13',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (154,1,'2026-03-15',22,0,'2026-02-18 08:52:13','2026-02-18 08:52:13',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (155,1,'2026-03-16',22,0,'2026-02-18 08:52:13','2026-02-18 08:52:13',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (156,1,'2026-03-17',22,0,'2026-02-18 08:52:14','2026-02-18 08:52:14',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (157,1,'2026-03-18',22,0,'2026-02-18 08:52:14','2026-02-18 08:52:14',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (158,1,'2026-03-19',22,0,'2026-02-18 08:52:14','2026-02-18 08:52:14',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (159,1,'2026-03-20',22,0,'2026-02-18 08:52:14','2026-02-18 08:52:14',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (160,1,'2026-03-21',22,0,'2026-02-18 08:52:14','2026-02-18 08:52:14',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (161,1,'2026-03-22',22,0,'2026-02-18 08:52:15','2026-02-18 08:52:15',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (162,1,'2026-03-23',22,0,'2026-02-18 08:52:15','2026-02-18 08:52:15',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (163,1,'2026-03-24',22,0,'2026-02-18 08:52:15','2026-02-18 08:52:15',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (164,1,'2026-03-25',22,0,'2026-02-18 08:52:15','2026-02-18 08:52:15',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (165,1,'2026-03-26',22,0,'2026-02-18 08:52:16','2026-02-18 08:52:16',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (166,1,'2026-03-27',22,0,'2026-02-18 08:52:16','2026-02-18 08:52:16',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (167,1,'2026-03-28',22,0,'2026-02-18 08:52:16','2026-02-18 08:52:16',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (168,1,'2026-03-29',22,0,'2026-02-18 08:52:16','2026-02-18 08:52:16',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (169,1,'2026-03-30',22,0,'2026-02-18 08:52:17','2026-02-18 08:52:17',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (170,1,'2026-03-31',22,0,'2026-02-18 08:52:17','2026-02-18 08:52:17',NULL,NULL,NULL,'午後',NULL,'B');
INSERT INTO "product_stocks" VALUES (171,2,'2026-02-18',50,0,'2026-02-18 08:52:55','2026-02-18 08:52:55',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (172,2,'2026-02-19',50,0,'2026-02-18 08:52:55','2026-02-18 08:52:55',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (173,2,'2026-02-20',50,0,'2026-02-18 08:52:55','2026-02-18 08:52:55',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (174,2,'2026-02-21',50,0,'2026-02-18 08:52:55','2026-02-18 08:52:55',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (175,2,'2026-02-22',50,0,'2026-02-18 08:52:56','2026-02-18 08:52:56',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (176,2,'2026-02-23',50,0,'2026-02-18 08:52:56','2026-02-18 08:52:56',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (177,2,'2026-02-24',50,0,'2026-02-18 08:52:56','2026-02-18 08:52:56',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (178,2,'2026-02-25',50,0,'2026-02-18 08:52:56','2026-02-18 08:52:56',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (179,2,'2026-02-26',50,0,'2026-02-18 08:52:56','2026-02-18 08:52:56',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (180,2,'2026-02-27',50,0,'2026-02-18 08:52:57','2026-02-18 08:52:57',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (181,2,'2026-02-28',50,0,'2026-02-18 08:52:57','2026-02-18 08:52:57',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (182,2,'2026-03-01',50,0,'2026-02-18 08:52:57','2026-02-18 08:52:57',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (183,2,'2026-03-02',50,0,'2026-02-18 08:52:57','2026-02-18 08:52:57',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (184,2,'2026-03-03',50,0,'2026-02-18 08:52:58','2026-02-18 08:52:58',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (185,2,'2026-03-04',50,0,'2026-02-18 08:52:58','2026-02-18 08:52:58',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (186,2,'2026-03-05',50,0,'2026-02-18 08:52:58','2026-02-18 08:52:58',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (187,2,'2026-03-06',50,0,'2026-02-18 08:52:59','2026-02-18 08:52:59',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (188,2,'2026-03-07',50,0,'2026-02-18 08:52:59','2026-02-18 08:52:59',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (189,2,'2026-03-08',50,0,'2026-02-18 08:52:59','2026-02-18 08:52:59',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (190,2,'2026-03-09',50,0,'2026-02-18 08:52:59','2026-02-18 08:52:59',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (191,2,'2026-03-10',50,0,'2026-02-18 08:52:59','2026-02-18 08:52:59',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (192,2,'2026-03-11',50,0,'2026-02-18 08:53:00','2026-02-18 08:53:00',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (193,2,'2026-03-12',50,0,'2026-02-18 08:53:00','2026-02-18 08:53:00',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (194,2,'2026-03-13',50,0,'2026-02-18 08:53:00','2026-02-18 08:53:00',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (195,2,'2026-03-14',50,0,'2026-02-18 08:53:00','2026-02-18 08:53:00',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (196,2,'2026-03-15',50,0,'2026-02-18 08:53:01','2026-02-18 08:53:01',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (197,2,'2026-03-16',50,0,'2026-02-18 08:53:01','2026-02-18 08:53:01',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (198,2,'2026-03-17',50,0,'2026-02-18 08:53:01','2026-02-18 08:53:01',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (199,2,'2026-03-18',50,0,'2026-02-18 08:53:01','2026-02-18 08:53:01',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (200,2,'2026-03-19',50,0,'2026-02-18 08:53:02','2026-02-18 08:53:02',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (201,2,'2026-03-20',50,0,'2026-02-18 08:53:02','2026-02-18 08:53:02',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (202,2,'2026-03-21',50,0,'2026-02-18 08:53:02','2026-02-18 08:53:02',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (203,2,'2026-03-22',50,0,'2026-02-18 08:53:02','2026-02-18 08:53:02',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (204,2,'2026-03-23',50,0,'2026-02-18 08:53:03','2026-02-18 08:53:03',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (205,2,'2026-03-24',50,0,'2026-02-18 08:53:03','2026-02-18 08:53:03',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (206,2,'2026-03-25',50,0,'2026-02-18 08:53:03','2026-02-18 08:53:03',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (207,2,'2026-03-26',50,0,'2026-02-18 08:53:03','2026-02-18 08:53:03',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (208,2,'2026-03-27',50,0,'2026-02-18 08:53:03','2026-02-18 08:53:03',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (209,2,'2026-03-28',50,0,'2026-02-18 08:53:04','2026-02-18 08:53:04',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (210,2,'2026-03-29',50,0,'2026-02-18 08:53:04','2026-02-18 08:53:04',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (211,2,'2026-03-30',50,0,'2026-02-18 08:53:04','2026-02-18 08:53:04',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES (212,2,'2026-03-31',50,0,'2026-02-18 08:53:04','2026-02-18 08:53:04',NULL,NULL,NULL,NULL,NULL,'A');


-- Table: products
CREATE TABLE products (
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
  cancel_policy TEXT,
  purchase_limit INTEGER,
  deposit_address TEXT,
  note TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  slot_type INTEGER DEFAULT 0,
  deleted_at TEXT,
  
  
  cancellation_days_1 INTEGER,
  cancellation_rate_1 INTEGER,
  cancellation_days_2 INTEGER,
  cancellation_rate_2 INTEGER,
  cancellation_days_3 INTEGER,
  cancellation_rate_3 INTEGER,
  cancellation_days_4 INTEGER,
  cancellation_rate_4 INTEGER,
  cancellation_days_5 INTEGER,
  cancellation_rate_5 INTEGER,
  
  common_names TEXT,
  cancellation_policy_details TEXT,
  price_unit TEXT DEFAULT '人',
  charge_type TEXT DEFAULT 'per_person',
  charge_description TEXT,
  form_field_settings TEXT DEFAULT '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}', image_url TEXT,
  
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (product_category_id) REFERENCES product_categories(id)
);

INSERT INTO "products" VALUES (1,3,3,'東京1日観光ツアー スタンダードプラン','2026-01-01T09:00','2026-12-20T09:00',0,NULL,'英語ガイド付きで東京の主要観光スポットを巡る1日ツアーです。
少人数制で快適にご参加いただけます。

【ツアー内容】
- 浅草寺（雷門・仲見世通り）
- スカイツリー展望台（天望デッキ）
- 皇居外苑（二重橋）
- 明治神宮
- 原宿・竹下通り
- 渋谷スクランブル交差点

【スケジュール】
09:00 新宿集合
09:30-11:00 浅草観光
11:30-12:30 スカイツリー
12:30-13:30 ランチ（日本料理）
14:00-14:45 皇居外苑
15:00-15:45 明治神宮
16:00-16:30 原宿散策
16:45-17:15 渋谷散策
17:30 新宿解散','雨天決行。悪天候の場合は一部スケジュールを変更する場合があります。
歩きやすい靴でご参加ください。','・英語ガイド料
・貸切バス代
・スカイツリー展望台入場料（天望デッキ350m）
・ランチ（日本料理コース）
・旅行保険','・天望回廊（450m）追加入場料
・個人的なお買い物代
・飲み物（ランチ時の飲み物は含む）','',20,NULL,'',1,'2026-02-12 07:32:20','2026-02-18 08:49:55',0,NULL,7,0,3,30,2,50,NULL,NULL,NULL,NULL,'[{"name":"大人","description":""},{"name":"子供","description":""}]','[]','人','per_person','1名様あたりの料金','{"lastname_kanji":true,"firstname_kanji":true,"lastname_kana":true,"firstname_kana":true,"lastname_roman":false,"firstname_roman":false,"age":true,"gender":true,"email":false,"phone":false,"birth_date":false,"address":false}','https://placehold.co/400x300/3b82f6/ffffff?text=Standard+Tour');
INSERT INTO "products" VALUES (2,3,3,'東京1日観光ツアー プレミアムプラン','2026-01-01T09:00','2026-12-20T09:00',0,NULL,'スタンダードプランにスカイツリー天望回廊（450m）入場を追加したプレミアムプランです。
より高い場所から東京の絶景をお楽しみいただけます。

【ツアー内容】
スタンダードプランの内容に加えて：
- スカイツリー天望回廊（450m）入場
- プレミアムランチ（特選日本料理コース）
- オリジナルお土産付き

【スケジュール】
09:00 新宿集合
09:30-11:00 浅草観光
11:30-13:00 スカイツリー（天望デッキ＋天望回廊）
13:00-14:00 プレミアムランチ
14:30-15:15 皇居外苑
15:30-16:15 明治神宮
16:30-17:00 原宿散策
17:15-17:45 渋谷散策
18:00 新宿解散','雨天決行。
少人数制（最大12名）で特別な体験をお約束します。','・英語ガイド料
・貸切バス代
・スカイツリー展望台入場料（天望デッキ＋天望回廊）
・プレミアムランチ（特選日本料理コース・ドリンク付き）
・オリジナルお土産
・旅行保険','・個人的なお買い物代','',12,NULL,'',1,'2026-02-12 07:32:20','2026-02-18 08:50:55',0,NULL,7,0,3,30,2,50,NULL,NULL,NULL,NULL,'[{"name":"弁当付き","description":""},{"name":"弁当なし","description":""}]','[]','人','per_person','1名様あたりの料金','{"lastname_kanji":true,"firstname_kanji":true,"lastname_kana":true,"firstname_kana":true,"lastname_roman":true,"firstname_roman":true,"age":true,"gender":true,"email":false,"phone":true,"birth_date":false,"address":true}','https://placehold.co/400x300/f59e0b/ffffff?text=Premium+Tour');
INSERT INTO "products" VALUES (3,3,3,'東京プライベート観光ツアー（貸切）','2026-01-01T09:00','2026-12-20T09:00',3,NULL,'お客様のグループだけの完全プライベートツアーです。
ご希望に合わせて訪問先やスケジュールをカスタマイズできます。

【基本プラン内容】
- 専属英語ガイド
- 貸切車両（1-6名様まで）
- 8時間のツアー
- スカイツリー天望回廊入場付き
- プレミアムランチ

【カスタマイズ可能】
- 訪問先の変更・追加
- 出発時刻の調整
- ランチ場所の選択
- ショッピング時間の延長
など、ご要望をお聞かせください。

【おすすめの訪問先】
- 浅草寺・仲見世
- スカイツリー
- 皇居
- 明治神宮
- 築地場外市場
- お台場
- 秋葉原
- 六本木ヒルズ
など、お好きな場所を選択できます。','3日前までの事前予約制。
ご希望の訪問先がある場合は予約時にお知らせください。','・専属英語ガイド（8時間）
・貸切車両（1-6名様）
・スカイツリー天望回廊入場料
・プレミアムランチ（お一人様）
・旅行保険
・駐車料金','・入場料（ランチ・スカイツリー以外）
・個人的なお買い物代
・追加の飲食代','',6,NULL,'',1,'2026-02-12 07:32:20','2026-02-12 07:41:18',0,NULL,14,0,7,20,3,30,NULL,NULL,NULL,NULL,'[{"name":"大人","description":""},{"name":"子供","description":""}]','[]','人','per_person','1名あたりの料金','{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}','https://placehold.co/400x300/8b5cf6/ffffff?text=Private+Tour');


-- Table: refund_history
CREATE TABLE refund_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  payment_id INTEGER NOT NULL,
  booking_item_id INTEGER,
  
  
  refund_amount INTEGER NOT NULL,
  refund_method TEXT,
  refund_date TEXT DEFAULT (datetime('now', 'localtime')),
  refund_transaction_id TEXT,
  
  
  refund_reason TEXT,
  refund_details TEXT,
  
  remarks TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (payment_id) REFERENCES booking_payments(id),
  FOREIGN KEY (booking_item_id) REFERENCES booking_items(id)
);

INSERT INTO "refund_history" VALUES (1,4,4,16800,'credit_card','2026-02-20 14:00:00','re_1AbCdE4567890123','予約キャンセル','キャンセル料30%適用。3日前キャンセル','','2026-02-20 14:00:00');


-- Table: shared_stock_pools
CREATE TABLE shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pool_name TEXT NOT NULL,
  pool_code TEXT,
  description TEXT,
  date TEXT NOT NULL,
  time_slot_start TEXT,
  time_slot_end TEXT,
  time_slot_label TEXT,
  total_stock INTEGER DEFAULT 0,
  booked INTEGER DEFAULT 0,
  available_stock INTEGER GENERATED ALWAYS AS (total_stock - booked) VIRTUAL,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);


-- Table: vendors
CREATE TABLE vendors (
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

INSERT INTO "vendors" VALUES (1,'富士急バス株式会社','高橋運転','takahashi@fujikyu-bus.co.jp','0555-1111-2222',1,NULL,'403-0016',19,'富士吉田市松山1-1-1','0555-1111-2223',NULL,'24時間対応','なし','観光バス・貸切バス事業','大型バス20台保有','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "vendors" VALUES (2,'箱根登山観光バス','小林ドライブ','kobayashi@hakone-bus.co.jp','0460-2222-3333',1,NULL,'250-0311',14,'足柄下郡箱根町湯本2-2-2','0460-2222-3334',NULL,'6:00-22:00','不定休','箱根エリア専門','中型バス10台','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "vendors" VALUES (3,'東京シティクルーズ','伊藤船長','ito@tokyo-cruise.jp','03-3333-4444',1,NULL,'105-0011',13,'港区芝公園3-3-3','03-3333-4445',NULL,'8:00-20:00','月曜','東京湾クルーズ','大型船2隻・小型船5隻','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "vendors" VALUES (4,'多摩ケータリングサービス','渡辺料理','watanabe@tama-catering.jp','042-4444-5555',1,NULL,'190-0012',13,'立川市曙町4-4-4','042-4444-5556',NULL,'7:00-22:00','なし','弁当・ケータリング','1日1000食対応可能','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO "vendors" VALUES (5,'富士山ガイドセンター','山本登山','yamamoto@fujisan-guide.jp','0555-5555-6666',1,NULL,'403-0005',19,'富士吉田市上吉田5-5-5','0555-5555-6667',NULL,'7:00-18:00','悪天候時','富士登山ガイド','認定ガイド20名在籍','2026-02-12 07:16:29','2026-02-12 07:16:29');


-- Indexes
CREATE INDEX idx_booking_emails_booking ON booking_emails(booking_number);
CREATE INDEX idx_booking_emails_scheduled ON booking_emails(scheduled_send_at);
CREATE INDEX idx_booking_emails_status ON booking_emails(send_status);
CREATE INDEX idx_booking_files_booking ON booking_files(booking_number);
CREATE INDEX idx_booking_items_booking ON booking_items(booking_id);
CREATE INDEX idx_booking_items_participation ON booking_items(participation_date);
CREATE INDEX idx_booking_items_payment ON booking_items(payment_id);
CREATE INDEX idx_booking_items_status ON booking_items(status);
CREATE INDEX idx_booking_items_type_id ON booking_items(item_type, item_id);
CREATE INDEX idx_booking_messages_booking ON booking_messages(booking_id);
CREATE INDEX idx_booking_messages_status ON booking_messages(send_status);
CREATE INDEX idx_booking_payments_booking ON booking_payments(booking_number);
CREATE INDEX idx_booking_payments_date ON booking_payments(payment_date);
CREATE INDEX idx_booking_payments_due ON booking_payments(payment_due_date);
CREATE INDEX idx_booking_payments_method ON booking_payments(payment_method);
CREATE INDEX idx_booking_payments_number ON booking_payments(payment_number);
CREATE INDEX idx_booking_payments_status ON booking_payments(payment_status);
CREATE INDEX idx_booking_payments_transaction ON booking_payments(payment_transaction_id);
CREATE INDEX idx_bookings_created ON bookings(created_at);
CREATE INDEX idx_bookings_customer ON bookings(customer_id);
CREATE INDEX idx_bookings_event ON bookings(event_id);
CREATE INDEX idx_bookings_gmo_order ON bookings(gmo_order_id);
CREATE INDEX idx_bookings_number ON bookings(booking_number);
CREATE INDEX idx_bookings_secure_token ON bookings(secure_token);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_email_templates_active ON email_templates(is_active);
CREATE INDEX idx_event_staff_account_id ON event_staff(account_id);
CREATE INDEX idx_event_staff_event_id ON event_staff(event_id);
CREATE INDEX idx_gmo_logs_booking ON gmo_payment_logs(booking_id);
CREATE INDEX idx_gmo_logs_order ON gmo_payment_logs(gmo_order_id);
CREATE INDEX idx_gmo_logs_type ON gmo_payment_logs(event_type);
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_members_enable_flg ON members(enable_flg);
CREATE INDEX idx_otp_code ON otp_tokens(otp_code, used_at);
CREATE INDEX idx_otp_email ON otp_tokens(email, expires_at);
CREATE INDEX idx_otp_session ON otp_tokens(session_token);
CREATE INDEX idx_refund_history_date ON refund_history(refund_date);
CREATE INDEX idx_refund_history_item ON refund_history(booking_item_id);
CREATE INDEX idx_refund_history_payment ON refund_history(payment_id);
CREATE INDEX idx_refund_history_reason ON refund_history(refund_reason);

-- Views

-- View: v_booking_payments_list
CREATE VIEW v_booking_payments_list AS
SELECT 
  bp.id,
  bp.booking_number,
  bp.payment_number,
  bp.payment_type,
  bp.payment_method,
  bp.payment_status,
  bp.amount,
  bp.refunded_amount,
  bp.net_amount,
  bp.payment_date,
  bp.payment_due_date,
  bp.refund_date,
  bp.payment_transaction_id,
  
  (
    SELECT COUNT(*)
    FROM booking_items bi
    WHERE bi.payment_id = bp.id
  ) AS item_count,
  
  (
    SELECT COALESCE(SUM(bi.quantity), 0)
    FROM booking_items bi
    WHERE bi.payment_id = bp.id
      AND bi.status = 'active'
  ) AS total_participants,
  
  bp.created_at,
  bp.modified_at
FROM booking_payments bp;

-- View: v_bookings_list
CREATE VIEW v_bookings_list AS
SELECT 
  b.id,
  b.booking_number,
  b.customer_id,
  c.family_name || ' ' || c.first_name AS customer_name,
  c.email AS customer_email,
  c.mobile AS customer_phone,
  b.event_id,
  e.name AS event_name,
  b.status AS booking_status,
  b.booker_name,
  b.booker_email,
  b.booker_phone,
  
  (
    SELECT bp.payment_status
    FROM booking_payments bp
    WHERE bp.booking_number = b.booking_number
    ORDER BY bp.created_at DESC
    LIMIT 1
  ) AS latest_payment_status,
  
  (
    SELECT COALESCE(SUM(bp.net_amount), 0)
    FROM booking_payments bp
    WHERE bp.booking_number = b.booking_number
  ) AS total_amount,
  
  (
    SELECT COALESCE(SUM(bp.refunded_amount), 0)
    FROM booking_payments bp
    WHERE bp.booking_number = b.booking_number
  ) AS total_refunded,
  
  b.created_at,
  b.modified_at
FROM bookings b
LEFT JOIN customers c ON b.customer_id = c.id
LEFT JOIN events e ON b.event_id = e.id;
