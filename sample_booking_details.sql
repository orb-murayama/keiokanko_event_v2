-- 予約ID 1 にサンプルデータを追加（予約済み・未決済）

-- 参加者情報（1名の参加者）
UPDATE product_bookings SET participants = '[
  {
    "name": "田中 太郎",
    "kana": "タナカ タロウ",
    "age": 35,
    "gender": "male",
    "email": "tanaka@example.com",
    "tel": "090-1111-1111"
  }
]' WHERE id = 1;

-- 参加日
UPDATE product_bookings SET participation_date = '2025-03-15' WHERE id = 1;

-- 主催者ID、販売者ID
UPDATE product_bookings SET organizer_id = 1, vendor_id = 1 WHERE id = 1;

-- ステータスを「予約済み」「未決済」に設定
UPDATE product_bookings SET 
  booking_status = 'reserved',
  payment_status = 'pending'
WHERE id = 1;

-- クレジットカード決済情報
UPDATE product_bookings SET 
  payment_method = 'credit_card',
  payment_date = '2025-12-26 10:30:00',
  payment_transaction_id = 'TXN-20251226-ABC123456'
WHERE id = 1;

-- 設問回答
UPDATE product_bookings SET survey_answers = '[
  {
    "question": "参加動機をお聞かせください",
    "answer": "健康のためにマラソンを始めたいと思い、参加を決めました。"
  },
  {
    "question": "過去のマラソン経験はありますか？",
    "answer": "初めての参加です"
  },
  {
    "question": "食事制限はありますか？",
    "answer": "特にありません"
  },
  {
    "question": "緊急連絡先",
    "answer": "鈴木一郎 (080-9999-8888)"
  }
]' WHERE id = 1;

-- 予約ID 2 に銀行振込のサンプル（予約完了・決済完了）
UPDATE product_bookings SET 
  booking_status = 'confirmed',
  payment_status = 'paid',
  payment_method = 'bank_transfer',
  payment_date = '2025-12-25 15:20:00',
  bank_transfer_info = '{
    "bank_name": "みずほ銀行",
    "branch_name": "東京支店",
    "account_type": "普通",
    "account_number": "1234567",
    "account_holder": "株式会社イベント企画",
    "transfer_deadline": "2025-12-30"
  }',
  participation_date = '2025-03-15',
  organizer_id = 1,
  vendor_id = 1
WHERE id = 2;

-- 予約ID 3 にコンビニ決済のサンプル（キャンセル申込・返金待ち）
UPDATE product_bookings SET 
  booking_status = 'cancel_requested',
  payment_status = 'refund_pending',
  payment_method = 'convenience_store',
  payment_date = '2025-12-24 18:45:00',
  convenience_store_info = '{
    "store_name": "セブンイレブン",
    "payment_code": "12345-67890-11111",
    "payment_deadline": "2025-12-31"
  }',
  participation_date = '2025-04-01',
  organizer_id = 2,
  vendor_id = 2
WHERE id = 3;

-- 予約ID 4, 5 を追加して、全ステータスパターンをカバー（存在する場合のみ更新）
UPDATE product_bookings SET 
  booking_status = 'cancelled',
  payment_status = 'refunded'
WHERE id = 4;

UPDATE product_bookings SET 
  booking_status = 'confirmed',
  payment_status = 'paid'
WHERE id = 5;
