PRAGMA defer_foreign_keys=TRUE;
CREATE TABLE d1_migrations(
		id         INTEGER PRIMARY KEY AUTOINCREMENT,
		name       TEXT UNIQUE,
		applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
INSERT INTO "d1_migrations" VALUES(1,'0000_consolidated_schema.sql','2025-12-26 00:12:10');
INSERT INTO "d1_migrations" VALUES(2,'0001_add_file_columns_to_bookings.sql','2025-12-26 01:34:17');
INSERT INTO "d1_migrations" VALUES(3,'0002_add_participant_payment_info.sql','2025-12-26 01:55:35');
INSERT INTO "d1_migrations" VALUES(4,'0003_complete_schema_product_bookings.sql','2026-01-07 07:30:50');
INSERT INTO "d1_migrations" VALUES(5,'0004_add_event_relationships.sql','2026-01-07 07:30:50');
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
INSERT INTO "clients" VALUES(1,'東京イベント企画',NULL,NULL,NULL,NULL,NULL,NULL,'03-1111-1111',NULL,'tokyo@client.com','password123',NULL,1,1,'2025-12-26 00:12:45','2025-12-26 00:12:45','CLI001',NULL);
INSERT INTO "clients" VALUES(2,'京都観光サービス',NULL,NULL,NULL,NULL,NULL,NULL,'075-2222-2222',NULL,'kyoto@client.com','password123',NULL,1,1,'2025-12-26 00:12:45','2025-12-26 00:12:45','CLI002',NULL);
INSERT INTO "clients" VALUES(3,'大阪ビジネス',NULL,NULL,NULL,NULL,NULL,NULL,'06-3333-3333',NULL,'osaka@client.com','password123',NULL,1,1,'2025-12-26 00:12:45','2025-12-26 00:12:45','CLI003',NULL);
INSERT INTO "clients" VALUES(4,'福岡プロモーション',NULL,NULL,NULL,NULL,NULL,NULL,'092-4444-4444',NULL,'fukuoka@client.com','password123',NULL,1,1,'2025-12-26 00:12:45','2025-12-26 00:12:45','CLI004',NULL);
INSERT INTO "clients" VALUES(5,'札幌イベントサービス',NULL,NULL,NULL,NULL,NULL,NULL,'011-5555-5555',NULL,'sapporo@client.com','password123',NULL,1,1,'2025-12-26 00:12:45','2025-12-26 00:12:45','CLI005',NULL);
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
  auto_reply_convenience_refund_en TEXT, parent_event_id INTEGER, event_type TEXT DEFAULT 'standalone',
  FOREIGN KEY (client_id) REFERENCES clients(id)
);
INSERT INTO "events" VALUES(1,'東京マラソン2025',NULL,'東京イベント企画',NULL,NULL,0,NULL,NULL,1,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','東京都内',NULL,NULL,NULL,NULL,'2025-01-01','2025-02-20','2025-03-01','2025-03-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(2,'京都祇園祭ツアー',NULL,'京都観光協会',NULL,NULL,0,NULL,NULL,2,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','京都市内',NULL,NULL,NULL,NULL,'2025-05-01','2025-07-10','2025-07-15','2025-07-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(3,'大阪ビジネスフォーラム',NULL,'大阪ビジネス',NULL,NULL,0,NULL,NULL,3,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','大阪国際会議場',NULL,NULL,NULL,NULL,'2025-03-01','2025-05-15','2025-05-20','2025-05-20',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(4,'福岡グルメフェス',NULL,'福岡プロモーション',NULL,NULL,0,NULL,NULL,4,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','福岡ドーム',NULL,NULL,NULL,NULL,'2025-02-01','2025-04-05','2025-04-10','2025-04-12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(5,'札幌雪まつり見学ツアー',NULL,'札幌イベントサービス',NULL,NULL,0,NULL,NULL,5,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','札幌市内',NULL,NULL,NULL,NULL,'2025-01-01','2025-01-31','2025-02-05','2025-02-10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(6,'東京サマーフェスティバル2025',NULL,'東京イベント企画',NULL,NULL,0,NULL,NULL,1,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','東京ビッグサイト',NULL,NULL,NULL,NULL,'2025-06-01','2025-07-25','2025-08-01','2025-08-03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(7,'京都伝統工芸展',NULL,'京都観光協会',NULL,NULL,0,NULL,NULL,2,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','京都市美術館',NULL,NULL,NULL,NULL,'2025-07-01','2025-09-10','2025-09-15','2025-09-20',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(8,'大阪ビジネスセミナー',NULL,'大阪ビジネス',NULL,NULL,0,NULL,NULL,3,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','大阪商工会議所',NULL,NULL,NULL,NULL,'2025-04-01','2025-06-05','2025-06-10','2025-06-10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(9,'福岡グルメフェア',NULL,'福岡プロモーション',NULL,NULL,0,NULL,NULL,4,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','マリンメッセ福岡',NULL,NULL,NULL,NULL,'2025-08-01','2025-10-10','2025-10-15','2025-10-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(10,'札幌スポーツフェス',NULL,'札幌イベントサービス',NULL,NULL,0,NULL,NULL,5,0,1,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,'single','札幌ドーム',NULL,NULL,NULL,NULL,'2025-09-01','2025-11-01','2025-11-05','2025-11-07',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone');
INSERT INTO "events" VALUES(20,'東京モーターショー2025','日本最大級の自動車展示会。最新モデルや次世代技術を一堂に展示します。','info@motorshow2025.jp',NULL,NULL,0,NULL,NULL,1,0,1,0,NULL,'2026-01-07 07:39:04','2026-01-07 07:39:04',1,NULL,'https://example.com/motorshow-2025',NULL,NULL,'button','東京ビッグサイト',NULL,NULL,NULL,NULL,'2025-05-01 00:00:00','2025-09-30 23:59:59','2025-10-01','2025-10-10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'parent');
INSERT INTO "events" VALUES(21,'東京モーターショー2025 - 出展者登録','東京モーターショー2025の出展者向け登録です。ブース申込みと出展料金のお支払いをお願いします。','exhibitor@motorshow2025.jp',NULL,NULL,0,NULL,NULL,1,0,1,0,NULL,'2026-01-07 07:39:34','2026-01-07 07:39:34',1,NULL,'https://example.com/motorshow-2025-exhibitor',NULL,NULL,'button','東京ビッグサイト',NULL,NULL,NULL,NULL,'2025-05-01 00:00:00','2025-08-31 23:59:59','2025-10-01','2025-10-10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,'child');
INSERT INTO "events" VALUES(22,'東京モーターショー2025 - 来場者チケット','東京モーターショー2025の来場者向けチケット販売です。一般入場券と特別観覧席をご用意しています。','visitor@motorshow2025.jp',NULL,NULL,0,NULL,NULL,1,0,1,0,NULL,'2026-01-07 07:39:37','2026-01-07 07:39:37',1,NULL,'https://example.com/motorshow-2025-visitor',NULL,NULL,'calendar','東京ビッグサイト',NULL,NULL,NULL,NULL,'2025-06-01 00:00:00','2025-10-10 18:00:00','2025-10-01','2025-10-10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,'child');
CREATE TABLE product_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);
INSERT INTO "product_categories" VALUES(1,'チケット','イベント参加チケット','2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "product_categories" VALUES(2,'ツアー','観光ツアーパッケージ','2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "product_categories" VALUES(3,'セミナー','ビジネスセミナー参加券','2025-12-26 00:12:45','2025-12-26 00:12:45');
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
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (product_category_id) REFERENCES product_categories(id)
);
INSERT INTO "products" VALUES(1,1,1,'フルマラソン参加券','2025-12-17T13:23','2026-01-03T13:23',0,1,'','','','','',NULL,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 07:37:17',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'[{"label":"名称1","name":"大人","description":""}]','[]','人','per_person','');
INSERT INTO "products" VALUES(2,1,1,'ハーフマラソン参加券','2025-01-01','2025-02-20',0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(3,2,2,'祇園祭プレミアムツアー','2025-05-01','2025-07-10',0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(4,2,2,'祇園祭標準ツアー','2025-05-01','2025-07-10',0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(5,3,3,'ビジネスフォーラム一般席','2025-03-01','2025-05-15',0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(6,3,3,'ビジネスフォーラムVIP席','2025-03-01','2025-05-15',0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(101,1,21,'スタンダードブース（3m×3m）','2025-05-01 00:00:00','2025-08-31 23:59:59',0,NULL,'基本的な展示ブース。壁面パネル、照明、電源込み。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-07 07:40:25','2026-01-07 07:40:25','none',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(102,1,21,'プレミアムブース（6m×6m）','2025-05-01 00:00:00','2025-08-31 23:59:59',0,NULL,'広々とした展示ブース。特等エリアに配置、追加照明・電源付き。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-07 07:40:37','2026-01-07 07:40:37','none',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(103,1,21,'コーナーブース（4m×4m）','2025-05-01 00:00:00','2025-08-31 23:59:59',0,NULL,'角地の目立つブース。2面展示可能、追加看板設置可。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-07 07:40:37','2026-01-07 07:40:37','none',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(201,1,22,'一般入場券（1日券）','2025-06-01 00:00:00','2025-10-10 18:00:00',0,NULL,'会期中の1日有効な入場券。全展示エリア観覧可能。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-07 07:40:37','2026-01-07 07:40:37','date',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(202,1,22,'通し券（全日程）','2025-06-01 00:00:00','2025-10-10 18:00:00',0,NULL,'会期中すべての日程で入場可能。何度でもご来場いただけます。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-07 07:40:37','2026-01-07 07:40:37','none',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
INSERT INTO "products" VALUES(203,1,22,'VIP入場券（1日券）','2025-06-01 00:00:00','2025-10-10 18:00:00',0,NULL,'専用ラウンジ利用可、優先入場、記念品付き。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-01-07 07:40:37','2026-01-07 07:40:37','date',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL);
CREATE TABLE option_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);
INSERT INTO "option_categories" VALUES(1,'グッズ','イベントグッズ','2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "option_categories" VALUES(2,'サービス','追加サービス','2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "option_categories" VALUES(3,'飲食','食事・飲料','2025-12-26 00:12:45','2025-12-26 00:12:45');
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
  deleted_at TEXT,
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (option_category_id) REFERENCES option_categories(id)
);
INSERT INTO "options" VALUES(1,1,'Tシャツ',NULL,NULL,1,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "options" VALUES(2,1,'記録証明書',NULL,NULL,2,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "options" VALUES(3,2,'昼食弁当',NULL,NULL,3,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "options" VALUES(4,3,'ガイドブック',NULL,NULL,1,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "options" VALUES(5,3,'懇親会参加券',NULL,NULL,3,NULL,NULL,1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "options" VALUES(6,3,'コピー 懇親会参加券',NULL,NULL,3,NULL,NULL,0,'2025-12-26 08:00:31','2025-12-26 08:00:31',NULL);
INSERT INTO "options" VALUES(7,3,'コピー コピー 懇親会参加券',NULL,NULL,3,NULL,NULL,0,'2025-12-26 08:00:36','2025-12-26 08:00:36',NULL);
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
INSERT INTO "product_prices" VALUES(1,1,10000,'A-名称1','2025-12-26 07:37:17','2025-12-26 07:37:17',NULL,NULL,0,1);
INSERT INTO "product_prices" VALUES(2,101,500000,NULL,'2026-01-07 07:40:47','2026-01-07 07:40:47',NULL,'基本プラン',1,1);
INSERT INTO "product_prices" VALUES(3,102,1200000,NULL,'2026-01-07 07:40:47','2026-01-07 07:40:47',NULL,'基本プラン',1,1);
INSERT INTO "product_prices" VALUES(4,103,800000,NULL,'2026-01-07 07:40:47','2026-01-07 07:40:47',NULL,'基本プラン',1,1);
INSERT INTO "product_prices" VALUES(5,201,3000,NULL,'2026-01-07 07:40:47','2026-01-07 07:40:47',NULL,'1日券',1,1);
INSERT INTO "product_prices" VALUES(6,202,15000,NULL,'2026-01-07 07:40:47','2026-01-07 07:40:47',NULL,'通し券',1,1);
INSERT INTO "product_prices" VALUES(7,203,15000,NULL,'2026-01-07 07:40:47','2026-01-07 07:40:47',NULL,'VIP 1日券',1,1);
CREATE TABLE option_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);
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
INSERT INTO "product_stocks" VALUES(2,1,'2025-12-27',3,0,'2025-12-26 07:37:41','2025-12-26 07:37:41',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES(3,1,'2025-12-28',3,0,'2025-12-26 07:37:41','2025-12-26 07:37:41',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES(4,1,'2025-12-29',7,0,'2025-12-26 07:37:42','2025-12-26 07:46:16',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES(5,1,'2025-12-30',3,0,'2025-12-26 07:37:42','2025-12-26 07:37:42',NULL,NULL,NULL,NULL,NULL,'A');
INSERT INTO "product_stocks" VALUES(6,1,'2025-12-31',3,0,'2025-12-26 07:37:42','2025-12-26 07:37:42',NULL,NULL,NULL,NULL,NULL,'A');
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
  canceled_at TEXT, qr_code_url TEXT, pdf_file_url TEXT, price_items TEXT, remarks TEXT, participants TEXT, participation_date TEXT, payment_method TEXT, payment_date TEXT, payment_transaction_id TEXT, bank_transfer_info TEXT, convenience_store_info TEXT, survey_answers TEXT, organizer_id INTEGER, vendor_id INTEGER,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (product_stock_id) REFERENCES product_stocks(id)
);
INSERT INTO "product_bookings" VALUES(1,'BK-2025-001',1,1,NULL,15000,1,'reserved','pending',1,'2025-12-26 00:12:45','2025-12-26 01:33:38',NULL,NULL,NULL,NULL,NULL,replace('[\n  {\n    "name": "田中 太郎",\n    "kana": "タナカ タロウ",\n    "age": 35,\n    "gender": "male",\n    "email": "tanaka@example.com",\n    "tel": "090-1111-1111"\n  }\n]','\n',char(10)),'2025-03-15','credit_card','2025-12-26 10:30:00','TXN-20251226-ABC123456',NULL,NULL,replace('[\n  {\n    "question": "参加動機をお聞かせください",\n    "answer": "健康のためにマラソンを始めたいと思い、参加を決めました。"\n  },\n  {\n    "question": "過去のマラソン経験はありますか？",\n    "answer": "初めての参加です"\n  },\n  {\n    "question": "食事制限はありますか？",\n    "answer": "特にありません"\n  },\n  {\n    "question": "緊急連絡先",\n    "answer": "鈴木一郎 (080-9999-8888)"\n  }\n]','\n',char(10)),1,1);
INSERT INTO "product_bookings" VALUES(2,'BK-2025-002',2,2,NULL,8000,2,'confirmed','paid',1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,NULL,'2025-03-15','bank_transfer','2025-12-25 15:20:00',NULL,replace('{\n    "bank_name": "みずほ銀行",\n    "branch_name": "東京支店",\n    "account_type": "普通",\n    "account_number": "1234567",\n    "account_holder": "株式会社イベント企画",\n    "transfer_deadline": "2025-12-30"\n  }','\n',char(10)),NULL,NULL,1,1);
INSERT INTO "product_bookings" VALUES(3,'BK-2025-003',3,3,NULL,50000,1,'cancel_requested','refund_pending',1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,NULL,'2025-04-01','convenience_store','2025-12-24 18:45:00',NULL,NULL,replace('{\n    "store_name": "セブンイレブン",\n    "payment_code": "12345-67890-11111",\n    "payment_deadline": "2025-12-31"\n  }','\n',char(10)),NULL,2,2);
INSERT INTO "product_bookings" VALUES(4,'BK-2025-004',4,4,NULL,35000,1,'cancelled','refunded',1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "product_bookings" VALUES(5,'BK-2025-005',5,5,NULL,10000,3,'confirmed','paid',1,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
CREATE TABLE customers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  family_name TEXT,
  first_name TEXT,
  family_kana TEXT,
  first_kana TEXT,
  sex INTEGER,
  birth TEXT,
  mobile TEXT,
  tel TEXT,
  fax TEXT,
  email TEXT,
  zip TEXT,
  pref_id INTEGER,
  city TEXT,
  addr TEXT,
  bldg TEXT,
  password TEXT,
  payment TEXT,
  answer TEXT,
  remark TEXT,
  mailme_flg INTEGER DEFAULT 0,
  contact TEXT,
  company_name TEXT,
  department_name TEXT,
  free1 TEXT,
  free2 TEXT,
  free3 TEXT,
  free4 TEXT,
  free5 TEXT,
  free6 TEXT,
  agent_number TEXT,
  enable_flg INTEGER DEFAULT 1,
  payment_select INTEGER DEFAULT 0,
  payment_status INTEGER DEFAULT 0,
  uniqid TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT
);
INSERT INTO "customers" VALUES(1,'田中','太郎','タナカ','タロウ',NULL,NULL,NULL,'090-1111-1111',NULL,'tanaka@example.com','100-0001',13,'千代田区','丸の内1-1-1',NULL,'password123',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "customers" VALUES(2,'鈴木','花子','スズキ','ハナコ',NULL,NULL,NULL,'080-2222-2222',NULL,'suzuki@example.com','530-0001',27,'大阪市北区','梅田1-1-1',NULL,'password123',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "customers" VALUES(3,'佐藤','次郎','サトウ','ジロウ',NULL,NULL,NULL,'070-3333-3333',NULL,'sato@example.com','600-8216',26,'京都市下京区','烏丸通七条下る',NULL,'password123',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "customers" VALUES(4,'山田','美咲','ヤマダ','ミサキ',NULL,NULL,NULL,'090-4444-4444',NULL,'yamada@example.com','810-0001',40,'福岡市中央区','天神1-1-1',NULL,'password123',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
INSERT INTO "customers" VALUES(5,'高橋','健太','タカハシ','ケンタ',NULL,NULL,NULL,'080-5555-5555',NULL,'takahashi@example.com','060-0001',1,'札幌市中央区','北一条西1-1-1',NULL,'password123',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45',NULL);
CREATE TABLE prefs (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);
INSERT INTO "prefs" VALUES(1,'北海道');
INSERT INTO "prefs" VALUES(2,'青森県');
INSERT INTO "prefs" VALUES(3,'岩手県');
INSERT INTO "prefs" VALUES(4,'宮城県');
INSERT INTO "prefs" VALUES(5,'秋田県');
INSERT INTO "prefs" VALUES(6,'山形県');
INSERT INTO "prefs" VALUES(7,'福島県');
INSERT INTO "prefs" VALUES(8,'茨城県');
INSERT INTO "prefs" VALUES(9,'栃木県');
INSERT INTO "prefs" VALUES(10,'群馬県');
INSERT INTO "prefs" VALUES(11,'埼玉県');
INSERT INTO "prefs" VALUES(12,'千葉県');
INSERT INTO "prefs" VALUES(13,'東京都');
INSERT INTO "prefs" VALUES(14,'神奈川県');
INSERT INTO "prefs" VALUES(15,'新潟県');
INSERT INTO "prefs" VALUES(16,'富山県');
INSERT INTO "prefs" VALUES(17,'石川県');
INSERT INTO "prefs" VALUES(18,'福井県');
INSERT INTO "prefs" VALUES(19,'山梨県');
INSERT INTO "prefs" VALUES(20,'長野県');
INSERT INTO "prefs" VALUES(21,'岐阜県');
INSERT INTO "prefs" VALUES(22,'静岡県');
INSERT INTO "prefs" VALUES(23,'愛知県');
INSERT INTO "prefs" VALUES(24,'三重県');
INSERT INTO "prefs" VALUES(25,'滋賀県');
INSERT INTO "prefs" VALUES(26,'京都府');
INSERT INTO "prefs" VALUES(27,'大阪府');
INSERT INTO "prefs" VALUES(28,'兵庫県');
INSERT INTO "prefs" VALUES(29,'奈良県');
INSERT INTO "prefs" VALUES(30,'和歌山県');
INSERT INTO "prefs" VALUES(31,'鳥取県');
INSERT INTO "prefs" VALUES(32,'島根県');
INSERT INTO "prefs" VALUES(33,'岡山県');
INSERT INTO "prefs" VALUES(34,'広島県');
INSERT INTO "prefs" VALUES(35,'山口県');
INSERT INTO "prefs" VALUES(36,'徳島県');
INSERT INTO "prefs" VALUES(37,'香川県');
INSERT INTO "prefs" VALUES(38,'愛媛県');
INSERT INTO "prefs" VALUES(39,'高知県');
INSERT INTO "prefs" VALUES(40,'福岡県');
INSERT INTO "prefs" VALUES(41,'佐賀県');
INSERT INTO "prefs" VALUES(42,'長崎県');
INSERT INTO "prefs" VALUES(43,'熊本県');
INSERT INTO "prefs" VALUES(44,'大分県');
INSERT INTO "prefs" VALUES(45,'宮崎県');
INSERT INTO "prefs" VALUES(46,'鹿児島県');
INSERT INTO "prefs" VALUES(47,'沖縄県');
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
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);
INSERT INTO "accounts" VALUES(1,'admin','password123','システム管理者','admin@system.com',NULL,'system_admin',1,'2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "accounts" VALUES(2,'tokyo_admin','password123','東京 太郎','tokyo_admin@client.com',1,'client_admin',1,'2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "accounts" VALUES(3,'kyoto_admin','password123','京都 花子','kyoto_admin@client.com',2,'client_admin',1,'2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "accounts" VALUES(4,'osaka_user','password123','大阪 次郎','osaka_user@client.com',3,'general',1,'2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "accounts" VALUES(5,'fukuoka_user','password123','福岡 三郎','fukuoka_user@client.com',4,'general',1,'2025-12-26 00:12:45','2025-12-26 00:12:45');
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
INSERT INTO "organizers" VALUES(1,'東京イベント企画株式会社',NULL,'info@tokyo-event.com','03-1234-5678',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "organizers" VALUES(2,'京都観光協会',NULL,'info@kyoto-kanko.or.jp','075-123-4567',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "organizers" VALUES(3,'大阪文化センター',NULL,'info@osaka-bunka.or.jp','06-1234-5678',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45');
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
INSERT INTO "vendors" VALUES(1,'チケット販売株式会社',NULL,'sales@ticket.com','03-9999-0001',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "vendors" VALUES(2,'イベントプラス',NULL,'info@event-plus.com','06-8888-0002',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45');
INSERT INTO "vendors" VALUES(3,'トラベルネット',NULL,'support@travel-net.com','075-7777-0003',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-12-26 00:12:45','2025-12-26 00:12:45');
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
CREATE TABLE product_shared_stock_pools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pool_name TEXT NOT NULL,
  total_stock INTEGER DEFAULT 0,
  booked INTEGER DEFAULT 0,
  available INTEGER DEFAULT 0,
  event_id INTEGER,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);
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
INSERT INTO "shared_stock_pools" VALUES(1,'東京サマーフェス往復バス','BUS-TOKYO-2025','東京駅⇔イベント会場','2025-08-01','09:00','10:00','午前便',45,10,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(2,'東京サマーフェス往復バス','BUS-TOKYO-2025','東京駅⇔イベント会場','2025-08-01','13:00','14:00','午後便',45,5,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(3,'東京サマーフェス往復バス','BUS-TOKYO-2025','東京駅⇔イベント会場','2025-08-02','09:00','10:00','午前便',45,15,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(4,'東京サマーフェス往復バス','BUS-TOKYO-2025','東京駅⇔イベント会場','2025-08-02','13:00','14:00','午後便',45,20,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(5,'東京サマーフェス往復バス','BUS-TOKYO-2025','東京駅⇔イベント会場','2025-08-03','09:00','10:00','午前便',45,8,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(6,'京都花火大会駐車場','PARKING-KYOTO-01','会場隣接駐車場','2025-07-15',NULL,NULL,NULL,100,45,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(7,'京都花火大会駐車場','PARKING-KYOTO-01','会場隣接駐車場','2025-07-16',NULL,NULL,NULL,100,67,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(8,'京都花火大会駐車場','PARKING-KYOTO-01','会場隣接駐車場','2025-07-17',NULL,NULL,NULL,100,89,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(9,'大阪音楽フェス宿泊パック','HOTEL-OSAKA-2025','提携ホテル宿泊','2025-09-10',NULL,NULL,NULL,50,12,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(10,'大阪音楽フェス宿泊パック','HOTEL-OSAKA-2025','提携ホテル宿泊','2025-09-11',NULL,NULL,NULL,50,34,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
INSERT INTO "shared_stock_pools" VALUES(11,'大阪音楽フェス宿泊パック','HOTEL-OSAKA-2025','提携ホテル宿泊','2025-09-12',NULL,NULL,NULL,50,28,1,'2025-12-26 00:12:52','2025-12-26 00:12:52');
CREATE TABLE option_forms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  form_type INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);
CREATE TABLE option_inherited_products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);
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
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('d1_migrations',5);
INSERT INTO "sqlite_sequence" VALUES('accounts',5);
INSERT INTO "sqlite_sequence" VALUES('clients',5);
INSERT INTO "sqlite_sequence" VALUES('organizers',3);
INSERT INTO "sqlite_sequence" VALUES('vendors',3);
INSERT INTO "sqlite_sequence" VALUES('events',22);
INSERT INTO "sqlite_sequence" VALUES('product_categories',3);
INSERT INTO "sqlite_sequence" VALUES('products',203);
INSERT INTO "sqlite_sequence" VALUES('option_categories',3);
INSERT INTO "sqlite_sequence" VALUES('options',7);
INSERT INTO "sqlite_sequence" VALUES('customers',5);
INSERT INTO "sqlite_sequence" VALUES('product_bookings',5);
INSERT INTO "sqlite_sequence" VALUES('shared_stock_pools',11);
INSERT INTO "sqlite_sequence" VALUES('product_prices',7);
INSERT INTO "sqlite_sequence" VALUES('product_stocks',6);
CREATE INDEX idx_clients_email ON clients(email);
CREATE INDEX idx_clients_group_id ON clients(group_id);
CREATE INDEX idx_events_client_id ON events(client_id);
CREATE INDEX idx_events_enable_flg ON events(enable_flg);
CREATE INDEX idx_events_company_flg ON events(company_flg);
CREATE INDEX idx_products_event_id ON products(event_id);
CREATE INDEX idx_products_client_id ON products(client_id);
CREATE INDEX idx_products_enable_flg ON products(enable_flg);
CREATE INDEX idx_products_sales_start ON products(sales_start);
CREATE INDEX idx_products_sales_end ON products(sales_end);
CREATE UNIQUE INDEX idx_products_event_name ON products(event_id, name);
CREATE INDEX idx_product_bookings_number 
  ON product_bookings(booking_number);
CREATE INDEX idx_product_bookings_created 
  ON product_bookings(created_at);
CREATE INDEX idx_accounts_login_id ON accounts(login_id);
CREATE INDEX idx_accounts_email ON accounts(email);
CREATE INDEX idx_shared_stock_pools_pool_date 
  ON shared_stock_pools(pool_name, pool_code, date);
CREATE INDEX idx_shared_stock_pools_enable 
  ON shared_stock_pools(enable_flg);
CREATE INDEX idx_product_bookings_customer ON product_bookings(customer_id);
CREATE INDEX idx_product_bookings_product ON product_bookings(product_id);
CREATE INDEX idx_product_bookings_status ON product_bookings(booking_status);
CREATE INDEX idx_product_bookings_payment ON product_bookings(payment_status);
CREATE INDEX idx_product_bookings_participation ON product_bookings(participation_date);
CREATE INDEX idx_events_parent_event_id ON events(parent_event_id);
CREATE INDEX idx_events_event_type ON events(event_type);