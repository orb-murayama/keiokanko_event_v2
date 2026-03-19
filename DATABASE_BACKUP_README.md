# データベースバックアップ - 2026年2月18日

## 📦 生成されたファイル

| ファイル名 | サイズ | 行数 | 説明 |
|-----------|-------|------|------|
| **db_full_backup_20260218.sql** | 132KB | 1,450行 | ✅ **推奨** 完全バックアップ（スキーマ+データ） |
| **db_schema_20260218.sql** | 22KB | 802行 | スキーマ定義のみ（CREATE TABLE文） |
| **db_data_20260218.sql** | 112KB | 676行 | データのみ（INSERT文） |

---

## 🗄️ データベース統計

- **テーブル数**: 38テーブル
- **総レコード数**: 266レコード
- **エクスポート日時**: 2026年2月18日 01:00:36

### テーブル別レコード数

| テーブル | レコード数 | 説明 |
|---------|----------|------|
| accounts | 10 | アカウント情報 |
| branches | 26 | 支店情報 |
| prefs | 47 | 都道府県マスタ |
| clients | 3 | クライアント情報 |
| organizers | 5 | 主催者情報 |
| events | 5 | イベント情報 |
| products | 12 | 商品情報 |
| product_prices | 43 | 商品価格 |
| product_stocks | 86 | 商品在庫 |
| options | 3 | オプション情報 |
| option_prices | 3 | オプション価格 |
| option_stocks | 21 | オプション在庫 |
| bookings | 2 | 予約情報 |
| その他 | - | メール、カテゴリーなど |

---

## 🔄 復元方法

### 方法1: 完全バックアップから復元（推奨）

```bash
# 1. データベースをクリーン
rm -rf .wrangler/state/v3/d1/*.sqlite*

# 2. マイグレーションを適用
npx wrangler d1 migrations apply webapp-production --local

# 3. データを復元（INSERT文を実行）
# スキーマは既にマイグレーションで作成されているため、INSERTのみ実行
grep "^INSERT INTO" db_full_backup_20260218.sql > restore_data_only.sql
npx wrangler d1 execute webapp-production --local --file=restore_data_only.sql
```

### 方法2: データのみを復元

```bash
# データベースが既に存在する場合
npx wrangler d1 execute webapp-production --local --file=db_data_20260218.sql
```

### 方法3: ゼロから復元

```bash
# 1. データベースファイルを削除
rm -rf .wrangler/state/v3/d1/*.sqlite*

# 2. 完全バックアップを実行
npx wrangler d1 execute webapp-production --local --file=db_full_backup_20260218.sql
```

---

## 📋 主要テーブルの構造

### eventsテーブル (100カラム)
- イベントの基本情報、開催日、支払い設定、キャンセルポリシーなど
- **image_url**: イベント画像URL ✅

### productsテーブル (38カラム)
- 商品の基本情報、説明、料金に含まれるもの、キャンセルポリシーなど
- **image_url**: 商品画像URL ✅

### optionsテーブル (13カラム)
- オプションの基本情報、説明、注意事項など
- **image_url**: オプション画像URL ✅

### 価格・在庫テーブル
- **product_prices**: 商品価格（大人/子供などのカテゴリー別）
- **product_stocks**: 商品の日別在庫
- **option_prices**: オプション価格
- **option_stocks**: オプションの日別在庫

---

## 🔍 データ確認

### イベント一覧
```sql
SELECT id, name, event_start_date, event_end_date 
FROM events 
WHERE enable_flg = 1;
```

| ID | イベント名 | 開始日 | 終了日 |
|----|-----------|--------|--------|
| 1 | 富士山登山ツアー2026夏 | 2026-08-01 | 2026-08-31 |
| 2 | 箱根温泉リゾート 春の特別プラン | 2026-04-01 | 2026-05-31 |
| 3 | 東京1日観光ツアー 英語ガイド付き | 2026-01-01 | 2026-12-31 |
| 4 | 多摩丘陵サイクリング 紅葉満喫コース | 2026-10-15 | 2026-11-30 |
| 5 | 里山エコツーリズム 自然体験プログラム | 2026-04-01 | 2026-06-30 |

### 商品一覧（イベント3）
```sql
SELECT id, name, image_url 
FROM products 
WHERE event_id = 3 AND enable_flg = 1;
```

| ID | 商品名 | 画像URL |
|----|--------|---------|
| 1 | 東京1日観光ツアー スタンダードプラン | https://placehold.co/400x300/3b82f6/ffffff?text=Standard+Tour |
| 2 | 東京1日観光ツアー プレミアムプラン | https://placehold.co/400x300/f59e0b/ffffff?text=Premium+Tour |
| 3 | 東京プライベート観光ツアー（貸切） | https://placehold.co/400x300/8b5cf6/ffffff?text=Private+Tour |

---

## ⚙️ エクスポートスクリプト

バックアップの生成に使用したスクリプト:
- `export_database.py` - Pythonスクリプト（sqlite3モジュール使用）

### 再エクスポート方法

```bash
python3 export_database.py
```

自動的に以下のファイルが生成されます:
- `db_schema_YYYYMMDD.sql`
- `db_data_YYYYMMDD.sql`
- `db_full_backup_YYYYMMDD.sql`

---

## 📝 注意事項

1. **外部キー制約**: 復元時は `PRAGMA foreign_keys=OFF;` が設定されています
2. **トランザクション**: データ復元はトランザクション内で実行されます
3. **文字エスケープ**: シングルクォートは `''` にエスケープされています
4. **NULL値**: NULL値は `NULL` として明示的に記録されています
5. **マイグレーション**: スキーマはマイグレーションファイルから作成することを推奨

---

## 🔐 セキュリティ

- パスワードは bcrypt でハッシュ化されています（$2a$10$...）
- バックアップファイルには機密情報が含まれる可能性があります
- 本番環境へのデプロイ前に `.gitignore` に追加してください

```bash
# .gitignore に追加
db_*.sql
!db_schema.sql  # スキーマのみは許可する場合
```

---

## 📚 関連ドキュメント

- [TABLE_STRUCTURE_SUMMARY.md](./TABLE_STRUCTURE_SUMMARY.md) - 詳細なテーブル構造
- [table_structure_summary.md](./table_structure_summary.md) - 完全なカラム定義

---

**作成日**: 2026年2月18日  
**データベース**: webapp-production (D1 Local)  
**バックアップ方法**: Python sqlite3 module
