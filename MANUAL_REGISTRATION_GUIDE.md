# 管理画面から価格帯を手動登録する手順

## 前提条件

既存データを削除してから手動登録する場合は、以下のSQLをCloudflare Dashboardで実行してください：

```sql
DELETE FROM product_prices WHERE product_id = 8;
UPDATE products SET common_names = '[]' WHERE id = 8;
```

## 手順

### 1. 商品編集画面を開く

https://webapp-geh.pages.dev/products-edit?id=8&event_id=4

### 2. 共通名称を設定

画面上部の「共通名称」セクションで以下を入力：

| 名称 | 説明 |
|------|------|
| 名称1: 大人 | 大人料金 |
| 名称2: 中高生 | 中高生料金 |
| 名称3: 小学生 | 小学生料金 |

### 3. 価格帯を追加

「価格帯を追加」ボタンをクリックすると、価格帯Aが表示されます。

### 4. 各料金を入力

| 名称 | 料金 |
|------|------|
| 大人 | 2100円 |
| 中高生 | 1550円 |
| 小学生 | 950円 |

### 5. 保存

「保存」ボタンをクリックして完了。

## データベースに保存される形式

保存後、以下の形式でデータベースに保存されます：

```sql
-- product_prices テーブル
INSERT INTO product_prices (product_id, price, category_name, price_band, slot_number) VALUES
(8, 2100, 'A-名称1', 'A', 1),
(8, 1550, 'A-名称2', 'A', 2),
(8, 950, 'A-名称3', 'A', 3);

-- products テーブル
UPDATE products SET common_names = '[
  {"name":"大人","description":"大人料金","label":"名称1"},
  {"name":"中高生","description":"中高生料金","label":"名称2"},
  {"name":"小学生","description":"小学生料金","label":"名称3"}
]' WHERE id = 8;
```

## フロント画面での表示

保存後、以下のURLで正しく表示されます：

- **商品詳細**: https://webapp-geh.pages.dev/product-detail?event_id=4
- **予約画面**: https://webapp-geh.pages.dev/booking?event_id=4&product_id=8

料金は「大人」「中高生」「小学生」として表示されます。

## トラブルシューティング

### 価格帯が表示されない

既存の古いデータが残っている可能性があります。Cloudflare Dashboardで以下を実行：

```sql
SELECT * FROM product_prices WHERE product_id = 8;
```

結果が「A-名称1」形式でない場合は、データをクリアして再登録してください：

```sql
DELETE FROM product_prices WHERE product_id = 8;
UPDATE products SET common_names = '[]' WHERE id = 8;
```

### 保存後にエラーが出る

ブラウザのコンソールを開いて（F12キー）、エラーメッセージを確認してください。
