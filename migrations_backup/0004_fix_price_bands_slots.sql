-- 価格帯システムを5枠固定スロットシステムに変更

-- slot_number カラムを追加（1-5の固定スロット番号）
ALTER TABLE product_prices ADD COLUMN slot_number INTEGER DEFAULT 1;

-- 既存データを第1スロットに設定
UPDATE product_prices SET slot_number = 1 WHERE slot_number IS NULL OR slot_number = 0;

-- price_band は A-Z の選択式
-- price_name は各スロットの名称（例：大人、子供、幼児、60歳以上、70歳以上）
-- slot_number は 1-5 の固定枠
-- display_order は表示順（slot_numberと同じ値を推奨）

-- コメント：
-- 商品登録時に5枠固定で価格帯を設定
-- 各枠（slot_number 1-5）に対して：
--   - 価格帯記号（price_band: A-Z）を選択
--   - 価格帯名称（price_name: 大人、子供など）を入力
--   - 価格（price）を入力
