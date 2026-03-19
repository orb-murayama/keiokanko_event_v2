-- 商品在庫日付に合わせてオプション在庫を作成（イベントID=2: 多摩サイクリング）
-- 商品在庫日付: 2026-10-15, 2026-10-22, 2026-10-29, 2026-11-05

-- 既存のオプション在庫を削除
DELETE FROM option_stocks WHERE option_id IN (1, 2, 3);

-- オプション1: 電動アシスト自転車（option_id=1）- 各日10台
INSERT INTO option_stocks (option_id, date, stock, booked, stock_name, price, total_stock, available_stock, enable_flg) VALUES
(1, '2026-10-15', 10, 0, '電動アシスト自転車', 2000, 10, 10, 1),
(1, '2026-10-22', 10, 0, '電動アシスト自転車', 2000, 10, 10, 1),
(1, '2026-10-29', 10, 0, '電動アシスト自転車', 2000, 10, 10, 1),
(1, '2026-11-05', 10, 0, '電動アシスト自転車', 2000, 10, 10, 1);

-- オプション2: サイクリング保険（option_id=2）- 各日30名
INSERT INTO option_stocks (option_id, date, stock, booked, stock_name, price, total_stock, available_stock, enable_flg) VALUES
(2, '2026-10-15', 30, 0, 'サイクリング保険', 500, 30, 30, 1),
(2, '2026-10-22', 30, 0, 'サイクリング保険', 500, 30, 30, 1),
(2, '2026-10-29', 30, 0, 'サイクリング保険', 500, 30, 30, 1),
(2, '2026-11-05', 30, 0, 'サイクリング保険', 500, 30, 30, 1);

-- オプション3: 特製弁当（option_id=3）- 各日50食
INSERT INTO option_stocks (option_id, date, stock, booked, stock_name, price, total_stock, available_stock, enable_flg) VALUES
(3, '2026-10-15', 50, 0, '特製弁当（豪華版）', 1500, 50, 50, 1),
(3, '2026-10-22', 50, 0, '特製弁当（豪華版）', 1500, 50, 50, 1),
(3, '2026-10-29', 50, 0, '特製弁当（豪華版）', 1500, 50, 50, 1),
(3, '2026-11-05', 50, 0, '特製弁当（豪華版）', 1500, 50, 50, 1);
