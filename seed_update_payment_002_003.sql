-- ========================================
-- BK20260209-002 決済2の統合
-- ========================================
-- 目的: VIP入場券と一般入場券のコンビニ払いを1つの決済に統合
-- 変更内容:
--   1. 決済2 (PAY20260209-003) の金額を ¥10,000 → ¥20,000 に更新
--   2. 決済2の payment_details にセブンイレブン情報を追加
--   3. 明細3 (booking_items.id = 8) の payment_id を 8 → 3 に変更
--   4. 決済3 (PAY20260209-008) を削除
-- ========================================

-- 1. 明細3を決済2に紐付け
UPDATE booking_items 
SET payment_id = 3,
    modified_at = datetime('now')
WHERE id = 8;

-- 2. 決済2の金額を更新し、セブンイレブン情報を追加
-- 注意: net_amount は GENERATED カラムなので更新不要（自動計算される）
UPDATE booking_payments 
SET amount = 20000,
    payment_details = json('{
      "convenience_store": "seven_eleven",
      "store_name": "セブンイレブン",
      "payment_code": "12345678901234",
      "payment_slip_url": "https://example.com/payment/12345678901234",
      "payment_amount": 20000,
      "expiry_date": "2026-02-14",
      "notes": "VIP入場券(¥10,000) + 一般入場券×2名(¥10,000)の統合決済"
    }'),
    modified_at = datetime('now')
WHERE payment_number = 'PAY20260209-003';

-- 3. 決済3を削除
DELETE FROM booking_payments 
WHERE payment_number = 'PAY20260209-008';

-- ========================================
-- 確認用クエリ（実行しない、コメント化）
-- ========================================

-- 決済2の確認
-- SELECT 
--   bp.payment_number,
--   bp.payment_type,
--   bp.payment_method,
--   bp.amount,
--   bp.payment_details,
--   bp.payment_due_date
-- FROM booking_payments bp
-- WHERE bp.payment_number = 'PAY20260209-003';

-- 決済2に紐付く明細の確認
-- SELECT 
--   bi.id,
--   bi.item_name,
--   bi.quantity,
--   bi.subtotal,
--   bi.participants
-- FROM booking_items bi
-- WHERE bi.payment_id = 3
-- ORDER BY bi.id;

-- BK20260209-002の全体確認
-- SELECT 
--   bp.payment_number,
--   bp.payment_method,
--   bp.amount,
--   bp.payment_status,
--   COUNT(bi.id) as item_count,
--   SUM(bi.subtotal) as total_subtotal
-- FROM booking_payments bp
-- LEFT JOIN booking_items bi ON bp.id = bi.payment_id
-- WHERE bp.booking_number = 'BK20260209-002'
-- GROUP BY bp.id
-- ORDER BY bp.id;
