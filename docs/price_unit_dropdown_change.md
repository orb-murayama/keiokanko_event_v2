# 料金単位プルダウンの変更

## 📅 実施日時
2026-02-24

## 🎯 変更内容

商品管理画面の「単位」フィールドを、テキスト入力からプルダウン選択に変更しました。

---

## 📋 プルダウン選択肢（13項目）

1. **名**
2. **枚**
3. **個**
4. **回**
5. **組**
6. **グループ**
7. **泊**
8. **時間**
9. **日**
10. **席**
11. **台**
12. **セット**
13. **食**

---

## 🔧 修正ファイル

### 1. フロントエンド（HTML）
**ファイル**: `/home/user/webapp/public/products-edit.html`

**変更前**:
```html
<input type="text" id="price_unit_common" name="price_unit" 
       class="form-control" placeholder="例：人、名、台、部屋" required>
```

**変更後**:
```html
<select id="price_unit_common" name="price_unit" class="form-control" required>
  <option value="">選択してください</option>
  <option value="名">名</option>
  <option value="枚">枚</option>
  <option value="個">個</option>
  <option value="回">回</option>
  <option value="組">組</option>
  <option value="グループ">グループ</option>
  <option value="泊">泊</option>
  <option value="時間">時間</option>
  <option value="日">日</option>
  <option value="席">席</option>
  <option value="台">台</option>
  <option value="セット">セット</option>
  <option value="食">食</option>
</select>
```

### 2. バックエンド（TypeScript）
**ファイル**: `/home/user/webapp/src/index.tsx`

**変更箇所**: デフォルト値を `'人'` から `'名'` に変更

**変更前**:
```typescript
data.price_unit || '人',
```

**変更後**:
```typescript
data.price_unit || '名',
```

**影響範囲**: 2箇所
- 商品作成API（POST `/api/products`）
- 商品更新API（PUT `/api/products/:id`）

### 3. フロントエンド（JavaScript）
**ファイル1**: `/home/user/webapp/public/static/product-form.js`

**変更箇所**: デフォルト値を `'人'` から `'名'` に変更（2箇所）

```javascript
// 商品データ読み込み時
document.querySelector('[name="price_unit"]').value = product.price_unit || '名';

// フォーム送信時
price_unit: formData.get('price_unit') || '名',
```

**ファイル2**: `/home/user/webapp/public/js/pages/admin-product-edit.js`

```javascript
setValue('price_unit', product.price_unit || '名');
```

---

## ✅ 動作確認

### 確認済み項目
- ✅ プルダウンが正しく表示される（13項目）
- ✅ デフォルト値が「名」に設定される
- ✅ 既存データは保持される（コピー機能も含む）
- ✅ ビルド成功
- ✅ サーバー起動成功

### テストURL
**商品編集画面**: https://3000-ib4b640jlamofc0mqgpvk-583b4d74.sandbox.novita.ai/admin/products/edit

---

## 📊 影響範囲

### 影響あり
- ✅ 商品作成画面（新規作成時）
- ✅ 商品編集画面（既存商品編集時）
- ✅ 商品コピー機能（単位もコピーされる）

### 影響なし
- ✅ 既存の商品データ（そのまま保持）
- ✅ 予約データ
- ✅ 価格データ

---

## 🗄️ データベース

### テーブル
`products` テーブルの `price_unit` カラム

### データ型
`TEXT`（変更なし）

### デフォルト値
新規作成時のデフォルトが `'人'` から `'名'` に変更

### 既存データ
- 既存の商品で `price_unit` が `'人'` のものはそのまま保持
- 編集時に新しいプルダウンから選択し直すことが可能

---

## 📝 使用方法

### 商品作成・編集時
1. 商品管理画面で「単位」フィールドを選択
2. プルダウンから適切な単位を選択（例：チケットなら「枚」、宿泊なら「泊」）
3. 保存

### 選択肢の追加が必要な場合
1. `/home/user/webapp/public/products-edit.html` を編集
2. `<select id="price_unit_common">` 内に `<option>` を追加
3. ビルド・デプロイ

---

## 🔄 今後の拡張

### 推奨事項
将来的に選択肢を追加する場合は、以下のファイルを修正してください：

1. **HTML**: `public/products-edit.html` の `<select id="price_unit_common">` セクション
2. **デフォルト値**: 必要に応じて `src/index.tsx` と JSファイルのデフォルト値を変更

---

作成日: 2026-02-24  
状態: ✅ 完了
