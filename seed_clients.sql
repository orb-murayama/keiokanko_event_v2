-- クライアントテストデータ
INSERT INTO clients (
  id, name, contactable_person, branch_office, accounted_person, 
  zip, pref_id, addr, tel, fax, email, password, remarks, 
  reg_flg, client_code, position
) VALUES 
(1, '株式会社テストクライアント', '山田太郎', '東京本社', '佐藤花子',
 '1000001', 13, '千代田区千代田1-1-1', '03-1234-5678', '03-1234-5679', 
 'test@example.com', 'password123', 'テストクライアント', 
 1, 'TC001', '営業部長'),
 
(2, '株式会社サンプル', '田中次郎', '大阪支店', '鈴木一郎',
 '5300001', 27, '大阪市北区梅田1-1-1', '06-2345-6789', '06-2345-6790', 
 'sample@example.com', 'password456', 'サンプルクライアント', 
 1, 'SA001', '営業課長'),
 
(3, '株式会社デモ', '高橋三郎', '名古屋支店', '伊藤美咲',
 '4600001', 23, '名古屋市中区栄1-1-1', '052-3456-7890', '052-3456-7891', 
 'demo@example.com', 'password789', 'デモクライアント', 
 1, 'DM001', '部長');
