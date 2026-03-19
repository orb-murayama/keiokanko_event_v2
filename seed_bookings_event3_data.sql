-- 予約テストデータ（イベント3: 東京1日観光ツアー）
-- 作成日: 2026-02-12

-- 予約1: 山田太郎 - スタンダードプラン (大人2名、子供1名) - クレジット決済完了
INSERT INTO bookings (
  booking_number, customer_id, event_id, status, 
  booker_name, booker_email, booker_phone,
  additional_info, remarks, created_at, modified_at
) VALUES (
  'BK20260215-001', 1, 3, 'confirmed',
  '山田太郎', 'yamada.taro@example.com', '090-1234-5678',
  '子供は6歳です。アレルギーはありません。', '',
  '2026-02-15 10:30:00', '2026-02-15 10:30:00'
);

INSERT INTO booking_payments (
  booking_number, payment_number, payment_type, payment_method, payment_status,
  amount, refunded_amount,
  payment_date, payment_due_date, refund_date,
  payment_transaction_id, payment_details, remarks,
  created_at, modified_at
) VALUES (
  'BK20260215-001', 'PAY20260215-001', 'booking', 'credit_card', 'completed',
  32000, 0,
  '2026-02-15 10:35:00', NULL, NULL,
  'ch_3QaBcD1234567890', 'Visa **** 1234', '',
  '2026-02-15 10:35:00', '2026-02-15 10:35:00'
);

INSERT INTO booking_items (
  booking_id, payment_id, item_type, item_id, item_name,
  stock_id, price_category, quantity, unit_price, subtotal,
  participation_date, participants, status,
  canceled_at, cancel_reason, refund_amount, item_details, remarks,
  created_at, modified_at
) VALUES 
(1, 1, 'product', 1, '東京1日観光ツアー スタンダードプラン',
 5, '大人', 2, 12000, 24000,
 '2026-03-15', '山田太郎、山田花子', 'active',
 NULL, NULL, 0, '{"price_name":"大人（13歳以上）"}', '',
 '2026-02-15 10:35:00', '2026-02-15 10:35:00'),
(1, 1, 'product', 1, '東京1日観光ツアー スタンダードプラン',
 5, '子供', 1, 8000, 8000,
 '2026-03-15', '山田太郎', 'active',
 NULL, NULL, 0, '{"price_name":"子供（6-12歳）"}', '',
 '2026-02-15 10:35:00', '2026-02-15 10:35:00');

-- 予約2: 鈴木花子 - プレミアムプラン (大人1名) - 銀行振込待ち
INSERT INTO bookings (
  booking_number, customer_id, event_id, status,
  booker_name, booker_email, booker_phone,
  additional_info, remarks, created_at, modified_at
) VALUES (
  'BK20260216-001', 2, 3, 'pending',
  '鈴木花子', 'suzuki.hanako@example.com', '080-2345-6789',
  '英語ガイドの方にお会いするのを楽しみにしています。', '',
  '2026-02-16 14:20:00', '2026-02-16 14:20:00'
);

INSERT INTO booking_payments (
  booking_number, payment_number, payment_type, payment_method, payment_status,
  amount, refunded_amount,
  payment_date, payment_due_date, refund_date,
  payment_transaction_id, payment_details, remarks,
  created_at, modified_at
) VALUES (
  'BK20260216-001', 'PAY20260216-001', 'booking', 'bank_transfer', 'pending',
  18000, 0,
  NULL, '2026-02-23 23:59:59', NULL,
  NULL, '三菱UFJ銀行 新宿支店 普通 1234567', '',
  '2026-02-16 14:20:00', '2026-02-16 14:20:00'
);

INSERT INTO booking_items (
  booking_id, payment_id, item_type, item_id, item_name,
  stock_id, price_category, quantity, unit_price, subtotal,
  participation_date, participants, status,
  canceled_at, cancel_reason, refund_amount, item_details, remarks,
  created_at, modified_at
) VALUES (
  2, 2, 'product', 2, '東京1日観光ツアー プレミアムプラン',
  40, '大人', 1, 18000, 18000,
  '2026-03-22', '鈴木花子', 'active',
  NULL, NULL, 0, '{"price_name":"大人（13歳以上）"}', '',
  '2026-02-16 14:20:00', '2026-02-16 14:20:00'
);

-- 予約3: 田中一郎 - プライベートツアー (3-4名) - クレジット決済完了
INSERT INTO bookings (
  booking_number, customer_id, event_id, status,
  booker_name, booker_email, booker_phone,
  additional_info, remarks, created_at, modified_at
) VALUES (
  'BK20260217-001', 3, 3, 'confirmed',
  '田中一郎', 'tanaka.ichiro@example.com', '090-3456-7890',
  '家族4名でプライベートツアーを希望します。築地市場を追加したいです。', '',
  '2026-02-17 09:15:00', '2026-02-17 09:15:00'
);

INSERT INTO booking_payments (
  booking_number, payment_number, payment_type, payment_method, payment_status,
  amount, refunded_amount,
  payment_date, payment_due_date, refund_date,
  payment_transaction_id, payment_details, remarks,
  created_at, modified_at
) VALUES (
  'BK20260217-001', 'PAY20260217-001', 'booking', 'credit_card', 'completed',
  100000, 0,
  '2026-02-17 09:20:00', NULL, NULL,
  'ch_4RcDeF2345678901', 'Mastercard **** 5678', '',
  '2026-02-17 09:20:00', '2026-02-17 09:20:00'
);

INSERT INTO booking_items (
  booking_id, payment_id, item_type, item_id, item_name,
  stock_id, price_category, quantity, unit_price, subtotal,
  participation_date, participants, status,
  canceled_at, cancel_reason, refund_amount, item_details, remarks,
  created_at, modified_at
) VALUES (
  3, 3, 'product', 3, '東京プライベート観光ツアー（貸切）',
  52, '3-4名', 1, 100000, 100000,
  '2026-04-05', '田中一郎、田中美咲、田中太郎、田中花子', 'active',
  NULL, NULL, 0, '{"price_name":"3-4名様"}', '',
  '2026-02-17 09:20:00', '2026-02-17 09:20:00'
);

-- 予約4: 渡辺優希 - スタンダードプラン (大人2名) - キャンセル済み（3日前）
INSERT INTO bookings (
  booking_number, customer_id, event_id, status,
  booker_name, booker_email, booker_phone,
  additional_info, remarks, created_at, modified_at
) VALUES (
  'BK20260218-001', 4, 3, 'cancelled',
  '渡辺優希', 'watanabe.yuki@example.com', '080-4567-8901',
  '急用のためキャンセルさせていただきます。', 'キャンセル料30%適用',
  '2026-02-18 16:45:00', '2026-02-20 11:30:00'
);

INSERT INTO booking_payments (
  booking_number, payment_number, payment_type, payment_method, payment_status,
  amount, refunded_amount,
  payment_date, payment_due_date, refund_date,
  payment_transaction_id, payment_details, remarks,
  created_at, modified_at
) VALUES (
  'BK20260218-001', 'PAY20260218-001', 'booking', 'credit_card', 'refunded',
  24000, 16800,
  '2026-02-18 16:50:00', NULL, '2026-02-20 14:00:00',
  'ch_5SdEfG3456789012', 'Visa **** 9012', 'キャンセル料30%（7,200円）を差し引いて返金',
  '2026-02-18 16:50:00', '2026-02-20 14:00:00'
);

INSERT INTO booking_items (
  booking_id, payment_id, item_type, item_id, item_name,
  stock_id, price_category, quantity, unit_price, subtotal,
  participation_date, participants, status,
  canceled_at, cancel_reason, refund_amount, item_details, remarks,
  created_at, modified_at
) VALUES (
  4, 4, 'product', 1, '東京1日観光ツアー スタンダードプラン',
  11, '大人', 2, 12000, 24000,
  '2026-02-23', '渡辺優希、渡辺健二', 'cancelled',
  '2026-02-20 11:30:00', '急用のため', 16800, '{"price_name":"大人（13歳以上）","cancellation_rate":30}', '',
  '2026-02-18 16:50:00', '2026-02-20 11:30:00'
);

INSERT INTO refund_history (
  payment_id, booking_item_id, refund_amount, refund_method,
  refund_date, refund_transaction_id, refund_reason, refund_details, remarks,
  created_at
) VALUES (
  4, 4, 16800, 'credit_card',
  '2026-02-20 14:00:00', 're_1AbCdE4567890123', '予約キャンセル',
  'キャンセル料30%適用。3日前キャンセル', '',
  '2026-02-20 14:00:00'
);

-- 予約5: 伊藤健二 - スタンダードプラン (大人2名、子供2名、幼児1名) - コンビニ決済待ち
INSERT INTO bookings (
  booking_number, customer_id, event_id, status,
  booker_name, booker_email, booker_phone,
  additional_info, remarks, created_at, modified_at
) VALUES (
  'BK20260219-001', 5, 3, 'pending',
  '伊藤健二', 'ito.kenji@example.com', '090-5678-9012',
  '子供の食事でアレルギー対応をお願いします（卵・小麦）。幼児は座席不要です。', '',
  '2026-02-19 13:10:00', '2026-02-19 13:10:00'
);

INSERT INTO booking_payments (
  booking_number, payment_number, payment_type, payment_method, payment_status,
  amount, refunded_amount,
  payment_date, payment_due_date, refund_date,
  payment_transaction_id, payment_details, remarks,
  created_at, modified_at
) VALUES (
  'BK20260219-001', 'PAY20260219-001', 'booking', 'convenience_store', 'pending',
  40000, 0,
  NULL, '2026-02-22 23:59:59', NULL,
  NULL, 'ファミリーマート 支払番号: 12345678901234', '',
  '2026-02-19 13:10:00', '2026-02-19 13:10:00'
);

INSERT INTO booking_items (
  booking_id, payment_id, item_type, item_id, item_name,
  stock_id, price_category, quantity, unit_price, subtotal,
  participation_date, participants, status,
  canceled_at, cancel_reason, refund_amount, item_details, remarks,
  created_at, modified_at
) VALUES 
(5, 5, 'product', 1, '東京1日観光ツアー スタンダードプラン',
 18, '大人', 2, 12000, 24000,
 '2026-03-29', '伊藤健二、伊藤愛', 'active',
 NULL, NULL, 0, '{"price_name":"大人（13歳以上）"}', '',
 '2026-02-19 13:10:00', '2026-02-19 13:10:00'),
(5, 5, 'product', 1, '東京1日観光ツアー スタンダードプラン',
 18, '子供', 2, 8000, 16000,
 '2026-03-29', '伊藤太郎、伊藤花子', 'active',
 NULL, NULL, 0, '{"price_name":"子供（6-12歳）","allergy":"卵・小麦"}', '',
 '2026-02-19 13:10:00', '2026-02-19 13:10:00'),
(5, 5, 'product', 1, '東京1日観光ツアー スタンダードプラン',
 18, '幼児', 1, 0, 0,
 '2026-03-29', '伊藤結衣', 'active',
 NULL, NULL, 0, '{"price_name":"幼児（5歳以下・座席なし）"}', '',
 '2026-02-19 13:10:00', '2026-02-19 13:10:00');

-- 在庫を更新（予約により減少）
-- スタンダードプラン 2026-03-15（予約1で2席使用）
UPDATE product_stocks SET booked = 2 WHERE id = 5;

-- プレミアムプラン 2026-03-22（予約2で1席使用）
UPDATE product_stocks SET booked = 1 WHERE id = 40;

-- プライベートツアー 2026-04-05（予約3で1組使用）
UPDATE product_stocks SET booked = 1 WHERE id = 52;

-- スタンダードプラン 2026-02-23（予約4キャンセルで在庫復活、booked = 0のまま）
-- キャンセル済みなので在庫は減らさない

-- スタンダードプラン 2026-03-29（予約5で2席使用）
UPDATE product_stocks SET booked = 2 WHERE id = 18;
