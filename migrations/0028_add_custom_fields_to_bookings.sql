-- マイグレーション: bookings テーブルに custom_fields カラムを追加
-- 区分=1（商品）のカスタムフィールドを保存するためのカラム
-- JSON形式でフィールド名と値を保存
-- 例: {"meal": "和食", "request": "アレルギーなし"}

ALTER TABLE bookings ADD COLUMN custom_fields TEXT;
