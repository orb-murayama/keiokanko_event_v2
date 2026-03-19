-- イベント3（東京1日観光ツアー）の商品に画像URLを設定

-- 商品1: スタンダードプラン
UPDATE products 
SET image_url = 'https://placehold.co/400x300/3b82f6/ffffff?text=Standard+Tour'
WHERE id = 1 AND event_id = 3;

-- 商品2: プレミアムプラン
UPDATE products 
SET image_url = 'https://placehold.co/400x300/f59e0b/ffffff?text=Premium+Tour'
WHERE id = 2 AND event_id = 3;

-- 商品3: プライベート観光ツアー
UPDATE products 
SET image_url = 'https://placehold.co/400x300/8b5cf6/ffffff?text=Private+Tour'
WHERE id = 3 AND event_id = 3;

-- イベント3にも画像URLを設定
UPDATE events 
SET image_url = 'https://placehold.co/1920x600/1e40af/ffffff?text=Tokyo+City+Tour'
WHERE id = 3;
