# データベースマイグレーション

## 📁 ディレクトリ構成

```
migrations/
├── 0000_full_schema_backup.sql          # 完全スキーマバックアップ（復旧用）
├── 0001_initial_schema.sql              # 初期スキーマ
├── 0002_fix_deleted_at_null_strings.sql # deleted_at 'NULL'文字列修正
├── 0003_add_event_type_and_hierarchy.sql
├── 0004_add_branch_code_to_events.sql
├── 0005_add_event_images.sql
├── 0006_add_charge_description.sql
├── 0007_add_product_images.sql
├── 0008_add_option_images.sql
├── 0009_add_branch_to_bookings.sql
├── 0010_add_event_image.sql
└── 0011_convert_payment_methods_to_flags.sql # payment_methodsビット形式→個別フラグ
```

---

## 🔧 マイグレーション実行方法

### **ローカル環境（開発用）**

```bash
# 全マイグレーションを適用
npx wrangler d1 migrations apply webapp-production --local

# 特定のマイグレーションを実行
npx wrangler d1 execute webapp-production --local --file=./migrations/0000_full_schema_backup.sql
```

### **本番環境（Cloudflare D1）**

```bash
# 本番DBに適用
npx wrangler d1 migrations apply webapp-production --remote

# 本番DBに特定のマイグレーションを実行
npx wrangler d1 execute webapp-production --remote --file=./migrations/0000_full_schema_backup.sql
```

---

## 🆘 データベース復旧手順

### **完全復旧（全テーブル再作成）**

新しいデータベースで全テーブルを復旧する場合：

```bash
# 1. 完全スキーマを実行
npx wrangler d1 execute webapp-production --local --file=./migrations/0000_full_schema_backup.sql

# 2. その他のマイグレーションを適用
npx wrangler d1 migrations apply webapp-production --local
```

### **部分復旧（特定のテーブルのみ）**

`0000_full_schema_backup.sql` から必要なテーブルのCREATE TABLE文をコピーして実行してください。

---

## 📊 データベーススキーマ概要

### **全28テーブル**

| # | テーブル名 | 説明 | 主要カラム |
|---|-----------|------|----------|
| 1 | accounts | アカウント管理 | login_id, password, role |
| 2 | booking_items | 予約明細 | booking_id, item_type, quantity |
| 3 | bookings | 予約管理 | booking_number, member_id, event_id |
| 4 | branches | 支店管理 | branch_code, branch_name |
| 5 | categories | カテゴリ | name, parent_id |
| 6 | clients | クライアント企業 | name, email, client_code |
| 7 | customers | 顧客 | family_name, email, tel |
| 8 | event_form_fields | イベントフォームフィールド | event_id, field_type, field_name |
| 9 | **events** | **イベント（最重要）** | name, event_url, payment_* |
| 10 | members | 会員 | email, password_hash |
| 11 | option_bookings | オプション予約 | customer_id, option_id |
| 12 | option_categories | オプションカテゴリ | name |
| 13 | option_forms | オプションフォーム | option_id, form_type |
| 14 | option_inherited_products | オプション継承商品 | option_id, product_id |
| 15 | option_prices | オプション価格 | option_id, price |
| 16 | option_shared_stock_pools | オプション共有在庫プール | pool_name, total_stock |
| 17 | option_stocks | オプション在庫 | option_id, date, stock |
| 18 | options | オプション | event_id, name |
| 19 | organizers | 主催者 | name, email, tel |
| 20 | prefs | 都道府県マスタ | id, name |
| 21 | product_bookings | 商品予約 | customer_id, product_id |
| 22 | product_categories | 商品カテゴリ | name |
| 23 | product_prices | 商品価格 | product_id, price, price_band |
| 24 | product_shared_stock_pools | 商品共有在庫プール | pool_name, total_stock |
| 25 | product_stocks | 商品在庫 | product_id, date, stock |
| 26 | products | 商品 | event_id, name, sales_start |
| 27 | shared_stock_pools | 共有在庫プール | pool_name, date, total_stock |
| 28 | vendors | 販売会社 | name, email, tel |

---

## 🔑 重要なテーブル詳細

### **events（イベント管理）**

最も重要なテーブル。全機能の中心。

**主要フィールド**:
- 基本情報: `name`, `detail`, `location`, `event_url`
- 決済設定: `payment_credit_card`, `payment_bank_transfer`, `payment_convenience_store`
- 期間: `event_start_date`, `event_end_date`, `registration_start_date`, `registration_end_date`
- 銀行情報: `bank_name`, `bank_branch`, `bank_account_number`
- コンビニ: `available_convenience_stores`, `convenience_payment_deadline`
- フォーム: `form_field_settings`
- オートリプライ: `auto_reply_*`（日本語・英語）
- 画像: `image_url`
- 親子イベント: `event_type`, `parent_event_id`

---

## 🚨 重要な注意事項

### **1. deleted_at フィールド**

- **問題**: 一部のレコードで `deleted_at = 'NULL'`（文字列）になっている
- **正しい値**: `deleted_at = NULL`（NULLリテラル）
- **修正マイグレーション**: `0002_fix_deleted_at_null_strings.sql`

### **2. payment_methods フィールド**

- **旧形式**: ビット形式（`1`=クレジット, `2`=銀行, `4`=コンビニ）
- **新形式**: 個別フラグ（`payment_credit_card`, `payment_bank_transfer`, `payment_convenience_store`）
- **移行マイグレーション**: `0011_convert_payment_methods_to_flags.sql`
- **互換性**: 旧`payment_methods`カラムは残っています

### **3. 外部キー制約**

SQLiteは外部キー制約がデフォルトで無効です。有効にする場合：

```sql
PRAGMA foreign_keys = ON;
```

---

## 🛠️ 便利なコマンド

### **テーブル一覧表示**

```bash
npx wrangler d1 execute webapp-production --local --command="SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
```

### **テーブル構造確認**

```bash
npx wrangler d1 execute webapp-production --local --command="PRAGMA table_info(events)"
```

### **データ確認**

```bash
npx wrangler d1 execute webapp-production --local --command="SELECT * FROM events WHERE id = 22"
```

### **マイグレーション履歴**

```bash
npx wrangler d1 execute webapp-production --local --command="SELECT * FROM d1_migrations ORDER BY applied_at DESC"
```

---

## 📝 マイグレーション作成ガイド

新しいマイグレーションを作成する場合：

1. **ファイル名**: `XXXX_description.sql`（XXXXは連番）
2. **形式**: 
   ```sql
   -- 変更内容の説明
   
   ALTER TABLE table_name ADD COLUMN new_column TEXT;
   
   -- データ移行（必要な場合）
   UPDATE table_name SET new_column = 'default_value';
   ```
3. **テスト**: ローカル環境で必ずテスト
4. **本番適用**: 問題なければ本番環境に適用

---

## 🔄 バックアップとリストア

### **バックアップ**

```bash
# 全テーブルのスキーマとデータをエクスポート
npx wrangler d1 export webapp-production --local --output=backup.sql
```

### **リストア**

```bash
# バックアップから復元
npx wrangler d1 execute webapp-production --local --file=backup.sql
```

---

## 📞 サポート

問題が発生した場合：

1. マイグレーション履歴を確認
2. ローカル環境でテスト
3. ログを確認: `pm2 logs webapp`
4. データベースの整合性チェック

---

## 📅 更新履歴

- **2026-01-15**: `0000_full_schema_backup.sql` 作成（全28テーブル）
- **2026-01-15**: `0011_convert_payment_methods_to_flags.sql` 追加
- **2026-01-09**: `0002_fix_deleted_at_null_strings.sql` 追加
- **2025-12-26**: 初期マイグレーションファイル作成
