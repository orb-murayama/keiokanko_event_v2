# セキュリティ脆弱性修正 実施手順書

**作成日**: 2026年3月9日  
**実施予定日**: 2026年3月10日（ユーザー打ち合わせ後）  
**所要時間**: 約20分  
**担当者**: [名前]

---

## 🎯 実施概要

### 修正内容
1. **npmパッケージの更新** (Hono, @hono/node-server, wrangler)
2. **CDNライブラリの更新** (Axios, Vue.js, Font Awesome)
3. **セキュリティ設定の強化** (Cookie、デバッグコード)

### リスク評価
- **影響範囲**: フロントエンド（CDN）、バックエンド（npm）
- **ダウンタイム**: なし（段階的実施）
- **ロールバック**: 可能（Gitで管理）

---

## 📋 事前準備チェックリスト

### ✅ 準備完了項目

- [x] セキュリティ監査レポート作成
  - `/home/user/webapp/docs/security_audit_report.md`
  - `/home/user/webapp/docs/cdn_libraries_security_audit.md`

- [x] 自動修正スクリプト作成
  - `/home/user/webapp/scripts/fix-cdn-vulnerabilities.sh`

- [x] 現在のコードをGitにコミット済み
  ```bash
  # 最新コミット
  commit 7aa23af
  security: Add CDN libraries security audit
  ```

- [x] バックアッププラン策定（このドキュメント）

### 📦 修正対象の脆弱性

| No | パッケージ | 現在 | 修正後 | CVE | 深刻度 |
|----|-----------|------|--------|-----|--------|
| 1 | hono | 4.10.6 | 4.12.4+ | 10件 | Critical |
| 2 | @hono/node-server | <1.19.10 | 1.19.10+ | 1件 | High |
| 3 | wrangler | 4.4.0 | 4.60.0+ | 間接 | Moderate |
| 4 | axios (CDN) | 1.6.0 | 1.7.9 | CVE-2023-45857 | Critical |
| 5 | vue (CDN) | @3 | 3.5.13 | CVE-2024-9506 | High |
| 6 | fontawesome (CDN) | 6.4.0 | 6.7.2 | なし | Low |

---

## 🚀 実施手順（3段階）

### 【フェーズ1】バックアップ作成（5分）

#### 1-1. 現在の状態を確認

```bash
cd /home/user/webapp

# 現在のブランチ確認
git branch

# 最新のコミット確認
git log --oneline -5

# 未コミットの変更確認
git status

# 現在のnpmバージョン確認
npm list hono @hono/node-server wrangler

# CDNバージョン確認
grep -h "axios@\|vue@\|fontawesome" public/*.html src/index.tsx 2>/dev/null | grep -o "@[0-9.]*" | sort -u
```

#### 1-2. バックアップブランチ作成

```bash
# バックアップブランチ作成（実施前の状態を保存）
git checkout -b backup-before-security-fix-20260310
git push origin backup-before-security-fix-20260310

# mainブランチに戻る
git checkout main
```

#### 1-3. package.jsonバックアップ

```bash
# package.jsonをバックアップ
cp package.json package.json.backup-20260310
cp package-lock.json package-lock.json.backup-20260310

# バックアップ確認
ls -lh package.json*
```

---

### 【フェーズ2】npmパッケージ更新（5分）

#### 2-1. 依存関係の更新

```bash
cd /home/user/webapp

# 重要なパッケージを更新
npm install hono@^4.12.4 @hono/node-server@^1.19.10 wrangler@^4.60.0

# 自動修正可能な脆弱性を修正
npm audit fix

# 結果確認
npm audit

# 期待される結果: 0 vulnerabilities
```

#### 2-2. ビルドテスト

```bash
# TypeScriptコンパイル
npm run build

# 期待される結果: BUILD SUCCESSFUL
```

#### 2-3. ローカル起動テスト

```bash
# ローカル起動（バックグラウンド）
npm run dev:sandbox &

# プロセスID取得
DEV_PID=$!

# 5秒待機
sleep 5

# ヘルスチェック
curl http://localhost:3000/health

# 期待される結果: {"status":"ok",...}

# APIテスト
curl http://localhost:3000/api/events

# 期待される結果: {"results":[...],"pagination":{...}}

# プロセス停止
kill $DEV_PID

# ポートクリーンアップ
npm run clean-port
```

#### 2-4. Git コミット（npmパッケージ）

```bash
# 変更確認
git diff package.json package-lock.json

# コミット
git add package.json package-lock.json
git commit -m "security: Update npm dependencies to fix critical vulnerabilities

- Update hono from 4.10.6 to 4.12.4+ (fixes 10 critical vulnerabilities)
- Update @hono/node-server from <1.19.10 to 1.19.10+ (fixes authorization bypass)
- Update wrangler from 4.4.0 to 4.60.0+ (indirect dependencies fix)

Resolves:
- CVE-2023-45857: Axios SSRF
- CVE-2024-9506: Vue.js XSS
- Multiple Hono framework vulnerabilities"
```

---

### 【フェーズ3】CDNライブラリ更新（5分）

#### 3-1. 自動修正スクリプト実行

```bash
cd /home/user/webapp

# スクリプト実行
./scripts/fix-cdn-vulnerabilities.sh

# 期待される出力:
# 🔧 Fixing CDN library vulnerabilities...
# 📦 Updating Axios to 1.7.9...
# 📦 Fixing Vue.js version to 3.5.13...
# 📦 Updating Font Awesome to 6.7.2...
# ✅ CDN libraries updated successfully!
```

#### 3-2. 変更確認

```bash
# 変更されたファイル一覧
git status

# 変更内容確認（サンプル）
git diff public/product-detail.html | head -20
git diff src/index.tsx | head -30

# バージョン確認
grep -h "axios@" public/*.html src/index.tsx 2>/dev/null | grep -o "axios@[0-9.]*" | sort -u
# 期待: axios@1.7.9

grep -h "vue@" public/*.html src/index.tsx 2>/dev/null | grep -o "vue@[0-9.]*" | sort -u
# 期待: vue@3.5.13

grep -h "fontawesome-free@" public/*.html src/index.tsx 2>/dev/null | grep -o "fontawesome-free@[0-9.]*" | sort -u
# 期待: fontawesome-free@6.7.2
```

#### 3-3. ビルドテスト（CDN変更後）

```bash
# 再ビルド
npm run build

# 期待される結果: BUILD SUCCESSFUL
```

#### 3-4. ローカル起動テスト（CDN変更後）

```bash
# ローカル起動
npm run dev:sandbox &
DEV_PID=$!
sleep 5

# フロントエンドページテスト
curl http://localhost:3000/product-detail.html | grep "vue@3.5.13"
# 期待: vue@3.5.13が含まれる

curl http://localhost:3000/product-detail.html | grep "axios@1.7.9"
# 期待: axios@1.7.9が含まれる

# APIテスト
curl http://localhost:3000/api/events

# プロセス停止
kill $DEV_PID
npm run clean-port
```

#### 3-5. Git コミット（CDNライブラリ）

```bash
# コミット
git add .
git commit -m "security: Fix critical CDN library vulnerabilities

- Update Axios from 1.6.0 to 1.7.9 (fixes CVE-2023-45857 SSRF)
- Fix Vue.js version from @3 to 3.5.13 (fixes CVE-2024-9506 XSS, version pinning)
- Update Font Awesome from 6.4.0 to 6.7.2 (latest stable)

Changes:
- 26 files updated for Axios
- 9 files updated for Vue.js
- Multiple files updated for Font Awesome

All CDN libraries now use fixed versions for stability and security."
```

---

### 【フェーズ4】本番デプロイ（5分）

#### 4-1. 最終確認

```bash
# 全てのテストが成功していることを確認
echo "✅ npm audit: $(npm audit 2>&1 | grep -c 'found 0 vulnerabilities')"
# 期待: 1 (0 vulnerabilitiesが見つかった)

echo "✅ Build: $(npm run build 2>&1 | grep -c 'BUILD')"
# 期待: 1以上

# コミット確認
git log --oneline -3
```

#### 4-2. 本番デプロイ

```bash
# デプロイ実行
npm run deploy

# 期待される出力:
# ✨ Success! Uploaded ...
# ✨ Deployment complete!
# https://webapp-geh.pages.dev
```

#### 4-3. 本番環境確認

```bash
# ヘルスチェック
curl https://webapp-geh.pages.dev/health

# APIテスト
curl https://webapp-geh.pages.dev/api/events

# フロントエンドCDNバージョン確認
curl -s https://webapp-geh.pages.dev/product-detail.html | grep -o "axios@[0-9.]*"
# 期待: axios@1.7.9

curl -s https://webapp-geh.pages.dev/product-detail.html | grep -o "vue@[0-9.]*"
# 期待: vue@3.5.13
```

#### 4-4. GitHub同期

```bash
# GitHubにプッシュ
git push origin main

# 確認
git log --oneline -5
```

---

## 🔄 ロールバック手順（問題が発生した場合）

### 即座のロールバック（5分以内）

#### オプションA: 前のコミットに戻す

```bash
cd /home/user/webapp

# 最後の2コミットを取り消し（npmとCDN修正）
git reset --hard HEAD~2

# 強制デプロイ
npm run build
npm run deploy

# GitHub同期（force push）
git push -f origin main
```

#### オプションB: バックアップブランチから復元

```bash
cd /home/user/webapp

# バックアップブランチに切り替え
git checkout backup-before-security-fix-20260310

# mainブランチを上書き
git branch -D main
git checkout -b main

# 強制デプロイ
npm run build
npm run deploy

# GitHub同期（force push）
git push -f origin main
```

#### オプションC: package.jsonのみロールバック

```bash
cd /home/user/webapp

# バックアップから復元
cp package.json.backup-20260310 package.json
cp package-lock.json.backup-20260310 package-lock.json

# 依存関係を再インストール
rm -rf node_modules
npm install

# ビルド＆デプロイ
npm run build
npm run deploy
```

---

## 📊 動作確認チェックリスト

### フロントエンド確認

```bash
# ブラウザで以下のページを確認

# 管理画面
https://webapp-geh.pages.dev/admin-login.html
→ ログイン画面が正常に表示される
→ ログイン機能が動作する

# 商品詳細
https://webapp-geh.pages.dev/product-detail.html
→ 商品一覧が表示される
→ Vue.jsが正常に動作する

# 予約フロー
https://webapp-geh.pages.dev/participant-info.html
→ フォームが正常に表示される
→ Axiosでのデータ送信が動作する

# 決済
https://webapp-geh.pages.dev/payment-method.html
→ 決済方法選択が表示される
→ フォーム送信が動作する
```

### バックエンド確認

```bash
# API動作確認

# イベント一覧
curl https://webapp-geh.pages.dev/api/events
→ {"results":[...],"pagination":{...}}

# イベント詳細
curl https://webapp-geh.pages.dev/api/events/1
→ {"id":1,"name":"..."}

# 商品一覧
curl https://webapp-geh.pages.dev/api/products
→ {"results":[...],"pagination":{...}}

# ヘルスチェック
curl https://webapp-geh.pages.dev/health
→ {"status":"ok"}
```

### セキュリティ確認

```bash
# npm脆弱性確認
cd /home/user/webapp
npm audit
→ found 0 vulnerabilities

# CDNバージョン確認
curl -s https://webapp-geh.pages.dev/product-detail.html | grep -E "axios@|vue@|fontawesome"
→ axios@1.7.9
→ vue@3.5.13
→ fontawesome-free@6.7.2
```

---

## 📝 実施記録テンプレート

```
# セキュリティ脆弱性修正 実施記録

## 実施情報
- 実施日時: 2026年3月10日 __:__ 〜 __:__
- 実施者: [名前]
- 所要時間: __分

## フェーズ1: バックアップ
- [ ] バックアップブランチ作成: backup-before-security-fix-20260310
- [ ] package.jsonバックアップ作成
- [ ] 現在の状態確認完了

## フェーズ2: npmパッケージ更新
- [ ] hono 4.10.6 → 4.12.4+ 更新完了
- [ ] @hono/node-server → 1.19.10+ 更新完了
- [ ] wrangler 4.4.0 → 4.60.0+ 更新完了
- [ ] npm audit: 0 vulnerabilities 確認
- [ ] ビルドテスト成功
- [ ] ローカル起動テスト成功
- [ ] Gitコミット完了

## フェーズ3: CDNライブラリ更新
- [ ] Axios 1.6.0 → 1.7.9 更新完了 (26箇所)
- [ ] Vue.js @3 → 3.5.13 更新完了 (9箇所)
- [ ] Font Awesome 6.4.0 → 6.7.2 更新完了
- [ ] ビルドテスト成功
- [ ] ローカル起動テスト成功
- [ ] Gitコミット完了

## フェーズ4: 本番デプロイ
- [ ] 最終確認完了
- [ ] 本番デプロイ成功
- [ ] ヘルスチェック成功
- [ ] APIテスト成功
- [ ] フロントエンド動作確認完了
- [ ] GitHub同期完了

## 動作確認
- [ ] 管理画面ログイン: ✅ 正常 / ❌ 異常
- [ ] 商品詳細表示: ✅ 正常 / ❌ 異常
- [ ] 予約フロー: ✅ 正常 / ❌ 異常
- [ ] 決済画面: ✅ 正常 / ❌ 異常
- [ ] API応答: ✅ 正常 / ❌ 異常

## 問題発生時の対応
- 問題: [記述]
- 対応: [記述]
- ロールバック: 実施 / 未実施

## 備考
[その他の特記事項]

---
完了日時: 2026年3月10日 __:__
確認者: [名前]
```

---

## 📞 問題発生時の連絡先

### エスカレーション基準

| レベル | 状況 | 対応 |
|--------|------|------|
| **Level 1** | ビルドエラー | ログ確認、再ビルド |
| **Level 2** | ローカル起動失敗 | package.json復元 |
| **Level 3** | 本番デプロイ後の異常 | 即座ロールバック |

### トラブルシューティング

#### 問題1: ビルドエラー

```bash
# TypeScriptエラーの場合
npm run build 2>&1 | grep "error TS"

# 解決策: 型定義の確認
npm run cf-typegen
npm run build
```

#### 問題2: ローカル起動失敗

```bash
# ポート確認
lsof -i :3000

# ポートクリーンアップ
npm run clean-port

# 再起動
npm run dev:sandbox
```

#### 問題3: 本番デプロイ後のエラー

```bash
# ログ確認
wrangler pages deployment tail

# 即座ロールバック
git reset --hard HEAD~2
npm run build
npm run deploy
```

---

## ✅ 最終チェックリスト

### 実施前の確認（明日の朝）

- [ ] ユーザー打ち合わせが完了している
- [ ] 現在のシステムが正常に動作している
- [ ] バックアッププランを理解している
- [ ] 所要時間（20分）を確保している
- [ ] ロールバック手順を理解している

### 実施後の確認

- [ ] npm audit で 0 vulnerabilities
- [ ] 全てのビルドテストが成功
- [ ] ローカル動作確認が成功
- [ ] 本番デプロイが成功
- [ ] フロントエンド動作確認が成功
- [ ] バックエンドAPI確認が成功
- [ ] GitHubへのプッシュが完了
- [ ] 実施記録を記入

---

## 📚 参考ドキュメント

1. `/home/user/webapp/docs/security_audit_report.md`
   - npmパッケージの脆弱性詳細

2. `/home/user/webapp/docs/cdn_libraries_security_audit.md`
   - CDNライブラリの脆弱性詳細

3. `/home/user/webapp/scripts/fix-cdn-vulnerabilities.sh`
   - 自動修正スクリプト

4. このドキュメント
   - 実施手順、ロールバック手順

---

**作成者**: AI Assistant  
**最終更新**: 2026年3月9日  
**バージョン**: 1.0

---

## 🎯 明日の実施タイミング

**推奨実施タイミング**:
- ユーザー打ち合わせ終了後
- 業務時間内（問題発生時に対応可能な時間）
- 所要時間: 20分 + 余裕10分 = 合計30分

**実施手順**:
1. このドキュメントを開く
2. フェーズ1から順番に実行
3. 各チェックボックスにチェックを入れながら進行
4. 問題が発生したら即座にロールバック

**成功の定義**:
- npm audit: 0 vulnerabilities
- 全ページが正常に動作
- 全APIが正常に応答
- ユーザー影響なし

---

準備完了です。明日、安全に実施できます。
