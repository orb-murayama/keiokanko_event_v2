-- ============================================
-- Migration: Add branch columns and populate branch data
-- Date: 2026-02-20
-- Description: Add branch_type, address, tel columns to branches table
--              and populate with 14 branch locations
-- ============================================

-- Step 1: Add new columns to branches table
ALTER TABLE branches ADD COLUMN branch_type TEXT DEFAULT '支店';
ALTER TABLE branches ADD COLUMN address TEXT;
ALTER TABLE branches ADD COLUMN tel TEXT;

-- Step 2: Clear existing data
DELETE FROM branches;

-- Step 3: Insert branch data (14 locations)

-- 本社
INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('HQ', '本社', '本社', '京王観光株式会社 本社', '東京都多摩市関戸2-37-3 せいせき さくらゲート3階', NULL, 1, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

-- カウンター店舗（個人向け）
INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('SHINJUKU', 'カウンター', '京王新宿店', '京王新宿店', '東京都新宿区西新宿1-1-4（京王線新宿駅西口改札前）', '03-3342-7731', 2, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('SEISEKI', 'カウンター', '聖蹟桜ヶ丘店', '聖蹟桜ヶ丘店', '東京都多摩市関戸1-10-10（京王線聖蹟桜ヶ丘駅西口改札横）', '042-375-8611', 3, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

-- 団体旅行営業支店（法人・団体等）
INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('TOKYO1', '支店', '東京第1支店', '東京第1支店', '東京都新宿区新宿2-3-10 新宿御苑ビル2階', '03-5312-6540', 4, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('TOKYO2', '支店', '東京第2支店', '東京第2支店', '東京都新宿区新宿2-3-10 新宿御苑ビル2階', '03-5919-4831', 5, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('GLOBAL', 'センター', 'グローバルツアーセンター', 'グローバルツアーセンター', '東京都新宿区新宿2-3-10 新宿御苑ビル2階', '03-5367-4850', 6, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('SAITAMA', '支店', 'さいたま支店', 'さいたま支店', '埼玉県さいたま市大宮区宮町2-55-2 第一大宮ビル8階', '048-647-0025', 7, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('SPORTS', '支店', 'スポーツ支店', 'スポーツ支店', '東京都調布市布田3-1-7 池田ビル5階', '042-484-2881', 8, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('TACHIKAWA', '支店', '立川支店', '立川支店', '東京都立川市錦町2-4-2 CB立川ビル5階', '042-525-3991', 9, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('HACHIOJI', '支店', '八王子支店', '八王子支店', '東京都八王子市東町2-12 京王八王子東町ビル4階', '042-631-4721', 10, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('KANAGAWA', '支店', '神奈川北支店', '神奈川北支店', '神奈川県相模原市中央区鹿沼台1-3-12 パロス竹内3階', '042-786-6155', 11, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('SAPPORO', '支店', '札幌支店', '札幌支店', '北海道札幌市中央区北一条東1-2-5 カレスサッポロビル5階', '011-241-6501', 12, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('SENDAI', '支店', '仙台支店', '仙台支店', '宮城県仙台市青葉区本町1-2-20 KDX仙台ビル3階', '022-227-3281', 13, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));

INSERT INTO branches (branch_code, branch_type, branch_name, branch_full_name, address, tel, display_order, enable_flg, created_at, modified_at)
VALUES ('KANSAI', '支店', '関西支店', '関西支店', '大阪府大阪市西区阿波座1-3-15 関電不動産西本町ビル6階', '06-6541-7634', 14, 1, datetime('now', 'localtime'), datetime('now', 'localtime'));
