-- ============================================
-- データ移行: product_bookings → 新予約管理システム
-- バージョン: 0005
-- 作成日: 2026-02-06
-- 
-- 概要:
-- - 既存のproduct_bookingsテーブルから新しいbookings/booking_payments/booking_itemsへデータを移行
-- - 1つのproduct_bookingレコード → 1つのbooking + 1つのpayment + 1つのitem
-- ============================================

-- ============================================
-- ステップ1: bookings（予約グループ）を作成
-- ============================================
INSERT INTO bookings (
  booking_number,
  customer_id,
  event_id,
  status,
  booker_name,
  booker_email,
  booker_phone,
  created_at,
  modified_at
)
SELECT DISTINCT
  pb.booking_number,
  pb.customer_id,
  p.event_id,
  CASE 
    WHEN pb.booking_status = 'canceled' THEN 'fully_canceled'
    WHEN pb.booking_status = 'confirmed' THEN 'active'
    WHEN pb.booking_status = 'reserved' THEN 'active'
    ELSE 'active'
  END AS status,
  c.family_name || ' ' || c.first_name AS booker_name,
  c.email AS booker_email,
  c.mobile AS booker_phone,
  pb.created_at,
  pb.modified_at
FROM product_bookings pb
LEFT JOIN customers c ON pb.customer_id = c.id
LEFT JOIN products p ON pb.product_id = p.id
WHERE NOT EXISTS (
  SELECT 1 FROM bookings b WHERE b.booking_number = pb.booking_number
);

-- ============================================
-- ステップ2: booking_payments（決済情報）を作成
-- ============================================
INSERT INTO booking_payments (
  booking_number,
  payment_number,
  payment_type,
  payment_method,
  payment_status,
  amount,
  refunded_amount,
  payment_date,
  payment_transaction_id,
  payment_details,
  created_at,
  modified_at
)
SELECT 
  pb.booking_number,
  'PAY' || substr(pb.booking_number, 3) AS payment_number, -- BK20240201-001 → PAY20240201-001
  'immediate' AS payment_type,
  COALESCE(pb.payment_method, 'credit_card') AS payment_method,
  CASE 
    WHEN pb.payment_status = 'completed' THEN 'completed'
    WHEN pb.payment_status = 'pending' THEN 'pending'
    WHEN pb.payment_status = 'failed' THEN 'failed'
    ELSE 'pending'
  END AS payment_status,
  pb.price * pb.quantity AS amount,
  0 AS refunded_amount,
  pb.payment_date,
  pb.payment_transaction_id,
  json_object(
    'convenience_store', json_object(
      'info', pb.convenience_store_info
    ),
    'bank_transfer', json_object(
      'info', pb.bank_transfer_info
    )
  ) AS payment_details,
  pb.created_at,
  pb.modified_at
FROM product_bookings pb
WHERE NOT EXISTS (
  SELECT 1 FROM booking_payments bp WHERE bp.payment_number = 'PAY' || substr(pb.booking_number, 3)
);

-- ============================================
-- ステップ3: booking_items（予約明細）を作成
-- ============================================
INSERT INTO booking_items (
  booking_id,
  payment_id,
  item_type,
  item_id,
  item_name,
  stock_id,
  price_category,
  quantity,
  unit_price,
  subtotal,
  participation_date,
  participants,
  status,
  canceled_at,
  cancel_reason,
  refund_amount,
  item_details,
  remarks,
  created_at,
  modified_at
)
SELECT 
  b.id AS booking_id,
  bp.id AS payment_id,
  'product' AS item_type,
  pb.product_id AS item_id,
  p.name AS item_name,
  pb.product_stock_id AS stock_id,
  NULL AS price_category,
  pb.quantity,
  pb.price AS unit_price,
  pb.price * pb.quantity AS subtotal,
  pb.participation_date,
  pb.participants,
  CASE 
    WHEN pb.booking_status = 'canceled' THEN 'canceled'
    ELSE 'active'
  END AS status,
  pb.canceled_at,
  NULL AS cancel_reason,
  0 AS refund_amount,
  json_object(
    'price_items', json(COALESCE(pb.price_items, '[]')),
    'survey_answers', json(COALESCE(pb.survey_answers, '{}'))
  ) AS item_details,
  pb.remarks,
  pb.created_at,
  pb.modified_at
FROM product_bookings pb
LEFT JOIN bookings b ON b.booking_number = pb.booking_number
LEFT JOIN booking_payments bp ON bp.payment_number = 'PAY' || substr(pb.booking_number, 3)
LEFT JOIN products p ON pb.product_id = p.id
WHERE b.id IS NOT NULL 
  AND bp.id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM booking_items bi 
    WHERE bi.booking_id = b.id 
      AND bi.payment_id = bp.id
      AND bi.item_id = pb.product_id
      AND bi.participation_date = pb.participation_date
  );

-- ============================================
-- 確認用クエリ
-- ============================================

-- 移行件数の確認
-- SELECT 
--   (SELECT COUNT(*) FROM product_bookings) AS product_bookings_count,
--   (SELECT COUNT(*) FROM bookings) AS bookings_count,
--   (SELECT COUNT(*) FROM booking_payments) AS payments_count,
--   (SELECT COUNT(*) FROM booking_items) AS items_count;

-- 予約一覧を確認
-- SELECT * FROM v_bookings_list ORDER BY created_at DESC LIMIT 10;

-- 特定の予約番号のデータを確認
-- SELECT 
--   'bookings' AS table_name, booking_number, customer_id, event_id, status
-- FROM bookings WHERE booking_number = 'BK20240201-001'
-- UNION ALL
-- SELECT 
--   'booking_payments', booking_number, payment_number, payment_method, payment_status
-- FROM booking_payments WHERE booking_number = 'BK20240201-001'
-- UNION ALL
-- SELECT 
--   'booking_items', b.booking_number, bi.item_name, bi.quantity, bi.status
-- FROM booking_items bi
-- JOIN bookings b ON bi.booking_id = b.id
-- WHERE b.booking_number = 'BK20240201-001';
