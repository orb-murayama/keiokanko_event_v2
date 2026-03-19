# ベーシック認証設定ガイド

## 概要

本番環境にベーシック認証を追加して、アクセスを制限できます。

## 設定方法

### 1. Cloudflare Pages の環境変数設定

Cloudflare Dashboard で環境変数を設定します：

1. https://dash.cloudflare.com/ にアクセス
2. **Workers & Pages** → **webapp** プロジェクトを選択
3. **Settings** タブ → **Environment variables** を選択
4. **Add variable** で以下を追加：

| 変数名 | 値（例） | 説明 |
|--------|---------|------|
| `BASIC_AUTH_USER` | `admin` | ベーシック認証のユーザー名 |
| `BASIC_AUTH_PASS` | `your-secure-password` | ベーシック認証のパスワード |

5. **Production** 環境と **Preview** 環境の両方に適用
6. **Save** をクリック

### 2. 再デプロイ

環境変数を設定後、再デプロイが必要です：

```bash
cd /home/user/webapp
npm run build
npx wrangler pages deploy dist --project-name webapp
```

または、Cloudflare Dashboard から **Deployments** → **Retry deployment** をクリック

## 動作確認

1. ブラウザで https://webapp-geh.pages.dev にアクセス
2. ベーシック認証のダイアログが表示される
3. 設定したユーザー名とパスワードを入力
4. 認証成功後、サイトが表示される

## ローカル開発環境

ローカル開発でベーシック認証をテストする場合：

### .dev.vars ファイルに追加

```bash
# ベーシック認証（任意）
# コメントを外して使用
# BASIC_AUTH_USER=admin
# BASIC_AUTH_PASS=password
```

### テスト

```bash
npm run dev

# 別のターミナルで
curl -u admin:password http://localhost:3000
```

## セキュリティ推奨事項

1. **強力なパスワードを使用**
   - 12文字以上
   - 英数字と記号を組み合わせる
   - 例: `xK9$mN2@pL7#vR4!`

2. **パスワードを定期的に変更**
   - 3～6ヶ月ごとに変更を推奨

3. **認証情報を安全に管理**
   - パスワードマネージャーを使用
   - `.dev.vars` ファイルは `.gitignore` に含める（既に設定済み）

## 認証を無効化する方法

ベーシック認証を無効にする場合：

1. Cloudflare Dashboard で環境変数 `BASIC_AUTH_USER` と `BASIC_AUTH_PASS` を削除
2. 再デプロイ

または、空の値を設定：
- `BASIC_AUTH_USER` = `（空）`
- `BASIC_AUTH_PASS` = `（空）`

## トラブルシューティング

### 認証ダイアログが表示されない

1. 環境変数が正しく設定されているか確認
2. 再デプロイを実行
3. ブラウザのキャッシュをクリア

### 認証後も403エラーが出る

1. ユーザー名とパスワードが正しいか確認
2. 大文字小文字を区別（例: `Admin` ≠ `admin`）
3. Cloudflare Dashboard で環境変数を確認

### API呼び出しでエラーが出る

JavaScriptから API を呼び出す場合、認証ヘッダーを追加：

```javascript
const response = await fetch('/api/events', {
  headers: {
    'Authorization': 'Basic ' + btoa('admin:password')
  }
})
```

## 技術詳細

### 実装方法

Hono の `basicAuth` ミドルウェアを使用：

```typescript
import { basicAuth } from 'hono/basic-auth'

app.use('*', async (c, next) => {
  const BASIC_AUTH_USER = c.env?.BASIC_AUTH_USER
  const BASIC_AUTH_PASS = c.env?.BASIC_AUTH_PASS
  
  if (!BASIC_AUTH_USER || !BASIC_AUTH_PASS) {
    await next()
    return
  }
  
  const auth = basicAuth({
    username: BASIC_AUTH_USER,
    password: BASIC_AUTH_PASS,
    realm: 'Event Booking System'
  })
  
  return auth(c, next)
})
```

### 対象範囲

- 全てのページ（`/*`）
- 全てのAPI（`/api/*`）
- 静的ファイル（`/static/*`）

環境変数が設定されていない場合は、認証はスキップされます。
