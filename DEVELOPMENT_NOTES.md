# 開発ノート

## HTMLの変更フロー（重要）

### Cloudflare Workers/Pages環境の制約

このプロジェクトはCloudflare Workers/Pages環境で動作しており、以下の制約があります：

1. **ファイルシステムが存在しない**
   - 実行時にファイルを読み込むことができない
   - すべてのHTMLはビルド時にバンドルされる必要がある

2. **HTMLの配信方法**
   - `src/index.tsx`で`?raw`インポート
   - ビルド時に`_worker.js`にバンドル
   - サーバーサイドで`c.html()`で配信

### HTMLを変更した場合の手順

**必須**: HTMLファイルを変更したら必ずビルドが必要です。

```bash
# 1. HTMLファイルを編集
# public/bookings-edit.html などを編集

# 2. ビルド（必須）
npm run build

# 3. サービス再起動
pm2 restart webapp

# 4. 確認
curl http://localhost:3000/bookings-edit.html | grep "確認したい文字列"
```

### JavaScriptのみの変更の場合

JavaScriptファイル（`public/js/`配下）のみを変更した場合は、distにコピーするだけで済みます：

```bash
# JSファイルをdistにコピー
cp public/js/pages/admin-bookings-edit.js dist/static/js/pages/admin-bookings-edit.js

# サービス再起動
pm2 restart webapp
```

### 方法2（serveStatic）が動作しない理由

**試みた方法**: HTMLインポートを削除し、`serveStatic`で動的配信

**失敗した理由**:
1. Cloudflare Workers環境ではファイルシステムアクセスができない
2. `serveStatic`はビルド時にバンドルされたコンテンツのみ配信可能
3. 実行時にHTMLファイルを読み込むことは不可能

**結論**: HTMLインポート方式を継続する必要がある

## 開発効率化のヒント

### ビルド時間の短縮

- HTMLのみ変更: 約10-30秒
- TypeScript変更: 約10-30秒
- JavaScript変更: コピーのみ（1秒未満）

### ブラウザキャッシュのクリア

HTMLやJSを変更した後は、必ずブラウザのキャッシュをクリア：
- **Chrome/Edge**: `Ctrl + Shift + R` または `Ctrl + F5`
- **完全クリア**: `Ctrl + Shift + Delete`

## 認証の方針

現在のHTML配信は`routeAccessControl('admin')`で保護されていますが、将来的には：

1. HTMLは認証なしで配信
2. 各APIで認証を実施
3. HTML直アクセスしてもAPIで401エラーになる

この方針に変更する場合でも、HTMLインポート方式は維持する必要があります。

## バックアップ

DBスキーマバックアップ: `db_schema_backup_20260216_074159.sql`

## 最終更新

- 日時: 2026-02-16
- コミット: f2febad
- リポジトリ: https://github.com/maikeura/keiokanko_event_html
