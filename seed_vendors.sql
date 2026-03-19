-- 販売会社のテストデータ（vendors）

-- 販売会社1: 東京の販売会社
INSERT INTO vendors (id, name, contactable_person, email, tel, fax, password, zip, pref_id, addr, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES (
  1,
  '株式会社東京トラベル',
  '鈴木一郎',
  'suzuki@tokyo-travel.example.com',
  '03-1111-2222',
  '03-1111-2223',
  'password123',
  '100-0001',
  13,
  '千代田区千代田1-1-1 東京ビル5F',
  '平日 9:00-18:00',
  '土日祝',
  '事前予約が必要です',
  '東京エリアの主要販売会社',
  1
);

-- 販売会社2: 大阪の販売会社
INSERT INTO vendors (id, name, contactable_person, email, tel, fax, password, zip, pref_id, addr, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES (
  2,
  '株式会社大阪ツアーズ',
  '田中花子',
  'tanaka@osaka-tours.example.com',
  '06-2222-3333',
  '06-2222-3334',
  'password123',
  '530-0001',
  27,
  '北区梅田1-1-1 大阪ビル3F',
  '平日 9:30-17:30',
  '土日祝',
  '繁忙期は対応できない場合があります',
  '関西エリアの大手販売会社',
  1
);

-- 販売会社3: 名古屋の販売会社
INSERT INTO vendors (id, name, contactable_person, email, tel, fax, password, zip, pref_id, addr, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES (
  3,
  '株式会社名古屋エクスカーション',
  '佐藤次郎',
  'sato@nagoya-ex.example.com',
  '052-3333-4444',
  '052-3333-4445',
  'password123',
  '460-0001',
  23,
  '中区栄1-1-1 名古屋ビル2F',
  '平日 10:00-19:00、土曜 10:00-15:00',
  '日祝',
  '土曜日は予約制です',
  '中部エリアの有力販売会社',
  1
);

-- 販売会社4: 無効化された販売会社
INSERT INTO vendors (id, name, contactable_person, email, tel, fax, password, zip, pref_id, addr, business_hours, closed_days, business_notes, remarks, reg_flg)
VALUES (
  4,
  '株式会社テスト販売（無効）',
  '山田太郎',
  'yamada@test.example.com',
  '03-4444-5555',
  '03-4444-5556',
  'password123',
  '100-0002',
  13,
  '千代田区千代田2-2-2',
  '平日 9:00-18:00',
  '土日祝',
  '',
  '無効化された販売会社',
  0
);
