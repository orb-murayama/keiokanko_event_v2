# テスト環境セットアップガイド

## 📋 概要

本番環境（webapp-geh）とは別に、テスト環境（ko-event）を設定しました。
テスト環境は一時的な利用を想定しており、Cloudflare Pagesへのデプロイが可能です。

---

## 🔑 認証情報

### テスト環境のCloudflare情報

- **Account ID**: `458b083c565f5d68f3020904bd953002`
- **Account Email**: `orb+keioevent@orb-japan.co.jp`
- **API Token**: `6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY`
- **プロジェクト名**: `ko-event`

### データベース・ストレージ情報

- **D1 Database ID**: `85cef4a7-802a-461c-bd01-415708be28a5`
- **D1 Database Name**: `ko-event-db`（wrangler.jsonc内で定義）
- **R2 Bucket Name**: `ko-event`

---

## 📁 設定ファイル

### 1. `.env.test`

テスト環境用の環境変数ファイル（**Gitにコミットしない**）:

```bash
# テスト環境用のCloudflare認証情報
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY
CLOUDFLARE_ACCOUNT_EMAIL=orb+keioevent@orb-japan.co.jp
```

**重要**: `.gitignore`に`.env.test`が追加されているため、Gitリポジトリにはコミットされません。

### 2. `wrangler.jsonc`

テスト環境の設定が追加されています:

```jsonc
{
  "env": {
    "test": {
      "name": "ko-event",
      "account_id": "458b083c565f5d68f3020904bd953002",
      "vars": {
        "APP_MODE": "all"
      },
      "d1_databases": [
        {
          "binding": "DB",
          "database_name": "ko-event-db",
          "database_id": "85cef4a7-802a-461c-bd01-415708be28a5"
        }
      ],
      "r2_buckets": [
        {
          "binding": "R2",
          "bucket_name": "ko-event"
        },
        {
          "binding": "BOOKING_FILES",
          "bucket_name": "ko-event"
        }
      ]
    }
  }
}
```

### 3. `package.json`

テスト環境用のスクリプトが追加されています:

```json
{
  "scripts": {
    "deploy:test": "npm run build && CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY wrangler pages deploy dist --project-name ko-event --env test",
    "db:migrate:test": "CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY wrangler d1 migrations apply ko-event-db --env test --remote",
    "db:console:test": "CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY wrangler d1 execute ko-event-db --env test --remote"
  }
}
```

---

## 🚀 使い方

### 1. データベースのマイグレーション適用

テスト環境のD1データベースにスキーマを適用します:

```bash
npm run db:migrate:test
```

または直接コマンドで実行:

```bash
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY \
  npx wrangler d1 migrations apply ko-event-db --remote
```

**⚠️ 注意**: APIトークンの権限によっては、Cloudflareダッシュボードから手動でマイグレーションを適用する必要がある場合があります。

### 2. テスト環境へのデプロイ

```bash
npm run deploy:test
```

デプロイ完了後、以下のようなURLでアクセスできます:
```
https://<random-id>.ko-event.pages.dev
https://ko-event.pages.dev  # プロジェクト名で本番URL
```

### 3. データベースコンソールへのアクセス

SQLクエリを直接実行:

```bash
npm run db:console:test -- --command="SELECT * FROM events LIMIT 5"
```

または:

```bash
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY \
  npx wrangler d1 execute ko-event-db --remote \
  --command="SELECT * FROM events LIMIT 5"
```

### 4. データベース操作例

#### イベント一覧取得
```bash
npm run db:console:test -- --command="SELECT id, name, event_url FROM events WHERE deleted_at IS NULL"
```

#### テストデータ投入
```bash
npm run db:console:test -- --file=./seed.sql
```

---

## 🔄 環境の切り替え

### 本番環境（現在の環境）

```bash
# ビルド
npm run build

# デプロイ（本番環境）
npm run deploy

# データベース操作（本番環境）
npm run db:migrate:prod
npm run db:console:prod
```

### テスト環境（新しい環境）

```bash
# ビルド（共通）
npm run build

# デプロイ（テスト環境）
npm run deploy:test

# データベース操作（テスト環境）
npm run db:migrate:test
npm run db:console:test
```

---

## ⚠️ 重要な注意事項

### 1. 環境の独立性

- **本番環境**（`webapp`）と**テスト環境**（`ko-event`）は**完全に独立**しています
- データベース、R2バケット、Pages プロジェクトはすべて別々です
- 本番環境への影響は一切ありません

### 2. APIトークンの権限

提供されたAPIトークン（`6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY`）には、以下の権限が必要です:

- **Cloudflare Pages**: Read + Edit
- **Workers D1**: Read + Edit
- **Workers R2**: Read + Edit

権限が不足している場合、Cloudflareダッシュボードから以下を行ってください:
1. API Tokens ページ（https://dash.cloudflare.com/profile/api-tokens）にアクセス
2. 該当トークンの権限を確認・編集
3. 必要な権限を追加

### 3. R2バケットの作成

R2バケット `ko-event` が存在しない場合、事前に作成が必要です:

```bash
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY \
  npx wrangler r2 bucket create ko-event
```

または、Cloudflareダッシュボードから手動作成:
1. R2 ページ（https://dash.cloudflare.com/<account-id>/r2）にアクセス
2. 「Create bucket」をクリック
3. Bucket名: `ko-event`

### 4. Cloudflare Pages プロジェクトの作成

プロジェクト `ko-event` が存在しない場合、初回デプロイ時に自動作成されます。

または、事前に手動作成:

```bash
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY \
  npx wrangler pages project create ko-event --production-branch main
```

---

## 🛠️ トラブルシューティング

### エラー: "Authentication error [code: 10000]"

**原因**: APIトークンの権限が不足しています。

**解決方法**:
1. Cloudflareダッシュボードにログイン
2. API Tokens ページで該当トークンの権限を確認
3. 必要な権限（Pages、D1、R2）を追加

### エラー: "Couldn't find a D1 DB with the name or binding 'ko-event-db'"

**原因**: D1データベースが存在しないか、データベース名が間違っています。

**解決方法**:
1. Cloudflareダッシュボードで D1 データベース一覧を確認
2. データベースID `85cef4a7-802a-461c-bd01-415708be28a5` が存在するか確認
3. 存在しない場合、ダッシュボードから新規作成

### エラー: "R2 bucket 'ko-event' not found"

**原因**: R2バケットが存在しません。

**解決方法**:
```bash
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY \
  npx wrangler r2 bucket create ko-event
```

---

## 📊 環境比較表

| 項目 | 本番環境 | テスト環境 |
|------|---------|----------|
| **Account ID** | （現在のアカウント） | `458b083c565f5d68f3020904bd953002` |
| **プロジェクト名** | `webapp` | `ko-event` |
| **D1 Database** | `webapp-production` | `ko-event-db` |
| **Database ID** | `123349c1-bc70-4887-9647-e4ca86222564` | `85cef4a7-802a-461c-bd01-415708be28a5` |
| **R2 Bucket** | `webapp-products` | `ko-event` |
| **デプロイコマンド** | `npm run deploy` | `npm run deploy:test` |
| **DB操作** | `npm run db:console:prod` | `npm run db:console:test` |
| **URL例** | `https://webapp-geh.pages.dev` | `https://ko-event.pages.dev` |

---

## 🔐 セキュリティ

### 環境変数ファイルの管理

- **`.env.test`** は **Gitにコミットしない**
- APIトークンは絶対に公開リポジトリにプッシュしない
- チームメンバーには安全な方法（1Password等）で共有

### APIトークンの有効期限

- 一時的な利用とのことなので、使用後はトークンを無効化することを推奨
- Cloudflareダッシュボードからいつでも無効化・削除可能

---

## 📚 関連ドキュメント

- [Cloudflare Pages ドキュメント](https://developers.cloudflare.com/pages/)
- [Cloudflare D1 ドキュメント](https://developers.cloudflare.com/d1/)
- [Cloudflare R2 ドキュメント](https://developers.cloudflare.com/r2/)
- [Wrangler CLI ドキュメント](https://developers.cloudflare.com/workers/wrangler/)

---

## ✅ セットアップ完了後のチェックリスト

- [ ] `.env.test` ファイルが作成されている
- [ ] `wrangler.jsonc` にテスト環境設定が追加されている
- [ ] `package.json` にテスト環境用スクリプトが追加されている
- [ ] `.gitignore` に `.env.test` が追加されている
- [ ] Cloudflare D1 データベース `ko-event-db` が存在する
- [ ] Cloudflare R2 バケット `ko-event` が存在する
- [ ] `npm run db:migrate:test` でマイグレーションが適用できる
- [ ] `npm run deploy:test` でデプロイが成功する
- [ ] デプロイされたURLでアプリケーションが動作する

---

**作成日**: 2026年2月24日  
**更新日**: 2026年2月24日  
**ステータス**: セットアップ完了  
**用途**: テスト環境（一時的な利用）
