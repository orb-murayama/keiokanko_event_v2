-- テストデータ投入用SQLファイル

-- アカウントデータ（5件）
INSERT OR IGNORE INTO accounts (login_id, password, person_name, email, client_id, role, enable_flg) VALUES
  ('admin', 'password123', 'システム管理者', 'admin@system.com', NULL, 'system_admin', 1),
  ('tokyo_admin', 'password123', '東京 太郎', 'tokyo_admin@client.com', 1, 'client_admin', 1),
  ('kyoto_admin', 'password123', '京都 花子', 'kyoto_admin@client.com', 2, 'client_admin', 1),
  ('osaka_user', 'password123', '大阪 次郎', 'osaka_user@client.com', 3, 'general', 1),
  ('fukuoka_user', 'password123', '福岡 三郎', 'fukuoka_user@client.com', 4, 'general', 1);

-- クライアントデータ（5件）
INSERT OR IGNORE INTO clients (client_code, name, email, tel, password) VALUES
  ('CLI001', '東京イベント企画', 'tokyo@client.com', '03-1111-1111', 'password123'),
  ('CLI002', '京都観光サービス', 'kyoto@client.com', '075-2222-2222', 'password123'),
  ('CLI003', '大阪ビジネス', 'osaka@client.com', '06-3333-3333', 'password123'),
  ('CLI004', '福岡プロモーション', 'fukuoka@client.com', '092-4444-4444', 'password123'),
  ('CLI005', '札幌イベントサービス', 'sapporo@client.com', '011-5555-5555', 'password123');

-- 主催者データ（3件）
INSERT OR IGNORE INTO organizers (name, email, tel) VALUES
  ('東京イベント企画株式会社', 'info@tokyo-event.com', '03-1234-5678'),
  ('京都観光協会', 'info@kyoto-kanko.or.jp', '075-123-4567'),
  ('大阪文化センター', 'info@osaka-bunka.or.jp', '06-1234-5678');

-- 販売業者データ（3件）
INSERT OR IGNORE INTO vendors (name, email, tel) VALUES
  ('チケット販売株式会社', 'sales@ticket.com', '03-9999-0001'),
  ('イベントプラス', 'info@event-plus.com', '06-8888-0002'),
  ('トラベルネット', 'support@travel-net.com', '075-7777-0003');

-- イベントデータ（10件）
INSERT OR IGNORE INTO events (client_id, name, contact, location, event_start_date, event_end_date, registration_start_date, registration_end_date) VALUES
  (1, '東京マラソン2025', '東京イベント企画', '東京都内', '2025-03-01', '2025-03-01', '2025-01-01', '2025-02-20'),
  (2, '京都祇園祭ツアー', '京都観光協会', '京都市内', '2025-07-15', '2025-07-17', '2025-05-01', '2025-07-10'),
  (3, '大阪ビジネスフォーラム', '大阪ビジネス', '大阪国際会議場', '2025-05-20', '2025-05-20', '2025-03-01', '2025-05-15'),
  (4, '福岡グルメフェス', '福岡プロモーション', '福岡ドーム', '2025-04-10', '2025-04-12', '2025-02-01', '2025-04-05'),
  (5, '札幌雪まつり見学ツアー', '札幌イベントサービス', '札幌市内', '2025-02-05', '2025-02-10', '2025-01-01', '2025-01-31'),
  (1, '東京サマーフェスティバル2025', '東京イベント企画', '東京ビッグサイト', '2025-08-01', '2025-08-03', '2025-06-01', '2025-07-25'),
  (2, '京都伝統工芸展', '京都観光協会', '京都市美術館', '2025-09-15', '2025-09-20', '2025-07-01', '2025-09-10'),
  (3, '大阪ビジネスセミナー', '大阪ビジネス', '大阪商工会議所', '2025-06-10', '2025-06-10', '2025-04-01', '2025-06-05'),
  (4, '福岡グルメフェア', '福岡プロモーション', 'マリンメッセ福岡', '2025-10-15', '2025-10-17', '2025-08-01', '2025-10-10'),
  (5, '札幌スポーツフェス', '札幌イベントサービス', '札幌ドーム', '2025-11-05', '2025-11-07', '2025-09-01', '2025-11-01');

-- 商品カテゴリデータ
INSERT OR IGNORE INTO product_categories (name, description) VALUES
  ('チケット', 'イベント参加チケット'),
  ('ツアー', '観光ツアーパッケージ'),
  ('セミナー', 'ビジネスセミナー参加券');

-- 商品データ（6件）
INSERT OR IGNORE INTO products (client_id, event_id, product_category_id, name, sales_start, sales_end) VALUES
  (1, 1, 1, 'フルマラソン参加券', '2025-01-01', '2025-02-20'),
  (1, 1, 1, 'ハーフマラソン参加券', '2025-01-01', '2025-02-20'),
  (2, 2, 2, '祇園祭プレミアムツアー', '2025-05-01', '2025-07-10'),
  (2, 2, 2, '祇園祭標準ツアー', '2025-05-01', '2025-07-10'),
  (3, 3, 3, 'ビジネスフォーラム一般席', '2025-03-01', '2025-05-15'),
  (3, 3, 3, 'ビジネスフォーラムVIP席', '2025-03-01', '2025-05-15');

-- オプションカテゴリデータ
INSERT OR IGNORE INTO option_categories (name, description) VALUES
  ('グッズ', 'イベントグッズ'),
  ('サービス', '追加サービス'),
  ('飲食', '食事・飲料');

-- オプションデータ（5件）
INSERT OR IGNORE INTO options (event_id, option_category_id, name) VALUES
  (1, 1, 'Tシャツ'),
  (1, 2, '記録証明書'),
  (2, 3, '昼食弁当'),
  (3, 1, 'ガイドブック'),
  (3, 3, '懇親会参加券');

-- 会員データ（5件）
INSERT OR IGNORE INTO customers (email, password, family_name, first_name, family_kana, first_kana, tel, zip, pref_id, city, addr, enable_flg) VALUES
  ('tanaka@example.com', 'password123', '田中', '太郎', 'タナカ', 'タロウ', '090-1111-1111', '100-0001', 13, '千代田区', '丸の内1-1-1', 1),
  ('suzuki@example.com', 'password123', '鈴木', '花子', 'スズキ', 'ハナコ', '080-2222-2222', '530-0001', 27, '大阪市北区', '梅田1-1-1', 1),
  ('sato@example.com', 'password123', '佐藤', '次郎', 'サトウ', 'ジロウ', '070-3333-3333', '600-8216', 26, '京都市下京区', '烏丸通七条下る', 1),
  ('yamada@example.com', 'password123', '山田', '美咲', 'ヤマダ', 'ミサキ', '090-4444-4444', '810-0001', 40, '福岡市中央区', '天神1-1-1', 1),
  ('takahashi@example.com', 'password123', '高橋', '健太', 'タカハシ', 'ケンタ', '080-5555-5555', '060-0001', 1, '札幌市中央区', '北一条西1-1-1', 1);

-- 予約データ（5件）
INSERT OR IGNORE INTO product_bookings (booking_number, customer_id, product_id, price, quantity, booking_status, payment_status) VALUES
  ('BK-2025-001', 1, 1, 15000, 1, 'reserved', 'pending'),
  ('BK-2025-002', 2, 2, 8000, 2, 'confirmed', 'paid'),
  ('BK-2025-003', 3, 3, 50000, 1, 'reserved', 'pending'),
  ('BK-2025-004', 4, 4, 35000, 1, 'confirmed', 'paid'),
  ('BK-2025-005', 5, 5, 10000, 3, 'reserved', 'pending');
