-- 価格帯システムを再設計
-- 価格帯（A-Z）ごとに複数の名称（大人、子供など）を持つ構造に変更

-- 古いカラムの意味を変更
-- price_band: 価格帯記号（A, B, C, ...）
-- price_name: 名称枠の名前（大人、子供、幼児、シニア、80歳以上など）
-- slot_number: 同一価格帯内での名称の順番（1-5）

-- 例：
-- 価格帯A - 大人: price_band='A', price_name='大人', slot_number=1, price=10000
-- 価格帯A - 子供: price_band='A', price_name='子供', slot_number=2, price=7000
-- 価格帯A - 幼児: price_band='A', price_name='幼児', slot_number=3, price=5000
-- 価格帯B - 大人: price_band='B', price_name='大人', slot_number=1, price=10000
-- 価格帯B - 子供: price_band='B', price_name='子供', slot_number=2, price=7000

-- 既存データのクリーンアップ（開発環境のみ）
UPDATE product_prices SET price_band = 'A' WHERE price_band IS NULL OR price_band = '';
UPDATE product_prices SET slot_number = 1 WHERE slot_number IS NULL OR slot_number = 0;

-- インデックスを追加（価格帯とスロット番号でのクエリを高速化）
CREATE INDEX IF NOT EXISTS idx_product_prices_band_slot ON product_prices(product_id, price_band, slot_number);
