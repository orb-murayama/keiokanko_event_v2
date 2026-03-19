# セキュリティ監査レポート

**プロジェクト**: webapp  
**監査日**: 2026年3月9日  
**監査対象**: ソースコード、依存関係、構成ファイル

---

## 🚨 重大な脆弱性（Critical）

### 1. Hono Framework - 複数の深刻な脆弱性

**パッケージ**: `hono@4.10.6`  
**現在のバージョン**: 4.10.6  
**推奨バージョン**: 4.12.4以上

**検出された脆弱性**:

#### 1.1 JWT Algorithm Confusion（GHSA-3vhc-576x-3qv4）
- **深刻度**: High
- **影響**: JWK認証ミドルウェアで、JWKに"alg"が欠落している場合、信頼できないheader.algにフォールバックし、トークン偽造が可能
- **対策**: Hono 4.12.4以上にアップデート

#### 1.2 JWT Default Algorithm (HS256) Token Forgery（GHSA-f67f-6cw9-8mq4）
- **深刻度**: High
- **影響**: JWTミドルウェアのデフォルト設定（HS256）により、トークン偽造と認証バイパスが可能
- **対策**: Hono 4.12.4以上にアップデート

#### 1.3 XSS via ErrorBoundary（GHSA-9r54-q6cx-xmh5）
- **深刻度**: High
- **影響**: ErrorBoundaryコンポーネントでのXSS脆弱性
- **対策**: Hono 4.12.4以上にアップデート

#### 1.4 Web Cache Deception（GHSA-6wqw-2p9w-4vw4）
- **深刻度**: High
- **影響**: キャッシュミドルウェアが"Cache-Control: private"を無視し、Web Cache Deceptionが可能
- **対策**: Hono 4.12.4以上にアップデート

#### 1.5 IP Restriction Bypass（GHSA-r354-f388-2fhh）
- **深刻度**: High
- **影響**: IPv4アドレス検証のバイパスにより、IPスプーフィングが可能
- **対策**: Hono 4.12.4以上にアップデート

#### 1.6 Arbitrary Key Read in Serve Static（GHSA-w332-q679-j88p）
- **深刻度**: High
- **影響**: Cloudflare Workers Adapterの静的ファイル配信ミドルウェアで任意のキー読み取りが可能
- **対策**: Hono 4.12.4以上にアップデート

#### 1.7 Cookie Attribute Injection（GHSA-5pq2-9x2x-5p6w）
- **深刻度**: High
- **影響**: setCookie()のdomainとpathパラメータが未サニタイズで、Cookie属性インジェクションが可能
- **現在のコード影響箇所**: 
  - `src/index.tsx:19756` - admin_session_tokenの設定
  - `src/index.tsx:13726` - mypage_session_tokenの設定
- **対策**: Hono 4.12.4以上にアップデート

#### 1.8 SSE Control Field Injection（GHSA-p6xx-57qc-3wxr）
- **深刻度**: High
- **影響**: writeSSE()でのCR/LFインジェクションにより、SSE制御フィールドインジェクションが可能
- **対策**: Hono 4.12.4以上にアップデート

#### 1.9 Arbitrary File Access via serveStatic（GHSA-q5qw-h33p-qvwr）
- **深刻度**: High
- **影響**: serveStatic脆弱性により任意のファイルアクセスが可能
- **現在のコード影響箇所**: `src/index.tsx:215` - `/static/*`での静的ファイル配信
- **対策**: Hono 4.12.4以上にアップデート

#### 1.10 Timing Attack on Basic Auth（GHSA-gq3j-xvxp-8hrf）
- **深刻度**: High
- **影響**: basicAuthとbearerAuthでのタイミング攻撃の可能性
- **現在のコード影響箇所**: 
  - `src/index.tsx:174, 10121, 10145, 10169` - basicAuth使用箇所
- **対策**: Hono 4.12.4以上にアップデート

---

### 2. @hono/node-server - Authorization Bypass

**パッケージ**: `@hono/node-server@<1.19.10`  
**深刻度**: High

**脆弱性**: GHSA-wc8c-qw6v-h7f6
- **影響**: Serve Static Middlewareで、エンコードされたスラッシュを使用して保護された静的パスの認証をバイパス可能
- **対策**: @hono/node-server 1.19.10以上にアップデート

**注意**: 現在のプロジェクトではCloudflare Workers用のserveStaticを使用しているため、直接影響はないが、将来EC2+Honoに移行する際は注意が必要

---

## ⚠️ 高リスク脆弱性（High）

### 3. Rollup - Arbitrary File Write

**パッケージ**: `rollup@4.0.0-4.58.0`  
**深刻度**: High

**脆弱性**: GHSA-mw96-cpmx-2vgc
- **影響**: パストラバーサルによる任意のファイル書き込み
- **対策**: Rollup 4.58.1以上にアップデート（Viteの依存関係として間接的に使用）

---

### 4. minimatch - ReDoS (Regular Expression Denial of Service)

**パッケージ**: `minimatch@<=3.1.3 || 5.0.0-5.1.7 || 9.0.0-9.0.6`  
**深刻度**: High

**脆弱性**: 
- GHSA-3ppc-4f35-3m26: 非マッチングリテラルと繰り返しワイルドカードによるReDoS
- GHSA-7r86-cg39-jmmj: 複数の非隣接GLOBSTARセグメントによるReDoS
- GHSA-23c5-xmqv-rm74: ネストされた*()拡張グロブによるReDoS

**対策**: minimatch 10.0.0以上にアップデート

---

## 📊 中程度のリスク（Moderate）

### 5. undici - Unbounded Decompression

**パッケージ**: `undici@7.0.0-7.18.1`  
**深刻度**: Moderate

**脆弱性**: GHSA-g9mf-h72j-4rw9
- **影響**: Content-Encodingを介したHTTPレスポンスの無制限の解凍チェーンにより、リソース枯渇が可能
- **間接依存**: wrangler → miniflare → undici
- **対策**: undici 7.18.2以上にアップデート（wranglerのアップデートで自動解決）

---

## 🔍 コードレベルのセキュリティ問題

### 6. innerHTML使用によるXSSリスク

**影響箇所**: `src/index.tsx`
- Line 15702, 15721: ログインボタンのinnerHTML
- Line 15994, 16024: 登録ボタンのinnerHTML
- Line 16506, 17061, 17125, 17133, 17233, 17277, 17396: コンテナのinnerHTML

**リスク**: 
- ユーザー入力が適切にサニタイズされずにinnerHTMLに渡されると、XSS攻撃の可能性
- 現在の実装では固定文字列を使用しているため直接的なリスクは低いが、将来の変更で脆弱性が混入する可能性

**推奨対策**:
```typescript
// ❌ 悪い例
element.innerHTML = userInput

// ✅ 良い例
element.textContent = userInput

// ✅ または
const template = document.createElement('div')
template.textContent = userInput
element.appendChild(template)
```

---

### 7. Basic認証の実装

**影響箇所**: `src/index.tsx`
- Line 174, 10121, 10145, 10169: basicAuth使用

**現在の実装**:
```typescript
const auth = basicAuth({
  username: basicAuthUser,
  password: basicAuthPass,
})
```

**リスク**:
- Honoの古いバージョン（4.10.6）では、タイミング攻撃に対する強化が不十分
- HTTPS経由でのみ使用する必要がある（Cloudflare経由なので問題なし）

**推奨対策**:
- Hono 4.12.4以上にアップデート（タイミング比較の強化が含まれる）

---

### 8. Cookie設定のセキュリティ

**影響箇所**: `src/index.tsx:19756, 13726`

**現在の実装**:
```typescript
setCookie(c, 'admin_session_token', sessionToken, {
  path: '/',
  httpOnly: true,
  sameSite: 'Lax',
  maxAge: 86400
})
```

**リスク**:
- Hono 4.10.6では、domainとpathパラメータのCookie属性インジェクション脆弱性
- 現在の実装では固定値を使用しているため直接的なリスクは低い

**推奨対策**:
- Hono 4.12.4以上にアップデート
- 本番環境では`secure: true`を追加（HTTPSのみ）
- セッショントークンには`SameSite: Strict`を推奨

```typescript
// 推奨設定
setCookie(c, 'admin_session_token', sessionToken, {
  path: '/',
  httpOnly: true,
  secure: true,  // HTTPS only
  sameSite: 'Strict',  // より厳格
  maxAge: 86400
})
```

---

### 9. SQLインジェクション対策の確認

**影響箇所**: 全てのDB.prepare()呼び出し

**現在の実装**: ✅ 適切
```typescript
// ✅ 良い例（パラメータバインディング使用）
const countResult = await DB.prepare(countQuery).bind(...params).first()
```

**確認結果**:
- 全てのSQLクエリでパラメータバインディング（`.bind()`）を使用
- 文字列連結でのSQL構築は見られない
- **SQLインジェクションのリスクは低い**

---

### 10. 環境変数の露出リスク

**影響箇所**: `src/index.tsx:161, 881`

**現在の実装**:
```typescript
envKeys: Object.keys(c.env || {}).filter(k => k.includes('BASIC') || k.includes('AUTH'))
```

**リスク**:
- デバッグ目的で環境変数のキー名を出力
- 本番環境では削除すべき

**推奨対策**:
```typescript
// 開発環境のみ出力
if (process.env.NODE_ENV === 'development') {
  console.log('Available env keys:', Object.keys(c.env || {}).filter(...))
}
```

---

## 📋 推奨アクション（優先度順）

### 🔴 優先度1: 即座に実施（Critical）

#### 1. 依存関係のアップデート

```bash
cd /home/user/webapp

# package.jsonを更新
npm install hono@latest @hono/node-server@latest wrangler@latest

# または個別に
npm install hono@^4.12.4
npm install @hono/node-server@^1.19.10
npm install wrangler@^4.60.0

# 監査実行
npm audit

# 自動修正可能な脆弱性を修正
npm audit fix

# ビルドテスト
npm run build

# 開発環境でテスト
npm run dev:sandbox
```

#### 2. Cookie設定の強化

```typescript
// src/index.tsx の全てのsetCookie呼び出しを更新

// Before
setCookie(c, 'admin_session_token', sessionToken, {
  path: '/',
  httpOnly: true,
  sameSite: 'Lax',
  maxAge: 86400
})

// After
const isProduction = c.env.NODE_ENV === 'production'
setCookie(c, 'admin_session_token', sessionToken, {
  path: '/',
  httpOnly: true,
  secure: isProduction,  // 本番環境でHTTPSのみ
  sameSite: 'Strict',    // より厳格なポリシー
  maxAge: 86400
})
```

#### 3. デバッグコードの削除

```typescript
// src/index.tsx:161, 881 のデバッグコードを削除または条件付き実行

// Before
envKeys: Object.keys(c.env || {}).filter(k => k.includes('BASIC') || k.includes('AUTH'))

// After（開発環境のみ）
...(process.env.NODE_ENV === 'development' ? {
  envKeys: Object.keys(c.env || {}).filter(k => k.includes('BASIC') || k.includes('AUTH'))
} : {})
```

---

### 🟡 優先度2: 近日中に実施（High）

#### 4. innerHTML使用の見直し

```typescript
// 安全なDOM操作に置き換え

// Before
element.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>ログイン中...'

// After
element.textContent = ''
const spinner = document.createElement('i')
spinner.className = 'fas fa-spinner fa-spin mr-2'
element.appendChild(spinner)
element.appendChild(document.createTextNode('ログイン中...'))
```

#### 5. serveStaticの安全な設定

```typescript
// src/index.tsx:215

// Before
app.use('/static/*', serveStatic({ root: './' }))

// After（より安全な設定）
app.use('/static/*', serveStatic({ 
  root: './public',  // 公開ディレクトリのみ
  rewriteRequestPath: (path) => path.replace(/^\/static/, '')
}))
```

---

### 🟢 優先度3: 長期的に実施（Moderate）

#### 6. セキュリティヘッダーの追加

```typescript
// src/index.tsx にグローバルミドルウェアを追加

app.use('*', async (c, next) => {
  await next()
  
  // セキュリティヘッダーを追加
  c.header('X-Content-Type-Options', 'nosniff')
  c.header('X-Frame-Options', 'DENY')
  c.header('X-XSS-Protection', '1; mode=block')
  c.header('Referrer-Policy', 'strict-origin-when-cross-origin')
  
  // HTTPS環境でのみ
  if (c.req.url.startsWith('https://')) {
    c.header('Strict-Transport-Security', 'max-age=31536000; includeSubDomains')
  }
})
```

#### 7. Content Security Policy (CSP)の導入

```typescript
app.use('*', async (c, next) => {
  await next()
  
  c.header('Content-Security-Policy', [
    "default-src 'self'",
    "script-src 'self' 'unsafe-inline' https://cdn.tailwindcss.com https://cdn.jsdelivr.net",
    "style-src 'self' 'unsafe-inline' https://cdn.tailwindcss.com https://cdn.jsdelivr.net",
    "img-src 'self' data: https:",
    "font-src 'self' https://cdn.jsdelivr.net",
    "connect-src 'self'",
    "frame-ancestors 'none'"
  ].join('; '))
})
```

#### 8. レート制限の実装

```typescript
// API エンドポイントにレート制限を追加

import { rateLimiter } from 'hono-rate-limiter'

// 依存関係追加
// npm install hono-rate-limiter

const limiter = rateLimiter({
  windowMs: 15 * 60 * 1000, // 15分
  max: 100, // 最大100リクエスト
  standardHeaders: 'draft-7',
  keyGenerator: (c) => c.req.header('x-forwarded-for') || 'unknown'
})

app.use('/api/*', limiter)
```

---

## 📊 脆弱性サマリー

| 深刻度 | 件数 | パッケージ | 状態 |
|--------|------|-----------|------|
| **Critical** | 10 | hono | 🔴 要対応 |
| **High** | 1 | @hono/node-server | 🔴 要対応 |
| **High** | 1 | rollup | 🟡 間接依存 |
| **High** | 3 | minimatch | 🟡 間接依存 |
| **Moderate** | 1 | undici | 🟡 間接依存 |
| **コードレベル** | 5 | src/index.tsx | 🟡 要レビュー |

**合計**: 21件の問題

---

## 🔧 即座に実行可能な修正コマンド

```bash
# 1. ワーキングディレクトリ移動
cd /home/user/webapp

# 2. 現在の依存関係バックアップ
cp package.json package.json.backup
cp package-lock.json package-lock.json.backup

# 3. 依存関係アップデート
npm install hono@^4.12.4 @hono/node-server@^1.19.10 wrangler@^4.60.0

# 4. 自動修正
npm audit fix

# 5. 監査確認
npm audit

# 6. ビルドテスト
npm run build

# 7. ローカルテスト
npm run dev:sandbox

# 8. 問題なければコミット
git add package.json package-lock.json
git commit -m "security: Update dependencies to fix critical vulnerabilities (Hono, @hono/node-server, wrangler)"

# 9. デプロイ
npm run deploy
```

---

## 📝 追加の推奨事項

### 1. 定期的なセキュリティ監査

```bash
# 毎週実行
npm audit

# GitHub Dependabotの有効化
# .github/dependabot.yml を作成
```

### 2. セキュリティスキャンツールの導入

```bash
# Snyk インストール
npm install -g snyk

# Snyk認証
snyk auth

# プロジェクトスキャン
snyk test

# 継続的監視
snyk monitor
```

### 3. .gitignoreの確認

```bash
# 機密情報が含まれるファイルを除外
cat >> .gitignore << 'EOF'
.env
.env.local
.env.production
*.pem
*.key
secrets/
EOF
```

### 4. セキュリティポリシーの作成

```markdown
# SECURITY.md を作成

## セキュリティポリシー

### 報告方法
セキュリティ脆弱性を発見した場合は、security@example.com にご連絡ください。

### サポートバージョン
| バージョン | サポート状態 |
|-----------|-------------|
| 1.x       | ✅ サポート中 |
| 0.x       | ❌ サポート終了 |
```

---

## ✅ 修正完了チェックリスト

- [ ] Hono 4.12.4以上にアップデート
- [ ] @hono/node-server 1.19.10以上にアップデート
- [ ] wrangler 4.60.0以上にアップデート
- [ ] npm audit でクリーン確認
- [ ] Cookie設定にsecure: trueを追加
- [ ] Cookie設定にsameSite: Strictを設定
- [ ] デバッグコードの削除または条件付き実行
- [ ] innerHTML使用箇所の見直し
- [ ] serveStatic設定の見直し
- [ ] セキュリティヘッダーの追加
- [ ] CSPの導入（オプション）
- [ ] レート制限の実装（オプション）
- [ ] .gitignoreの確認
- [ ] SECURITY.mdの作成
- [ ] ビルドテスト成功
- [ ] ローカル動作確認
- [ ] 本番デプロイ

---

**監査完了日**: 2026年3月9日  
**次回監査予定**: 2026年4月9日（月次）  
**担当者**: [名前]
