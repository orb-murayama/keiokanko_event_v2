# セキュリティ修正実施準備ガイド（明日実施予定）

## 📅 実施予定日時
**2026年3月10日（明日）**

## ⚠️ 重要事項
- **ユーザー打合せへの影響を避けるため、慎重な実施が必要**
- **必ず実施前バックアップを取得**
- **問題発生時は即座にロールバック**

---

## 🎯 修正対象の脆弱性

### 1. Axios 1.6.0 → 1.7.9
- **CVE**: CVE-2023-45857
- **深刻度**: Critical (CVSS 9.8)
- **脆弱性内容**: SSRF（Server-Side Request Forgery）
- **影響範囲**: 26ファイル（HTML/tsx）

### 2. Vue.js @3（不定バージョン） → 3.5.13
- **CVE**: CVE-2024-9506
- **深刻度**: High
- **脆弱性内容**: XSS（Cross-Site Scripting）
- **影響範囲**: 9ファイル

### 3. Font Awesome 6.4.0 → 6.7.2
- **深刻度**: Low（最新版へのアップデート）
- **影響範囲**: 複数ファイル

---

## 📋 実施前チェックリスト

### ✅ 1. 現在の環境確認
```bash
# 現在のバージョン確認
cd /home/user/webapp
grep -r "axios@1.6.0" public/ src/
grep -r "vue@3" public/ src/
grep -r "fontawesome-free@6.4.0" public/ src/

# ビルドが正常に動作するか確認
npm run build

# ローカルテスト環境が起動するか確認
npm run dev:sandbox
# または
pm2 list
```

### ✅ 2. バックアップ作成（**必須**）
```bash
# 日付付きバックアップを作成
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)

# プロジェクト全体のバックアップ
cd /home/user
tar -czf webapp_backup_before_cdn_fix_${BACKUP_DATE}.tar.gz webapp/

# AI Driveにも保存（推奨）
cp webapp_backup_before_cdn_fix_${BACKUP_DATE}.tar.gz /mnt/aidrive/

# バックアップ確認
ls -lh webapp_backup_before_cdn_fix_${BACKUP_DATE}.tar.gz
ls -lh /mnt/aidrive/webapp_backup_before_cdn_fix_${BACKUP_DATE}.tar.gz
```

### ✅ 3. Gitコミット状態確認
```bash
cd /home/user/webapp

# 現在のコミット状態を確認
git status

# 未コミットの変更がある場合は先にコミット
git add .
git commit -m "Pre-CDN-fix backup commit"

# 現在のコミットハッシュを記録（ロールバック用）
git log -1 --oneline > /tmp/current_commit.txt
cat /tmp/current_commit.txt
```

---

## 🚀 実施手順（明日実行）

### ステップ1: バックアップ確認（5分）
```bash
# 上記「2. バックアップ作成」を実行
# バックアップファイルが存在することを確認
ls -lh /home/user/webapp_backup_before_cdn_fix_*.tar.gz
ls -lh /mnt/aidrive/webapp_backup_before_cdn_fix_*.tar.gz
```

### ステップ2: 修正スクリプト実行（5分）
```bash
cd /home/user/webapp

# スクリプトに実行権限があることを確認
ls -l scripts/fix-cdn-vulnerabilities.sh

# スクリプト実行
./scripts/fix-cdn-vulnerabilities.sh

# 実行結果を確認
echo "修正完了。以下の変更が適用されました："
git diff
```

### ステップ3: ビルドとローカルテスト（10分）
```bash
cd /home/user/webapp

# ビルド
npm run build

# ビルドエラーがないか確認
echo $?  # 0なら成功

# ポート3000をクリーンアップ
npm run clean-port

# ローカル開発環境起動（PM2使用）
pm2 start ecosystem.config.cjs

# 起動確認
pm2 list
pm2 logs --nostream

# 基本的な動作確認
curl http://localhost:3000/
curl http://localhost:3000/api/health
```

### ステップ4: フロントエンド動作確認（15分）
```bash
# ブラウザで以下のページをテスト：
# 1. トップページ: http://localhost:3000/
# 2. 商品一覧: http://localhost:3000/products
# 3. 予約フォーム: http://localhost:3000/booking
# 4. 管理画面ログイン: http://localhost:3000/admin/login

# 確認項目：
# ✅ ページが正常に表示される
# ✅ Axiosを使用したAPI呼び出しが動作する
# ✅ Vue.jsコンポーネントが正常に動作する
# ✅ Font Awesomeアイコンが表示される
# ✅ JavaScriptエラーがコンソールに表示されない
```

### ステップ5: 本番デプロイ（5分）
```bash
cd /home/user/webapp

# 変更をコミット
git add .
git commit -m "fix: update CDN libraries to fix security vulnerabilities (Axios 1.7.9, Vue 3.5.13, FontAwesome 6.7.2)"

# 本番デプロイ
npm run deploy

# デプロイ成功を確認
# 出力されたURLをメモ（例: https://webapp-geh.pages.dev）
```

### ステップ6: 本番環境動作確認（10分）
```bash
# 本番URLで同様の確認
# 1. トップページ
# 2. 商品一覧
# 3. 予約フォーム
# 4. 管理画面ログイン

# API動作確認
curl https://webapp-geh.pages.dev/
curl https://webapp-geh.pages.dev/api/health
```

---

## 🔙 ロールバック手順（問題発生時）

### パターンA: ローカルテストで問題が発生した場合
```bash
cd /home/user/webapp

# Gitで元に戻す
git reset --hard HEAD~1

# 再ビルド
npm run build

# PM2再起動
pm2 restart all

# 動作確認
curl http://localhost:3000/
```

### パターンB: 本番デプロイ後に問題が発生した場合
```bash
cd /home/user/webapp

# 前のコミットに戻す
git reset --hard HEAD~1

# 強制プッシュ（注意）
git push -f origin main

# 再デプロイ
npm run deploy

# 本番環境確認
curl https://webapp-geh.pages.dev/
```

### パターンC: 完全ロールバック（バックアップから復元）
```bash
# PM2停止
cd /home/user/webapp
pm2 delete all

# 現在のプロジェクトを退避
cd /home/user
mv webapp webapp_broken_$(date +%Y%m%d_%H%M%S)

# バックアップから復元
tar -xzf webapp_backup_before_cdn_fix_*.tar.gz

# 再起動
cd /home/user/webapp
npm run clean-port
pm2 start ecosystem.config.cjs

# 確認
pm2 list
curl http://localhost:3000/
```

---

## 📊 修正内容の詳細

### 変更されるファイル一覧
```
public/static/product-edit-template.html
public/product-detail.html
public/test-option-api.html
public/auth-email.html
public/participant-info.html
public/payment-method.html
public/booking-complete.html
public/gmo-payment-credit.html
public/gmo-payment-convenience.html
public/payment-callback.html
public/admin-login.html
src/index.tsx
```

### 修正内容
```diff
# Axios
- <script src="https://cdn.jsdelivr.net/npm/axios@1.6.0/dist/axios.min.js"></script>
+ <script src="https://cdn.jsdelivr.net/npm/axios@1.7.9/dist/axios.min.js"></script>

# Vue.js
- <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
+ <script src="https://unpkg.com/vue@3.5.13/dist/vue.global.js"></script>

# Font Awesome
- <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
+ <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.7.2/css/all.min.css" rel="stylesheet">

# Tailwind CSS（変更なし）
<script src="https://cdn.tailwindcss.com"></script>
```

---

## ⏱️ 推定所要時間
| フェーズ | 時間 | 説明 |
|---------|------|------|
| バックアップ | 5分 | tar.gz作成、AI Drive保存 |
| スクリプト実行 | 5分 | CDN URL置換 |
| ビルド | 5分 | npm run build |
| ローカルテスト | 15分 | PM2起動、動作確認 |
| デプロイ | 5分 | Cloudflare Pages |
| 本番確認 | 10分 | 全機能テスト |
| **合計** | **45分** | 問題なければ45分で完了 |

---

## 🚨 注意事項

1. **必ず営業時間外に実施**（推奨: 早朝または深夜）
2. **ユーザー打合せの少なくとも2時間前に完了させる**
3. **問題が発生したら即座にロールバック**
4. **修正後は必ず全機能をテストする**

---

## 📞 問題発生時の連絡先
- **技術担当**: [連絡先]
- **プロジェクトマネージャー**: [連絡先]

---

## ✅ 実施完了後のチェックリスト

- [ ] ローカルテスト完了（全ページ正常表示）
- [ ] 本番デプロイ完了
- [ ] 本番環境テスト完了（全機能動作確認）
- [ ] バックアップファイル保管確認
- [ ] Gitコミット完了
- [ ] ドキュメント更新（本ファイルに実施日時・結果を記録）
- [ ] チームへの完了報告

---

## 📝 実施記録（明日記入）

### 実施日時
- **開始時刻**: ____年____月____日 ____時____分
- **完了時刻**: ____年____月____日 ____時____分
- **所要時間**: ____分

### 実施結果
- [ ] 成功
- [ ] 一部問題あり（詳細: ________________）
- [ ] ロールバック実施

### 発生した問題
```
（あれば記入）
```

### 対処方法
```
（あれば記入）
```

### 備考
```
（あれば記入）
```

---

## 📚 関連ドキュメント
- `/home/user/webapp/docs/cdn_libraries_security_audit.md` - 脆弱性詳細レポート
- `/home/user/webapp/docs/security_audit_report.md` - 全体セキュリティ監査
- `/home/user/webapp/scripts/fix-cdn-vulnerabilities.sh` - 自動修正スクリプト

---

**作成日**: 2026-03-09
**最終更新**: 2026-03-09
**バージョン**: 1.0
