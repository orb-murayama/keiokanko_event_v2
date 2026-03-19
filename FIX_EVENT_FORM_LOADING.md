# イベント編集画面「読み込み中」フリーズ問題の修正

## 🐛 問題の詳細

### 現象
- URL: `/events-form?id=4` でイベント編集画面を開く
- フォームの各項目にはデータがセットされている
- しかし画面上部の「読み込み中...」スピナーが消えない
- ローディング状態のまま固まっている

### 再現手順
1. イベント編集画面を開く（例: `/events-form?id=4`）
2. 画面上部に「読み込み中...」が表示される
3. フォームデータは正常に表示される
4. しかし「読み込み中...」が消えない

## 🔍 根本原因

### 非同期処理の実行順序問題

**問題のあった初期化フロー：**
```javascript
// DOMContentLoaded イベント内
renderForm();
setupFormEvents();          // ← ここで initializeStaffSelector() を呼ぶが await しない
await loadClients();
await loadOrganizers();
...
await loadEventData();      // ← この中で loadExistingStaff() を呼ぶ
  └─ await loadExistingStaff(eventId);
      └─ renderSelectedTags();  // ← allStaff がまだ空！
```

**setupFormEvents() 内：**
```javascript
function setupFormEvents() {
  // ...
  initializeStaffSelector();  // ← await されていない（非同期で実行開始）
}
```

**initializeStaffSelector() の処理：**
```javascript
async function initializeStaffSelector() {
  // 支店データ取得
  const branchResponse = await fetch('/api/branches?per_page=1000');
  
  // 担当者データ取得
  const staffResponse = await fetch('/api/accounts?role=branch&status=active');
  allStaff = await staffResponse.json();  // ← これが完了する前に...
}
```

**loadExistingStaff() の処理：**
```javascript
async function loadExistingStaff(eventId) {
  const response = await fetch(`/api/events/${eventId}/staff`);
  // ...
  renderSelectedTags();  // ← allStaff がまだ空なのでデータが見つからない
}
```

### タイミングの問題
1. `setupFormEvents()` が `initializeStaffSelector()` を**await せずに**呼び出す
2. `initializeStaffSelector()` がバックグラウンドで実行開始（非同期）
3. `loadEventData()` が呼ばれる
4. `loadExistingStaff()` が呼ばれる ← **この時点で `allStaff` がまだ空**
5. `renderSelectedTags()` が `allStaff.find()` を実行 ← **データが見つからない**
6. 何らかのエラーが発生し、**ローディング非表示処理が実行されない**

## ✅ 修正内容

### 1. DOMContentLoaded 内で `await initializeStaffSelector()` を追加

**修正前：**
```javascript
try {
  renderForm();
  setupFormEvents();
  
  await loadClients();
  await loadOrganizers();
  await loadVendors();
  await loadCategories();
  await loadBranches();
  await loadParentEvents();
  
  if (isEditMode) {
    await loadEventData();
  }
  
  document.getElementById('loading').style.display = 'none';
  document.getElementById('eventFormContainer').style.display = 'block';
}
```

**修正後：**
```javascript
try {
  renderForm();
  setupFormEvents();
  
  await loadClients();
  await loadOrganizers();
  await loadVendors();
  await loadCategories();
  await loadBranches();
  await loadParentEvents();
  
  // 担当者データを読み込み（編集モード用に先に読み込む必要がある）
  await initializeStaffSelector();  // ← 追加
  
  if (isEditMode) {
    await loadEventData();
  }
  
  document.getElementById('loading').style.display = 'none';
  document.getElementById('eventFormContainer').style.display = 'block';
}
```

### 2. setupFormEvents() から重複呼び出しを削除

**修正前：**
```javascript
function setupFormEvents() {
  // ...
  initializeStaffSelector();  // ← 削除
}
```

**修正後：**
```javascript
function setupFormEvents() {
  // ...
  // 担当者セレクターの初期化は DOMContentLoaded 内で await される
}
```

## 🎯 修正効果

### 正しい初期化フロー
```
1. renderForm()
2. setupFormEvents()
3. await loadClients()
4. await loadOrganizers()
5. await loadVendors()
6. await loadCategories()
7. await loadBranches()
8. await loadParentEvents()
9. await initializeStaffSelector()  ← allStaff を確実に読み込む
   ├─ 支店データ取得完了
   └─ 担当者データ取得完了（allStaff に格納）
10. await loadEventData()
    └─ await loadExistingStaff(eventId)
        └─ renderSelectedTags()  ← allStaff にデータが入っている！
11. ローディング非表示、フォーム表示  ← 確実に実行される
```

### 解決される問題
1. ✅ `allStaff` が確実に読み込まれてから `loadExistingStaff()` が実行される
2. ✅ `renderSelectedTags()` で既存担当者が正しく表示される
3. ✅ エラーが発生せず、ローディング非表示処理が確実に実行される
4. ✅ 画面が正常に表示され、ユーザー操作が可能になる

## 📝 技術的なポイント

### 非同期関数の await の重要性
- `initializeStaffSelector()` は `async function` なので、Promise を返す
- `await` せずに呼び出すと、処理が完了する前に次の処理が実行される
- データ依存関係がある場合、必ず `await` で待機する必要がある

### データ依存関係
```
initializeStaffSelector()
  └─ allStaff を読み込む
       ↓ (依存)
loadEventData()
  └─ loadExistingStaff()
      └─ renderSelectedTags()
          └─ allStaff を使用
```

## 🚀 デプロイ状態
- ✅ ローカル環境: 修正済み
- ⏳ 本番環境: 未デプロイ

## 🧪 テスト方法
1. ブラウザでハードリロード（Ctrl+Shift+R または Cmd+Shift+R）
2. イベント編集画面を開く: `/events-form?id=4`
3. 「読み込み中...」が表示される
4. 1〜2秒後、フォームが表示され、ローディングが消える
5. デベロッパーツールのコンソールで以下のログを確認：
   - `担当者データ読み込み: 2名`
   - `イベントデータ読み込み開始: 4`
   - `[loadExistingStaff] イベントID: 4 で担当者を取得します`
   - `初期化完了`

---
**更新日**: 2026-02-17  
**コミット**: 1e9f490  
**関連ファイル**: `public/js/pages/admin-event-form.js`

---

## 🐛 追加修正：CSS !important による非表示失敗

### 問題の詳細
初期化が正常に完了し、コンソールに「初期化完了」と表示されるにもかかわらず、画面上の「読み込み中...」スピナーが消えない。

### ログ出力
```
担当者データ読み込み: 2名
イベントデータ読み込み開始: 4
イベントデータ読み込み完了
初期化完了  ← ここまで実行されている
```

### 根本原因
`events-form.html` の`<style>`タグ内（90行目）で、以下のCSSが設定されていました：

```css
#loading {
  display: flex !important;  /* ← !important が設定されている */
  flex-direction: column !important;
  align-items: center !important;
  /* ... */
}
```

JavaScriptで以下のように設定しても、**`!important`が優先されて非表示にならない**：

```javascript
document.getElementById('loading').style.display = 'none';  // ← !important に負ける
```

### CSS詳細度と !important
- CSS の `!important` は通常のインラインスタイルよりも優先される
- JavaScriptで `element.style.display = 'none'` を設定しても上書きされない
- `!important` を上書きするには、`setProperty()` で `!important` を指定する必要がある

### 修正内容

**修正前（admin-event-form.js:48）:**
```javascript
// ローディングを非表示、フォームを表示
document.getElementById('loading').style.display = 'none';
document.getElementById('eventFormContainer').style.display = 'block';
```

**修正後:**
```javascript
// ローディングを非表示、フォームを表示
// CSSで !important が設定されているため、setProperty を使用
const loadingElement = document.getElementById('loading');
if (loadingElement) {
  loadingElement.style.setProperty('display', 'none', 'important');
}
document.getElementById('eventFormContainer').style.display = 'block';
```

### setProperty の使用方法
```javascript
element.style.setProperty(propertyName, value, priority)
```

- **propertyName**: CSSプロパティ名（例: `'display'`）
- **value**: 設定する値（例: `'none'`）
- **priority**: 優先度（`'important'` または空文字）

### 修正効果
1. ✅ JavaScriptでローディング要素が確実に非表示になる
2. ✅ `!important` が設定されたCSSを上書きできる
3. ✅ 画面に「読み込み中...」が残らなくなる
4. ✅ フォームが正しく表示される

### 代替案（今回は採用しなかった）
CSSから `!important` を削除する方法もありますが、以下の理由でJavaScript側を修正：

**CSSから削除する場合:**
```css
#loading {
  display: flex;  /* !important を削除 */
  /* ... */
}
```

**採用しなかった理由:**
- 他のCSSルールとの競合を防ぐために `!important` が意図的に設定されている可能性
- ローディング表示を強制的に優先したい設計思想
- HTML/CSSを変更せず、JavaScript側で対応する方が安全

---
**追加修正日**: 2026-02-17  
**コミット**: 32666e2  
**修正ファイル**: `public/js/pages/admin-event-form.js`
