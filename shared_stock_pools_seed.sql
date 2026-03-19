-- 共有在庫プールのテストデータ

-- 東京サマーフェスティバル2025用バスプール（2025年8月）
INSERT INTO shared_stock_pools (pool_name, pool_code, description, date, time_slot_start, time_slot_end, time_slot_label, total_stock, booked, enable_flg) VALUES
('東京サマーフェス往復バス', 'BUS-TOKYO-2025', '東京駅⇔イベント会場', '2025-08-01', '09:00', '10:00', '午前便', 45, 10, 1),
('東京サマーフェス往復バス', 'BUS-TOKYO-2025', '東京駅⇔イベント会場', '2025-08-01', '13:00', '14:00', '午後便', 45, 5, 1),
('東京サマーフェス往復バス', 'BUS-TOKYO-2025', '東京駅⇔イベント会場', '2025-08-02', '09:00', '10:00', '午前便', 45, 15, 1),
('東京サマーフェス往復バス', 'BUS-TOKYO-2025', '東京駅⇔イベント会場', '2025-08-02', '13:00', '14:00', '午後便', 45, 20, 1),
('東京サマーフェス往復バス', 'BUS-TOKYO-2025', '東京駅⇔イベント会場', '2025-08-03', '09:00', '10:00', '午前便', 45, 8, 1);

-- 京都花火大会用駐車場プール（2025年7月）
INSERT INTO shared_stock_pools (pool_name, pool_code, description, date, total_stock, booked, enable_flg) VALUES
('京都花火大会駐車場', 'PARKING-KYOTO-01', '会場隣接駐車場', '2025-07-15', 100, 45, 1),
('京都花火大会駐車場', 'PARKING-KYOTO-01', '会場隣接駐車場', '2025-07-16', 100, 67, 1),
('京都花火大会駐車場', 'PARKING-KYOTO-01', '会場隣接駐車場', '2025-07-17', 100, 89, 1);

-- 大阪音楽フェス用宿泊プール（2025年9月）
INSERT INTO shared_stock_pools (pool_name, pool_code, description, date, total_stock, booked, enable_flg) VALUES
('大阪音楽フェス宿泊パック', 'HOTEL-OSAKA-2025', '提携ホテル宿泊', '2025-09-10', 50, 12, 1),
('大阪音楽フェス宿泊パック', 'HOTEL-OSAKA-2025', '提携ホテル宿泊', '2025-09-11', 50, 34, 1),
('大阪音楽フェス宿泊パック', 'HOTEL-OSAKA-2025', '提携ホテル宿泊', '2025-09-12', 50, 28, 1);
