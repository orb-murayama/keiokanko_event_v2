-- product_form_fieldsテーブルにcategoryカラムを追加
-- このカラムは各フォームフィールドが「商品用」か「参加者毎用」かを判定するために使用
-- 1 = 商品（商品情報入力時に表示）
-- 2 = 参加者毎（参加者情報入力時に表示）

ALTER TABLE product_form_fields 
ADD COLUMN category INTEGER DEFAULT 1;

-- 既存レコードのデフォルト値を設定（全て「商品」に設定）
UPDATE product_form_fields 
SET category = 1 
WHERE category IS NULL;
