# Cloudflare APIトークン権限確認ガイド

## 🚨 現在の状況

テスト環境用のAPIトークン（`6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY`）は、以下の権限が**不足**しています：

```
❌ D1 Database: Authentication error [code: 10000]
❌ R2 Bucket: Authentication error [code: 10000]
❌ Cloudflare Pages: Authentication error [code: 10000]
```

**現在利用可能な権限**:
- ✅ Account Read（アカウント情報の読み取りのみ）

---

## 📋 必要な権限

テスト環境を利用するには、以下の権限が必要です：

| サービス | 必要な権限 | 現在の状態 | 用途 |
|---------|-----------|----------|------|
| **D1 Database** | Edit | ❌ なし | データベースの作成・マイグレーション・クエリ実行 |
| **Workers R2 Storage** | Edit | ❌ なし | 画像アップロード・ファイル保存 |
| **Cloudflare Pages** | Edit | ❌ なし | アプリケーションのデプロイ |
| **Account** | Read | ✅ あり | アカウント情報の取得 |

---

## 🔧 権限追加方法（ステップバイステップ）

### ステップ1: Cloudflareダッシュボードにログイン

1. ブラウザで以下のURLにアクセス:
   ```
   https://dash.cloudflare.com/login
   ```

2. ログイン情報:
   - **Email**: `orb+keioevent@orb-japan.co.jp`
   - **Password**: （あなたのパスワード）

---

### ステップ2: API Tokensページに移動

ログイン後、以下のURLに**直接アクセス**:
```
https://dash.cloudflare.com/profile/api-tokens
```

**または、手動でナビゲート**:
1. 右上のプロフィールアイコンをクリック
2. 「My Profile」を選択
3. 左メニューから「API Tokens」をクリック

---

### ステップ3: 該当トークンを探す

APIトークン一覧から、以下の方法で該当トークンを特定します:

#### 方法A: トークンの一部で検索
- トークンの**最初の文字**: `6iYpM1...`
- または**最後の文字**: `...HjeY`

#### 方法B: 作成日時で特定
- 最近作成されたトークンを確認

#### 方法C: トークン名で特定
- トークンに名前が付いている場合（例: "ko-event-token"）

---

### ステップ4: トークンを編集

該当トークンの行で「**Edit**」ボタンをクリックします。

---

### ステップ5: 権限を追加

「**Permissions**」セクションで、以下の権限を追加します:

#### ✅ 追加すべき権限（3つ）

1. **Account > D1**
   - Permission: **Edit**
   - 説明: データベースの作成・編集・削除・クエリ実行

2. **Account > Workers R2 Storage**
   - Permission: **Edit**
   - 説明: R2バケットの作成・ファイルアップロード・削除

3. **Account > Cloudflare Pages**
   - Permission: **Edit**
   - 説明: Pagesプロジェクトの作成・デプロイ・設定変更

#### 📸 設定画面のイメージ

```
Permissions:
┌─────────────────────────────────┬──────────┐
│ Account > D1                    │ Edit     │
├─────────────────────────────────┼──────────┤
│ Account > Workers R2 Storage    │ Edit     │
├─────────────────────────────────┼──────────┤
│ Account > Cloudflare Pages      │ Edit     │
└─────────────────────────────────┴──────────┘
```

---

### ステップ6: Account Resourcesを確認

「**Account Resources**」セクションで、正しいアカウントが選択されているか確認:

```
Include:
  ☑ Specific account
    └─ Orb+keioevent@orb-japan.co.jp's Account
       (458b083c565f5d68f3020904bd953002)
```

---

### ステップ7: 設定を保存

1. 「**Continue to summary**」ボタンをクリック
2. 設定内容を確認
3. 「**Update Token**」ボタンをクリック

⚠️ **重要**: トークンを編集すると、**新しいトークン値**が表示されます。
この値は**再表示されない**ため、安全に保存してください。

---

### ステップ8: 新しいトークンを保存（必要な場合）

トークンが再生成された場合:

1. 表示された新しいトークン値をコピー
2. 安全な場所に保存（パスワードマネージャー等）
3. プロジェクトの`.env.test`ファイルを更新:
   ```bash
   cd /home/user/webapp
   nano .env.test
   # CLOUDFLARE_API_TOKEN=新しいトークン値
   ```

---

## ✅ 権限確認（CLI）

権限追加後、以下のコマンドで確認できます:

### 基本確認
```bash
cd /home/user/webapp
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY npx wrangler whoami
```

### D1 Database権限確認
```bash
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY npx wrangler d1 list
```

**期待される結果**:
```
✔ Success
┌──────────────────────────────────┬──────────────────────────────────┐
│ Database ID                      │ Database Name                    │
├──────────────────────────────────┼──────────────────────────────────┤
│ 85cef4a7-802a-461c-bd01-...      │ ko-event-db                      │
└──────────────────────────────────┴──────────────────────────────────┘
```

### R2 Bucket権限確認
```bash
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY npx wrangler r2 bucket list
```

**期待される結果**:
```
┌────────────────┬──────────────────────────────────┐
│ Name           │ Creation Date                    │
├────────────────┼──────────────────────────────────┤
│ ko-event       │ 2026-02-24T00:00:00.000Z         │
└────────────────┴──────────────────────────────────┘
```

### Cloudflare Pages権限確認
```bash
CLOUDFLARE_API_TOKEN=6iYpM1QjAWIa5mcEDVbDLUK7P4DXh2tKcvA8HjeY npx wrangler pages project list
```

**期待される結果**:
```
┌──────────────┬──────────────────────────────────┬──────────────┐
│ Project Name │ Deployment URL                   │ Production   │
├──────────────┼──────────────────────────────────┼──────────────┤
│ ko-event     │ https://ko-event.pages.dev       │ main         │
└──────────────┴──────────────────────────────────┴──────────────┘
```

---

## 🔒 セキュリティのベストプラクティス

### 1. 最小権限の原則

必要最小限の権限のみを付与:
- ✅ D1: Edit（Read + Writeが必要）
- ✅ R2: Edit（Read + Writeが必要）
- ✅ Pages: Edit（Read + Writeが必要）
- ❌ Account Settings: Edit（不要）
- ❌ DNS: Edit（不要）
- ❌ Zone Settings: Edit（不要）

### 2. トークンの有効期限設定

可能であれば、トークンに有効期限を設定:
- 一時的な利用 → 1ヶ月程度
- 長期利用 → 半年〜1年

### 3. トークンの安全な保管

- ✅ パスワードマネージャー（1Password, LastPass等）に保存
- ✅ `.env.test`ファイル（Gitにコミットされない）
- ❌ メール、Slack、チャットツールに送信しない
- ❌ GitHub等の公開リポジトリにコミットしない

### 4. 使用後の無効化

一時的な利用が終了したら:
1. Cloudflareダッシュボードの API Tokens ページにアクセス
2. 該当トークンの「**Roll**」または「**Delete**」をクリック
3. トークンを無効化・削除

---

## 🆘 トラブルシューティング

### Q1: トークンが見つからない

**A**: 以下を確認してください:
- 正しいアカウント（`orb+keioevent@orb-japan.co.jp`）でログインしているか
- トークンが削除されていないか
- 別のCloudflareアカウントで作成されていないか

### Q2: 権限を追加してもエラーが続く

**A**: 以下を試してください:
1. ブラウザのキャッシュをクリア
2. 5〜10分待ってから再試行（権限の反映に時間がかかる場合がある）
3. `wrangler logout` → `wrangler login` で再認証

### Q3: 新しいトークンを再表示したい

**A**: 残念ながら、再表示はできません。以下の選択肢があります:
- 保存した値を使用する
- トークンを「Roll」（再生成）して新しい値を取得
- トークンを削除して新規作成

### Q4: "Authentication error [code: 10000]" が続く

**A**: 以下を確認してください:
- トークンの値が正しいか（コピー時のスペース等）
- Account ID が正しいか（`458b083c565f5d68f3020904bd953002`）
- トークンが有効期限内か
- トークンが無効化されていないか

---

## 📞 サポート

### Cloudflare公式サポート

- **ドキュメント**: https://developers.cloudflare.com/fundamentals/api/get-started/create-token/
- **コミュニティフォーラム**: https://community.cloudflare.com/
- **サポートチケット**: https://dash.cloudflare.com/?to=/:account/support

### このプロジェクトの問題

権限設定後もエラーが続く場合は、以下の情報を提供してください:
1. 実行したコマンド
2. 完全なエラーメッセージ
3. `npx wrangler whoami` の出力結果

---

## 📚 関連ドキュメント

- [テスト環境セットアップガイド](./test_environment_setup.md)
- [Cloudflare API Tokens 公式ドキュメント](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
- [Cloudflare D1 ドキュメント](https://developers.cloudflare.com/d1/)
- [Cloudflare R2 ドキュメント](https://developers.cloudflare.com/r2/)
- [Cloudflare Pages ドキュメント](https://developers.cloudflare.com/pages/)

---

**作成日**: 2026年2月24日  
**最終更新**: 2026年2月24日  
**ステータス**: 権限不足（要対応）  
**次のアクション**: Cloudflareダッシュボードで権限を追加
