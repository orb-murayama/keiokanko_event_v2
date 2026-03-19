-- ====================================
-- 予約管理システム DDL
-- ====================================
-- 作成日: 2026-02-06
-- 説明: 予約管理に関連するテーブル定義
-- 対象テーブル:
--   - customers (顧客)
--   - product_bookings (商品予約)
--   - option_bookings (オプション予約)
--   - bookings (統合予約)
--   - booking_items (予約明細)
-- ====================================

-- ====================================
-- 1. 顧客テーブル (customers)
-- ====================================
-- 説明: 予約を行う顧客の情報を管理
-- 用途: 予約者の基本情報、連絡先、住所などを保存

CREATE TABLE IF NOT EXISTS customers (
  -- 基本情報
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  family_name TEXT,                      -- 姓
  first_name TEXT,                       -- 名
  family_kana TEXT,                      -- 姓（かな）
  first_kana TEXT,                       -- 名（かな）
  sex INTEGER,                           -- 性別（1:男性, 2:女性）
  birth TEXT,                            -- 生年月日（YYYY-MM-DD）
  
  -- 連絡先情報
  mobile TEXT,                           -- 携帯電話番号
  tel TEXT,                              -- 固定電話番号
  fax TEXT,                              -- FAX番号
  email TEXT,                            -- メールアドレス
  
  -- 住所情報
  zip TEXT,                              -- 郵便番号
  pref_id INTEGER,                       -- 都道府県ID
  city TEXT,                             -- 市区町村
  addr TEXT,                             -- 番地
  bldg TEXT,                             -- 建物名・部屋番号
  
  -- 認証情報
  password TEXT,                         -- パスワード（ハッシュ化）
  uniqid TEXT,                           -- 一意識別子
  
  -- 支払い情報
  payment TEXT,                          -- 支払い方法
  payment_select INTEGER DEFAULT 0,     -- 支払い方法選択フラグ
  payment_status INTEGER DEFAULT 0,     -- 支払いステータス
  
  -- アンケート・備考
  answer TEXT,                           -- アンケート回答
  remark TEXT,                           -- 備考
  contact TEXT,                          -- 連絡方法
  
  -- 企業情報
  company_name TEXT,                     -- 会社名
  department_name TEXT,                  -- 部署名
  
  -- カスタムフィールド
  free1 TEXT,                            -- 自由項目1
  free2 TEXT,                            -- 自由項目2
  free3 TEXT,                            -- 自由項目3
  free4 TEXT,                            -- 自由項目4
  free5 TEXT,                            -- 自由項目5
  free6 TEXT,                            -- 自由項目6
  
  -- その他
  agent_number TEXT,                     -- 代理店番号
  branch_code TEXT,                      -- 担当支店コード
  mailme_flg INTEGER DEFAULT 0,         -- メール送信フラグ
  enable_flg INTEGER DEFAULT 1,         -- 有効フラグ（1:有効, 0:無効）
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT                       -- キャンセル日時
);

-- customersテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_customers_email 
  ON customers(email);

CREATE INDEX IF NOT EXISTS idx_customers_branch_code 
  ON customers(branch_code);

-- ====================================
-- 2. 商品予約テーブル (product_bookings)
-- ====================================
-- 説明: 商品に対する予約情報を管理
-- 用途: イベント商品の予約、参加者情報、料金明細などを保存

CREATE TABLE IF NOT EXISTS product_bookings (
  -- 基本情報
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT,                   -- 予約番号（例: BK20240201-001）
  
  -- 関連ID
  customer_id INTEGER NOT NULL,          -- 顧客ID
  product_id INTEGER NOT NULL,           -- 商品ID
  product_stock_id INTEGER,              -- 商品在庫ID
  organizer_id INTEGER,                  -- 主催者ID
  vendor_id INTEGER,                     -- 販売会社ID
  
  -- 予約内容
  quantity INTEGER NOT NULL DEFAULT 1,   -- 数量
  participation_date TEXT,               -- 参加日（YYYY-MM-DD）
  
  -- 料金情報
  price INTEGER NOT NULL,                -- 合計金額
  price_items TEXT,                      -- 料金明細（JSON）
                                         -- 例: [{"name":"入場券","price":2500,"quantity":2,"subtotal":5000}]
  
  -- ステータス
  booking_status TEXT DEFAULT 'reserved', -- 予約ステータス
                                         -- reserved: 予約済み
                                         -- confirmed: 確定
                                         -- canceled: キャンセル
  payment_status TEXT DEFAULT 'pending', -- 支払いステータス
                                         -- pending: 未払い
                                         -- completed: 完了
                                         -- failed: 失敗
  
  -- 支払い情報
  payment_method TEXT,                   -- 支払い方法
                                         -- credit_card: クレジットカード
                                         -- bank_transfer: 銀行振込
                                         -- convenience_store: コンビニ決済
  payment_date TEXT,                     -- 支払い日時
  payment_transaction_id TEXT,           -- 決済トランザクションID
  bank_transfer_info TEXT,               -- 銀行振込情報（JSON）
  convenience_store_info TEXT,           -- コンビニ決済情報（JSON）
  
  -- 参加者情報
  participants TEXT,                     -- 参加者情報（JSON）
                                         -- 例: [{"name":"山田太郎","age":39,"gender":"男性"}]
  
  -- アンケート・備考
  survey_answers TEXT,                   -- アンケート回答（JSON）
  remarks TEXT,                          -- 備考
  branch_code TEXT,                      -- 担当支店コード
  
  -- QR・PDF
  qr_code_url TEXT,                      -- QRコードURL
  pdf_file_url TEXT,                     -- PDF証明書URL
  
  -- フラグ
  enable_flg INTEGER DEFAULT 1,         -- 有効フラグ（1:有効, 0:無効）
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,                      -- キャンセル日時
  
  -- 外部キー制約
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (product_stock_id) REFERENCES product_stocks(id)
);

-- product_bookingsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_product_bookings_customer_id 
  ON product_bookings(customer_id);

CREATE INDEX IF NOT EXISTS idx_product_bookings_product_id 
  ON product_bookings(product_id);

CREATE INDEX IF NOT EXISTS idx_product_bookings_booking_number 
  ON product_bookings(booking_number);

CREATE INDEX IF NOT EXISTS idx_product_bookings_booking_status 
  ON product_bookings(booking_status);

CREATE INDEX IF NOT EXISTS idx_product_bookings_payment_status 
  ON product_bookings(payment_status);

CREATE INDEX IF NOT EXISTS idx_product_bookings_created_at 
  ON product_bookings(created_at);

CREATE INDEX IF NOT EXISTS idx_product_bookings_participation_date 
  ON product_bookings(participation_date);

CREATE INDEX IF NOT EXISTS idx_product_bookings_branch_code 
  ON product_bookings(branch_code);

-- ====================================
-- 3. オプション予約テーブル (option_bookings)
-- ====================================
-- 説明: オプション商品に対する予約情報を管理
-- 用途: 追加オプションの予約、料金などを保存

CREATE TABLE IF NOT EXISTS option_bookings (
  -- 基本情報
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  
  -- 関連ID
  customer_id INTEGER NOT NULL,          -- 顧客ID
  option_id INTEGER NOT NULL,            -- オプションID
  option_stock_id INTEGER,               -- オプション在庫ID
  
  -- 予約内容
  quantity INTEGER NOT NULL DEFAULT 1,   -- 数量
  price INTEGER NOT NULL,                -- 料金
  
  -- フラグ
  enable_flg INTEGER DEFAULT 1,         -- 有効フラグ（1:有効, 0:無効）
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  canceled_at TEXT,                      -- キャンセル日時
  
  -- 外部キー制約
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (option_stock_id) REFERENCES option_stocks(id)
);

-- option_bookingsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_option_bookings_customer_id 
  ON option_bookings(customer_id);

CREATE INDEX IF NOT EXISTS idx_option_bookings_option_id 
  ON option_bookings(option_id);

-- ====================================
-- 4. 統合予約テーブル (bookings)
-- ====================================
-- 説明: 会員による統合予約を管理
-- 用途: イベント全体の予約、複数商品・オプションをまとめた予約

CREATE TABLE IF NOT EXISTS bookings (
  -- 基本情報
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT UNIQUE NOT NULL,   -- 予約番号
  
  -- 関連ID
  member_id INTEGER NOT NULL,            -- 会員ID
  event_id INTEGER NOT NULL,             -- イベントID
  
  -- 予約情報
  booking_date DATE NOT NULL,            -- 予約日
  total_amount INTEGER NOT NULL,         -- 合計金額
  
  -- ステータス
  status TEXT NOT NULL DEFAULT 'pending',-- 予約ステータス
                                         -- pending: 保留中
                                         -- confirmed: 確定
                                         -- canceled: キャンセル
  payment_status TEXT DEFAULT 'unpaid', -- 支払いステータス
                                         -- unpaid: 未払い
                                         -- paid: 支払い済み
                                         -- refunded: 返金済み
  payment_method TEXT,                   -- 支払い方法
  
  -- 予約者情報
  is_proxy BOOLEAN DEFAULT 0,           -- 代理予約フラグ（0:本人, 1:代理）
  booker_family_name TEXT NOT NULL,     -- 予約者姓
  booker_first_name TEXT NOT NULL,      -- 予約者名
  booker_family_kana TEXT NOT NULL,     -- 予約者姓（かな）
  booker_first_kana TEXT NOT NULL,      -- 予約者名（かな）
  booker_tel TEXT NOT NULL,             -- 予約者電話番号
  booker_email TEXT NOT NULL,           -- 予約者メールアドレス
  booker_zip TEXT NOT NULL,             -- 予約者郵便番号
  booker_addr TEXT NOT NULL,            -- 予約者住所
  booker_emergency_contact TEXT,        -- 緊急連絡先
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  -- 外部キー制約
  FOREIGN KEY (member_id) REFERENCES members(id),
  FOREIGN KEY (event_id) REFERENCES events(id)
);

-- bookingsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_bookings_member_id 
  ON bookings(member_id);

CREATE INDEX IF NOT EXISTS idx_bookings_event_id 
  ON bookings(event_id);

CREATE INDEX IF NOT EXISTS idx_bookings_booking_number 
  ON bookings(booking_number);

-- ====================================
-- 5. 予約明細テーブル (booking_items)
-- ====================================
-- 説明: 統合予約の明細（商品・オプションごとの内訳）を管理
-- 用途: 1つの予約に含まれる複数の商品・オプションを明細として管理

CREATE TABLE IF NOT EXISTS booking_items (
  -- 基本情報
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,           -- 予約ID
  
  -- 明細情報
  item_type TEXT NOT NULL,               -- 明細タイプ（product/option）
  item_id INTEGER NOT NULL,              -- 商品ID or オプションID
  item_name TEXT NOT NULL,               -- 商品名 or オプション名
  stock_id INTEGER,                      -- 在庫ID
  price_category TEXT,                   -- 料金カテゴリ
  
  -- 料金情報
  quantity INTEGER NOT NULL,             -- 数量
  unit_price INTEGER NOT NULL,           -- 単価
  subtotal INTEGER NOT NULL,             -- 小計
  
  -- タイムスタンプ
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  -- 外部キー制約
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

-- booking_itemsテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_booking_items_booking_id 
  ON booking_items(booking_id);

CREATE INDEX IF NOT EXISTS idx_booking_items_item 
  ON booking_items(item_type, item_id);

-- ====================================
-- ビュー定義
-- ====================================

-- 予約一覧ビュー（商品予約）
-- 説明: 商品予約に関連する情報を結合した読み取り専用ビュー
CREATE VIEW IF NOT EXISTS v_product_bookings_list AS
SELECT 
  pb.id,
  pb.booking_number,
  pb.booking_status,
  pb.payment_status,
  pb.price,
  pb.quantity,
  pb.participation_date,
  pb.branch_code,
  pb.created_at,
  pb.modified_at,
  pb.canceled_at,
  
  -- 顧客情報
  (c.family_name || ' ' || c.first_name) as customer_name,
  c.email as customer_email,
  c.mobile as customer_phone,
  
  -- 商品情報
  p.name as product_name,
  p.id as product_id,
  
  -- イベント情報
  e.name as event_name,
  e.id as event_id,
  e.client_id
FROM product_bookings pb
LEFT JOIN customers c ON pb.customer_id = c.id
LEFT JOIN products p ON pb.product_id = p.id
LEFT JOIN events e ON p.event_id = e.id
WHERE pb.enable_flg = 1;

-- ====================================
-- 確認用クエリ（実行しない - 参考用）
-- ====================================

-- 顧客一覧
-- SELECT id, family_name, first_name, email, branch_code, enable_flg FROM customers LIMIT 10;

-- 予約一覧（最新10件）
-- SELECT * FROM v_product_bookings_list ORDER BY created_at DESC LIMIT 10;

-- ステータス別予約件数
-- SELECT booking_status, COUNT(*) as count FROM product_bookings WHERE enable_flg = 1 GROUP BY booking_status;

-- 支払いステータス別予約件数
-- SELECT payment_status, COUNT(*) as count FROM product_bookings WHERE enable_flg = 1 GROUP BY payment_status;

-- 支店別予約件数
-- SELECT branch_code, COUNT(*) as count FROM product_bookings WHERE enable_flg = 1 GROUP BY branch_code;

-- 本日の予約件数
-- SELECT COUNT(*) as today_bookings FROM product_bookings WHERE DATE(created_at) = DATE('now', 'localtime');
