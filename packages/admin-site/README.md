# 管理者向けサイト (@keiokanko/admin-site)

## 概要

イベント予約管理システムの管理者向けフロントエンド。
イベント、商品、予約、顧客情報などを管理できます。

## 主な機能

### イベント・商品管理
- イベント作成・編集・削除
- 商品作成・編集・削除
- 在庫管理
- 価格設定

### 予約管理
- 予約一覧・検索
- 予約詳細確認
- 予約ステータス変更
- キャンセル処理

### 顧客管理
- アカウント管理
- メンバー情報管理
- クライアント管理

### レポート・分析
- 売上レポート
- 予約統計
- 在庫状況

### 一括操作
- 一括メール送信
- 一括ドキュメント生成
- 一括メッセージ送信

## セキュリティ

### Basic認証

管理画面へのアクセスにはBasic認証が必要です。

```env
BASIC_AUTH_USERNAME=admin
BASIC_AUTH_PASSWORD=your-secure-password
```

### ロール別アクセス制御

- **管理者**: すべての機能にアクセス可能
- **スタッフ**: 割り当てられたイベントのみ管理可能
- **ビューワー**: 閲覧のみ可能

## 開発

### ローカル開発サーバー起動

```bash
npm run dev
```

ポート3002でサーバーが起動します。

### ビルド

```bash
npm run build
```

### デプロイ

```bash
npm run deploy
```

## ページ構成

### ログイン・ダッシュボード
- `/admin-login.html` - ログインページ
- `/admin-dashboard.html` - ダッシュボード

### マスタ管理
- `/accounts-list.html` - アカウント一覧
- `/members-list.html` - メンバー一覧
- `/clients-list.html` - クライアント一覧
- `/vendors-list.html` - ベンダー一覧
- `/organizers-list.html` - オーガナイザー一覧

### イベント・商品管理
- `/events-list.html` - イベント一覧
- `/events-form.html` - イベント作成・編集
- `/products-list.html` - 商品一覧
- `/products-edit.html` - 商品編集
- `/products-stocks.html` - 在庫管理
- `/options-list.html` - オプション一覧
- `/options-edit.html` - オプション編集

### 予約管理
- `/bookings-list.html` - 予約一覧
- `/bookings-detail.html` - 予約詳細
- `/bookings-edit.html` - 予約編集

### 一括操作
- `/admin-bulk-messages.html` - 一括メッセージ
- `/admin-bulk-documents.html` - 一括ドキュメント
- `/admin-bulk-emails.html` - 一括メール

### ヘルプ
- `/admin-help.html` - ヘルプページ
- `/email-placeholder-help.html` - メールテンプレートヘルプ
- `/document-placeholder-help.html` - ドキュメントテンプレートヘルプ

## API連携

APIサービス (`@keiokanko/api-service`) と連携して動作します。

- API Base URL: `https://keiokanko-api.pages.dev/api`
- または開発環境: `http://localhost:8000/api`

## 環境変数

```env
API_BASE_URL=https://keiokanko-api.pages.dev
BASIC_AUTH_USERNAME=admin
BASIC_AUTH_PASSWORD=your-secure-password
```

## 依存関係

- `@keiokanko/shared` - 共通ライブラリ（認証、型定義など）
- `hono` - Webフレームワーク
