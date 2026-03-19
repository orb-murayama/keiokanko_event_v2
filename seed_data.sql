-- Branches
INSERT INTO branches VALUES(1,'HON','本社','京王観光本社',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches VALUES(2,'SHI','新宿','京王観光新宿支店',2,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches VALUES(3,'TAC','立川','京王観光立川支店',3,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO branches VALUES(4,'HNO','八王子','京王観光八王子支店',4,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');

-- Prefs
INSERT INTO prefs VALUES(13,'東京都');
INSERT INTO prefs VALUES(14,'神奈川県');
INSERT INTO prefs VALUES(19,'山梨県');

-- Categories
INSERT INTO categories VALUES(1,'登山・トレッキング','hiking','登山・トレッキングツアー',NULL,1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO categories VALUES(2,'温泉・宿泊','onsen','温泉・宿泊プラン',NULL,2,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO categories VALUES(3,'観光・ツアー','sightseeing','観光ツアー',NULL,3,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO categories VALUES(4,'サイクリング・アウトドア','cycling','サイクリング・アウトドア',NULL,4,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO categories VALUES(5,'エコツアー・体験','ecotour','エコツアー・体験プログラム',NULL,5,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO categories VALUES(6,'文化体験','culture','文化体験プログラム',NULL,6,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO categories VALUES(7,'その他','other','その他のイベント',NULL,7,1,'2026-02-12 07:16:29','2026-02-12 07:16:29');

-- Clients
INSERT INTO clients VALUES(1,'京王観光株式会社','田中太郎','本社','経理部 山田花子','160-0023',13,'新宿区西新宿1-1-1','03-1234-5678','03-1234-5679','tanaka@keio-kanko.co.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','主要取引先',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI001','営業部長');
INSERT INTO clients VALUES(2,'株式会社旅の友','鈴木一郎','東京支店','営業部 佐藤次郎','100-0001',13,'千代田区千代田1-1','03-2345-6789','03-2345-6780','suzuki@tabinotomo.co.jp','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','VIP顧客',1,1,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI002','支店長');
INSERT INTO clients VALUES(3,'グローバルツアーズ','Michael Smith','日本支社','Finance Team','105-0001',13,'港区虎ノ門2-2-2','03-3456-7890','03-3456-7891','smith@globaltours.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','海外顧客',1,2,'2026-02-12 07:16:29','2026-02-12 07:16:29','CLI003','Manager');

-- Organizers
INSERT INTO organizers VALUES(1,'京王グループツアーズ','山田太郎','yamada@keio-tours.co.jp','03-1111-2222','新宿本社',1,NULL,'160-0023',13,'新宿区西新宿1-10-1','03-1111-2223',NULL,'平日9:00-18:00','土日祝','各種ツアー企画・運営','T-001-12345','日本旅行業協会','JATA会員','旅行業務取扱管理者','山田太郎','メイン主催者','2026-02-12 07:16:29','2026-02-12 07:16:29');
INSERT INTO organizers VALUES(2,'多摩地域観光推進協議会','佐藤花子','sato@tama-tourism.jp','042-2222-3333','立川事務所',1,NULL,'190-0012',13,'立川市曙町2-1-1','042-2222-3334',NULL,'平日9:00-17:00','土日祝','多摩地域の観光振興','T-002-23456','多摩観光連盟','理事会員','事務局長','佐藤花子','地域密着型','2026-02-12 07:16:29','2026-02-12 07:16:29');

-- Vendors
INSERT INTO vendors VALUES(1,'富士急バス株式会社','高橋運転','takahashi@fujikyu-bus.co.jp','0555-1111-2222',1,NULL,'403-0016',19,'富士吉田市松山1-1-1','0555-1111-2223',NULL,'24時間対応','なし','観光バス・貸切バス事業','大型バス20台保有','2026-02-12 07:16:29','2026-02-12 07:16:29');

-- Events
INSERT INTO events VALUES(1,'富士山登山ツアー2026夏','日本最高峰・富士山（標高3,776m）への登頂を目指す1泊2日のツアーです。','京王グループツアーズ','登山経験のある方推奨',NULL,0,'この度は富士山登山ツアーにお申込みいただき、ありがとうございます。','悪天候時は中止',1,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',1,NULL,'fujisan-2026-summer','登山・トレッキング',NULL,'single','山梨県富士吉田市','credit,bank','percentage','customer','fixed','2026-03-01','2026-07-31','2026-08-01','2026-08-31','yamada@keio-tours.co.jp','山田太郎',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-15','2026-09-30',NULL,'京王グループツアーズ','info@keio-tours.co.jp','京王グループツアーズ',NULL,'みずほ銀行','新宿支店','普通','1234567','ケイオウグループツアーズ',7,'KEIO001',7,'["セブンイレブン","ファミリーマート"]',3.5,0,0,330,0,330,'{"name_kanji":true,"name_kana":true}',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,1,NULL,'出発日の21日前まで無料、20日前～8日前20%',21,0,8,20,2,30,NULL);

INSERT INTO events VALUES(4,'多摩丘陵サイクリング 紅葉満喫コース','秋の多摩丘陵を自転車で巡る日帰りツアー。','多摩地域観光推進協議会','自転車に乗れる方',NULL,0,'多摩丘陵の美しい紅葉をお楽しみください。','雨天中止',4,0,1,1,NULL,'2026-02-12 07:21:42','2026-02-12 07:21:42',4,NULL,'tama-cycling-autumn-2026','サイクリング',NULL,'single','東京都立川市','credit,bank','percentage','customer',NULL,'2026-08-01','2026-10-31','2026-10-15','2026-11-30','sato@tama-tourism.jp','佐藤花子',NULL,NULL,NULL,NULL,NULL,NULL,2,'2026-07-01','2026-12-31',NULL,'多摩地域観光推進協議会','info@tama-tourism.jp','多摩地域観光推進協議会',NULL,'きらぼし銀行','立川支店','普通','4567890','タマチイキカンコウ',7,NULL,NULL,NULL,3.5,NULL,NULL,330,NULL,NULL,'{"name_kanji":true,"name_kana":true}',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'standalone',1,1,0,NULL,'実施日の7日前まで無料',7,0,3,30,NULL,NULL,NULL);

-- Products
INSERT INTO products VALUES(1,1,1,'富士山登山ツアー スタンダードプラン','2026-03-01','2026-07-31',0,NULL,'山小屋1泊2日の登山ツアー','登山経験者推奨','ガイド料、山小屋宿泊費、往復バス','個人装備','7日前まで無料',20,NULL,NULL,1,'2026-02-12 07:32:20','2026-02-12 07:32:20',0,NULL,7,0,3,30,2,50,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL,'{"name_kanji":true,"name_kana":true}',NULL);

INSERT INTO products VALUES(2,4,4,'多摩丘陵サイクリングツアー','2026-08-01','2026-10-31',0,NULL,'紅葉の多摩丘陵を自転車で巡るツアー','初心者OK','自転車レンタル、ガイド料、昼食','個人装備','7日前まで無料',30,NULL,NULL,1,'2026-02-12 07:32:20','2026-02-12 07:32:20',0,NULL,7,0,3,30,NULL,NULL,NULL,NULL,NULL,NULL,'人','per_person',NULL,'{"name_kanji":true,"name_kana":true}',NULL);

-- Product Prices
INSERT INTO product_prices VALUES(1,1,35000,'大人','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'大人（13歳以上）',1,1);
INSERT INTO product_prices VALUES(2,1,28000,'子供','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'子供（6-12歳）',2,1);
INSERT INTO product_prices VALUES(3,2,8000,'大人','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'大人（13歳以上）',1,1);
INSERT INTO product_prices VALUES(4,2,5000,'子供','2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,'子供（6-12歳）',2,1);

-- Product Stocks
INSERT INTO product_stocks VALUES(1,1,'2026-08-01',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks VALUES(2,1,'2026-08-08',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks VALUES(3,1,'2026-08-15',20,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks VALUES(4,2,'2026-10-15',30,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks VALUES(5,2,'2026-10-22',30,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO product_stocks VALUES(6,2,'2026-10-29',30,0,'2026-02-12 07:32:20','2026-02-12 07:32:20',NULL,NULL,NULL,NULL,NULL,NULL);

-- Customers
INSERT INTO customers VALUES(1,'山田','太郎','ヤマダ','タロウ',1,'1985-04-15','090-1234-5678','03-1234-5678',NULL,'yamada.taro@example.com','160-0023',13,NULL,'新宿区西新宿1-1-1',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);
INSERT INTO customers VALUES(2,'鈴木','花子','スズキ','ハナコ',2,'1990-08-20','090-2345-6789','03-2345-6789',NULL,'suzuki.hanako@example.com','150-0001',13,NULL,'渋谷区神宮前2-2-2',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,NULL,'2026-02-12 07:16:29','2026-02-12 07:16:29',NULL,NULL,NULL);

-- Members
INSERT INTO members VALUES(1,'yamada.taro@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','山田','太郎','ヤマダ','タロウ','Yamada','Taro','男性','1985-04-15','160-0023',13,'新宿区西新宿1-1-1','03-1234-5678',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-1234-5678');
INSERT INTO members VALUES(2,'suzuki.hanako@example.com','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhkO','鈴木','花子','スズキ','ハナコ','Suzuki','Hanako','女性','1990-08-20','150-0001',13,'渋谷区神宮前2-2-2','03-2345-6789',1,'2026-02-12 07:16:29','2026-02-12 07:16:29','090-2345-6789');
