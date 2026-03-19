# フォーム設定機能 (event_form_fields) 仕様書

## 概要

イベント予約フォームに動的にカスタムフィールドを追加・編集・削除できる機能です。
イベントごとに異なる入力項目を柔軟に設定できます。

---

## テーブル構造

### event_form_fields テーブル

| カラム名 | データ型 | NULL | デフォルト | 説明 |
|---------|---------|------|-----------|------|
| id | INTEGER | NOT NULL | AUTO_INCREMENT | フォームフィールドID（主キー） |
| event_id | INTEGER | NOT NULL | - | イベントID（外部キー：events.id） |
| field_type | TEXT | NOT NULL | - | フィールドタイプ |
| field_name | TEXT | NOT NULL | - | フィールド名（英数字とアンダースコア） |
| field_label | TEXT | NOT NULL | - | フィールドラベル（日本語表示名） |
| field_options | TEXT | NULL | null | 選択肢（JSON形式） |
| is_required | INTEGER | NOT NULL | 0 | 必須フラグ（1:必須/0:任意） |
| description | TEXT | NULL | null | 説明文・ヘルプテキスト |
| display_order | INTEGER | NOT NULL | 0 | 表示順序（昇順） |
| placeholder | TEXT | NULL | null | プレースホルダー |
| parent_field_id | INTEGER | NULL | null | 親フィールドID（条件付き表示用） |
| parent_condition | TEXT | NULL | null | 表示条件（親フィールドの値） |
| indent_level | INTEGER | NOT NULL | 0 | インデントレベル（0:通常、1以上:階層） |
| created_at | TEXT | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| modified_at | TEXT | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

---

## フィールドタイプ

### サポートするフィールドタイプ

| タイプ | 説明 | field_options | 用途例 |
|-------|------|---------------|--------|
| text | 1行テキスト入力 | 不要 | 会社名、部署名、役職 |
| textarea | 複数行テキスト入力 | 不要 | 特記事項、要望事項 |
| select | プルダウン選択 | 必要 | 食事タイプ、部屋タイプ |
| radio | ラジオボタン（単一選択） | 必要 | 性別、参加/不参加 |
| checkbox | チェックボックス（複数選択） | 必要 | 参加理由、興味のある分野 |
| date | 日付入力 | 不要 | 生年月日、希望日 |
| email | メールアドレス入力 | 不要 | 予備メールアドレス |
| tel | 電話番号入力 | 不要 | 緊急連絡先 |
| number | 数値入力 | 不要 | 年齢、参加人数 |
| file | ファイルアップロード | 不要 | 身分証明書、名刺 |

### field_options の形式

**JSON配列形式（推奨）:**
```json
["選択肢1", "選択肢2", "選択肢3"]
```

**例:**
```json
["和食", "洋食", "中華", "ベジタリアン"]
["あり", "なし"]
["男性", "女性", "その他"]
```

---

## 条件付き表示機能

### 概要

特定のフィールドの値に応じて、他のフィールドを動的に表示/非表示にする機能です。

### 設定方法

1. **親フィールド**を先に作成
2. **子フィールド**に以下を設定：
   - `parent_field_id`: 親フィールドのID
   - `parent_condition`: 親フィールドのどの値の時に表示するか
   - `indent_level`: 階層表示のためのインデント（通常は1）

### 例: アレルギー詳細の条件付き表示

```sql
-- 親フィールド: アレルギーの有無（ラジオボタン）
INSERT INTO event_form_fields (
  event_id, field_type, field_name, field_label, field_options, is_required, display_order
) VALUES (
  1, 'radio', 'has_allergy', 'アレルギーの有無', '["なし", "あり"]', 1, 70
);

-- 子フィールド: アレルギー詳細（"あり"を選択した場合のみ表示）
INSERT INTO event_form_fields (
  event_id, field_type, field_name, field_label, is_required, display_order,
  parent_field_id, parent_condition, indent_level
) VALUES (
  1, 'textarea', 'allergy_details', 'アレルギー詳細', 1, 71,
  7, 'あり', 1
);
```

### 注意事項

- 条件付き表示は最大2階層まで推奨（UXの観点）
- 循環参照に注意（A→B→A のような設定は不可）
- parent_condition は親フィールドの選択肢と完全一致する必要がある

---

## 表示順序の管理

### display_order の使い方

- 昇順で表示される（小さい数字が先）
- 連番でなくても良い
- 10, 20, 30... のように間隔を空けると後で挿入しやすい

### 例: 途中に項目を追加

```sql
-- 既存の項目: 10, 20, 30, 40...
-- 20と30の間に追加したい場合 → display_order = 25 とする

INSERT INTO event_form_fields (
  event_id, field_type, field_name, field_label, display_order
) VALUES (
  1, 'text', 'new_field', '新しいフィールド', 25
);
```

---

## API設計例

### フォームフィールド一覧取得

**エンドポイント:** `GET /api/events/:event_id/form-fields`

**レスポンス例:**
```json
{
  "fields": [
    {
      "id": 1,
      "field_type": "text",
      "field_name": "company_name",
      "field_label": "会社名",
      "is_required": 1,
      "placeholder": "例: 株式会社〇〇",
      "description": "所属されている会社名を入力してください",
      "display_order": 10
    },
    {
      "id": 7,
      "field_type": "radio",
      "field_name": "has_allergy",
      "field_label": "アレルギーの有無",
      "field_options": ["なし", "あり"],
      "is_required": 1,
      "display_order": 70
    },
    {
      "id": 8,
      "field_type": "textarea",
      "field_name": "allergy_details",
      "field_label": "アレルギー詳細",
      "is_required": 1,
      "parent_field_id": 7,
      "parent_condition": "あり",
      "indent_level": 1,
      "display_order": 71
    }
  ]
}
```

### フォームフィールド作成

**エンドポイント:** `POST /api/events/:event_id/form-fields`

**リクエストボディ例:**
```json
{
  "field_type": "select",
  "field_name": "meal_type",
  "field_label": "食事タイプ",
  "field_options": ["和食", "洋食", "中華"],
  "is_required": 1,
  "display_order": 60,
  "description": "お好みの食事タイプをお選びください"
}
```

### フォームフィールド更新

**エンドポイント:** `PUT /api/events/:event_id/form-fields/:id`

### フォームフィールド削除

**エンドポイント:** `DELETE /api/events/:event_id/form-fields/:id`

---

## フロントエンド実装例

### 条件付き表示の制御（JavaScript）

```javascript
// 親フィールドの変更を監視
document.getElementById('has_allergy').addEventListener('change', (e) => {
  const allergyDetails = document.getElementById('allergy_details_wrapper');
  
  if (e.target.value === 'あり') {
    allergyDetails.style.display = 'block'; // 表示
  } else {
    allergyDetails.style.display = 'none'; // 非表示
  }
});
```

### フィールドの動的レンダリング

```javascript
function renderFormField(field) {
  let html = '';
  
  // インデントレベルに応じてスタイル調整
  const indent = field.indent_level > 0 ? `style="margin-left: ${field.indent_level * 20}px"` : '';
  
  // 条件付き表示の場合
  const display = field.parent_field_id ? 'style="display: none"' : '';
  
  html += `<div class="form-group" id="${field.field_name}_wrapper" ${indent} ${display}>`;
  html += `<label class="form-label">`;
  if (field.is_required) {
    html += `<span class="text-danger">*</span> `;
  }
  html += `${field.field_label}</label>`;
  
  // フィールドタイプに応じた入力欄
  switch (field.field_type) {
    case 'text':
    case 'email':
    case 'tel':
      html += `<input type="${field.field_type}" name="${field.field_name}" 
               class="form-control" placeholder="${field.placeholder || ''}" 
               ${field.is_required ? 'required' : ''}>`;
      break;
    
    case 'textarea':
      html += `<textarea name="${field.field_name}" class="form-control" 
               rows="3" placeholder="${field.placeholder || ''}" 
               ${field.is_required ? 'required' : ''}></textarea>`;
      break;
    
    case 'select':
      html += `<select name="${field.field_name}" class="form-control" 
               ${field.is_required ? 'required' : ''}>`;
      html += `<option value="">選択してください</option>`;
      JSON.parse(field.field_options).forEach(option => {
        html += `<option value="${option}">${option}</option>`;
      });
      html += `</select>`;
      break;
    
    case 'radio':
      JSON.parse(field.field_options).forEach((option, index) => {
        html += `<label class="radio-label">
                   <input type="radio" name="${field.field_name}" 
                   value="${option}" ${field.is_required ? 'required' : ''}>
                   ${option}
                 </label>`;
      });
      break;
    
    case 'checkbox':
      JSON.parse(field.field_options).forEach(option => {
        html += `<label class="checkbox-label">
                   <input type="checkbox" name="${field.field_name}" value="${option}">
                   ${option}
                 </label>`;
      });
      break;
  }
  
  // 説明文
  if (field.description) {
    html += `<small class="form-hint">${field.description}</small>`;
  }
  
  html += `</div>`;
  
  return html;
}
```

---

## バリデーション

### サーバーサイド

```javascript
function validateFormField(field, value) {
  // 必須チェック
  if (field.is_required && !value) {
    return { valid: false, message: `${field.field_label}は必須です` };
  }
  
  // タイプ別バリデーション
  switch (field.field_type) {
    case 'email':
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (value && !emailRegex.test(value)) {
        return { valid: false, message: `${field.field_label}の形式が正しくありません` };
      }
      break;
    
    case 'tel':
      const telRegex = /^[0-9-]+$/;
      if (value && !telRegex.test(value)) {
        return { valid: false, message: `${field.field_label}は数字とハイフンのみ入力可能です` };
      }
      break;
    
    case 'number':
      if (value && isNaN(value)) {
        return { valid: false, message: `${field.field_label}は数値を入力してください` };
      }
      break;
  }
  
  return { valid: true };
}
```

---

## まとめ

このフォーム設定機能により、以下が実現できます：

1. ✅ イベントごとに異なる入力項目を動的に設定
2. ✅ 10種類のフィールドタイプをサポート
3. ✅ 条件付き表示による動的なフォーム制御
4. ✅ 必須/任意、説明文、プレースホルダーの柔軟な設定
5. ✅ 表示順序の簡単な管理
6. ✅ 階層表示によるわかりやすいUI

---

## 関連ファイル

- **DDL**: `ddl/event_form_fields.sql`
- **サンプルデータ**: `seed_event_form_fields.sql`
- **API実装**: `src/index.tsx` (APIエンドポイント)
- **フロントエンド**: `public/event-form.html` (フォーム画面)
