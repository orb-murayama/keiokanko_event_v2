# オプション在庫管理のInternal Server Error修正レポート

## 📋 概要
- **日時**: 2025-12-24
- **エラー**: オプション在庫管理画面 (`/admin/options/:id/stocks`) でInternal Server Error
- **根本原因**: `option_stocks`テーブルのカラム不足
- **ステータス**: ✅ 解消済み

## 🔍 問題の詳細

### エラーログ
```
D1_ERROR: no such table: option_stocks: SQLITE_ERROR
```

### 根本原因
1. **`option_stocks`テーブルが存在しない** - 初回確認時
2. **テーブル作成後もカラム不足** - 以下のカラムが欠如:
   - `stock_name` (TEXT) - 在庫名（例: 午前便、午後便）
   - `price` (INTEGER) - 料金
   - `total_stock` (INTEGER) - 総在庫数
   - `available_stock` (INTEGER) - 利用可能在庫
   - `enable_flg` (INTEGER) - 有効フラグ（論理削除用）

### 影響範囲
- オプション在庫管理画面の表示エラー
- 在庫追加APIの失敗
- 在庫削除APIの失敗

## 🛠️ 実施した修正

### 1. テーブル構造の修正

**実行したSQL**:
```sql
ALTER TABLE option_stocks ADD COLUMN stock_name TEXT;
ALTER TABLE option_stocks ADD COLUMN price INTEGER;
ALTER TABLE option_stocks ADD COLUMN total_stock INTEGER DEFAULT 0;
ALTER TABLE option_stocks ADD COLUMN available_stock INTEGER DEFAULT 0;
ALTER TABLE option_stocks ADD COLUMN enable_flg INTEGER DEFAULT 1;
```

**修正後のテーブル構造**:
```sql
CREATE TABLE option_stocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  option_id INTEGER NOT NULL,
  date TEXT,                           -- YYYY-MM-DD形式
  stock INTEGER NOT NULL DEFAULT 0,    -- 旧カラム（互換性のため残存）
  booked INTEGER NOT NULL DEFAULT 0,
  stock_name TEXT,                     -- ✅ 新規追加
  price INTEGER,                       -- ✅ 新規追加
  total_stock INTEGER DEFAULT 0,       -- ✅ 新規追加
  available_stock INTEGER DEFAULT 0,   -- ✅ 新規追加
  enable_flg INTEGER DEFAULT 1,        -- ✅ 新規追加（論理削除用）
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (option_id) REFERENCES options(id)
);
```

### 2. APIコードの修正

#### `GET /admin/options/:id/stocks` - 在庫一覧取得
**修正前**:
```typescript
SELECT 
  id, option_id, date,
  stock as total_stock,
  booked,
  (stock - booked) as available_stock
FROM option_stocks
WHERE option_id = ?
```

**修正後**:
```typescript
SELECT 
  id, option_id, date,
  stock_name,              -- ✅ 追加
  price,                   -- ✅ 追加
  total_stock,             -- ✅ 直接取得
  booked,
  available_stock,         -- ✅ 直接取得
  enable_flg
FROM option_stocks
WHERE option_id = ? AND enable_flg = 1  -- ✅ 論理削除対応
ORDER BY date ASC
```

#### HTML表示の更新
```html
<!-- 修正前: 5カラム（日付、総在庫、予約済み、利用可能、アクション） -->

<!-- 修正後: 7カラム -->
<th>日付</th>
<th>在庫名</th>        <!-- ✅ 追加 -->
<th>料金</th>          <!-- ✅ 追加 -->
<th>総在庫</th>
<th>予約済み</th>
<th>利用可能</th>
<th>アクション</th>
```

### 3. マイグレーションファイルの作成

**ファイル**: `migrations/0002_add_option_stocks_columns.sql`

本番環境へのデプロイ時に実行:
```bash
npx wrangler d1 migrations apply webapp-production
```

## ✅ テスト結果

### 1. 在庫追加APIのテスト
```bash
curl -X POST http://localhost:3000/api/options/1/stocks \
  -H "Content-Type: application/json" \
  -d '{
    "dateStart": "2025-12-25",
    "dateEnd": "2025-12-27",
    "stockName": "午前便",
    "price": 1000,
    "totalStock": 50
  }'

# レスポンス
{
  "success": true,
  "message": "3件の在庫を登録しました",
  "count": 3
}
```

### 2. 在庫一覧表示のテスト
```bash
curl http://localhost:3000/admin/options/1/stocks
# ✅ 正常にHTMLが表示
# ✅ 在庫名「午前便」、料金「¥1,000」、総在庫「50」が表示
```

### 3. 在庫削除APIのテスト
```bash
curl -X DELETE http://localhost:3000/api/options/1/stocks/2

# レスポンス
{
  "success": true,
  "message": "在庫を削除しました"
}

# データベース確認（論理削除）
# enable_flg = 0 に変更され、画面には表示されない
```

## 📊 データ例

### 登録された在庫データ
| ID | 日付 | 在庫名 | 料金 | 総在庫 | 予約済み | 利用可能 | 有効 |
|----|------|--------|------|--------|----------|----------|------|
| 1 | 2025-12-25 | 午前便 | 1000 | 50 | 0 | 50 | 1 |
| 2 | 2025-12-26 | 午前便 | 1000 | 50 | 0 | 50 | 0 ← 削除済み |
| 3 | 2025-12-27 | 午前便 | 1000 | 50 | 0 | 50 | 1 |

## 🚀 デプロイ手順

### ローカル環境（開発）
```bash
# ✅ 完了済み
npx wrangler d1 execute webapp-production --local --command="ALTER TABLE..."
```

### 本番環境
```bash
# マイグレーションの適用
npx wrangler d1 migrations apply webapp-production

# コードのデプロイ
npm run build
npx wrangler pages deploy dist --project-name webapp
```

## 📝 関連API仕様

### POST /api/options/:id/stocks
**リクエスト**:
```json
{
  "dateStart": "2025-12-25",    // 必須: 開始日（YYYY-MM-DD）
  "dateEnd": "2025-12-27",      // 必須: 終了日（YYYY-MM-DD）
  "stockName": "午前便",         // 任意: 在庫名
  "price": 1000,                // 必須: 料金
  "totalStock": 50              // 必須: 総在庫数
}
```

**レスポンス**:
```json
{
  "success": true,
  "message": "3件の在庫を登録しました",
  "count": 3
}
```

### DELETE /api/options/:id/stocks/:stockId
**レスポンス**:
```json
{
  "success": true,
  "message": "在庫を削除しました"
}
```
※ 論理削除（`enable_flg = 0`）で実装

## 🔗 関連コミット
- **修正コミット**: `09b2b59` - オプション在庫管理のInternal Server Error解消
- **マイグレーション追加**: `dac4d9d` - オプション在庫管理用のマイグレーションファイル

## 📂 GitHubリポジトリ
https://github.com/maikeura/keiokanko_event

## 📌 今後の推奨事項

1. **初期マイグレーションの更新**: `migrations/0001_initial_schema.sql`に新カラムを含めることを推奨
2. **既存データの移行**: `stock`カラムから`total_stock`へのデータ移行を検討
3. **API化**: 在庫管理画面もAPI+JavaScriptに移行して一貫性を保つ
4. **バリデーション強化**: フロントエンドでの入力チェック追加

## ✅ 完了チェックリスト
- [x] `option_stocks`テーブルの作成
- [x] 必要なカラムの追加
- [x] SELECTクエリの修正
- [x] HTML表示の更新
- [x] 在庫追加APIのテスト
- [x] 在庫削除APIのテスト
- [x] 画面表示の確認
- [x] マイグレーションファイルの作成
- [x] GitHubへのプッシュ
- [x] ドキュメント作成

---

**修正完了日時**: 2025-12-24  
**修正者**: Claude (AI Assistant)  
**確認方法**: ローカル環境でのAPI・画面テスト、データベース直接確認
