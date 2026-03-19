-- マイグレーション: product_form_fields テーブルに category カラムを追加
-- 作成日: 2026-02-10
-- 説明: フォームフィールドの区分（1:商品、2:参加者毎）を管理するカラムを追加

-- category カラムを追加（既存のレコードはデフォルト値 1 になる）
ALTER TABLE product_form_fields ADD COLUMN category INTEGER DEFAULT 1;

-- コメント:
-- category の値:
--   1: 商品 - 商品全体で1回だけ入力するフィールド（例：代表者名、連絡先）
--   2: 参加者毎 - 参加者ごとに繰り返し入力するフィールド（例：参加者氏名、年齢）
