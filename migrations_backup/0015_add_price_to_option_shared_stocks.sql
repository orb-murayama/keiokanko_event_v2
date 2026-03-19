-- マイグレーション: option_shared_stocksテーブルにpriceカラムを追加
-- 共有在庫ごとに料金を設定できるようにする

-- option_shared_stocksにpriceカラムを追加
ALTER TABLE option_shared_stocks ADD COLUMN price INTEGER;

-- コメント: priceはオプション共有在庫の料金（円単位）
-- NULLの場合はオプション基本料金を使用
