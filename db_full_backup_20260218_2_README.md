# Database Full Backup - 20260218_2

## バックアップ情報
- **ファイル名**: db_full_backup_20260218_2.sql
- **作成日時**: 2026-02-18 09:17:54
- **データベース**: webapp-production (local)
- **ファイルサイズ**: 105 KB (107,393 bytes)
- **テーブル数**: 39

## 主な変更点（元のバックアップとの違い）
- ✅ **customersテーブルを削除** - membersテーブルに統合済み
- ✅ **membersテーブルのみ使用** - 10件のメンバーデータ
- ✅ **bookings.customer_id** - membersテーブルを参照

## データサマリー

| テーブル | 件数 | 説明 |
|---------|------|------|
| accounts | 10 | 管理者アカウント |
| bookings | 5 | 予約データ（customer_id → members.id） |
| booking_items | 9 | 予約商品明細 |
| booking_emails | 5 | 予約メール履歴 |
| booking_files | 1 | 予約ファイル（領収書等） |
| events | 5 | イベント情報 |
| products | 3 | 商品プラン |
| product_stocks | 212 | 商品在庫 |
| product_prices | 8 | 商品価格設定 |
| product_form_fields | 11 | 商品フォームフィールド |
| members | 10 | 会員情報（customersから統合） |
| clients | 5 | 取引先情報 |
| organizers | 5 | 主催者情報 |
| vendors | 5 | ベンダー情報 |
| branches | 26 | 支店情報 |
| prefs | 47 | 都道府県マスタ |
| refund_history | 1 | 返金履歴 |
| email_templates | 1 | メールテンプレート |
| d1_migrations | 11 | マイグレーション履歴 |

## 空のテーブル（データなし）
- booking_messages
- booking_payments (後で削除されたため)
- categories
- event_form_fields
- event_staff
- gmo_payment_logs
- option_* (全オプション関連テーブル)
- product_bookings
- product_categories
- product_shared_stock_pools
- shared_stock_pools
- otp_tokens

## 使用方法

### 1. 復元（新しいデータベースに）
```bash
cd /home/user/webapp
python3 restore_data.py  # カスタムスクリプト使用
```

### 2. 確認
```bash
npx wrangler d1 execute webapp-production --local --command="SELECT COUNT(*) FROM members"
npx wrangler d1 execute webapp-production --local --command="SELECT COUNT(*) FROM bookings"
```

### 3. customersテーブルがないことを確認
```bash
npx wrangler d1 execute webapp-production --local --command="SELECT name FROM sqlite_master WHERE type='table' AND name='customers'"
# 結果: 0件（customersテーブルは存在しない）
```

## 注意事項
- このバックアップには**customersテーブルが含まれていません**
- すべての会員データは**membersテーブル**に統合されています
- `bookings.customer_id`は`members.id`を参照します
- 古いバックアップから復元する場合は、customersテーブルを手動で削除する必要があります

## 関連コミット
- `4d8626e` - refactor: Replace customers table with members table
- `be0dfe3` - refactor: Change booking detail API to use members table instead of customers
