# 🔧 Cloudflare APIトークン トラブルシューティング

## 🚨 現在の問題

新しいAPIトークン `oAzdX1LcFreqzlZq9ukJwalI8ErhwHIGKIe4Mo2c` を作成しましたが、認証エラーが発生しています。

### エラー詳細
```
A request to the Cloudflare API (/accounts/5cbc7f6fac80a0b3fa7c96e560e24d62/d1/database) failed.
Authentication error [code: 10000]
```

### 問題の原因
- **期待されるAccount ID**: `458b083c565f5d68f3020904bd953002`
- **実際のAccount ID**: `5cbc7f6fac80a0b3fa7c96e560e24d62` ⚠️

→ トークンが**別のアカウント**に対して作成されているか、トークンの**Account Resources設定が間違っている**可能性があります。

---

## ✅ 解決方法

### 方法1: トークンのAccount Resources設定を確認（最も可能性が高い）

#### 1. Cloudflareダッシュボードへアクセス
```
https://dash.cloudflare.com/profile/api-tokens
```

#### 2. 新しいトークンを見つける
- トークン名: `ko-event-test-token` など
- または末尾 `...Mo2c` で識別

#### 3. 「Edit」をクリック

#### 4. **Account Resources**セクションを確認

**現在の設定（問題あり）**:
```
Account Resources: Include → Specific account → [間違ったアカウント]
Account ID: 5cbc7f6fac80a0b3fa7c96e560e24d62 ❌
```

**正しい設定**:

**オプションA（推奨）**:
```
Account Resources: Include → All accounts
```

**オプションB**:
```
Account Resources: Include → Specific account
→ "Orb+keioevent@orb-japan.co.jp's Account" を選択
→ Account ID: 458b083c565f5d68f3020904bd953002 ✅
```

#### 5. Permissions（権限）を再確認

以下が全て設定されているか確認:

| Permission Type | Resource | Access |
|---|---|---|
| Account | **D1** | **Edit** ✅ |
| Account | **Workers R2 Storage** | **Edit** ✅ |
| Account | **Cloudflare Pages** | **Edit** ✅ |

#### 6. 「Update Token」で保存

#### 7. 5-10分待機してから再テスト

```bash
cd /home/user/webapp && /tmp/verify_new_token.sh
```

---

### 方法2: 完全に新しいトークンを作成（推奨）

既存トークンの修正が難しい場合は、最初から新しいトークンを作成してください。

#### 1. Cloudflareダッシュボードへアクセス
```
https://dash.cloudflare.com/profile/api-tokens
```

#### 2. 「Create Token」をクリック

#### 3. 「Create Custom Token」を選択

#### 4. 設定内容

**Token name**:
```
ko-event-api-token-v2
```

**Permissions**（重要！）:
```
✅ Account | D1 | Edit
✅ Account | Workers R2 Storage | Edit  
✅ Account | Cloudflare Pages | Edit
```

**Account Resources**（重要！）:
```
Include: All accounts
```

または

```
Include: Specific account
→ "Orb+keioevent@orb-japan.co.jp's Account"
→ 必ずAccount ID: 458b083c565f5d68f3020904bd953002 を確認
```

**Client IP Address Filtering**:
```
（空欄）
```

**TTL**:
```
Start: (今日)
End: (テスト終了日 or 無期限)
```

#### 5. 「Continue to summary」→「Create Token」

#### 6. トークンをコピー
⚠️ **一度しか表示されません！** 必ずコピーして保存。

#### 7. `.env.test` を更新

```bash
cd /home/user/webapp

nano .env.test
```

以下のように修正:
```env
CLOUDFLARE_API_TOKEN=【新しいトークンv2をここに貼り付け】
```

#### 8. 即座にテスト

```bash
cd /home/user/webapp && /tmp/verify_new_token.sh
```

---

### 方法3: Wranglerのキャッシュをクリア

Wranglerが古いアカウント情報をキャッシュしている可能性があります。

```bash
# Wranglerログアウト
cd /home/user/webapp && npx wrangler logout

# キャッシュクリア
rm -rf ~/.wrangler
rm -rf .wrangler

# 新トークンで再認証
CLOUDFLARE_API_TOKEN=oAzdX1LcFreqzlZq9ukJwalI8ErhwHIGKIe4Mo2c npx wrangler whoami

# 再テスト
/tmp/verify_new_token.sh
```

---

## 🔍 Account IDの確認方法

### Cloudflare APIで確認

```bash
curl -X GET "https://api.cloudflare.com/client/v4/accounts" \
  -H "Authorization: Bearer oAzdX1LcFreqzlZq9ukJwalI8ErhwHIGKIe4Mo2c" \
  -H "Content-Type: application/json" | jq '.result[] | {id, name}'
```

期待される出力:
```json
{
  "id": "458b083c565f5d68f3020904bd953002",
  "name": "Orb+keioevent@orb-japan.co.jp's Account"
}
```

もし `5cbc7f6fac80a0b3fa7c96e560e24d62` が出力された場合 → **トークンが間違ったアカウントに紐づいています**

---

## 📞 次のステップ

1. **方法1または方法2**を実行してトークンを修正/再作成
2. 5-10分待機（トークン反映時間）
3. `/tmp/verify_new_token.sh` で権限確認
4. 全て✅になったら:
   ```bash
   npm run db:migrate:test
   npm run deploy:test
   ```

---

## 🆘 それでも解決しない場合

以下の情報をご提供ください:
1. Cloudflareダッシュボードのトークン設定画面のスクリーンショット
2. 以下のコマンド結果:
   ```bash
   curl -X GET "https://api.cloudflare.com/client/v4/accounts" \
     -H "Authorization: Bearer oAzdX1LcFreqzlZq9ukJwalI8ErhwHIGKIe4Mo2c" \
     -H "Content-Type: application/json" | jq
   ```

---

作成日: 2026-02-24
