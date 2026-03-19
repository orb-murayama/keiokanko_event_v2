# 既知の問題（Known Issues）

## 概要
このドキュメントは、現在確認されている既知の問題をトラッキングするためのものです。

---

## 🔴 優先度: 低 - addEventListener エラー（マイページ）

### 問題の詳細
- **発生場所**: `/mypage/bookings` ページ
- **エラーメッセージ**: `Uncaught TypeError: Cannot read properties of null (reading 'addEventListener')`
- **エラー箇所**: `src/index.tsx` 行7836
- **原因**: 存在しないログアウトボタン（`id="logoutBtn"`）に対して `addEventListener` を設定しようとしている

### 再現手順
1. マイページにログイン（OTP認証）
2. 予約一覧ページ（`/mypage/bookings`）を開く
3. ブラウザのコンソール（F12）を開く
4. エラーメッセージを確認

### 影響範囲
- **機能面**: 影響なし（ログアウトボタンがそもそも表示されていない）
- **ユーザー体験**: 影響なし（コンソールエラーのみ）
- **セキュリティ**: 影響なし

### 発見日
2026-03-11

### ステータス
後日対応予定

### 修正案

#### オプション1（推奨）: ログアウトボタンを追加
マイページにログアウトボタンを実装し、ユーザービリティを向上させる。

**実装内容**:
1. `/mypage/bookings` の HTML にログアウトボタンを追加
2. ヘッダー部分に配置（右上など）
3. クリック時に `/api/mypage/logout` を呼び出し
4. ログアウト後は `/mypage` にリダイレクト

**推定工数**: 15分

#### オプション2: エラーハンドリング追加
要素が存在しない場合は `addEventListener` をスキップする。

**実装内容**:
```javascript
// src/index.tsx 行7836付近
const logoutBtn = document.getElementById('logoutBtn');
if (logoutBtn) {
  logoutBtn.addEventListener('click', async () => {
    // 既存のコード
  });
}
```

**推定工数**: 5分

### 優先度判断の理由
- 機能に影響がない
- ユーザー体験に影響がない
- セキュリティリスクがない
- CDN修正（セキュリティ対応）を優先すべき

### 関連ファイル
- `src/index.tsx` (行7474-7893: `/mypage/bookings` ルート定義)
- `src/index.tsx` (行7836: エラー発生箇所)

---

## 履歴

| 日付 | 内容 |
|------|------|
| 2026-03-11 | 初回記録 - addEventListener エラー発見 |

