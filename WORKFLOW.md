# 開発ワークフロー

## 📋 **基本方針**

### ✅ **実施すること**
1. **本番環境直接デプロイ**: サンドボックスでのテストは行わず、本番環境にデプロイ後にテスト
2. **定期的なGitHubプッシュ**: 作業の節目で必ずリモートリポジトリにプッシュ
3. **新テーブル作成時の承認**: 新規テーブルを作成する際は、必ず承認を得てから実施

### ❌ **実施しないこと**
- サンドボックス環境でのテスト実行
- ローカル開発サーバーの起動（`wrangler pages dev`）
- PM2によるサービス起動

---

## 🚀 **デプロイワークフロー**

### **1. コード修正**
```bash
# ファイル編集後、必ずgitコミット
cd /home/user/webapp
git add -A
git commit -m "修正内容の説明"
```

### **2. GitHubプッシュ**
```bash
# GitHub認証が必要な場合
# setup_github_environment ツールを呼び出し

cd /home/user/webapp
git push origin main
```

### **3. 本番環境デプロイ**
```bash
# Cloudflare API認証が必要な場合
# setup_cloudflare_api_key ツールを呼び出し

cd /home/user/webapp
npm run build
npx wrangler pages deploy dist --project-name webapp
```

### **4. 本番環境でテスト**
```bash
# デプロイ完了後、本番URLで動作確認
curl https://webapp-geh.pages.dev/api/health
```

---

## 🗃️ **データベースマイグレーション**

### **マイグレーションファイル管理**
- **初期スキーマ**: `migrations/0000_initial_schema.sql`
- **履歴**:
  - `migrations/0001_add_booking_id_relations.sql` - booking_idリレーション追加
  - `migrations/0002_add_booking_id_to_emails.sql` - booking_emailsテーブルにbooking_id追加

### **新規マイグレーション作成手順**

#### **1. マイグレーションファイル作成**
```bash
# ファイル名: migrations/XXXX_description.sql
# 例: migrations/0003_add_user_profiles.sql

cat > /home/user/webapp/migrations/0003_add_user_profiles.sql << 'EOF'
-- 新しいテーブルを作成
CREATE TABLE IF NOT EXISTS user_profiles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  bio TEXT,
  avatar_url TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (user_id) REFERENCES members(id)
);

-- インデックスを作成
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
EOF
```

#### **2. 本番環境適用**
```bash
cd /home/user/webapp
npx wrangler d1 migrations apply webapp-production --remote
```

#### **3. ローカル環境適用（開発用）**
```bash
cd /home/user/webapp
npx wrangler d1 migrations apply webapp-production --local
```

### **⚠️ 新テーブル作成時の注意**
**新しいテーブルを作成する際は、必ず以下の手順を守ってください：**

1. **承認を得る**: テーブル定義を提示し、承認を得る
2. **マイグレーションファイル作成**: `migrations/`ディレクトリに作成
3. **本番環境適用**: `--remote`フラグで本番DBに適用
4. **コミット**: マイグレーションファイルをgitにコミット

---

## 📦 **定期的なバックアップ**

### **データベーススキーマのエクスポート**
```bash
# 全テーブルDDL取得
npx wrangler d1 execute webapp-production --remote \
  --command="SELECT sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name"

# インデックス取得
npx wrangler d1 execute webapp-production --remote \
  --command="SELECT sql FROM sqlite_master WHERE type='index' AND sql IS NOT NULL AND name NOT LIKE 'sqlite_%' ORDER BY name"
```

### **GitHub定期プッシュタイミング**
- コード修正完了後
- マイグレーション適用後
- 本番デプロイ成功後
- 大きな機能追加完了後

---

## 🔍 **トラブルシューティング**

### **デプロイエラー時**
```bash
# 1. ビルドエラー確認
npm run build

# 2. wranglerログ確認
cat ~/.config/.wrangler/logs/wrangler-*.log | tail -50

# 3. Git状態確認
git status
git log --oneline -5
```

### **データベースエラー時**
```bash
# 1. マイグレーション履歴確認
npx wrangler d1 execute webapp-production --remote \
  --command="SELECT * FROM d1_migrations ORDER BY applied_at DESC"

# 2. テーブル一覧確認
npx wrangler d1 execute webapp-production --remote \
  --command="SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
```

---

## 📝 **チェックリスト**

### **コード修正後**
- [ ] `git add -A && git commit -m "..."`
- [ ] `git push origin main`
- [ ] `npm run build`
- [ ] `npx wrangler pages deploy dist --project-name webapp`
- [ ] 本番環境で動作確認

### **マイグレーション実施後**
- [ ] マイグレーションファイル作成
- [ ] 本番環境適用 `--remote`
- [ ] マイグレーションファイルをgitコミット
- [ ] GitHubプッシュ
- [ ] 本番環境で動作確認

### **新テーブル作成前**
- [ ] テーブル定義を提示
- [ ] 承認を得る
- [ ] マイグレーションファイル作成
- [ ] 本番環境適用
- [ ] 動作確認
