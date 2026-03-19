# 管理画面とお客様側画面の分離デプロイ手順

## 概要

このプロジェクトは、単一のコードベースで**お客様側画面**と**管理画面**を環境変数により分離して動作させることができます。

## 環境変数による分岐

- `APP_MODE=customer`: お客様側画面のみ動作
- `APP_MODE=admin`: 管理画面のみ動作
- `APP_MODE=all`: 両方動作（開発環境用、デフォルト）

## ローカル開発環境

### 両方動作させる場合（デフォルト）

```bash
npm run build
npm run dev:sandbox
```

アクセス:
- お客様側: http://localhost:3000/
- 管理画面: http://localhost:3000/admin

### お客様側のみ動作させる場合

```bash
# .dev.vars ファイルを作成
echo "APP_MODE=customer" > .dev.vars

npm run build
npm run dev:sandbox
```

アクセス:
- お客様側: http://localhost:3000/ ✅
- 管理画面: http://localhost:3000/admin ❌ (404エラー)

### 管理画面のみ動作させる場合

```bash
# .dev.vars ファイルを作成
echo "APP_MODE=admin" > .dev.vars

npm run build
npm run dev:sandbox
```

アクセス:
- お客様側: http://localhost:3000/ ❌ (404エラー)
- 管理画面: http://localhost:3000/admin ✅

## 本番環境へのデプロイ

### 1. Cloudflare Pages プロジェクトを2つ作成

お客様側と管理画面用に2つのプロジェクトを作成します。

```bash
# お客様側プロジェクト作成
npx wrangler pages project create webapp-customer \
  --production-branch main \
  --compatibility-date 2025-11-20

# 管理画面プロジェクト作成
npx wrangler pages project create webapp-admin \
  --production-branch main \
  --compatibility-date 2025-11-20
```

### 2. 環境変数を設定

Cloudflare Pagesダッシュボードで環境変数を設定します。

#### お客様側 (webapp-customer)

Settings > Environment variables > Production:
```
APP_MODE = customer
```

#### 管理画面 (webapp-admin)

Settings > Environment variables > Production:
```
APP_MODE = admin
```

### 3. デプロイ

```bash
# お客様側をデプロイ
npm run deploy:customer

# 管理画面をデプロイ
npm run deploy:admin
```

## デプロイURL例

デプロイ後、以下のようなURLでアクセス可能になります:

- **お客様側**: https://webapp-customer.pages.dev
- **管理画面**: https://webapp-admin.pages.dev

## カスタムドメインの設定

Cloudflare Pagesダッシュボードで独自ドメインを設定できます:

- お客様側: https://booking.example.com
- 管理画面: https://admin.example.com

## データベース・ストレージの共有

お客様側と管理画面は同じD1データベースとR2ストレージを共有します:

- **D1 Database**: `webapp-production`
- **R2 Bucket**: `webapp-products`

両方のプロジェクトで同じデータベースIDとバケット名を設定してください。

## トラブルシューティング

### 404エラーが発生する

- 環境変数 `APP_MODE` が正しく設定されているか確認
- Cloudflare Pagesダッシュボードで環境変数が反映されているか確認
- 再デプロイしてキャッシュをクリア

### APIが動作しない

- APIエンドポイント (`/api/*`) は両方の環境で共通で動作します
- D1データベースとR2バケットの設定が正しいか確認

### ローカル開発でテストしたい

```bash
# お客様側のテスト
cp .dev.vars.customer .dev.vars
npm run build
npm run dev:sandbox

# 管理画面のテスト
cp .dev.vars.admin .dev.vars
npm run build
npm run dev:sandbox
```

## セキュリティ注意事項

1. **管理画面のアクセス制御**: 
   - Cloudflare Access や IP制限を設定することを推奨
   - 認証機能の実装を検討

2. **API保護**: 
   - 管理画面APIには認証トークンの実装を推奨
   - お客様側APIは公開されることを前提に設計

3. **環境変数の管理**: 
   - `.dev.vars` ファイルは `.gitignore` に含める
   - 本番環境の環境変数はCloudflareダッシュボードで管理

## まとめ

この構成により、単一コードベースで2つの独立したアプリケーションとして動作させることができ:

- ✅ コード共有が可能
- ✅ APIの統一管理
- ✅ データベースの一元管理
- ✅ 別サーバーでの動作
- ✅ セキュリティの分離

メンテナンスが容易で、かつセキュアな運用が可能です。
