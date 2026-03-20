# 共通APIサービス (@keiokanko/api-service)

## 概要

イベント予約管理システムの共通APIサービス。すべてのビジネスロジックとデータアクセスを提供します。

## 主な機能

### イベント管理API
- イベント一覧・検索
- イベント詳細情報
- カテゴリ管理

### 商品管理API
- 商品一覧・検索
- 商品詳細情報
- 価格・在庫管理

### 予約管理API
- 予約作成・更新・削除
- 予約一覧・検索
- 予約状態管理

### 決済API
- GMO決済統合
- 決済状態管理
- 決済履歴

### 管理者API
- アカウント管理
- メンバー管理
- 一括操作

## 開発

### ローカル開発サーバー起動

```bash
npm run dev
```

ポート8000でサーバーが起動します。

### ビルド

```bash
npm run build
```

### デプロイ

```bash
npm run deploy
```

## APIエンドポイント

### 公開API

- `GET /api/events` - イベント一覧
- `GET /api/events/:id` - イベント詳細
- `GET /api/products` - 商品一覧
- `GET /api/products/:id` - 商品詳細
- `POST /api/bookings` - 予約作成
- `GET /api/bookings/:id` - 予約詳細

### 管理者API（認証必須）

- `GET /api/admin/bookings` - 予約管理
- `POST /api/admin/events` - イベント作成
- `PUT /api/admin/events/:id` - イベント更新
- `DELETE /api/admin/events/:id` - イベント削除

## 環境変数

必要な環境変数は、Cloudflare Pagesの設定で管理します。

## データベース

D1データベース（SQLite）を使用：
- Database: `webapp-v2-production`
- マイグレーション: `migrations/` ディレクトリ

## 依存関係

- `@keiokanko/shared` - 共通ライブラリ
- `hono` - Webフレームワーク
- `csv-parse` - CSV解析
- `exceljs` - Excel処理
