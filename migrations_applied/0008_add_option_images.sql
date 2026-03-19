-- オプションテーブルに画像URLカラムを追加
ALTER TABLE options ADD COLUMN image_url TEXT;

-- 既存のオプションにはデフォルトのプレースホルダー画像を設定
UPDATE options SET image_url = '/static/images/no-image.svg' WHERE image_url IS NULL;

-- インデックスは不要（検索条件に使わない）

-- 動作確認用のコメント
-- image_url: オプション画像のURL（R2バケットのURL or ローカルパス）
