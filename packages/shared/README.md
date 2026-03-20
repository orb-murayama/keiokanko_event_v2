# 共通ライブラリ (@keiokanko/shared)

## 概要

イベント予約管理システムの共通ライブラリ。
すべてのプロジェクトで共有される機能を提供します。

## 主な機能

### データベースアダプター (`/database`)

複数のデータベースバックエンドをサポート：

- **D1 Adapter**: Cloudflare D1 (SQLite)
- **MySQL Adapter**: MySQL/MariaDB

```typescript
import { createDatabaseAdapter } from '@keiokanko/shared'

// D1の場合
const db = createDatabaseAdapter('d1', env.DB)

// MySQLの場合
const db = createDatabaseAdapter('mysql', {
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'keiokanko'
})
```

### サービスレイヤー (`/services`)

#### 予約サービス (BookingService)
- 予約作成・更新・削除
- 在庫管理
- 予約状態管理

```typescript
import { BookingService } from '@keiokanko/shared'

const bookingService = new BookingService(db)
const booking = await bookingService.createBooking(bookingData)
```

#### 決済サービス (GMOPaymentService)
- GMO Payment Gateway統合
- クレジットカード決済
- コンビニ決済
- 銀行振込

```typescript
import { GMOPaymentService } from '@keiokanko/shared'

const paymentService = new GMOPaymentService({
  siteId: env.GMO_SITE_ID,
  sitePass: env.GMO_SITE_PASS,
  shopId: env.GMO_SHOP_ID,
  shopPass: env.GMO_SHOP_PASS
})
```

#### メールサービス (EmailService)
- SMTP経由のメール送信
- テンプレートエンジン統合

```typescript
import { EmailService, EmailTemplateEngine } from '@keiokanko/shared'

const emailService = new EmailService({
  host: env.SMTP_HOST,
  port: env.SMTP_PORT,
  user: env.SMTP_USER,
  pass: env.SMTP_PASS
})

const templateEngine = new EmailTemplateEngine(db)
```

### ミドルウェア (`/middleware`)

#### 認証ミドルウェア
- JWT認証
- セッション管理
- ロールベースアクセス制御

```typescript
import { requireAuth, requireRole, requireEventAccess } from '@keiokanko/shared'

// 認証が必要なエンドポイント
app.get('/api/protected', requireAuth, async (c) => {
  // ...
})

// 管理者のみアクセス可能
app.post('/api/admin/events', requireAuth, requireRole('admin'), async (c) => {
  // ...
})

// 特定のイベントへのアクセス権が必要
app.get('/api/events/:id', requireAuth, requireEventAccess, async (c) => {
  // ...
})
```

### 型定義 (`/types`)

共通のTypeScript型定義：

```typescript
import type { 
  Event, 
  Product, 
  Booking, 
  Account, 
  Bindings 
} from '@keiokanko/shared'
```

主な型：
- `Event` - イベント
- `Product` - 商品
- `ProductPrice` - 商品価格
- `ProductStock` - 商品在庫
- `Option` - オプション
- `OptionPrice` - オプション価格
- `Booking` - 予約
- `Account` - アカウント
- `Member` - メンバー
- `Bindings` - Cloudflare環境変数

## 使用方法

### インストール

```bash
npm install @keiokanko/shared
```

### インポート

```typescript
// すべてをインポート
import * from '@keiokanko/shared'

// 個別にインポート
import { createDatabaseAdapter } from '@keiokanko/shared/database'
import { BookingService } from '@keiokanko/shared/services'
import { requireAuth } from '@keiokanko/shared/middleware'
import type { Event, Product } from '@keiokanko/shared/types'
```

## 開発

### ビルド

```bash
npm run build
```

### テスト

```bash
npm test
```

## 依存関係

- `bcryptjs` - パスワードハッシュ化
- `nodemailer` - メール送信
- `@cloudflare/workers-types` - Cloudflare Workers型定義

## エクスポート

```typescript
// package.json
{
  "exports": {
    ".": "./src/index.ts",
    "./database": "./src/database/index.ts",
    "./services": "./src/services/index.ts",
    "./middleware": "./src/middleware/auth.ts",
    "./types": "./src/types.ts"
  }
}
```
