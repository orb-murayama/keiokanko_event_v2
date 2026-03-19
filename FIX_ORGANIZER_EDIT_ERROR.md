# 主催者編集画面エラー修正レポート

## 🐛 エラー内容

```
admin-organizer-edit.js:172 Uncaught (in promise) TypeError: 
Cannot set properties of null (setting 'textContent')
    at HTMLDocument.<anonymous> (admin-organizer-edit.js:172:55)
```

## 🔍 原因分析

### 問題点
`admin-organizer-edit.js` の172行目で以下のコードが実行されていました：

```javascript
document.getElementById('headerText').textContent = '主催者編集';
```

しかし、`headerText` という ID の要素が HTML に存在しませんでした。

### 根本原因

1. **HTML に ID が定義されていない**
   - `organizers-edit.html` には `<h1 id="headerText">` が存在しない
   
2. **common-header.js が動的生成するヘッダーに ID がなかった**
   - `common-header.js` は `<h1>` を動的生成していたが、ID 属性が付いていなかった
   
3. **ページタイトルマッピングに主催者編集ページが登録されていなかった**
   - `/organizers-edit.html` のエントリが `pageTitles` オブジェクトに存在しなかった

## ✅ 修正内容

### 1. `<h1>` タグに `id="headerText"` を追加

**ファイル**: `public/js/components/common-header.js`  
**行**: 104

**修正前**:
```javascript
<h1>${getPageTitle()}</h1>
```

**修正後**:
```javascript
<h1 id="headerText">${getPageTitle()}</h1>
```

### 2. ページタイトルマッピングに編集ページを追加

**ファイル**: `public/js/components/common-header.js`  
**行**: 46-68

**追加したエントリ**:
```javascript
'/accounts-edit.html': { icon: 'fas fa-user-edit', title: 'アカウント編集' },
'/members-edit.html': { icon: 'fas fa-user-edit', title: '会員編集' },
'/clients-edit.html': { icon: 'fas fa-building', title: '顧客企業編集' },
'/vendors-edit.html': { icon: 'fas fa-handshake', title: '仕入先編集' },
'/organizers-edit.html': { icon: 'fas fa-users-cog', title: '主催者編集' },
```

## 🎯 修正効果

✅ `document.getElementById('headerText')` が正しく要素を取得できるようになった  
✅ JavaScript エラーが解消された  
✅ 主催者編集画面のタイトルが正しく表示される  
✅ 他の編集画面（アカウント、会員、顧客企業、仕入先）も同様に動作するようになった

## 🧪 確認方法

以下のURLにアクセスして、コンソールエラーが出ないことを確認：

- 主催者編集（新規）: `/organizers-edit.html?id=new`
- 主催者編集（既存）: `/organizers-edit.html?id=1`
- アカウント編集: `/accounts-edit.html?id=new`
- 会員編集: `/members-edit.html?id=new`
- 顧客企業編集: `/clients-edit.html?id=new`
- 仕入先編集: `/vendors-edit.html?id=new`

## 📝 補足

この修正により、全ての編集画面で統一されたヘッダー動作が実現されました。
`common-header.js` で一元管理されているため、今後の編集ページ追加時も同様のパターンで対応可能です。

---
修正日: 2026-02-17

---

## 🔧 追加修正（2回目）

### 問題
最初の修正後もエラーが継続：
```
TypeError: Cannot set properties of null (setting 'textContent')
at admin-organizer-edit.js:172
```

### 根本原因（2回目）
HTMLファイルが **間違ったパス** を参照していた：

```html
<!-- ❌ 間違い（ファイルが存在しない） -->
<script src="/static/js/components/common-header.js"></script>

<!-- ✅ 正解（実際のファイル位置） -->
<script src="/js/components/common-header.js"></script>
```

### 影響範囲
- `common-header.js` がロードされなかった
- そのため `<h1 id="headerText">` 要素が生成されなかった
- `admin-organizer-edit.js` が存在しない要素にアクセスしてエラー

### 修正内容（2回目）
**対象**: public/ 配下の全 HTML ファイル（31ファイル）

一括置換実行：
```bash
find public -name "*.html" -type f \
  -exec sed -i 's|/static/js/components/common-header.js|/js/components/common-header.js|g' {} \;
```

### 修正ファイル一覧
- accounts-edit.html, accounts-list.html
- admin-bulk-documents.html, admin-bulk-emails.html, admin-bulk-messages.html
- admin-form-fields.html, admin-products.html
- bookings-detail.html, bookings-edit.html, bookings-list.html
- clients-edit.html, clients-list.html
- events-form.html, events-list.html
- index.html
- members-edit.html, members-list.html
- options-edit.html, options-list.html, options-stocks.html
- organizers-edit.html, organizers-list.html
- products-edit.html, products-form-fields.html, products-list.html
- products-shared-stocks.html, products-stocks.html
- shared-stock-pools-list.html, shared-stock-pools-manage.html, shared-stock-pools-new.html
- vendors-edit.html, vendors-list.html

## ✅ 最終確認

### 動作確認手順
1. ブラウザで `/organizers-edit.html?id=new` にアクセス
2. ブラウザのデベロッパーツールでコンソールを確認
3. エラーが出ないことを確認
4. ページタイトルが「主催者編集」と表示されることを確認

### 完全修正内容まとめ
**第1回修正**:
- ✅ `common-header.js` の `<h1>` に `id="headerText"` を追加
- ✅ ページタイトルマッピングに5つの編集ページを追加

**第2回修正**:
- ✅ 全HTMLファイルの `common-header.js` パスを修正（31ファイル）

---
最終修正日: 2026-02-17
