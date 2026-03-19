# AWS EC2 vs Lambda アーキテクチャ比較

## 📊 3つのアプローチ比較

### オプション1: Lambda + API Gateway（既存提案）
### オプション2: EC2 + Node.js/Express
### オプション3: EC2 + Hono（推奨）✨

---

## 🏗️ アーキテクチャ比較

### オプション1: Lambda + API Gateway

```
Cloudflare Workers/Pages
        ↓ HTTPS
   API Gateway (28エンドポイント)
        ↓
   Lambda Functions (28個の関数)
        ↓ VPC Private
   RDS MySQL
```

**特徴:**
- ✅ サーバーレス（サーバー管理不要）
- ✅ 自動スケーリング
- ❌ コールドスタート（初回50-500ms）
- ❌ 28個の関数管理が必要
- ❌ API Gateway追加コスト

**コスト:** $47/月

---

### オプション2: EC2 + Node.js/Express

```
Cloudflare Workers/Pages
        ↓ HTTPS
   Application Load Balancer (ALB)
        ↓
   EC2 Instance (Node.js + Express)
   ├─ PM2でプロセス管理
   └─ Nginx リバースプロキシ
        ↓ VPC Private
   RDS MySQL
```

**特徴:**
- ✅ シンプル（1つのExpressアプリ）
- ✅ コールドスタートなし
- ✅ フルコントロール
- ❌ サーバー管理必要
- ❌ スケーリングは手動

**コスト:** $25-40/月

---

### オプション3: EC2 + Hono（推奨）✨

```
Cloudflare Workers/Pages
        ↓ HTTPS
   Application Load Balancer (ALB)
        ↓
   EC2 Instance (Node.js + Hono)
   ├─ PM2でプロセス管理
   └─ @hono/node-server
        ↓ VPC Private
   RDS MySQL
```

**特徴:**
- ✅ シンプル（1つのHonoアプリ）
- ✅ コールドスタートなし
- ✅ **Honoの知識をそのまま活用**
- ✅ 既存コード構造を維持
- ✅ 軽量・高速（Expressより速い）
- ❌ サーバー管理必要（最小限）

**コスト:** $25-40/月

---

## 🎯 推奨: EC2 + Hono

### なぜHonoをEC2で動かすのが最適か

#### 1. **既存コードの再利用**

現在のCloudflare Workers版コードをほぼそのまま使える：

```typescript
// 現在のindex.tsx（Cloudflare Workers版）
import { Hono } from 'hono'

const app = new Hono<{ Bindings: Bindings }>()

app.get('/api/events', async (c) => {
  const DB = c.env.DB  // Cloudflare D1
  // ...
})

export default app
```

```typescript
// EC2版（ほぼ同じコード）
import { Hono } from 'hono'
import { serve } from '@hono/node-server'
import mysql from 'mysql2/promise'

const app = new Hono()

// データベース接続プール
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  connectionLimit: 10
})

app.get('/api/events', async (c) => {
  const [rows] = await pool.execute('SELECT * FROM events')
  return c.json({ results: rows })
})

// Node.jsサーバーとして起動
serve({
  fetch: app.fetch,
  port: 3000
})
```

#### 2. **開発効率**

| 項目 | Lambda + API Gateway | EC2 + Hono |
|------|---------------------|-----------|
| 関数数 | 28個 | 1つのアプリ |
| デプロイ | 28回（または一括スクリプト） | 1回 |
| ローカル開発 | 複雑（SAM/Serverless Framework） | 簡単（npm run dev） |
| デバッグ | 難しい（CloudWatch Logs） | 簡単（ローカルログ） |
| トランザクション | 難しい（Lambda間調整） | 簡単（アプリ内完結） |

#### 3. **パフォーマンス**

```
Lambda:
├─ コールドスタート: 50-500ms（初回）
├─ ウォームスタート: 1-5ms
└─ API Gateway経由: +10-30ms

EC2 + Hono:
├─ 常時起動: 0ms（待機なし）
├─ レスポンス: 5-20ms
└─ ALB経由: +5-10ms

結果: EC2の方が安定して速い
```

#### 4. **コスト**

```
【Lambda + API Gateway】
RDS (db.t3.small):        $35/月
Lambda:                   $2.50/月
API Gateway:              $3.50/月
その他:                   $6/月
────────────────────────────────
合計:                     $47/月

【EC2 + Hono】
RDS (db.t3.small):        $35/月
EC2 (t3.small):           $15/月
ALB:                      $16/月
その他:                   $3/月
────────────────────────────────
合計:                     $69/月

注: ALB不要の場合 $53/月
```

---

## 🏗️ EC2 + Hono 詳細設計

### アーキテクチャ図

```
┌─────────────────────────────────────────────────────────────┐
│                     ユーザー                                  │
└─────────────────────────────────────────────────────────────┘
                            ↓ HTTPS
┌─────────────────────────────────────────────────────────────┐
│              Cloudflare Pages/Workers                        │
│  - フロントエンド（HTML/CSS/JS）                              │
│  - SSR（Server-Side Rendering）                              │
│  - 認証・セッション管理                                        │
│  - ビジネスロジック                                           │
└─────────────────────────────────────────────────────────────┘
                            ↓ HTTPS (REST API)
┌─────────────────────────────────────────────────────────────┐
│         Application Load Balancer (ALB) - オプション          │
│  - ヘルスチェック                                             │
│  - SSL/TLS終端                                               │
│  - Auto Scaling連携                                          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              EC2 Instance (t3.small)                         │
│                                                              │
│  ┌────────────────────────────────────────────┐             │
│  │  Node.js 20.x + Hono                       │             │
│  │  ├─ @hono/node-server                      │             │
│  │  ├─ mysql2/promise                         │             │
│  │  └─ PM2 (プロセス管理)                     │             │
│  └────────────────────────────────────────────┘             │
│                                                              │
│  Port 3000: Hono API Server                                 │
│  - 288 API routes                                           │
│  - MySQL接続プール                                           │
│  - トランザクション管理                                       │
└─────────────────────────────────────────────────────────────┘
                            ↓ VPC Private Network
┌─────────────────────────────────────────────────────────────┐
│              AWS RDS MySQL                                   │
│  - db.t3.small (2vCPU, 2GB RAM)                             │
│  - 100GB ストレージ (gp3)                                     │
│  - Multi-AZ（高可用性）                                       │
│  - 自動バックアップ（7日間保持）                               │
└─────────────────────────────────────────────────────────────┘
```

### EC2インスタンス構成

#### インスタンスタイプ選択

| タイプ | vCPU | RAM | 料金/月 | 推奨用途 |
|--------|------|-----|---------|---------|
| **t3.micro** | 2 | 1GB | $7.59 | 開発・テスト |
| **t3.small** | 2 | 2GB | **$15.18** | **本番（推奨）** |
| **t3.medium** | 2 | 4GB | $30.37 | 高トラフィック |
| **t3.large** | 2 | 8GB | $60.74 | 大規模 |

#### ソフトウェアスタック

```
OS: Ubuntu 22.04 LTS
Node.js: 20.x LTS
パッケージマネージャー: npm
プロセス管理: PM2
リバースプロキシ: Nginx (オプション)
監視: CloudWatch Agent
```

---

## 💻 実装コード

### 1. EC2版 Hono アプリケーション

```typescript
// ec2-api/src/index.ts
import { Hono } from 'hono'
import { serve } from '@hono/node-server'
import { cors } from 'hono/cors'
import { logger } from 'hono/logger'
import mysql from 'mysql2/promise'

// MySQL接続プール
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  connectionLimit: 10,
  waitForConnections: true,
  queueLimit: 0
})

const app = new Hono()

// ミドルウェア
app.use('*', logger())
app.use('/api/*', cors())

// API Key認証ミドルウェア
app.use('/api/*', async (c, next) => {
  const apiKey = c.req.header('X-API-Key')
  
  if (apiKey !== process.env.API_KEY) {
    return c.json({ error: 'Unauthorized' }, 401)
  }
  
  await next()
})

// ヘルスチェック
app.get('/health', (c) => {
  return c.json({ status: 'ok', timestamp: new Date().toISOString() })
})

// Events API
app.get('/api/events', async (c) => {
  try {
    const page = parseInt(c.req.query('page') || '1')
    const perPage = parseInt(c.req.query('per_page') || '50')
    const name = c.req.query('name')
    const offset = (page - 1) * perPage

    const conditions: string[] = []
    const values: any[] = []

    if (name) {
      conditions.push('name LIKE ?')
      values.push(`%${name}%`)
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : ''

    // カウントクエリ
    const [countRows] = await pool.execute(
      `SELECT COUNT(*) as total FROM events ${whereClause}`,
      values
    )
    const total = (countRows as any)[0].total

    // データクエリ
    const [rows] = await pool.execute(
      `SELECT * FROM events ${whereClause} ORDER BY id DESC LIMIT ? OFFSET ?`,
      [...values, perPage, offset]
    )

    return c.json({
      results: rows,
      pagination: {
        total,
        page,
        perPage,
        totalPages: Math.ceil(total / perPage)
      }
    })
  } catch (error) {
    console.error('Database error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

app.get('/api/events/:id', async (c) => {
  try {
    const eventId = parseInt(c.req.param('id'))
    
    const [rows] = await pool.execute(
      'SELECT * FROM events WHERE id = ?',
      [eventId]
    )

    if ((rows as any[]).length === 0) {
      return c.json({ error: 'Event not found' }, 404)
    }

    return c.json((rows as any[])[0])
  } catch (error) {
    console.error('Database error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

app.post('/api/events', async (c) => {
  try {
    const data = await c.req.json()
    
    const [result] = await pool.execute(
      `INSERT INTO events (name, detail, event_start_date, event_end_date, client_id) 
       VALUES (?, ?, ?, ?, ?)`,
      [data.name, data.detail, data.event_start_date, data.event_end_date, data.client_id]
    )

    const insertId = (result as any).insertId

    const [rows] = await pool.execute(
      'SELECT * FROM events WHERE id = ?',
      [insertId]
    )

    return c.json((rows as any[])[0], 201)
  } catch (error) {
    console.error('Database error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

// Bookings API（トランザクション例）
app.post('/api/bookings', async (c) => {
  const connection = await pool.getConnection()
  
  try {
    await connection.beginTransaction()
    
    const data = await c.req.json()

    // 予約作成
    const [bookingResult] = await connection.execute(
      `INSERT INTO bookings (event_id, member_id, booking_date, status, total_amount) 
       VALUES (?, ?, NOW(), 'pending', ?)`,
      [data.event_id, data.member_id, data.total_amount]
    )
    const bookingId = (bookingResult as any).insertId

    // 予約アイテム作成
    for (const item of data.items) {
      await connection.execute(
        `INSERT INTO booking_items (booking_id, product_id, quantity, unit_price, subtotal) 
         VALUES (?, ?, ?, ?, ?)`,
        [bookingId, item.product_id, item.quantity, item.unit_price, item.subtotal]
      )
    }

    // 決済レコード作成
    if (data.payment) {
      await connection.execute(
        `INSERT INTO booking_payments (booking_id, payment_method, amount, status) 
         VALUES (?, ?, ?, 'pending')`,
        [bookingId, data.payment.method, data.payment.amount]
      )
    }

    await connection.commit()

    // 作成された予約を取得
    const [bookings] = await connection.execute(
      'SELECT * FROM bookings WHERE id = ?',
      [bookingId]
    )

    return c.json((bookings as any[])[0], 201)
  } catch (error) {
    await connection.rollback()
    console.error('Transaction error:', error)
    return c.json({ error: 'Transaction failed' }, 500)
  } finally {
    connection.release()
  }
})

// ... 他の288ルートを同様に実装

// サーバー起動
const port = parseInt(process.env.PORT || '3000')

console.log(`🚀 Hono API Server starting on port ${port}`)

serve({
  fetch: app.fetch,
  port
})
```

### 2. PM2設定

```javascript
// ecosystem.config.cjs
module.exports = {
  apps: [
    {
      name: 'webapp-api',
      script: 'dist/index.js',
      instances: 'max',  // CPUコア数に応じて自動
      exec_mode: 'cluster',
      watch: false,
      max_memory_restart: '500M',
      env: {
        NODE_ENV: 'production',
        PORT: 3000,
        DB_HOST: 'webapp-production.xxxxx.rds.amazonaws.com',
        DB_USER: 'admin',
        DB_PASSWORD: 'your-secure-password',
        DB_NAME: 'webapp',
        API_KEY: 'your-api-key'
      },
      error_file: './logs/error.log',
      out_file: './logs/out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true
    }
  ]
}
```

### 3. package.json

```json
{
  "name": "webapp-ec2-api",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "pm2:start": "pm2 start ecosystem.config.cjs",
    "pm2:stop": "pm2 stop webapp-api",
    "pm2:restart": "pm2 restart webapp-api",
    "pm2:logs": "pm2 logs webapp-api --nostream",
    "pm2:monit": "pm2 monit"
  },
  "dependencies": {
    "hono": "^4.0.0",
    "@hono/node-server": "^1.0.0",
    "mysql2": "^3.6.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "tsx": "^4.0.0",
    "typescript": "^5.0.0"
  }
}
```

### 4. Nginx設定（オプション）

```nginx
# /etc/nginx/sites-available/webapp-api
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # ヘルスチェック
    location /health {
        proxy_pass http://localhost:3000/health;
        access_log off;
    }
}
```

---

## 🚀 デプロイ手順

### ステップ1: EC2インスタンス作成

```bash
# AWS CLI
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \  # Ubuntu 22.04
  --instance-type t3.small \
  --key-name your-key-pair \
  --security-group-ids sg-xxxxx \
  --subnet-id subnet-xxxxx \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=webapp-api}]'
```

### ステップ2: EC2環境セットアップ

```bash
# SSH接続
ssh -i your-key.pem ubuntu@ec2-xxx.compute.amazonaws.com

# Node.js 20.x インストール
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# PM2インストール
sudo npm install -g pm2

# アプリディレクトリ作成
mkdir -p /home/ubuntu/webapp-api
cd /home/ubuntu/webapp-api
```

### ステップ3: アプリケーションデプロイ

```bash
# ローカルでビルド
npm run build

# EC2へアップロード
scp -i your-key.pem -r dist package.json ecosystem.config.cjs \
  ubuntu@ec2-xxx:/home/ubuntu/webapp-api/

# EC2で依存関係インストール
ssh -i your-key.pem ubuntu@ec2-xxx
cd /home/ubuntu/webapp-api
npm install --production

# PM2起動
pm2 start ecosystem.config.cjs

# 起動確認
pm2 list
pm2 logs webapp-api --nostream

# 自動起動設定
pm2 startup
pm2 save
```

### ステップ4: CloudWatch Agent設定

```bash
# CloudWatch Agentインストール
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb

# 設定ファイル作成
sudo vi /opt/aws/amazon-cloudwatch-agent/etc/config.json
```

```json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ubuntu/webapp-api/logs/error.log",
            "log_group_name": "/aws/ec2/webapp-api/error",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/home/ubuntu/webapp-api/logs/out.log",
            "log_group_name": "/aws/ec2/webapp-api/out",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "WebApp/EC2",
    "metrics_collected": {
      "cpu": {
        "measurement": [{"name": "cpu_usage_idle"}],
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": [{"name": "mem_used_percent"}],
        "metrics_collection_interval": 60
      }
    }
  }
}
```

```bash
# Agent起動
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json
```

---

## 📊 比較表

### 機能比較

| 項目 | Lambda + API Gateway | EC2 + Hono |
|------|---------------------|-----------|
| **開発効率** | ⭐⭐ 28関数管理 | ⭐⭐⭐⭐⭐ 1アプリ |
| **デプロイ** | ⭐⭐ 複雑 | ⭐⭐⭐⭐⭐ シンプル |
| **ローカル開発** | ⭐⭐ 難しい | ⭐⭐⭐⭐⭐ 簡単 |
| **コールドスタート** | ⭐⭐ あり（50-500ms） | ⭐⭐⭐⭐⭐ なし |
| **レスポンス速度** | ⭐⭐⭐ 50-200ms | ⭐⭐⭐⭐ 10-50ms |
| **トランザクション** | ⭐⭐ 難しい | ⭐⭐⭐⭐⭐ 簡単 |
| **スケーラビリティ** | ⭐⭐⭐⭐⭐ 自動 | ⭐⭐⭐ Auto Scaling |
| **サーバー管理** | ⭐⭐⭐⭐⭐ 不要 | ⭐⭐⭐ 必要 |
| **コスト（低トラフィック）** | ⭐⭐⭐⭐ $47/月 | ⭐⭐⭐⭐⭐ $50/月 |
| **コスト（高トラフィック）** | ⭐⭐ 増加 | ⭐⭐⭐⭐⭐ 固定 |
| **既存コード流用** | ⭐⭐ 大幅修正 | ⭐⭐⭐⭐⭐ ほぼそのまま |

### コスト比較（月間リクエスト数別）

| リクエスト数/月 | Lambda + API Gateway | EC2 + Hono (t3.small) |
|----------------|---------------------|----------------------|
| **100万** | $47 | $50 |
| **500万** | $72 | $50 |
| **1,000万** | $127 | $50 |
| **5,000万** | $547 | $80（t3.mediumへ） |

---

## 🎯 最終推奨

### **EC2 + Hono を推奨します**

#### 理由:

1. **シンプル**: 1つのHonoアプリケーション、28個のLambda関数不要
2. **高速**: コールドスタートなし、安定したレスポンス
3. **既存コード流用**: Cloudflare Workers版のコードをほぼそのまま使える
4. **トランザクション**: アプリ内で完結、複雑な分散トランザクション不要
5. **コスト**: 低〜中トラフィックでは同等、高トラフィックでは大幅に安い
6. **開発効率**: ローカル開発が簡単、デバッグも容易

#### デメリット:

1. サーバー管理が必要（ただし、PM2で自動再起動、CloudWatchで監視）
2. 手動スケーリング（ただし、Auto Scalingグループで自動化可能）

---

## 🚀 次のステップ

### Week 1: EC2環境構築
- [ ] EC2インスタンス作成（t3.small）
- [ ] セキュリティグループ設定
- [ ] Node.js + PM2インストール
- [ ] CloudWatch Agent設定

### Week 2: Honoアプリ開発
- [ ] 既存index.tsxからAPI部分を抽出
- [ ] MySQL接続プール実装
- [ ] 288ルートの実装
- [ ] トランザクション処理実装

### Week 3: RDS構築とデータ移行
- [ ] RDS MySQL作成
- [ ] マイグレーション実行
- [ ] データインポート
- [ ] 接続テスト

### Week 4: 統合テスト・本番移行
- [ ] Cloudflare側コード修正
- [ ] 統合テスト
- [ ] パフォーマンステスト
- [ ] 本番切替

---

**質問**: EC2 + Hono アプローチで進めますか？
