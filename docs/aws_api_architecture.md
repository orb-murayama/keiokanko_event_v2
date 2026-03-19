# AWS API Gateway + Lambda アーキテクチャ

## 📐 全体構成図

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
│              AWS API Gateway                                 │
│  - RESTful API（28エンドポイント）                            │
│  - API Key認証                                               │
│  - レート制限                                                 │
│  - ログ記録                                                   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              AWS Lambda Functions                            │
│  - events-list, events-get, events-create...                │
│  - products-list, products-get...                           │
│  - bookings-list, bookings-create...                        │
│  - payments-process...                                      │
│  (合計28関数)                                                 │
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

## 🎯 このアプローチの利点

### 1. 責務分離（Separation of Concerns）

```
Cloudflare Workers/Pages:
├─ プレゼンテーション層
│  ├─ HTML生成・SSR
│  ├─ 静的アセット配信
│  └─ フロントエンドロジック
├─ アプリケーション層
│  ├─ ビジネスロジック
│  ├─ 認証・認可
│  ├─ セッション管理
│  └─ バリデーション
└─ データアクセス層（API呼び出しのみ）

AWS API Gateway + Lambda:
├─ データアクセス層
│  ├─ CRUD操作
│  ├─ クエリ実行
│  └─ トランザクション管理
└─ データ永続化層
   └─ RDS MySQL接続
```

### 2. セキュリティ強化 🔒

```
✅ データベース直接接続なし
   → RDSはVPCプライベートサブネット内に配置
   → インターネットからの直接アクセス不可

✅ API Key認証
   → Cloudflare側で環境変数として管理
   → リクエストヘッダーに付与

✅ レート制限
   → API Gateway側で制御
   → DDoS攻撃の防止

✅ IAM権限制御
   → Lambda関数の権限を最小限に
```

### 3. スケーラビリティ 📈

```
Cloudflare Workers:
- 世界320+拠点のエッジで実行
- 無制限の同時接続
- 0ms起動時間

AWS Lambda:
- 自動スケーリング
- 1関数あたり1,000同時実行
- コールドスタート対策可能

RDS MySQL:
- 読み取りレプリカ追加可能
- インスタンスサイズ変更可能
- 最大64TBまで拡張
```

### 4. 監視・運用 📊

```
Cloudflare:
├─ Pages Analytics
├─ Workers Analytics
└─ Real User Monitoring

AWS:
├─ CloudWatch（メトリクス・ログ）
├─ X-Ray（トレーシング）
└─ RDS Performance Insights
```

## 🔧 実装詳細

### Cloudflare Workers側（データアクセス層）

```typescript
// src/db/mysql-api.ts
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
        'X-API-Key': this.apiKey,  // API Key認証
        ...options.headers
      }
    })

    if (!response.ok) {
      const error = await response.json()
      throw new Error(`API error: ${response.status} - ${error.message}`)
    }

    return response.json()
  }

  // イベント一覧取得
  async listEvents(params: EventListParams): Promise<EventListResult> {
    const queryParams = new URLSearchParams()
    if (params.page) queryParams.set('page', params.page.toString())
    if (params.perPage) queryParams.set('per_page', params.perPage.toString())
    if (params.name) queryParams.set('name', params.name)
    if (params.clientId) queryParams.set('client_id', params.clientId.toString())
    
    return await this.request(`/events?${queryParams.toString()}`)
  }

  // イベント取得
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

  // イベント作成
  async createEvent(data: EventCreateData): Promise<Event> {
    return await this.request('/events', {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }

  // イベント更新
  async updateEvent(id: number, data: EventUpdateData): Promise<Event> {
    return await this.request(`/events/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data)
    })
  }

  // イベント削除
  async deleteEvent(id: number): Promise<void> {
    await this.request(`/events/${id}`, {
      method: 'DELETE'
    })
  }

  // 予約作成（トランザクション）
  async createBooking(data: BookingCreateData): Promise<Booking> {
    return await this.request('/bookings', {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }
}
```

### AWS Lambda側（データアクセス実装）

```javascript
// lambda/functions/events/list.js
const mysql = require('mysql2/promise')

// 接続プール（グローバルスコープで再利用）
let pool

const getPool = () => {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      connectionLimit: 10,
      waitForConnections: true,
      queueLimit: 0
    })
  }
  return pool
}

exports.handler = async (event) => {
  // API Key認証
  const apiKey = event.headers['x-api-key'] || event.headers['X-API-Key']
  if (apiKey !== process.env.API_KEY) {
    return {
      statusCode: 401,
      body: JSON.stringify({ error: 'Unauthorized' })
    }
  }

  try {
    const pool = getPool()
    
    // クエリパラメータ取得
    const params = event.queryStringParameters || {}
    const page = parseInt(params.page || '1')
    const perPage = parseInt(params.per_page || '50')
    const name = params.name
    const clientId = params.client_id
    const offset = (page - 1) * perPage

    // WHERE句構築
    const conditions = []
    const values = []

    if (name) {
      conditions.push('name LIKE ?')
      values.push(`%${name}%`)
    }

    if (clientId) {
      conditions.push('client_id = ?')
      values.push(parseInt(clientId))
    }

    const whereClause = conditions.length > 0 
      ? `WHERE ${conditions.join(' AND ')}` 
      : ''

    // カウントクエリ
    const [countRows] = await pool.execute(
      `SELECT COUNT(*) as total FROM events ${whereClause}`,
      values
    )
    const total = countRows[0].total

    // データクエリ
    const [rows] = await pool.execute(
      `SELECT * FROM events ${whereClause} 
       ORDER BY id DESC 
       LIMIT ? OFFSET ?`,
      [...values, perPage, offset]
    )

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        results: rows,
        pagination: {
          total,
          page,
          perPage,
          totalPages: Math.ceil(total / perPage)
        }
      })
    }
  } catch (error) {
    console.error('Database error:', error)
    return {
      statusCode: 500,
      body: JSON.stringify({ 
        error: 'Internal server error',
        message: error.message 
      })
    }
  }
}
```

```javascript
// lambda/functions/events/get.js
const mysql = require('mysql2/promise')

let pool

const getPool = () => {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      connectionLimit: 10
    })
  }
  return pool
}

exports.handler = async (event) => {
  // API Key認証
  const apiKey = event.headers['x-api-key'] || event.headers['X-API-Key']
  if (apiKey !== process.env.API_KEY) {
    return {
      statusCode: 401,
      body: JSON.stringify({ error: 'Unauthorized' })
    }
  }

  const eventId = parseInt(event.pathParameters.id)

  try {
    const pool = getPool()
    const [rows] = await pool.execute(
      'SELECT * FROM events WHERE id = ?',
      [eventId]
    )

    if (rows.length === 0) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: 'Event not found' })
      }
    }

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify(rows[0])
    }
  } catch (error) {
    console.error('Database error:', error)
    return {
      statusCode: 500,
      body: JSON.stringify({ 
        error: 'Internal server error',
        message: error.message 
      })
    }
  }
}
```

```javascript
// lambda/functions/bookings/create.js
const mysql = require('mysql2/promise')

let pool

const getPool = () => {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      connectionLimit: 10
    })
  }
  return pool
}

exports.handler = async (event) => {
  // API Key認証
  const apiKey = event.headers['x-api-key'] || event.headers['X-API-Key']
  if (apiKey !== process.env.API_KEY) {
    return {
      statusCode: 401,
      body: JSON.stringify({ error: 'Unauthorized' })
    }
  }

  const data = JSON.parse(event.body)

  let connection
  try {
    const pool = getPool()
    connection = await pool.getConnection()
    
    // トランザクション開始
    await connection.beginTransaction()

    // 予約作成
    const [bookingResult] = await connection.execute(
      `INSERT INTO bookings 
       (event_id, member_id, booking_date, status, total_amount) 
       VALUES (?, ?, NOW(), 'pending', ?)`,
      [data.event_id, data.member_id, data.total_amount]
    )
    const bookingId = bookingResult.insertId

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

    // コミット
    await connection.commit()

    // 作成された予約を取得
    const [bookings] = await connection.execute(
      'SELECT * FROM bookings WHERE id = ?',
      [bookingId]
    )

    return {
      statusCode: 201,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify(bookings[0])
    }
  } catch (error) {
    // ロールバック
    if (connection) {
      await connection.rollback()
    }
    
    console.error('Transaction error:', error)
    return {
      statusCode: 500,
      body: JSON.stringify({ 
        error: 'Transaction failed',
        message: error.message 
      })
    }
  } finally {
    if (connection) {
      connection.release()
    }
  }
}
```

## 🔌 API Gateway設定

### エンドポイント一覧（28エンドポイント）

```
Events:
├─ GET    /events                     # リスト取得
├─ GET    /events/{id}                # 詳細取得
├─ POST   /events                     # 作成
├─ PUT    /events/{id}                # 更新
└─ DELETE /events/{id}                # 削除

Products:
├─ GET    /products                   # リスト取得
├─ GET    /products/{id}              # 詳細取得
├─ POST   /products                   # 作成
└─ PUT    /products/{id}              # 更新

Options:
├─ GET    /options                    # リスト取得
├─ GET    /options/{id}               # 詳細取得
├─ POST   /options                    # 作成
└─ PUT    /options/{id}               # 更新

Bookings:
├─ GET    /bookings                   # リスト取得
├─ GET    /bookings/{id}              # 詳細取得
├─ POST   /bookings                   # 作成（トランザクション）
├─ PUT    /bookings/{id}              # 更新
└─ DELETE /bookings/{id}              # キャンセル

Members:
├─ GET    /members                    # リスト取得
├─ GET    /members/{id}               # 詳細取得
├─ POST   /members                    # 作成
└─ PUT    /members/{id}               # 更新

Accounts:
├─ GET    /accounts                   # リスト取得
├─ GET    /accounts/{id}              # 詳細取得
├─ POST   /accounts                   # 作成
└─ PUT    /accounts/{id}              # 更新

Payments:
├─ POST   /payments/process           # 決済処理
└─ GET    /payments/{id}              # 決済状況確認
```

### Terraform設定例

```hcl
# terraform/api-gateway.tf

resource "aws_api_gateway_rest_api" "webapp" {
  name        = "webapp-api"
  description = "webapp Database API"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Key
resource "aws_api_gateway_api_key" "cloudflare" {
  name    = "cloudflare-workers-key"
  enabled = true
}

# Usage Plan
resource "aws_api_gateway_usage_plan" "standard" {
  name = "standard-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.webapp.id
    stage  = aws_api_gateway_stage.prod.stage_name
  }

  quota_settings {
    limit  = 1000000  # 100万リクエスト/月
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 500    # バースト制限
    rate_limit  = 1000   # 秒間1000リクエスト
  }
}

resource "aws_api_gateway_usage_plan_key" "cloudflare" {
  key_id        = aws_api_gateway_api_key.cloudflare.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.standard.id
}

# Events Resource
resource "aws_api_gateway_resource" "events" {
  rest_api_id = aws_api_gateway_rest_api.webapp.id
  parent_id   = aws_api_gateway_rest_api.webapp.root_resource_id
  path_part   = "events"
}

# GET /events
resource "aws_api_gateway_method" "events_list" {
  rest_api_id   = aws_api_gateway_rest_api.webapp.id
  resource_id   = aws_api_gateway_resource.events.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "events_list" {
  rest_api_id = aws_api_gateway_rest_api.webapp.id
  resource_id = aws_api_gateway_resource.events.id
  http_method = aws_api_gateway_method.events_list.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.events_list.invoke_arn
}

# Lambda Permission
resource "aws_lambda_permission" "events_list" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.events_list.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.webapp.execution_arn}/*/*"
}
```

## 📊 パフォーマンス比較

### 現在のアーキテクチャ（D1）

```
Cloudflare Workers → D1 Database
レイテンシー: 1-5ms
スループット: 中
コスト: $0/月
制限: 500MB
```

### 新アーキテクチャ（AWS API）

```
Cloudflare Workers → API Gateway → Lambda → RDS MySQL
レイテンシー: 50-200ms
  ├─ API Gateway: 10-30ms
  ├─ Lambda Cold Start: 50-500ms (初回のみ)
  ├─ Lambda Warm: 1-5ms
  └─ RDS Query: 5-50ms
  
スループット: 高
コスト: $45-60/月
制限: 64TB
```

### パフォーマンス最適化

```
1. Lambda ウォームアップ
   - CloudWatch Eventsで5分ごとにPing
   - コールドスタート回避

2. プロビジョンド同時実行数
   - 常時起動Lambda: 2-5個
   - コスト: +$10-20/月

3. RDS Proxy
   - 接続プール管理
   - Lambda接続数削減
   - コスト: +$15/月

4. CloudFront キャッシュ
   - 読み取り専用APIをキャッシュ
   - TTL: 60秒
   - コスト: ほぼ$0

最適化後レイテンシー: 20-80ms
```

## 💰 詳細コスト分析

### 月額コスト（月間100万リクエスト想定）

```
【AWS側】
RDS MySQL (db.t3.small):              $35.04
├─ インスタンス (730時間)              $29.20
└─ ストレージ (100GB gp3)              $5.84

Lambda:                               $2.50
├─ リクエスト (100万)                  $0.20
├─ 実行時間 (512MB, 200ms平均)         $2.30

API Gateway:                          $3.50
├─ リクエスト (100万)                  $3.50

データ転送 (10GB):                    $0.90

CloudWatch:                           $5.00
├─ ログ保存 (5GB)                     $2.50
├─ メトリクス                         $2.50

小計（AWS）:                          $46.94/月

【Cloudflare側】
Pages (無料プラン):                   $0.00
Workers (無料プラン):                 $0.00
R2 (10GB):                            $0.00

合計:                                 $46.94/月
```

### スケール時のコスト

```
【100万リクエスト/月】
- 現在の構成: $47/月

【500万リクエスト/月】
- Lambda: $12.50 (+$10)
- API Gateway: $17.50 (+$14)
- RDS: $35.04 (変更なし)
- その他: $6.90 (変更なし)
合計: $71.94/月

【1,000万リクエスト/月】
- Lambda: $25.00 (+$22.50)
- API Gateway: $35.00 (+$31.50)
- RDS: $60.00 (db.t3.medium)
- その他: $6.90 (変更なし)
合計: $126.90/月
```

## 🔒 セキュリティ設計

### 1. ネットワークセキュリティ

```
┌─────────────────────────────────────┐
│  Internet                            │
└─────────────────────────────────────┘
              ↓ HTTPS only
┌─────────────────────────────────────┐
│  Cloudflare (DDoS Protection)        │
└─────────────────────────────────────┘
              ↓ HTTPS + API Key
┌─────────────────────────────────────┐
│  AWS API Gateway                     │
│  - API Key認証                       │
│  - レート制限                         │
│  - WAF (オプション)                  │
└─────────────────────────────────────┘
              ↓ VPC内部通信
┌─────────────────────────────────────┐
│  Lambda (VPC内)                      │
└─────────────────────────────────────┘
              ↓ VPC内部通信
┌─────────────────────────────────────┐
│  RDS MySQL (Private Subnet)          │
│  - インターネットアクセス不可         │
│  - Security Group制限                │
└─────────────────────────────────────┘
```

### 2. 認証・認可

```typescript
// Cloudflare Workers側
const MYSQL_API_URL = c.env.MYSQL_API_URL
const MYSQL_API_KEY = c.env.MYSQL_API_KEY  // Secret管理

const response = await fetch(`${MYSQL_API_URL}/events`, {
  headers: {
    'X-API-Key': MYSQL_API_KEY
  }
})
```

```javascript
// Lambda側
exports.handler = async (event) => {
  // API Key検証
  const apiKey = event.headers['x-api-key']
  
  if (apiKey !== process.env.API_KEY) {
    return {
      statusCode: 401,
      body: JSON.stringify({ error: 'Unauthorized' })
    }
  }
  
  // ... 処理続行
}
```

### 3. データ暗号化

```
✅ 転送中の暗号化
   - Cloudflare → API Gateway: TLS 1.3
   - API Gateway → Lambda: AWS内部暗号化
   - Lambda → RDS: TLS接続

✅ 保存時の暗号化
   - RDS: AES-256暗号化
   - バックアップ: 自動暗号化
   - ログ: CloudWatch暗号化
```

## 🚀 デプロイ手順

### ステップ1: AWS環境構築

```bash
# Terraform初期化
cd terraform
terraform init

# 環境構築
terraform plan
terraform apply

# 出力確認
terraform output api_gateway_url
terraform output api_key
```

### ステップ2: Lambda関数デプロイ

```bash
# Lambda関数ビルド
cd lambda
npm install

# 各関数をZIP化
for dir in functions/*/; do
  cd "$dir"
  zip -r "../$(basename $dir).zip" .
  cd -
done

# デプロイ
aws lambda update-function-code \
  --function-name events-list \
  --zip-file fileb://functions/events-list.zip
```

### ステップ3: Cloudflare側設定

```bash
# 環境変数設定
npx wrangler pages secret put MYSQL_API_URL --project-name webapp
# 値: https://xxx.execute-api.us-east-1.amazonaws.com/prod

npx wrangler pages secret put MYSQL_API_KEY --project-name webapp
# 値: [APIキー]

npx wrangler pages secret put USE_MYSQL --project-name webapp
# 値: true

# デプロイ
npm run build
npm run deploy
```

## ✅ まとめ

### このアプローチが最適な理由

| 項目 | メリット |
|------|---------|
| **アーキテクチャ** | 責務分離・スケーラブル |
| **セキュリティ** | データベース直接接続なし |
| **パフォーマンス** | Cloudflare + AWSの両方の強みを活用 |
| **コスト** | $47/月（合理的） |
| **保守性** | API Gateway = 明確なインターフェース |
| **拡張性** | 最大64TBまで対応可能 |

### 次のステップ

1. **Week 1**: AWS環境構築開始
2. **Week 2**: Lambda関数開発
3. **Week 3**: Cloudflare側コード修正
4. **Week 4**: 統合テスト・本番移行

---

**質問**: このアーキテクチャで進めてよろしいですか？
