-- ============================================
-- 予約管理システム 新DDL
-- バージョン: 2.0
-- 作成日: 2026-02-06
-- 
-- 概要:
-- - bookings: 予約グループ（顧客とイベントの関係）
-- - booking_payments: 決済情報（複数決済対応、後払い対応）
-- - booking_items: 予約明細（商品・オプション、参加者情報）
-- - refund_history: 返金履歴（部分返金対応）
-- ============================================

-- ============================================
-- 1. bookings（予約グループ）
-- ============================================
CREATE TABLE IF NOT EXISTS bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT UNIQUE NOT NULL,           -- 予約番号（例: BK20240201-001）
  customer_id INTEGER NOT NULL,                  -- 顧客ID
  event_id INTEGER NOT NULL,                     -- イベントID
  status TEXT DEFAULT 'active',                  -- 予約ステータス（active, partially_canceled, fully_canceled, completed）
  
  -- 予約者情報
  booker_name TEXT,                              -- 予約者名
  booker_email TEXT,                             -- 予約者メールアドレス
  booker_phone TEXT,                             -- 予約者電話番号
  
  -- その他詳細情報（JSON）
  additional_info TEXT,                          -- JSON: 住所、会社名、特記事項など
  
  remarks TEXT,                                  -- 備考
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (event_id) REFERENCES events(id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_bookings_number ON bookings(booking_number);
CREATE INDEX IF NOT EXISTS idx_bookings_customer ON bookings(customer_id);
CREATE INDEX IF NOT EXISTS idx_bookings_event ON bookings(event_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_created ON bookings(created_at);

-- ============================================
-- 2. booking_payments（決済情報）
-- ============================================
CREATE TABLE IF NOT EXISTS booking_payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,                  -- 予約番号
  payment_number TEXT UNIQUE NOT NULL,           -- 決済番号（例: PAY20240201-001）
  
  -- 決済タイミング・方法・状態
  payment_type TEXT NOT NULL DEFAULT 'immediate', -- 決済タイプ（immediate: 即時, deferred: 後払い）
  payment_method TEXT NOT NULL,                  -- 決済方法（credit_card, convenience_store, bank_transfer）
  payment_status TEXT DEFAULT 'pending',         -- 決済ステータス（pending, completed, failed, expired, refunded, partially_refunded, canceled）
  
  -- 金額管理
  amount INTEGER NOT NULL,                       -- 決済金額（元の金額、変更しない）
  refunded_amount INTEGER DEFAULT 0,             -- 返金済み金額（累積）
  net_amount INTEGER GENERATED ALWAYS AS (amount - refunded_amount) STORED, -- 実質金額（計算カラム）
  
  -- 日付管理
  payment_date TEXT,                             -- 実際の決済日
  payment_due_date TEXT,                         -- 支払い期限（後払いの場合）
  refund_date TEXT,                              -- 返金日
  
  -- 決済詳細
  payment_transaction_id TEXT,                   -- トランザクションID（検索用）
  payment_details TEXT,                          -- JSON: クレカ情報、コンビニ情報、銀行振込情報など
  
  remarks TEXT,                                  -- 備考
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_number) REFERENCES bookings(booking_number)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_booking_payments_number ON booking_payments(payment_number);
CREATE INDEX IF NOT EXISTS idx_booking_payments_booking ON booking_payments(booking_number);
CREATE INDEX IF NOT EXISTS idx_booking_payments_status ON booking_payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_booking_payments_method ON booking_payments(payment_method);
CREATE INDEX IF NOT EXISTS idx_booking_payments_transaction ON booking_payments(payment_transaction_id);
CREATE INDEX IF NOT EXISTS idx_booking_payments_date ON booking_payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_booking_payments_due ON booking_payments(payment_due_date);

-- ============================================
-- 3. booking_items（予約明細）
-- ============================================
CREATE TABLE IF NOT EXISTS booking_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,                   -- 予約ID
  payment_id INTEGER,                            -- 決済ID（この明細がどの決済に紐づくか）
  
  -- 商品/オプション情報
  item_type TEXT NOT NULL,                       -- 明細タイプ（product, option, discount）
  item_id INTEGER NOT NULL,                      -- 商品ID or オプションID
  item_name TEXT NOT NULL,                       -- 商品名 or オプション名
  stock_id INTEGER,                              -- 在庫ID
  price_category TEXT,                           -- 料金カテゴリ
  
  -- 金額情報
  quantity INTEGER DEFAULT 1,                    -- 数量（人数・個数）
  unit_price INTEGER NOT NULL,                   -- 単価
  subtotal INTEGER NOT NULL,                     -- 小計
  
  -- 参加日
  participation_date TEXT,                       -- 参加日
  
  -- 参加者情報（JSON配列）
  participants TEXT,                             -- JSON配列: [{name, age, gender, phone, email, ...}, ...]
  
  -- キャンセル管理
  status TEXT DEFAULT 'active',                  -- 明細ステータス（active, canceled, refunded）
  canceled_at TEXT,                              -- キャンセル日時
  cancel_reason TEXT,                            -- キャンセル理由
  refund_amount INTEGER DEFAULT 0,               -- この明細の返金額
  
  -- その他詳細情報（JSON）
  item_details TEXT,                             -- JSON: 座席情報、食事制限、アンケート回答など
  
  remarks TEXT,                                  -- 備考
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (payment_id) REFERENCES booking_payments(id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_booking_items_booking ON booking_items(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_payment ON booking_items(payment_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_type_id ON booking_items(item_type, item_id);
CREATE INDEX IF NOT EXISTS idx_booking_items_status ON booking_items(status);
CREATE INDEX IF NOT EXISTS idx_booking_items_participation ON booking_items(participation_date);

-- ============================================
-- 4. refund_history（返金履歴）
-- ============================================
CREATE TABLE IF NOT EXISTS refund_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  payment_id INTEGER NOT NULL,                   -- 決済ID
  booking_item_id INTEGER,                       -- 明細ID（NULL可: 決済全体の返金の場合）
  
  -- 返金情報
  refund_amount INTEGER NOT NULL,                -- 返金額
  refund_method TEXT,                            -- 返金方法（original_payment: 元の決済方法, bank_transfer: 銀行振込）
  refund_date TEXT DEFAULT (datetime('now', 'localtime')), -- 返金日
  refund_transaction_id TEXT,                    -- 返金トランザクションID
  
  -- 返金理由
  refund_reason TEXT,                            -- 簡易理由（customer_request, event_canceled, error）
  refund_details TEXT,                           -- JSON: 詳細理由、承認者、添付書類など
  
  remarks TEXT,                                  -- 備考
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (payment_id) REFERENCES booking_payments(id),
  FOREIGN KEY (booking_item_id) REFERENCES booking_items(id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_refund_history_payment ON refund_history(payment_id);
CREATE INDEX IF NOT EXISTS idx_refund_history_item ON refund_history(booking_item_id);
CREATE INDEX IF NOT EXISTS idx_refund_history_date ON refund_history(refund_date);
CREATE INDEX IF NOT EXISTS idx_refund_history_reason ON refund_history(refund_reason);

-- ============================================
-- ビュー: 予約一覧（統合ビュー）
-- ============================================
CREATE VIEW IF NOT EXISTS v_bookings_list AS
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
  
  -- 決済情報（最新の決済ステータス）
  (
    SELECT bp.payment_status
    FROM booking_payments bp
    WHERE bp.booking_number = b.booking_number
    ORDER BY bp.created_at DESC
    LIMIT 1
  ) AS latest_payment_status,
  
  -- 合計金額（すべての決済の実質金額の合計）
  (
    SELECT COALESCE(SUM(bp.net_amount), 0)
    FROM booking_payments bp
    WHERE bp.booking_number = b.booking_number
  ) AS total_amount,
  
  -- 返金済み金額（すべての決済の返金額の合計）
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

-- ============================================
-- ビュー: 決済一覧（詳細ビュー）
-- ============================================
CREATE VIEW IF NOT EXISTS v_booking_payments_list AS
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
  
  -- 明細件数
  (
    SELECT COUNT(*)
    FROM booking_items bi
    WHERE bi.payment_id = bp.id
  ) AS item_count,
  
  -- 参加者総数
  (
    SELECT COALESCE(SUM(bi.quantity), 0)
    FROM booking_items bi
    WHERE bi.payment_id = bp.id
      AND bi.status = 'active'
  ) AS total_participants,
  
  bp.created_at,
  bp.modified_at
FROM booking_payments bp;

-- ============================================
-- 確認用クエリ
-- ============================================

-- 1. すべてのテーブルを確認
-- SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'booking%' ORDER BY name;

-- 2. 予約一覧を取得
-- SELECT * FROM v_bookings_list ORDER BY created_at DESC LIMIT 10;

-- 3. 決済一覧を取得
-- SELECT * FROM v_booking_payments_list ORDER BY created_at DESC LIMIT 10;

-- 4. 特定の予約の詳細を取得
-- SELECT 
--   b.*,
--   (SELECT json_group_array(json_object(
--     'payment_number', payment_number,
--     'payment_method', payment_method,
--     'payment_status', payment_status,
--     'amount', amount,
--     'net_amount', net_amount
--   )) FROM booking_payments WHERE booking_number = b.booking_number) AS payments,
--   (SELECT json_group_array(json_object(
--     'item_name', item_name,
--     'quantity', quantity,
--     'subtotal', subtotal,
--     'status', status
--   )) FROM booking_items bi WHERE bi.booking_id = b.id) AS items
-- FROM bookings b
-- WHERE b.booking_number = 'BK20240201-001';

-- 5. 返金履歴を取得
-- SELECT 
--   rh.*,
--   bp.payment_number,
--   bi.item_name
-- FROM refund_history rh
-- LEFT JOIN booking_payments bp ON rh.payment_id = bp.id
-- LEFT JOIN booking_items bi ON rh.booking_item_id = bi.id
-- ORDER BY rh.refund_date DESC
-- LIMIT 10;
