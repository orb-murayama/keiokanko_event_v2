-- Generated on: 2026-02-19
-- Test data for core tables

-- 1. clients (5 records)
INSERT INTO clients (id, name, contactable_person, branch_office, accounted_person, zip, pref_id, addr, tel, fax, email, password, remarks, reg_flg, group_id, created_at, modified_at, client_code, position) VALUES
(1, '株式会社京王観光', '田中太郎', '本社', '経理部 佐藤', '1600022', 13, '東京都新宿区新宿3-1-24', '0333456789', '0333456790', 'keio@example.com', 'hashed_password_1', '大手旅行代理店', 1, 1, datetime('now','localtime'), datetime('now','localtime'), 'KEIO001', '営業部長'),
(2, '旅の友株式会社', '鈴木花子', '東京支店', '経理部 山田', '1050001', 13, '東京都港区虎ノ門1-2-3', '0355551234', '0355551235', 'tabinotomo@example.com', 'hashed_password_2', '中堅旅行会社', 1, 1, datetime('now','localtime'), datetime('now','localtime'), 'TABI001', '支店長'),
(3, 'Global Tours Japan', 'John Smith', '本社', '経理部 Emily', '1060032', 13, '東京都港区六本木3-4-5', '0366667890', '0366667891', 'global@example.com', 'hashed_password_3', 'インバウンド専門', 1, 1, datetime('now','localtime'), datetime('now','localtime'), 'GLOBAL001', 'Manager'),
(4, '株式会社多摩ツーリスト', '高橋一郎', '多摩本社', '経理部 渡辺', '1900012', 13, '東京都立川市曙町2-1-1', '0425551111', '0425551112', 'tama@example.com', 'hashed_password_4', '地域密着型', 1, 2, datetime('now','localtime'), datetime('now','localtime'), 'TAMA001', '代表取締役'),
(5, 'スカイツアーズ株式会社', '伊藤美咲', '羽田支店', '経理部 木村', '1440041', 13, '東京都大田区羽田空港1-6-5', '0357771234', '0357771235', 'sky@example.com', 'hashed_password_5', '航空券専門', 1, 1, datetime('now','localtime'), datetime('now','localtime'), 'SKY001', '営業部長');

-- 2. accounts (5 records)
INSERT INTO accounts (id, login_id, password, person_name, email, client_id, role, enable_flg, created_at, modified_at, account_type, primary_branch_code, accessible_branches, expiration_date, tel, mobile) VALUES
(1, 'admin', '$2y$10$YourHashedPasswordHere1', '管理者', 'admin@example.com', NULL, 'admin', 1, datetime('now','localtime'), datetime('now','localtime'), 'internal', NULL, NULL, NULL, '0333334444', '09011112222'),
(2, 'keio_staff', '$2y$10$YourHashedPasswordHere2', '京王 太郎', 'keio.staff@example.com', 1, 'staff', 1, datetime('now','localtime'), datetime('now','localtime'), 'client', 'KEIO_HQ', 'KEIO_HQ,KEIO_SHINJUKU', NULL, '0333456789', '09012345678'),
(3, 'tabinotomo_staff', '$2y$10$YourHashedPasswordHere3', '旅友 花子', 'tabi.staff@example.com', 2, 'staff', 1, datetime('now','localtime'), datetime('now','localtime'), 'client', 'TABI_HQ', 'TABI_HQ', NULL, '0355551234', '09023456789'),
(4, 'global_staff', '$2y$10$YourHashedPasswordHere4', 'Global Admin', 'global.staff@example.com', 3, 'staff', 1, datetime('now','localtime'), datetime('now','localtime'), 'client', 'GLOBAL_HQ', 'GLOBAL_HQ', NULL, '0366667890', '09034567890'),
(5, 'tama_staff', '$2y$10$YourHashedPasswordHere5', '多摩 一郎', 'tama.staff@example.com', 4, 'staff', 1, datetime('now','localtime'), datetime('now','localtime'), 'client', 'TAMA_HQ', 'TAMA_HQ', NULL, '0425551111', '09045678901');

-- 3. members (5 records)
INSERT INTO members (id, email, password_hash, family_name, first_name, family_kana, first_kana, last_name_en, first_name_en, sex, birth, zip, pref_id, addr, tel, enable_flg, created_at, modified_at, mobile, email_verified, last_login_at) VALUES
(1, 'yamada.taro@example.com', '$2y$10$MemberHashedPassword1', '山田', '太郎', 'ヤマダ', 'タロウ', 'Yamada', 'Taro', '男性', '1985-03-15', '1600022', 13, '新宿区新宿1-1-1', '0333334444', 1, datetime('now','localtime'), datetime('now','localtime'), '09011112222', 1, datetime('now','localtime')),
(2, 'suzuki.hanako@example.com', '$2y$10$MemberHashedPassword2', '鈴木', '花子', 'スズキ', 'ハナコ', 'Suzuki', 'Hanako', '女性', '1990-07-22', '1050001', 13, '港区虎ノ門2-2-2', '0355556666', 1, datetime('now','localtime'), datetime('now','localtime'), '09022223333', 1, datetime('now','localtime')),
(3, 'tanaka.jiro@example.com', '$2y$10$MemberHashedPassword3', '田中', '次郎', 'タナカ', 'ジロウ', 'Tanaka', 'Jiro', '男性', '1982-11-05', '1060032', 13, '港区六本木3-3-3', '0366668888', 1, datetime('now','localtime'), datetime('now','localtime'), '09033334444', 1, NULL),
(4, 'sato.yuki@example.com', '$2y$10$MemberHashedPassword4', '佐藤', '由紀', 'サトウ', 'ユキ', 'Sato', 'Yuki', '女性', '1995-01-30', '1900012', 13, '立川市曙町3-3-3', '0425552222', 1, datetime('now','localtime'), datetime('now','localtime'), '09044445555', 1, datetime('now','localtime')),
(5, 'watanabe.ken@example.com', '$2y$10$MemberHashedPassword5', '渡辺', '健', 'ワタナベ', 'ケン', 'Watanabe', 'Ken', '男性', '1988-09-18', '1440041', 13, '大田区羽田空港2-2-2', '0357773333', 1, datetime('now','localtime'), datetime('now','localtime'), '09055556666', 0, NULL);

-- 4. vendors (5 records)
INSERT INTO vendors (id, name, contactable_person, email, tel, reg_flg, deleted_at, zip, pref_id, addr, fax, password, business_hours, closed_days, business_notes) VALUES
(1, '東京バス株式会社', '営業部 鈴木', 'info@tokyobus.example.com', '0344445555', 1, NULL, '1600023', 13, '新宿区西新宿2-1-1', '0344445556', 'vendor_pass_1', '8:00-20:00', '年中無休', '観光バス・送迎バス'),
(2, 'ホテルサンシャイン', '予約課 高橋', 'reservations@sunshine.example.com', '0355557777', 1, NULL, '1700013', 13, '豊島区東池袋3-1-1', '0355557778', 'vendor_pass_2', '24時間', 'なし', '宿泊施設'),
(3, '美食レストラン株式会社', '営業部 佐藤', 'sales@bishoku.example.com', '0366668888', 1, NULL, '1060032', 13, '港区六本木6-10-1', '0366668889', 'vendor_pass_3', '11:00-23:00', '月曜定休', 'ケータリング・レストラン'),
(4, 'ガイドサービスジャパン', '代表 田中', 'info@guideservice.example.jp', '0377779999', 1, NULL, '1500002', 13, '渋谷区渋谷1-1-1', '0377770000', 'vendor_pass_4', '9:00-18:00', '土日祝休', '通訳ガイド・観光ガイド'),
(5, 'イベントプロダクション東京', 'イベント課 山本', 'event@eventpro.example.com', '0388881111', 1, NULL, '1350091', 13, '港区台場1-7-1', '0388881112', 'vendor_pass_5', '10:00-19:00', '水曜定休', 'イベント企画・運営');

-- 5. organizers (5 records)
INSERT INTO organizers (id, name, contactable_person, email, tel, zip, pref_id, addr, fax, password, created_at, modified_at) VALUES
(1, '京王ツアーズ株式会社', '企画部 伊藤', 'planning@keio-tours.example.com', '0333339999', '1600022', 13, '新宿区新宿5-1-1', '0333330000', 'org_pass_1', datetime('now','localtime'), datetime('now','localtime')),
(2, '多摩観光協会', '事務局 渡辺', 'info@tama-tourism.example.jp', '0425553333', '1900014', 13, '立川市緑町3-1', '0425553334', 'org_pass_2', datetime('now','localtime'), datetime('now','localtime')),
(3, '東京シティガイド協会', '代表理事 小林', 'contact@tokyo-guide.example.jp', '0344446666', '1000005', 13, '千代田区丸の内1-1-1', '0344446667', 'org_pass_3', datetime('now','localtime'), datetime('now','localtime')),
(4, '文化体験ジャパン', '事業部 木村', 'info@culture-jp.example.com', '0366669999', '1110032', 13, '台東区浅草1-1-1', '0366660000', 'org_pass_4', datetime('now','localtime'), datetime('now','localtime')),
(5, 'グリーンツーリズム推進会', '事務局長 中村', 'green@tourism-green.example.jp', '0422221111', '1810013', 13, '三鷹市下連雀3-1-1', '0422221112', 'org_pass_5', datetime('now','localtime'), datetime('now','localtime'));

-- Verify insertion
SELECT 'Test data inserted successfully' as status;
