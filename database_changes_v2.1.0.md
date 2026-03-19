# データベース変更履歴 v2.1.0 (2026-01-23)

## 📋 変更概要

フォーム設定を**イベント単位**から**商品単位**の管理に変更しました。

---

## 🔄 変更内容

### 1. productsテーブル

#### 追加カラム
| カラム名 | データ型 | 説明 | デフォルト値 |
|---------|---------|------|------------|
| `form_field_settings` | TEXT | 入力フォーム項目設定（JSON形式） | `{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}` |

#### JSON形式の詳細
```json
{
  "name_kanji": true,      // 氏名（漢字）
  "name_kana": true,       // 氏名（カナ）
  "name_roma": false,      // 氏名（ローマ字）
  "address": true,         // 住所
  "tel": true,             // 電話番号
  "birth_date": false,     // 生年月日
  "age": false             // 年齢
}
```

#### マイグレーションSQL
```sql
ALTER TABLE products 
ADD COLUMN form_field_settings TEXT 
DEFAULT '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}';
```

---

### 2. product_form_fieldsテーブル（新規作成）

商品別のカスタムフォーム項目を管理するテーブル。

| カラム名 | データ型 | 制約 | 説明 |
|---------|---------|------|------|
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | ID |
| `product_id` | INTEGER | NOT NULL, FOREIGN KEY | 商品ID（products.id） |
| `field_type` | TEXT | NOT NULL | フィールドタイプ（text, textarea, select, radio, checkbox, date, file） |
| `field_name` | TEXT | NOT NULL | フィールド名 |
| `field_label` | TEXT | NOT NULL | フィールドラベル |
| `field_options` | TEXT | | 選択肢（JSON形式） |
| `is_required` | INTEGER | DEFAULT 0 | 必須フラグ（0: 任意, 1: 必須） |
| `description` | TEXT | | 説明文 |
| `display_order` | INTEGER | DEFAULT 0 | 表示順序 |
| `placeholder` | TEXT | | プレースホルダー |
| `parent_field_id` | INTEGER | | 親フィールドID（条件分岐用） |
| `parent_condition` | TEXT | | 親フィールドの条件 |
| `indent_level` | INTEGER | DEFAULT 0 | インデントレベル |
| `created_at` | TEXT | DEFAULT (datetime('now','localtime')) | 作成日時 |
| `modified_at` | TEXT | DEFAULT (datetime('now','localtime')) | 更新日時 |

#### 外部キー
- `product_id` → `products(id)`

#### 作成SQL
```sql
CREATE TABLE IF NOT EXISTS product_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  field_type TEXT NOT NULL,
  field_name TEXT NOT NULL,
  field_label TEXT NOT NULL,
  field_options TEXT,
  is_required INTEGER DEFAULT 0,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  placeholder TEXT,
  parent_field_id INTEGER,
  parent_condition TEXT,
  indent_level INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (product_id) REFERENCES products(id)
)
```

---

### 3. booking_form_responsesテーブル

#### 追加カラム
| カラム名 | データ型 | 制約 | 説明 |
|---------|---------|------|------|
| `product_id` | INTEGER | | 商品ID（products.id） |

#### 追加インデックス
```sql
CREATE INDEX IF NOT EXISTS idx_booking_form_responses_product_id 
ON booking_form_responses(product_id);
```

#### マイグレーションSQL
```sql
ALTER TABLE booking_form_responses 
ADD COLUMN product_id INTEGER;

CREATE INDEX IF NOT EXISTS idx_booking_form_responses_product_id 
ON booking_form_responses(product_id);
```

#### 変更理由
予約時のフォーム回答を商品単位で管理するため。複数商品がある場合、各商品のフォーム項目を合算して表示する。

---

### 4. event_form_fieldsテーブル（非推奨化）

**このテーブルは削除されました。**

代わりに `product_form_fields` テーブルを使用してください。

#### 削除SQL
```sql
DROP TABLE IF EXISTS event_form_fields;
```

---

### 5. eventsテーブル

#### 変更なし
`form_field_settings`カラムは残りますが、新規イベントでは使用されません。

---

## 🔗 関連API変更

### 削除されたAPI
- `GET /api/events/{id}/form-fields` - イベントフォーム項目取得
- `POST /api/events/{id}/form-fields` - イベントフォーム項目登録

### 追加されたAPI
- `GET /api/products/{id}/form-fields` - 商品フォーム項目取得
- `POST /api/products/{id}/form-fields` - 商品フォーム項目登録

### 変更されたAPI
- `GET /api/products/{id}` - レスポンスに`form_field_settings`を含む
- `POST /api/products` - リクエストボディに`form_field_settings`を含む
- `PUT /api/products/{id}` - リクエストボディに`form_field_settings`を含む
- `POST /api/products/{id}/copy` - `form_field_settings`もコピーされる

---

## 📊 影響範囲

### 管理画面UI
- **イベント管理画面**: 「入力フォーム項目設定」セクションを削除
- **商品管理画面**: 「入力フォーム項目設定」セクションを追加（販売期間・締切の後、共通名称設定の前）

### 予約フォーム
- 商品単位でフォーム項目を表示
- 複数商品がある場合は、各商品のフォーム設定を合算して重複しないように表示

---

## 🚀 移行手順

### 1. ローカル開発環境
```bash
# データベースにカラムを追加
npx wrangler d1 execute webapp-production --local --command="
ALTER TABLE products ADD COLUMN form_field_settings TEXT DEFAULT '{\"name_kanji\":true,\"name_kana\":true,\"name_roma\":false,\"address\":true,\"tel\":true,\"birth_date\":false,\"age\":false}';
"

# 既存テーブルを削除（オプション）
npx wrangler d1 execute webapp-production --local --command="
DROP TABLE IF EXISTS event_form_fields;
"

# アプリケーションを再起動
pm2 restart webapp
```

### 2. 本番環境
```bash
# データベースにカラムを追加（本番）
npx wrangler d1 execute webapp-production --command="
ALTER TABLE products ADD COLUMN form_field_settings TEXT DEFAULT '{\"name_kanji\":true,\"name_kana\":true,\"name_roma\":false,\"address\":true,\"tel\":true,\"birth_date\":false,\"age\":false}';
"

# デプロイ
npm run deploy
```

---

## 📝 備考

- **既存データ**: イベントテーブルの`form_field_settings`は保持されますが、新規イベントでは使用されません
- **互換性**: 既存の予約データには影響ありません
- **ロールバック**: 必要に応じて、`event_form_fields`テーブルを再作成できます

---

**作成日**: 2026-01-23  
**バージョン**: 2.1.0  
**作成者**: 開発チーム
