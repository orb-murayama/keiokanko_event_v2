-- 会員のテストデータ（members）

-- 会員1: 有効な会員
INSERT INTO members (id, email, password_hash, family_name, first_name, family_kana, first_kana, tel, mobile, enable_flg)
VALUES (
  1,
  'member001@example.com',
  'password123',
  '鈴木',
  '一郎',
  'スズキ',
  'イチロウ',
  '03-1111-1111',
  '090-1111-1111',
  1
);

-- 会員2: 有効な会員
INSERT INTO members (id, email, password_hash, family_name, first_name, family_kana, first_kana, tel, mobile, enable_flg)
VALUES (
  2,
  'member002@example.com',
  'password123',
  '高橋',
  '美咲',
  'タカハシ',
  'ミサキ',
  '03-2222-2222',
  '090-2222-2222',
  1
);

-- 会員3: 有効な会員
INSERT INTO members (id, email, password_hash, family_name, first_name, family_kana, first_kana, tel, mobile, enable_flg)
VALUES (
  3,
  'member003@example.com',
  'password123',
  '伊藤',
  '健太',
  'イトウ',
  'ケンタ',
  '03-3333-3333',
  '090-3333-3333',
  1
);

-- 会員4: 無効化された会員
INSERT INTO members (id, email, password_hash, family_name, first_name, family_kana, first_kana, tel, mobile, enable_flg)
VALUES (
  4,
  'member004@example.com',
  'password123',
  '渡辺',
  '由美',
  'ワタナベ',
  'ユミ',
  '03-4444-4444',
  '090-4444-4444',
  0
);

-- 会員5: 有効な会員
INSERT INTO members (id, email, password_hash, family_name, first_name, family_kana, first_kana, tel, mobile, enable_flg)
VALUES (
  5,
  'member005@example.com',
  'password123',
  '中村',
  '太一',
  'ナカムラ',
  'タイチ',
  '03-5555-5555',
  '090-5555-5555',
  1
);
