-- 文字列"null"をNULLに修正（deleted_at フィールド）
-- 問題: deleted_atに文字列"null"が入っているレコードがあり、IS NULL条件で除外できない

UPDATE events SET deleted_at = NULL 
WHERE deleted_at = 'null' OR deleted_at = '' OR deleted_at = 'undefined';

UPDATE products SET deleted_at = NULL 
WHERE deleted_at = 'null' OR deleted_at = '' OR deleted_at = 'undefined';

UPDATE options SET deleted_at = NULL 
WHERE deleted_at = 'null' OR deleted_at = '' OR deleted_at = 'undefined';
