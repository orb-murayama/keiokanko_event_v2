# AWS RDS MySQL 移行計画書

## 📋 プロジェクト概要

### 目的
- Cloudflare D1（500MB制限）から AWS RDS MySQL（最大64TB）へ移行
- 長期運用に耐えうるスケーラブルなデータベース基盤を構築

### 期間
- **合計: 4週間**（2026年3月10日 〜 2026年4月6日）

### 予算
- **月額運用コスト**: $45-60/月
  - AWS RDS MySQL (db.t3.small): $30-40/月
  - ストレージ (100GB): $10/月
  - Lambda + API Gateway: $5-10/月

## 🗓️ 詳細スケジュール

### 【Week 1】フェーズ1: AWS環境構築 + 要件定義

#### Day 1-2: AWS環境セットアップ
```bash
# 1. AWS RDS MySQL作成
aws rds create-db-instance \
  --db-instance-identifier webapp-production \
  --db-instance-class db.t3.small \
  --engine mysql \
  --engine-version 8.0.35 \
  --master-username admin \
  --master-user-password [SECURE_PASSWORD] \
  --allocated-storage 100 \
  --storage-type gp3 \
  --storage-encrypted \
  --backup-retention-period 7 \
  --preferred-backup-window "03:00-04:00" \
  --preferred-maintenance-window "Mon:04:00-Mon:05:00" \
  --vpc-security-group-ids sg-xxxxx \
  --db-subnet-group-name webapp-subnet-group \
  --publicly-accessible false \
  --multi-az false \
  --tags Key=Environment,Value=Production Key=Project,Value=webapp

# 2. パラメータグループ設定
aws rds create-db-parameter-group \
  --db-parameter-group-name webapp-mysql80 \
  --db-parameter-group-family mysql8.0 \
  --description "webapp MySQL 8.0 parameters"

aws rds modify-db-parameter-group \
  --db-parameter-group-name webapp-mysql80 \
  --parameters \
    "ParameterName=character_set_server,ParameterValue=utf8mb4,ApplyMethod=immediate" \
    "ParameterName=collation_server,ParameterValue=utf8mb4_unicode_ci,ApplyMethod=immediate" \
    "ParameterName=max_connections,ParameterValue=500,ApplyMethod=immediate"
```

**成果物:**
- ✅ RDS MySQL インスタンス稼働
- ✅ VPC、セキュリティグループ設定完了
- ✅ 接続確認完了

#### Day 3-4: Lambda + API Gateway構築

**Lambda関数構成:**
```
lambda/
├── layers/
│   └── mysql2/          # mysql2ライブラリ
├── functions/
│   ├── events/
│   │   ├── list.js      # GET /events
│   │   ├── get.js       # GET /events/:id
│   │   ├── create.js    # POST /events
│   │   └── update.js    # PUT /events/:id
│   ├── products/
│   ├── bookings/
│   ├── members/
│   └── accounts/
└── shared/
    ├── db.js            # DB接続共通処理
    └── utils.js         # ユーティリティ
```

**Lambda Layer作成:**
```bash
# mysql2 Layer作成
mkdir -p lambda-layers/mysql2/nodejs
cd lambda-layers/mysql2/nodejs
npm init -y
npm install mysql2
cd ..
zip -r mysql2-layer.zip nodejs/
aws lambda publish-layer-version \
  --layer-name mysql2 \
  --zip-file fileb://mysql2-layer.zip \
  --compatible-runtimes nodejs20.x
```

**Lambda関数例 (events/get.js):**
```javascript
const mysql = require('mysql2/promise');

// 接続プール
let pool;

const getConnection = async () => {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });
  }
  return pool;
};

exports.handler = async (event) => {
  const eventId = event.pathParameters.id;
  
  try {
    const pool = await getConnection();
    const [rows] = await pool.execute(
      'SELECT * FROM events WHERE id = ?',
      [eventId]
    );
    
    if (rows.length === 0) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: 'Event not found' })
      };
    }
    
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify(rows[0])
    };
  } catch (error) {
    console.error('Database error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal server error' })
    };
  }
};
```

**API Gateway設定:**
```bash
# REST APIの作成
aws apigateway create-rest-api \
  --name webapp-api \
  --description "webapp Database API" \
  --endpoint-configuration types=REGIONAL

# リソース・メソッド作成例
# GET /events
# GET /events/{id}
# POST /events
# PUT /events/{id}
# DELETE /events/{id}
# (全28エンドポイント作成)
```

**成果物:**
- ✅ Lambda関数（28個）デプロイ完了
- ✅ API Gateway設定完了
- ✅ API URL取得: `https://xxx.execute-api.us-east-1.amazonaws.com/prod`

#### Day 5: マイグレーションファイル変換

**SQLite → MySQL変換タスク:**

| 変換項目 | SQLite (D1) | MySQL |
|---------|-------------|-------|
| 自動採番 | `INTEGER PRIMARY KEY AUTOINCREMENT` | `INT AUTO_INCREMENT PRIMARY KEY` |
| 日時型 | `DATETIME` | `DATETIME` |
| 日時デフォルト | `datetime('now')` | `CURRENT_TIMESTAMP` |
| ブール型 | `INTEGER (0/1)` | `TINYINT(1)` または `BOOLEAN` |
| TEXT型 | `TEXT` | `TEXT` または `VARCHAR(n)` |
| JSON型 | `TEXT` (JSON文字列) | `JSON` |
| 文字列連結 | `||` | `CONCAT()` |
| 大文字小文字 | 区別する | 区別しない（デフォルト） |

**変換スクリプト例:**
```bash
# migrations/の全.sqlファイルを変換
cd /home/user/webapp
mkdir migrations-mysql

for file in migrations/*.sql; do
  filename=$(basename "$file")
  
  # SQLite → MySQL変換
  sed -e 's/INTEGER PRIMARY KEY AUTOINCREMENT/INT AUTO_INCREMENT PRIMARY KEY/g' \
      -e "s/datetime('now')/CURRENT_TIMESTAMP/g" \
      -e 's/DATETIME DEFAULT (datetime/DATETIME DEFAULT CURRENT_TIMESTAMP/g' \
      -e 's/TEXT/VARCHAR(2000)/g' \
      "$file" > "migrations-mysql/$filename"
  
  # MySQL固有設定を追加
  echo "" >> "migrations-mysql/$filename"
  echo "-- MySQL specific settings" >> "migrations-mysql/$filename"
  echo "ALTER TABLE [TABLE_NAME] ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;" >> "migrations-mysql/$filename"
done
```

**手動確認が必要な項目:**
- [ ] JSON型フィールドの変換
- [ ] 全文検索インデックス
- [ ] 外部キー制約
- [ ] トリガー

**成果物:**
- ✅ migrations-mysql/ ディレクトリ（19ファイル）
- ✅ 変換済みDDL検証完了

---

### 【Week 2】フェーズ2: データベーススキーマ構築 + コード抽象化

#### Day 6-7: RDSマイグレーション実行

```bash
# 1. RDS接続確認
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p \
      -e "SELECT VERSION();"

# 2. データベース作成
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p \
      -e "CREATE DATABASE webapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 3. マイグレーション実行
cd migrations-mysql
for file in *.sql; do
  echo "Applying $file..."
  mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
        -u admin -p webapp < "$file"
done

# 4. テーブル一覧確認
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp \
      -e "SHOW TABLES;"

# 5. インデックス確認
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp \
      -e "SHOW INDEX FROM events;"
```

**成果物:**
- ✅ 全40テーブル作成完了
- ✅ インデックス設定完了
- ✅ 外部キー制約設定完了

#### Day 8-10: データベースアクセス層の抽象化

**アーキテクチャ:**
```
src/
├── db/
│   ├── interface.ts          # DB抽象インターフェース
│   ├── d1.ts                  # D1実装（既存）
│   ├── mysql-api.ts           # MySQL API実装（新規）
│   └── factory.ts             # DB実装切替
├── index.tsx                  # メインファイル（変更最小限）
└── types.ts                   # 型定義更新
```

**1. interface.ts:**
```typescript
// src/db/interface.ts
export interface Database {
  // Events
  getEvent(id: number): Promise<Event | null>
  listEvents(params: EventListParams): Promise<EventListResult>
  createEvent(data: EventCreateData): Promise<Event>
  updateEvent(id: number, data: EventUpdateData): Promise<Event>
  deleteEvent(id: number): Promise<void>
  
  // Products
  getProduct(id: number): Promise<Product | null>
  listProducts(params: ProductListParams): Promise<ProductListResult>
  createProduct(data: ProductCreateData): Promise<Product>
  updateProduct(id: number, data: ProductUpdateData): Promise<Product>
  
  // Bookings
  getBooking(id: number): Promise<Booking | null>
  listBookings(params: BookingListParams): Promise<BookingListResult>
  createBooking(data: BookingCreateData): Promise<Booking>
  updateBooking(id: number, data: BookingUpdateData): Promise<Booking>
  
  // Members
  getMember(id: number): Promise<Member | null>
  createMember(data: MemberCreateData): Promise<Member>
  
  // Accounts
  getAccount(id: number): Promise<Account | null>
  createAccount(data: AccountCreateData): Promise<Account>
  
  // ... 他のメソッド（合計約100メソッド）
}

export interface EventListParams {
  page?: number
  perPage?: number
  name?: string
  branchCode?: string
  clientId?: number
  vendorId?: number
  eventStartDateFrom?: string
  eventStartDateTo?: string
  enableFlg?: number
  category?: string
  eventType?: string
  includeDeleted?: boolean
  sort?: string
  order?: 'asc' | 'desc'
}

export interface EventListResult {
  results: Event[]
  pagination: {
    total: number
    page: number
    perPage: number
    totalPages: number
  }
}
```

**2. d1.ts (既存コード移植):**
```typescript
// src/db/d1.ts
import type { Database, Event, EventListParams, EventListResult } from './interface'

export class D1Database implements Database {
  constructor(private db: D1Database) {}
  
  async getEvent(id: number): Promise<Event | null> {
    const result = await this.db.prepare('SELECT * FROM events WHERE id = ?')
      .bind(id)
      .first()
    return result as Event | null
  }
  
  async listEvents(params: EventListParams): Promise<EventListResult> {
    const { page = 1, perPage = 50, name, clientId, sort = 'id', order = 'desc' } = params
    const offset = (page - 1) * perPage
    
    const conditions: string[] = []
    const values: any[] = []
    
    if (name) {
      conditions.push('name LIKE ?')
      values.push(`%${name}%`)
    }
    
    if (clientId) {
      conditions.push('client_id = ?')
      values.push(clientId)
    }
    
    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : ''
    
    // Count query
    const countResult = await this.db.prepare(`
      SELECT COUNT(*) as total FROM events ${whereClause}
    `).bind(...values).first()
    
    const total = countResult?.total || 0
    
    // Data query
    const { results } = await this.db.prepare(`
      SELECT * FROM events ${whereClause}
      ORDER BY ${sort} ${order}
      LIMIT ? OFFSET ?
    `).bind(...values, perPage, offset).all()
    
    return {
      results: results as Event[],
      pagination: {
        total,
        page,
        perPage,
        totalPages: Math.ceil(total / perPage)
      }
    }
  }
  
  // ... 他のメソッド実装
}
```

**3. mysql-api.ts (新規):**
```typescript
// src/db/mysql-api.ts
import type { Database, Event, EventListParams, EventListResult } from './interface'

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
        'Authorization': `Bearer ${this.apiKey}`,
        ...options.headers
      }
    })
    
    if (!response.ok) {
      throw new Error(`API error: ${response.status} ${response.statusText}`)
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
    if (params.perPage) queryParams.set('per_page', params.perPage.toString())
    if (params.name) queryParams.set('name', params.name)
    if (params.clientId) queryParams.set('client_id', params.clientId.toString())
    if (params.sort) queryParams.set('sort', params.sort)
    if (params.order) queryParams.set('order', params.order)
    
    return await this.request(`/events?${queryParams.toString()}`)
  }
  
  async createEvent(data: EventCreateData): Promise<Event> {
    return await this.request('/events', {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }
  
  // ... 他のメソッド実装
}
```

**4. factory.ts:**
```typescript
// src/db/factory.ts
import type { Database } from './interface'
import { D1Database } from './d1'
import { MySQLAPI } from './mysql-api'

export function createDatabase(env: any): Database {
  const useMySQL = env.USE_MYSQL === 'true' || env.USE_MYSQL === true
  
  if (useMySQL) {
    console.log('🔄 Using MySQL API')
    return new MySQLAPI(
      env.MYSQL_API_URL,
      env.MYSQL_API_KEY
    )
  } else {
    console.log('🔄 Using D1 Database')
    return new D1Database(env.DB)
  }
}
```

**5. index.tsx修正:**
```typescript
// src/index.tsx
import { createDatabase } from './db/factory'

const app = new Hono<{ Bindings: Bindings }>()

// 既存コード
app.get('/api/events/:id', async (c) => {
  const eventId = parseInt(c.req.param('id'))
  
  // Before (404箇所)
  // const event = await c.env.DB.prepare('SELECT * FROM events WHERE id = ?')
  //   .bind(eventId).first()
  
  // After (統一インターフェース)
  const db = createDatabase(c.env)
  const event = await db.getEvent(eventId)
  
  if (!event) {
    return c.json({ error: 'Event not found' }, 404)
  }
  
  return c.json(event)
})

app.get('/api/events', async (c) => {
  const page = parseInt(c.req.query('page') || '1')
  const perPage = parseInt(c.req.query('per_page') || '50')
  const name = c.req.query('name')
  
  const db = createDatabase(c.env)
  const result = await db.listEvents({ page, perPage, name })
  
  return c.json(result)
})

// ... 他の404箇所も同様に修正
```

**成果物:**
- ✅ DB抽象化層実装完了
- ✅ 既存コード動作確認（D1モード）
- ✅ ユニットテスト作成

---

### 【Week 3】フェーズ3: 全404箇所のコード移行

#### Day 11-15: 段階的コード移行

**移行優先順位:**

**Phase 3.1: 読み取り専用API（リスク低）**
- Day 11-12: Events系API（8箇所）
- Day 12-13: Products系API（10箇所）
- Day 13-14: Options系API（8箇所）
- Day 14: Members/Accounts系API（6箇所）

**Phase 3.2: 書き込みAPI（リスク中）**
- Day 15: Bookings作成API（20箇所）
- Day 15: 決済関連API（15箇所）

**移行チェックリスト（各API）:**
```markdown
- [ ] 既存D1クエリ確認
- [ ] DB抽象化メソッド実装
- [ ] Lambda関数実装
- [ ] API Gatewayエンドポイント作成
- [ ] ローカルテスト（D1モード）
- [ ] ローカルテスト（MySQLモード）
- [ ] 統合テスト
- [ ] エラーハンドリング確認
```

**テストコマンド:**
```bash
# D1モード（既存動作確認）
export USE_MYSQL=false
npm run dev:sandbox

# MySQLモード（新実装確認）
export USE_MYSQL=true
export MYSQL_API_URL=https://xxx.execute-api.us-east-1.amazonaws.com/prod
export MYSQL_API_KEY=your-api-key
npm run dev:sandbox

# APIテスト
curl http://localhost:3000/api/events
curl http://localhost:3000/api/events/1
curl -X POST http://localhost:3000/api/events -d '{"name":"Test Event"}'
```

**成果物:**
- ✅ 404箇所のコード移行完了
- ✅ 全APIテスト合格
- ✅ エラーハンドリング実装完了

---

### 【Week 4】フェーズ4: テスト + 本番移行

#### Day 16-17: 統合テスト

**テストシナリオ:**
```
1. 基本CRUD操作
   - Events作成・取得・更新・削除
   - Products作成・取得・更新・削除
   - Bookings作成・取得・更新・キャンセル

2. 複雑なクエリ
   - ページネーション（page=1-10）
   - ソート（複数カラム）
   - フィルタリング（複数条件）
   - JOIN操作

3. トランザクション
   - 予約作成（booking + booking_items + payment）
   - キャンセル処理（返金 + ステータス更新）

4. パフォーマンステスト
   - 100並行リクエスト
   - 1000件データ取得
   - レスポンスタイム測定

5. エラーケース
   - 不正なパラメータ
   - DB接続エラー
   - タイムアウト
   - ロールバック
```

**負荷テストツール:**
```bash
# Apache Bench
ab -n 1000 -c 100 https://webapp-geh.pages.dev/api/events

# k6
k6 run load-test.js
```

**成果物:**
- ✅ 全テストシナリオ合格
- ✅ パフォーマンス目標達成（レスポンス200ms以下）
- ✅ エラー率0.1%以下

#### Day 18: データ移行準備

**D1→MySQL データエクスポート:**
```bash
# 1. D1データエクスポート
npx wrangler d1 export webapp-production > d1-export.sql

# 2. SQLite→MySQL変換
sed -e 's/INTEGER PRIMARY KEY AUTOINCREMENT/INT AUTO_INCREMENT PRIMARY KEY/g' \
    -e "s/datetime('now')/CURRENT_TIMESTAMP/g" \
    d1-export.sql > mysql-import.sql

# 3. MySQL インポート
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp < mysql-import.sql

# 4. データ整合性確認
# D1のレコード数
npx wrangler d1 execute webapp-production \
  --command="SELECT COUNT(*) FROM events"

# MySQLのレコード数
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp \
      -e "SELECT COUNT(*) FROM events"
```

**成果物:**
- ✅ 全テーブルデータ移行完了
- ✅ レコード数一致確認
- ✅ データ整合性検証完了

#### Day 19: 本番環境切替

**切替手順:**

**1. 事前確認（10:00-11:00）**
```bash
# 最終テスト実行
npm run test

# バックアップ確認
aws rds describe-db-snapshots --db-instance-identifier webapp-production

# ロールバック手順確認
cat rollback-plan.md
```

**2. メンテナンスモード（11:00-11:05）**
```typescript
// src/index.tsx
app.use('*', async (c, next) => {
  const maintenanceMode = c.env.MAINTENANCE_MODE === 'true'
  
  if (maintenanceMode && !c.req.path.startsWith('/api/health')) {
    return c.html(`
      <html>
        <body>
          <h1>メンテナンス中</h1>
          <p>現在システムメンテナンス中です。しばらくお待ちください。</p>
        </body>
      </html>
    `, 503)
  }
  
  await next()
})
```

```bash
# メンテナンスモード有効化
npx wrangler pages secret put MAINTENANCE_MODE --project-name webapp
# 値: true

# デプロイ
npm run deploy
```

**3. 環境変数切替（11:05-11:10）**
```bash
# Cloudflare Pages Secretsを更新
npx wrangler pages secret put USE_MYSQL --project-name webapp
# 値: true

npx wrangler pages secret put MYSQL_API_URL --project-name webapp
# 値: https://xxx.execute-api.us-east-1.amazonaws.com/prod

npx wrangler pages secret put MYSQL_API_KEY --project-name webapp
# 値: your-secure-api-key

# 最終データ同期
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp < final-sync.sql
```

**4. デプロイ + 動作確認（11:10-11:30）**
```bash
# 本番デプロイ
npm run build
npx wrangler pages deploy dist --project-name webapp

# ヘルスチェック
curl https://webapp-geh.pages.dev/api/health

# 動作確認
curl https://webapp-geh.pages.dev/api/events
curl https://webapp-geh.pages.dev/api/products
curl https://webapp-geh.pages.dev/api/bookings

# テスト予約作成
curl -X POST https://webapp-geh.pages.dev/api/bookings \
  -H "Content-Type: application/json" \
  -d '{"event_id": 1, "member_id": 1, ...}'
```

**5. メンテナンスモード解除（11:30-11:35）**
```bash
npx wrangler pages secret put MAINTENANCE_MODE --project-name webapp
# 値: false

npm run deploy
```

**6. 監視開始（11:35-）**
```bash
# CloudWatch監視
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name CPUUtilization \
  --dimensions Name=DBInstanceIdentifier,Value=webapp-production \
  --start-time 2026-03-XX \
  --end-time 2026-03-XX \
  --period 300 \
  --statistics Average

# Lambda監視
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Invocations \
  --dimensions Name=FunctionName,Value=webapp-events-get \
  --start-time 2026-03-XX \
  --end-time 2026-03-XX \
  --period 300 \
  --statistics Sum

# エラーログ監視
aws logs tail /aws/lambda/webapp-events-get --follow
```

**成果物:**
- ✅ 本番環境MySQL切替完了
- ✅ 全機能動作確認完了
- ✅ パフォーマンス正常

#### Day 20: 監視 + 最適化

**監視ダッシュボード設定:**
```bash
# CloudWatch Dashboard作成
aws cloudwatch put-dashboard \
  --dashboard-name webapp-production \
  --dashboard-body file://cloudwatch-dashboard.json
```

**アラート設定:**
```bash
# RDS CPU使用率アラート
aws cloudwatch put-metric-alarm \
  --alarm-name webapp-rds-cpu-high \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --metric-name CPUUtilization \
  --namespace AWS/RDS \
  --period 300 \
  --statistic Average \
  --threshold 80.0 \
  --dimensions Name=DBInstanceIdentifier,Value=webapp-production

# Lambda エラー率アラート
aws cloudwatch put-metric-alarm \
  --alarm-name webapp-lambda-errors \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 1 \
  --metric-name Errors \
  --namespace AWS/Lambda \
  --period 60 \
  --statistic Sum \
  --threshold 10
```

**パフォーマンス最適化:**
```bash
# RDSスロークエリログ確認
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p \
      -e "SELECT * FROM mysql.slow_log ORDER BY query_time DESC LIMIT 10;"

# インデックス追加
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp \
      -e "CREATE INDEX idx_events_start_date ON events(event_start_date);"
```

**成果物:**
- ✅ 監視ダッシュボード稼働
- ✅ アラート設定完了
- ✅ パフォーマンス最適化完了

---

## 📊 成果物一覧

### Week 1
- [x] AWS RDS MySQL インスタンス
- [x] Lambda関数（28個）
- [x] API Gateway エンドポイント
- [x] MySQL用マイグレーションファイル（19個）

### Week 2
- [x] RDSスキーマ構築完了
- [x] DB抽象化層実装
- [x] D1/MySQL切替機能

### Week 3
- [x] 404箇所コード移行完了
- [x] 全APIテスト合格

### Week 4
- [x] 統合テスト完了
- [x] データ移行完了
- [x] 本番環境切替完了
- [x] 監視システム稼働

## 💰 コスト詳細

### 初期費用
- **$0** （AWSアカウント既存想定）

### 月額運用コスト
| 項目 | 料金 |
|------|------|
| RDS MySQL (db.t3.small) | $30-40 |
| ストレージ (100GB gp3) | $10 |
| Lambda (100万リクエスト/月) | $0-5 |
| API Gateway (100万リクエスト/月) | $3.50 |
| データ転送 (10GB/月) | $0.90 |
| CloudWatch (メトリクス・ログ) | $5-10 |
| **合計** | **$49.40-68.40/月** |

### スケール時の追加コスト
| データ量 | RDS | ストレージ | 合計 |
|---------|-----|-----------|------|
| 100GB | $40 | $10 | $50/月 |
| 500GB | $60 | $50 | $110/月 |
| 1TB | $100 | $100 | $200/月 |

## ⚠️ リスクと対策

### リスク1: レイテンシー増加
- **現在**: Workers → D1 (1-5ms)
- **移行後**: Workers → API Gateway → Lambda → RDS (50-200ms)
- **対策**: 
  - Lambda ウォームアップ
  - RDS プロキシ使用
  - Redis キャッシュ導入（必要時）

### リスク2: 移行中のデータ不整合
- **対策**:
  - 並行書き込み期間を設ける
  - データ整合性チェックツール作成
  - ロールバック手順確認

### リスク3: Lambda Cold Start
- **対策**:
  - プロビジョンド同時実行数設定
  - CloudWatch EventsでKeep Alive
  - 接続プール最適化

### リスク4: コスト超過
- **対策**:
  - CloudWatch予算アラート設定
  - Lambda タイムアウト設定（3秒）
  - RDS 自動スケーリング無効化

## 📋 ロールバック計画

### 緊急ロールバック手順（15分以内）

**ステップ1: 環境変数を戻す**
```bash
npx wrangler pages secret put USE_MYSQL --project-name webapp
# 値: false

npm run deploy
```

**ステップ2: 動作確認**
```bash
curl https://webapp-geh.pages.dev/api/health
curl https://webapp-geh.pages.dev/api/events
```

**ステップ3: データ同期（必要時）**
```bash
# MySQLからD1へ最新データをエクスポート
mysql -h webapp-production.xxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p webapp -e "SELECT * FROM events" > events-rollback.csv

# D1へインポート
# （手動またはスクリプト）
```

## 🎯 成功基準

### 機能要件
- [ ] 全APIが正常動作（404箇所）
- [ ] データ整合性100%
- [ ] トランザクション正常動作

### 非機能要件
- [ ] レスポンスタイム: 平均200ms以下
- [ ] エラー率: 0.1%以下
- [ ] 可用性: 99.9%以上

### 運用要件
- [ ] 監視ダッシュボード稼働
- [ ] アラート通知動作確認
- [ ] バックアップ自動取得

## 📞 連絡先・エスカレーション

### チーム体制
- **プロジェクトマネージャー**: [名前]
- **バックエンド開発**: [名前]
- **インフラ**: [名前]
- **QA**: [名前]

### エスカレーション基準
- **Level 1**: API応答時間 > 500ms
- **Level 2**: エラー率 > 1%
- **Level 3**: サービス停止 > 5分

---

**承認:**
- [ ] 技術責任者
- [ ] プロジェクトマネージャー
- [ ] 予算承認者

**開始日**: 2026年3月10日  
**完了予定日**: 2026年4月6日
