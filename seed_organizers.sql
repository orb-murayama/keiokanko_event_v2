-- 主催者のテストデータ（organizers）

-- 主催者1: 東京の旅行会社
INSERT INTO organizers (id, name, contactable_person, email, tel, branch_office, fax, password, zip, pref_id, addr, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES (
  1,
  '株式会社東京ツーリスト',
  '田中一郎',
  'tanaka@tokyo-tourist.example.com',
  '03-1111-2222',
  '東京本社',
  '03-1111-2223',
  'password123',
  '100-0001',
  13,
  '千代田区千代田1-1-1 東京ビル10F',
  '平日 9:00-18:00',
  '土日祝',
  '年末年始は休業いたします',
  '東京都知事登録旅行業第1234号',
  '一般社団法人全国旅行業協会',
  '正会員第5678号',
  '総合旅行業務取扱管理者',
  '佐藤花子',
  '東京エリアの主要主催者',
  1
);

-- 主催者2: 大阪の旅行会社
INSERT INTO organizers (id, name, contactable_person, email, tel, branch_office, fax, password, zip, pref_id, addr, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES (
  2,
  '株式会社関西トラベル',
  '鈴木次郎',
  'suzuki@kansai-travel.example.com',
  '06-2222-3333',
  '大阪本社',
  '06-2222-3334',
  'password123',
  '530-0001',
  27,
  '北区梅田1-1-1 大阪ビル8F',
  '平日 9:30-17:30',
  '土日祝',
  '繁忙期は予約制です',
  '大阪府知事登録旅行業第2345号',
  '一般社団法人日本旅行業協会',
  '正会員第6789号',
  '総合旅行業務取扱管理者',
  '高橋太郎',
  '関西エリアの大手主催者',
  1
);

-- 主催者3: 名古屋の旅行会社
INSERT INTO organizers (id, name, contactable_person, email, tel, branch_office, fax, password, zip, pref_id, addr, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES (
  3,
  '株式会社中部ツーリズム',
  '伊藤三郎',
  'ito@chubu-tourism.example.com',
  '052-3333-4444',
  '名古屋本社',
  '052-3333-4445',
  'password123',
  '460-0001',
  23,
  '中区栄1-1-1 名古屋ビル5F',
  '平日 10:00-19:00、土曜 10:00-15:00',
  '日祝',
  '土曜日は予約制です',
  '愛知県知事登録旅行業第3456号',
  '一般社団法人全国旅行業協会',
  '正会員第7890号',
  '国内旅行業務取扱管理者',
  '渡辺美咲',
  '中部エリアの有力主催者',
  1
);

-- 主催者4: 無効化された主催者
INSERT INTO organizers (id, name, contactable_person, email, tel, branch_office, fax, password, zip, pref_id, addr, business_hours, closed_days, business_notes, registration_number, association_name, association_membership, travel_manager_title, travel_manager_name, remarks, reg_flg)
VALUES (
  4,
  '株式会社テスト主催者（無効）',
  '山田四郎',
  'yamada@test.example.com',
  '03-4444-5555',
  '東京支店',
  '03-4444-5556',
  'password123',
  '100-0002',
  13,
  '千代田区千代田2-2-2',
  '平日 9:00-18:00',
  '土日祝',
  '',
  '東京都知事登録旅行業第9999号',
  '',
  '',
  '',
  '',
  '無効化された主催者',
  0
);
