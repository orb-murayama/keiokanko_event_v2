# データベーススキーマドキュメント（完全版）

生成日時: 2026-01-28

## 概要

このファイルは、イベント予約管理システムの**完全なデータベーススキーマ**を含みます。
実際のローカルD1データベースから直接エクスポートされた、すべてのカラムとインデックスを含む完全版DDLです。

## ⚠️ 重要な注意事項

- **このスキーマは復旧用の完全版です**
- すべてのカラム、制約、インデックスが含まれています
- 本番環境への適用前に必ずバックアップを取得してください
- 既存データベースへの適用時はデータ整合性に注意してください

## ファイル構成

- `database_schema_complete.sql` - **完全版DDL**（推奨・復旧用）
- `database_schema.sql` - 簡略版DDL（参考用）

## テーブル一覧（全29テーブル）

### アカウント管理
- **accounts** - アカウント情報
  - ログインID、パスワード、権限
  - アカウントタイプ（keio等）
  - 支店アクセス権限
  - 有効期限、連絡先
  
- **members** - 会員情報
  - 基本情報（氏名、かな、連絡先）
  - 誕生日、性別
  - 備考

### 組織管理
- **clients** - クライアント（顧客企業）
  - **group_id** - クライアントグループID（重要！）
  - 担当者情報、経理担当者
  - 支店、住所、連絡先
  - パスワード（クライアントログイン用）
  
- **vendors** - ベンダー（仕入先）
- **organizers** - 主催者
- **branches** - 支店

### イベント管理
- **events** - イベント情報
  - キャンセルポリシー（5段階設定可能）
  
- **event_form_fields** - イベント用フォームフィールド

### 商品管理
- **product_categories** - 商品カテゴリ
- **products** - 商品
  - slot_type（スロットタイプ）
  - キャンセルポリシー
  - 共通名称（common_names）
  - 課金タイプ（per_person/per_item等）
  - フォームフィールド設定
  
- **product_prices** - 商品価格
  - 価格帯（price_band）
  - スロット番号（slot_number）
  - 共通名称マッピング
  
- **product_stocks** - 商品在庫
  - **available_stock** - 仮想カラム（total_stock - booked）
  
- **product_form_fields** - 商品用フォームフィールド
- **product_shared_stock_pools** - 商品と共有在庫プールの関連
  - 優先度（priority）
  - 価格帯マッピング

### オプション管理
- **option_categories** - オプションカテゴリ
- **options** - オプション
- **option_prices** - オプション価格
- **option_stocks** - オプション在庫
  - **available_stock** - 仮想カラム（total_stock - booked）
  
- **option_forms** - オプション用フォーム
- **option_inherited_products** - オプションが継承する商品
- **option_shared_stock_pools** - オプションと共有在庫プールの関連

### 共有在庫プール
- **shared_stock_pools** - 共有在庫プール
  - pool_name, pool_code
  - 日付、時間帯
  - **available_stock** - 仮想カラム（total_stock - booked）

### 予約管理
- **bookings** - 予約
  - 予約番号、ステータス、支払いステータス
  
- **booking_items** - 予約アイテム（汎用）
- **product_bookings** - 商品予約
- **option_bookings** - オプション予約

### その他
- **customers** - 顧客
- **categories** - カテゴリ（汎用）
- **prefs** - 都道府県

## 重要なカラム解説

### clients.group_id
**クライアントグループID**（NOT NULL, DEFAULT 1）

**用途**:
- 企業グループ管理（親会社と子会社）
- 組織階層（本社と支店）
- 権限管理（同グループ内でデータ共有）
- レポート集計（グループ単位の売上集計）

**デフォルト値**: 1（すべてのクライアントはデフォルトでグループ1に所属）

### 仮想カラム（Generated Columns）
以下のテーブルで`available_stock`を自動計算：
- `product_stocks.available_stock = total_stock - booked`
- `option_stocks.available_stock = total_stock - booked`
- `shared_stock_pools.available_stock = total_stock - booked`

**メリット**:
- 常に最新の利用可能在庫を反映
- 計算ロジックをDBレイヤーで保証
- アプリケーション側での計算不要

### キャンセルポリシー（events/products）
最大5段階のキャンセル料率設定：
```
cancellation_days_1: 7日前
cancellation_rate_1: 0.0 (無料)

cancellation_days_2: 3日前
cancellation_rate_2: 0.5 (50%)

cancellation_days_3: 1日前
cancellation_rate_3: 0.8 (80%)

...
```

## スキーマの適用方法

### ローカル開発環境
```bash
cd /home/user/webapp
npx wrangler d1 execute webapp-production --local --file=database_schema_complete.sql
```

### 本番環境
```bash
cd /home/user/webapp
npx wrangler d1 execute webapp-production --remote --file=database_schema_complete.sql
```

### 既存データベースの完全リセット（注意！）
```bash
# ⚠️ すべてのデータが削除されます！バックアップ必須！

# ローカル環境
rm -rf .wrangler/state/v3/d1
npx wrangler d1 execute webapp-production --local --file=database_schema_complete.sql

# 本番環境（慎重に実行してください）
# 事前に必ずバックアップを取得
npx wrangler d1 execute webapp-production --remote --file=database_schema_complete.sql
```

## マイグレーション

マイグレーションファイルは`migrations/`ディレクトリに格納されています。

### マイグレーションの適用
```bash
# ローカル
npx wrangler d1 migrations apply webapp-production --local

# 本番
npx wrangler d1 migrations apply webapp-production --remote
```

## テーブル間の関連

### 共有在庫プール
```
products ─┐
          ├─→ product_shared_stock_pools ─→ shared_stock_pools
          │
options ──┘    option_shared_stock_pools ──┘
```

### 予約システム
```
bookings ─┬─→ booking_items（汎用）
          ├─→ product_bookings → products → product_stocks
          └─→ option_bookings → options → option_stocks
```

### 組織階層
```
clients (group_id) ─→ グループ管理
   ├─→ accounts（アカウント）
   ├─→ members（会員）
   └─→ events → products → bookings
```

## 復旧手順

### 1. バックアップからの完全復旧
```bash
# 1. 既存データベースを削除
rm -rf .wrangler/state/v3/d1

# 2. スキーマを適用
npx wrangler d1 execute webapp-production --local --file=database_schema_complete.sql

# 3. データをインポート（別途バックアップデータがある場合）
# npx wrangler d1 execute webapp-production --local --file=backup_data.sql

# 4. サービス再起動
pm2 restart webapp
```

### 2. 特定テーブルのみ復旧
```bash
# 特定のテーブルだけ再作成する場合
npx wrangler d1 execute webapp-production --local --command="DROP TABLE IF EXISTS clients"
npx wrangler d1 execute webapp-production --local --command="CREATE TABLE clients (...)"
```

## 更新履歴

- **2026-01-28**: 完全版DDL作成
  - 全29テーブルの完全なDDLをエクスポート
  - すべてのカラム、制約、インデックスを含む
  - clients.group_id等、すべての実カラムを含む
  - 仮想カラム（generated columns）を含む
  - 実際のD1データベースから直接エクスポート

## 関連ドキュメント

- `database_schema_complete.sql` - このスキーマの完全版DDL
- `migrations/` - マイグレーションファイル
- `README.md` - プロジェクト全体のドキュメント
