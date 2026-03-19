# データベースバックアップ情報

## バックアップファイル

- **ファイル名**: `database_backup_full_schema_and_data.sql`
- **作成日時**: 2026-01-07 07:44:38
- **サイズ**: 44KB
- **タイプ**: 完全バックアップ（スキーマ + データ）

## バックアップ内容

### テーブル数: 25

1. **d1_migrations** - マイグレーション履歴
2. **clients** - クライアント情報
3. **events** - イベント情報
4. **products** - 商品情報
5. **product_prices** - 商品価格
6. **product_stocks** - 商品在庫
7. **product_bookings** - 商品予約
8. **product_categories** - 商品カテゴリ
9. **product_shared_stock_pools** - 商品共有在庫プール
10. **options** - オプション情報
11. **option_prices** - オプション価格
12. **option_stocks** - オプション在庫
13. **option_bookings** - オプション予約
14. **option_categories** - オプションカテゴリ
15. **option_forms** - オプションフォーム
16. **option_inherited_products** - オプション継承商品
17. **option_shared_stock_pools** - オプション共有在庫プール
18. **shared_stock_pools** - 共有在庫プール
19. **organizers** - 主催者情報
20. **vendors** - ベンダー情報
21. **customers** - 顧客情報
22. **categories** - カテゴリ
23. **prefs** - 都道府県
24. **accounts** - アカウント
25. **event_form_fields** - イベントフォームフィールド

## 主要なマイグレーション履歴

1. `0000_consolidated_schema.sql` - 初期スキーマ
2. `0001_add_file_columns_to_bookings.sql` - 予約テーブルにファイルカラムを追加
3. `0002_add_participant_payment_info.sql` - 参加者支払い情報を追加
4. `0003_complete_schema_product_bookings.sql` - 商品予約スキーマの完成
5. `0004_add_event_relationships.sql` - イベント親子関係を追加

## サンプルデータ

### イベント（親子構造）

- **親イベント**: 東京モーターショー2025 (ID: 20)
  - **子イベント1**: 出展者登録 (ID: 21) - 商品3点
  - **子イベント2**: 来場者チケット (ID: 22) - 商品3点

### 商品数

- 出展者向け商品: 3点（ブース）
- 来場者向け商品: 3点（チケット）
- 合計: 6点の新規サンプル商品

## リストア方法

### ローカル環境へのリストア

```bash
# データベースをリセット
rm -rf .wrangler/state/v3/d1

# バックアップから復元
npx wrangler d1 execute webapp-production --local --file=./database_backup_full_schema_and_data.sql
```

### 本番環境へのリストア（注意！）

```bash
# 本番環境へのリストアは慎重に
npx wrangler d1 execute webapp-production --remote --file=./database_backup_full_schema_and_data.sql
```

## 注意事項

- このバックアップにはすべてのテーブル定義とデータが含まれています
- マイグレーション履歴も含まれているため、完全な復元が可能です
- 本番環境へのリストアは既存データを上書きするため、事前にバックアップを取得してください
- 外部キー制約が有効になっているため、リストア順序は自動的に調整されます

## バックアップファイルの保管場所

- **ローカル**: `/home/user/webapp/database_backup_full_schema_and_data.sql`
- **Git**: コミット済み（リポジトリに含まれています）
- **GitHub**: https://github.com/maikeura/keiokanko_event

## 次回バックアップ推奨タイミング

- 重要な機能追加後
- マイグレーション実行後
- 大量のデータ投入後
- 本番デプロイ前
