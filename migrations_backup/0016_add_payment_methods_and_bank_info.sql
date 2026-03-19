-- マイグレーション: 支払方法を複数選択可能にし、銀行口座情報を追加

-- 支払方法フラグを追加（ビットマスク形式）
-- payment_methods: 1=クレジットカード, 2=銀行振込, 4=コンビニ払い
ALTER TABLE events ADD COLUMN payment_methods INTEGER DEFAULT 1;

-- 銀行振込情報
ALTER TABLE events ADD COLUMN bank_name TEXT; -- 金融機関名
ALTER TABLE events ADD COLUMN bank_branch TEXT; -- 支店名
ALTER TABLE events ADD COLUMN bank_account_type TEXT; -- 口座種別（普通/当座）
ALTER TABLE events ADD COLUMN bank_account_number TEXT; -- 口座番号
ALTER TABLE events ADD COLUMN bank_account_name TEXT; -- 口座名義

-- コメント:
-- payment_methods は複数選択を表すためのビットマスク
-- 例: クレカ+銀行振込 = 1+2 = 3
-- 例: 全て選択 = 1+2+4 = 7
