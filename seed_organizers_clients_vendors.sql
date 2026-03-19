-- 主催者管理と販売会社管理のダミーデータ

-- ====================================
-- 販売会社（clients）データ
-- ====================================
-- ID=1は既存データのため、ID=2から追加

-- 大手企業
INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, client_code, position, remarks, reg_flg, group_id)
VALUES 
  ('株式会社グローバルトラベル', '営業部 田中一郎', '東京本社', '経理部 鈴木花子', '100-0001', 13, '千代田区千代田1-1-1', '03-1234-5678', '03-1234-5679', 'info@global-travel.co.jp', 'global123', 'GT001', '営業部長', '大手旅行代理店', 1, 1);

INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, client_code, position, remarks, reg_flg, group_id)
VALUES 
  ('関西ツアーズ株式会社', '企画部 山本次郎', '大阪支店', '総務部 佐藤美咲', '530-0001', 27, '大阪市北区梅田1-1-1', '06-2345-6789', '06-2345-6790', 'contact@kansai-tours.co.jp', 'kansai123', 'KT001', '企画部課長', '関西地域主力', 1, 1);

INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, client_code, position, remarks, reg_flg, group_id)
VALUES 
  ('九州トラベルサービス', '営業課 福田隆', '福岡本社', '経理課 中村聡子', '810-0001', 40, '福岡市中央区天神1-1-1', '092-345-6789', '092-345-6790', 'info@kyushu-travel.co.jp', 'kyushu123', 'KTS001', '営業課長', '九州エリア専門', 1, 1);

-- 中小企業
INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, client_code, position, remarks, reg_flg, group_id)
VALUES 
  ('横浜観光プランニング', '代表 横山太郎', '本社', '経理担当 小林恵', '220-0001', 14, '横浜市西区みなとみらい1-1-1', '045-123-4567', '045-123-4568', 'info@yokohama-kanko.co.jp', 'yokohama123', 'YKP001', '代表取締役', '地元密着型', 1, 1);

INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, client_code, position, remarks, reg_flg, group_id)
VALUES 
  ('北海道ツアーコーディネート', '営業 札幌雪子', '札幌オフィス', '会計担当 旭川春美', '060-0001', 1, '札幌市中央区北1条西1-1', '011-234-5678', '011-234-5679', 'info@hokkaido-tour.co.jp', 'hokkaido123', 'HTC001', '営業主任', '北海道ツアー専門', 1, 1);

-- 自治体・公共団体
INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, client_code, position, remarks, reg_flg, group_id)
VALUES 
  ('長岡市観光協会', '事務局 長岡太郎', '事務局', '経理担当 越後花子', '940-0001', 15, '長岡市大手通1-1-1', '0258-12-3456', '0258-12-3457', 'info@nagaoka-kanko.jp', 'nagaoka123', 'NK001', '事務局長', '公的機関', 1, 1);

INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, client_code, position, remarks, reg_flg, group_id)
VALUES 
  ('京都市文化観光局', '企画課 京都次郎', '本庁舎', '会計課 宇治美咲', '604-0001', 26, '京都市中京区寺町通御池上る', '075-456-7890', '075-456-7891', 'kikaku@kyoto-bunka.jp', 'kyoto123', 'KCT001', '企画課長', '市役所観光部門', 1, 1);

-- 停止中（テスト用）
INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, client_code, position, remarks, reg_flg, group_id)
VALUES 
  ('停止中旅行社', '担当者 停止太郎', '本社', '経理 停止花子', '100-0000', 13, '東京都千代田区丸の内1-1-1', '03-0000-0000', '03-0000-0001', 'disabled@example.com', 'disabled123', 'DIS001', '担当者', '登録停止中のテストデータ', 0, 1);

-- ====================================
-- 主催者（organizers）データ
-- ====================================

-- イベント系主催者
INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('東京モーターショー実行委員会', '事務局 自動車太郎', 'info@tokyo-motorshow.jp', '03-3456-7890', '03-3456-7891', '東京ビッグサイト', '135-0063', 13, '江東区有明3-11-1', 'motorshow123', '9:00-18:00', '土日祝', '大規模イベント主催', '観光庁長官登録旅行業第1234号', '日本旅行業協会', '正会員', '旅行業務取扱管理者', '運輸花子', '自動車業界最大級のイベント', 1);

INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('長岡花火財団', '総務部 長岡三郎', 'info@nagaoka-hanabi.jp', '0258-34-5678', '0258-34-5679', '長岡市役所内', '940-0062', 15, '長岡市大手通2-6', 'hanabi123', '8:30-17:30', '土日祝（7-8月は無休）', '花火大会運営', '新潟県知事登録旅行業第567号', '全国旅行業協会', '正会員', '総合旅行業務取扱管理者', '信濃次郎', '日本三大花火大会', 1);

INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('コミックマーケット準備会', '運営部 秋葉原太郎', 'info@comiket.jp', '03-5678-9012', '03-5678-9013', '東京都内', '101-0021', 13, '千代田区外神田1-1-1', 'comiket123', '10:00-20:00', '不定休', '同人誌即売会', NULL, NULL, NULL, NULL, NULL, '世界最大級の同人誌即売会', 1);

-- スポーツイベント
INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('東京マラソン財団', '事業部 ランナー一郎', 'info@marathon.tokyo', '03-6789-0123', '03-6789-0124', '東京都庁内', '163-8001', 13, '新宿区西新宿2-8-1', 'marathon123', '9:00-17:00', '土日祝', 'マラソン大会運営', '観光庁長官登録旅行業第2345号', '日本旅行業協会', '正会員', '国内旅行業務取扱管理者', '駅伝花子', '世界6大マラソン', 1);

INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('阪神タイガース応援ツアー企画', '営業部 虎吉', 'tour@hanshin-tigers.jp', '06-7890-1234', '06-7890-1235', '甲子園球場', '663-8152', 28, '西宮市甲子園町1-82', 'tigers123', '10:00-18:00', '月曜日', '野球観戦ツアー', '大阪府知事登録旅行業第678号', '全国旅行業協会', '正会員', '国内旅行業務取扱管理者', '甲子園次郎', 'プロ野球観戦パック', 1);

-- 文化・芸術イベント
INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('京都国際映画祭実行委員会', '企画課 映画太郎', 'info@kyoto-film-festival.jp', '075-890-1234', '075-890-1235', '京都文化博物館', '604-8183', 26, '京都市中京区三条高倉', 'film123', '10:00-19:00', '月曜日', '国際映画祭運営', '京都府知事登録旅行業第789号', '日本旅行業協会', '正会員', '総合旅行業務取扱管理者', '撮影花子', '国際映画祭', 1);

INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('さっぽろ雪まつり実行委員会', '総務課 雪子', 'info@sapporo-snow-festival.jp', '011-890-1234', '011-890-1235', '札幌市役所内', '060-8611', 1, '札幌市中央区北1条西2', 'snow123', '8:45-17:15', '土日祝', '冬季イベント運営', '北海道知事登録旅行業第890号', '全国旅行業協会', '正会員', '国内旅行業務取扱管理者', '氷彫太郎', '世界的な冬祭り', 1);

-- 音楽フェス
INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('フジロック運営事務局', '制作部 ロック太郎', 'info@fujirockfestival.jp', '025-789-0123', '025-789-0124', '新潟県湯沢町', '949-6101', 15, '南魚沼郡湯沢町三国202', 'fujirock123', '10:00-18:00', '月曜日', '野外音楽フェス', '新潟県知事登録旅行業第901号', '日本旅行業協会', '正会員', '総合旅行業務取扱管理者', 'ミュージック花子', '日本最大級ロックフェス', 1);

-- 停止中（テスト用）
INSERT INTO organizers (name, contactable_person, email, tel, fax, branch_office, zip, pref_id, addr, password, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES 
  ('停止中イベント企画', '担当者 停止三郎', 'disabled@event-example.com', '03-0000-0002', '03-0000-0003', '東京都', '100-0000', 13, '千代田区丸の内1-1-1', 'disabled123', '9:00-18:00', '土日祝', 'テストデータ', NULL, NULL, NULL, NULL, NULL, '登録停止中のテストデータ', 0);

-- ====================================
-- 販売会社（vendors）データ
-- ====================================

INSERT INTO vendors (name, contactable_person, email, tel, fax, zip, pref_id, addr, password, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES 
  ('ジェイティービー', '営業本部 JTB太郎', 'sales@jtb.co.jp', '03-5678-1234', '03-5678-1235', '140-8602', 13, '品川区東品川2-3-11', 'jtb123', '9:30-17:30', '土日祝', '大手旅行代理店', '国内最大手', 1);

INSERT INTO vendors (name, contactable_person, email, tel, fax, zip, pref_id, addr, password, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES 
  ('エイチ・アイ・エス', '法人営業部 HIS花子', 'corporate@his-j.com', '03-6789-2345', '03-6789-2346', '163-0590', 13, '新宿区西新宿6-8-1', 'his123', '10:00-19:00', '不定休', '格安パッケージツアー', '若年層に人気', 1);

INSERT INTO vendors (name, contactable_person, email, tel, fax, zip, pref_id, addr, password, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES 
  ('日本旅行', '団体旅行部 日旅次郎', 'dantai@nta.co.jp', '03-7890-3456', '03-7890-3457', '104-8237', 13, '中央区八重洲1-5-8', 'nta123', '9:00-18:00', '土日祝', 'JRグループ', '鉄道系旅行会社', 1);

INSERT INTO vendors (name, contactable_person, email, tel, fax, zip, pref_id, addr, password, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES 
  ('近畿日本ツーリスト', '関西支店 近ツリ三郎', 'kansai@knt.co.jp', '06-8901-4567', '06-8901-4568', '530-8628', 27, '大阪市北区梅田1-13-13', 'knt123', '10:00-18:00', '月曜日', '近鉄グループ', '関西地盤', 1);

INSERT INTO vendors (name, contactable_person, email, tel, fax, zip, pref_id, addr, password, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES 
  ('クラブツーリズム', 'テーマ旅行課 クラツー四郎', 'theme@club-t.com', '03-9012-5678', '03-9012-5679', '160-8308', 13, '新宿区西新宿6-3-1', 'club123', '9:30-17:30', '土日祝', 'テーマ特化ツアー', '中高年向け', 1);

INSERT INTO vendors (name, contactable_person, email, tel, fax, zip, pref_id, addr, password, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES 
  ('楽天トラベル', 'イベント事業部 楽天五郎', 'event@travel.rakuten.co.jp', '03-0123-6789', '03-0123-6790', '140-0002', 13, '品川区東品川4-12-3', 'rakuten123', '10:00-19:00', '無休', 'オンライン旅行予約', 'EC最大手', 1);

INSERT INTO vendors (name, contactable_person, email, tel, fax, zip, pref_id, addr, password, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES 
  ('じゃらん', 'レジャー企画部 じゃらん六郎', 'leisure@jalan.net', '03-1234-7890', '03-1234-7891', '100-6640', 13, '千代田区丸の内1-9-2', 'jalan123', '9:00-18:00', '土日祝', 'レジャー予約サイト', 'リクルート系', 1);

INSERT INTO vendors (name, contactable_person, email, tel, fax, zip, pref_id, addr, password, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES 
  ('停止中販売会社', '担当 停止四郎', 'disabled@vendor-example.com', '03-0000-0004', '03-0000-0005', '100-0000', 13, '東京都千代田区丸の内1-1-1', 'disabled123', '9:00-18:00', '土日祝', 'テストデータ', '登録停止中のテストデータ', 0);
