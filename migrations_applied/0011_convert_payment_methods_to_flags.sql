-- payment_methodsビット形式を個別フラグに変換
-- 1: クレジットカード
-- 2: 銀行振込
-- 4: コンビニ

-- 新しいフラグカラムを追加
ALTER TABLE events ADD COLUMN payment_credit_card INTEGER DEFAULT 0;
ALTER TABLE events ADD COLUMN payment_bank_transfer INTEGER DEFAULT 0;
ALTER TABLE events ADD COLUMN payment_convenience_store INTEGER DEFAULT 0;

-- 既存データを移行（payment_methodsが数値の場合）
UPDATE events 
SET 
  payment_credit_card = CASE WHEN CAST(payment_methods AS INTEGER) & 1 THEN 1 ELSE 0 END,
  payment_bank_transfer = CASE WHEN CAST(payment_methods AS INTEGER) & 2 THEN 1 ELSE 0 END,
  payment_convenience_store = CASE WHEN CAST(payment_methods AS INTEGER) & 4 THEN 1 ELSE 0 END
WHERE payment_methods IS NOT NULL AND payment_methods != '';

-- payment_methodsカラムは互換性のため残す（後で削除可能）
-- DROP COLUMN payment_methods; -- SQLiteはDROP COLUMNをサポートしていない
