-- ============================================
-- 商品追加と後払い決済（コンビニ払い）のテストデータ
-- 予約番号: BK20260209-002（佐藤花子）
-- 作成日: 2026-02-09
-- 
-- シナリオ:
-- BK20260209-002に新しい商品を追加
-- 決済方法: コンビニ払い（セブンイレブン）
-- 決済タイプ: 後払い（deferred）
-- ============================================

-- 追加決済（一般入場券 × 2名、後払い、セブンイレブン）
INSERT INTO booking_payments (
  id, 
  booking_number, 
  payment_number, 
  payment_type, 
  payment_method, 
  payment_status, 
  amount, 
  refunded_amount, 
  payment_due_date,
  payment_details,
  created_at
)
VALUES (
  8,
  'BK20260209-002',
  'PAY20260209-008',
  'deferred',
  'convenience_store',
  'pending',
  10000,
  0,
  date('now', '+7 days'),
  json('{"convenience_store":"seven_eleven","store_name":"セブンイレブン","payment_code":"12345678901234","payment_slip_url":"https://example.com/payment/12345678901234"}'),
  datetime('now')
);

-- 追加明細（一般入場券 × 2名）
INSERT INTO booking_items (
  id, 
  booking_id, 
  payment_id, 
  item_type, 
  item_id, 
  item_name, 
  quantity, 
  unit_price, 
  subtotal, 
  participation_date, 
  participants, 
  status, 
  created_at
)
VALUES (
  8,
  2,
  8,
  'product',
  1,
  '一般入場券',
  2,
  5000,
  10000,
  '2024-08-15',
  json('[{"lastname":"佐藤","firstname":"次郎","age":12,"gender":"男性","email":"","phone":"","birth":"2012-05-10","custom_fields":{"お弁当":"お子様ランチ","ドリンク":"コーラ"}},{"lastname":"佐藤","firstname":"三郎","age":10,"gender":"男性","email":"","phone":"","birth":"2014-08-22","custom_fields":{"お弁当":"お子様ランチ","ドリンク":"オレンジジュース","アレルギー":"乳製品"}}]'),
  'active',
  datetime('now')
);

-- ============================================
-- 確認用クエリ
-- ============================================

-- 予約BK20260209-002の全決済を確認
-- SELECT 
--   payment_number, 
--   payment_type,
--   payment_method, 
--   payment_status, 
--   amount, 
--   payment_due_date,
--   payment_details
-- FROM booking_payments 
-- WHERE booking_number = 'BK20260209-002'
-- ORDER BY created_at;

-- 予約BK20260209-002の全明細を確認
-- SELECT 
--   item_name, 
--   quantity, 
--   unit_price, 
--   subtotal,
--   participation_date,
--   status
-- FROM booking_items 
-- WHERE booking_id = 2
-- ORDER BY created_at;

-- 予約BK20260209-002の合計金額を確認
-- SELECT 
--   SUM(amount) as total_amount,
--   SUM(refunded_amount) as total_refunded
-- FROM booking_payments 
-- WHERE booking_number = 'BK20260209-002';
