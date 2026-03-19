-- ============================================
-- VIP入場券と一般入場券のコンビニ払いを1つにまとめる
-- 予約番号: BK20260209-002（佐藤花子）
-- 作成日: 2026-02-09
-- 
-- 変更内容:
-- 1. 明細3（id=8）の決済を決済3（id=8）から決済2（id=3）に変更
-- 2. 決済2（PAY20260209-003）の金額を¥10,000から¥20,000に更新
-- 3. 決済2のpayment_detailsにセブンイレブン情報を追加
-- 4. 決済3（PAY20260209-008）を削除
-- ============================================

-- 1. 明細3の決済IDを決済2に変更
UPDATE booking_items 
SET payment_id = 3 
WHERE id = 8;

-- 2. 決済2の金額を¥20,000に更新
UPDATE booking_payments 
SET amount = 20000 
WHERE id = 3;

-- 3. 決済2にセブンイレブンの決済詳細情報を追加
UPDATE booking_payments 
SET payment_details = json('{"convenience_store":"seven_eleven","store_name":"セブンイレブン","payment_code":"12345678901234","payment_slip_url":"https://example.com/payment/12345678901234"}')
WHERE id = 3;

-- 4. 決済3を削除
DELETE FROM booking_payments 
WHERE id = 8;

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

-- 予約BK20260209-002の全明細と紐付け決済を確認
-- SELECT 
--   bi.id,
--   bi.item_name, 
--   bi.quantity, 
--   bi.subtotal,
--   bp.payment_number,
--   bp.amount as payment_amount
-- FROM booking_items bi
-- LEFT JOIN booking_payments bp ON bi.payment_id = bp.id
-- WHERE bi.booking_id = 2
-- ORDER BY bi.created_at;

-- 決済2に紐付く明細の合計金額を確認
-- SELECT 
--   bp.payment_number,
--   bp.amount as payment_amount,
--   SUM(bi.subtotal) as items_total,
--   COUNT(bi.id) as items_count
-- FROM booking_payments bp
-- LEFT JOIN booking_items bi ON bi.payment_id = bp.id
-- WHERE bp.id = 3
-- GROUP BY bp.id;
