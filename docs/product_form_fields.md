# 商品フォーム項目マスター（product_form_fields）

## 概要

**目的**: 商品ごとにカスタマイズ可能な入力フォームを動的に管理し、商品予約時に収集する顧客情報のフィールド定義を保存する。

**テーブル名**: `product_form_fields`

**関連テーブル**:
- `products`: 商品マスター（product_id で紐付け）
- `product_bookings`: 商品予約データ（フォーム入力値を保存）
- `booking_form_responses`: 予約フォーム回答データ

## テーブル構造

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|------|------|-----------|------|
| id | INTEGER | NO | AUTO_INCREMENT | フィールドID（主キー） |
| product_id | INTEGER | NO | - | 商品ID（products.id） |
| field_type | TEXT | NO | - | フィールドタイプ（text/email/tel/select/radio/checkbox/textarea/date/number/time/datetime/file） |
| field_name | TEXT | NO | - | フィールド名（内部識別用、例: checkin_date, room_type） |
| field_label | TEXT | NO | - | フィールドラベル（表示用、例: チェックイン日、部屋タイプ） |
| field_options | TEXT | YES | NULL | 選択肢（JSON配列形式、select/radio/checkbox用）例: ["シングル","ツイン","ダブル"] |
| is_required | INTEGER | NO | 0 | 必須フラグ（1:必須/0:任意） |
| description | TEXT | YES | NULL | 説明文（フィールドの補足説明） |
| display_order | INTEGER | NO | 0 | 表示順序（昇順でソート） |
| placeholder | TEXT | YES | NULL | プレースホルダー（入力例の表示） |
| parent_field_id | INTEGER | YES | NULL | 親フィールドID（条件分岐用） |
| parent_condition | TEXT | YES | NULL | 親フィールドの条件値（例: "希望する"） |
| indent_level | INTEGER | NO | 0 | インデント階層レベル（0:親、1:子、2:孫...） |
| validation_rule | TEXT | YES | NULL | バリデーションルール（JSON形式、例: {"min":1,"max":10}） |
| default_value | TEXT | YES | NULL | デフォルト値 |
| help_text | TEXT | YES | NULL | ヘルプテキスト（詳細なガイダンス） |
| created_at | TEXT | NO | datetime('now','localtime') | 作成日時 |
| modified_at | TEXT | NO | datetime('now','localtime') | 更新日時 |

### インデックス

```sql
-- 商品IDでの検索を高速化
CREATE INDEX idx_product_form_fields_product_id ON product_form_fields(product_id);

-- 表示順序での並び替えを高速化
CREATE INDEX idx_product_form_fields_display_order ON product_form_fields(product_id, display_order);

-- 親子関係の検索を高速化
CREATE INDEX idx_product_form_fields_parent ON product_form_fields(parent_field_id);
```

## フィールドタイプ一覧

| タイプ | 説明 | 用途例 | HTML要素 |
|-------|------|--------|---------|
| text | 1行テキスト | 名前、住所、備考 | `<input type="text">` |
| email | メールアドレス | メールアドレス（自動バリデーション） | `<input type="email">` |
| tel | 電話番号 | 電話番号（自動フォーマット） | `<input type="tel">` |
| select | ドロップダウン選択 | 部屋タイプ、時間帯（1つ選択） | `<select>` |
| radio | ラジオボタン | 朝食希望、送迎希望（1つ選択） | `<input type="radio">` |
| checkbox | チェックボックス | 朝食メニュー、同意事項（複数選択可） | `<input type="checkbox">` |
| textarea | 複数行テキスト | 備考、要望、健康状態 | `<textarea>` |
| date | 日付選択 | チェックイン日、参加日 | `<input type="date">` |
| number | 数値入力 | 人数、年齢 | `<input type="number">` |
| time | 時刻選択 | 集合時間、送迎時刻 | `<input type="time">` |
| datetime | 日時選択 | 予約日時 | `<input type="datetime-local">` |
| file | ファイルアップロード | 証明書、身分証 | `<input type="file">` |

## 条件分岐機能

親フィールドの値に応じて、子フィールドの表示・非表示を制御できます。

### 設定方法

1. **親フィールド**: `parent_field_id` を NULL に設定
2. **子フィールド**: 
   - `parent_field_id` に親フィールドのIDを設定
   - `parent_condition` に表示条件の値を設定（親フィールドの選択値）
   - `indent_level` を1以上に設定（階層レベル）

### 使用例: 朝食オプション

```
朝食希望（radio）← 親フィールド
  ├─ 朝食の時間帯（select）← 子フィールド（parent_condition: "希望する"）
  └─ 朝食メニュー（checkbox）← 子フィールド（parent_condition: "希望する"）
```

**実装イメージ**:
```javascript
// 親フィールドの値が変更されたとき
if (parentFieldValue === parentCondition) {
  showChildField(); // 子フィールドを表示
} else {
  hideChildField(); // 子フィールドを非表示
}
```

## JSON形式の field_options

select/radio/checkbox タイプのフィールドで使用する選択肢をJSON配列で定義します。

### 基本的な形式

```json
["選択肢1", "選択肢2", "選択肢3"]
```

### 実例

#### 1. 部屋タイプ（select）
```json
["シングル", "ツイン", "ダブル", "スイート"]
```

#### 2. 朝食希望（radio）
```json
["希望する", "希望しない"]
```

#### 3. 朝食メニュー（checkbox）
```json
["和食", "洋食", "アレルギー対応食"]
```

#### 4. 体験レベル（radio）
```json
["初心者", "経験者"]
```

## バリデーションルール（validation_rule）

JSON形式でフィールドのバリデーションルールを定義します。

### 数値フィールド（number）

```json
{
  "min": 1,
  "max": 10,
  "step": 1
}
```

### 日付フィールド（date）

```json
{
  "min": "today",
  "max": "today+90"
}
```

または具体的な日付:
```json
{
  "min": "2024-04-01",
  "max": "2024-12-31"
}
```

### テキストフィールド（text/textarea）

```json
{
  "minLength": 10,
  "maxLength": 500,
  "pattern": "^[0-9]{3}-[0-9]{4}$"
}
```

## API設計

### 1. 商品のフォーム項目一覧取得

**エンドポイント**: `GET /api/products/:product_id/form-fields`

**レスポンス**:
```json
{
  "form_fields": [
    {
      "id": 1,
      "product_id": 1,
      "field_type": "date",
      "field_name": "checkin_date",
      "field_label": "チェックイン日",
      "field_options": null,
      "is_required": 1,
      "description": "ご宿泊開始日をお選びください",
      "display_order": 10,
      "placeholder": "2024-04-01",
      "parent_field_id": null,
      "parent_condition": null,
      "indent_level": 0,
      "validation_rule": "{\"min\":\"today\"}",
      "default_value": null,
      "help_text": "チェックイン時間は15:00以降です",
      "created_at": "2026-01-23 10:00:00",
      "modified_at": "2026-01-23 10:00:00"
    }
  ]
}
```

### 2. フォーム項目詳細取得

**エンドポイント**: `GET /api/products/:product_id/form-fields/:id`

### 3. フォーム項目作成

**エンドポイント**: `POST /api/products/:product_id/form-fields`

**リクエストボディ**:
```json
{
  "field_type": "date",
  "field_name": "checkin_date",
  "field_label": "チェックイン日",
  "is_required": 1,
  "description": "ご宿泊開始日をお選びください",
  "display_order": 10,
  "placeholder": "2024-04-01",
  "validation_rule": "{\"min\":\"today\"}",
  "help_text": "チェックイン時間は15:00以降です"
}
```

### 4. フォーム項目更新

**エンドポイント**: `PUT /api/products/:product_id/form-fields/:id`

### 5. フォーム項目削除

**エンドポイント**: `DELETE /api/products/:product_id/form-fields/:id`

### 6. 表示順序の一括更新

**エンドポイント**: `POST /api/products/:product_id/form-fields/reorder`

**リクエストボディ**:
```json
{
  "orders": [
    { "id": 1, "display_order": 10 },
    { "id": 2, "display_order": 20 },
    { "id": 3, "display_order": 30 }
  ]
}
```

## 使用例

### 宿泊プランのフォーム項目

| 順序 | フィールド名 | ラベル | タイプ | 必須 | 親フィールド | 条件 |
|-----|-------------|--------|------|------|-------------|------|
| 10 | checkin_date | チェックイン日 | date | ✓ | - | - |
| 20 | checkout_date | チェックアウト日 | date | ✓ | - | - |
| 30 | room_type | 部屋タイプ | select | ✓ | - | - |
| 40 | guest_count | 宿泊人数 | number | ✓ | - | - |
| 50 | breakfast_option | 朝食希望 | radio | - | - | - |
| 60 | breakfast_time | 朝食の時間帯 | select | - | 50 | "希望する" |
| 70 | breakfast_menu | 朝食メニュー | checkbox | - | 50 | "希望する" |
| 80 | allergy_info | アレルギー情報 | textarea | - | - | - |
| 90 | special_requests | 特別なご要望 | textarea | - | - | - |

### 体験ツアーのフォーム項目

| 順序 | フィールド名 | ラベル | タイプ | 必須 | 親フィールド | 条件 |
|-----|-------------|--------|------|------|-------------|------|
| 10 | tour_date | 参加希望日 | date | ✓ | - | - |
| 20 | tour_time | 希望時間帯 | select | ✓ | - | - |
| 30 | participant_count | 参加人数 | number | ✓ | - | - |
| 40 | experience_level | 体験レベル | radio | ✓ | - | - |
| 50 | equipment_rental | 装備レンタル | select | - | 40 | "経験者" |
| 60 | pickup_option | 送迎希望 | radio | - | - | - |
| 70 | pickup_location | 送迎場所 | text | - | 60 | "希望する" |
| 80 | pickup_time | 希望送迎時刻 | time | - | 60 | "希望する" |
| 90 | health_info | 健康状態について | textarea | - | - | - |
| 100 | consent_items | 同意事項 | checkbox | ✓ | - | - |

## セキュリティとバリデーション

### 1. 必須チェック項目

- **product_id**: 必須（外部キー制約相当の検証をアプリ層で実施）
- **field_type**: 定義済みタイプのみ許可（列挙型検証）
- **field_name**: 半角英数字とアンダースコアのみ（正規表現: `^[a-z0-9_]+$`）
- **親子関係**: 循環参照を防止（parent_field_id の検証）

### 2. JSON形式のバリデーション

- **field_options**: 有効なJSON配列形式のみ許可
- **validation_rule**: 有効なJSONオブジェクト形式のみ許可

### 3. 条件分岐の制約

- 親フィールドは `select` または `radio` タイプのみ
- 条件分岐は最大3階層まで推奨（複雑化を防止）

### 4. フラグの値制約

- **is_required**: 0 または 1 のみ
- **indent_level**: 0〜3 を推奨

## 運用ガイドライン

### 1. フォーム項目の追加・編集

- 管理者のみが実行可能
- display_order は 10, 20, 30... と10刻みで設定（後から項目を挿入しやすい）

### 2. 商品公開後の変更

- フォーム項目の削除は慎重に（既存予約データへの影響を考慮）
- 必須項目の追加は既存予約データの整合性を確認
- field_name は変更しない（予約データとの紐付けに使用）

### 3. 削除の推奨方法

- 物理削除ではなく、論理削除を推奨
- 将来的に `deleted_at` カラムの追加を検討

### 4. パフォーマンス最適化

- 商品あたりのフォーム項目数は20項目以内を推奨
- 条件分岐は最大3階層まで

## 関連する既存機能

### 商品テーブル（products）の form_field_settings

productsテーブルには `form_field_settings` カラム（JSON形式）が存在し、以下の7つの基本フォーム項目のON/OFF設定を保存します：

```json
{
  "name_kanji": true,     // 氏名（漢字）
  "name_kana": true,      // 氏名（カナ）
  "name_roma": false,     // 氏名（ローマ字）
  "address": true,        // 住所
  "tel": true,            // 電話番号
  "birth_date": false,    // 生年月日
  "age": false            // 年齢
}
```

### 使い分け

- **form_field_settings**: 基本的な顧客情報（氏名、住所など）のON/OFF
- **product_form_fields**: 商品固有のカスタム項目（チェックイン日、部屋タイプなど）

両者を組み合わせることで、柔軟な予約フォームを構築できます。

## マイグレーション状況

### 現状

- **テーブル**: product_form_fields テーブルは未作成
- **DDL**: `/home/user/webapp/ddl/product_form_fields.sql` に定義済み
- **シードデータ**: `/home/user/webapp/seed_product_form_fields.sql` に用意済み

### 適用手順

```bash
# 1. ローカルDBにテーブル作成
cd /home/user/webapp
npx wrangler d1 execute webapp-production --local --file=ddl/product_form_fields.sql

# 2. シードデータ投入
npx wrangler d1 execute webapp-production --local --file=seed_product_form_fields.sql

# 3. 本番DBにも適用（準備できたら）
npx wrangler d1 execute webapp-production --remote --file=ddl/product_form_fields.sql
npx wrangler d1 execute webapp-production --remote --file=seed_product_form_fields.sql
```

## 今後の拡張案

### 1. フィールドグループ化

フォーム項目をセクションごとにグループ化する機能:
```sql
ALTER TABLE product_form_fields ADD COLUMN group_name TEXT;
ALTER TABLE product_form_fields ADD COLUMN group_order INTEGER DEFAULT 0;
```

### 2. 多言語対応

field_labelやdescriptionを多言語対応する:
```sql
CREATE TABLE product_form_field_i18n (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  field_id INTEGER NOT NULL,
  locale TEXT NOT NULL,
  field_label TEXT NOT NULL,
  description TEXT,
  help_text TEXT
);
```

### 3. 論理削除対応

```sql
ALTER TABLE product_form_fields ADD COLUMN deleted_at TEXT;
CREATE INDEX idx_product_form_fields_deleted ON product_form_fields(deleted_at);
```

---

**最終更新日**: 2026-01-26  
**バージョン**: 1.0.0  
**管理者**: システム管理者
