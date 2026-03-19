-- 商品テーブルに画像URLカラムを追加
ALTER TABLE products ADD COLUMN image_url TEXT;

-- 既存の商品にはデフォルトのプレースホルダー画像を設定
UPDATE products SET image_url = '/static/images/no-image.svg' WHERE image_url IS NULL;

-- インデックスは不要（検索条件に使わない）

-- 動作確認用のコメント
-- image_url: 商品画像のURL（R2バケットのURL or ローカルパス）
