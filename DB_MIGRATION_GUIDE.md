# データベース統合マイグレーション運用ガイド

## 概要

本プロジェクトでは、**統合マイグレーションファイル方式**を採用しています。
従来の段階的マイグレーション（0001, 0002...）は廃止し、
常に最新の完全なDB構造を1つのファイル（`0000_consolidated_schema.sql`）で管理します。

## ファイル構成

```
migrations/
├── 0000_consolidated_schema.sql  # 統合マイグレーションファイル（これだけ使用）
migrations_backup/                 # 旧マイグレーションファイル（バックアップ）
├── 0001_initial_schema.sql
├── 0002_xxx.sql
└── ...（53個の旧ファイル）
```

## データベースリセット手順

### 1. ローカルDBを完全リセット
```bash
cd /home/user/webapp
rm -rf .wrangler/state/v3/d1
```

### 2. 統合マイグレーションを適用
```bash
npx wrangler d1 migrations apply webapp-production --local
```

**これだけで全22テーブル、270+カラムが完全に復元されます。**

## DBスキーマ変更時の運用フロー

### ステップ1: DB変更を実施
APIやアプリケーションの要求に応じて、必要なテーブル/カラムを手動で追加：
```bash
npx wrangler d1 execute webapp-production --local --command="
ALTER TABLE events ADD COLUMN new_column TEXT;
"
```

### ステップ2: 統合マイグレーションファイルを更新
変更後、必ず以下のコマンドで統合ファイルを再生成：

```bash
cd /home/user/webapp

# 全テーブルのスキーマを取得して統合ファイルを更新
./scripts/update_consolidated_migration.sh
```

**または手動で更新：**
1. 現在のDB構造を確認
2. `migrations/0000_consolidated_schema.sql`を編集
3. 変更したテーブル定義を更新

### ステップ3: 動作確認
DBをリセットして、統合マイグレーションだけで復元できることを確認：
```bash
rm -rf .wrangler/state/v3/d1
npx wrangler d1 migrations apply webapp-production --local
```

## 現在のテーブル構成

### 全22テーブル

| # | テーブル名 | カラム数 | 用途 |
|---|-----------|---------|------|
| 1 | clients | 19 | クライアント（主催者）管理 |
| 2 | events | 86 | イベント管理（多言語・決済対応） |
| 3 | products | 36 | 商品管理 |
| 4 | options | 12 | オプション管理 |
| 5 | product_categories | 5 | 商品カテゴリー |
| 6 | option_categories | 5 | オプションカテゴリー |
| 7 | product_prices | 10 | 商品価格 |
| 8 | option_prices | 6 | オプション価格 |
| 9 | product_stocks | 13 | 商品在庫 |
| 10 | option_stocks | 13 | オプション在庫 |
| 11 | product_bookings | 10 | 商品予約 |
| 12 | option_bookings | 10 | オプション予約 |
| 13 | customers | 38 | 会員（顧客）管理 |
| 14 | prefs | 2 | 都道府県マスタ |
| 15 | accounts | 10 | アカウント管理 |
| 16 | organizers | 24 | 主催者管理 |
| 17 | vendors | 18 | 販売業者管理 |
| 18 | categories | 9 | カテゴリー管理 |
| 19 | product_shared_stock_pools | 8 | 商品共有在庫プール |
| 20 | option_shared_stock_pools | 8 | オプション共有在庫プール |
| 21 | option_forms | 5 | オプションフォーム |
| 22 | option_inherited_products | 4 | オプション継承関係 |

**合計: 270+ カラム**

## 重要な注意事項

### ❌ やってはいけないこと
- 新しい段階的マイグレーションファイル（0001, 0002...）を作成しない
- 旧マイグレーションファイルを使用しない
- 統合ファイルを更新せずにDB構造を変更したままにしない

### ✅ 必ずやること
- DB構造変更後は**必ず**統合マイグレーションファイルを更新
- 更新後は必ずリセット→再適用でテスト
- 本番環境デプロイ前に必ず動作確認

## トラブルシューティング

### Q: マイグレーション適用時にエラーが出る
A: 統合ファイルの構文エラーの可能性があります。
   SQLファイルを確認し、必要に応じて手動修正してください。

### Q: テーブルやカラムが不足している
A: 統合ファイルが古い可能性があります。
   現在のDB構造を確認して、統合ファイルを更新してください。

### Q: 本番環境への適用方法は？
A: リモートデータベースへの適用：
```bash
npx wrangler d1 migrations apply webapp-production --remote
```

## 更新履歴

- **2025-12-25**: 統合マイグレーションファイル方式を採用
  - 53個の段階的マイグレーションを1つの統合ファイルに統合
  - 全22テーブル、270+カラムを完全定義
  - 都道府県マスタデータ（47都道府県）を含む
