-- このマイグレーションは0000_full_schema_backup.sqlで既に適用済みのため、
-- データの挿入のみを実行します

-- 18支店のマスタデータ投入（重複チェック付き）
INSERT OR IGNORE INTO branches (branch_code, branch_name, branch_full_name, display_order) VALUES
('01', '東京中央支店', '東京中央支店:01', 1),
('02', '東京南支店', '東京南支店:02', 2),
('03', '東京東支店', '東京東支店:03', 3),
('04', 'イベント＆ツアー センター', 'イベント＆ツアー センター:04', 4),
('05', 'さいたま支店', 'さいたま支店:05', 5),
('06', '調布支店', '調布支店:06', 6),
('07', '立川支店', '立川支店:07', 7),
('08', '八王子支店', '八王子支店:08', 8),
('09', '神奈川北支店', '神奈川北支店:09', 9),
('10', '町田営業所', '町田営業所:10', 10),
('11', '団体旅行営業部スポーツセールス担当', '団体旅行営業部スポーツセールス担当:11', 11),
('12', '札幌支店', '札幌支店:12', 12),
('13', '仙台支店', '仙台支店:13', 13),
('14', '大阪支店', '大阪支店:14', 14),
('15', '大阪西支店', '大阪西支店:15', 15),
('16', '福岡支店', '福岡支店:16', 16),
('17', '旅行事業部', '旅行事業部:17', 17),
('18', '経営管理部', '経営管理部:18', 18);

-- インデックス作成（既に存在する場合はスキップ）
CREATE INDEX IF NOT EXISTS idx_accounts_account_type ON accounts(account_type);
CREATE INDEX IF NOT EXISTS idx_accounts_primary_branch ON accounts(primary_branch_code);
CREATE INDEX IF NOT EXISTS idx_branches_code ON branches(branch_code);
CREATE INDEX IF NOT EXISTS idx_branches_enable ON branches(enable_flg);
