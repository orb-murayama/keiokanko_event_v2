# 管理画面API仕様書（HTML5版）

## 📋 概要

このドキュメントは、イベント予約管理システムの**管理画面（HTML5版）**で使用する全APIエンドポイントの仕様書です。

## 📁 ファイル一覧

### 1. OpenAPI仕様書
**ファイル**: `openapi_admin.yaml` (110KB)

- **形式**: OpenAPI 3.0.3
- **用途**: Swagger UIやPostmanでAPIテストが可能
- **確認方法**: [Swagger Editor](https://editor.swagger.io/) にコピー&ペースト

### 2. Excel API仕様書
**ファイル**: `api_specification_admin.xlsx` (30KB)

- **形式**: Microsoft Excel (.xlsx)
- **シート構成**:
  - **目次**: 全カテゴリとAPI数の一覧
  - **API一覧**: 全102個のAPIエンドポイント一覧
  - **画面別API使用状況**: 各画面で使用しているAPI
  - **カテゴリ別シート**: 各カテゴリの詳細仕様（12シート）

### 3. データベース定義書
**ファイル**: `database_definition.xlsx` (48KB)

- **形式**: Microsoft Excel (.xlsx)
- **内容**: 24テーブルの完全定義
- **関連**: 各テーブルに関連POST APIを明記

## 🎯 API統計

| 項目 | 数量 |
|------|------|
| **総APIエンドポイント数** | 102個 |
| **GETメソッド** | 53個 (+1) |
| **POSTメソッド** | 29個 |
| **PUTメソッド** | 9個 |
| **DELETEメソッド** | 12個 (-1) |
| **カテゴリ数** | 12カテゴリ |

**変更履歴**:
- イベント管理からフォーム項目API 2個を削除（GET/POST `/api/events/{id}/form-fields`）
- 商品管理にフォーム項目API 2個を追加（GET/POST `/api/products/{id}/form-fields`）

## 📂 APIカテゴリ別一覧

### 1. 画像管理 (6個)
- POST `/api/events/upload-image` - イベント画像アップロード
- POST `/api/options/upload-image` - オプション画像アップロード
- POST `/api/products/upload-image` - 商品画像アップロード
- GET `/api/events/images/{fileName}` - イベント画像取得
- GET `/api/options/images/{fileName}` - オプション画像取得
- GET `/api/products/images/{fileName}` - 商品画像取得

**仕様**:
- **対応形式**: JPEG, JPG, PNG, GIF, WebP
- **最大サイズ**: 5MB
- **保存先**: Cloudflare R2
- **リクエスト**: multipart/form-data
- **レスポンス**: `{"success": true, "image_url": "/api/.../images/xxx.jpg", "file_name": "xxx.jpg"}`

### 2. マスタデータ (2個)
- GET `/api/prefs` - 都道府県一覧取得
- GET `/api/branches` - 支店一覧取得

### 3. 主催者管理 (5個)
- GET `/api/organizers` - 主催者一覧取得
- GET `/api/organizers/{id}` - 主催者詳細取得
- POST `/api/organizers` - 主催者新規登録
- PUT `/api/organizers/{id}` - 主催者更新
- DELETE `/api/organizers/{id}` - 主催者削除

### 4. クライアント管理 (5個)
- GET `/api/clients` - クライアント一覧取得
- GET `/api/clients/{id}` - クライアント詳細取得
- POST `/api/clients` - クライアント新規登録
- PUT `/api/clients/{id}` - クライアント更新
- DELETE `/api/clients/{id}` - クライアント削除

### 5. 仕入先管理 (5個)
- GET `/api/vendors` - 仕入先一覧取得
- GET `/api/vendors/{id}` - 仕入先詳細取得
- POST `/api/vendors` - 仕入先新規登録
- PUT `/api/vendors/{id}` - 仕入先更新
- DELETE `/api/vendors/{id}` - 仕入先削除

### 6. アカウント管理 (5個)
- GET `/api/accounts` - アカウント一覧取得
- GET `/api/accounts/{id}` - アカウント詳細取得
- POST `/api/accounts` - アカウント新規登録
- PUT `/api/accounts/{id}` - アカウント更新
- DELETE `/api/accounts/{id}` - アカウント削除

### 7. 会員管理 (4個)
- GET `/api/members` - 会員一覧取得
- GET `/api/members/{id}` - 会員詳細取得
- POST `/api/members` - 会員新規登録
- PUT `/api/members/{id}` - 会員更新

### 8. イベント管理 (14個) ※フォーム項目管理を商品管理に移動
- GET `/api/events` - イベント一覧取得
- GET `/api/events/{id}` - イベント詳細取得
- POST `/api/events` - イベント新規登録
- PUT `/api/events/{id}` - イベント更新
- DELETE `/api/events/{id}` - イベント削除
- GET `/api/events/{id}/available-dates` - イベント販売可能日取得
- GET `/api/events/{id}/children` - イベント子要素取得
- GET `/api/events/{id}/group` - イベントグループ取得
- GET `/api/events/{id}/options` - イベントオプション一覧取得
- GET `/api/events/{id}/options-by-date` - 日付別イベントオプション取得
- GET `/api/events/{id}/products` - イベント商品一覧取得
- GET `/api/events/{id}/products-all` - イベント商品全取得
- GET `/api/events/{id}/products-by-date` - 日付別イベント商品取得
- GET `/api/events/parents/list` - 親イベント一覧取得

### 9. 商品管理 (17個) ※フォーム項目管理を追加
- GET `/api/products` - 商品一覧取得
- GET `/api/products/{id}` - 商品詳細取得
- POST `/api/products` - 商品新規登録
- PUT `/api/products/{id}` - 商品更新
- DELETE `/api/products/{id}` - 商品削除
- POST `/api/products/{id}/copy` - 商品複製
- GET `/api/products/{id}/form-fields` - 商品フォーム項目取得 ※新規追加
- POST `/api/products/{id}/form-fields` - 商品フォーム項目登録 ※新規追加
- GET `/api/products/{id}/prices` - 商品価格一覧取得
- POST `/api/products/{id}/prices` - 商品価格登録
- DELETE `/api/products/{productId}/prices/{priceId}` - 商品価格削除
- GET `/api/products/{id}/stocks` - 商品在庫一覧取得
- GET `/api/products/{id}/shared-stocks` - 商品共有在庫一覧取得
- POST `/api/products/{id}/shared-stocks` - 商品共有在庫登録
- POST `/api/products/{id}/shared-stocks/batch` - 商品共有在庫一括登録
- DELETE `/api/products/{id}/shared-stocks/{linkId}` - 商品共有在庫削除
- DELETE `/api/products/{productId}/shared-stocks/{id}` - 商品共有在庫削除（旧形式）

### 10. オプション管理 (14個)
- GET `/api/options` - オプション一覧取得
- GET `/api/options/{id}` - オプション詳細取得
- POST `/api/options` - オプション新規登録
- PUT `/api/options/{id}` - オプション更新
- DELETE `/api/options/{id}` - オプション削除
- POST `/api/options/{id}/copy` - オプション複製
- GET `/api/options/{id}/stocks` - オプション在庫一覧取得
- POST `/api/options/{id}/stocks` - オプション在庫登録
- PUT `/api/options/{id}/stocks/{stockId}` - オプション在庫更新
- DELETE `/api/options/{id}/stocks/{stockId}` - オプション在庫削除
- GET `/api/options/{id}/shared-stocks` - オプション共有在庫一覧取得
- POST `/api/options/{id}/shared-stocks` - オプション共有在庫登録
- POST `/api/options/{id}/shared-stocks/batch` - オプション共有在庫一括登録
- DELETE `/api/options/{optionId}/shared-stocks/{id}` - オプション共有在庫削除

### 11. 在庫管理 (4個)
- GET `/api/stocks` - 在庫一覧取得
- POST `/api/stocks` - 在庫新規登録
- PUT `/api/stocks/{id}` - 在庫更新
- DELETE `/api/stocks/{id}` - 在庫削除

### 12. 共有在庫プール管理 (8個)
- GET `/api/shared-stock-pools` - 共有在庫プール一覧取得
- GET `/api/shared-stock-pools/{id}` - 共有在庫プール詳細取得
- POST `/api/shared-stock-pools` - 共有在庫プール新規登録
- PUT `/api/shared-stock-pools/{id}` - 共有在庫プール更新
- DELETE `/api/shared-stock-pools/{id}` - 共有在庫プール削除
- POST `/api/shared-stock-pools/batch` - 共有在庫プール一括登録
- GET `/api/shared-stock-pools/by-name` - 共有在庫プール名検索
- GET `/api/shared-stock-pools/summary` - 共有在庫プールサマリ取得

### 13. 予約管理 (6個)
- GET `/api/bookings` - 予約一覧取得
- GET `/api/bookings/{id}` - 予約詳細取得
- POST `/api/bookings` - 予約新規登録
- PUT `/api/bookings/{id}` - 予約更新
- POST `/api/bookings/{id}/cancel` - 予約キャンセル
- GET `/api/bookings/export/csv` - 予約CSV出力

### 14. その他 (7個)
- GET `/api/option-categories` - オプションカテゴリ一覧取得
- POST `/api/auth/send-otp` - OTP送信
- POST `/api/auth/verify-otp` - OTP検証
- POST `/api/booking/register` - 予約ユーザー登録
- POST `/api/booking/login` - 予約ユーザーログイン
- GET `/api/mypage/bookings` - マイページ予約一覧取得
- GET `/api/reports/sales` - 売上レポート取得

## 🔐 認証

全APIエンドポイントは **Cookie認証（session）** を使用します。

## 📱 使用画面とAPI

| 画面名 | 使用API数 |
|--------|----------|
| 主催者一覧/編集 | 6個 |
| クライアント一覧/編集 | 6個 |
| 仕入先一覧/編集 | 6個 |
| アカウント一覧/編集 | 6個 |
| 会員一覧/編集 | 5個 |
| イベント一覧/編集 | 16個 (-2) ※フォーム項目管理を削除 |
| 商品一覧/編集 | 19個 (+2) ※フォーム項目管理を追加 |
| オプション一覧/編集 | 16個 |
| 在庫管理 | 4個 |
| 共有在庫プール管理 | 8個 |
| 予約一覧/詳細 | 9個 |

詳細は `api_specification_admin.xlsx` の「画面別API使用状況」シートを参照してください。

## 🔄 更新履歴

### v2.1.0 (2026-01-23)
- **入力フォーム項目設定の移動**: イベント管理から商品管理へ完全移動
  - ❌ 削除: `GET/POST /api/events/{id}/form-fields` (2個) - event_form_fields廃止
  - ✅ 追加: `GET/POST /api/products/{id}/form-fields` (2個) - product_form_fields新設
- **データベース変更**: 
  - ✅ `products`テーブルに`form_field_settings`カラム追加（TEXT型、JSON形式）
    - デフォルト値: `{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}`
    - 7つの入力項目設定: 氏名（漢字）、氏名（カナ）、氏名（ローマ字）、住所、電話番号、生年月日、年齢
  - ✅ `product_form_fields`テーブル追加（商品別カスタムフォーム項目・高度なフォーム設定用）
  - ✅ `booking_form_responses`に`product_id`カラム追加（予約時の商品別フォーム回答）
  - ❌ `event_form_fields`テーブル削除（廃止・マイグレーション済み）
  - ❌ `events`テーブルの`form_field_settings`カラム削除（データ保持するが使用しない）
- **UI/画面変更**:
  - ❌ イベント管理画面から「入力フォーム項目設定」セクション削除
  - ✅ 商品管理画面に「入力フォーム項目設定」セクション追加（販売期間・締切の後に配置）
  - ✅ 商品一覧に「フォーム設定」ボタン追加（在庫ボタンの後に配置）
  - ❌ イベント一覧から「フォーム設定」ボタン削除
- **API変更**:
  - ✅ `POST /api/products` - `form_field_settings`を保存
  - ✅ `PUT /api/products/{id}` - `form_field_settings`を更新
  - ✅ `POST /api/products/{id}/copy` - `form_field_settings`もコピー
  - ✅ `GET /api/products/{id}` - `form_field_settings`を返却
- **理由**: 
  - 予約フォームの項目設定を商品単位で管理する要件変更
  - 同一イベント内で商品ごとに異なるフォーム項目を設定可能に
  - 複数商品がある場合は合算して重複しないように項目を表示（今後実装予定）

### v2.0.0 (2026-01-21)
- 管理画面（HTML5版）で使用する102個のAPIエンドポイントを網羅
- 画像アップロード/取得API（6個）を追加
- マスタデータAPI（prefs, branches）を追加
- カテゴリ別にAPI分類（12カテゴリ）
- 画面別API使用状況を明記
- OpenAPI 3.0.3形式で仕様書を作成
- Excel形式で詳細仕様書を作成

## 📞 お問い合わせ

API仕様に関するご質問は開発チームまでお問い合わせください。

---

**作成日**: 2026-01-21  
**最終更新**: 2026-01-23  
**バージョン**: 2.1.0  
**対象**: 管理画面（HTML5版）
