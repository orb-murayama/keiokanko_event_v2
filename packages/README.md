# イベント予約管理システム v2 - モノレポ構成

## 📋 プロジェクト概要

イベントのチケット及びオプション（お弁当、駐車場、シャトルバス等）の販売・予約管理システム

**技術スタック**: Hono + TypeScript + Cloudflare Pages + Cloudflare D1 (SQLite)

## 🏗️ プロジェクト構成

このプロジェクトは、以下の3つの独立したアプリケーションに分割されています：

```
packages/
├── shared/              # 共通ライブラリ
│   ├── src/
│   │   ├── database/    # データベースアダプター
│   │   ├── services/    # ビジネスロジック
│   │   ├── middleware/  # 認証・権限管理
│   │   └── types/       # 型定義
│   └── package.json
│
├── api-service/         # 共通APIサービス
│   ├── src/
│   │   ├── routes/      # APIルート
│   │   └── index.ts     # エントリーポイント
│   └── package.json
│
├── customer-site/       # エンドユーザー向けサイト
│   ├── src/
│   │   └── index.ts     # エントリーポイント
│   ├── public/          # 静的ファイル（HTML, CSS, JS）
│   └── package.json
│
└── admin-site/          # 管理者向けサイト
    ├── src/
    │   └── index.ts     # エントリーポイント
    ├── public/          # 静的ファイル（HTML, CSS, JS）
    └── package.json
```

## 🚀 各プロジェクトの役割

### 1. 共通ライブラリ (@keiokanko/shared)

すべてのプロジェクトで共有される機能を提供：

- **データベースアダプター**: D1/MySQL接続
- **サービスレイヤー**: 予約管理、決済、メール送信
- **ミドルウェア**: 認証・権限管理
- **型定義**: 共通のTypeScript型

### 2. 共通APIサービス (@keiokanko/api-service)

すべてのAPIエンドポイントを提供：

- **イベント・商品API**: `/api/events`, `/api/products`
- **予約API**: `/api/bookings`
- **管理者API**: `/api/admin/*`
- **決済API**: `/api/payments`
- **ポート**: 8000
- **デプロイ先**: `keiokanko-api.pages.dev`

### 3. エンドユーザー向けサイト (@keiokanko/customer-site)

お客様向けのフロントエンド：

- イベント一覧・詳細表示
- チケット・オプション購入
- 予約確認
- 決済処理
- **ポート**: 3001
- **デプロイ先**: `keiokanko-customer.pages.dev`

### 4. 管理者向けサイト (@keiokanko/admin-site)

管理者向けのフロントエンド：

- イベント・商品管理
- 予約・顧客管理
- レポート・分析
- 一括操作
- **ポート**: 3002
- **デプロイ先**: `keiokanko-admin.pages.dev`

## 🛠️ セットアップ

### 前提条件

- Node.js >= 18.0.0
- npm >= 9.0.0
- Cloudflare アカウント

### インストール

```bash
# ルートディレクトリで依存関係をインストール
cd packages
npm install
```

## 💻 開発

### 個別にサービスを起動

```bash
# 共通APIサービス（ポート8000）
npm run dev:api

# エンドユーザー向けサイト（ポート3001）
npm run dev:customer

# 管理者向けサイト（ポート3002）
npm run dev:admin
```

### すべてビルド

```bash
npm run build:all
```

## 🚢 デプロイ

### 個別にデプロイ

```bash
# APIサービスのみ
npm run deploy:api

# エンドユーザー向けサイトのみ
npm run deploy:customer

# 管理者向けサイトのみ
npm run deploy:admin
```

### すべてデプロイ

```bash
npm run deploy:all
```

## 📊 データベース

### D1データベース

- **データベース名**: `webapp-v2-production`
- **Database ID**: `cb4e75fc-e88d-429d-86ce-b96a9b5e86de`
- **テーブル数**: 41テーブル

### マイグレーション

```bash
# ローカル環境
npm run db:migrate:local --workspace=@keiokanko/api-service

# 本番環境
npm run db:migrate:prod --workspace=@keiokanko/api-service
```

## 🔐 環境変数

各プロジェクトで以下の環境変数が必要です：

```env
# データベース
DATABASE_URL=...

# GMO決済
GMO_SITE_ID=...
GMO_SITE_PASS=...
GMO_SHOP_ID=...
GMO_SHOP_PASS=...

# メール送信
SMTP_HOST=...
SMTP_PORT=...
SMTP_USER=...
SMTP_PASS=...

# Basic認証（管理画面）
BASIC_AUTH_USERNAME=admin
BASIC_AUTH_PASSWORD=...
```

## 📁 ディレクトリ構造の利点

### 🎯 明確な責任分離

- **API**: ビジネスロジックとデータアクセス
- **Customer**: エンドユーザー体験
- **Admin**: 管理者機能
- **Shared**: 共通機能の再利用

### 🚀 独立したデプロイ

各サービスを個別にデプロイ可能：

- APIの変更が顧客サイトに影響しない
- 管理画面の更新が本番環境に影響しない
- 段階的なロールアウトが可能

### 🔒 セキュリティ向上

- 管理機能とユーザー機能を物理的に分離
- 異なるドメイン・認証方式
- 権限管理の明確化

### 📈 スケーラビリティ

- 各サービスを独立してスケール
- 負荷に応じた最適化
- マイクロサービスへの移行が容易

## 🔗 公開URL

### 本番環境

- **APIサービス**: https://keiokanko-api.pages.dev
- **エンドユーザー向け**: https://keiokanko-customer.pages.dev
- **管理者向け**: https://keiokanko-admin.pages.dev

### 開発環境

- **APIサービス**: http://localhost:8000
- **エンドユーザー向け**: http://localhost:3001
- **管理者向け**: http://localhost:3002

## 📚 ドキュメント

- [API仕様書](./API_SPEC_EVENT_MANAGEMENT.md)
- [データベース設計](./DATABASE_SCHEMA_COMPLETE.md)
- [開発ガイド](./DEVELOPMENT_DOCS_EVENT_MANAGEMENT.md)

## 🤝 貢献

1. 新しいブランチを作成: `git checkout -b feature/amazing-feature`
2. 変更をコミット: `git commit -m 'Add amazing feature'`
3. ブランチをプッシュ: `git push origin feature/amazing-feature`
4. プルリクエストを作成

## 📝 ライセンス

Proprietary - All rights reserved

## 👥 開発者

- **Organization**: OrbJapan
- **Repository**: keiokanko_event_v2
- **Branch**: develop (デフォルト)
