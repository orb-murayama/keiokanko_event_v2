-- ============================================
-- テストデータ投入スクリプト
-- 生成日時: 2026-02-12
-- ============================================

-- ============================================
-- クライアント（clients）
-- ============================================
INSERT INTO clients (name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, remarks, reg_flg, group_id, client_code, position) VALUES
('京王観光株式会社', '田中太郎', '本社', '経理部 山田花子', '160-0023', 13, '新宿区西新宿1-1-1', '03-1234-5678', '03-1234-5679', 'tanaka@keio-kanko.co.jp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '主要取引先', 1, 1, 'CLI001', '営業部長'),
('株式会社旅の友', '鈴木一郎', '東京支店', '営業部 佐藤次郎', '100-0001', 13, '千代田区千代田1-1', '03-2345-6789', '03-2345-6780', 'suzuki@tabinotomo.co.jp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', 'VIP顧客', 1, 1, 'CLI002', '支店長'),
('グローバルツアーズ', 'Michael Smith', '日本支社', 'Finance Team', '105-0001', 13, '港区虎ノ門2-2-2', '03-3456-7890', '03-3456-7891', 'smith@globaltours.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '海外顧客', 1, 2, 'CLI003', 'Manager'),
('日本トラベル協会', '高橋美咲', '事務局', '総務課 伊藤健太', '150-0001', 13, '渋谷区神宮前3-3-3', '03-4567-8901', '03-4567-8902', 'takahashi@jta.or.jp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '協会関係', 1, 1, 'CLI004', '事務局長'),
('エコツーリズム推進協議会', '中村環', '企画部', '企画課 小林緑', '102-0072', 13, '千代田区飯田橋4-4-4', '03-5678-9012', '03-5678-9013', 'nakamura@eco-tourism.jp', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', 'エコツアー専門', 1, 1, 'CLI005', '企画部長');

-- ============================================
-- 主催者（organizers）
-- ============================================
INSERT INTO organizers (name, contactable_person, email, tel, branch_office, reg_flg, zip, pref_id, addr, fax, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks) VALUES
('京王グループツアーズ', '山田太郎', 'yamada@keio-tours.co.jp', '03-1111-2222', '新宿本社', 1, '160-0023', 13, '新宿区西新宿1-10-1', '03-1111-2223', '平日9:00-18:00', '土日祝', '各種ツアー企画・運営', 'T-001-12345', '日本旅行業協会', 'JATA会員', '旅行業務取扱管理者', '山田太郎', 'メイン主催者'),
('多摩地域観光推進協議会', '佐藤花子', 'sato@tama-tourism.jp', '042-2222-3333', '立川事務所', 1, '190-0012', 13, '立川市曙町2-1-1', '042-2222-3334', '平日9:00-17:00', '土日祝', '多摩地域の観光振興', 'T-002-23456', '多摩観光連盟', '理事会員', '事務局長', '佐藤花子', '地域密着型'),
('富士山ネイチャーツアーズ', '鈴木登', 'suzuki@fujisan-nature.jp', '0555-3333-4444', '富士吉田営業所', 1, '403-0005', 19, '富士吉田市上吉田5-5-5', '0555-3333-4445', '8:00-19:00', '不定休', '富士山周辺ツアー専門', 'T-003-34567', '山梨県旅行業協会', '正会員', '総合旅行業務取扱管理者', '鈴木登', '富士山エリア専門'),
('箱根温泉旅館組合', '田中温子', 'tanaka@hakone-onsen.or.jp', '0460-4444-5555', '箱根湯本事務局', 1, '250-0311', 14, '足柄下郡箱根町湯本茶屋6-6-6', '0460-4444-5556', '9:00-18:00', '年末年始', '箱根温泉地域の観光振興', 'T-004-45678', '箱根観光協会', '組合員', '組合長', '田中温子', '温泉旅館組合'),
('東京シティガイド協会', 'Emily Johnson', 'johnson@tokyo-guide.org', '03-5555-6666', '東京支部', 1, '100-0005', 13, '千代田区丸の内1-7-7', '03-5555-6667', '9:00-17:00', '土日祝', '東京観光ガイド事業', 'T-005-56789', '全国通訳案内士協会', '認定団体', 'Director', 'Emily Johnson', '英語ガイド専門');

-- ============================================
-- ベンダー（vendors）
-- ============================================
INSERT INTO vendors (name, contactable_person, email, tel, reg_flg, zip, pref_id, addr, fax, business_hours, closed_days, business_notes, remarks) VALUES
('富士急バス株式会社', '高橋運転', 'takahashi@fujikyu-bus.co.jp', '0555-1111-2222', 1, '403-0016', 19, '富士吉田市松山1-1-1', '0555-1111-2223', '24時間対応', 'なし', '観光バス・貸切バス事業', '大型バス20台保有'),
('箱根登山観光バス', '小林ドライブ', 'kobayashi@hakone-bus.co.jp', '0460-2222-3333', 1, '250-0311', 14, '足柄下郡箱根町湯本2-2-2', '0460-2222-3334', '6:00-22:00', '不定休', '箱根エリア専門', '中型バス10台'),
('東京シティクルーズ', '伊藤船長', 'ito@tokyo-cruise.jp', '03-3333-4444', 1, '105-0011', 13, '港区芝公園3-3-3', '03-3333-4445', '8:00-20:00', '月曜', '東京湾クルーズ', '大型船2隻・小型船5隻'),
('多摩ケータリングサービス', '渡辺料理', 'watanabe@tama-catering.jp', '042-4444-5555', 1, '190-0012', 13, '立川市曙町4-4-4', '042-4444-5556', '7:00-22:00', 'なし', '弁当・ケータリング', '1日1000食対応可能'),
('富士山ガイドセンター', '山本登山', 'yamamoto@fujisan-guide.jp', '0555-5555-6666', 1, '403-0005', 19, '富士吉田市上吉田5-5-5', '0555-5555-6667', '7:00-18:00', '悪天候時', '富士登山ガイド', '認定ガイド20名在籍');

-- ============================================
-- アカウント（accounts）
-- ============================================
-- パスワードは全て 'password123' のハッシュ値
INSERT INTO accounts (login_id, password, person_name, email, client_id, role, enable_flg, account_type, primary_branch_code, accessible_branches, expiration_date, tel, mobile) VALUES
-- システム管理者
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', 'システム管理者', 'admin@keio-kanko.co.jp', NULL, 'admin', 1, 'keio', NULL, NULL, NULL, '03-1234-5678', '090-1234-5678'),

-- 京王観光スタッフ（本社）
('keio_honsha', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '本社管理者', 'honsha@keio-kanko.co.jp', NULL, 'staff', 1, 'keio', 'HON', '["HON","SHI","TAC","HNO"]', NULL, '03-1234-5678', '090-1111-2222'),
('keio_shinjuku', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '新宿支店担当', 'shinjuku@keio-kanko.co.jp', NULL, 'staff', 1, 'keio', 'SHI', '["SHI"]', NULL, '03-2345-6789', '090-2222-3333'),
('keio_tachikawa', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '立川支店担当', 'tachikawa@keio-kanko.co.jp', NULL, 'staff', 1, 'keio', 'TAC', '["TAC"]', NULL, '042-1234-5678', '090-3333-4444'),
('keio_hachioji', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '八王子支店担当', 'hachioji@keio-kanko.co.jp', NULL, 'staff', 1, 'keio', 'HNO', '["HNO"]', NULL, '042-2345-6789', '090-4444-5555'),

-- クライアント管理者
('client_keio', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '田中太郎', 'tanaka@keio-kanko.co.jp', 1, 'client_admin', 1, 'client', NULL, NULL, '2025-12-31', '03-1234-5678', '090-5555-6666'),
('client_tabinotomo', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '鈴木一郎', 'suzuki@tabinotomo.co.jp', 2, 'client_admin', 1, 'client', NULL, NULL, '2025-12-31', '03-2345-6789', '090-6666-7777'),
('client_global', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', 'Michael Smith', 'smith@globaltours.com', 3, 'client_admin', 1, 'client', NULL, NULL, '2025-12-31', '03-3456-7890', '090-7777-8888'),

-- 主催者管理者
('organizer_keio_tours', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '山田太郎', 'yamada@keio-tours.co.jp', NULL, 'organizer', 1, 'organizer', NULL, NULL, '2025-12-31', '03-1111-2222', '090-8888-9999'),
('organizer_tama', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '佐藤花子', 'sato@tama-tourism.jp', NULL, 'organizer', 1, 'organizer', NULL, NULL, '2025-12-31', '042-2222-3333', '090-9999-0000');

-- ============================================
-- 会員（members）
-- ============================================
-- パスワードは全て 'member123' のハッシュ値
INSERT INTO members (email, password_hash, family_name, first_name, family_kana, first_kana, last_name_en, first_name_en, sex, birth, zip, pref_id, addr, tel, mobile, enable_flg) VALUES
('yamada.taro@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '山田', '太郎', 'ヤマダ', 'タロウ', 'Yamada', 'Taro', '男性', '1985-04-15', '160-0023', 13, '新宿区西新宿1-1-1 マンションA 101', '03-1234-5678', '090-1234-5678', 1),
('suzuki.hanako@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '鈴木', '花子', 'スズキ', 'ハナコ', 'Suzuki', 'Hanako', '女性', '1990-08-20', '150-0001', 13, '渋谷区神宮前2-2-2 ビルB 202', '03-2345-6789', '090-2345-6789', 1),
('tanaka.ichiro@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '田中', '一郎', 'タナカ', 'イチロウ', 'Tanaka', 'Ichiro', '男性', '1978-12-05', '100-0001', 13, '千代田区千代田3-3-3 ハイツC 303', '03-3456-7890', '090-3456-7890', 1),
('watanabe.yuki@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '渡辺', '優希', 'ワタナベ', 'ユウキ', 'Watanabe', 'Yuki', '女性', '1995-03-10', '190-0012', 13, '立川市曙町4-4-4 コーポD 404', '042-1234-5678', '090-4567-8901', 1),
('ito.kenji@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '伊藤', '健二', 'イトウ', 'ケンジ', 'Ito', 'Kenji', '男性', '1982-07-25', '105-0001', 13, '港区虎ノ門5-5-5 タワーE 505', '03-4567-8901', '090-5678-9012', 1),
('kobayashi.ai@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '小林', '愛', 'コバヤシ', 'アイ', 'Kobayashi', 'Ai', '女性', '1988-11-30', '102-0072', 13, '千代田区飯田橋6-6-6 マンションF 606', '03-5678-9012', '090-6789-0123', 1),
('sato.makoto@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '佐藤', '誠', 'サトウ', 'マコト', 'Sato', 'Makoto', '男性', '1975-02-18', '250-0311', 14, '足柄下郡箱根町湯本7-7-7', '0460-1234-5678', '090-7890-1234', 1),
('takahashi.misa@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '高橋', '美咲', 'タカハシ', 'ミサ', 'Takahashi', 'Misa', '女性', '1992-06-12', '403-0005', 19, '富士吉田市上吉田8-8-8', '0555-1234-5678', '090-8901-2345', 1),
('nakamura.jun@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '中村', '潤', 'ナカムラ', 'ジュン', 'Nakamura', 'Jun', '男性', '1987-09-08', '180-0004', 13, '武蔵野市吉祥寺本町9-9-9', '0422-1234-5678', '090-9012-3456', 1),
('yamamoto.yui@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO', '山本', '結衣', 'ヤマモト', 'ユイ', 'Yamamoto', 'Yui', '女性', '1998-01-22', '183-0055', 13, '府中市府中町10-10-10', '042-2345-6789', '090-0123-4567', 1);

-- ============================================
-- 顧客（customers）
-- ============================================
-- membersから自動的にcustomersにも登録（members.id = customers.id として紐付け）
INSERT INTO customers (id, family_name, first_name, family_kana, first_kana, sex, birth, mobile, tel, email, zip, pref_id, addr, enable_flg) VALUES
(1, '山田', '太郎', 'ヤマダ', 'タロウ', 1, '1985-04-15', '090-1234-5678', '03-1234-5678', 'yamada.taro@example.com', '160-0023', 13, '新宿区西新宿1-1-1 マンションA 101', 1),
(2, '鈴木', '花子', 'スズキ', 'ハナコ', 2, '1990-08-20', '090-2345-6789', '03-2345-6789', 'suzuki.hanako@example.com', '150-0001', 13, '渋谷区神宮前2-2-2 ビルB 202', 1),
(3, '田中', '一郎', 'タナカ', 'イチロウ', 1, '1978-12-05', '090-3456-7890', '03-3456-7890', 'tanaka.ichiro@example.com', '100-0001', 13, '千代田区千代田3-3-3 ハイツC 303', 1),
(4, '渡辺', '優希', 'ワタナベ', 'ユウキ', 2, '1995-03-10', '090-4567-8901', '042-1234-5678', 'watanabe.yuki@example.com', '190-0012', 13, '立川市曙町4-4-4 コーポD 404', 1),
(5, '伊藤', '健二', 'イトウ', 'ケンジ', 1, '1982-07-25', '090-5678-9012', '03-4567-8901', 'ito.kenji@example.com', '105-0001', 13, '港区虎ノ門5-5-5 タワーE 505', 1),
(6, '小林', '愛', 'コバヤシ', 'アイ', 2, '1988-11-30', '090-6789-0123', '03-5678-9012', 'kobayashi.ai@example.com', '102-0072', 13, '千代田区飯田橋6-6-6 マンションF 606', 1),
(7, '佐藤', '誠', 'サトウ', 'マコト', 1, '1975-02-18', '090-7890-1234', '0460-1234-5678', 'sato.makoto@example.com', '250-0311', 14, '足柄下郡箱根町湯本7-7-7', 1),
(8, '高橋', '美咲', 'タカハシ', 'ミサ', 2, '1992-06-12', '090-8901-2345', '0555-1234-5678', 'takahashi.misa@example.com', '403-0005', 19, '富士吉田市上吉田8-8-8', 1),
(9, '中村', '潤', 'ナカムラ', 'ジュン', 1, '1987-09-08', '090-9012-3456', '0422-1234-5678', 'nakamura.jun@example.com', '180-0004', 13, '武蔵野市吉祥寺本町9-9-9', 1),
(10, '山本', '結衣', 'ヤマモト', 'ユイ', 2, '1998-01-22', '090-0123-4567', '042-2345-6789', 'yamamoto.yui@example.com', '183-0055', 13, '府中市府中町10-10-10', 1);

-- ============================================
-- 支店マスター（branches）
-- ============================================
INSERT INTO branches (branch_code, branch_name, branch_full_name, display_order, enable_flg) VALUES
('HON', '本社', '京王観光本社', 1, 1),
('SHI', '新宿', '京王観光新宿支店', 2, 1),
('TAC', '立川', '京王観光立川支店', 3, 1),
('HNO', '八王子', '京王観光八王子支店', 4, 1),
('CHO', '調布', '京王観光調布支店', 5, 1),
('FUC', '府中', '京王観光府中支店', 6, 1),
('SAN', '三鷹', '京王観光三鷹支店', 7, 1),
('KOK', '国分寺', '京王観光国分寺支店', 8, 1);
