-- ============================================
-- 新予約管理システム テストデータ v2
-- バージョン: 2.0
-- 作成日: 2026-02-09
-- 
-- 変更点:
-- - 参加者情報を lastname, firstname に分割
-- - custom_fields フィールドを追加（付加情報）
-- 
-- テストシナリオ:
-- 1. 通常予約（1決済、顧客情報を参加者にセット）
-- 2. 複数決済予約（初回 + 追加予約）
-- 3. 返金ありの予約（部分返金）
-- 4. 複数参加者の予約（custom_fieldsあり）
-- 5. 部分返金の予約
-- ============================================

-- 既存データをクリア
DELETE FROM refund_history;
DELETE FROM booking_items;
DELETE FROM booking_payments;
DELETE FROM bookings;

-- ============================================
-- テストケース1: 通常予約（山田太郎）
-- 顧客: 山田太郎（ID: 1）
-- イベント: 東京サマーフェスティバル2024（ID: 1）
-- 商品: 一般入場券（ID: 1）× 1名
-- 決済: クレジットカード、即時決済、完了
-- 参加者: 山田太郎（顧客情報から取得）
-- ============================================

INSERT INTO bookings (id, booking_number, customer_id, event_id, status, booker_name, booker_email, booker_phone, created_at)
VALUES (1, 'BK20260209-001', 1, 1, 'active', '山田 太郎', 'yamada.taro@example.com', '090-1234-5678', datetime('now', '-2 days'));

INSERT INTO booking_payments (id, booking_number, payment_number, payment_type, payment_method, payment_status, amount, refunded_amount, payment_date, payment_transaction_id, created_at)
VALUES (1, 'BK20260209-001', 'PAY20260209-001', 'immediate', 'credit_card', 'completed', 5000, 0, datetime('now', '-2 days'), 'TXN-20260209-001', datetime('now', '-2 days'));

INSERT INTO booking_items (id, booking_id, payment_id, item_type, item_id, item_name, quantity, unit_price, subtotal, participation_date, participants, status, created_at)
VALUES (
  1, 1, 1, 'product', 1, '一般入場券', 1, 5000, 5000, '2024-08-15',
  json('[{"lastname":"山田","firstname":"太郎","age":39,"gender":"男性","email":"yamada.taro@example.com","phone":"090-1234-5678","birth":"1985-03-15","custom_fields":{}}]'),
  'active', datetime('now', '-2 days')
);

-- ============================================
-- テストケース2: 複数決済予約（佐藤花子）
-- 顧客: 佐藤花子（ID: 2）
-- イベント: 東京サマーフェスティバル2024（ID: 1）
-- 商品1: 一般入場券（ID: 1）× 2名（初回決済）
-- 商品2: VIP入場券（ID: 2）× 1名（追加決済、後払い）
-- 決済1: クレジットカード、即時決済、完了
-- 決済2: コンビニ決済、後払い、支払い待ち
-- 参加者: 佐藤花子 + 家族
-- ============================================

INSERT INTO bookings (id, booking_number, customer_id, event_id, status, booker_name, booker_email, booker_phone, created_at)
VALUES (2, 'BK20260209-002', 2, 1, 'active', '佐藤 花子', 'sato.hanako@example.com', '080-2345-6789', datetime('now', '-3 days'));

-- 初回決済（一般入場券 × 2名）
INSERT INTO booking_payments (id, booking_number, payment_number, payment_type, payment_method, payment_status, amount, refunded_amount, payment_date, payment_transaction_id, created_at)
VALUES (2, 'BK20260209-002', 'PAY20260209-002', 'immediate', 'credit_card', 'completed', 10000, 0, datetime('now', '-3 days'), 'TXN-20260209-002', datetime('now', '-3 days'));

INSERT INTO booking_items (id, booking_id, payment_id, item_type, item_id, item_name, quantity, unit_price, subtotal, participation_date, participants, status, created_at)
VALUES (
  2, 2, 2, 'product', 1, '一般入場券', 2, 5000, 10000, '2024-08-15',
  json('[{"lastname":"佐藤","firstname":"花子","age":34,"gender":"女性","email":"sato.hanako@example.com","phone":"080-2345-6789","birth":"1990-07-20","custom_fields":{"お弁当":"和食","ドリンク":"ウーロン茶"}},{"lastname":"佐藤","firstname":"太一","age":8,"gender":"男性","email":"","phone":"","birth":"2016-04-10","custom_fields":{"お弁当":"お子様ランチ","ドリンク":"オレンジジュース"}}]'),
  'active', datetime('now', '-3 days')
);

-- 追加決済（VIP入場券 × 1名、後払い）
INSERT INTO booking_payments (id, booking_number, payment_number, payment_type, payment_method, payment_status, amount, refunded_amount, payment_due_date, created_at)
VALUES (3, 'BK20260209-002', 'PAY20260209-003', 'deferred', 'convenience_store', 'pending', 10000, 0, date('now', '+5 days'), datetime('now', '-1 day'));

INSERT INTO booking_items (id, booking_id, payment_id, item_type, item_id, item_name, quantity, unit_price, subtotal, participation_date, participants, status, created_at)
VALUES (
  3, 2, 3, 'product', 2, 'VIP入場券', 1, 10000, 10000, '2024-08-15',
  json('[{"lastname":"佐藤","firstname":"花子","age":34,"gender":"女性","email":"sato.hanako@example.com","phone":"080-2345-6789","birth":"1990-07-20","custom_fields":{"座席":"最前列希望","特別対応":"車椅子対応"}}]'),
  'active', datetime('now', '-1 day')
);

-- ============================================
-- テストケース3: 返金ありの予約（鈴木一郎）
-- 顧客: 鈴木一郎（ID: 3）
-- イベント: 大阪マラソン大会2024（ID: 2）
-- 商品1: フルマラソン参加（ID: 3）× 1名（返金済み）
-- 商品2: ハーフマラソン参加（ID: 4）× 1名（有効）
-- 決済1: 銀行振込、完了 → 全額返金
-- 決済2: クレジットカード、完了
-- 参加者: 鈴木一郎
-- ============================================

INSERT INTO bookings (id, booking_number, customer_id, event_id, status, booker_name, booker_email, booker_phone, created_at)
VALUES (3, 'BK20260209-003', 3, 2, 'partially_canceled', '鈴木 一郎', 'suzuki.ichiro@example.com', '090-3456-7890', datetime('now', '-5 days'));

-- 決済1（フルマラソン、返金済み）
INSERT INTO booking_payments (id, booking_number, payment_number, payment_type, payment_method, payment_status, amount, refunded_amount, payment_date, refund_date, payment_transaction_id, created_at)
VALUES (4, 'BK20260209-003', 'PAY20260209-004', 'immediate', 'bank_transfer', 'refunded', 15000, 15000, datetime('now', '-5 days'), datetime('now', '-2 days'), 'TXN-20260209-004', datetime('now', '-5 days'));

INSERT INTO booking_items (id, booking_id, payment_id, item_type, item_id, item_name, quantity, unit_price, subtotal, participation_date, participants, status, canceled_at, refund_amount, created_at)
VALUES (
  4, 3, 4, 'product', 3, 'フルマラソン参加', 1, 15000, 15000, '2024-09-20',
  json('[{"lastname":"鈴木","firstname":"一郎","age":36,"gender":"男性","email":"suzuki.ichiro@example.com","phone":"090-3456-7890","birth":"1988-11-10","custom_fields":{"Tシャツサイズ":"L","ゼッケン番号":"1234"}}]'),
  'refunded', datetime('now', '-2 days'), 15000, datetime('now', '-5 days')
);

-- 返金履歴
INSERT INTO refund_history (id, payment_id, booking_item_id, refund_amount, refund_method, refund_date, refund_reason, refund_details, created_at)
VALUES (
  1, 4, 4, 15000, 'original_payment', datetime('now', '-2 days'), 'customer_request',
  json('{"reason_category":"customer_request","detailed_reason":"怪我のため参加できなくなった","approved_by":"管理者A","approval_date":"' || datetime('now', '-2 days') || '"}'),
  datetime('now', '-2 days')
);

-- 決済2（ハーフマラソン、変更後）
INSERT INTO booking_payments (id, booking_number, payment_number, payment_type, payment_method, payment_status, amount, refunded_amount, payment_date, payment_transaction_id, created_at)
VALUES (5, 'BK20260209-003', 'PAY20260209-005', 'immediate', 'credit_card', 'completed', 8000, 0, datetime('now', '-2 days'), 'TXN-20260209-005', datetime('now', '-2 days'));

INSERT INTO booking_items (id, booking_id, payment_id, item_type, item_id, item_name, quantity, unit_price, subtotal, participation_date, participants, status, created_at)
VALUES (
  5, 3, 5, 'product', 4, 'ハーフマラソン参加', 1, 8000, 8000, '2024-09-20',
  json('[{"lastname":"鈴木","firstname":"一郎","age":36,"gender":"男性","email":"suzuki.ichiro@example.com","phone":"090-3456-7890","birth":"1988-11-10","custom_fields":{"Tシャツサイズ":"L","ゼッケン番号":"5678"}}]'),
  'active', datetime('now', '-2 days')
);

-- ============================================
-- テストケース4: 複数参加者の予約（高橋美咲）
-- 顧客: 高橋美咲（ID: 4）
-- イベント: 東京サマーフェスティバル2024（ID: 1）
-- 商品: 一般入場券（ID: 1）× 4名（家族全員）
-- 決済: クレジットカード、即時決済、完了
-- 参加者: 高橋美咲（顧客） + 家族3名（custom_fieldsあり）
-- ============================================

INSERT INTO bookings (id, booking_number, customer_id, event_id, status, booker_name, booker_email, booker_phone, created_at)
VALUES (4, 'BK20260209-004', 4, 1, 'active', '高橋 美咲', 'takahashi.misaki@example.com', '080-4567-8901', datetime('now', '-1 day'));

INSERT INTO booking_payments (id, booking_number, payment_number, payment_type, payment_method, payment_status, amount, refunded_amount, payment_date, payment_transaction_id, created_at)
VALUES (6, 'BK20260209-004', 'PAY20260209-006', 'immediate', 'credit_card', 'completed', 20000, 0, datetime('now', '-1 day'), 'TXN-20260209-006', datetime('now', '-1 day'));

INSERT INTO booking_items (id, booking_id, payment_id, item_type, item_id, item_name, quantity, unit_price, subtotal, participation_date, participants, status, created_at)
VALUES (
  6, 4, 6, 'product', 1, '一般入場券', 4, 5000, 20000, '2024-08-15',
  json('[{"lastname":"高橋","firstname":"美咲","age":32,"gender":"女性","email":"takahashi.misaki@example.com","phone":"080-4567-8901","birth":"1992-05-25","custom_fields":{"お弁当":"洋食","ドリンク":"ワイン","座席":"ファミリーエリア"}},{"lastname":"高橋","firstname":"健","age":35,"gender":"男性","email":"","phone":"080-1111-2222","birth":"1989-08-15","custom_fields":{"お弁当":"和食","ドリンク":"ビール"}},{"lastname":"高橋","firstname":"結衣","age":7,"gender":"女性","email":"","phone":"","birth":"2017-03-20","custom_fields":{"お弁当":"お子様ランチ","ドリンク":"オレンジジュース","アレルギー":"卵"}},{"lastname":"高橋","firstname":"蓮","age":5,"gender":"男性","email":"","phone":"","birth":"2019-06-10","custom_fields":{"お弁当":"お子様ランチ","ドリンク":"りんごジュース"}}]'),
  'active', datetime('now', '-1 day')
);

-- ============================================
-- テストケース5: 部分返金の予約（田中健太）
-- 顧客: 田中健太（ID: 5）
-- イベント: 東京サマーフェスティバル2024（ID: 1）
-- 商品: 一般入場券（ID: 1）× 3名
-- 決済: クレジットカード、完了 → 1名分部分返金
-- 参加者: 田中健太 + 友人2名 → 1名キャンセル
-- ============================================

INSERT INTO bookings (id, booking_number, customer_id, event_id, status, booker_name, booker_email, booker_phone, created_at)
VALUES (5, 'BK20260209-005', 5, 1, 'partially_canceled', '田中 健太', 'tanaka.kenta@example.com', '090-5678-9012', datetime('now', '-4 days'));

INSERT INTO booking_payments (id, booking_number, payment_number, payment_type, payment_method, payment_status, amount, refunded_amount, payment_date, refund_date, payment_transaction_id, created_at)
VALUES (7, 'BK20260209-005', 'PAY20260209-007', 'immediate', 'credit_card', 'partially_refunded', 15000, 5000, datetime('now', '-4 days'), datetime('now', '-1 day'), 'TXN-20260209-007', datetime('now', '-4 days'));

-- 元の予約明細（3名分）
INSERT INTO booking_items (id, booking_id, payment_id, item_type, item_id, item_name, quantity, unit_price, subtotal, participation_date, participants, status, created_at)
VALUES (
  7, 5, 7, 'product', 1, '一般入場券', 3, 5000, 15000, '2024-08-15',
  json('[{"lastname":"田中","firstname":"健太","age":29,"gender":"男性","email":"tanaka.kenta@example.com","phone":"090-5678-9012","birth":"1995-09-08","custom_fields":{"お弁当":"洋食","ドリンク":"ビール"}},{"lastname":"山本","firstname":"大輔","age":30,"gender":"男性","email":"yamamoto.daisuke@example.com","phone":"090-9999-1111","birth":"1994-02-20","custom_fields":{"お弁当":"和食","ドリンク":"日本酒"}},{"lastname":"中村","firstname":"翔太","age":28,"gender":"男性","email":"nakamura.shota@example.com","phone":"090-8888-2222","birth":"1996-11-05","custom_fields":{"お弁当":"洋食","ドリンク":"ワイン"}}]'),
  'active', datetime('now', '-4 days')
);

-- 部分返金履歴（1名分キャンセル）
INSERT INTO refund_history (id, payment_id, booking_item_id, refund_amount, refund_method, refund_date, refund_reason, refund_details, created_at)
VALUES (
  2, 7, 7, 5000, 'original_payment', datetime('now', '-1 day'), 'customer_request',
  json('{"reason_category":"customer_request","detailed_reason":"中村翔太さんが都合により参加できなくなった","approved_by":"管理者B","approval_date":"' || datetime('now', '-1 day') || '","refund_participants":[{"lastname":"中村","firstname":"翔太"}]}'),
  datetime('now', '-1 day')
);

-- ============================================
-- 確認用クエリ
-- ============================================

-- 予約一覧を確認
-- SELECT * FROM v_bookings_list ORDER BY created_at DESC;

-- 特定の予約の詳細を確認
-- SELECT 
--   b.*,
--   (SELECT json_group_array(json_object(
--     'payment_number', payment_number,
--     'payment_method', payment_method,
--     'payment_status', payment_status,
--     'amount', amount,
--     'refunded_amount', refunded_amount,
--     'net_amount', net_amount
--   )) FROM booking_payments WHERE booking_number = 'BK20260209-002') AS payments,
--   (SELECT json_group_array(json_object(
--     'item_name', item_name,
--     'quantity', quantity,
--     'subtotal', subtotal,
--     'status', status
--   )) FROM booking_items bi WHERE bi.booking_id = b.id) AS items
-- FROM bookings b
-- WHERE b.booking_number = 'BK20260209-002';

-- 決済一覧を確認
-- SELECT * FROM v_booking_payments_list ORDER BY created_at DESC;

-- 返金履歴を確認
-- SELECT 
--   rh.*,
--   bp.payment_number,
--   bi.item_name
-- FROM refund_history rh
-- LEFT JOIN booking_payments bp ON rh.payment_id = bp.id
-- LEFT JOIN booking_items bi ON rh.booking_item_id = bi.id
-- ORDER BY rh.refund_date DESC;

-- 予約件数の確認
-- SELECT 
--   (SELECT COUNT(*) FROM bookings) AS bookings_count,
--   (SELECT COUNT(*) FROM booking_payments) AS payments_count,
--   (SELECT COUNT(*) FROM booking_items) AS items_count,
--   (SELECT COUNT(*) FROM refund_history) AS refunds_count;
