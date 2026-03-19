# カスタムフィールド機能実装レポート

## 📋 実装日時
- **日付**: 2026-02-24
- **コミットハッシュ**: a22263c
- **デプロイURL**: https://8c279ba2.webapp-geh.pages.dev

---

## 🎯 実装内容

### 概要
参加者情報入力画面にフォーム設定のカスタムフィールドを追加しました。

### 要件
1. **区分=1（商品）**: 同意事項欄の上に商品ごとのカスタムフィールドを表示
2. **区分=2（参加者毎）**: 参加者情報設定の入力欄に参加者ごとに表示
3. **親子関係**: 親フィールドの選択値に応じて子フィールドを動的に表示/非表示
4. **データ保存**:
   - 区分=1: `bookings` テーブルの `custom_fields` カラム（JSON形式）
   - 区分=2: `booking_items` の `participants` カラム（JSON）内の `custom_fields`

---

## 🔧 修正内容

### 1️⃣ データベース修正

#### マイグレーションファイル作成
**ファイル**: `migrations/0028_add_custom_fields_to_bookings.sql`

```sql
-- マイグレーション: bookings テーブルに custom_fields カラムを追加
-- 区分=1（商品）のカスタムフィールドを保存するためのカラム
-- JSON形式でフィールド名と値を保存
-- 例: {"meal": "和食", "request": "アレルギーなし"}

ALTER TABLE bookings ADD COLUMN custom_fields TEXT;
```

#### データ構造
- **区分=1（商品）**: `bookings.custom_fields` に保存
  ```json
  {
    "meal": "和食",
    "meal_2": "洋食",
    "request": "アレルギー対応お願いします"
  }
  ```

- **区分=2（参加者毎）**: `booking_items.participants` 内の `custom_fields` に保存
  ```json
  [
    {
      "lastname": "山田",
      "firstname": "太郎",
      "custom_fields": {
        "meal": "和食",
        "request": "アレルギーなし"
      }
    }
  ]
  ```

---

### 2️⃣ バックエンド修正

#### ファイル: `src/index.tsx`

**修正箇所**: 予約作成API (`POST /api/v2/bookings`)

**変更内容**:
1. 商品全体のカスタムフィールド（category=1）を収集
2. `bookings` テーブルに `custom_fields` カラムを追加して保存
3. 複数商品のフィールドをマージして1つのJSONオブジェクトにする

**コード変更**:
```typescript
// 3. 商品全体のカスタムフィールド（category=1）を収集
const allProductCustomFields = {}
for (const item of items) {
  if (item.product_custom_fields) {
    // 商品ごとのフィールドをマージ（フィールド名が重複する場合は上書き）
    Object.assign(allProductCustomFields, item.product_custom_fields)
  }
}

// 3.5. 予約グループを作成（custom_fields を含む）
const bookingResult = await DB.prepare(`
  INSERT INTO bookings (
    booking_number, member_id, event_id, booker_name, booker_email, booker_phone, custom_fields
  ) VALUES (?, ?, ?, ?, ?, ?, ?)
`).bind(
  bookingNumber,
  member_id,
  event_id,
  `${booker.family_name} ${booker.first_name}`,
  booker.email,
  booker.tel || '',
  Object.keys(allProductCustomFields).length > 0 ? JSON.stringify(allProductCustomFields) : null
).run()
```

**削除した処理**:
- `booking_item_custom_fields` テーブルへの保存処理を削除（不要になったため）

---

### 3️⃣ フロントエンド

#### ファイル: `public/participant-info.html`

**既存実装の確認**:
- ✅ **区分=1（商品）**: 569-663行目に既に実装済み
- ✅ **区分=2（参加者毎）**: 472-564行目に既に実装済み
- ✅ **親子フィールド**: 1002-1051行目に条件分岐処理が実装済み
- ✅ **バリデーション**: 1132-1169行目に必須チェックが実装済み

**データ送信**:
```javascript
// 商品全体カスタムフィールド（category=1）を items に追加
const updatedItems = this.bookingDraft.items.map(item => {
  if (item.type === 'product' && this.productFieldAnswers[item.id]) {
    return {
      ...item,
      product_custom_fields: this.productFieldAnswers[item.id]
    };
  }
  return item;
});
```

---

## ✅ 実装結果

### マイグレーション実行結果
```bash
✅ 本番データベースにマイグレーション適用完了
Migration: 0028_add_custom_fields_to_bookings.sql
Status: ✅ Success
```

### デプロイ結果
```
✨ Deployment complete!
URL: https://8c279ba2.webapp-geh.pages.dev
Production URL: https://webapp-geh.pages.dev
```

### GitHubプッシュ結果
```
✅ Commit: a22263c
✅ Push: main branch
Repository: https://github.com/maikeura/keiokanko_event_html
```

---

## 📊 動作フロー

### 区分=1（商品）の場合

```
1. 参加者情報入力画面
   ↓
2. 商品ごとのカスタムフィールドセクション表示
   - 商品名の下にフィールドが表示される
   - 親フィールドの選択値に応じて子フィールドが動的に表示
   ↓
3. 予約確定ボタン押下
   ↓
4. バックエンドAPI: POST /api/v2/bookings
   - 全商品のカスタムフィールドをマージ
   - bookings.custom_fields に JSON 形式で保存
   ↓
5. 予約完了
```

### 区分=2（参加者毎）の場合

```
1. 参加者情報入力画面
   ↓
2. 参加者ごとのカスタムフィールド表示
   - 基本情報（氏名・住所等）の下にフィールドが表示される
   - 親フィールドの選択値に応じて子フィールドが動的に表示
   ↓
3. 予約確定ボタン押下
   ↓
4. バックエンドAPI: POST /api/v2/bookings
   - 参加者ごとの custom_fields を保存
   - booking_items.participants の JSON 内に保存
   ↓
5. 予約完了
```

---

## 🔍 親子フィールドの動作

### 仕組み
```javascript
// 親フィールドの値が条件と一致する場合のみ子フィールドを表示
shouldShowCustomField(participant, field) {
  if (field.parent_field_id && field.parent_condition) {
    const parentField = this.getParticipantCustomFields(participant.item_id)
      .find(f => f.id === field.parent_field_id);
    
    if (parentField) {
      const parentValue = participant.custom_fields[parentField.field_name];
      return parentValue === field.parent_condition;
    }
    return false;
  }
  return true;
}
```

### 例
- **親フィールド**: 「食事」（select）
  - オプション: 和食, 洋食, ベジタリアン
- **子フィールド**: 「和食の詳細」（text）
  - 表示条件: parent_condition = "和食"
  - 親で「和食」が選択された場合のみ表示

---

## 🛡️ バリデーション

### 必須フィールドチェック
```javascript
// 区分=1（商品）
for (const product of uniqueProducts) {
  const productFields = this.getProductCustomFields(product.id);
  for (const field of productFields) {
    if (!this.shouldShowProductCustomField(product.id, field)) continue;
    
    if (field.is_required) {
      const value = this.productFieldAnswers[product.id][field.field_name];
      if (!value || (Array.isArray(value) && value.length === 0)) {
        this.errorMessage = `「${product.name}」の「${field.field_label}」を入力してください`;
        return false;
      }
    }
  }
}

// 区分=2（参加者毎）
for (const field of participantFields) {
  if (!this.shouldShowCustomField(p, field)) continue;
  
  if (field.is_required) {
    const value = p.custom_fields[field.field_name];
    if (!value || (Array.isArray(value) && value.length === 0)) {
      this.errorMessage = `参加者${i + 1}の「${field.field_label}」を入力してください`;
      return false;
    }
  }
}
```

---

## 📝 テストシナリオ

### ✅ 区分=1（商品）のテスト

1. **フォーム設定で商品にカスタムフィールド追加**
   - category = 1（商品）
   - フィールド: meal（食事）, request（要望）

2. **参加者情報入力画面**
   - 同意事項欄の上に「商品名 - 追加情報」セクションが表示される
   - カスタムフィールドが表示される

3. **予約確定**
   - データが `bookings.custom_fields` に保存される
   - JSON形式: `{"meal": "和食", "request": "アレルギー対応"}`

### ✅ 区分=2（参加者毎）のテスト

1. **フォーム設定で商品にカスタムフィールド追加**
   - category = 2（参加者毎）
   - フィールド: meal（食事）, allergy（アレルギー）

2. **参加者情報入力画面**
   - 各参加者の基本情報の下にカスタムフィールドが表示される

3. **予約確定**
   - データが `booking_items.participants` の JSON 内に保存される
   - 各参加者ごとに `custom_fields` が保存される

### ✅ 親子フィールドのテスト

1. **親フィールド（select）と子フィールド（text）を作成**
   - 親: meal（食事）→ 和食, 洋食
   - 子: meal_detail（詳細）→ parent_condition = "和食"

2. **参加者情報入力画面**
   - 初期状態: 子フィールドは非表示
   - 親で「和食」選択 → 子フィールドが表示される
   - 親で「洋食」選択 → 子フィールドが非表示になる

3. **バリデーション**
   - 子フィールドが表示されている場合、必須チェックが働く
   - 子フィールドが非表示の場合、必須チェックはスキップされる

---

## 🚀 本番環境確認

### URL
- **本番**: https://webapp-geh.pages.dev
- **最新デプロイ**: https://8c279ba2.webapp-geh.pages.dev

### 確認手順
1. 管理画面でフォーム設定を追加
2. 商品詳細ページで予約を開始
3. 参加者情報入力画面でカスタムフィールドが表示されることを確認
4. 予約確定
5. 管理画面で予約詳細を確認し、カスタムフィールドが保存されていることを確認

---

## 📚 関連ファイル

### 修正ファイル
- `migrations/0028_add_custom_fields_to_bookings.sql` - マイグレーションファイル
- `src/index.tsx` - バックエンドAPI修正

### 確認済みファイル（修正不要）
- `public/participant-info.html` - フロントエンド（既に実装済み）

### ドキュメント
- `docs/custom_fields_implementation.md` - このドキュメント

---

## ⚠️ 注意事項

### データベース構造の変更
- `bookings` テーブルに `custom_fields` カラムが追加されました
- 既存の予約データには影響ありません（NULL 値）

### 互換性
- 既存のフォーム設定は引き続き動作します
- カスタムフィールドがない商品の場合、`custom_fields` は NULL または空のオブジェクトとして保存されます

### フィールド名の重複
- 複数の商品で同じフィールド名を使用した場合、後の商品の値で上書きされます
- フィールド名はユニークにすることを推奨します

---

## 🎉 完了

すべての実装とデプロイが完了しました！

- ✅ データベースマイグレーション完了
- ✅ バックエンドAPI修正完了
- ✅ フロントエンド確認完了（既存実装）
- ✅ 本番環境デプロイ完了
- ✅ GitHubプッシュ完了

**デプロイURL**: https://8c279ba2.webapp-geh.pages.dev  
**GitHubコミット**: a22263c
