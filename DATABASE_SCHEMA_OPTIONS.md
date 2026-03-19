# オプション管理データベーススキーマ仕様書

**バージョン**: 1.0  
**作成日**: 2026-02-05  
**最終更新**: 2026-02-05

---

## 目次

1. [概要](#概要)
2. [ER図](#er図)
3. [テーブル一覧](#テーブル一覧)
4. [テーブル詳細](#テーブル詳細)
5. [インデックス](#インデックス)
6. [制約・ルール](#制約ルール)
7. [関連ドキュメント](#関連ドキュメント)
8. [変更履歴](#変更履歴)

---

## 概要

オプション管理データベースは、イベントに紐づくオプション商品（お弁当・駐車場・シャトルバス等）の管理に必要なテーブル群です。オプション情報、価格設定、在庫管理、予約情報を格納します。

**主要機能**:
- オプションマスタ管理
- 価格設定・在庫管理
- 日付別在庫管理
- 予約管理

**テーブル総数**: 5テーブル

---

## ER図

```
┌─────────────────┐
│ option_         │
│ categories      │
└────────┬────────┘
         │
         │ 1:N
         │
┌────────▼────────────────────────┐
│ options                         │
│ ・基本情報                       │
│ ・キャンセルポリシー              │
└─┬───────┬──────────┬────────────┘
  │       │          │
  │ 1:N   │ 1:N      │ 1:N
  │       │          │
┌─▼──────────┐ ┌─▼─────────────┐ ┌─▼────────────────┐
│ option_    │ │ option_       │ │ option_          │
│ prices     │ │ stocks        │ │ bookings         │
│ ・価格設定 │ │ ・日別在庫    │ │ ・予約情報       │
└────────────┘ └───────────────┘ └──────────────────┘
```

---

## テーブル一覧

| テーブル名 | 説明 | 主な用途 |
|-----------|------|---------|
| `option_categories` | オプションカテゴリ | オプションの分類管理 |
| `options` | オプションマスタ | オプションの基本情報 |
| `option_prices` | オプション価格 | 料金設定 |
| `option_stocks` | オプション在庫 | 日別在庫管理 |
| `option_bookings` | オプション予約 | 予約情報管理 |

---

## テーブル詳細

### 1. option_categories（オプションカテゴリ）

オプションの分類を管理するマスタテーブル。

#### スキーマ

```sql
CREATE TABLE option_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
)
```

#### カラム定義

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | カテゴリID（主キー） |
| `name` | TEXT | NO | - | カテゴリ名 |
| `description` | TEXT | YES | NULL | 説明 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### インデックス

```sql
CREATE INDEX idx_option_categories_name ON option_categories(name);
```

#### サンプルデータ

```sql
INSERT INTO option_categories (name, description) VALUES
  ('食事', 'お弁当・飲食オプション'),
  ('交通', '駐車場・シャトルバス'),
  ('物品', 'レンタル品・グッズ');
```

---

### 2. options（オプションマスタ）

オプションの基本情報を管理するメインテーブル。

#### スキーマ

```sql
CREATE TABLE options (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  remarks TEXT,
  option_category_id INTEGER NOT NULL,
  cancel_policy TEXT,
  note TEXT,
  enable_flg INTEGER DEFAULT 1,
  image_url TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  deleted_at TEXT,
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (option_category_id) REFERENCES option_categories(id)
)
```

#### カラム定義

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | オプションID（主キー） |
| `event_id` | INTEGER | NO | - | イベントID |
| `name` | TEXT | NO | - | オプション名 |
| `description` | TEXT | YES | NULL | 説明 |
| `remarks` | TEXT | YES | NULL | 備考 |
| `option_category_id` | INTEGER | NO | - | オプションカテゴリID |
| `cancel_policy` | TEXT | YES | NULL | キャンセルポリシー |
| `note` | TEXT | YES | NULL | 特記事項 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `image_url` | TEXT | YES | NULL | 画像URL |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |
| `deleted_at` | TEXT | YES | NULL | 削除日時（論理削除） |

#### 外部キー

```sql
FOREIGN KEY (event_id) REFERENCES events(id)
FOREIGN KEY (option_category_id) REFERENCES option_categories(id)
```

#### インデックス

```sql
CREATE INDEX idx_options_event_id ON options(event_id);
CREATE INDEX idx_options_category_id ON options(option_category_id);
CREATE INDEX idx_options_deleted_at ON options(deleted_at);
CREATE INDEX idx_options_enable_flg ON options(enable_flg);
```

#### サンプルデータ

```sql
INSERT INTO options (event_id, name, description, remarks, option_category_id, cancel_policy, note, enable_flg, image_url) VALUES
  (1, 'お弁当（和食）', '季節の和食弁当', 'アレルギー対応可', 1, '前日まで無料キャンセル可', '特記事項なし', 1, '/api/options/images/option_1.jpg'),
  (1, '駐車場', '会場駐車場利用券', '当日先着順', 2, 'キャンセル不可', NULL, 1, '/api/options/images/option_2.jpg'),
  (1, 'シャトルバス', '駅↔会場シャトルバス', '30分間隔運行', 2, '前日まで無料キャンセル可', NULL, 1, '/api/options/images/option_3.jpg');
```

---

### 3. option_prices（オプション価格）

オプションの価格設定を管理するテーブル。

#### スキーマ

```sql
CREATE TABLE option_prices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  category_name TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
)
```

#### カラム定義

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 価格ID（主キー） |
| `option_id` | INTEGER | NO | - | オプションID |
| `price` | INTEGER | NO | - | 価格（円） |
| `category_name` | TEXT | YES | NULL | カテゴリ名（標準、大人、子供等） |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (option_id) REFERENCES options(id)
```

#### インデックス

```sql
CREATE INDEX idx_option_prices_option_id ON option_prices(option_id);
```

#### サンプルデータ

```sql
INSERT INTO option_prices (option_id, price, category_name) VALUES
  (1, 1200, '標準'),
  (2, 500, '標準'),
  (3, 300, '標準');
```

---

### 4. option_stocks（オプション在庫）

オプションの日別在庫を管理するテーブル。

#### スキーマ

```sql
CREATE TABLE option_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  date TEXT,
  stock INTEGER NOT NULL DEFAULT 0,
  booked INTEGER NOT NULL DEFAULT 0,
  stock_name TEXT,
  price INTEGER,
  total_stock INTEGER DEFAULT 0,
  available_stock INTEGER DEFAULT 0,
  enable_flg INTEGER DEFAULT 1,
  shared_pool_id INTEGER,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
)
```

#### カラム定義

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 在庫ID（主キー） |
| `option_id` | INTEGER | NO | - | オプションID |
| `date` | TEXT | YES | NULL | 日付（YYYY-MM-DD） |
| `stock` | INTEGER | NO | 0 | 在庫数 |
| `booked` | INTEGER | NO | 0 | 予約済み数 |
| `stock_name` | TEXT | YES | NULL | 在庫名 |
| `price` | INTEGER | YES | NULL | 価格 |
| `total_stock` | INTEGER | YES | 0 | 総在庫数 |
| `available_stock` | INTEGER | YES | 0 | 利用可能在庫数 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `shared_pool_id` | INTEGER | YES | NULL | 共有在庫プールID |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (option_id) REFERENCES options(id)
```

#### インデックス

```sql
CREATE INDEX idx_option_stocks_option_id ON option_stocks(option_id);
CREATE INDEX idx_option_stocks_date ON option_stocks(date);
CREATE INDEX idx_option_stocks_enable_flg ON option_stocks(enable_flg);
CREATE INDEX idx_option_stocks_shared_pool_id ON option_stocks(shared_pool_id);
```

#### 計算ロジック

**利用可能在庫数** = `stock` - `booked`

または

**利用可能在庫数** = `available_stock` (直接格納されている場合)

#### サンプルデータ

```sql
INSERT INTO option_stocks (option_id, date, stock, booked, stock_name, price, total_stock, available_stock, enable_flg) VALUES
  (1, '2024-08-01', 100, 25, 'お弁当（和食）', 1200, 100, 75, 1),
  (1, '2024-08-02', 100, 30, 'お弁当（和食）', 1200, 100, 70, 1),
  (2, '2024-08-01', 50, 10, '駐車場', 500, 50, 40, 1),
  (3, '2024-08-01', 80, 15, 'シャトルバス', 300, 80, 65, 1);
```

---

### 5. option_bookings（オプション予約）

オプションの予約情報を管理するテーブル。

#### スキーマ

```sql
CREATE TABLE option_bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  option_id INTEGER NOT NULL,
  option_stock_id INTEGER,
  price INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  enable_flg INTEGER DEFAULT 1,
  canceled_at TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (option_id) REFERENCES options(id),
  FOREIGN KEY (option_stock_id) REFERENCES option_stocks(id)
)
```

#### カラム定義

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| `id` | INTEGER | NO | AUTO_INCREMENT | 予約ID（主キー） |
| `customer_id` | INTEGER | NO | - | 顧客ID |
| `option_id` | INTEGER | NO | - | オプションID |
| `option_stock_id` | INTEGER | YES | NULL | オプション在庫ID |
| `price` | INTEGER | NO | - | 金額（円） |
| `quantity` | INTEGER | NO | 1 | 数量 |
| `enable_flg` | INTEGER | YES | 1 | 有効フラグ（0: 無効, 1: 有効） |
| `canceled_at` | TEXT | YES | NULL | キャンセル日時 |
| `created_at` | TEXT | YES | datetime('now', 'localtime') | 作成日時 |
| `modified_at` | TEXT | YES | datetime('now', 'localtime') | 更新日時 |

#### 外部キー

```sql
FOREIGN KEY (customer_id) REFERENCES customers(id)
FOREIGN KEY (option_id) REFERENCES options(id)
FOREIGN KEY (option_stock_id) REFERENCES option_stocks(id)
```

#### インデックス

```sql
CREATE INDEX idx_option_bookings_customer_id ON option_bookings(customer_id);
CREATE INDEX idx_option_bookings_option_id ON option_bookings(option_id);
CREATE INDEX idx_option_bookings_option_stock_id ON option_bookings(option_stock_id);
CREATE INDEX idx_option_bookings_canceled_at ON option_bookings(canceled_at);
```

#### サンプルデータ

```sql
INSERT INTO option_bookings (customer_id, option_id, option_stock_id, price, quantity, enable_flg) VALUES
  (1, 1, 1, 1200, 2, 1),
  (1, 2, 3, 500, 1, 1),
  (2, 3, 4, 300, 3, 1);
```

---

## インデックス

### 推奨インデックス一覧

```sql
-- option_categories
CREATE INDEX idx_option_categories_name ON option_categories(name);

-- options
CREATE INDEX idx_options_event_id ON options(event_id);
CREATE INDEX idx_options_category_id ON options(option_category_id);
CREATE INDEX idx_options_deleted_at ON options(deleted_at);
CREATE INDEX idx_options_enable_flg ON options(enable_flg);

-- option_prices
CREATE INDEX idx_option_prices_option_id ON option_prices(option_id);

-- option_stocks
CREATE INDEX idx_option_stocks_option_id ON option_stocks(option_id);
CREATE INDEX idx_option_stocks_date ON option_stocks(date);
CREATE INDEX idx_option_stocks_enable_flg ON option_stocks(enable_flg);
CREATE INDEX idx_option_stocks_shared_pool_id ON option_stocks(shared_pool_id);

-- option_bookings
CREATE INDEX idx_option_bookings_customer_id ON option_bookings(customer_id);
CREATE INDEX idx_option_bookings_option_id ON option_bookings(option_id);
CREATE INDEX idx_option_bookings_option_stock_id ON option_bookings(option_stock_id);
CREATE INDEX idx_option_bookings_canceled_at ON option_bookings(canceled_at);
```

---

## 制約・ルール

### 1. 論理削除

**対象テーブル**: `options`

削除時は `deleted_at` に削除日時を設定し、物理削除は行わない。

```sql
UPDATE options SET deleted_at = datetime('now', 'localtime') WHERE id = ?;
```

### 2. 有効フラグ

**対象テーブル**: `options`, `option_stocks`, `option_bookings`

`enable_flg` を使用した論理的な無効化が可能。

- `0`: 無効（非表示・非アクティブ）
- `1`: 有効（表示・アクティブ）

### 3. 在庫管理ロジック

#### 利用可能在庫の計算

**パターン1: stock と booked を使用**
```
利用可能在庫数 = stock - booked
```

**パターン2: available_stock を直接使用**
```
利用可能在庫数 = available_stock
```

**パターン3: total_stock と booked を使用**
```
利用可能在庫数 = total_stock - booked
```

### 4. 日付形式

日付は `YYYY-MM-DD` 形式で格納（例: `2024-08-01`）

### 5. キャンセル処理

予約キャンセル時は `option_bookings.canceled_at` に日時を設定。

```sql
UPDATE option_bookings SET canceled_at = datetime('now', 'localtime') WHERE id = ?;
```

### 6. 価格設定

- 基本価格は `option_prices` テーブルで管理
- 日別価格変動がある場合は `option_stocks.price` を使用
- `option_stocks.price` が NULL の場合は `option_prices.price` を参照

### 7. オプション分類

`option_category_id` によってオプションを分類：
- 食事（お弁当、飲み物等）
- 交通（駐車場、シャトルバス等）
- 物品（レンタル品、グッズ等）

### 8. イベントとの関連

すべてのオプションは必ず1つのイベントに紐づく（`options.event_id`）。

---

## 関連ドキュメント

- [API_SPEC_OPTION_MANAGEMENT.md](./API_SPEC_OPTION_MANAGEMENT.md) - オプション管理API仕様書
- [DATABASE_SCHEMA_PRODUCTS.md](./DATABASE_SCHEMA_PRODUCTS.md) - 商品管理データベーススキーマ
- [database_schema_complete.sql](./database_schema_complete.sql) - 完全なデータベーススキーマSQL

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|---------|
| 1.0 | 2026-02-05 | 初版作成 |

---

## 問い合わせ

データベーススキーマに関するお問い合わせは、開発チームまでご連絡ください。
