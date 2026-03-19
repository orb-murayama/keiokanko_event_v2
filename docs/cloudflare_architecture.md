# 現在のCloudflare構成

## 📊 全体構成サマリー

```
┌─────────────────────────────────────────────────────────────┐
│               Cloudflare Pages (Edge Runtime)               │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │         webapp (Production Project)                  │   │
│  │  URL: https://webapp-geh.pages.dev                  │   │
│  │  Latest: https://a87b2edf.webapp-geh.pages.dev      │   │
│  └─────────────────────────────────────────────────────┘   │
│                          ↓                                  │
│  ┌──────────────┬──────────────────┬──────────────────┐   │
│  │   Hono App   │   Static Files   │   API Routes     │   │
│  │  (SSR Worker)│   (HTML/CSS/JS)  │   (/api/*)       │   │
│  └──────────────┴──────────────────┴──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                          ↓
         ┌────────────────┼────────────────┐
         ↓                ↓                ↓
  ┌──────────┐    ┌──────────────┐   ┌───────────┐
  │    D1    │    │     R2       │   │ Env Vars  │
  │ Database │    │   Storage    │   │ & Secrets │
  └──────────┘    └──────────────┘   └───────────┘
```

## 1️⃣ Cloudflare Pages (デプロイプラットフォーム)

### プロジェクト情報
- **プロジェクト名**: `webapp`
- **本番URL**: https://webapp-geh.pages.dev
- **最新デプロイ**: https://a87b2edf.webapp-geh.pages.dev (44分前)
- **Gitブランチ**: `main`
- **Git連携**: なし（手動デプロイ）

### デプロイ設定
```jsonc
// wrangler.jsonc
{
  "name": "webapp",
  "compatibility_date": "2025-11-20",
  "pages_build_output_dir": "./dist",
  "compatibility_flags": ["nodejs_compat"]
}
```

### ビルド・デプロイコマンド
```bash
# ローカル開発（サンドボックス）
npm run dev:sandbox
# → wrangler pages dev dist --d1=webapp-production --local --ip 0.0.0.0 --port 3000

# ビルド
npm run build
# → vite build && cp -r public/* dist/

# 本番デプロイ
npm run deploy
# → npm run build && wrangler pages deploy dist --project-name webapp
```

## 2️⃣ Cloudflare Workers (実行環境)

### Workers構成
- **実行モデル**: Cloudflare Pages Functions（自動生成）
- **Worker ファイル**: `dist/_worker.js` (ビルド時に生成)
- **フレームワーク**: Hono v4.10.6
- **ランタイム**: V8 Isolate + nodejs_compat

### Workers機能
- **SSR (Server-Side Rendering)**: Honoアプリケーション
- **静的ファイル配信**: public/ → dist/static/
- **APIルート**: 288個のルート定義（管理画面、顧客画面、API）
- **認証**: セッション、OTP、Basic認証対応

## 3️⃣ Cloudflare D1 (SQLiteデータベース)

### データベース情報
```
UUID:     123349c1-bc70-4887-9647-e4ca86222564
Name:     webapp-production
Version:  production
Tables:   0 (マイグレーション未適用の可能性)
Size:     565,248 bytes (約552KB)
Created:  2026-02-19
```

### バインディング
```jsonc
{
  "binding": "DB",
  "database_name": "webapp-production",
  "database_id": "123349c1-bc70-4887-9647-e4ca86222564"
}
```

### マイグレーション管理
```bash
# ローカル開発用マイグレーション
npm run db:migrate:local
# → wrangler d1 migrations apply webapp-production --local

# 本番マイグレーション
npm run db:migrate:prod
# → wrangler d1 migrations apply webapp-production
```

### マイグレーションファイル（19個）
```
migrations/
├── 0000_consolidated_schema.sql      # 統合スキーマ
├── 0000_initial_schema.sql          # 初期スキーマ
├── 0001_add_booking_id_relations.sql
├── 0002_add_booking_id_to_emails.sql
├── 0002_add_cancellation_fee.sql
├── 0003_add_cancellation_fee_paid.sql
├── 0003_add_payment_transaction_id.sql
├── 0004_add_cancel_reason_to_bookings.sql
├── 0004_add_payment_details.sql
├── 0005_change_datetime_to_jst.sql
├── 0022_mark_all_migrations_applied.sql
├── 0023_add_branch_columns_and_data.sql
├── 0024_add_option_categories_data.sql
├── 0026_drop_option_prices_table.sql
├── 0027_add_sales_controls_to_options.sql
└── その他...
```

### 主要テーブル（推測）
- **イベント・商品**: events, products, options
- **予約管理**: bookings, booking_items, booking_payments
- **顧客管理**: members, accounts
- **組織管理**: clients, organizers, vendors, branches
- **決済**: booking_payments（payment_method: credit_card, bank_transfer, convenience_store, free）

## 4️⃣ Cloudflare R2 (オブジェクトストレージ)

### バケット情報

#### バケット1: webapp-products
```
Name:         webapp-products
Created:      2026-02-20 03:05:05 UTC
Binding:      R2
用途:         商品画像、イベント画像
```

#### バケット2: webapp-booking-files
```
Name:         webapp-booking-files
Created:      2026-02-20 03:05:36 UTC
Binding:      BOOKING_FILES
用途:         予約関連ファイル（添付ファイル、ダウンロード用ドキュメント）
```

### TypeScript型定義
```typescript
type Bindings = {
  DB: D1Database;
  R2: R2Bucket;              // webapp-products
  BOOKING_FILES: R2Bucket;   // webapp-booking-files
}
```

### 使用例（コード内）
```typescript
// 商品画像アップロード
await c.env.R2.put(`products/${filename}`, file)

// 予約ファイルダウンロード
const file = await c.env.BOOKING_FILES.get(fileKey)
```

## 5️⃣ 環境変数とシークレット

### 環境変数（vars）
```jsonc
{
  "vars": {
    "APP_MODE": "all"  // 管理画面+顧客画面統合モード
  }
}
```

### シークレット（推測される設定）
以下はコード参照から推測されるシークレット（wrangler secret putで設定）:
- `BASIC_AUTH_USER`: ベーシック認証ユーザー名
- `BASIC_AUTH_PASS`: ベーシック認証パスワード
- `GMO_SITE_ID`: GMOペイメント サイトID
- `GMO_SITE_PASS`: GMOペイメント サイトパスワード
- `GMO_SHOP_ID`: GMOペイメント ショップID
- `GMO_SHOP_PASS`: GMOペイメント ショップパスワード

### シークレット管理コマンド
```bash
# シークレット設定
npx wrangler pages secret put SECRET_NAME --project-name webapp

# シークレット一覧
npx wrangler pages secret list --project-name webapp

# シークレット削除
npx wrangler pages secret delete SECRET_NAME --project-name webapp
```

## 6️⃣ アーキテクチャの特徴

### ✅ 利点
1. **グローバル配信**: エッジネットワークで高速レスポンス
2. **スケーラビリティ**: 自動スケーリング、リクエスト数無制限
3. **低コスト**: 無料プラン（月10万リクエスト、100GBバンド幅）
4. **統合性**: D1, R2がシームレスに連携
5. **型安全**: TypeScript + Hono + Cloudflare Workersの型定義

### ⚠️ 制約
1. **CPU時間制限**: 無料プラン10ms、有料プラン30ms/リクエスト
2. **メモリ制限**: 128MB/リクエスト
3. **実行時間制限**: 最大30秒
4. **Node.js互換性**: `nodejs_compat`フラグで一部対応（fs, pathは不可）
5. **D1データベース**: 現在テーブル数0（マイグレーション適用必要）

## 7️⃣ デプロイフロー

```
┌────────────────────┐
│  ローカル開発      │
│  npm run build     │
│  ↓                 │
│  dist/ 生成        │
└────────────────────┘
         ↓
┌────────────────────┐
│  Git Commit        │
│  git push          │
└────────────────────┘
         ↓
┌────────────────────┐
│  手動デプロイ      │
│  npm run deploy    │
│  ↓                 │
│  wrangler pages    │
│  deploy dist       │
└────────────────────┘
         ↓
┌────────────────────┐
│  Cloudflare Pages  │
│  自動ビルド        │
│  ↓                 │
│  Worker生成        │
│  (_worker.js)      │
└────────────────────┘
         ↓
┌────────────────────┐
│  本番環境          │
│  https://...       │
│  pages.dev         │
└────────────────────┘
```

## 8️⃣ 推奨される次のステップ

### 🔧 データベース設定
```bash
# ローカル開発用D1初期化
npm run db:migrate:local

# 本番D1マイグレーション適用
npm run db:migrate:prod

# テーブル確認
npx wrangler d1 execute webapp-production --command="SELECT name FROM sqlite_master WHERE type='table';"
```

### 🔐 シークレット設定
```bash
# GMOペイメント設定（必要な場合）
npx wrangler pages secret put GMO_SITE_ID --project-name webapp
npx wrangler pages secret put GMO_SITE_PASS --project-name webapp
npx wrangler pages secret put GMO_SHOP_ID --project-name webapp
npx wrangler pages secret put GMO_SHOP_PASS --project-name webapp

# Basic認証設定（必要な場合）
npx wrangler pages secret put BASIC_AUTH_USER --project-name webapp
npx wrangler pages secret put BASIC_AUTH_PASS --project-name webapp
```

### 📊 モニタリング
- Cloudflare Dashboard: https://dash.cloudflare.com
- Pages Analytics: リクエスト数、帯域幅、エラー率
- Workers Analytics: CPU時間、メモリ使用量
- D1 Analytics: クエリ実行時間、行数

---

**最終更新**: 2026-03-09 07:45 UTC
**構成確認日**: 2026-03-09
**Wrangler バージョン**: 4.49.0
