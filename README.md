# イベント予約管理システム v2

## プロジェクト概要
- **名称**: イベント予約管理システム v2
- **目的**: イベントのチケット及びオプション（お弁当、駐車場、シャトルバス等）の販売・予約管理
- **技術スタック**: Hono + TypeScript + Cloudflare Pages + Cloudflare D1 (SQLite)
- **フロントエンド**: HTML5 (セマンティックマークアップ) + CSS3 (カスタムCSS) + JavaScript ES6+ (モジュール)
- **決済**: GMO Payment Gateway（仮売上→売上確定方式）

## 公開URL
- **本番環境**: https://webapp-v2-9w1.pages.dev
- **最新デプロイ**: https://2c8139c1.webapp-v2-9w1.pages.dev (2026-03-19 14:26 JST) ✅ **環境変数設定完了**
- **GitHub**: https://github.com/maikeura/keiokanko_event_v2 ✅ **連携完了**
- **デフォルトブランチ**: develop

## Git ブランチ構成
- **main**: 本番環境用（リリースブランチ）
- **develop**: 開発用（デフォルトブランチ） ✅

## プロジェクト構成
- **プロジェクト名**: webapp-v2
- **Cloudflare Pages**: webapp-v2
- **D1 Database**: webapp-v2-production (ID: cb4e75fc-e88d-429d-86ce-b96a9b5e86de)
  - **テーブル数**: 41テーブル（webapp と同一）
  - **データ**: webappから完全コピー（accounts: 8件、bookings: 88件、events: 5件、products: 12件、options: 7件）
- **R2 Buckets**: 
  - webapp-v2-products (商品画像用)
  - webapp-v2-booking-files (予約ファイル用)

## セットアップ状況
- [x] プロジェクトディレクトリコピー
- [x] Git初期化
- [x] 設定ファイル更新（package.json, wrangler.jsonc, README.md）
- [x] D1データベース作成（41テーブル）
- [x] データベースインポート（webapp から完全コピー）
- [x] R2バケット作成
- [x] Cloudflare Pagesデプロイ
- [x] 環境変数設定（11個の環境変数）
- [x] GitHubリポジトリ連携 ✅

## 注意事項
このプロジェクトは元の `webapp` プロジェクトから独立しています。
- データベースは新規作成（空のデータベース）
- GitHub Organization: OrbJapan
- Repository: keiokanko_event
