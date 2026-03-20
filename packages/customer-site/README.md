# エンドユーザー向けサイト (@keiokanko/customer-site)

## 概要

イベント予約管理システムのエンドユーザー向けフロントエンド。
お客様がイベントを閲覧し、チケットやオプションを購入できます。

## 主な機能

### イベント閲覧
- イベント一覧表示
- カテゴリ別フィルタリング
- イベント詳細表示

### 予約・購入
- チケット選択
- オプション追加（お弁当、駐車場、シャトルバスなど）
- 参加者情報入力
- 決済方法選択（クレジットカード、銀行振込、コンビニ決済）

### 決済処理
- GMO Payment Gateway統合
- クレジットカード決済
- コンビニ決済

### 予約確認
- 予約完了メール
- 予約詳細確認

## 開発

### ローカル開発サーバー起動

```bash
npm run dev
```

ポート3001でサーバーが起動します。

### ビルド

```bash
npm run build
```

### デプロイ

```bash
npm run deploy
```

## ページ構成

- `/` - トップページ（イベント一覧へリダイレクト）
- `/product-list` - イベント・商品一覧
- `/product-detail.html` - 商品詳細
- `/auth-email.html` - メール認証
- `/participant-info.html` - 参加者情報入力
- `/payment-method.html` - 支払い方法選択
- `/booking-complete.html` - 予約完了
- `/gmo-payment-credit.html` - クレジットカード決済
- `/gmo-payment-convenience.html` - コンビニ決済
- `/payment-callback.html` - 決済コールバック

## 静的リソース

- `/css/` - スタイルシート
- `/js/` - JavaScriptファイル
- `/static/` - 画像などの静的ファイル

## API連携

APIサービス (`@keiokanko/api-service`) と連携して動作します。

- API Base URL: `https://keiokanko-api.pages.dev/api`
- または開発環境: `http://localhost:8000/api`

## 環境変数

```env
API_BASE_URL=https://keiokanko-api.pages.dev
```

## 依存関係

- `@keiokanko/shared` - 共通ライブラリ（型定義など）
- `hono` - Webフレームワーク
