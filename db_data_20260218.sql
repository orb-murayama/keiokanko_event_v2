-- Database Data Export
-- Date: 2026-02-18 01:00:36
-- ========================================

PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-- Table: _cf_METADATA (1 rows)
INSERT INTO _cf_METADATA (key,value) VALUES (2,155);

-- Table: accounts (10 rows)
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (1,'admin','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','システム管理者','admin@keio-kanko.co.jp',NULL,'admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio',NULL,NULL,NULL,'03-1234-5678','090-1234-5678');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (2,'keio_honsha','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','本社管理者','honsha@keio-kanko.co.jp',NULL,'staff',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','HON','["HON","SHI","TAC","HNO"]',NULL,'03-1234-5678','090-1111-2222');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (3,'keio_shinjuku','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','新宿支店担当','shinjuku@keio-kanko.co.jp',NULL,'staff',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','SHI','["SHI"]',NULL,'03-2345-6789','090-2222-3333');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (4,'keio_tachikawa','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','立川支店担当','tachikawa@keio-kanko.co.jp',NULL,'staff',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','keio','TAC','["TAC"]',NULL,'042-1234-5678','090-3333-4444');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (5,'keio_hachioji','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','八王子支店担当','hachioji@keio-kanko.co.jp',NULL,'branch',1,'2026-02-12 07:16:29','2026-02-18 00:51:31','keio','HON','["HON","HNO"]',NULL,'042-2345-6789','090-4444-5555');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (6,'client_keio','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','田中太郎','tanaka@keio-kanko.co.jp',NULL,'branch',1,'2026-02-12 07:16:29','2026-02-18 00:51:05','keio','HON',NULL,'2025-12-31','03-1234-5678','090-5555-6666');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (7,'client_tabinotomo','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','鈴木一郎','suzuki@tabinotomo.co.jp',2,'client_admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','client',NULL,NULL,'2025-12-31','03-2345-6789','090-6666-7777');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (8,'client_global','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','Michael Smith','smith@globaltours.com',3,'client_admin',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','client',NULL,NULL,'2025-12-31','03-3456-7890','090-7777-8888');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (9,'organizer_keio_tours','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','山田太郎','yamada@keio-tours.co.jp',NULL,'organizer',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','organizer',NULL,NULL,'2025-12-31','03-1111-2222','090-8888-9999');
INSERT INTO accounts (id,login_id,password,person_name,email,client_id,role,enable_flg,created_at,modified_at,account_type,primary_branch_code,accessible_branches,expiration_date,tel,mobile) VALUES (10,'organizer_tama','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','佐藤花子','sato@tama-tourism.jp',NULL,'organizer',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','organizer',NULL,NULL,'2025-12-31','042-2222-3333','090-9999-0000');

-- Table: booking_emails (5 rows)
INSERT INTO booking_emails (id,booking_number,from_email,to_email,bcc_email,subject,body,scheduled_send_at,send_status,sent_at,error_message,template_id,created_at,modified_at) VALUES (2,'BK20260216-001','noreply@example.com','suzuki.hanako@example.com','admin@example.com','【東京1日観光ツアー 英語ガイド付き】ご予約確認','鈴木花子 様

ご予約ありがとうございます。
予約番号: BK20260216-001','2026-02-13 10:00:00','pending',NULL,NULL,NULL,'2026-02-12 08:53:34','2026-02-12 08:53:34');
INSERT INTO booking_emails (id,booking_number,from_email,to_email,bcc_email,subject,body,scheduled_send_at,send_status,sent_at,error_message,template_id,created_at,modified_at) VALUES (3,'BK20260215-001','noreply@example.com','yamada.taro@example.com',NULL,'【東京1日観光ツアー 英語ガイド付き】ご予約確認','山田太郎 様

この度は東京1日観光ツアー 英語ガイド付きにお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: BK20260215-001
イベント名: 東京1日観光ツアー 英語ガイド付き
開催期間: 2026-01-01 〜 2026-12-31

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。','2026-02-13 10:00:00','pending',NULL,NULL,1,'2026-02-12 08:55:42','2026-02-12 08:55:42');
INSERT INTO booking_emails (id,booking_number,from_email,to_email,bcc_email,subject,body,scheduled_send_at,send_status,sent_at,error_message,template_id,created_at,modified_at) VALUES (4,'BK20260215-001','noreply@example.com','yamada.taro@example.com',NULL,'【東京1日観光ツアー 英語ガイド付き】ご予約確認','山田太郎 様

この度は東京1日観光ツアー 英語ガイド付きにお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: BK20260215-001
イベント名: 東京1日観光ツアー 英語ガイド付き
開催期間: 2026-01-01 〜 2026-12-31

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。','2026-02-13 10:00:00','pending',NULL,NULL,1,'2026-02-12 08:58:36','2026-02-12 08:58:36');
INSERT INTO booking_emails (id,booking_number,from_email,to_email,bcc_email,subject,body,scheduled_send_at,send_status,sent_at,error_message,template_id,created_at,modified_at) VALUES (5,'BK20260215-001','noreply@example.com','yamada.taro@example.com',NULL,'【東京1日観光ツアー 英語ガイド付き】ご予約確認','山田太郎 様

この度は東京1日観光ツアー 英語ガイド付きにお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: BK20260215-001
イベント名: 東京1日観光ツアー 英語ガイド付き
開催期間: 2026-01-01 〜 2026-12-31

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。','2026-02-13 10:00:00','pending',NULL,NULL,1,'2026-02-12 09:03:14','2026-02-12 09:03:14');
INSERT INTO booking_emails (id,booking_number,from_email,to_email,bcc_email,subject,body,scheduled_send_at,send_status,sent_at,error_message,template_id,created_at,modified_at) VALUES (6,'BK20260215-001','noreply@example.com','yamada.taro@example.com',NULL,'【東京1日観光ツアー 英語ガイド付き】ご予約確認','山田太郎 様

この度は東京1日観光ツアー 英語ガイド付きにお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: BK20260215-001
イベント名: 東京1日観光ツアー 英語ガイド付き
開催期間: 2026-01-01 〜 2026-12-31

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。','2026-02-13 10:00:00','pending',NULL,NULL,1,'2026-02-12 09:05:54','2026-02-12 09:05:54');

-- Table: booking_files (1 rows)
INSERT INTO booking_files (id,booking_number,file_key,original_filename,display_filename,file_size,download_limit,download_count,created_at,modified_at) VALUES (1,'BK20260215-001','documents/1770885342228-領収書テンプレート_BK20260215-001_20260212.pdf','領収書テンプレート_BK20260215-001_20260212.pdf','領収書テンプレート_BK20260215-001_20260212.pdf',223289,1,0,'2026-02-12 08:35:42','2026-02-12 08:35:51');

-- Table: booking_items (9 rows)
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (1,1,1,'product',1,'東京1日観光ツアー スタンダードプラン',5,'大人',2,12000,24000,'2026-03-15','[{"lastname":"山田","firstname":"太郎","age":"","gender":"","email":"","phone":"","birth":"","custom_fields":{}},{"lastname":"山田","firstname":"ハナコ","age":30,"gender":"女性","email":"","phone":"","birth":"","custom_fields":{}}]','active',NULL,NULL,0,'{"price_name":"大人（13歳以上）"}','','2026-02-15 10:35:00','2026-02-12 09:39:27');
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (2,1,1,'product',1,'東京1日観光ツアー スタンダードプラン',5,'子供',1,8000,8000,'2026-03-15','[{"lastname":"山田","firstname":"一郎","age":22,"gender":"","email":"","phone":"","birth":"","custom_fields":{}}]','active',NULL,NULL,0,'{"price_name":"子供（6-12歳）"}','','2026-02-15 10:35:00','2026-02-12 09:39:28');
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (3,2,2,'product',2,'東京1日観光ツアー プレミアムプラン',40,'大人',1,18000,18000,'2026-03-22','鈴木花子','active',NULL,NULL,0,'{"price_name":"大人（13歳以上）"}','','2026-02-16 14:20:00','2026-02-16 14:20:00');
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (4,3,3,'product',3,'東京プライベート観光ツアー（貸切）',52,'3-4名',1,100000,100000,'2026-04-05','田中一郎、田中美咲、田中太郎、田中花子','active',NULL,NULL,0,'{"price_name":"3-4名様"}','','2026-02-17 09:20:00','2026-02-17 09:20:00');
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (5,4,4,'product',1,'東京1日観光ツアー スタンダードプラン',11,'大人',2,12000,24000,'2026-02-23','渡辺優希、渡辺健二','cancelled','2026-02-20 11:30:00','急用のため',16800,'{"price_name":"大人（13歳以上）","cancellation_rate":30}','','2026-02-18 16:50:00','2026-02-20 11:30:00');
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (6,5,5,'product',1,'東京1日観光ツアー スタンダードプラン',18,'大人',2,12000,24000,'2026-03-29','伊藤健二、伊藤愛','active',NULL,NULL,0,'{"price_name":"大人（13歳以上）"}','','2026-02-19 13:10:00','2026-02-19 13:10:00');
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (7,5,5,'product',1,'東京1日観光ツアー スタンダードプラン',18,'子供',2,8000,16000,'2026-03-29','伊藤太郎、伊藤花子','active',NULL,NULL,0,'{"price_name":"子供（6-12歳）","allergy":"卵・小麦"}','','2026-02-19 13:10:00','2026-02-19 13:10:00');
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (8,5,5,'product',1,'東京1日観光ツアー スタンダードプラン',18,'幼児',1,0,0,'2026-03-29','伊藤結衣','active',NULL,NULL,0,'{"price_name":"幼児（5歳以下・座席なし）"}','','2026-02-19 13:10:00','2026-02-19 13:10:00');
INSERT INTO booking_items (id,booking_id,payment_id,item_type,item_id,item_name,stock_id,price_category,quantity,unit_price,subtotal,participation_date,participants,status,canceled_at,cancel_reason,refund_amount,item_details,remarks,created_at,modified_at) VALUES (9,1,NULL,'product',2,'東京1日観光ツアー プレミアムプラン',NULL,NULL,1,18000,18000,'2026-02-14','[{"lastname":"ヤマダ","firstname":"タロウ","age":"","gender":"","email":"","phone":"","birth":"","custom_fields":{"Dietary Restrictions / 食事制限":"No restrictions / なし","Special Requests / 特別なご要望":"ああああ","Hotel Name (if pickup needed) / ホテル名（送迎希望の場合）":"ざざ"}}]','active',NULL,NULL,0,NULL,NULL,'2026-02-12 08:07:31','2026-02-12 09:39:28');

-- Table: booking_messages (0 rows)

-- Table: booking_payments (6 rows)
INSERT INTO booking_payments (id,booking_number,payment_number,payment_type,payment_method,payment_status,amount,refunded_amount,payment_date,payment_due_date,refund_date,payment_transaction_id,payment_details,remarks,created_at,modified_at) VALUES (1,'BK20260215-001','PAY20260215-001','booking','credit_card','completed',32000,0,32000,'2026-02-15 10:35:00',NULL,NULL,'ch_3QaBcD1234567890','Visa **** 1234','','2026-02-15 10:35:00','2026-02-15 10:35:00');
INSERT INTO booking_payments (id,booking_number,payment_number,payment_type,payment_method,payment_status,amount,refunded_amount,payment_date,payment_due_date,refund_date,payment_transaction_id,payment_details,remarks,created_at,modified_at) VALUES (2,'BK20260216-001','PAY20260216-001','booking','bank_transfer','pending',18000,0,18000,NULL,'2026-02-23 23:59:59',NULL,NULL,'三菱UFJ銀行 新宿支店 普通 1234567','','2026-02-16 14:20:00','2026-02-16 14:20:00');
INSERT INTO booking_payments (id,booking_number,payment_number,payment_type,payment_method,payment_status,amount,refunded_amount,payment_date,payment_due_date,refund_date,payment_transaction_id,payment_details,remarks,created_at,modified_at) VALUES (3,'BK20260217-001','PAY20260217-001','booking','credit_card','completed',100000,0,100000,'2026-02-17 09:20:00',NULL,NULL,'ch_4RcDeF2345678901','Mastercard **** 5678','','2026-02-17 09:20:00','2026-02-17 09:20:00');
INSERT INTO booking_payments (id,booking_number,payment_number,payment_type,payment_method,payment_status,amount,refunded_amount,payment_date,payment_due_date,refund_date,payment_transaction_id,payment_details,remarks,created_at,modified_at) VALUES (4,'BK20260218-001','PAY20260218-001','booking','credit_card','refunded',24000,16800,7200,'2026-02-18 16:50:00',NULL,'2026-02-20 14:00:00','ch_5SdEfG3456789012','Visa **** 9012','キャンセル料30%（7,200円）を差し引いて返金','2026-02-18 16:50:00','2026-02-20 14:00:00');
INSERT INTO booking_payments (id,booking_number,payment_number,payment_type,payment_method,payment_status,amount,refunded_amount,payment_date,payment_due_date,refund_date,payment_transaction_id,payment_details,remarks,created_at,modified_at) VALUES (5,'BK20260219-001','PAY20260219-001','booking','convenience_store','pending',40000,0,40000,NULL,'2026-02-22 23:59:59',NULL,NULL,'ファミリーマート 支払番号: 12345678901234','','2026-02-19 13:10:00','2026-02-19 13:10:00');
INSERT INTO booking_payments (id,booking_number,payment_number,payment_type,payment_method,payment_status,amount,refunded_amount,payment_date,payment_due_date,refund_date,payment_transaction_id,payment_details,remarks,created_at,modified_at) VALUES (6,'BK20260215-001','PAY20260212-001','deferred','convenience_store','pending',18000,0,18000,NULL,'2026-02-17',NULL,NULL,NULL,'商品追加に伴う追加決済','2026-02-12 08:08:05','2026-02-12 08:08:05');

-- Table: bookings (5 rows)
INSERT INTO bookings (id,booking_number,customer_id,event_id,status,booker_name,booker_email,booker_phone,additional_info,remarks,created_at,modified_at) VALUES (1,'BK20260215-001',1,3,'confirmed','山田太郎','yamada.taro@example.com','090-1234-5678','子供は6歳です。アレルギーはありません。','','2026-02-15 10:30:00','2026-02-15 10:30:00');
INSERT INTO bookings (id,booking_number,customer_id,event_id,status,booker_name,booker_email,booker_phone,additional_info,remarks,created_at,modified_at) VALUES (2,'BK20260216-001',2,3,'pending','鈴木花子','suzuki.hanako@example.com','080-2345-6789','英語ガイドの方にお会いするのを楽しみにしています。','','2026-02-16 14:20:00','2026-02-16 14:20:00');
INSERT INTO bookings (id,booking_number,customer_id,event_id,status,booker_name,booker_email,booker_phone,additional_info,remarks,created_at,modified_at) VALUES (3,'BK20260217-001',3,3,'confirmed','田中一郎','tanaka.ichiro@example.com','090-3456-7890','家族4名でプライベートツアーを希望します。築地市場を追加したいです。','','2026-02-17 09:15:00','2026-02-17 09:15:00');
INSERT INTO bookings (id,booking_number,customer_id,event_id,status,booker_name,booker_email,booker_phone,additional_info,remarks,created_at,modified_at) VALUES (4,'BK20260218-001',4,3,'cancelled','渡辺優希','watanabe.yuki@example.com','080-4567-8901','急用のためキャンセルさせていただきます。','キャンセル料30%適用','2026-02-18 16:45:00','2026-02-20 11:30:00');
INSERT INTO bookings (id,booking_number,customer_id,event_id,status,booker_name,booker_email,booker_phone,additional_info,remarks,created_at,modified_at) VALUES (5,'BK20260219-001',5,3,'pending','伊藤健二','ito.kenji@example.com','090-5678-9012','子供の食事でアレルギー対応をお願いします（卵・小麦）。幼児は座席不要です。','','2026-02-19 13:10:00','2026-02-19 13:10:00');

-- Table: branches (26 rows)
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (1,'HON','本社','京王観光本社',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (2,'SHI','新宿','京王観光新宿支店',2,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (3,'TAC','立川','京王観光立川支店',3,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (4,'HNO','八王子','京王観光八王子支店',4,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (5,'CHO','調布','京王観光調布支店',5,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (6,'FUC','府中','京王観光府中支店',6,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (7,'SAN','三鷹','京王観光三鷹支店',7,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (8,'KOK','国分寺','京王観光国分寺支店',8,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (9,'01','東京中央支店','東京中央支店:01',1,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (10,'02','東京南支店','東京南支店:02',2,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (11,'03','東京東支店','東京東支店:03',3,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (12,'04','イベント＆ツアー センター','イベント＆ツアー センター:04',4,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (13,'05','さいたま支店','さいたま支店:05',5,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (14,'06','調布支店','調布支店:06',6,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (15,'07','立川支店','立川支店:07',7,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (16,'08','八王子支店','八王子支店:08',8,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (17,'09','神奈川北支店','神奈川北支店:09',9,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (18,'10','町田営業所','町田営業所:10',10,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (19,'11','団体旅行営業部スポーツセールス担当','団体旅行営業部スポーツセールス担当:11',11,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (20,'12','札幌支店','札幌支店:12',12,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (21,'13','仙台支店','仙台支店:13',13,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (22,'14','大阪支店','大阪支店:14',14,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (23,'15','大阪西支店','大阪西支店:15',15,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (24,'16','福岡支店','福岡支店:16',16,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (25,'17','旅行事業部','旅行事業部:17',17,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');
INSERT INTO branches (id,branch_code,branch_name,branch_full_name,display_order,enable_flg,created_at,modified_at) VALUES (26,'18','経営管理部','経営管理部:18',18,1,'2026-02-12 07:46:43','2026-02-12 07:46:43');

-- Table: categories (0 rows)

-- Table: clients (5 rows)
INSERT INTO clients (id,name,contactable_person,branch_office,accounted_person,zip,pref_id,addr,tel,fax,email,password,remarks,reg_flg,group_id,created_at,modified_at,client_code,position) VALUES (1,'京王観光株式会社','田中太郎','本社','経理部 山田花子','160-0023',13,'新宿区西新宿1-1-1','03-1234-5678','03-1234-5679','tanaka@keio-kanko.co.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','主要取引先',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI001','営業部長');
INSERT INTO clients (id,name,contactable_person,branch_office,accounted_person,zip,pref_id,addr,tel,fax,email,password,remarks,reg_flg,group_id,created_at,modified_at,client_code,position) VALUES (2,'株式会社旅の友','鈴木一郎','東京支店','営業部 佐藤次郎','100-0001',13,'千代田区千代田1-1','03-2345-6789','03-2345-6780','suzuki@tabinotomo.co.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','VIP顧客',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI002','支店長');
INSERT INTO clients (id,name,contactable_person,branch_office,accounted_person,zip,pref_id,addr,tel,fax,email,password,remarks,reg_flg,group_id,created_at,modified_at,client_code,position) VALUES (3,'グローバルツアーズ','Michael Smith','日本支社','Finance Team','105-0001',13,'港区虎ノ門2-2-2','03-3456-7890','03-3456-7891','smith@globaltours.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','海外顧客',1,2,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI003','Manager');
INSERT INTO clients (id,name,contactable_person,branch_office,accounted_person,zip,pref_id,addr,tel,fax,email,password,remarks,reg_flg,group_id,created_at,modified_at,client_code,position) VALUES (4,'日本トラベル協会','高橋美咲','事務局','総務課 伊藤健太','150-0001',13,'渋谷区神宮前3-3-3','03-4567-8901','03-4567-8902','takahashi@jta.or.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','協会関係',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI004','事務局長');
INSERT INTO clients (id,name,contactable_person,branch_office,accounted_person,zip,pref_id,addr,tel,fax,email,password,remarks,reg_flg,group_id,created_at,modified_at,client_code,position) VALUES (5,'エコツーリズム推進協議会','中村環','企画部','企画課 小林緑','102-0072',13,'千代田区飯田橋4-4-4','03-5678-9012','03-5678-9013','nakamura@eco-tourism.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','エコツアー専門',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI005','企画部長');

-- Table: customers (10 rows)
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (1,'山田','太郎','ヤマダ','タロウ',1,'1985-04-15','090-1234-5678','03-1234-5678',NULL,'yamada.taro@example.com','160-0023',13,NULL,'新宿区西新宿1-1-1 マンションA 101',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (2,'鈴木','花子','スズキ','ハナコ',2,'1990-08-20','090-2345-6789','03-2345-6789',NULL,'suzuki.hanako@example.com','150-0001',13,NULL,'渋谷区神宮前2-2-2 ビルB 202',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (3,'田中','一郎','タナカ','イチロウ',1,'1978-12-05','090-3456-7890','03-3456-7890',NULL,'tanaka.ichiro@example.com','100-0001',13,NULL,'千代田区千代田3-3-3 ハイツC 303',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (4,'渡辺','優希','ワタナベ','ユウキ',2,'1995-03-10','090-4567-8901','042-1234-5678',NULL,'watanabe.yuki@example.com','190-0012',13,NULL,'立川市曙町4-4-4 コーポD 404',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (5,'伊藤','健二','イトウ','ケンジ',1,'1982-07-25','090-5678-9012','03-4567-8901',NULL,'ito.kenji@example.com','105-0001',13,NULL,'港区虎ノ門5-5-5 タワーE 505',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (6,'小林','愛','コバヤシ','アイ',2,'1988-11-30','090-6789-0123','03-5678-9012',NULL,'kobayashi.ai@example.com','102-0072',13,NULL,'千代田区飯田橋6-6-6 マンションF 606',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (7,'佐藤','誠','サトウ','マコト',1,'1975-02-18','090-7890-1234','0460-1234-5678',NULL,'sato.makoto@example.com','250-0311',14,NULL,'足柄下郡箱根町湯本7-7-7',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (8,'高橋','美咲','タカハシ','ミサ',2,'1992-06-12','090-8901-2345','0555-1234-5678',NULL,'takahashi.misa@example.com','403-0005',19,NULL,'富士吉田市上吉田8-8-8',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (9,'中村','潤','ナカムラ','ジュン',1,'1987-09-08','090-9012-3456','0422-1234-5678',NULL,'nakamura.jun@example.com','180-0004',13,NULL,'武蔵野市吉祥寺本町9-9-9',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers (id,family_name,first_name,family_kana,first_kana,sex,birth,mobile,tel,fax,email,zip,pref_id,city,addr,bldg,password,payment,answer,remark,mailme_flg,contact,company_name,department_name,free1,free2,free3,free4,free5,free6,agent_number,enable_flg,payment_select,payment_status,uniqid,created_at,modified_at,canceled_at,branch_code,address) VALUES (10,'山本','結衣','ヤマモト','ユイ',2,'1998-01-22','090-0123-4567','042-2345-6789',NULL,'yamamoto.yui@example.com','183-0055',13,NULL,'府中市府中町10-10-10',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);

-- Table: d1_migrations (6 rows)
INSERT INTO d1_migrations (id,name,applied_at) VALUES (1,'0000_consolidated_schema.sql','2026-02-18 00:45:22');
INSERT INTO d1_migrations (id,name,applied_at) VALUES (2,'0022_mark_all_migrations_applied.sql','2026-02-18 00:45:22');
INSERT INTO d1_migrations (id,name,applied_at) VALUES (3,'0023_create_event_staff_table.sql','2026-02-18 00:45:23');
INSERT INTO d1_migrations (id,name,applied_at) VALUES (4,'0024_add_image_url_to_products.sql','2026-02-18 00:45:23');
INSERT INTO d1_migrations (id,name,applied_at) VALUES (5,'0025_add_image_url_to_events.sql','2026-02-18 00:45:23');
INSERT INTO d1_migrations (id,name,applied_at) VALUES (6,'0026_add_image_url_to_options.sql','2026-02-18 00:45:24');

-- Table: email_templates (1 rows)
INSERT INTO email_templates (id,template_name,description,from_email,bcc_email,subject_template,body_template,is_active,created_at,modified_at) VALUES (1,'予約確認メール','お客様への予約確認メール','noreply@example.com',NULL,'【{{event_name}}】ご予約確認','{{booker_name}} 様

この度は{{event_name}}にお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: {{booking_number}}
イベント名: {{event_name}}
開催期間: {{event_start_date}} 〜 {{event_end_date}}

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。',1,'2026-02-18 00:45:22','2026-02-18 00:45:22');

-- Table: event_form_fields (0 rows)

-- Table: event_staff (0 rows)

-- Table: events (5 rows)
INSERT INTO events (id,name,detail,contact,remarks,question,postage,thanks_msg,note,client_id,company_flg,enable_flg,payment_flg,payment_cd,created_at,modified_at,customer_client_id,vendor_id,event_url,category,deleted_at,date_selection_type,location,payment_methods,credit_fee_type,bank_fee_type,convenience_fee_type,registration_start_date,registration_end_date,event_start_date,event_end_date,admin_email,admin_name,name_en,detail_en,location_en,contact_en,remarks_en,thanks_msg_en,organizer_id,admin_login_start_date,admin_login_end_date,admin_cc_email,sender_name,sender_email,email_signature,email_signature_en,bank_name,bank_branch,bank_account_type,bank_account_number,bank_account_name,bank_transfer_deadline,store_code,convenience_payment_deadline,available_convenience_stores,credit_fee_percentage,credit_fee_fixed,bank_fee_percentage,bank_fee_fixed,convenience_fee_percentage,convenience_fee_fixed,form_field_settings,auto_reply_enabled,auto_reply_credit_payment,auto_reply_bank_payment,auto_reply_convenience_payment,auto_reply_credit_cancel,auto_reply_bank_cancel,auto_reply_convenience_cancel,auto_reply_credit_refund,auto_reply_bank_deposit,auto_reply_bank_refund,auto_reply_convenience_deposit,auto_reply_convenience_refund,auto_reply_credit_payment_en,auto_reply_bank_payment_en,auto_reply_convenience_payment_en,auto_reply_credit_cancel_en,auto_reply_bank_cancel_en,auto_reply_convenience_cancel_en,auto_reply_credit_refund_en,auto_reply_bank_deposit_en,auto_reply_bank_refund_en,auto_reply_convenience_deposit_en,auto_reply_convenience_refund_en,parent_event_id,event_type,payment_credit_card,payment_bank_transfer,payment_convenience_store,cancel_policy,cancellation_policy_details,cancellation_days_1,cancellation_rate_1,cancellation_days_2,cancellation_rate_2,cancellation_days_3,cancellation_rate_3,image_url) VALUES (1,'富士山登山ツアー2026夏','日本最高峰・富士山（標高3,776m）への登頂を目指す1泊2日のツアーです。
経験豊富なガイドが同行し、初心者の方でも安心してご参加いただけます。
山小屋での宿泊、往復バス、登山保険が含まれています。

【スケジュール】
1日目：新宿集合 → バスで富士山五合目へ → 登山開始 → 山小屋泊
2日目：早朝出発 → 山頂でご来光 → 下山 → 温泉入浴 → 新宿解散

【含まれるもの】
- 往復バス代
- ガイド料
- 山小屋宿泊費（1泊2食付）
- 登山保険
- 温泉入浴券','京王グループツアーズ
TEL: 03-1111-2222
Email: yamada@keio-tours.co.jp
受付時間: 平日9:00-18:00','登山経験のある方のご参加を推奨します。
高山病のリスクがありますので、体調管理に十分ご注意ください。','登山経験はありますか？（初めて・1-2回・3回以上）
登山靴はお持ちですか？（持っている・レンタル希望）
食物アレルギーはありますか？',0,'この度は富士山登山ツアーにお申込みいただき、誠にありがとうございます。
日本最高峰の絶景を、安全に楽しんでいただけるよう全力でサポートいたします。
当日お会いできることを楽しみにしております。','悪天候時は中止または日程変更となります。
装備リストは別途お送りします。',1,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',1,NULL,'fujisan-2026-summer','登山・トレッキング',NULL,'single','山梨県富士吉田市 富士山','credit,bank,convenience','percentage','customer','fixed','2026-03-01','2026-07-31','2026-08-01','2026-08-31','yamada@keio-tours.co.jp','山田太郎',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-15','2026-09-30',NULL,'京王グループツアーズ','info@keio-tours.co.jp','━━━━━━━━━━━━━━━━━━━━
京王グループツアーズ
〒160-0023 東京都新宿区西新宿1-10-1
TEL: 03-1111-2222 / FAX: 03-1111-2223
Email: info@keio-tours.co.jp
━━━━━━━━━━━━━━━━━━━━','KEIO GROUP TOURS
1-10-1 Nishi-Shinjuku, Shinjuku-ku, Tokyo
TEL: +81-3-1111-2222
Email: info@keio-tours.co.jp','みずほ銀行','新宿支店','普通','1234567','ケイオウグループツアーズ',7,'KEIO001',7,'["セブンイレブン","ファミリーマート","ローソン"]',3.5,0,0.0,330,0.0,330,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":true,"age":false}',1,'ご予約ありがとうございます。
決済が完了次第、詳細な行程表と装備リストをお送りいたします。','ご予約ありがとうございます。
お振込確認後、詳細な行程表と装備リストをお送りいたします。
振込期限: お申込みから7日以内',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,1,NULL,'■キャンセル料について
出発日の21日前まで：無料
20日前～8日前：旅行代金の20%
7日前～2日前：旅行代金の30%
前日：旅行代金の40%
当日・無連絡不参加：旅行代金の100%',21,0,8,20,2,30,NULL);
INSERT INTO events (id,name,detail,contact,remarks,question,postage,thanks_msg,note,client_id,company_flg,enable_flg,payment_flg,payment_cd,created_at,modified_at,customer_client_id,vendor_id,event_url,category,deleted_at,date_selection_type,location,payment_methods,credit_fee_type,bank_fee_type,convenience_fee_type,registration_start_date,registration_end_date,event_start_date,event_end_date,admin_email,admin_name,name_en,detail_en,location_en,contact_en,remarks_en,thanks_msg_en,organizer_id,admin_login_start_date,admin_login_end_date,admin_cc_email,sender_name,sender_email,email_signature,email_signature_en,bank_name,bank_branch,bank_account_type,bank_account_number,bank_account_name,bank_transfer_deadline,store_code,convenience_payment_deadline,available_convenience_stores,credit_fee_percentage,credit_fee_fixed,bank_fee_percentage,bank_fee_fixed,convenience_fee_percentage,convenience_fee_fixed,form_field_settings,auto_reply_enabled,auto_reply_credit_payment,auto_reply_bank_payment,auto_reply_convenience_payment,auto_reply_credit_cancel,auto_reply_bank_cancel,auto_reply_convenience_cancel,auto_reply_credit_refund,auto_reply_bank_deposit,auto_reply_bank_refund,auto_reply_convenience_deposit,auto_reply_convenience_refund,auto_reply_credit_payment_en,auto_reply_bank_payment_en,auto_reply_convenience_payment_en,auto_reply_credit_cancel_en,auto_reply_bank_cancel_en,auto_reply_convenience_cancel_en,auto_reply_credit_refund_en,auto_reply_bank_deposit_en,auto_reply_bank_refund_en,auto_reply_convenience_deposit_en,auto_reply_convenience_refund_en,parent_event_id,event_type,payment_credit_card,payment_bank_transfer,payment_convenience_store,cancel_policy,cancellation_policy_details,cancellation_days_1,cancellation_rate_1,cancellation_days_2,cancellation_rate_2,cancellation_days_3,cancellation_rate_3,image_url) VALUES (2,'箱根温泉リゾート 春の特別プラン','春の箱根を満喫する2泊3日の温泉リゾートステイ。
名湯として知られる箱根温泉で、日頃の疲れを癒しませんか？

【プランの特徴】
- 源泉かけ流しの露天風呂付き客室
- 地元食材を使った懐石料理（夕朝食付）
- 箱根美術館入館券付き
- 箱根登山鉄道フリーパス付き

【おすすめポイント】
春の箱根は桜や新緑が美しく、気候も穏やかで観光に最適です。
芦ノ湖遊覧、大涌谷見学など周辺観光も充実しています。','箱根温泉旅館組合
TEL: 0460-4444-5555
Email: tanaka@hakone-onsen.or.jp
受付時間: 9:00-18:00','お子様連れ歓迎。お部屋タイプは予約時にご相談ください。',NULL,0,'箱根温泉リゾートへようこそ。
ごゆっくりお寛ぎいただき、心身ともにリフレッシュしていただければ幸いです。
スタッフ一同、心よりお待ちしております。','土日祝日は混雑が予想されます。平日のご利用をおすすめします。',2,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',2,NULL,'hakone-spring-2026','温泉・宿泊',NULL,'single','神奈川県足柄下郡箱根町','credit,bank','percentage','customer',NULL,'2026-01-15','2026-04-30','2026-04-01','2026-05-31','tanaka@hakone-onsen.or.jp','田中温子',NULL,NULL,NULL,NULL,NULL,NULL,4,'2026-01-10','2026-06-30',NULL,'箱根温泉旅館組合','info@hakone-onsen.or.jp','━━━━━━━━━━━━━━━━━━━━
箱根温泉旅館組合
〒250-0311 神奈川県足柄下郡箱根町湯本茶屋6-6-6
TEL: 0460-4444-5555
Email: info@hakone-onsen.or.jp
━━━━━━━━━━━━━━━━━━━━',NULL,'横浜銀行','箱根支店','普通','2345678','ハコネオンセンリョカンクミアイ',10,NULL,NULL,NULL,3.0,NULL,0.0,330,NULL,NULL,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}',1,'ご予約ありがとうございます。
チェックイン時間は15:00以降、チェックアウトは10:00までとなります。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,0,NULL,'■キャンセル料について
宿泊日の14日前まで：無料
13日前～7日前：宿泊料金の20%
6日前～2日前：宿泊料金の30%
前日：宿泊料金の50%
当日・無連絡不参加：宿泊料金の100%',14,0,7,20,NULL,NULL,NULL);
INSERT INTO events (id,name,detail,contact,remarks,question,postage,thanks_msg,note,client_id,company_flg,enable_flg,payment_flg,payment_cd,created_at,modified_at,customer_client_id,vendor_id,event_url,category,deleted_at,date_selection_type,location,payment_methods,credit_fee_type,bank_fee_type,convenience_fee_type,registration_start_date,registration_end_date,event_start_date,event_end_date,admin_email,admin_name,name_en,detail_en,location_en,contact_en,remarks_en,thanks_msg_en,organizer_id,admin_login_start_date,admin_login_end_date,admin_cc_email,sender_name,sender_email,email_signature,email_signature_en,bank_name,bank_branch,bank_account_type,bank_account_number,bank_account_name,bank_transfer_deadline,store_code,convenience_payment_deadline,available_convenience_stores,credit_fee_percentage,credit_fee_fixed,bank_fee_percentage,bank_fee_fixed,convenience_fee_percentage,convenience_fee_fixed,form_field_settings,auto_reply_enabled,auto_reply_credit_payment,auto_reply_bank_payment,auto_reply_convenience_payment,auto_reply_credit_cancel,auto_reply_bank_cancel,auto_reply_convenience_cancel,auto_reply_credit_refund,auto_reply_bank_deposit,auto_reply_bank_refund,auto_reply_convenience_deposit,auto_reply_convenience_refund,auto_reply_credit_payment_en,auto_reply_bank_payment_en,auto_reply_convenience_payment_en,auto_reply_credit_cancel_en,auto_reply_bank_cancel_en,auto_reply_convenience_cancel_en,auto_reply_credit_refund_en,auto_reply_bank_deposit_en,auto_reply_bank_refund_en,auto_reply_convenience_deposit_en,auto_reply_convenience_refund_en,parent_event_id,event_type,payment_credit_card,payment_bank_transfer,payment_convenience_store,cancel_policy,cancellation_policy_details,cancellation_days_1,cancellation_rate_1,cancellation_days_2,cancellation_rate_2,cancellation_days_3,cancellation_rate_3,image_url) VALUES (3,'東京1日観光ツアー 英語ガイド付き','英語ガイド付きで巡る東京の名所を巡る1日ツアー。
外国人観光客にも大人気のコースです。

【訪問先】
- 浅草寺（雷門、仲見世通り散策）
- スカイツリー（展望台入場）
- 皇居外苑（二重橋見学）
- 明治神宮
- 原宿・竹下通り散策
- 渋谷スクランブル交差点

【含まれるもの】
- 英語ガイド
- 貸切バス代
- スカイツリー展望台入場料
- 昼食（日本料理）','東京シティガイド協会
TEL: 03-5555-6666
Email: johnson@tokyo-guide.org
Hours: 9:00-17:00','英語対応可能。日本語ガイドをご希望の場合はお問い合わせください。',NULL,0,'Thank you for booking Tokyo City Tour!
We look forward to showing you the best of Tokyo.',NULL,3,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',3,NULL,'tokyo-city-tour-2026','観光・ツアー',NULL,'button','東京都内各所','credit,bank,convenience','percentage','fixed','fixed','2026-01-01','2026-12-20','2026-01-01','2026-12-31','johnson@tokyo-guide.org',NULL,'Tokyo City Tour with English Guide','Full-day sightseeing tour of Tokyo with professional English-speaking guide.

Highlights:
- Sensoji Temple (Asakusa)
- Tokyo Skytree Observatory
- Imperial Palace East Gardens
- Meiji Shrine
- Harajuku & Shibuya

Includes:
- English-speaking guide
- Private coach
- Skytree admission
- Japanese lunch','Tokyo Metropolitan Area',NULL,NULL,NULL,5,'2025-12-01','2027-01-31',NULL,'Tokyo City Guide','info@tokyo-guide.org','━━━━━━━━━━━━━━━━━━━━
東京シティガイド協会
〒100-0005 東京都千代田区丸の内1-7-7
TEL: 03-5555-6666
Email: info@tokyo-guide.org
━━━━━━━━━━━━━━━━━━━━','Tokyo City Guide Association
1-7-7 Marunouchi, Chiyoda-ku, Tokyo
TEL: +81-3-5555-6666
Email: info@tokyo-guide.org','三菱UFJ銀行','東京営業部','普通','3456789','トウキョウシティガイドキョウカイ',5,'TOKYO001',5,'["セブンイレブン","ファミリーマート","ローソン","ミニストップ"]',3.5,NULL,NULL,330,NULL,330,'{"name_kanji":true,"name_kana":true,"name_roma":true,"address":false,"tel":true,"birth_date":false,"age":false}',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,1,NULL,'■Cancellation Policy
Up to 7 days before: Free
6-3 days before: 30% of tour price
2-1 days before: 50% of tour price
Same day/No show: 100% of tour price',7,0,NULL,NULL,NULL,NULL,'https://placehold.co/1920x600/1e40af/ffffff?text=Tokyo+City+Tour');
INSERT INTO events (id,name,detail,contact,remarks,question,postage,thanks_msg,note,client_id,company_flg,enable_flg,payment_flg,payment_cd,created_at,modified_at,customer_client_id,vendor_id,event_url,category,deleted_at,date_selection_type,location,payment_methods,credit_fee_type,bank_fee_type,convenience_fee_type,registration_start_date,registration_end_date,event_start_date,event_end_date,admin_email,admin_name,name_en,detail_en,location_en,contact_en,remarks_en,thanks_msg_en,organizer_id,admin_login_start_date,admin_login_end_date,admin_cc_email,sender_name,sender_email,email_signature,email_signature_en,bank_name,bank_branch,bank_account_type,bank_account_number,bank_account_name,bank_transfer_deadline,store_code,convenience_payment_deadline,available_convenience_stores,credit_fee_percentage,credit_fee_fixed,bank_fee_percentage,bank_fee_fixed,convenience_fee_percentage,convenience_fee_fixed,form_field_settings,auto_reply_enabled,auto_reply_credit_payment,auto_reply_bank_payment,auto_reply_convenience_payment,auto_reply_credit_cancel,auto_reply_bank_cancel,auto_reply_convenience_cancel,auto_reply_credit_refund,auto_reply_bank_deposit,auto_reply_bank_refund,auto_reply_convenience_deposit,auto_reply_convenience_refund,auto_reply_credit_payment_en,auto_reply_bank_payment_en,auto_reply_convenience_payment_en,auto_reply_credit_cancel_en,auto_reply_bank_cancel_en,auto_reply_convenience_cancel_en,auto_reply_credit_refund_en,auto_reply_bank_deposit_en,auto_reply_bank_refund_en,auto_reply_convenience_deposit_en,auto_reply_convenience_refund_en,parent_event_id,event_type,payment_credit_card,payment_bank_transfer,payment_convenience_store,cancel_policy,cancellation_policy_details,cancellation_days_1,cancellation_rate_1,cancellation_days_2,cancellation_rate_2,cancellation_days_3,cancellation_rate_3,image_url) VALUES (4,'多摩丘陵サイクリング 紅葉満喫コース','秋の多摩丘陵を自転車で巡る日帰りツアー。
紅葉の名所を訪れながら、地元グルメも楽しめます。

【コース概要】
立川駅集合 → 昭和記念公園（銀杏並木）→ 多摩湖サイクリングロード → 
野山北公園（昼食）→ 狭山丘陵（トトロの森）→ 立川駅解散

【距離】約30km（初心者でも走りやすいコース）
【所要時間】約6時間（休憩含む）

【含まれるもの】
- スポーツサイクルレンタル（電動アシスト可）
- ヘルメット、グローブレンタル
- サイクリングガイド
- 昼食（地元食材を使ったお弁当）
- 保険
- ドリンク','多摩地域観光推進協議会
TEL: 042-2222-3333
Email: sato@tama-tourism.jp
受付時間: 平日9:00-17:00','自転車に乗れる方が対象です。
雨天の場合は中止となり、全額返金いたします。',NULL,0,'多摩丘陵の美しい紅葉と、地域の魅力をお楽しみください。
安全運転で、気持ちの良いサイクリングをお楽しみいただけます。','電動アシスト自転車をご希望の方は予約時にお申し出ください（追加料金なし）。',4,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',4,NULL,'tama-cycling-autumn-2026','サイクリング・アウトドア',NULL,'single','東京都立川市・武蔵村山市周辺','credit,bank','percentage','customer',NULL,'2026-08-01','2026-10-31','2026-10-15','2026-11-30','sato@tama-tourism.jp','佐藤花子',NULL,NULL,NULL,NULL,NULL,NULL,2,'2026-07-01','2026-12-31',NULL,'多摩地域観光推進協議会','info@tama-tourism.jp','━━━━━━━━━━━━━━━━━━━━
多摩地域観光推進協議会
〒190-0012 東京都立川市曙町2-1-1
TEL: 042-2222-3333
Email: info@tama-tourism.jp
━━━━━━━━━━━━━━━━━━━━',NULL,'きらぼし銀行','立川支店','普通','4567890','タマチイキカンコウスイシンキョウギカイ',7,NULL,NULL,NULL,3.5,NULL,NULL,330,NULL,NULL,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":false,"tel":true,"birth_date":true,"age":false}',1,'ご予約ありがとうございます。
当日は動きやすい服装と、タオル・飲み物をお持ちください。','ご予約ありがとうございます。
お振込確認後、集合場所の詳細地図をお送りいたします。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,0,NULL,'■キャンセル料について
実施日の7日前まで：無料
6日前～3日前：参加費の30%
2日前～前日：参加費の50%
当日・無連絡不参加：参加費の100%',7,0,3,30,NULL,NULL,NULL);
INSERT INTO events (id,name,detail,contact,remarks,question,postage,thanks_msg,note,client_id,company_flg,enable_flg,payment_flg,payment_cd,created_at,modified_at,customer_client_id,vendor_id,event_url,category,deleted_at,date_selection_type,location,payment_methods,credit_fee_type,bank_fee_type,convenience_fee_type,registration_start_date,registration_end_date,event_start_date,event_end_date,admin_email,admin_name,name_en,detail_en,location_en,contact_en,remarks_en,thanks_msg_en,organizer_id,admin_login_start_date,admin_login_end_date,admin_cc_email,sender_name,sender_email,email_signature,email_signature_en,bank_name,bank_branch,bank_account_type,bank_account_number,bank_account_name,bank_transfer_deadline,store_code,convenience_payment_deadline,available_convenience_stores,credit_fee_percentage,credit_fee_fixed,bank_fee_percentage,bank_fee_fixed,convenience_fee_percentage,convenience_fee_fixed,form_field_settings,auto_reply_enabled,auto_reply_credit_payment,auto_reply_bank_payment,auto_reply_convenience_payment,auto_reply_credit_cancel,auto_reply_bank_cancel,auto_reply_convenience_cancel,auto_reply_credit_refund,auto_reply_bank_deposit,auto_reply_bank_refund,auto_reply_convenience_deposit,auto_reply_convenience_refund,auto_reply_credit_payment_en,auto_reply_bank_payment_en,auto_reply_convenience_payment_en,auto_reply_credit_cancel_en,auto_reply_bank_cancel_en,auto_reply_convenience_cancel_en,auto_reply_credit_refund_en,auto_reply_bank_deposit_en,auto_reply_bank_refund_en,auto_reply_convenience_deposit_en,auto_reply_convenience_refund_en,parent_event_id,event_type,payment_credit_card,payment_bank_transfer,payment_convenience_store,cancel_policy,cancellation_policy_details,cancellation_days_1,cancellation_rate_1,cancellation_days_2,cancellation_rate_2,cancellation_days_3,cancellation_rate_3,image_url) VALUES (5,'里山エコツーリズム 自然体験プログラム','都心から1時間、里山で自然とふれあう1日体験プログラム。
環境保護と観光を両立させたエコツーリズムの入門編です。

【プログラム内容】
午前：
- 里山ガイドウォーク（約2時間）
- 野鳥観察体験
- 森林セラピー

午後：
- 農業体験（季節の野菜収穫）
- 地元食材を使った昼食作り
- 環境保全ワークショップ

【学べること】
- 里山の生態系
- 持続可能な観光のあり方
- 地域資源の活用方法
- 生物多様性の重要性

【対象】
小学生から大人まで。ファミリーでの参加も大歓迎です。','エコツーリズム推進協議会
TEL: 03-5678-9012
Email: nakamura@eco-tourism.jp
受付時間: 平日9:00-17:00','小学生以下のお子様は保護者同伴でご参加ください。
汚れてもよい服装、長靴または運動靴でお越しください。',NULL,0,'エコツーリズム体験プログラムへようこそ。
自然との共生、持続可能な社会について、楽しく学んでいただけます。
皆様のご参加を心よりお待ちしております。','悪天候時は屋内プログラムに変更します（中止の場合は全額返金）。
季節によって体験内容が異なります。',5,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',5,NULL,'eco-tourism-2026','エコツアー・体験',NULL,'single','東京都・埼玉県 里山エリア','credit,bank,convenience','percentage','customer','fixed','2026-02-01','2026-09-30','2026-04-01','2026-10-31','nakamura@eco-tourism.jp','中村環',NULL,NULL,NULL,NULL,NULL,NULL,2,'2026-01-15','2026-11-30',NULL,'エコツーリズム推進協議会','info@eco-tourism.jp','━━━━━━━━━━━━━━━━━━━━
エコツーリズム推進協議会
〒102-0072 東京都千代田区飯田橋4-4-4
TEL: 03-5678-9012
Email: info@eco-tourism.jp
━━━━━━━━━━━━━━━━━━━━',NULL,'三井住友銀行','飯田橋支店','普通','5678901','エコツーリズムスイシンキョウギカイ',7,'ECO001',7,'["セブンイレブン","ファミリーマート","ローソン"]',3.0,NULL,NULL,330,NULL,330,'{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":true,"age":true}',1,'ご予約ありがとうございます。
当日は汚れてもよい服装と、タオル・着替えをお持ちください。
集合場所は事前にメールでお知らせいたします。','ご予約ありがとうございます。
お振込確認後、詳細な行程表と持ち物リストをお送りいたします。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,1,NULL,'■キャンセル料について
実施日の14日前まで：無料
13日前～7日前：参加費の20%
6日前～3日前：参加費の30%
2日前～前日：参加費の50%
当日・無連絡不参加：参加費の100%',14,0,7,20,3,30,NULL);

-- Table: members (10 rows)
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (1,'yamada.taro@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','山田','太郎','ヤマダ','タロウ','Yamada','Taro','男性','1985-04-15','160-0023',13,'新宿区西新宿1-1-1 マンションA 101','03-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-1234-5678');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (2,'suzuki.hanako@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','鈴木','花子','スズキ','ハナコ','Suzuki','Hanako','女性','1990-08-20','150-0001',13,'渋谷区神宮前2-2-2 ビルB 202','03-2345-6789',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-2345-6789');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (3,'tanaka.ichiro@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','田中','一郎','タナカ','イチロウ','Tanaka','Ichiro','男性','1978-12-05','100-0001',13,'千代田区千代田3-3-3 ハイツC 303','03-3456-7890',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-3456-7890');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (4,'watanabe.yuki@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','渡辺','優希','ワタナベ','ユウキ','Watanabe','Yuki','女性','1995-03-10','190-0012',13,'立川市曙町4-4-4 コーポD 404','042-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-4567-8901');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (5,'ito.kenji@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','伊藤','健二','イトウ','ケンジ','Ito','Kenji','男性','1982-07-25','105-0001',13,'港区虎ノ門5-5-5 タワーE 505','03-4567-8901',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-5678-9012');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (6,'kobayashi.ai@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','小林','愛','コバヤシ','アイ','Kobayashi','Ai','女性','1988-11-30','102-0072',13,'千代田区飯田橋6-6-6 マンションF 606','03-5678-9012',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-6789-0123');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (7,'sato.makoto@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','佐藤','誠','サトウ','マコト','Sato','Makoto','男性','1975-02-18','250-0311',14,'足柄下郡箱根町湯本7-7-7','0460-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-7890-1234');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (8,'takahashi.misa@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','高橋','美咲','タカハシ','ミサ','Takahashi','Misa','女性','1992-06-12','403-0005',19,'富士吉田市上吉田8-8-8','0555-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-8901-2345');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (9,'nakamura.jun@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','中村','潤','ナカムラ','ジュン','Nakamura','Jun','男性','1987-09-08','180-0004',13,'武蔵野市吉祥寺本町9-9-9','0422-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-9012-3456');
INSERT INTO members (id,email,password_hash,family_name,first_name,family_kana,first_kana,last_name_en,first_name_en,sex,birth,zip,pref_id,addr,tel,enable_flg,created_at,modified_at,mobile) VALUES (10,'yamamoto.yui@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','山本','結衣','ヤマモト','ユイ','Yamamoto','Yui','女性','1998-01-22','183-0055',13,'府中市府中町10-10-10','042-2345-6789',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-0123-4567');

-- Table: option_bookings (0 rows)

-- Table: option_categories (0 rows)

-- Table: option_forms (0 rows)

-- Table: option_inherited_products (0 rows)

-- Table: option_prices (0 rows)

-- Table: option_shared_stock_pools (0 rows)

-- Table: option_stocks (0 rows)

-- Table: options (0 rows)

-- Table: organizers (5 rows)
INSERT INTO organizers (id,name,contactable_person,email,tel,branch_office,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,registration_number,association_name,association_membership,travel_manager_title,travel_manager_name,remarks,created_at,modified_at) VALUES (1,'京王グループツアーズ','山田太郎','yamada@keio-tours.co.jp','03-1111-2222','新宿本社',1,NULL,'160-0023',13,'新宿区西新宿1-10-1','03-1111-2223',NULL,'平日9:00-18:00','土日祝','各種ツアー企画・運営','T-001-12345','日本旅行業協会','JATA会員','旅行業務取扱管理者','山田太郎','メイン主催者','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO organizers (id,name,contactable_person,email,tel,branch_office,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,registration_number,association_name,association_membership,travel_manager_title,travel_manager_name,remarks,created_at,modified_at) VALUES (2,'多摩地域観光推進協議会','佐藤花子','sato@tama-tourism.jp','042-2222-3333','立川事務所',1,NULL,'190-0012',13,'立川市曙町2-1-1','042-2222-3334',NULL,'平日9:00-17:00','土日祝','多摩地域の観光振興','T-002-23456','多摩観光連盟','理事会員','事務局長','佐藤花子','地域密着型','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO organizers (id,name,contactable_person,email,tel,branch_office,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,registration_number,association_name,association_membership,travel_manager_title,travel_manager_name,remarks,created_at,modified_at) VALUES (3,'富士山ネイチャーツアーズ','鈴木登','suzuki@fujisan-nature.jp','0555-3333-4444','富士吉田営業所',1,NULL,'403-0005',19,'富士吉田市上吉田5-5-5','0555-3333-4445',NULL,'8:00-19:00','不定休','富士山周辺ツアー専門','T-003-34567','山梨県旅行業協会','正会員','総合旅行業務取扱管理者','鈴木登','富士山エリア専門','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO organizers (id,name,contactable_person,email,tel,branch_office,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,registration_number,association_name,association_membership,travel_manager_title,travel_manager_name,remarks,created_at,modified_at) VALUES (4,'箱根温泉旅館組合','田中温子','tanaka@hakone-onsen.or.jp','0460-4444-5555','箱根湯本事務局',1,NULL,'250-0311',14,'足柄下郡箱根町湯本茶屋6-6-6','0460-4444-5556',NULL,'9:00-18:00','年末年始','箱根温泉地域の観光振興','T-004-45678','箱根観光協会','組合員','組合長','田中温子','温泉旅館組合','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO organizers (id,name,contactable_person,email,tel,branch_office,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,registration_number,association_name,association_membership,travel_manager_title,travel_manager_name,remarks,created_at,modified_at) VALUES (5,'東京シティガイド協会','Emily Johnson','johnson@tokyo-guide.org','03-5555-6666','東京支部',1,NULL,'100-0005',13,'千代田区丸の内1-7-7','03-5555-6667',NULL,'9:00-17:00','土日祝','東京観光ガイド事業','T-005-56789','全国通訳案内士協会','認定団体','Director','Emily Johnson','英語ガイド専門','2026-02-12 07:16:29','2026-02-12 07:16:29');

-- Table: prefs (47 rows)
INSERT INTO prefs (id,name) VALUES (1,'北海道');
INSERT INTO prefs (id,name) VALUES (2,'青森県');
INSERT INTO prefs (id,name) VALUES (3,'岩手県');
INSERT INTO prefs (id,name) VALUES (4,'宮城県');
INSERT INTO prefs (id,name) VALUES (5,'秋田県');
INSERT INTO prefs (id,name) VALUES (6,'山形県');
INSERT INTO prefs (id,name) VALUES (7,'福島県');
INSERT INTO prefs (id,name) VALUES (8,'茨城県');
INSERT INTO prefs (id,name) VALUES (9,'栃木県');
INSERT INTO prefs (id,name) VALUES (10,'群馬県');
INSERT INTO prefs (id,name) VALUES (11,'埼玉県');
INSERT INTO prefs (id,name) VALUES (12,'千葉県');
INSERT INTO prefs (id,name) VALUES (13,'東京都');
INSERT INTO prefs (id,name) VALUES (14,'神奈川県');
INSERT INTO prefs (id,name) VALUES (15,'新潟県');
INSERT INTO prefs (id,name) VALUES (16,'富山県');
INSERT INTO prefs (id,name) VALUES (17,'石川県');
INSERT INTO prefs (id,name) VALUES (18,'福井県');
INSERT INTO prefs (id,name) VALUES (19,'山梨県');
INSERT INTO prefs (id,name) VALUES (20,'長野県');
INSERT INTO prefs (id,name) VALUES (21,'岐阜県');
INSERT INTO prefs (id,name) VALUES (22,'静岡県');
INSERT INTO prefs (id,name) VALUES (23,'愛知県');
INSERT INTO prefs (id,name) VALUES (24,'三重県');
INSERT INTO prefs (id,name) VALUES (25,'滋賀県');
INSERT INTO prefs (id,name) VALUES (26,'京都府');
INSERT INTO prefs (id,name) VALUES (27,'大阪府');
INSERT INTO prefs (id,name) VALUES (28,'兵庫県');
INSERT INTO prefs (id,name) VALUES (29,'奈良県');
INSERT INTO prefs (id,name) VALUES (30,'和歌山県');
INSERT INTO prefs (id,name) VALUES (31,'鳥取県');
INSERT INTO prefs (id,name) VALUES (32,'島根県');
INSERT INTO prefs (id,name) VALUES (33,'岡山県');
INSERT INTO prefs (id,name) VALUES (34,'広島県');
INSERT INTO prefs (id,name) VALUES (35,'山口県');
INSERT INTO prefs (id,name) VALUES (36,'徳島県');
INSERT INTO prefs (id,name) VALUES (37,'香川県');
INSERT INTO prefs (id,name) VALUES (38,'愛媛県');
INSERT INTO prefs (id,name) VALUES (39,'高知県');
INSERT INTO prefs (id,name) VALUES (40,'福岡県');
INSERT INTO prefs (id,name) VALUES (41,'佐賀県');
INSERT INTO prefs (id,name) VALUES (42,'長崎県');
INSERT INTO prefs (id,name) VALUES (43,'熊本県');
INSERT INTO prefs (id,name) VALUES (44,'大分県');
INSERT INTO prefs (id,name) VALUES (45,'宮崎県');
INSERT INTO prefs (id,name) VALUES (46,'鹿児島県');
INSERT INTO prefs (id,name) VALUES (47,'沖縄県');

-- Table: product_bookings (0 rows)

-- Table: product_categories (0 rows)

-- Table: product_form_fields (11 rows)
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (1,1,'radio','dietary_restrictions','Dietary Restrictions / 食事制限','["No restrictions / なし","Vegetarian / ベジタリアン","Vegan / ヴィーガン","Halal / ハラル","Gluten-free / グルテンフリー","Other / その他"]',0,'Please let us know if you have any dietary restrictions',1,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (2,1,'textarea','special_requests','Special Requests / 特別なご要望',NULL,0,'Any special requests or requirements',2,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (3,1,'text','hotel_name','Hotel Name (if pickup needed) / ホテル名（送迎希望の場合）',NULL,0,'If you need hotel pickup, please provide your hotel name',3,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (4,2,'radio','dietary_restrictions','Dietary Restrictions / 食事制限','["No restrictions / なし","Vegetarian / ベジタリアン","Vegan / ヴィーガン","Halal / ハラル","Gluten-free / グルテンフリー","Other / その他"]',0,'Please let us know if you have any dietary restrictions',0,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 09:20:14',2);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (5,2,'textarea','special_requests','Special Requests / 特別なご要望',NULL,0,'Any special requests or requirements',1,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 09:20:14',2);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (6,2,'text','hotel_name','Hotel Name (if pickup needed) / ホテル名（送迎希望の場合）',NULL,0,'If you need hotel pickup, please provide your hotel name',2,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 09:20:14',2);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (7,3,'textarea','preferred_destinations','Preferred Destinations / 希望訪問先',NULL,1,'Please list the places you would like to visit',1,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (8,3,'text','preferred_start_time','Preferred Start Time / 希望開始時刻',NULL,0,'What time would you like to start? (e.g., 09:00)',2,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (9,3,'radio','dietary_restrictions','Dietary Restrictions / 食事制限','["No restrictions / なし","Vegetarian / ベジタリアン","Vegan / ヴィーガン","Halal / ハラル","Gluten-free / グルテンフリー","Other / その他"]',0,'Please let us know if you have any dietary restrictions',3,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (10,3,'textarea','special_requests','Special Requests / 特別なご要望',NULL,0,'Any other special requests or requirements',4,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);
INSERT INTO product_form_fields (id,product_id,field_type,field_name,field_label,field_options,is_required,description,display_order,placeholder,parent_field_id,parent_condition,indent_level,validation_rule,default_value,help_text,created_at,modified_at,category) VALUES (11,3,'text','hotel_name','Hotel Name (for pickup) / ホテル名（送迎用）',NULL,1,'We will pick you up from your hotel',5,NULL,NULL,NULL,0,NULL,NULL,NULL,'2026-02-12 07:32:20','2026-02-12 07:32:20',1);

-- Table: product_prices (8 rows)
INSERT INTO product_prices (id,product_id,price,category_name,created_at,modified_at,price_band,price_name,display_order,slot_number) VALUES (1,1,12000,'大人','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'大人（13歳以上）',1,1);
INSERT INTO product_prices (id,product_id,price,category_name,created_at,modified_at,price_band,price_name,display_order,slot_number) VALUES (2,1,8000,'子供','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'子供（6-12歳）',2,1);
INSERT INTO product_prices (id,product_id,price,category_name,created_at,modified_at,price_band,price_name,display_order,slot_number) VALUES (3,1,0,'幼児','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'幼児（5歳以下・座席なし）',3,1);
INSERT INTO product_prices (id,product_id,price,category_name,created_at,modified_at,price_band,price_name,display_order,slot_number) VALUES (4,2,18000,'大人','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'大人（13歳以上）',1,1);
INSERT INTO product_prices (id,product_id,price,category_name,created_at,modified_at,price_band,price_name,display_order,slot_number) VALUES (5,2,12000,'子供','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'子供（6-12歳）',2,1);
INSERT INTO product_prices (id,product_id,price,category_name,created_at,modified_at,price_band,price_name,display_order,slot_number) VALUES (6,2,0,'幼児','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'幼児（5歳以下・座席なし）',3,1);
INSERT INTO product_prices (id,product_id,price,category_name,created_at,modified_at,price_band,price_name,display_order,slot_number) VALUES (12,3,10000,'A-名称1','2026-02-12 07:41:18','2026-02-12 07:41:18','A','大人',0,1);
INSERT INTO product_prices (id,product_id,price,category_name,created_at,modified_at,price_band,price_name,display_order,slot_number) VALUES (13,3,8000,'A-名称2','2026-02-12 07:41:18','2026-02-12 07:41:18','A','子供',0,2);

-- Table: product_shared_stock_pools (0 rows)

-- Table: product_stocks (86 rows)
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (1,1,'2026-01-03',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (2,1,'2026-01-04',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (3,1,'2026-01-10',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (4,1,'2026-01-11',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (5,1,'2026-01-17',20,2,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (6,1,'2026-01-18',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (7,1,'2026-01-24',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (8,1,'2026-01-25',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (9,1,'2026-01-31',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (10,1,'2026-02-01',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (11,1,'2026-02-07',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (12,1,'2026-02-08',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (13,1,'2026-02-14',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (14,1,'2026-02-15',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (15,1,'2026-02-21',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (16,1,'2026-02-22',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (17,1,'2026-02-28',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (18,1,'2026-03-01',20,2,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (19,1,'2026-03-07',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (20,1,'2026-03-08',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (21,1,'2026-03-14',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (22,1,'2026-03-15',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (23,1,'2026-03-21',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (24,1,'2026-03-22',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (25,1,'2026-03-28',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (26,1,'2026-03-29',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (27,1,'2026-04-04',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (28,1,'2026-04-05',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (29,1,'2026-04-11',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (30,1,'2026-04-12',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (31,1,'2026-04-18',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (32,1,'2026-04-19',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (33,1,'2026-04-25',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (34,1,'2026-04-26',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (35,2,'2026-01-03',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (36,2,'2026-01-04',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (37,2,'2026-01-10',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (38,2,'2026-01-11',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (39,2,'2026-01-17',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (40,2,'2026-01-18',12,1,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (41,2,'2026-01-24',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (42,2,'2026-01-25',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (43,2,'2026-01-31',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (44,2,'2026-02-01',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (45,2,'2026-02-07',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (46,2,'2026-02-08',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (47,2,'2026-02-14',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (48,2,'2026-02-15',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (49,2,'2026-02-21',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (50,2,'2026-02-22',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (51,2,'2026-02-28',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (52,2,'2026-03-01',12,1,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (53,2,'2026-03-07',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (54,2,'2026-03-08',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (55,2,'2026-03-14',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (56,2,'2026-03-15',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (57,2,'2026-03-21',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (58,2,'2026-03-22',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (59,2,'2026-03-28',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (60,2,'2026-03-29',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (61,2,'2026-04-04',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (62,2,'2026-04-05',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (63,2,'2026-04-11',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (64,2,'2026-04-12',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (65,2,'2026-04-18',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (66,2,'2026-04-19',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (67,2,'2026-04-25',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (68,2,'2026-04-26',12,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (69,3,'2026-01-05',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (70,3,'2026-01-12',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (71,3,'2026-01-19',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (72,3,'2026-01-26',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (73,3,'2026-02-02',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (74,3,'2026-02-09',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (75,3,'2026-02-16',3,0,'2026-02-12 07:32:20','2026-02-12 07:50:30',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (76,3,'2026-02-23',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (77,3,'2026-03-02',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (78,3,'2026-03-09',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (79,3,'2026-03-16',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (80,3,'2026-03-23',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (81,3,'2026-03-30',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (82,3,'2026-04-06',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (83,3,'2026-04-13',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (84,3,'2026-04-20',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (85,3,'2026-04-27',3,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks (id,product_id,date,stock,booked,created_at,modified_at,time_slot_start,time_slot_end,time_slot_label,stock_name,shared_pool_id,price_band) VALUES (86,3,'2026-02-14',10,0,'2026-02-12 07:50:46','2026-02-12 07:50:46',NULL,NULL,NULL,NULL,NULL,'A');

-- Table: products (3 rows)
INSERT INTO products (id,client_id,event_id,name,sales_start,sales_end,closing_trade,product_category_id,description,remarks,fee_include,fee_exclude,cancel_policy,purchase_limit,deposit_address,note,enable_flg,created_at,modified_at,slot_type,deleted_at,cancellation_days_1,cancellation_rate_1,cancellation_days_2,cancellation_rate_2,cancellation_days_3,cancellation_rate_3,cancellation_days_4,cancellation_rate_4,cancellation_days_5,cancellation_rate_5,common_names,cancellation_policy_details,price_unit,charge_type,charge_description,form_field_settings,image_url) VALUES (1,3,3,'東京1日観光ツアー スタンダードプラン','2026-01-01','2026-12-20',0,NULL,'英語ガイド付きで東京の主要観光スポットを巡る1日ツアーです。
少人数制で快適にご参加いただけます。

【ツアー内容】
- 浅草寺（雷門・仲見世通り）
- スカイツリー展望台（天望デッキ）
- 皇居外苑（二重橋）
- 明治神宮
- 原宿・竹下通り
- 渋谷スクランブル交差点

【スケジュール】
09:00 新宿集合
09:30-11:00 浅草観光
11:30-12:30 スカイツリー
12:30-13:30 ランチ（日本料理）
14:00-14:45 皇居外苑
15:00-15:45 明治神宮
16:00-16:30 原宿散策
16:45-17:15 渋谷散策
17:30 新宿解散','雨天決行。悪天候の場合は一部スケジュールを変更する場合があります。
歩きやすい靴でご参加ください。','・英語ガイド料
・貸切バス代
・スカイツリー展望台入場料（天望デッキ350m）
・ランチ（日本料理コース）
・旅行保険','・天望回廊（450m）追加入場料
・個人的なお買い物代
・飲み物（ランチ時の飲み物は含む）','キャンセル料は7日前まで無料、6-3日前30%、2-1日前50%、当日100%',20,NULL,NULL,1,'2026-02-12 07:32:20','2026-02-12 07:32:20',0,NULL,7,0,3,30,2,50,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person','1名様あたりの料金','{"name_kanji":true,"name_kana":true,"name_roma":true,"address":false,"tel":true,"birth_date":false,"age":false}','https://placehold.co/400x300/3b82f6/ffffff?text=Standard+Tour');
INSERT INTO products (id,client_id,event_id,name,sales_start,sales_end,closing_trade,product_category_id,description,remarks,fee_include,fee_exclude,cancel_policy,purchase_limit,deposit_address,note,enable_flg,created_at,modified_at,slot_type,deleted_at,cancellation_days_1,cancellation_rate_1,cancellation_days_2,cancellation_rate_2,cancellation_days_3,cancellation_rate_3,cancellation_days_4,cancellation_rate_4,cancellation_days_5,cancellation_rate_5,common_names,cancellation_policy_details,price_unit,charge_type,charge_description,form_field_settings,image_url) VALUES (2,3,3,'東京1日観光ツアー プレミアムプラン','2026-01-01','2026-12-20',0,NULL,'スタンダードプランにスカイツリー天望回廊（450m）入場を追加したプレミアムプランです。
より高い場所から東京の絶景をお楽しみいただけます。

【ツアー内容】
スタンダードプランの内容に加えて：
- スカイツリー天望回廊（450m）入場
- プレミアムランチ（特選日本料理コース）
- オリジナルお土産付き

【スケジュール】
09:00 新宿集合
09:30-11:00 浅草観光
11:30-13:00 スカイツリー（天望デッキ＋天望回廊）
13:00-14:00 プレミアムランチ
14:30-15:15 皇居外苑
15:30-16:15 明治神宮
16:30-17:00 原宿散策
17:15-17:45 渋谷散策
18:00 新宿解散','雨天決行。
少人数制（最大12名）で特別な体験をお約束します。','・英語ガイド料
・貸切バス代
・スカイツリー展望台入場料（天望デッキ＋天望回廊）
・プレミアムランチ（特選日本料理コース・ドリンク付き）
・オリジナルお土産
・旅行保険','・個人的なお買い物代','キャンセル料は7日前まで無料、6-3日前30%、2-1日前50%、当日100%',12,NULL,NULL,1,'2026-02-12 07:32:20','2026-02-12 07:32:20',0,NULL,7,0,3,30,2,50,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person','1名様あたりの料金','{"name_kanji":true,"name_kana":true,"name_roma":true,"address":false,"tel":true,"birth_date":false,"age":false}','https://placehold.co/400x300/f59e0b/ffffff?text=Premium+Tour');
INSERT INTO products (id,client_id,event_id,name,sales_start,sales_end,closing_trade,product_category_id,description,remarks,fee_include,fee_exclude,cancel_policy,purchase_limit,deposit_address,note,enable_flg,created_at,modified_at,slot_type,deleted_at,cancellation_days_1,cancellation_rate_1,cancellation_days_2,cancellation_rate_2,cancellation_days_3,cancellation_rate_3,cancellation_days_4,cancellation_rate_4,cancellation_days_5,cancellation_rate_5,common_names,cancellation_policy_details,price_unit,charge_type,charge_description,form_field_settings,image_url) VALUES (3,3,3,'東京プライベート観光ツアー（貸切）','2026-01-01T09:00','2026-12-20T09:00',3,NULL,'お客様のグループだけの完全プライベートツアーです。
ご希望に合わせて訪問先やスケジュールをカスタマイズできます。

【基本プラン内容】
- 専属英語ガイド
- 貸切車両（1-6名様まで）
- 8時間のツアー
- スカイツリー天望回廊入場付き
- プレミアムランチ

【カスタマイズ可能】
- 訪問先の変更・追加
- 出発時刻の調整
- ランチ場所の選択
- ショッピング時間の延長
など、ご要望をお聞かせください。

【おすすめの訪問先】
- 浅草寺・仲見世
- スカイツリー
- 皇居
- 明治神宮
- 築地場外市場
- お台場
- 秋葉原
- 六本木ヒルズ
など、お好きな場所を選択できます。','3日前までの事前予約制。
ご希望の訪問先がある場合は予約時にお知らせください。','・専属英語ガイド（8時間）
・貸切車両（1-6名様）
・スカイツリー天望回廊入場料
・プレミアムランチ（お一人様）
・旅行保険
・駐車料金','・入場料（ランチ・スカイツリー以外）
・個人的なお買い物代
・追加の飲食代','',6,NULL,'',1,'2026-02-12 07:32:20','2026-02-12 07:41:18',0,NULL,14,0,7,20,3,30,NULL,NULL,NULL,NULL,'[{"name":"大人","description":""},{"name":"子供","description":""}]','[]','人','per_person','1名あたりの料金','{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}','https://placehold.co/400x300/8b5cf6/ffffff?text=Private+Tour');

-- Table: refund_history (1 rows)
INSERT INTO refund_history (id,payment_id,booking_item_id,refund_amount,refund_method,refund_date,refund_transaction_id,refund_reason,refund_details,remarks,created_at) VALUES (1,4,4,16800,'credit_card','2026-02-20 14:00:00','re_1AbCdE4567890123','予約キャンセル','キャンセル料30%適用。3日前キャンセル','','2026-02-20 14:00:00');

-- Table: shared_stock_pools (0 rows)

-- Table: vendors (5 rows)
INSERT INTO vendors (id,name,contactable_person,email,tel,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,remarks,created_at,modified_at) VALUES (1,'富士急バス株式会社','高橋運転','takahashi@fujikyu-bus.co.jp','0555-1111-2222',1,NULL,'403-0016',19,'富士吉田市松山1-1-1','0555-1111-2223',NULL,'24時間対応','なし','観光バス・貸切バス事業','大型バス20台保有','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO vendors (id,name,contactable_person,email,tel,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,remarks,created_at,modified_at) VALUES (2,'箱根登山観光バス','小林ドライブ','kobayashi@hakone-bus.co.jp','0460-2222-3333',1,NULL,'250-0311',14,'足柄下郡箱根町湯本2-2-2','0460-2222-3334',NULL,'6:00-22:00','不定休','箱根エリア専門','中型バス10台','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO vendors (id,name,contactable_person,email,tel,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,remarks,created_at,modified_at) VALUES (3,'東京シティクルーズ','伊藤船長','ito@tokyo-cruise.jp','03-3333-4444',1,NULL,'105-0011',13,'港区芝公園3-3-3','03-3333-4445',NULL,'8:00-20:00','月曜','東京湾クルーズ','大型船2隻・小型船5隻','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO vendors (id,name,contactable_person,email,tel,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,remarks,created_at,modified_at) VALUES (4,'多摩ケータリングサービス','渡辺料理','watanabe@tama-catering.jp','042-4444-5555',1,NULL,'190-0012',13,'立川市曙町4-4-4','042-4444-5556',NULL,'7:00-22:00','なし','弁当・ケータリング','1日1000食対応可能','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO vendors (id,name,contactable_person,email,tel,reg_flg,deleted_at,zip,pref_id,addr,fax,password,business_hours,closed_days,business_notes,remarks,created_at,modified_at) VALUES (5,'富士山ガイドセンター','山本登山','yamamoto@fujisan-guide.jp','0555-5555-6666',1,NULL,'403-0005',19,'富士吉田市上吉田5-5-5','0555-5555-6667',NULL,'7:00-18:00','悪天候時','富士登山ガイド','認定ガイド20名在籍','2026-02-12 07:16:29','2026-02-12 07:16:29');

COMMIT;
PRAGMA foreign_keys=ON;
