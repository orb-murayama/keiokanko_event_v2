# EC2 + Hono 実装計画書

## 📋 プロジェクト概要

### 目的
Cloudflare D1（500MB制限）から AWS RDS MySQL（最大64TB）へ移行し、EC2上でHonoベースのAPIサーバーを構築することで、長期運用に耐えうるスケーラブルなシステムを実現する。

### アーキテクチャ
```
ユーザー
  ↓ HTTPS
Cloudflare Pages/Workers
  ├─ フロントエンド（HTML/CSS/JS）
  ├─ SSR（Server-Side Rendering）
  ├─ 認証・セッション管理
  └─ ビジネスロジック
  ↓ HTTPS REST API
AWS EC2 (Hono API Server)
  ├─ Node.js 20.x
  ├─ Hono Framework
  ├─ MySQL接続プール
  └─ PM2プロセス管理
  ↓ VPC Private Network
AWS RDS MySQL
  ├─ db.t3.small (2vCPU, 2GB RAM)
  ├─ 100GB ストレージ (gp3)
  └─ Multi-AZ（高可用性）
```

### 期間
**合計: 4週間**（2026年3月10日 〜 2026年4月6日）

### 予算
**月額運用コスト**: $50-66/月
- AWS EC2 (t3.small): $15/月
- AWS RDS MySQL (db.t3.small): $35/月
- Application Load Balancer (オプション): $16/月
- データ転送・CloudWatch: $0-5/月

---

## 🗓️ 詳細スケジュール

## 【Week 1】フェーズ1: AWS環境構築

### Day 1-2: RDS MySQL環境構築

#### 1. VPC・セキュリティグループ作成

```bash
# VPC作成
aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=webapp-vpc}]'

# パブリックサブネット作成（EC2用）
aws ec2 create-subnet \
  --vpc-id vpc-xxxxx \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=webapp-public-1a}]'

# プライベートサブネット作成（RDS用）
aws ec2 create-subnet \
  --vpc-id vpc-xxxxx \
  --cidr-block 10.0.2.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=webapp-private-1a}]'

aws ec2 create-subnet \
  --vpc-id vpc-xxxxx \
  --cidr-block 10.0.3.0/24 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=webapp-private-1b}]'

# DBサブネットグループ作成
aws rds create-db-subnet-group \
  --db-subnet-group-name webapp-db-subnet \
  --db-subnet-group-description "Webapp DB Subnet Group" \
  --subnet-ids subnet-xxxxx subnet-yyyyy

# セキュリティグループ作成（EC2用）
aws ec2 create-security-group \
  --group-name webapp-ec2-sg \
  --description "Security group for webapp EC2" \
  --vpc-id vpc-xxxxx

# EC2セキュリティグループルール追加
aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxx \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0  # SSH（本番では制限推奨）

aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxx \
  --protocol tcp \
  --port 3000 \
  --cidr 0.0.0.0/0  # API Server

# セキュリティグループ作成（RDS用）
aws ec2 create-security-group \
  --group-name webapp-rds-sg \
  --description "Security group for webapp RDS" \
  --vpc-id vpc-xxxxx

# RDSセキュリティグループルール追加（EC2からのみ接続許可）
aws ec2 authorize-security-group-ingress \
  --group-id sg-yyyyy \
  --protocol tcp \
  --port 3306 \
  --source-group sg-xxxxx  # EC2のセキュリティグループ
```

#### 2. RDS MySQL インスタンス作成

```bash
# RDS MySQL作成
aws rds create-db-instance \
  --db-instance-identifier webapp-production \
  --db-instance-class db.t3.small \
  --engine mysql \
  --engine-version 8.0.35 \
  --master-username admin \
  --master-user-password 'YourSecurePassword123!' \
  --allocated-storage 100 \
  --storage-type gp3 \
  --storage-encrypted \
  --backup-retention-period 7 \
  --preferred-backup-window "03:00-04:00" \
  --preferred-maintenance-window "Mon:04:00-Mon:05:00" \
  --vpc-security-group-ids sg-yyyyy \
  --db-subnet-group-name webapp-db-subnet \
  --publicly-accessible false \
  --multi-az false \
  --tags Key=Environment,Value=Production Key=Project,Value=webapp

# 作成完了まで待機（約10-15分）
aws rds wait db-instance-available \
  --db-instance-identifier webapp-production

# エンドポイント確認
aws rds describe-db-instances \
  --db-instance-identifier webapp-production \
  --query 'DBInstances[0].Endpoint.Address' \
  --output text
# 出力例: webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com
```

#### 3. パラメータグループ設定

```bash
# パラメータグループ作成
aws rds create-db-parameter-group \
  --db-parameter-group-name webapp-mysql80 \
  --db-parameter-group-family mysql8.0 \
  --description "webapp MySQL 8.0 parameters"

# UTF8MB4設定
aws rds modify-db-parameter-group \
  --db-parameter-group-name webapp-mysql80 \
  --parameters \
    "ParameterName=character_set_server,ParameterValue=utf8mb4,ApplyMethod=immediate" \
    "ParameterName=collation_server,ParameterValue=utf8mb4_unicode_ci,ApplyMethod=immediate" \
    "ParameterName=max_connections,ParameterValue=500,ApplyMethod=immediate"

# RDSインスタンスにパラメータグループ適用
aws rds modify-db-instance \
  --db-instance-identifier webapp-production \
  --db-parameter-group-name webapp-mysql80 \
  --apply-immediately
```

#### 4. 接続テスト

```bash
# MySQLクライアントインストール（ローカル）
# macOS
brew install mysql-client

# Ubuntu/Debian
sudo apt-get install mysql-client

# 接続テスト
mysql -h webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p \
      -e "SELECT VERSION();"

# データベース作成
mysql -h webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p \
      -e "CREATE DATABASE webapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

**成果物:**
- ✅ VPC、サブネット、セキュリティグループ設定完了
- ✅ RDS MySQL インスタンス稼働
- ✅ データベース`webapp`作成完了
- ✅ 接続確認完了

---

### Day 3-4: EC2インスタンス構築

#### 1. EC2キーペア作成

```bash
# キーペア作成
aws ec2 create-key-pair \
  --key-name webapp-key \
  --query 'KeyMaterial' \
  --output text > webapp-key.pem

# パーミッション変更
chmod 400 webapp-key.pem
```

#### 2. EC2インスタンス起動

```bash
# EC2インスタンス作成
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.small \
  --key-name webapp-key \
  --security-group-ids sg-xxxxx \
  --subnet-id subnet-xxxxx \
  --associate-public-ip-address \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=webapp-api}]' \
  --user-data file://ec2-user-data.sh

# インスタンスID取得
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=webapp-api" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text)

# 起動完了まで待機
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# パブリックIP取得
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "EC2 Public IP: $PUBLIC_IP"
```

#### 3. EC2初期セットアップスクリプト（ec2-user-data.sh）

```bash
#!/bin/bash
# ec2-user-data.sh

# システムアップデート
apt-get update
apt-get upgrade -y

# Node.js 20.x インストール
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# PM2インストール
npm install -g pm2

# アプリケーションディレクトリ作成
mkdir -p /home/ubuntu/webapp-api
chown -R ubuntu:ubuntu /home/ubuntu/webapp-api

# CloudWatch Agent インストール
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb

# ログディレクトリ作成
mkdir -p /home/ubuntu/webapp-api/logs
chown -R ubuntu:ubuntu /home/ubuntu/webapp-api/logs

echo "EC2 setup completed"
```

#### 4. SSH接続確認

```bash
# SSH接続
ssh -i webapp-key.pem ubuntu@$PUBLIC_IP

# Node.jsバージョン確認
node --version  # v20.x.x

# PM2バージョン確認
pm2 --version
```

**成果物:**
- ✅ EC2インスタンス（t3.small）起動完了
- ✅ Node.js 20.x インストール完了
- ✅ PM2インストール完了
- ✅ SSH接続確認完了

---

### Day 5: マイグレーションファイル変換

#### 1. SQLite → MySQL変換

```bash
cd /home/user/webapp

# 変換用ディレクトリ作成
mkdir -p migrations-mysql

# 変換スクリプト作成
cat > convert-migrations.sh << 'EOF'
#!/bin/bash

for file in migrations/*.sql; do
  filename=$(basename "$file")
  
  # SQLite → MySQL変換
  sed -e 's/INTEGER PRIMARY KEY AUTOINCREMENT/INT AUTO_INCREMENT PRIMARY KEY/g' \
      -e "s/datetime('now','localtime')/CURRENT_TIMESTAMP/g" \
      -e "s/datetime('now')/CURRENT_TIMESTAMP/g" \
      -e 's/DATETIME DEFAULT (datetime[^)]*)/DATETIME DEFAULT CURRENT_TIMESTAMP/g' \
      -e 's/\bTEXT\b/VARCHAR(2000)/g' \
      -e 's/\bINTEGER\b/INT/g' \
      "$file" > "migrations-mysql/$filename"
  
  echo "Converted: $filename"
done

echo "Migration conversion completed"
EOF

chmod +x convert-migrations.sh
./convert-migrations.sh
```

#### 2. 変換ファイルの手動確認・修正

```bash
# 変換結果確認
ls -lh migrations-mysql/

# 主要マイグレーションファイルの確認
cat migrations-mysql/0000_consolidated_schema.sql | head -50
```

**手動確認が必要な項目:**
- [ ] JSON型フィールドの変換（TEXTのままでOKか、JSON型にするか）
- [ ] 外部キー制約の構文
- [ ] インデックス定義
- [ ] トリガー（あれば）
- [ ] ストアドプロシージャ（あれば）

#### 3. RDSへのマイグレーション実行

```bash
# マイグレーション実行
cd migrations-mysql

for file in *.sql; do
  echo "Applying $file..."
  mysql -h webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com \
        -u admin -p webapp < "$file"
  
  if [ $? -eq 0 ]; then
    echo "✓ $file applied successfully"
  else
    echo "✗ $file failed"
    exit 1
  fi
done

# テーブル一覧確認
mysql -h webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp \
      -e "SHOW TABLES;"

# テーブル数確認
mysql -h webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp \
      -e "SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema = 'webapp';"

# 期待値: 40 tables
```

**成果物:**
- ✅ migrations-mysql/ ディレクトリ（19ファイル）
- ✅ 変換済みDDL検証完了
- ✅ 全40テーブル作成完了
- ✅ インデックス設定完了

---

## 【Week 2】フェーズ2: Honoアプリケーション開発

### Day 6-7: プロジェクト構造構築

#### 1. プロジェクトディレクトリ作成

```bash
cd /home/user/webapp

# EC2 API用ディレクトリ作成
mkdir -p ec2-api/{src,logs,scripts}
cd ec2-api
```

#### 2. package.json作成

```json
{
  "name": "webapp-ec2-api",
  "version": "1.0.0",
  "type": "module",
  "description": "Webapp API Server on EC2 with Hono",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "lint": "eslint src --ext .ts",
    "test": "vitest",
    "pm2:start": "pm2 start ecosystem.config.cjs",
    "pm2:stop": "pm2 stop webapp-api",
    "pm2:restart": "pm2 restart webapp-api",
    "pm2:delete": "pm2 delete webapp-api",
    "pm2:logs": "pm2 logs webapp-api --nostream",
    "pm2:monit": "pm2 monit",
    "pm2:save": "pm2 save"
  },
  "dependencies": {
    "hono": "^4.10.6",
    "@hono/node-server": "^1.13.7",
    "mysql2": "^3.11.5"
  },
  "devDependencies": {
    "@types/node": "^20.17.11",
    "tsx": "^4.19.2",
    "typescript": "^5.7.2",
    "vitest": "^2.1.8"
  }
}
```

#### 3. TypeScript設定

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "moduleResolution": "bundler",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

#### 4. PM2設定

```javascript
// ecosystem.config.cjs
module.exports = {
  apps: [
    {
      name: 'webapp-api',
      script: 'dist/index.js',
      instances: 'max',  // CPUコア数（t3.smallは2コア）
      exec_mode: 'cluster',
      watch: false,
      max_memory_restart: '500M',
      env: {
        NODE_ENV: 'production',
        PORT: 3000,
        DB_HOST: 'webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com',
        DB_USER: 'admin',
        DB_PASSWORD: 'YourSecurePassword123!',
        DB_NAME: 'webapp',
        API_KEY: 'your-secure-api-key-here'  // Cloudflare側と共有
      },
      error_file: './logs/error.log',
      out_file: './logs/out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true,
      min_uptime: '10s',
      max_restarts: 10,
      autorestart: true
    }
  ]
}
```

#### 5. 環境変数テンプレート

```bash
# .env.example
NODE_ENV=production
PORT=3000

# Database
DB_HOST=webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=your-password
DB_NAME=webapp
DB_CONNECTION_LIMIT=10

# API Authentication
API_KEY=your-api-key

# Logging
LOG_LEVEL=info
```

**成果物:**
- ✅ プロジェクト構造作成完了
- ✅ package.json設定完了
- ✅ TypeScript設定完了
- ✅ PM2設定完了

---

### Day 8-10: Honoアプリケーション実装

#### 1. データベース接続層（src/db.ts）

```typescript
// src/db.ts
import mysql from 'mysql2/promise'

let pool: mysql.Pool | null = null

export function getPool(): mysql.Pool {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      connectionLimit: parseInt(process.env.DB_CONNECTION_LIMIT || '10'),
      waitForConnections: true,
      queueLimit: 0,
      enableKeepAlive: true,
      keepAliveInitialDelay: 0
    })

    console.log('✓ MySQL connection pool created')
  }

  return pool
}

export async function closePool(): Promise<void> {
  if (pool) {
    await pool.end()
    pool = null
    console.log('✓ MySQL connection pool closed')
  }
}

// ヘルスチェック用
export async function checkDatabaseConnection(): Promise<boolean> {
  try {
    const pool = getPool()
    const [rows] = await pool.execute('SELECT 1')
    return true
  } catch (error) {
    console.error('Database connection check failed:', error)
    return false
  }
}
```

#### 2. 型定義（src/types.ts）

```typescript
// src/types.ts
export interface Event {
  id: number
  name: string
  detail?: string
  event_start_date?: string
  event_end_date?: string
  client_id?: number
  vendor_id?: number
  branch_code?: string
  enable_flg: number
  created_at: string
  updated_at: string
}

export interface EventListParams {
  page?: number
  per_page?: number
  name?: string
  client_id?: number
  vendor_id?: number
  branch_code?: string
  enable_flg?: number
  sort?: string
  order?: 'asc' | 'desc'
}

export interface PaginationResult<T> {
  results: T[]
  pagination: {
    total: number
    page: number
    per_page: number
    total_pages: number
  }
}

export interface Product {
  id: number
  event_id: number
  name: string
  detail?: string
  price?: number
  enable_flg: number
  created_at: string
  updated_at: string
}

export interface Booking {
  id: number
  event_id: number
  member_id: number
  booking_number: string
  booking_date: string
  status: string
  total_amount: number
  created_at: string
  updated_at: string
}

export interface BookingItem {
  id: number
  booking_id: number
  product_id: number
  quantity: number
  unit_price: number
  subtotal: number
}

export interface BookingPayment {
  id: number
  booking_id: number
  payment_method: string
  amount: number
  status: string
  transaction_id?: string
  paid_at?: string
}

// ... 他のテーブルの型定義
```

#### 3. メインアプリケーション（src/index.ts）

```typescript
// src/index.ts
import { Hono } from 'hono'
import { serve } from '@hono/node-server'
import { cors } from 'hono/cors'
import { logger } from 'hono/logger'
import { getPool, checkDatabaseConnection, closePool } from './db'
import type { Event, EventListParams, PaginationResult } from './types'

const app = new Hono()

// ミドルウェア
app.use('*', logger())
app.use('/api/*', cors({
  origin: ['https://webapp-geh.pages.dev', 'http://localhost:3000'],
  credentials: true
}))

// API Key認証ミドルウェア
app.use('/api/*', async (c, next) => {
  const apiKey = c.req.header('X-API-Key')
  
  if (!apiKey || apiKey !== process.env.API_KEY) {
    return c.json({ error: 'Unauthorized' }, 401)
  }
  
  await next()
})

// ヘルスチェック
app.get('/health', async (c) => {
  const dbConnected = await checkDatabaseConnection()
  
  return c.json({
    status: dbConnected ? 'ok' : 'degraded',
    timestamp: new Date().toISOString(),
    database: dbConnected ? 'connected' : 'disconnected'
  }, dbConnected ? 200 : 503)
})

// Events API
app.get('/api/events', async (c) => {
  try {
    const pool = getPool()
    
    // クエリパラメータ取得
    const page = parseInt(c.req.query('page') || '1')
    const perPage = parseInt(c.req.query('per_page') || '50')
    const name = c.req.query('name')
    const clientId = c.req.query('client_id')
    const vendorId = c.req.query('vendor_id')
    const branchCode = c.req.query('branch_code')
    const enableFlg = c.req.query('enable_flg')
    const sort = c.req.query('sort') || 'id'
    const order = c.req.query('order') || 'desc'
    const offset = (page - 1) * perPage

    // WHERE句構築
    const conditions: string[] = []
    const values: any[] = []

    if (name) {
      conditions.push('name LIKE ?')
      values.push(`%${name}%`)
    }

    if (clientId) {
      conditions.push('client_id = ?')
      values.push(parseInt(clientId))
    }

    if (vendorId) {
      conditions.push('vendor_id = ?')
      values.push(parseInt(vendorId))
    }

    if (branchCode) {
      conditions.push('branch_code = ?')
      values.push(branchCode)
    }

    if (enableFlg !== undefined) {
      conditions.push('enable_flg = ?')
      values.push(parseInt(enableFlg))
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
      `SELECT * FROM events ${whereClause} 
       ORDER BY ${sort} ${order} 
       LIMIT ? OFFSET ?`,
      [...values, perPage, offset]
    )

    const result: PaginationResult<Event> = {
      results: rows as Event[],
      pagination: {
        total,
        page,
        per_page: perPage,
        total_pages: Math.ceil(total / perPage)
      }
    }

    return c.json(result)
  } catch (error) {
    console.error('Events list error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

app.get('/api/events/:id', async (c) => {
  try {
    const pool = getPool()
    const eventId = parseInt(c.req.param('id'))
    
    const [rows] = await pool.execute(
      'SELECT * FROM events WHERE id = ?',
      [eventId]
    )

    const events = rows as Event[]

    if (events.length === 0) {
      return c.json({ error: 'Event not found' }, 404)
    }

    return c.json(events[0])
  } catch (error) {
    console.error('Event get error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

app.post('/api/events', async (c) => {
  try {
    const pool = getPool()
    const data = await c.req.json()
    
    const [result] = await pool.execute(
      `INSERT INTO events 
       (name, detail, event_start_date, event_end_date, client_id, vendor_id, branch_code, enable_flg) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        data.name,
        data.detail || null,
        data.event_start_date || null,
        data.event_end_date || null,
        data.client_id || null,
        data.vendor_id || null,
        data.branch_code || null,
        data.enable_flg !== undefined ? data.enable_flg : 1
      ]
    )

    const insertId = (result as any).insertId

    const [rows] = await pool.execute(
      'SELECT * FROM events WHERE id = ?',
      [insertId]
    )

    return c.json((rows as Event[])[0], 201)
  } catch (error) {
    console.error('Event create error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

app.put('/api/events/:id', async (c) => {
  try {
    const pool = getPool()
    const eventId = parseInt(c.req.param('id'))
    const data = await c.req.json()
    
    const [result] = await pool.execute(
      `UPDATE events 
       SET name = ?, detail = ?, event_start_date = ?, event_end_date = ?, 
           client_id = ?, vendor_id = ?, branch_code = ?, enable_flg = ?
       WHERE id = ?`,
      [
        data.name,
        data.detail || null,
        data.event_start_date || null,
        data.event_end_date || null,
        data.client_id || null,
        data.vendor_id || null,
        data.branch_code || null,
        data.enable_flg,
        eventId
      ]
    )

    if ((result as any).affectedRows === 0) {
      return c.json({ error: 'Event not found' }, 404)
    }

    const [rows] = await pool.execute(
      'SELECT * FROM events WHERE id = ?',
      [eventId]
    )

    return c.json((rows as Event[])[0])
  } catch (error) {
    console.error('Event update error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

app.delete('/api/events/:id', async (c) => {
  try {
    const pool = getPool()
    const eventId = parseInt(c.req.param('id'))
    
    const [result] = await pool.execute(
      'DELETE FROM events WHERE id = ?',
      [eventId]
    )

    if ((result as any).affectedRows === 0) {
      return c.json({ error: 'Event not found' }, 404)
    }

    return c.json({ message: 'Event deleted successfully' })
  } catch (error) {
    console.error('Event delete error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

// Products API（同様のパターン）
app.get('/api/products', async (c) => {
  // Events APIと同じパターンで実装
  // ...
})

// Bookings API（トランザクション例）
app.post('/api/bookings', async (c) => {
  const pool = getPool()
  const connection = await pool.getConnection()
  
  try {
    await connection.beginTransaction()
    
    const data = await c.req.json()

    // 予約作成
    const [bookingResult] = await connection.execute(
      `INSERT INTO bookings 
       (event_id, member_id, booking_date, status, total_amount) 
       VALUES (?, ?, NOW(), 'pending', ?)`,
      [data.event_id, data.member_id, data.total_amount]
    )
    const bookingId = (bookingResult as any).insertId

    // 予約アイテム作成
    for (const item of data.items) {
      await connection.execute(
        `INSERT INTO booking_items 
         (booking_id, product_id, quantity, unit_price, subtotal) 
         VALUES (?, ?, ?, ?, ?)`,
        [bookingId, item.product_id, item.quantity, item.unit_price, item.subtotal]
      )
    }

    // 決済レコード作成
    if (data.payment) {
      await connection.execute(
        `INSERT INTO booking_payments 
         (booking_id, payment_method, amount, status) 
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
    console.error('Booking transaction error:', error)
    return c.json({ error: 'Transaction failed' }, 500)
  } finally {
    connection.release()
  }
})

// ... 他の288ルートを同様に実装
// - /api/products (GET, GET/:id, POST, PUT/:id, DELETE/:id)
// - /api/options (GET, GET/:id, POST, PUT/:id)
// - /api/bookings (GET, GET/:id, PUT/:id, DELETE/:id)
// - /api/members (GET, GET/:id, POST, PUT/:id)
// - /api/accounts (GET, GET/:id, POST, PUT/:id)
// - /api/payments (POST, GET/:id)
// - etc...

// 404ハンドラー
app.notFound((c) => {
  return c.json({ error: 'Not Found' }, 404)
})

// エラーハンドラー
app.onError((err, c) => {
  console.error('Unhandled error:', err)
  return c.json({ error: 'Internal Server Error' }, 500)
})

// サーバー起動
const port = parseInt(process.env.PORT || '3000')

console.log(`
🚀 Webapp API Server Starting...
   Port: ${port}
   Environment: ${process.env.NODE_ENV || 'development'}
   Database: ${process.env.DB_HOST}
`)

const server = serve({
  fetch: app.fetch,
  port
})

console.log(`✓ Server started on http://0.0.0.0:${port}`)

// Graceful Shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM signal received: closing HTTP server')
  await closePool()
  process.exit(0)
})

process.on('SIGINT', async () => {
  console.log('SIGINT signal received: closing HTTP server')
  await closePool()
  process.exit(0)
})
```

**成果物:**
- ✅ データベース接続層実装完了
- ✅ 型定義作成完了
- ✅ Honoアプリケーション実装完了（Events, Products, Bookings APIサンプル）
- ✅ トランザクション処理実装完了
- ✅ エラーハンドリング実装完了

---

## 【Week 3】フェーズ3: 全APIルート実装とテスト

### Day 11-13: 残りのAPIルート実装

#### 実装すべきAPI一覧（288ルート）

**優先度1: コアAPI（必須）**
- Events: GET, GET/:id, POST, PUT/:id, DELETE/:id
- Products: GET, GET/:id, POST, PUT/:id, DELETE/:id
- Options: GET, GET/:id, POST, PUT/:id
- Bookings: GET, GET/:id, POST, PUT/:id, DELETE/:id
- Members: GET, GET/:id, POST, PUT/:id
- Accounts: GET, GET/:id, POST, PUT/:id
- Payments: POST, GET/:id

**優先度2: 管理API**
- Clients: GET, GET/:id, POST, PUT/:id
- Organizers: GET, GET/:id, POST, PUT/:id
- Vendors: GET, GET/:id, POST, PUT/:id
- Branches: GET, GET/:id, POST, PUT/:id

**優先度3: 補助API**
- Form fields: GET, POST
- Staff: GET, POST
- Email logs: GET, GET/:id
- Statistics: GET

#### ルート実装テンプレート

各APIルートは以下のパターンで実装：

```typescript
// GET /api/[resource]
app.get('/api/[resource]', async (c) => {
  try {
    const pool = getPool()
    // ページネーション、フィルタリング、ソート実装
    // ...
    return c.json(result)
  } catch (error) {
    console.error('[Resource] list error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

// GET /api/[resource]/:id
app.get('/api/[resource]/:id', async (c) => {
  try {
    const pool = getPool()
    const id = parseInt(c.req.param('id'))
    // ...
    return c.json(item)
  } catch (error) {
    console.error('[Resource] get error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

// POST /api/[resource]
app.post('/api/[resource]', async (c) => {
  try {
    const pool = getPool()
    const data = await c.req.json()
    // バリデーション
    // INSERT処理
    // ...
    return c.json(newItem, 201)
  } catch (error) {
    console.error('[Resource] create error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

// PUT /api/[resource]/:id
app.put('/api/[resource]/:id', async (c) => {
  try {
    const pool = getPool()
    const id = parseInt(c.req.param('id'))
    const data = await c.req.json()
    // UPDATE処理
    // ...
    return c.json(updatedItem)
  } catch (error) {
    console.error('[Resource] update error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})

// DELETE /api/[resource]/:id
app.delete('/api/[resource]/:id', async (c) => {
  try {
    const pool = getPool()
    const id = parseInt(c.req.param('id'))
    // DELETE処理
    // ...
    return c.json({ message: '[Resource] deleted successfully' })
  } catch (error) {
    console.error('[Resource] delete error:', error)
    return c.json({ error: 'Internal server error' }, 500)
  }
})
```

**成果物:**
- ✅ 全288ルート実装完了
- ✅ バリデーション実装完了
- ✅ エラーハンドリング実装完了

---

### Day 14-15: ローカルテストとデバッグ

#### 1. ローカルビルド&起動

```bash
cd /home/user/webapp/ec2-api

# 依存関係インストール
npm install

# ビルド
npm run build

# 開発サーバー起動（ウォッチモード）
npm run dev

# 別ターミナルでテスト実行
curl http://localhost:3000/health
curl http://localhost:3000/api/events \
  -H "X-API-Key: your-api-key"
```

#### 2. テストスクリプト作成

```bash
# scripts/test-api.sh
#!/bin/bash

API_URL="http://localhost:3000"
API_KEY="your-api-key"

echo "Testing Health Check..."
curl -s "$API_URL/health" | jq

echo -e "\nTesting Events List..."
curl -s "$API_URL/api/events" \
  -H "X-API-Key: $API_KEY" | jq '.pagination'

echo -e "\nTesting Event Get..."
curl -s "$API_URL/api/events/1" \
  -H "X-API-Key: $API_KEY" | jq '.name'

echo -e "\nTesting Event Create..."
curl -s "$API_URL/api/events" \
  -X POST \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Event","enable_flg":1}' | jq

echo -e "\nTesting Products List..."
curl -s "$API_URL/api/products" \
  -H "X-API-Key: $API_KEY" | jq '.pagination'

echo -e "\nTesting Booking Create (Transaction)..."
curl -s "$API_URL/api/bookings" \
  -X POST \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "member_id": 1,
    "total_amount": 10000,
    "items": [
      {"product_id": 1, "quantity": 2, "unit_price": 5000, "subtotal": 10000}
    ],
    "payment": {
      "method": "credit_card",
      "amount": 10000
    }
  }' | jq

echo -e "\nAll tests completed!"
```

```bash
chmod +x scripts/test-api.sh
./scripts/test-api.sh
```

#### 3. 負荷テスト

```bash
# Apache Benchインストール
sudo apt-get install apache2-utils

# 100リクエスト、10並行
ab -n 100 -c 10 \
   -H "X-API-Key: your-api-key" \
   http://localhost:3000/api/events

# 期待値: Requests per second > 500
```

**成果物:**
- ✅ ローカルビルド成功
- ✅ 全APIテスト合格
- ✅ トランザクションテスト合格
- ✅ 負荷テスト合格（500+ req/s）

---

## 【Week 4】フェーズ4: デプロイと本番切替

### Day 16-17: EC2へのデプロイ

#### 1. ビルド成果物の準備

```bash
cd /home/user/webapp/ec2-api

# 本番ビルド
npm run build

# デプロイ用パッケージ作成
tar -czf webapp-api-deploy.tar.gz \
  dist/ \
  package.json \
  package-lock.json \
  ecosystem.config.cjs \
  logs/.gitkeep
```

#### 2. EC2へアップロード

```bash
# EC2へSCP転送
scp -i webapp-key.pem webapp-api-deploy.tar.gz \
  ubuntu@$PUBLIC_IP:/home/ubuntu/

# EC2にSSH接続
ssh -i webapp-key.pem ubuntu@$PUBLIC_IP

# 展開
cd /home/ubuntu/webapp-api
tar -xzf ../webapp-api-deploy.tar.gz

# 依存関係インストール（本番環境のみ）
npm install --production

# PM2で起動
pm2 start ecosystem.config.cjs

# 起動確認
pm2 list
pm2 logs webapp-api --nostream --lines 50

# プロセス数確認（t3.smallは2コア → 2プロセス）
pm2 describe webapp-api | grep instances

# 自動起動設定
pm2 startup systemd
# 出力されたコマンドを実行
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu

pm2 save
```

#### 3. 動作確認

```bash
# ヘルスチェック
curl http://$PUBLIC_IP:3000/health

# APIテスト
curl http://$PUBLIC_IP:3000/api/events \
  -H "X-API-Key: your-api-key"

# レスポンスタイム測定
time curl http://$PUBLIC_IP:3000/api/events \
  -H "X-API-Key: your-api-key" > /dev/null
```

**成果物:**
- ✅ EC2へのデプロイ完了
- ✅ PM2プロセス起動確認
- ✅ API動作確認完了
- ✅ 自動起動設定完了

---

### Day 18: Cloudflare側コード修正

#### 1. データベースアクセス層の追加

```typescript
// src/db/mysql-api.ts（Cloudflare Workers側）
export class MySQLAPI implements Database {
  constructor(
    private apiUrl: string,
    private apiKey: string
  ) {}

  private async request(path: string, options: RequestInit = {}) {
    const response = await fetch(`${this.apiUrl}${path}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': this.apiKey,
        ...options.headers
      }
    })

    if (!response.ok) {
      const error = await response.json()
      throw new Error(`API error: ${response.status} - ${error.message || error.error}`)
    }

    return response.json()
  }

  async getEvent(id: number): Promise<Event | null> {
    try {
      return await this.request(`/events/${id}`)
    } catch (error) {
      if (error.message.includes('404')) {
        return null
      }
      throw error
    }
  }

  async listEvents(params: EventListParams): Promise<EventListResult> {
    const queryParams = new URLSearchParams()
    if (params.page) queryParams.set('page', params.page.toString())
    if (params.per_page) queryParams.set('per_page', params.per_page.toString())
    if (params.name) queryParams.set('name', params.name)
    if (params.client_id) queryParams.set('client_id', params.client_id.toString())
    // ... 他のパラメータ
    
    return await this.request(`/events?${queryParams.toString()}`)
  }

  async createEvent(data: EventCreateData): Promise<Event> {
    return await this.request('/events', {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }

  // ... 他のメソッド実装（Products, Bookings, etc.）
}
```

#### 2. DB Factory修正

```typescript
// src/db/factory.ts
import type { Database } from './interface'
import { D1Database } from './d1'
import { MySQLAPI } from './mysql-api'

export function createDatabase(env: any): Database {
  const useMySQL = env.USE_MYSQL === 'true' || env.USE_MYSQL === true
  
  if (useMySQL) {
    console.log('🔄 Using MySQL API (EC2)')
    return new MySQLAPI(
      env.MYSQL_API_URL,  // http://EC2_PUBLIC_IP:3000/api
      env.MYSQL_API_KEY
    )
  } else {
    console.log('🔄 Using D1 Database')
    return new D1Database(env.DB)
  }
}
```

#### 3. 環境変数設定

```bash
# Cloudflare Pages Secrets設定
cd /home/user/webapp

npx wrangler pages secret put USE_MYSQL --project-name webapp
# 値: false（まずは並行運用）

npx wrangler pages secret put MYSQL_API_URL --project-name webapp
# 値: http://EC2_PUBLIC_IP:3000/api

npx wrangler pages secret put MYSQL_API_KEY --project-name webapp
# 値: your-secure-api-key
```

#### 4. デプロイ

```bash
cd /home/user/webapp

# ビルド
npm run build

# デプロイ
npm run deploy
```

**成果物:**
- ✅ MySQLAPI実装完了
- ✅ DB Factory切替機能実装完了
- ✅ Cloudflare Pages環境変数設定完了
- ✅ デプロイ完了

---

### Day 19: 並行運用テスト

#### 1. D1モードでの動作確認

```bash
# USE_MYSQL=false で確認
curl https://webapp-geh.pages.dev/api/events

# 管理画面動作確認
# - イベント一覧表示
# - イベント作成
# - 予約作成
```

#### 2. MySQLモードへ切替

```bash
# USE_MYSQL=true に変更
npx wrangler pages secret put USE_MYSQL --project-name webapp
# 値: true

# 再デプロイ（環境変数反映）
npm run deploy
```

#### 3. MySQLモードでの動作確認

```bash
# MySQL API経由で確認
curl https://webapp-geh.pages.dev/api/events

# 管理画面動作確認
# - イベント一覧表示
# - イベント作成
# - 予約作成

# EC2ログ確認
ssh -i webapp-key.pem ubuntu@$PUBLIC_IP
pm2 logs webapp-api --lines 100
```

#### 4. パフォーマンス比較

```bash
# D1モード
time curl https://webapp-geh.pages.dev/api/events > /dev/null
# 期待値: 0.2-0.5秒

# MySQLモード（EC2経由）
time curl https://webapp-geh.pages.dev/api/events > /dev/null
# 期待値: 0.3-0.8秒（やや増加は許容）
```

**成果物:**
- ✅ D1モード動作確認完了
- ✅ MySQLモード動作確認完了
- ✅ パフォーマンス測定完了
- ✅ エラー発生なし

---

### Day 20: データ移行と本番切替

#### 1. データエクスポート（D1 → MySQL）

```bash
# D1からデータエクスポート
cd /home/user/webapp

npx wrangler d1 export webapp-production > d1-export.sql

# SQLite → MySQL変換
sed -e 's/INTEGER PRIMARY KEY AUTOINCREMENT/INT AUTO_INCREMENT PRIMARY KEY/g' \
    -e "s/datetime('now','localtime')/CURRENT_TIMESTAMP/g" \
    -e "s/datetime('now')/CURRENT_TIMESTAMP/g" \
    d1-export.sql > mysql-import.sql

# MySQLへインポート
mysql -h webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp < mysql-import.sql
```

#### 2. データ整合性確認

```bash
# D1のレコード数
npx wrangler d1 execute webapp-production \
  --command="SELECT 
    (SELECT COUNT(*) FROM events) as events,
    (SELECT COUNT(*) FROM products) as products,
    (SELECT COUNT(*) FROM bookings) as bookings"

# MySQLのレコード数
mysql -h webapp-production.c9akxg0xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp \
      -e "SELECT 
            (SELECT COUNT(*) FROM events) as events,
            (SELECT COUNT(*) FROM products) as products,
            (SELECT COUNT(*) FROM bookings) as bookings"

# 結果が一致することを確認
```

#### 3. 本番切替

```bash
# メンテナンスモードON（オプション）
npx wrangler pages secret put MAINTENANCE_MODE --project-name webapp
# 値: true

# USE_MYSQL=true を確認
npx wrangler pages secret list --project-name webapp | grep USE_MYSQL

# デプロイ
npm run deploy

# 動作確認
curl https://webapp-geh.pages.dev/health
curl https://webapp-geh.pages.dev/api/events

# メンテナンスモードOFF
npx wrangler pages secret put MAINTENANCE_MODE --project-name webapp
# 値: false

npm run deploy
```

#### 4. 監視開始

```bash
# CloudWatch Logs確認
aws logs tail /aws/ec2/webapp-api/out --follow

# PM2監視
ssh -i webapp-key.pem ubuntu@$PUBLIC_IP
pm2 monit

# エラーログ監視
pm2 logs webapp-api --err --lines 0 --follow
```

**成果物:**
- ✅ データ移行完了
- ✅ データ整合性確認完了
- ✅ 本番環境切替完了
- ✅ 監視システム稼働開始

---

## 📊 運用・監視

### CloudWatch Agent設定

```json
// /opt/aws/amazon-cloudwatch-agent/etc/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ubuntu/webapp-api/logs/error.log",
            "log_group_name": "/aws/ec2/webapp-api/error",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          },
          {
            "file_path": "/home/ubuntu/webapp-api/logs/out.log",
            "log_group_name": "/aws/ec2/webapp-api/out",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "WebApp/EC2",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          {"name": "cpu_usage_idle"},
          {"name": "cpu_usage_iowait"}
        ],
        "metrics_collection_interval": 60,
        "totalcpu": false
      },
      "mem": {
        "measurement": [
          {"name": "mem_used_percent"}
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          {"name": "disk_used_percent"}
        ],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      }
    }
  }
}
```

### アラート設定

```bash
# CPU使用率アラート
aws cloudwatch put-metric-alarm \
  --alarm-name webapp-ec2-cpu-high \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --period 300 \
  --statistic Average \
  --threshold 80.0 \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID

# メモリ使用率アラート
aws cloudwatch put-metric-alarm \
  --alarm-name webapp-ec2-memory-high \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --metric-name mem_used_percent \
  --namespace WebApp/EC2 \
  --period 300 \
  --statistic Average \
  --threshold 85.0

# RDS接続数アラート
aws cloudwatch put-metric-alarm \
  --alarm-name webapp-rds-connections-high \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 1 \
  --metric-name DatabaseConnections \
  --namespace AWS/RDS \
  --period 60 \
  --statistic Average \
  --threshold 450 \
  --dimensions Name=DBInstanceIdentifier,Value=webapp-production
```

### バックアップ設定

```bash
# RDS自動バックアップ確認
aws rds describe-db-instances \
  --db-instance-identifier webapp-production \
  --query 'DBInstances[0].{BackupRetentionPeriod:BackupRetentionPeriod,PreferredBackupWindow:PreferredBackupWindow}'

# 手動スナップショット作成
aws rds create-db-snapshot \
  --db-instance-identifier webapp-production \
  --db-snapshot-identifier webapp-production-manual-$(date +%Y%m%d-%H%M%S)

# EC2 AMI作成（定期バックアップ用）
aws ec2 create-image \
  --instance-id $INSTANCE_ID \
  --name "webapp-api-backup-$(date +%Y%m%d-%H%M%S)" \
  --description "Webapp API Server Backup"
```

---

## 📋 チェックリスト

### Week 1: AWS環境構築
- [ ] VPC、サブネット、セキュリティグループ作成
- [ ] RDS MySQL インスタンス作成
- [ ] RDSパラメータグループ設定
- [ ] RDS接続確認
- [ ] データベース`webapp`作成
- [ ] EC2キーペア作成
- [ ] EC2インスタンス起動（t3.small）
- [ ] Node.js 20.x インストール
- [ ] PM2インストール
- [ ] CloudWatch Agent設定
- [ ] SQLite → MySQL マイグレーション変換
- [ ] RDSへのマイグレーション実行
- [ ] 全40テーブル作成確認

### Week 2: Honoアプリケーション開発
- [ ] プロジェクト構造作成
- [ ] package.json設定
- [ ] TypeScript設定
- [ ] PM2設定（ecosystem.config.cjs）
- [ ] データベース接続層実装（src/db.ts）
- [ ] 型定義作成（src/types.ts）
- [ ] メインアプリケーション実装（src/index.ts）
- [ ] Events API実装
- [ ] Products API実装
- [ ] Bookings API実装（トランザクション）
- [ ] Members API実装
- [ ] Accounts API実装
- [ ] Payments API実装

### Week 3: 全APIルート実装とテスト
- [ ] 残り282ルートの実装
- [ ] バリデーション実装
- [ ] エラーハンドリング実装
- [ ] ローカルビルド成功
- [ ] ローカル起動成功
- [ ] テストスクリプト作成
- [ ] 全APIテスト合格
- [ ] トランザクションテスト合格
- [ ] 負荷テスト合格（500+ req/s）

### Week 4: デプロイと本番切替
- [ ] 本番ビルド成功
- [ ] デプロイパッケージ作成
- [ ] EC2へSCP転送
- [ ] EC2で依存関係インストール
- [ ] PM2で起動
- [ ] EC2プロセス起動確認
- [ ] EC2 API動作確認
- [ ] PM2自動起動設定
- [ ] Cloudflare側MySQLAPI実装
- [ ] DB Factory切替機能実装
- [ ] Cloudflare環境変数設定
- [ ] Cloudflareデプロイ
- [ ] D1モード動作確認
- [ ] MySQLモード切替
- [ ] MySQLモード動作確認
- [ ] パフォーマンス測定
- [ ] D1データエクスポート
- [ ] MySQLへデータインポート
- [ ] データ整合性確認
- [ ] 本番切替（USE_MYSQL=true）
- [ ] CloudWatch監視開始
- [ ] アラート設定
- [ ] バックアップ設定

---

## 💰 コスト見積もり

### 月額運用コスト

| 項目 | 料金 | 備考 |
|------|------|------|
| **EC2 (t3.small)** | $15.18 | 2vCPU, 2GB RAM, 730時間/月 |
| **RDS (db.t3.small)** | $29.20 | 2vCPU, 2GB RAM, Single-AZ |
| **RDS ストレージ (100GB gp3)** | $5.84 | 3000 IOPS, 125 MB/s |
| **データ転送 (10GB/月)** | $0.90 | EC2 → インターネット |
| **CloudWatch Logs (5GB)** | $2.50 | ログ保存 |
| **CloudWatch メトリクス** | $0 | 標準メトリクス無料 |
| **EBS (EC2ルートボリューム 30GB)** | $3.00 | gp3 |
| **Elastic IP (使用中)** | $0 | EC2に割り当て済み |
| **合計** | **$56.62/月** | ALBなし |

**ALB追加の場合（オプション）:**
- Application Load Balancer: +$16.20/月
- **合計**: $72.82/月

### スケール時のコスト

#### 中規模（月間500万リクエスト）
- EC2: t3.small → t3.medium ($30/月)
- RDS: db.t3.small → db.t3.medium ($58/月)
- その他: $12/月
- **合計**: $100/月

#### 大規模（月間1000万リクエスト）
- EC2: t3.medium → t3.large ($60/月)
- RDS: db.t3.medium → db.t3.large ($117/月)
- その他: $15/月
- **合計**: $192/月

---

## 🔒 セキュリティ対策

### 1. ネットワークセキュリティ
- ✅ RDSはプライベートサブネットに配置
- ✅ EC2からのみRDSへの接続許可
- ✅ セキュリティグループで最小権限
- ✅ SSH接続は特定IPのみ許可（推奨）

### 2. API認証
- ✅ X-API-Key ヘッダーによる認証
- ✅ Cloudflare側でSecret管理
- ✅ EC2側で環境変数管理

### 3. データ暗号化
- ✅ RDS: 保存時の暗号化有効
- ✅ RDS: 転送時の暗号化（TLS）
- ✅ バックアップの自動暗号化

### 4. アクセス制御
- ✅ IAMロールによるEC2 → RDS接続
- ✅ CloudWatch Agent用のIAMロール
- ✅ 最小権限の原則

---

## 🚨 トラブルシューティング

### EC2接続エラー

**問題**: SSH接続できない
```bash
# セキュリティグループ確認
aws ec2 describe-security-groups --group-ids sg-xxxxx

# SSH接続テスト
ssh -vvv -i webapp-key.pem ubuntu@$PUBLIC_IP

# 解決策:
# 1. セキュリティグループでポート22を開放
# 2. キーペアのパーミッション確認 (chmod 400)
# 3. パブリックIPが正しいか確認
```

### RDS接続エラー

**問題**: EC2からRDSに接続できない
```bash
# セキュリティグループ確認
aws ec2 describe-security-groups --group-ids sg-yyyyy

# MySQL接続テスト
mysql -h webapp-production.xxxxx.rds.amazonaws.com -u admin -p -e "SELECT 1"

# 解決策:
# 1. RDSセキュリティグループでEC2のSGからポート3306を許可
# 2. RDSエンドポイント確認
# 3. VPCサブネット設定確認
```

### PM2プロセス起動エラー

**問題**: PM2でアプリが起動しない
```bash
# PM2ログ確認
pm2 logs webapp-api --err --lines 100

# プロセス詳細確認
pm2 describe webapp-api

# 解決策:
# 1. 環境変数が正しく設定されているか確認
# 2. Node.jsバージョン確認 (node --version)
# 3. 依存関係インストール確認 (npm install)
# 4. ビルド成功確認 (dist/index.js が存在するか)
```

### API応答遅延

**問題**: APIレスポンスが遅い（> 1秒）
```bash
# RDS接続数確認
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name DatabaseConnections \
  --dimensions Name=DBInstanceIdentifier,Value=webapp-production \
  --start-time 2026-03-XX \
  --end-time 2026-03-XX \
  --period 300 \
  --statistics Average

# 解決策:
# 1. コネクションプール設定確認（connectionLimit）
# 2. スロークエリログ確認
# 3. インデックス追加
# 4. RDSインスタンスサイズアップ
```

---

## 🎯 成功基準

### 機能要件
- [x] 全288 APIルートが正常動作
- [x] トランザクション処理が正常動作
- [x] データ整合性100%

### 非機能要件
- [x] レスポンスタイム: 平均 50ms以下（EC2内）、200ms以下（Cloudflare経由）
- [x] エラー率: 0.1%以下
- [x] 可用性: 99.9%以上（PM2自動再起動）

### 運用要件
- [x] CloudWatch監視稼働
- [x] アラート通知設定
- [x] 自動バックアップ設定
- [x] PM2自動起動設定

---

## 📞 連絡先・エスカレーション

### チーム体制
- **プロジェクトマネージャー**: [名前]
- **バックエンド開発**: [名前]
- **インフラ**: [名前]
- **QA**: [名前]

### エスカレーション基準
- **Level 1**: API応答時間 > 500ms → PM2再起動
- **Level 2**: エラー率 > 1% → EC2ログ確認、RDS接続確認
- **Level 3**: サービス停止 > 5分 → 緊急対応チーム招集

---

## 📚 参考資料

### ドキュメント
- `/home/user/webapp/docs/aws_rds_migration_plan.md` - 移行計画全体
- `/home/user/webapp/docs/aws_api_architecture.md` - Lambda版アーキテクチャ
- `/home/user/webapp/docs/aws_ec2_vs_lambda_comparison.md` - EC2 vs Lambda比較
- `/home/user/webapp/docs/ec2_hono_implementation_plan.md` - 本ドキュメント

### 外部リンク
- [Hono Documentation](https://hono.dev/)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [AWS RDS MySQL Documentation](https://docs.aws.amazon.com/rds/mysql/)
- [PM2 Documentation](https://pm2.keymetrics.io/docs/)
- [CloudWatch Agent Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)

---

## ✅ 承認

- [ ] 技術責任者承認
- [ ] プロジェクトマネージャー承認
- [ ] 予算承認者承認（月額 $57-73）
- [ ] セキュリティレビュー承認

**開始日**: 2026年3月10日  
**完了予定日**: 2026年4月6日  
**実装担当**: [名前]

---

**最終更新**: 2026年3月9日  
**バージョン**: 1.0
