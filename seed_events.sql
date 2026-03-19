-- イベントマスター テストデータ
-- 多様なイベントタイプをカバーする15件のテストデータ

-- 1. 東京サマーフェスティバル2024（文化・芸術、クレジットカード決済）
INSERT INTO events (
  name, name_en, event_url, category, client_id, organizer_id, vendor_id, branch_code,
  detail, detail_en, location, location_en, contact, contact_en,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_credit_card, credit_fee_type, credit_fee_percentage,
  admin_email, sender_name, sender_email,
  remarks, thanks_msg, email_signature
) VALUES (
  '東京サマーフェスティバル2024', 'Tokyo Summer Festival 2024', 'tokyo-summer-festival-2024',
  '1', 1, 1, 1, 'TOKYO',
  '毎年恒例の夏の風物詩。伝統芸能から現代アートまで、多彩なプログラムをお楽しみいただけます。',
  'Annual summer tradition featuring traditional performing arts and contemporary art programs.',
  '東京都渋谷区代々木公園イベント広場', 'Yoyogi Park Event Square, Shibuya, Tokyo',
  'お問い合わせ：03-1234-5678（平日10:00-18:00）\nメール：info@tokyosummer.jp',
  'Contact: 03-1234-5678 (Weekdays 10:00-18:00)\nEmail: info@tokyosummer.jp',
  'calendar', 'standalone', 1,
  '2024-05-01', '2024-07-20', '2024-08-01', '2024-08-15',
  1, 1, 'percentage', 3.5,
  'admin@tokyosummer.jp', '東京サマーフェスティバル事務局', 'noreply@tokyosummer.jp',
  '雨天決行。荒天の場合は中止となる可能性があります。',
  'この度は東京サマーフェスティバル2024にお申し込みいただき、誠にありがとうございます。当日のご来場を心よりお待ちしております。',
  '---\n東京サマーフェスティバル実行委員会\n〒150-0001 東京都渋谷区神宮前1-1-1\nTEL: 03-1234-5678'
);

-- 2. 大阪マラソン大会2024（スポーツ、銀行振込＋クレジットカード）
INSERT INTO events (
  name, name_en, event_url, category, client_id, organizer_id, vendor_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_credit_card, payment_bank_transfer,
  credit_fee_type, credit_fee_percentage,
  bank_fee_type, bank_fee_fixed,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  admin_email, sender_name, sender_email,
  remarks, thanks_msg
) VALUES (
  '大阪マラソン大会2024', 'Osaka Marathon 2024', 'osaka-marathon-2024',
  '2', 2, 2, 2, 'OSAKA',
  '大阪城をスタートし、御堂筋を駆け抜ける42.195kmのフルマラソン。初心者からベテランまで、幅広くご参加いただけます。',
  '大阪城公園スタート→御堂筋→大阪港ゴール', 'お問い合わせ：06-1234-5678\nメール：info@osakamarathon.jp',
  'button', 'standalone', 1,
  '2024-03-01', '2024-09-30', '2024-11-10', '2024-11-10',
  1, 1, 1,
  'percentage', 3.0,
  'fixed', 330,
  'みずほ銀行', '大阪支店', '普通', '1234567', 'オオサカマラソンジムキョク', 14,
  'admin@osakamarathon.jp', '大阪マラソン事務局', 'noreply@osakamarathon.jp',
  '定員に達し次第、受付を終了いたします。',
  'この度は大阪マラソン2024にエントリーいただき、ありがとうございます。大会当日のご健闘を心よりお祈り申し上げます。'
);

-- 3. 京都クラシックコンサート（音楽・コンサート、コンビニ決済）
INSERT INTO events (
  name, name_en, event_url, category, client_id, organizer_id, vendor_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_convenience_store,
  convenience_fee_type, convenience_fee_fixed,
  available_convenience_stores, store_code, convenience_payment_deadline,
  admin_email, sender_name, sender_email,
  thanks_msg
) VALUES (
  '京都クラシックコンサート', 'Kyoto Classical Concert', 'kyoto-classical-concert',
  '3', 1, 1, 1, 'KYOTO',
  '世界的指揮者による特別公演。ベートーヴェン交響曲第9番「合唱」を演奏いたします。',
  '京都コンサートホール 大ホール', 'お問い合わせ：075-123-4567\nメール：info@kyoto-concert.jp',
  'button', 'standalone', 1,
  '2024-06-01', '2024-11-30', '2024-12-20', '2024-12-20',
  1, 1,
  'fixed', 220,
  'seven_eleven,family_mart,lawson', 'KYO001', 7,
  'admin@kyoto-concert.jp', '京都コンサート事務局', 'noreply@kyoto-concert.jp',
  'この度は京都クラシックコンサートにお申し込みいただき、誠にありがとうございます。素晴らしい演奏をお楽しみください。'
);

-- 4. 北海道グルメフェア2024（食・グルメ、決済なし）
INSERT INTO events (
  name, name_en, event_url, category, client_id, organizer_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg,
  admin_email, sender_name, sender_email,
  remarks, thanks_msg
) VALUES (
  '北海道グルメフェア2024', 'Hokkaido Gourmet Fair 2024', 'hokkaido-gourmet-fair-2024',
  '4', 3, 2, 'SAPPORO',
  '北海道各地の名産品が大集合！海鮮丼、ジンギスカン、スイーツなど、北の幸をお楽しみいただけます。入場無料。',
  '札幌ドーム イベント広場', 'お問い合わせ：011-123-4567\nメール：info@hokkaido-gourmet.jp',
  'button', 'standalone', 1,
  '2024-04-01', '2024-06-30', '2024-07-15', '2024-07-17',
  0,
  'admin@hokkaido-gourmet.jp', '北海道グルメフェア実行委員会', 'noreply@hokkaido-gourmet.jp',
  '入場無料。事前申込制（先着5000名）。',
  'この度は北海道グルメフェア2024にお申し込みいただき、ありがとうございます。当日は北海道の美味しいものをたくさんご用意してお待ちしております！'
);

-- 5. 沖縄リゾートツアー（観光・旅行、全決済方法対応）
INSERT INTO events (
  name, name_en, event_url, category, client_id, organizer_id, vendor_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_credit_card, payment_bank_transfer, payment_convenience_store,
  credit_fee_type, credit_fee_percentage,
  bank_fee_type, bank_fee_percentage,
  convenience_fee_type, convenience_fee_percentage,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  available_convenience_stores, store_code, convenience_payment_deadline,
  admin_email, sender_name, sender_email,
  remarks, thanks_msg
) VALUES (
  '沖縄リゾートツアー', 'Okinawa Resort Tour', 'okinawa-resort-tour',
  '5', 2, 3, 3, 'OKINAWA',
  '美ら海水族館、首里城、離島巡りなど、沖縄の魅力を3泊4日で満喫するツアーです。',
  '沖縄本島・石垣島・宮古島', 'お問い合わせ：098-123-4567\nメール：info@okinawa-tour.jp',
  'calendar', 'standalone', 1,
  '2024-01-15', '2024-10-31', '2024-11-15', '2024-03-31',
  1, 1, 1, 1,
  'percentage', 3.5,
  'percentage', 2.0,
  'percentage', 3.0,
  '琉球銀行', '本店', '普通', '9876543', 'オキナワツアージムキョク', 10,
  'seven_eleven,family_mart,lawson,seicomart', 'OKI001', 5,
  'admin@okinawa-tour.jp', '沖縄リゾートツアー事務局', 'noreply@okinawa-tour.jp',
  '最少催行人数：20名。天候により日程が変更となる場合があります。',
  'この度は沖縄リゾートツアーにお申し込みいただき、誠にありがとうございます。美しい沖縄の海と文化をお楽しみください。'
);

-- 6. ビジネスセミナー「DX時代の経営戦略」（ビジネス・セミナー、クレジット決済のみ）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, vendor_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_credit_card,
  credit_fee_type,
  admin_email, sender_name, sender_email,
  thanks_msg
) VALUES (
  'ビジネスセミナー「DX時代の経営戦略」', 'business-seminar-dx-strategy',
  '6', 1, 1, 1, 'TOKYO',
  'デジタルトランスフォーメーション（DX）を成功に導くための実践的な経営戦略セミナー。事例紹介、パネルディスカッション、質疑応答を予定しています。',
  '東京国際フォーラム ホールB5', 'お問い合わせ：03-5555-1234\nメール：seminar@business-dx.jp',
  'button', 'standalone', 1,
  '2024-02-01', '2024-04-25', '2024-05-15', '2024-05-15',
  1, 1,
  'none',
  'admin@business-dx.jp', 'DXセミナー運営事務局', 'noreply@business-dx.jp',
  'この度はビジネスセミナーにお申し込みいただき、ありがとうございます。当日は貴重な学びの機会をご提供いたします。'
);

-- 7. 子供向けプログラミング教室（教育・学習、銀行振込）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_bank_transfer,
  bank_fee_type, bank_fee_fixed,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  admin_email, sender_name, sender_email,
  remarks, thanks_msg
) VALUES (
  '子供向けプログラミング教室', 'kids-programming-class',
  '7', 3, 2, 'YOKOHAMA',
  '小学生向けのプログラミング入門教室。Scratchを使った楽しいゲーム作りを通じて、論理的思考力を育てます。全5回コース。',
  '横浜市青少年センター', 'お問い合わせ：045-123-4567\nメール：info@kids-programming.jp',
  'calendar', 'standalone', 1,
  '2024-03-01', '2024-05-31', '2024-06-15', '2024-07-20',
  1, 1,
  'fixed', 220,
  '横浜銀行', '本店営業部', '普通', '1112233', 'コドモプログラミングキョウシツ', 14,
  'admin@kids-programming.jp', 'プログラミング教室事務局', 'noreply@kids-programming.jp',
  '対象：小学3年生～6年生。定員：各回20名。',
  'プログラミング教室へのお申し込みありがとうございます。楽しく学べる5回のレッスンをご用意してお待ちしております。'
);

-- 8. ヨガ&瞑想リトリート（健康・ウェルネス、コンビニ＋クレジット）
INSERT INTO events (
  name, name_en, event_url, category, client_id, organizer_id, vendor_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_credit_card, payment_convenience_store,
  credit_fee_type, credit_fee_percentage,
  convenience_fee_type, convenience_fee_fixed,
  available_convenience_stores, store_code, convenience_payment_deadline,
  admin_email, sender_name, sender_email,
  thanks_msg
) VALUES (
  'ヨガ&瞑想リトリート', 'Yoga & Meditation Retreat', 'yoga-meditation-retreat',
  '8', 2, 3, 2, 'SHIZUOKA',
  '富士山麓の静かな環境で心と体をリフレッシュ。初心者でも安心してご参加いただけます。2泊3日の宿泊付きプログラム。',
  '静岡県富士宮市 リトリートセンター', 'お問い合わせ：0544-12-3456\nメール：info@yoga-retreat.jp',
  'calendar', 'standalone', 1,
  '2024-04-01', '2024-08-31', '2024-09-15', '2024-09-17',
  1, 1, 1,
  'percentage', 3.0,
  'fixed', 300,
  'seven_eleven,family_mart,lawson,ministop', 'FUJ001', 10,
  'admin@yoga-retreat.jp', 'ヨガリトリート運営事務局', 'noreply@yoga-retreat.jp',
  'ヨガ&瞑想リトリートにお申し込みいただき、ありがとうございます。心安らぐひとときをお過ごしください。'
);

-- 9. お笑いライブ「東京コメディナイト」（エンターテインメント、決済なし）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg,
  admin_email, sender_name, sender_email,
  thanks_msg
) VALUES (
  'お笑いライブ「東京コメディナイト」', 'tokyo-comedy-night',
  '9', 1, 1, 'TOKYO',
  '人気芸人が総出演！笑いの祭典。漫才、コント、ピン芸など、多彩なネタでお届けします。',
  '新宿文化センター 大ホール', 'お問い合わせ：03-9999-0000\nメール：info@comedy-night.jp',
  'button', 'standalone', 1,
  '2024-06-01', '2024-09-20', '2024-10-05', '2024-10-05',
  0,
  'admin@comedy-night.jp', 'コメディナイト運営事務局', 'noreply@comedy-night.jp',
  '東京コメディナイトへのお申し込みありがとうございます。笑いが絶えない楽しい夜をお約束します！'
);

-- 10. 新春初売りセール（季節イベント、全決済方法対応）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, vendor_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_credit_card, payment_bank_transfer, payment_convenience_store,
  credit_fee_type,
  bank_fee_type,
  convenience_fee_type,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  available_convenience_stores, store_code, convenience_payment_deadline,
  admin_email, sender_name, sender_email,
  remarks, thanks_msg
) VALUES (
  '新春初売りセール', 'new-year-sale',
  '10', 3, 2, 1, 'NAGOYA',
  '新年最初の大セール！福袋、先着プレゼント、限定商品など、お買い得商品が満載です。',
  '名古屋駅前 特設会場', 'お問い合わせ：052-111-2222\nメール：info@newyear-sale.jp',
  'button', 'standalone', 1,
  '2024-12-01', '2024-12-31', '2025-01-02', '2025-01-03',
  1, 1, 1, 1,
  'none',
  'none',
  'none',
  '名古屋銀行', '本店', '普通', '5556677', 'シンシュンハツウリジムキョク', 3,
  'seven_eleven,family_mart,lawson,daily_yamazaki', 'NGY001', 3,
  'admin@newyear-sale.jp', '新春初売り事務局', 'noreply@newyear-sale.jp',
  '数量限定商品は先着順となります。',
  '新春初売りセールへのご来場ありがとうございます。素敵な新年のお買い物をお楽しみください！'
);

-- 11. テストイベント（無効、デバッグ用）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg,
  admin_email, sender_name, sender_email
) VALUES (
  'テストイベント（無効）', 'test-event-disabled',
  '11', 1, 1, 'TEST',
  'これはテスト用のイベントデータです。公開されません。',
  'テスト会場', 'test@example.com',
  'button', 'standalone', 0,
  '2024-01-01', '2024-12-31', '2024-06-01', '2024-06-30',
  0,
  'test@example.com', 'テスト事務局', 'test@example.com'
);

-- 12. 親子で楽しむ科学実験教室（教育・学習、親イベント）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, branch_code,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg, payment_credit_card,
  credit_fee_type, credit_fee_percentage,
  admin_email, sender_name, sender_email,
  remarks, thanks_msg
) VALUES (
  '親子で楽しむ科学実験教室', 'parent-child-science-class',
  '7', 2, 2, 'SAITAMA',
  '身近な材料で驚きの科学実験！親子で一緒に科学の不思議を体験しましょう。',
  'さいたま市科学館', 'お問い合わせ：048-123-4567\nメール：info@science-class.jp',
  'calendar', 'parent', 1,
  '2024-04-01', '2024-07-31', '2024-08-10', '2024-08-25',
  1, 1,
  'percentage', 3.0,
  'admin@science-class.jp', '科学実験教室事務局', 'noreply@science-class.jp',
  '対象：小学生とその保護者。定員：各回15組30名。',
  '科学実験教室へのお申し込みありがとうございます。親子で楽しい科学の時間をお過ごしください。'
);

-- 13. 夏休み自由研究サポート講座（教育・学習、子イベント1）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, branch_code, parent_event_id,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg,
  admin_email, sender_name, sender_email,
  thanks_msg
) VALUES (
  '夏休み自由研究サポート講座【午前の部】', 'summer-research-morning',
  '7', 2, 2, 'SAITAMA', 12,
  '自由研究のテーマ決めから実験・まとめ方まで、科学の先生がサポートします（午前クラス）。',
  'さいたま市科学館 実験室A', 'お問い合わせ：048-123-4567',
  'button', 'child', 1,
  '2024-04-01', '2024-07-31', '2024-08-10', '2024-08-10',
  0,
  'admin@science-class.jp', '科学実験教室事務局', 'noreply@science-class.jp',
  '午前の部へのお申し込みありがとうございます。楽しく学びましょう！'
);

-- 14. 工作ワークショップ（教育・学習、子イベント2）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, branch_code, parent_event_id,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg,
  admin_email, sender_name, sender_email,
  thanks_msg
) VALUES (
  '工作ワークショップ【午後の部】', 'craft-workshop-afternoon',
  '7', 2, 2, 'SAITAMA', 12,
  'ペットボトルロケット、スライム作りなど、楽しい工作体験（午後クラス）。',
  'さいたま市科学館 実験室B', 'お問い合わせ：048-123-4567',
  'button', 'child', 1,
  '2024-04-01', '2024-07-31', '2024-08-15', '2024-08-15',
  0,
  'admin@science-class.jp', '科学実験教室事務局', 'noreply@science-class.jp',
  '午後の部へのお申し込みありがとうございます。素敵な作品を作りましょう！'
);

-- 15. プラネタリウム鑑賞会（教育・学習、子イベント3）
INSERT INTO events (
  name, event_url, category, client_id, organizer_id, branch_code, parent_event_id,
  detail, location, contact,
  date_selection_type, event_type, enable_flg,
  registration_start_date, registration_end_date, event_start_date, event_end_date,
  payment_flg,
  admin_email, sender_name, sender_email,
  thanks_msg
) VALUES (
  'プラネタリウム鑑賞会【特別上映】', 'planetarium-show',
  '7', 2, 2, 'SAITAMA', 12,
  '夏の星座を学ぼう！プラネタリウムでの特別上映会。',
  'さいたま市科学館 プラネタリウム', 'お問い合わせ：048-123-4567',
  'button', 'child', 1,
  '2024-04-01', '2024-07-31', '2024-08-25', '2024-08-25',
  0,
  'admin@science-class.jp', '科学実験教室事務局', 'noreply@science-class.jp',
  'プラネタリウム鑑賞会へのお申し込みありがとうございます。美しい星空をお楽しみください。'
);
