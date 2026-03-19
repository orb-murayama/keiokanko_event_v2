# 🔑 新しいCloudflare APIトークンの作成手順

既存トークンで権限エラーが解消しない場合は、新しいトークンを作成してください。

## 📝 作成手順

### 1. Cloudflareダッシュボードへアクセス
```
https://dash.cloudflare.com/profile/api-tokens
```

### 2. 「Create Token」をクリック

### 3. 「Create Custom Token」を選択

### 4. トークン設定

#### Token name（トークン名）
```
ko-event-test-token
```

#### Permissions（権限）
以下の3つを追加:

| Permission Type | Permission | Access |
|---|---|---|
| Account | D1 | **Edit** |
| Account | Workers R2 Storage | **Edit** |
| Account | Cloudflare Pages | **Edit** |

#### Account Resources（アカウントリソース）
```
Include: All accounts
```

または

```
Include: Specific account
→ "Orb+keioevent@orb-japan.co.jp's Account"
→ Account ID: 458b083c565f5d68f3020904bd953002
```

#### Client IP Address Filtering（オプション）
```
（空欄でOK）
```

#### TTL（有効期限）
```
Start Date: (今日の日付)
End Date: (テスト終了予定日、または無期限)
```

### 5. 「Continue to summary」をクリック

### 6. 内容確認して「Create Token」をクリック

### 7. トークンをコピー
⚠️ **重要**: このトークンは一度しか表示されません！必ずコピーして保存してください。

---

## 🔄 新しいトークンの設定

### 1. `.env.test` を更新

```bash
cd /home/user/webapp

# 既存ファイルをバックアップ
cp .env.test .env.test.backup

# 新しいトークンを設定
nano .env.test  # または vim, vi
```

以下のように編集:
```env
# Cloudflare Test Environment (ko-event)
CLOUDFLARE_ACCOUNT_ID=458b083c565f5d68f3020904bd953002
CLOUDFLARE_API_TOKEN=【新しいトークンをここに貼り付け】
CLOUDFLARE_EMAIL=orb+keioevent@orb-japan.co.jp

# D1 Database
D1_DATABASE_ID=85cef4a7-802a-461c-bd01-415708be28a5
D1_DATABASE_NAME=ko-event-db

# R2 Bucket
R2_BUCKET_NAME=ko-event

# Project
PROJECT_NAME=ko-event
```

### 2. 権限確認（5-10分後）

```bash
# 自動確認スクリプト
cd /home/user/webapp && /tmp/check_permissions.sh
```

全て✅になったら成功！

### 3. 次のステップ

```bash
# マイグレーション適用
npm run db:migrate:test

# テスト環境デプロイ
npm run deploy:test
```

---

## 🗑️ 古いトークンの削除

新しいトークンが正常に動作したら、古いトークン（`6iYpM1QjAW...HjeY`）は削除してください:

1. https://dash.cloudflare.com/profile/api-tokens
2. 古いトークンの「...」メニュー → 「Revoke」
3. 確認して削除

---

## 📞 サポート

それでもエラーが続く場合:
- Cloudflareのアカウント設定を確認
- 別のCloudflareアカウントかどうか確認
- Cloudflareサポートへ問い合わせ

---

作成日: 2026-02-24
