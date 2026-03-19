-- オプション在庫テーブルに料金カラムを追加
ALTER TABLE option_stocks ADD COLUMN price INTEGER DEFAULT 0;

-- 料金インデックスを作成
CREATE INDEX IF NOT EXISTS idx_option_stocks_price ON option_stocks(price);
