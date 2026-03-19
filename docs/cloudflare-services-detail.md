# Cloudflare サービス詳細ガイド

このドキュメントでは、本プロジェクトで利用している各Cloudflareサービスの機能と使い方を詳しく説明します。

---

## 目次

1. [Cloudflare Pages](#1-cloudflare-pages)
2. [Cloudflare Workers](#2-cloudflare-workers)
3. [Cloudflare D1 Database](#3-cloudflare-d1-database)
4. [Cloudflare R2 Storage](#4-cloudflare-r2-storage)
5. [Cloudflare CDN](#5-cloudflare-cdn)
6. [Cloudflare WAF](#6-cloudflare-waf)
7. [Cloudflare Analytics](#7-cloudflare-analytics)
8. [その他利用可能なサービス](#8-その他利用可能なサービス)

---

## 1. Cloudflare Pages

### 概要
静的サイトホスティングとサーバーレスアプリケーションを実行できるプラットフォーム。GitHubと連携し、プッシュ時に自動デプロイが可能。

### 主な機能

#### 1.1 静的ファイルホスティング
```
機能:
• HTML/CSS/JavaScriptファイルの配信
• 画像、フォント、その他アセットのホスティング
• 自動的にCloudflare CDNで配信
• グローバルエッジネットワークでキャッシュ

使用例:
/public/
├── index.html          → https://webapp-geh.pages.dev/
├── css/style.css       → https://webapp-geh.pages.dev/css/style.css
├── js/app.js           → https://webapp-geh.pages.dev/js/app.js
└── images/logo.png     → https://webapp-geh.pages.dev/images/logo.png
```

#### 1.2 Cloudflare Workers統合
```
機能:
• _worker.js を使ったサーバーサイド処理
• Honoフレームワークによる動的コンテンツ生成
• APIエンドポイントの実装
• サーバーレス関数の実行

使用例:
dist/
├── _worker.js          → バックエンドロジック実行
├── _routes.json        → ルーティング設定
└── index.html          → 静的ファイル

_routes.json の例:
{
  "version": 1,
  "include": ["/api/*"],      // これらはWorkerで処理
  "exclude": ["/static/*"]    // これらは静的ファイルとして配信
}
```

#### 1.3 プレビューデプロイ
```
機能:
• 各Git commitごとに自動プレビュー環境作成
• ブランチごとの独立した環境
• 本番環境に影響を与えずにテスト可能

URL形式:
• 本番: https://webapp-geh.pages.dev
• プレビュー: https://<commit-hash>.webapp-geh.pages.dev
• ブランチ: https://<branch-name>.webapp-geh.pages.dev
```

#### 1.4 カスタムドメイン
```
機能:
• 独自ドメインの設定
• 自動SSL証明書発行（Let's Encrypt）
• HTTPS強制リダイレクト

設定例:
1. Cloudflare Pagesダッシュボードで設定
2. DNSレコード追加（CNAME）
   example.com → webapp-geh.pages.dev
3. 自動でSSL証明書が発行される
```

#### 1.5 環境変数
```
機能:
• プロジェクト単位での環境変数管理
• Production/Preview環境で別の値を設定可能
• シークレット情報の安全な保存

設定方法:
wrangler.jsonc:
  "vars": {
    "APP_MODE": "all",
    "DEBUG": "false"
  }

または Cloudflare Dashboard:
  Pages > プロジェクト > Settings > Environment variables
```

### 料金プラン
```
Free Plan:
• 500ビルド/月
• 無制限リクエスト
• 1並行ビルド
• 無制限サイト数

Paid Plan ($20/月):
• 5,000ビルド/月
• 5並行ビルド
• 高速ビルド環境
```

---

## 2. Cloudflare Workers

### 概要
JavaScriptをエッジで実行できるサーバーレスプラットフォーム。V8エンジンを使用し、世界中のデータセンターでコードを実行。

### 主な機能

#### 2.1 エッジコンピューティング
```
特徴:
• ユーザーに最も近いデータセンターで実行
• コールドスタート時間: 0ms（常に起動状態）
• レスポンス時間: 10-30ms

実行フロー:
1. ユーザーがリクエスト
2. 最寄りのCloudflareデータセンターで実行
3. 必要に応じてOrigin（D1/R2）にアクセス
4. レスポンスを返す（すべてエッジで完結）
```

#### 2.2 リクエスト処理
```javascript
// 基本的なWorker（Honoフレームワーム使用）
import { Hono } from 'hono'

const app = new Hono()

// APIエンドポイント
app.get('/api/hello', (c) => {
  return c.json({ message: 'Hello from Edge!' })
})

// 動的HTML生成
app.get('/', (c) => {
  return c.html('<h1>Dynamic Content</h1>')
})

export default app
```

#### 2.3 バインディング（他サービスとの連携）
```typescript
// wrangler.jsonc で定義されたバインディングを使用
type Bindings = {
  DB: D1Database              // D1データベース
  R2: R2Bucket                // R2ストレージ
  BOOKING_FILES: R2Bucket     // R2ストレージ（予約ファイル）
}

const app = new Hono<{ Bindings: Bindings }>()

// D1データベースへのアクセス
app.get('/api/products', async (c) => {
  const { DB } = c.env
  const result = await DB.prepare('SELECT * FROM products').all()
  return c.json(result.results)
})

// R2ストレージへのアクセス
app.post('/api/upload', async (c) => {
  const { R2 } = c.env
  const file = await c.req.arrayBuffer()
  await R2.put('images/product.jpg', file)
  return c.json({ success: true })
})
```

#### 2.4 制限事項
```
CPU時間:
• Free: 10ms/リクエスト
• Paid: 30ms/リクエスト（$5/月で1000万リクエスト）

メモリ:
• 128MB/リクエスト

リクエストサイズ:
• 100MB（アップロード・ダウンロード）

利用不可能なNode.js API:
• fs (ファイルシステム)
• child_process (子プロセス)
• net, dgram (ネットワーク)
• os (OS情報)

利用可能なWeb標準API:
• Fetch API
• Web Crypto API
• Streams API
• URL API
• TextEncoder/TextDecoder
```

### 料金プラン
```
Free Plan:
• 100,000リクエスト/日
• CPU時間: 10ms/リクエスト

Paid Plan ($5/1000万リクエスト):
• 無制限リクエスト
• CPU時間: 30ms/リクエスト
```

---

## 3. Cloudflare D1 Database

### 概要
SQLiteベースのグローバル分散型データベース。エッジで実行されるアプリケーションに最適化。

### 主な機能

#### 3.1 SQLiteデータベース
```sql
-- 標準的なSQLite構文を使用
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  price INTEGER NOT NULL,
  stock INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CRUD操作
INSERT INTO products (name, price, stock) VALUES ('商品A', 1000, 10);
SELECT * FROM products WHERE stock > 0;
UPDATE products SET stock = stock - 1 WHERE id = 1;
DELETE FROM products WHERE id = 1;
```

#### 3.2 Prepared Statements（SQLインジェクション対策）
```typescript
// ❌ 危険（SQLインジェクション脆弱性）
const userId = c.req.query('id')
await DB.prepare(`SELECT * FROM users WHERE id = ${userId}`).all()

// ✅ 安全（Prepared Statements使用）
const userId = c.req.query('id')
await DB.prepare('SELECT * FROM users WHERE id = ?').bind(userId).all()

// 複数パラメータ
await DB.prepare('INSERT INTO users (name, email) VALUES (?, ?)')
  .bind('田中太郎', 'tanaka@example.com')
  .run()
```

#### 3.3 トランザクション
```typescript
// バッチ処理（複数クエリを1トランザクションで実行）
const results = await DB.batch([
  DB.prepare('INSERT INTO bookings (user_id) VALUES (?)').bind(1),
  DB.prepare('UPDATE products SET stock = stock - 1 WHERE id = ?').bind(5),
  DB.prepare('INSERT INTO booking_items (booking_id, product_id) VALUES (?, ?)').bind(1, 5)
])

// すべて成功するか、すべて失敗する（ACID特性）
```

#### 3.4 マイグレーション管理
```bash
# マイグレーションファイル作成
migrations/
├── 0000_consolidated_schema.sql      # 初期スキーマ
├── 0031_add_display_order.sql        # 表示順追加
└── 0032_add_stock_type.sql           # 在庫タイプ追加

# ローカル環境に適用
npx wrangler d1 migrations apply webapp-production --local

# 本番環境に適用
npx wrangler d1 migrations apply webapp-production --remote

# マイグレーション履歴確認
npx wrangler d1 migrations list webapp-production --remote
```

#### 3.5 データベース操作
```bash
# 直接SQLを実行（本番）
npx wrangler d1 execute webapp-production --remote \
  --command="SELECT COUNT(*) FROM bookings"

# SQLファイルを実行
npx wrangler d1 execute webapp-production --remote \
  --file=./seed.sql

# データベースコンソール起動（ローカル）
npx wrangler d1 execute webapp-production --local
```

#### 3.6 レプリケーション
```
読み取りレプリカ:
• プライマリ（書き込み）: 1リージョン
• レプリカ（読み取り専用）: 複数リージョン
• 自動的に最寄りのレプリカから読み取り
• 結果整合性（Eventually Consistent）

一貫性レベル:
• Strong Consistency: 書き込み直後の読み取りは常に最新
• Eventual Consistency: レプリカ間で若干の遅延あり（通常数秒）
```

### 制限事項
```
データベースサイズ:
• Free: 5GB
• Paid: 50GB+

クエリ実行時間:
• 最大30秒/クエリ

同時接続数:
• Workers経由のみ（直接接続不可）

バックアップ:
• 自動バックアップ（Point-in-Time Recovery）
• 手動エクスポート（SQLダンプ）
```

### 料金プラン
```
Free Plan:
• 5GB storage
• 500万行読み取り/日
• 10万行書き込み/日

Paid Plan:
• $0.75/GB storage/月
• $0.001/100万行読み取り
• $1.00/100万行書き込み
```

---

## 4. Cloudflare R2 Storage

### 概要
S3互換のオブジェクトストレージ。Egress（データ転送）料金が無料なのが最大の特徴。

### 主な機能

#### 4.1 オブジェクトの保存・取得
```typescript
// R2にファイルをアップロード
app.post('/api/upload', async (c) => {
  const { R2 } = c.env
  const file = await c.req.arrayBuffer()
  
  // アップロード
  await R2.put('products/image123.jpg', file, {
    httpMetadata: {
      contentType: 'image/jpeg'
    },
    customMetadata: {
      uploadedBy: 'admin',
      uploadedAt: new Date().toISOString()
    }
  })
  
  return c.json({ success: true })
})

// R2からファイルを取得
app.get('/api/files/:key', async (c) => {
  const { R2 } = c.env
  const key = c.req.param('key')
  
  const object = await R2.get(key)
  
  if (!object) {
    return c.notFound()
  }
  
  return new Response(object.body, {
    headers: {
      'Content-Type': object.httpMetadata.contentType || 'application/octet-stream',
      'Cache-Control': 'public, max-age=31536000'
    }
  })
})
```

#### 4.2 ファイル管理
```typescript
// ファイル一覧取得
const objects = await R2.list({
  prefix: 'products/',     // プレフィックスでフィルタ
  limit: 100,              // 最大100件
  cursor: undefined        // ページネーション用
})

for (const obj of objects.objects) {
  console.log(obj.key)           // ファイルパス
  console.log(obj.size)          // ファイルサイズ（バイト）
  console.log(obj.uploaded)      // アップロード日時
}

// ファイル削除
await R2.delete('products/image123.jpg')

// 複数ファイル削除
await R2.delete(['file1.jpg', 'file2.jpg', 'file3.jpg'])

// ファイルのメタデータ取得（本体はダウンロードしない）
const metadata = await R2.head('products/image123.jpg')
console.log(metadata.size)
console.log(metadata.httpMetadata)
console.log(metadata.customMetadata)
```

#### 4.3 マルチパートアップロード（大容量ファイル用）
```typescript
// 100MB以上のファイルは分割アップロード推奨
const multipart = await R2.createMultipartUpload('large-file.mp4')

// パート1をアップロード
const part1 = await R2.uploadPart('large-file.mp4', multipart.uploadId, 1, chunk1)

// パート2をアップロード
const part2 = await R2.uploadPart('large-file.mp4', multipart.uploadId, 2, chunk2)

// マルチパートアップロード完了
await R2.completeMultipartUpload('large-file.mp4', multipart.uploadId, {
  parts: [
    { partNumber: 1, etag: part1.etag },
    { partNumber: 2, etag: part2.etag }
  ]
})
```

#### 4.4 公開URL設定
```typescript
// R2バケットを公開する（オプション）
// Cloudflare Dashboardで設定:
// R2 > バケット > Settings > Public Access

// 公開URL:
// https://pub-<hash>.r2.dev/products/image123.jpg

// カスタムドメイン設定:
// https://cdn.example.com/products/image123.jpg

// Workerで動的にアクセス制御
app.get('/files/:key', async (c) => {
  // 認証チェック
  const token = c.req.header('Authorization')
  if (!isValidToken(token)) {
    return c.json({ error: 'Unauthorized' }, 401)
  }
  
  // 認証成功後にR2からファイル取得
  const object = await c.env.R2.get(c.req.param('key'))
  return new Response(object.body)
})
```

#### 4.5 TTL（自動削除）
```typescript
// 一定期間後に自動削除
await R2.put('temp/session-data.json', data, {
  httpMetadata: { contentType: 'application/json' },
  customMetadata: {
    expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()
  }
})

// ライフサイクルルール（Dashboardで設定）
// 30日後に自動削除
// プレフィックス: temp/
```

### 制限事項
```
オブジェクトサイズ:
• 最大5TB/オブジェクト

リクエスト制限:
• 無制限（実質的に）

バケット数:
• 無制限

命名規則:
• S3互換（バケット名はグローバルでユニーク不要）
```

### 料金プラン
```
Storage:
• $0.015/GB/月

Class A Operations（書き込み）:
• $4.50/100万リクエスト
• PUT, POST, LIST, COPY

Class B Operations（読み取り）:
• $0.36/100万リクエスト
• GET, HEAD

Egress（データ転送）:
• 完全無料 🎉（他クラウドは有料）
```

---

## 5. Cloudflare CDN

### 概要
世界中に分散された300以上のデータセンターで構成されるCDNネットワーク。Pages利用時に自動的に有効化。

### 主な機能

#### 5.1 自動キャッシュ
```
キャッシュ対象:
• 静的ファイル（HTML, CSS, JS, 画像, フォントなど）
• APIレスポンス（Cache-Controlヘッダーで制御）

キャッシュ期間:
• ブラウザキャッシュ: Cache-Controlヘッダーで指定
• Cloudflareエッジキャッシュ: 自動最適化

例:
Cache-Control: public, max-age=31536000  // 1年間キャッシュ
Cache-Control: no-cache                  // キャッシュしない
```

#### 5.2 自動最適化
```typescript
// Workerでキャッシュ制御
app.get('/api/products', async (c) => {
  const { DB } = c.env
  
  // データベースから取得
  const products = await DB.prepare('SELECT * FROM products').all()
  
  // レスポンスヘッダーでキャッシュ設定
  return c.json(products.results, {
    headers: {
      'Cache-Control': 'public, max-age=300',  // 5分間キャッシュ
      'CDN-Cache-Control': 'max-age=600'       // CDNは10分間キャッシュ
    }
  })
})

// キャッシュをバイパス
app.get('/api/realtime-data', async (c) => {
  return c.json(data, {
    headers: {
      'Cache-Control': 'no-store, no-cache, must-revalidate'
    }
  })
})
```

#### 5.3 画像最適化
```
自動最適化:
• WebP/AVIF変換（対応ブラウザのみ）
• サイズ圧縮
• レスポンシブ画像配信

Cloudflare Images（別サービス）を使用すると:
• サムネイル自動生成
• リアルタイムリサイズ
• 透かし追加
```

#### 5.4 圧縮
```
自動圧縮:
• Gzip圧縮
• Brotli圧縮（より高効率）

圧縮対象:
• HTML, CSS, JavaScript
• JSON, XML
• SVG
```

### パフォーマンス
```
レイテンシ:
• 平均: 10-50ms
• 最寄りのデータセンターから配信

稼働率:
• 99.99%+ SLA

DDoS保護:
• 無制限の緩和
• 自動検知・ブロック
```

---

## 6. Cloudflare WAF (Web Application Firewall)

### 概要
Webアプリケーションを攻撃から保護するファイアウォール。Pages利用時に自動的に有効化。

### 主な機能

#### 6.1 OWASP Top 10保護
```
保護される攻撃:
• SQLインジェクション
• XSS（クロスサイトスクリプティング）
• CSRF（クロスサイトリクエストフォージェリ）
• ファイルインクルージョン
• コマンドインジェクション
• パストラバーサル
• リモートコード実行
• XXE（XML外部エンティティ攻撃）

自動ブロック:
• 悪意のあるパターン検出
• 異常なトラフィック検知
• ボット攻撃の緩和
```

#### 6.2 レート制限
```javascript
// Cloudflare Dashboard で設定
// または Worker内で実装

// シンプルなレート制限例
const rateLimiter = new Map()

app.post('/api/login', async (c) => {
  const ip = c.req.header('CF-Connecting-IP')
  const attempts = rateLimiter.get(ip) || 0
  
  // 5分間に5回まで
  if (attempts >= 5) {
    return c.json({ error: 'Too many requests' }, 429)
  }
  
  rateLimiter.set(ip, attempts + 1)
  setTimeout(() => rateLimiter.delete(ip), 5 * 60 * 1000)
  
  // ログイン処理
  // ...
})
```

#### 6.3 Bot Management
```
Bot検出:
• 良性ボット（GoogleBot, BingBotなど）を許可
• 悪性ボット（スクレイパー、スパムボットなど）をブロック

Bot Score:
• 1-99のスコア（低いほど怪しい）
• Workerでアクセス可能

例:
app.get('/api/data', async (c) => {
  const botScore = c.req.header('CF-Bot-Score')
  
  if (parseInt(botScore) < 30) {
    // ボットの可能性が高い
    return c.json({ error: 'Access denied' }, 403)
  }
  
  // 正常処理
})
```

#### 6.4 地域ブロック
```
IPベースのアクセス制御:
• 特定の国からのアクセスをブロック
• 特定のIPアドレスをホワイトリスト/ブラックリスト

Cloudflare Dashboardで設定:
WAF > Custom Rules > Create Rule

例:
if (ip.geoip.country == "CN") then Block
if (ip.src == 192.168.1.1) then Allow
```

### セキュリティレベル
```
Off: すべて許可
Low: 明らかな脅威のみブロック
Medium: 推奨（デフォルト）
High: 厳格なチェック
I'm Under Attack: DDoS攻撃時のモード
```

---

## 7. Cloudflare Analytics

### 概要
Webサイトとアプリケーションのトラフィック、パフォーマンス、セキュリティを監視。

### 主な機能

#### 7.1 トラフィック分析
```
収集データ:
• リクエスト数（時間別、日別）
• ユニークビジター数
• 帯域幅使用量
• キャッシュヒット率
• ステータスコード分布（200, 404, 500など）

ダッシュボード:
• リアルタイムグラフ
• 過去30日間のデータ
• エクスポート機能（CSV）
```

#### 7.2 地域別分析
```
地理的データ:
• 国別リクエスト数
• 都市別分布
• データセンター別レスポンスタイム

活用例:
• どの地域からのアクセスが多いか把握
• リージョン別のパフォーマンス最適化
• ターゲット市場の分析
```

#### 7.3 パフォーマンス分析
```
メトリクス:
• Time to First Byte (TTFB)
• レスポンスタイム平均
• エッジレスポンスタイム
• Origin（D1/R2）レスポンスタイム

パフォーマンス改善のヒント:
• キャッシュヒット率を上げる
• 画像最適化
• 不要なAPI呼び出し削減
```

#### 7.4 セキュリティ分析
```
脅威データ:
• ブロックされたリクエスト数
• 攻撃タイプ別の統計
• ボットトラフィック
• 異常なアクセスパターン

アラート:
• トラフィック急増
• エラー率上昇
• DDoS攻撃検知
```

#### 7.5 カスタムログ（Logpush）
```
高度なログ分析:
• すべてのリクエストログをS3/R2にエクスポート
• カスタム分析ツール（BigQuery, Elasticsearch）と連携
• 長期保存・監査用

データ項目:
• タイムスタンプ
• クライアントIP
• URL
• User-Agent
• レスポンスコード
• レスポンスタイム
• キャッシュステータス
```

#### 7.6 Workers Analytics
```
Worker専用メトリクス:
• CPU時間使用量
• リクエスト数
• エラー率
• メモリ使用量（推定）

コスト管理:
• 無料枠の使用状況
• 課金予測
```

### アクセス方法
```
Cloudflare Dashboard:
https://dash.cloudflare.com/<account-id>/analytics

Wrangler CLI:
npx wrangler pages deployment tail  # リアルタイムログ

GraphQL API（高度な分析）:
https://developers.cloudflare.com/analytics/graphql-api/
```

---

## 8. その他利用可能なサービス

本プロジェクトでは現在未使用ですが、必要に応じて追加できるサービス。

### 8.1 Cloudflare KV (Key-Value Storage)
```
概要:
• 低レイテンシのキーバリューストア
• グローバルに分散
• Eventual Consistency

用途:
• セッション管理
• キャッシュデータ
• 設定情報
• ユーザープリファレンス

使用例:
const { KV } = c.env

// 保存（TTL: 1時間）
await KV.put('session:user123', JSON.stringify(userData), {
  expirationTtl: 3600
})

// 取得
const data = await KV.get('session:user123', 'json')

// 削除
await KV.delete('session:user123')

// 一覧取得（プレフィックス検索）
const list = await KV.list({ prefix: 'session:' })

料金:
• Free: 100,000 read/日、1,000 write/日、1GB storage
• Paid: $0.50/100万 read、$5.00/100万 write、$0.50/GB/月
```

### 8.2 Cloudflare Durable Objects
```
概要:
• ステートフルなサーバーレス関数
• Strong Consistency保証
• WebSocket対応

用途:
• リアルタイムチャット
• 協調編集（Google Docs風）
• ゲームサーバー
• リアルタイムダッシュボード

使用例:
export class ChatRoom {
  constructor(state, env) {
    this.state = state
    this.sessions = []
  }
  
  async fetch(request) {
    // WebSocket接続処理
    const upgradeHeader = request.headers.get('Upgrade')
    if (upgradeHeader === 'websocket') {
      const pair = new WebSocketPair()
      this.sessions.push(pair[1])
      return new Response(null, { status: 101, webSocket: pair[0] })
    }
    return new Response('Not a WebSocket request', { status: 400 })
  }
  
  broadcast(message) {
    this.sessions.forEach(ws => ws.send(message))
  }
}

料金:
• $0.15/100万リクエスト
• $12.50/GB-月（メモリ使用量）
```

### 8.3 Cloudflare Stream
```
概要:
• ビデオストリーミングプラットフォーム
• エンコーディング自動化
• HLS/DASH配信

用途:
• 動画配信サービス
• ライブストリーミング
• 録画コンテンツ

料金:
• $1.00/1000分の動画保存
• $1.00/1000分の視聴時間
```

### 8.4 Cloudflare Images
```
概要:
• 画像最適化サービス
• リアルタイムリサイズ
• 変換・圧縮

用途:
• 商品画像
• ユーザーアバター
• サムネイル生成

機能:
• WebP/AVIF変換
• サイズ指定リサイズ
• 透かし追加
• トリミング

料金:
• $5/月で10万画像まで
• $1/1万画像（追加）
```

### 8.5 Cloudflare Queues
```
概要:
• メッセージキューサービス
• 非同期処理

用途:
• バックグラウンド処理
• イベント駆動アーキテクチャ
• メール送信キュー
• バッチ処理

使用例:
// メッセージを送信
await env.QUEUE.send({
  type: 'email',
  to: 'user@example.com',
  subject: 'Welcome!'
})

// Consumer Workerで処理
export default {
  async queue(batch, env) {
    for (const message of batch.messages) {
      await sendEmail(message.body)
    }
  }
}

料金:
• Free: 100万操作/月
• Paid: $0.40/100万操作
```

### 8.6 Cloudflare Email Routing
```
概要:
• カスタムドメインのメール転送
• 無料

用途:
• info@example.com → your-email@gmail.com
• support@example.com → support-team@company.com

設定:
1. ドメインをCloudflareに追加
2. Email Routingを有効化
3. 転送ルールを設定

料金:
• 完全無料 🎉
```

### 8.7 Cloudflare DNS
```
概要:
• 高速DNSサービス
• 世界最速（1.1.1.1）

機能:
• Aレコード、CNAMEレコード、MXレコードなど
• DNSSEC対応
• DDoS保護

料金:
• 無料
```

---

## 9. コスト最適化のヒント

### 9.1 無料枠の活用
```
Pages:
• 500ビルド/月まで無料
• リクエスト数無制限

Workers:
• 10万リクエスト/日まで無料
• 超過後も$5で1000万リクエスト

D1:
• 5GB、500万行読み取り/日まで無料

R2:
• 10GB storage無料
• Egress（転送）完全無料

→ 小〜中規模サイトなら完全無料で運用可能
```

### 9.2 キャッシュ戦略
```
• 静的ファイルは長期キャッシュ（max-age=31536000）
• APIレスポンスは適切にキャッシュ（max-age=60〜3600）
• Originへのリクエストを減らす → D1読み取り削減
• Cache APIを活用
```

### 9.3 データベース最適化
```
• インデックスを適切に設定
• N+1問題を避ける（JOIN活用）
• 頻繁にアクセスするデータはKVにキャッシュ
• バッチクエリを活用（DB.batch()）
```

### 9.4 R2活用
```
• 大容量ファイルはR2に保存（D1に保存しない）
• Egress無料なので、他クラウドからの移行でコスト削減
• 画像はR2 + Cloudflare Imagesの組み合わせ
```

---

## 10. トラブルシューティング

### 10.1 よくある問題

#### Workers CPU時間超過
```
問題:
Error: CPU time limit exceeded

原因:
• 重い計算処理
• 大量のデータベースクエリ
• 無限ループ

解決策:
• 処理を分割（Queueを使用）
• キャッシュを活用
• アルゴリズム最適化
• Paid Planにアップグレード（30ms）
```

#### D1レスポンス遅延
```
問題:
クエリが遅い（1秒以上）

原因:
• インデックス未設定
• N+1問題
• 大量データのフルスキャン

解決策:
• EXPLAIN QUERY PLANで分析
• 適切なインデックス作成
• JOINでN+1解消
• ページネーション実装
```

#### R2アップロード失敗
```
問題:
413 Payload Too Large

原因:
• 100MB超のファイルを単一リクエストでアップロード

解決策:
• マルチパートアップロード使用
• クライアント側で分割
```

### 10.2 デバッグ方法
```bash
# リアルタイムログ確認
npx wrangler pages deployment tail

# ローカル開発
npm run dev  # または wrangler pages dev

# D1データベースの確認
npx wrangler d1 execute webapp-production --remote \
  --command="SELECT * FROM bookings LIMIT 10"

# Workers実行ログ
# Cloudflare Dashboard > Workers & Pages > プロジェクト > Logs
```

---

## まとめ

Cloudflareのサービスは以下の特徴があります：

✅ **グローバルエッジネットワーク**
  - 世界中300+データセンターで実行
  - 低レイテンシ（10-50ms）

✅ **コスト効率**
  - 無料枠が非常に大きい
  - R2はEgress無料（他クラウドと比較して圧倒的に安い）

✅ **開発者体験**
  - Wrangler CLIで簡単デプロイ
  - TypeScriptネイティブ対応
  - ローカル開発環境

✅ **セキュリティ**
  - DDoS保護自動
  - WAF標準装備
  - SSL証明書自動発行

このドキュメントを参考に、必要に応じて追加サービスを導入してください。

---

**最終更新**: 2026-03-12  
**バージョン**: 1.0  
**プロジェクト**: keiokanko_event_html
