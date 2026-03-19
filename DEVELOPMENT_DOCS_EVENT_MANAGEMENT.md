# イベント管理 開発資料まとめ

**作成日**: 2026-01-28  
**対象システム**: イベント予約管理システム

---

## 📋 ドキュメント一覧

### 1. API仕様書
**ファイル**: [API_SPEC_EVENT_MANAGEMENT.md](./API_SPEC_EVENT_MANAGEMENT.md)

**内容**:
- イベント管理に関する全APIエンドポイントの詳細仕様
- リクエスト・レスポンス形式
- エラーハンドリング
- 認証・認可

**主要API**:
- `GET /api/events` - イベント一覧取得
- `GET /api/events/:id` - イベント詳細取得
- `POST /api/events` - イベント新規作成
- `PUT /api/events/:id` - イベント更新
- `DELETE /api/events/:id` - イベント削除
- `POST /api/v1/events/:id/copy` - イベントコピー
- その他、商品・オプション・日程関連API

---

### 2. データベース要件仕様書
**ファイル**: [DB_REQUIREMENTS_EVENT_MANAGEMENT.md](./DB_REQUIREMENTS_EVENT_MANAGEMENT.md)

**内容**:
- データベース設計方針
- テーブル定義（events, event_form_fields）
- カラム詳細説明
- インデックス戦略
- データ整合性ルール
- パフォーマンス要件
- セキュリティ要件

**主要テーブル**:
- `events` - イベント基本情報（87カラム）
- `event_form_fields` - イベント固有フォームフィールド

---

### 3. データベーススキーマ完全版
**ファイル**: [database_schema_complete.sql](./database_schema_complete.sql)

**内容**:
- 全29テーブルのDDL
- CREATE TABLE文
- インデックス定義
- 外部キー制約

**復旧用SQL**: データベースを一から構築できる完全版DDL

---

### 4. データベーススキーマドキュメント
**ファイル**: [DATABASE_SCHEMA_COMPLETE.md](./DATABASE_SCHEMA_COMPLETE.md)

**内容**:
- 全テーブルの概要説明
- 主要カラムの説明
- テーブル間の関連
- 復旧手順

---

## 🎯 開発会社様へのお願い

### 1. API開発時の注意点

#### 認証・認可
- 管理APIは`routeAccessControl('admin')`ミドルウェアで認証必須
- Cookie-based Session Authenticationを使用
- フロントエンド向けAPIは一部公開可能

#### データ形式
- リクエスト・レスポンス: JSON形式
- 日時: `YYYY-MM-DD HH:MM:SS`形式（JST）
- 論理削除: `deleted_at`カラムで管理

#### バリデーション
- 必須フィールドチェック
- イベントURLの一意性チェック
- 日付の整合性チェック（開始日 <= 終了日）

#### エラーハンドリング
- 適切なHTTPステータスコードを返却
- エラーメッセージは日本語で返却
- 詳細なエラーログをコンソールに出力

---

### 2. データベース設計時の注意点

#### 命名規則
- テーブル名: 複数形の英小文字（例: `events`）
- カラム名: スネークケース（例: `event_url`）
- 外部キー: `{参照先テーブル}_id`

#### 論理削除
- 物理削除は行わず、`deleted_at`で論理削除
- `deleted_at IS NULL`で有効データを取得

#### インデックス
- 頻繁に検索されるカラムにインデックスを作成
- 外部キーには必ずインデックスを作成

#### タイムスタンプ
- `created_at`: 作成日時（自動設定）
- `modified_at`: 更新日時（自動更新）

---

### 3. 開発環境

#### データベース
- **DBMS**: Cloudflare D1 (SQLite互換)
- **文字コード**: UTF-8
- **タイムゾーン**: Asia/Tokyo (JST)

#### マイグレーション
```bash
# ローカル環境
npx wrangler d1 migrations apply webapp-production --local

# 本番環境
npx wrangler d1 migrations apply webapp-production --remote
```

#### データベース復旧
```bash
# ローカル環境
npx wrangler d1 execute webapp-production --local --file=database_schema_complete.sql

# 本番環境（注意: 既存データが削除されます）
npx wrangler d1 execute webapp-production --remote --file=database_schema_complete.sql
```

---

### 4. テストデータ

現在のテストデータを確認するには:

```bash
# イベント一覧
npx wrangler d1 execute webapp-production --local --command="SELECT id, name, event_url, event_start_date, event_end_date FROM events WHERE deleted_at IS NULL LIMIT 10"

# イベント詳細
npx wrangler d1 execute webapp-production --local --command="SELECT * FROM events WHERE id = 1"
```

---

## 📊 主要エンドポイント一覧

| メソッド | エンドポイント | 説明 | 認証 |
|---------|--------------|------|------|
| GET | `/api/events` | イベント一覧取得（フロントエンド用） | 不要 |
| GET | `/api/v1/events` | イベント一覧取得（管理画面用） | 必要 |
| GET | `/api/events/:id` | イベント詳細取得 | 不要 |
| POST | `/api/events` | イベント新規作成 | 必要 |
| PUT | `/api/events/:id` | イベント更新 | 必要 |
| DELETE | `/api/events/:id` | イベント削除（論理削除） | 必要 |
| POST | `/api/v1/events/:id/copy` | イベントコピー | 必要 |
| GET | `/api/events/:id/products` | イベントの商品一覧取得 | 不要 |
| GET | `/api/events/:id/options` | イベントのオプション一覧取得 | 不要 |
| GET | `/api/events/:id/available-dates` | 利用可能日取得 | 不要 |
| GET | `/api/events/:id/products-by-date` | 日付別商品一覧取得 | 不要 |
| GET | `/api/events/:id/children` | 子イベント一覧取得 | 不要 |
| GET | `/api/events/:id/group` | イベントグループ取得 | 不要 |
| GET | `/api/events/parents/list` | 親イベント一覧取得 | 必要 |
| POST | `/api/events/upload-image` | イベント画像アップロード | 必要 |

---

## 🗂️ 主要データモデル

### events テーブル（イベント）

**主要カラム**:
- `id`: イベントID（主キー）
- `name`: イベント名（必須）
- `contact`: 連絡先（必須）
- `event_url`: イベントURL（必須、一意）
- `event_start_date`: 開催開始日（必須）
- `event_end_date`: 開催終了日（必須）
- `registration_start_date`: 受付開始日（必須）
- `registration_end_date`: 受付終了日（必須）
- `enable_flg`: 有効フラグ（0:無効, 1:有効）
- `payment_flg`: 決済フラグ（0:無料, 1:有料）
- `deleted_at`: 削除日時（論理削除）

**外部キー**:
- `client_id` → `clients(id)`
- `organizer_id` → `organizers(id)`
- `vendor_id` → `vendors(id)`

---

## 🔐 セキュリティ要件

### 認証
- Cookie-based Session Authentication
- 管理APIは`routeAccessControl('admin')`で保護

### データ保護
- 個人情報は暗号化（検討中）
- クレジットカード情報は保存しない（決済代行サービス利用）

### SQLインジェクション対策
- すべてのクエリでプリペアドステートメントを使用
- バインドパラメータの使用を徹底

---

## 📈 パフォーマンス要件

- **イベント一覧取得**: 500ms以内
- **イベント詳細取得**: 200ms以内
- **イベント作成**: 1秒以内
- **イベント更新**: 1秒以内

**最大同時実行**:
- 最大同時アクセス数: 100ユーザー
- 最大同時書き込み: 10トランザクション

---

## 💾 バックアップ・リカバリ

### バックアップ
- **頻度**: 1日1回（深夜）
- **保存期間**: 30日間
- **保存場所**: Cloudflare R2バケット

### リカバリ
- **RPO（目標復旧時点）**: 24時間以内
- **RTO（目標復旧時間）**: 4時間以内

---

## 📞 お問い合わせ

ご不明な点がございましたら、開発チームまでお気軽にお問い合わせください。

---

## 📝 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|---------|
| 1.0 | 2026-01-28 | 初版作成 |
