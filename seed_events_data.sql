-- ============================================
-- イベントテストデータ
-- 生成日時: 2026-02-12
-- ============================================

-- イベント1: 富士山登山ツアー（夏季）
INSERT INTO events (
  name, detail, contact, remarks, question, postage, thanks_msg, note,
  client_id, company_flg, enable_flg, payment_flg, payment_cd,
  customer_client_id, vendor_id, organizer_id,
  event_url, category, date_selection_type, location,
  registration_start_date, registration_end_date,
  event_start_date, event_end_date,
  admin_email, admin_name, sender_name, sender_email,
  email_signature, email_signature_en,
  admin_login_start_date, admin_login_end_date,
  payment_methods, payment_credit_card, payment_bank_transfer, payment_convenience_store,
  credit_fee_type, credit_fee_percentage, credit_fee_fixed,
  bank_fee_type, bank_fee_percentage, bank_fee_fixed,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  convenience_fee_type, convenience_fee_percentage, convenience_fee_fixed,
  store_code, convenience_payment_deadline, available_convenience_stores,
  form_field_settings,
  auto_reply_enabled,
  auto_reply_credit_payment,
  auto_reply_bank_payment,
  cancellation_policy_details,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2,
  cancellation_days_3, cancellation_rate_3
) VALUES (
  '富士山登山ツアー2026夏',
  '日本最高峰・富士山（標高3,776m）への登頂を目指す1泊2日のツアーです。
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
- 温泉入浴券',
  '京王グループツアーズ
TEL: 03-1111-2222
Email: yamada@keio-tours.co.jp
受付時間: 平日9:00-18:00',
  '登山経験のある方のご参加を推奨します。
高山病のリスクがありますので、体調管理に十分ご注意ください。',
  '登山経験はありますか？（初めて・1-2回・3回以上）
登山靴はお持ちですか？（持っている・レンタル希望）
食物アレルギーはありますか？',
  0,
  'この度は富士山登山ツアーにお申込みいただき、誠にありがとうございます。
日本最高峰の絶景を、安全に楽しんでいただけるよう全力でサポートいたします。
当日お会いできることを楽しみにしております。',
  '悪天候時は中止または日程変更となります。
装備リストは別途お送りします。',
  1, 0, 1, 1, NULL,
  1, NULL, 1,
  'fujisan-2026-summer', '登山・トレッキング', 'single', '山梨県富士吉田市 富士山',
  '2026-03-01', '2026-07-31',
  '2026-08-01', '2026-08-31',
  'yamada@keio-tours.co.jp', '山田太郎', '京王グループツアーズ', 'info@keio-tours.co.jp',
  '━━━━━━━━━━━━━━━━━━━━
京王グループツアーズ
〒160-0023 東京都新宿区西新宿1-10-1
TEL: 03-1111-2222 / FAX: 03-1111-2223
Email: info@keio-tours.co.jp
━━━━━━━━━━━━━━━━━━━━',
  'KEIO GROUP TOURS
1-10-1 Nishi-Shinjuku, Shinjuku-ku, Tokyo
TEL: +81-3-1111-2222
Email: info@keio-tours.co.jp',
  '2026-02-15', '2026-09-30',
  'credit,bank,convenience', 1, 1, 1,
  'percentage', 3.5, 0,
  'customer', 0, 330,
  'みずほ銀行', '新宿支店', '普通', '1234567', 'ケイオウグループツアーズ', 7,
  'fixed', 0, 330,
  'KEIO001', 7, '["セブンイレブン","ファミリーマート","ローソン"]',
  '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":true,"age":false}',
  1,
  'ご予約ありがとうございます。
決済が完了次第、詳細な行程表と装備リストをお送りいたします。',
  'ご予約ありがとうございます。
お振込確認後、詳細な行程表と装備リストをお送りいたします。
振込期限: お申込みから7日以内',
  '■キャンセル料について
出発日の21日前まで：無料
20日前～8日前：旅行代金の20%
7日前～2日前：旅行代金の30%
前日：旅行代金の40%
当日・無連絡不参加：旅行代金の100%',
  21, 0,
  8, 20,
  2, 30
);

-- イベント2: 箱根温泉リゾートステイ（春季）
INSERT INTO events (
  name, detail, contact, remarks, postage, thanks_msg, note,
  client_id, company_flg, enable_flg, payment_flg,
  customer_client_id, organizer_id,
  event_url, category, date_selection_type, location,
  registration_start_date, registration_end_date,
  event_start_date, event_end_date,
  admin_email, admin_name, sender_name, sender_email,
  email_signature,
  admin_login_start_date, admin_login_end_date,
  payment_methods, payment_credit_card, payment_bank_transfer,
  credit_fee_type, credit_fee_percentage,
  bank_fee_type, bank_fee_percentage, bank_fee_fixed,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  form_field_settings,
  auto_reply_enabled,
  auto_reply_credit_payment,
  cancellation_policy_details,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  '箱根温泉リゾート 春の特別プラン',
  '春の箱根を満喫する2泊3日の温泉リゾートステイ。
名湯として知られる箱根温泉で、日頃の疲れを癒しませんか？

【プランの特徴】
- 源泉かけ流しの露天風呂付き客室
- 地元食材を使った懐石料理（夕朝食付）
- 箱根美術館入館券付き
- 箱根登山鉄道フリーパス付き

【おすすめポイント】
春の箱根は桜や新緑が美しく、気候も穏やかで観光に最適です。
芦ノ湖遊覧、大涌谷見学など周辺観光も充実しています。',
  '箱根温泉旅館組合
TEL: 0460-4444-5555
Email: tanaka@hakone-onsen.or.jp
受付時間: 9:00-18:00',
  'お子様連れ歓迎。お部屋タイプは予約時にご相談ください。',
  0,
  '箱根温泉リゾートへようこそ。
ごゆっくりお寛ぎいただき、心身ともにリフレッシュしていただければ幸いです。
スタッフ一同、心よりお待ちしております。',
  '土日祝日は混雑が予想されます。平日のご利用をおすすめします。',
  2, 0, 1, 1,
  2, 4,
  'hakone-spring-2026', '温泉・宿泊', 'single', '神奈川県足柄下郡箱根町',
  '2026-01-15', '2026-04-30',
  '2026-04-01', '2026-05-31',
  'tanaka@hakone-onsen.or.jp', '田中温子', '箱根温泉旅館組合', 'info@hakone-onsen.or.jp',
  '━━━━━━━━━━━━━━━━━━━━
箱根温泉旅館組合
〒250-0311 神奈川県足柄下郡箱根町湯本茶屋6-6-6
TEL: 0460-4444-5555
Email: info@hakone-onsen.or.jp
━━━━━━━━━━━━━━━━━━━━',
  '2026-01-10', '2026-06-30',
  'credit,bank', 1, 1,
  'percentage', 3.0,
  'customer', 0, 330,
  '横浜銀行', '箱根支店', '普通', '2345678', 'ハコネオンセンリョカンクミアイ', 10,
  '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}',
  1,
  'ご予約ありがとうございます。
チェックイン時間は15:00以降、チェックアウトは10:00までとなります。',
  '■キャンセル料について
宿泊日の14日前まで：無料
13日前～7日前：宿泊料金の20%
6日前～2日前：宿泊料金の30%
前日：宿泊料金の50%
当日・無連絡不参加：宿泊料金の100%',
  14, 0,
  7, 20
);

-- イベント3: 東京シティツアー（通年）
INSERT INTO events (
  name, detail, contact, remarks, postage, thanks_msg,
  client_id, company_flg, enable_flg, payment_flg,
  customer_client_id, organizer_id,
  event_url, category, date_selection_type, location,
  registration_start_date, registration_end_date,
  event_start_date, event_end_date,
  admin_email, sender_name, sender_email,
  email_signature, email_signature_en,
  admin_login_start_date, admin_login_end_date,
  payment_methods, payment_credit_card, payment_bank_transfer, payment_convenience_store,
  credit_fee_type, credit_fee_percentage,
  bank_fee_type, bank_fee_fixed,
  convenience_fee_type, convenience_fee_fixed,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  store_code, convenience_payment_deadline, available_convenience_stores,
  form_field_settings,
  name_en, detail_en, location_en,
  auto_reply_enabled,
  cancellation_policy_details,
  cancellation_days_1, cancellation_rate_1
) VALUES (
  '東京1日観光ツアー 英語ガイド付き',
  '英語ガイド付きで巡る東京の名所を巡る1日ツアー。
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
- 昼食（日本料理）',
  '東京シティガイド協会
TEL: 03-5555-6666
Email: johnson@tokyo-guide.org
Hours: 9:00-17:00',
  '英語対応可能。日本語ガイドをご希望の場合はお問い合わせください。',
  0,
  'Thank you for booking Tokyo City Tour!
We look forward to showing you the best of Tokyo.',
  3, 0, 1, 1,
  3, 5,
  'tokyo-city-tour-2026', '観光・ツアー', 'button', '東京都内各所',
  '2026-01-01', '2026-12-20',
  '2026-01-01', '2026-12-31',
  'johnson@tokyo-guide.org', 'Tokyo City Guide', 'info@tokyo-guide.org',
  '━━━━━━━━━━━━━━━━━━━━
東京シティガイド協会
〒100-0005 東京都千代田区丸の内1-7-7
TEL: 03-5555-6666
Email: info@tokyo-guide.org
━━━━━━━━━━━━━━━━━━━━',
  'Tokyo City Guide Association
1-7-7 Marunouchi, Chiyoda-ku, Tokyo
TEL: +81-3-5555-6666
Email: info@tokyo-guide.org',
  '2025-12-01', '2027-01-31',
  'credit,bank,convenience', 1, 1, 1,
  'percentage', 3.5,
  'fixed', 330,
  'fixed', 330,
  '三菱UFJ銀行', '東京営業部', '普通', '3456789', 'トウキョウシティガイドキョウカイ', 5,
  'TOKYO001', 5, '["セブンイレブン","ファミリーマート","ローソン","ミニストップ"]',
  '{"name_kanji":true,"name_kana":true,"name_roma":true,"address":false,"tel":true,"birth_date":false,"age":false}',
  'Tokyo City Tour with English Guide',
  'Full-day sightseeing tour of Tokyo with professional English-speaking guide.

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
- Japanese lunch',
  'Tokyo Metropolitan Area',
  1,
  '■Cancellation Policy
Up to 7 days before: Free
6-3 days before: 30% of tour price
2-1 days before: 50% of tour price
Same day/No show: 100% of tour price',
  7, 0
);

-- イベント4: 多摩地域サイクリングツアー（秋季）
INSERT INTO events (
  name, detail, contact, remarks, postage, thanks_msg, note,
  client_id, company_flg, enable_flg, payment_flg,
  customer_client_id, organizer_id,
  event_url, category, date_selection_type, location,
  registration_start_date, registration_end_date,
  event_start_date, event_end_date,
  admin_email, admin_name, sender_name, sender_email,
  email_signature,
  admin_login_start_date, admin_login_end_date,
  payment_methods, payment_credit_card, payment_bank_transfer,
  credit_fee_type, credit_fee_percentage,
  bank_fee_type, bank_fee_fixed,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  form_field_settings,
  auto_reply_enabled,
  auto_reply_credit_payment,
  auto_reply_bank_payment,
  cancellation_policy_details,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2
) VALUES (
  '多摩丘陵サイクリング 紅葉満喫コース',
  '秋の多摩丘陵を自転車で巡る日帰りツアー。
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
- ドリンク',
  '多摩地域観光推進協議会
TEL: 042-2222-3333
Email: sato@tama-tourism.jp
受付時間: 平日9:00-17:00',
  '自転車に乗れる方が対象です。
雨天の場合は中止となり、全額返金いたします。',
  0,
  '多摩丘陵の美しい紅葉と、地域の魅力をお楽しみください。
安全運転で、気持ちの良いサイクリングをお楽しみいただけます。',
  '電動アシスト自転車をご希望の方は予約時にお申し出ください（追加料金なし）。',
  4, 0, 1, 1,
  4, 2,
  'tama-cycling-autumn-2026', 'サイクリング・アウトドア', 'single', '東京都立川市・武蔵村山市周辺',
  '2026-08-01', '2026-10-31',
  '2026-10-15', '2026-11-30',
  'sato@tama-tourism.jp', '佐藤花子', '多摩地域観光推進協議会', 'info@tama-tourism.jp',
  '━━━━━━━━━━━━━━━━━━━━
多摩地域観光推進協議会
〒190-0012 東京都立川市曙町2-1-1
TEL: 042-2222-3333
Email: info@tama-tourism.jp
━━━━━━━━━━━━━━━━━━━━',
  '2026-07-01', '2026-12-31',
  'credit,bank', 1, 1,
  'percentage', 3.5,
  'customer', 330,
  'きらぼし銀行', '立川支店', '普通', '4567890', 'タマチイキカンコウスイシンキョウギカイ', 7,
  '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":false,"tel":true,"birth_date":true,"age":false}',
  1,
  'ご予約ありがとうございます。
当日は動きやすい服装と、タオル・飲み物をお持ちください。',
  'ご予約ありがとうございます。
お振込確認後、集合場所の詳細地図をお送りいたします。',
  '■キャンセル料について
実施日の7日前まで：無料
6日前～3日前：参加費の30%
2日前～前日：参加費の50%
当日・無連絡不参加：参加費の100%',
  7, 0,
  3, 30
);

-- イベント5: エコツーリズム体験プログラム（春～秋）
INSERT INTO events (
  name, detail, contact, remarks, postage, thanks_msg, note,
  client_id, company_flg, enable_flg, payment_flg,
  customer_client_id, organizer_id,
  event_url, category, date_selection_type, location,
  registration_start_date, registration_end_date,
  event_start_date, event_end_date,
  admin_email, admin_name, sender_name, sender_email,
  email_signature,
  admin_login_start_date, admin_login_end_date,
  payment_methods, payment_credit_card, payment_bank_transfer, payment_convenience_store,
  credit_fee_type, credit_fee_percentage,
  bank_fee_type, bank_fee_fixed,
  convenience_fee_type, convenience_fee_fixed,
  bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name, bank_transfer_deadline,
  store_code, convenience_payment_deadline, available_convenience_stores,
  form_field_settings,
  auto_reply_enabled,
  auto_reply_credit_payment,
  auto_reply_bank_payment,
  cancellation_policy_details,
  cancellation_days_1, cancellation_rate_1,
  cancellation_days_2, cancellation_rate_2,
  cancellation_days_3, cancellation_rate_3
) VALUES (
  '里山エコツーリズム 自然体験プログラム',
  '都心から1時間、里山で自然とふれあう1日体験プログラム。
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
小学生から大人まで。ファミリーでの参加も大歓迎です。',
  'エコツーリズム推進協議会
TEL: 03-5678-9012
Email: nakamura@eco-tourism.jp
受付時間: 平日9:00-17:00',
  '小学生以下のお子様は保護者同伴でご参加ください。
汚れてもよい服装、長靴または運動靴でお越しください。',
  0,
  'エコツーリズム体験プログラムへようこそ。
自然との共生、持続可能な社会について、楽しく学んでいただけます。
皆様のご参加を心よりお待ちしております。',
  '悪天候時は屋内プログラムに変更します（中止の場合は全額返金）。
季節によって体験内容が異なります。',
  5, 0, 1, 1,
  5, 2,
  'eco-tourism-2026', 'エコツアー・体験', 'single', '東京都・埼玉県 里山エリア',
  '2026-02-01', '2026-09-30',
  '2026-04-01', '2026-10-31',
  'nakamura@eco-tourism.jp', '中村環', 'エコツーリズム推進協議会', 'info@eco-tourism.jp',
  '━━━━━━━━━━━━━━━━━━━━
エコツーリズム推進協議会
〒102-0072 東京都千代田区飯田橋4-4-4
TEL: 03-5678-9012
Email: info@eco-tourism.jp
━━━━━━━━━━━━━━━━━━━━',
  '2026-01-15', '2026-11-30',
  'credit,bank,convenience', 1, 1, 1,
  'percentage', 3.0,
  'customer', 330,
  'fixed', 330,
  '三井住友銀行', '飯田橋支店', '普通', '5678901', 'エコツーリズムスイシンキョウギカイ', 7,
  'ECO001', 7, '["セブンイレブン","ファミリーマート","ローソン"]',
  '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":true,"age":true}',
  1,
  'ご予約ありがとうございます。
当日は汚れてもよい服装と、タオル・着替えをお持ちください。
集合場所は事前にメールでお知らせいたします。',
  'ご予約ありがとうございます。
お振込確認後、詳細な行程表と持ち物リストをお送りいたします。',
  '■キャンセル料について
実施日の14日前まで：無料
13日前～7日前：参加費の20%
6日前～3日前：参加費の30%
2日前～前日：参加費の50%
当日・無連絡不参加：参加費の100%',
  14, 0,
  7, 20,
  3, 30
);
