# 価格帯表示修正手順

## 問題

管理画面（`products-edit.html`）で価格帯が表示されない問題が発生しています。

**原因**：
- 管理画面のJavaScriptは `category_name` を **「A-名称1」形式** で解析します
- 現在のデータベースには **「大人」「子供」** という形式で保存されています
- フォーマットが一致しないため、解析に失敗し、価格帯が表示されません

## 解決方法

Cloudflare Dashboardから以下の手順でSQLスクリプトを実行してください：

### 手順1: Cloudflare Dashboardにログイン

1. https://dash.cloudflare.com/ にアクセス
2. **Workers & Pages** を選択
3. 左メニューから **D1 SQL Database** を選択
4. **webapp-production** データベースをクリック

### 手順2: SQLスクリプトを実行

1. **Console** タブを開く
2. 以下のSQLをコピー&ペーストして実行：

```sql
-- 商品8（東京スカイツリー 展望デッキ入場券）
DELETE FROM product_prices WHERE product_id = 8;
INSERT INTO product_prices (product_id, price, category_name, price_band, slot_number, created_at, modified_at) 
VALUES 
(8, 2100, 'A-名称1', 'A', 1, datetime('now', 'localtime'), datetime('now', 'localtime')),
(8, 1550, 'A-名称2', 'A', 2, datetime('now', 'localtime'), datetime('now', 'localtime')),
(8, 950, 'A-名称3', 'A', 3, datetime('now', 'localtime'), datetime('now', 'localtime'));

UPDATE products 
SET common_names = '[{"name":"大人","description":"大人料金","label":"名称1"},{"name":"中高生","description":"中高生料金","label":"名称2"},{"name":"小学生","description":"小学生料金","label":"名称3"}]',
    modified_at = datetime('now', 'localtime')
WHERE id = 8;

-- 商品9（東京スカイツリー 天望回廊セット券）
DELETE FROM product_prices WHERE product_id = 9;
INSERT INTO product_prices (product_id, price, category_name, price_band, slot_number, created_at, modified_at) 
VALUES 
(9, 3100, 'A-名称1', 'A', 1, datetime('now', 'localtime'), datetime('now', 'localtime')),
(9, 2350, 'A-名称2', 'A', 2, datetime('now', 'localtime'), datetime('now', 'localtime')),
(9, 1450, 'A-名称3', 'A', 3, datetime('now', 'localtime'), datetime('now', 'localtime'));

UPDATE products 
SET common_names = '[{"name":"大人","description":"大人料金","label":"名称1"},{"name":"中高生","description":"中高生料金","label":"名称2"},{"name":"小学生","description":"小学生料金","label":"名称3"}]',
    modified_at = datetime('now', 'localtime')
WHERE id = 9;
```

3. **Execute** ボタンをクリック

### 手順3: 確認

修正後、管理画面で以下を確認：

1. https://webapp-geh.pages.dev/products-edit?id=8&event_id=4
2. 価格帯Aが表示され、3つの料金（大人/中高生/小学生）が確認できること

## 技術的な詳細

### 価格帯フォーマット

管理画面は以下の形式を想定しています：

- `category_name`: **「A-名称1」「A-名称2」「A-名称3」**
- `price_band`: **「A」**
- `slot_number`: **1, 2, 3**

### 共通名称（common_names）

JSONフォーマット：
```json
[
  {"name":"大人","description":"大人料金","label":"名称1"},
  {"name":"中高生","description":"中高生料金","label":"名称2"},
  {"name":"小学生","description":"小学生料金","label":"名称3"}
]
```

このJSONにより、管理画面は「A-名称1」を「大人」として表示します。

## 参考

- SQLスクリプト: `/migrations/fix_price_band_format.sql`
- 管理画面JS: `/public/js/pages/admin-product-edit.js` (行279-308)
