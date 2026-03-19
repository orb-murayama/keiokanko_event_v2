# Excel仕様書 更新ガイド v2.1.0

## 📋 更新対象ファイル

1. **database_definition.xlsx** (データベース定義書)
2. **api_specification_admin.xlsx** (API仕様書)

---

## 1️⃣ database_definition.xlsx の更新内容

### テーブル一覧シート
- テーブル数を更新: **24テーブル** → **25テーブル** (product_form_fields追加、event_form_fields削除で変更なし)

### productsテーブル
新しいカラムを追加：

| カラム名 | 型 | NULL | デフォルト値 | 説明 |
|---------|-----|------|------------|------|
| form_field_settings | TEXT | YES | `{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}` | 入力フォーム項目設定（JSON形式）<br>- name_kanji: 氏名（漢字）<br>- name_kana: 氏名（カナ）<br>- name_roma: 氏名（ローマ字）<br>- address: 住所<br>- tel: 電話番号<br>- birth_date: 生年月日<br>- age: 年齢 |

**配置位置**: `image_url`カラムの後に追加

### product_form_fieldsテーブル（新規追加）

| カラム名 | 型 | NULL | デフォルト値 | キー | 説明 |
|---------|-----|------|------------|------|------|
| id | INTEGER | NO | - | PRIMARY KEY, AUTOINCREMENT | フォームフィールドID |
| product_id | INTEGER | NO | - | FOREIGN KEY → products(id) | 商品ID |
| field_type | TEXT | NO | - | - | フィールドタイプ（text, textarea, select, radio, checkbox, date, file） |
| field_name | TEXT | NO | - | - | フィールド名（システム内部用） |
| field_label | TEXT | NO | - | - | フィールドラベル（表示用） |
| field_options | TEXT | YES | NULL | - | 選択肢（JSON形式、select/radio/checkbox用） |
| is_required | INTEGER | NO | 0 | - | 必須フラグ（0:任意, 1:必須） |
| description | TEXT | YES | NULL | - | 説明文・ヘルプテキスト |
| display_order | INTEGER | NO | 0 | - | 表示順序 |
| placeholder | TEXT | YES | NULL | - | プレースホルダーテキスト |
| parent_field_id | INTEGER | YES | NULL | - | 親フィールドID（条件分岐用） |
| parent_condition | TEXT | YES | NULL | - | 親フィールドの条件（JSON形式） |
| indent_level | INTEGER | NO | 0 | - | インデントレベル（0～） |
| created_at | TEXT | NO | datetime('now', 'localtime') | - | 作成日時 |
| modified_at | TEXT | NO | datetime('now', 'localtime') | - | 更新日時 |

**説明**: 商品別のカスタムフォーム項目を管理するテーブル。動的フォームフィールドの定義に使用。

### booking_form_responsesテーブル
新しいカラムを追加：

| カラム名 | 型 | NULL | デフォルト値 | キー | 説明 |
|---------|-----|------|------------|------|------|
| product_id | INTEGER | YES | NULL | FOREIGN KEY → products(id) | 商品ID（予約時の商品別フォーム回答） |

**配置位置**: `event_id`カラムの後に追加

### eventsテーブル
既存のカラムに備考を追加：

| カラム名 | 備考更新 |
|---------|---------|
| form_field_settings | ⚠️ **非推奨** - v2.1.0で商品管理に移動。既存データは保持するが使用しない。 |

### ❌ event_form_fieldsテーブル（削除）
このテーブルは廃止されました。product_form_fieldsに置き換えられました。

**削除理由**: 予約フォームの項目設定を商品単位で管理する要件変更のため

---

## 2️⃣ api_specification_admin.xlsx の更新内容

### 目次シート
- 商品管理のAPI数を更新: **15個** → **17個** (+2)
- イベント管理のAPI数を更新: **16個** → **14個** (-2)

### API一覧シート

#### ❌ 削除するAPI（2個）
| メソッド | エンドポイント | カテゴリ | 備考 |
|---------|---------------|---------|------|
| GET | /api/events/{id}/form-fields | イベント管理 | 廃止 - 商品管理に移動 |
| POST | /api/events/{id}/form-fields | イベント管理 | 廃止 - 商品管理に移動 |

#### ✅ 追加するAPI（2個）
| メソッド | エンドポイント | カテゴリ | 説明 |
|---------|---------------|---------|------|
| GET | /api/products/{id}/form-fields | 商品管理 | 商品フォーム項目取得 |
| POST | /api/products/{id}/form-fields | 商品管理 | 商品フォーム項目登録 |

### 商品管理シート

#### 既存APIの更新

**POST /api/products - 商品新規登録**
- リクエストボディに追加:
  ```json
  {
    "form_field_settings": "{\"name_kanji\":true,\"name_kana\":true,\"name_roma\":false,\"address\":true,\"tel\":true,\"birth_date\":false,\"age\":false}"
  }
  ```
- 説明: 入力フォーム項目設定（JSON文字列）。7つの項目を管理。

**PUT /api/products/{id} - 商品更新**
- リクエストボディに追加:
  ```json
  {
    "form_field_settings": "{\"name_kanji\":true,\"name_kana\":true,\"name_roma\":false,\"address\":true,\"tel\":true,\"birth_date\":false,\"age\":false}"
  }
  ```

**GET /api/products/{id} - 商品詳細取得**
- レスポンスボディに追加:
  ```json
  {
    "product": {
      "form_field_settings": "{\"name_kanji\":true,\"name_kana\":true,\"name_roma\":false,\"address\":true,\"tel\":true,\"birth_date\":false,\"age\":false}"
    }
  }
  ```

**POST /api/products/{id}/copy - 商品コピー**
- 動作説明に追加: form_field_settingsもコピーされる

#### 新規API詳細

**GET /api/products/{id}/form-fields**
- **説明**: 指定商品のカスタムフォーム項目を取得
- **認証**: Cookie (session)
- **パラメータ**:
  - `id` (path, integer, required) - 商品ID
- **レスポンス (200)**:
  ```json
  {
    "fields": [
      {
        "id": 1,
        "product_id": 1,
        "field_type": "text",
        "field_name": "company_name",
        "field_label": "会社名",
        "field_options": null,
        "is_required": 1,
        "description": "所属する会社名を入力してください",
        "display_order": 1,
        "placeholder": "例: 株式会社サンプル",
        "parent_field_id": null,
        "parent_condition": null,
        "indent_level": 0
      }
    ]
  }
  ```
- **エラー**: 400, 401, 404, 500

**POST /api/products/{id}/form-fields**
- **説明**: 指定商品のカスタムフォーム項目を登録・更新
- **認証**: Cookie (session)
- **パラメータ**:
  - `id` (path, integer, required) - 商品ID
- **リクエストボディ**:
  ```json
  {
    "fields": [
      {
        "field_type": "text",
        "field_name": "company_name",
        "field_label": "会社名",
        "field_options": null,
        "is_required": 1,
        "description": "所属する会社名を入力してください",
        "display_order": 1,
        "placeholder": "例: 株式会社サンプル",
        "parent_field_id": null,
        "parent_condition": null,
        "indent_level": 0
      }
    ]
  }
  ```
- **レスポンス (200)**:
  ```json
  {
    "success": true,
    "message": "フォームフィールドを保存しました"
  }
  ```
- **エラー**: 400, 401, 404, 500

### 画面別API使用状況シート

#### イベント一覧/編集
- API数を更新: **16個** → **14個** (-2)
- 削除API:
  - GET /api/events/{id}/form-fields
  - POST /api/events/{id}/form-fields

#### 商品一覧/編集
- API数を更新: **17個** → **19個** (+2)
- 追加API:
  - GET /api/products/{id}/form-fields
  - POST /api/products/{id}/form-fields

---

## 📝 更新手順

### database_definition.xlsx
1. Excelファイルを開く
2. 「products」シートを開く
3. 最後のカラム（image_url）の後に新しい行を追加
4. 上記の`form_field_settings`カラム情報を入力
5. 新しいシート「product_form_fields」を作成
6. 上記のテーブル定義を入力
7. 「booking_form_responses」シートを開く
8. `event_id`カラムの後に`product_id`カラムを追加
9. 「events」シートを開く
10. `form_field_settings`カラムの備考欄に非推奨の注記を追加
11. 「event_form_fields」シートを削除または非推奨マークを付ける
12. 保存

### api_specification_admin.xlsx
1. Excelファイルを開く
2. 「目次」シートを開く
3. 商品管理のAPI数を15→17に更新
4. イベント管理のAPI数を16→14に更新
5. 「API一覧」シートを開く
6. イベント管理の2つのフォームAPIを削除
7. 商品管理に2つの新しいフォームAPIを追加
8. 「商品管理」シートを開く
9. 既存APIのリクエスト/レスポンスに`form_field_settings`を追加
10. 2つの新しいAPI（GET/POST form-fields）の詳細を追加
11. 「画面別API使用状況」シートを開く
12. イベント管理のAPI数を更新
13. 商品管理のAPI数を更新
14. 保存

---

## 🔗 関連ドキュメント

以下のマークダウンファイルは既に更新済みです：
- ✅ `API仕様書_README.md`
- ✅ `openapi_admin.yaml`
- ✅ `DATABASE_SCHEMA_OVERVIEW.md`
- ✅ `README.md`

---

**作成日**: 2026-01-23  
**バージョン**: v2.1.0  
**対応Excelファイル**: database_definition.xlsx, api_specification_admin.xlsx
