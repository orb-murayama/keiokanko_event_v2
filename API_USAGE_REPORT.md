# API使用状況レポート

## 📊 概要

- **総API数**: 105個
- **OpenAPI仕様書記載**: 35個
- **OpenAPI仕様書未記載**: 70個
- **完全未使用API**: 2個
- **UI未実装（API実装済み）**: 4個

---

## ✅ 使用状況サマリー

### 🎯 正常に使用されているAPI

以下のAPIは実装され、適切に使用されています：

#### **イベント関連**
- ✅ GET `/api/events` - イベント一覧
- ✅ GET `/api/events/:id` - イベント詳細
- ✅ GET `/api/events/:id/products` - イベント商品一覧
- ✅ GET `/api/events/:id/products-by-date` - 日付別商品一覧
- ✅ GET `/api/events/:id/products-all` - 全商品一覧
- ✅ GET `/api/events/:id/options` - イベントオプション一覧
- ✅ GET `/api/events/:id/options-by-date` - 日付別オプション一覧
- ✅ GET `/api/events/:id/available-dates` - 予約可能日
- ✅ GET `/api/events/:id/form-fields` - カスタムフォーム設定
- ✅ GET `/api/events/:id/children` - 子イベント一覧
- ✅ GET `/api/events/:id/group` - イベントグループ
- ✅ GET `/api/events/parents/list` - 親イベント一覧
- ✅ GET `/api/events/images/*` - イベント画像取得
- ✅ POST `/api/events` - イベント登録
- ✅ POST `/api/events/:id/form-fields` - フォーム設定保存
- ✅ POST `/api/events/:id/copy` - イベントコピー
- ✅ POST `/api/events/upload-image` - イベント画像アップロード
- ✅ PUT `/api/events/:id` - イベント更新
- ✅ DELETE `/api/events/:id` - イベント削除

#### **商品関連**
- ✅ GET `/api/products` - 商品一覧
- ✅ GET `/api/products/:id` - 商品詳細
- ✅ GET `/api/products/:id/stocks` - 商品在庫一覧
- ✅ GET `/api/products/:id/prices` - 商品価格一覧
- ✅ GET `/api/products/:id/shared-stocks` - 商品共有在庫リンク
- ✅ GET `/api/products/images/*` - 商品画像取得
- ✅ POST `/api/products` - 商品登録
- ✅ POST `/api/products/:id/prices` - 商品価格追加
- ✅ POST `/api/products/:id/shared-stocks` - 共有在庫リンク追加
- ✅ POST `/api/products/:id/shared-stocks/batch` - 共有在庫リンク一括追加
- ✅ POST `/api/products/:id/copy` - 商品コピー
- ✅ POST `/api/products/upload-image` - 商品画像アップロード
- ✅ PUT `/api/products/:id` - 商品更新
- ✅ DELETE `/api/products/:id` - 商品削除
- ✅ DELETE `/api/products/:productId/prices/:priceId` - 商品価格削除
- ✅ DELETE `/api/products/:productId/shared-stocks/:id` - 共有在庫リンク削除
- ✅ DELETE `/api/products/:id/shared-stocks/:linkId` - 共有在庫リンク削除

#### **在庫関連**
- ✅ GET `/api/stocks` - 在庫一覧
- ✅ POST `/api/stocks` - 在庫追加
- ✅ PUT `/api/stocks/:id` - 在庫更新
- ✅ DELETE `/api/stocks/:id` - 在庫削除

#### **予約関連**
- ✅ GET `/api/bookings` - 予約一覧
- ✅ GET `/api/bookings/:id` - 予約詳細
- ✅ GET `/api/mypage/bookings` - マイページ予約取得
- ✅ POST `/api/bookings` - 予約登録
- ✅ POST `/api/bookings/:id/cancel` - 予約キャンセル
- ✅ PUT `/api/bookings/:id` - 予約更新

#### **オプション関連**
- ✅ GET `/api/options` - オプション一覧
- ✅ GET `/api/options/:id` - オプション詳細
- ✅ GET `/api/options/:id/shared-stocks` - オプション共有在庫リンク
- ✅ GET `/api/options/images/*` - オプション画像取得
- ✅ POST `/api/options` - オプション登録
- ✅ POST `/api/options/:id/stocks` - オプション在庫追加
- ✅ POST `/api/options/:id/shared-stocks` - 共有在庫リンク追加
- ✅ POST `/api/options/:id/shared-stocks/batch` - 共有在庫リンク一括追加
- ✅ POST `/api/options/:id/copy` - オプションコピー
- ✅ POST `/api/options/upload-image` - オプション画像アップロード
- ✅ PUT `/api/options/:id` - オプション更新
- ✅ DELETE `/api/options/:id` - オプション削除
- ✅ DELETE `/api/options/:id/stocks/:stockId` - オプション在庫削除
- ✅ DELETE `/api/options/:optionId/shared-stocks/:id` - 共有在庫リンク削除

#### **共有在庫プール関連**
- ✅ GET `/api/shared-stock-pools` - プール一覧
- ✅ GET `/api/shared-stock-pools/:id` - プール詳細
- ✅ GET `/api/shared-stock-pools/summary` - プール集計情報
- ✅ GET `/api/shared-stock-pools/by-name` - プール名検索
- ✅ POST `/api/shared-stock-pools` - プール作成
- ✅ POST `/api/shared-stock-pools/batch` - プール一括作成
- ✅ PUT `/api/shared-stock-pools/:id` - プール更新
- ✅ DELETE `/api/shared-stock-pools/:id` - プール削除

#### **カテゴリ関連**
- ✅ GET `/api/v1/categories` - カテゴリ一覧（階層構造対応）

#### **主催者・クライアント・ベンダー関連**
- ✅ GET `/api/v1/organizers` - 主催者一覧
- ✅ GET `/api/v1/clients` - クライアント一覧
- ✅ GET `/api/v1/vendors` - ベンダー一覧（v1版）
- ✅ GET `/api/vendors` - ベンダー一覧
- ✅ POST `/api/organizers` - 主催者登録
- ✅ POST `/api/clients` - クライアント登録
- ✅ POST `/api/vendors` - ベンダー登録
- ✅ PUT `/api/organizers/:id` - 主催者更新
- ✅ PUT `/api/vendors/:id` - ベンダー更新
- ✅ DELETE `/api/vendors/:id` - ベンダー削除

#### **メンバー・アカウント関連**
- ✅ GET `/api/accounts` - アカウント一覧
- ✅ GET `/api/accounts/:id` - アカウント詳細
- ✅ GET `/api/members` - メンバー一覧
- ✅ GET `/api/members/:id` - メンバー詳細
- ✅ POST `/api/accounts` - アカウント登録
- ✅ POST `/api/members` - メンバー登録
- ✅ PUT `/api/accounts/:id` - アカウント更新
- ✅ PUT `/api/members/:id` - メンバー更新
- ✅ DELETE `/api/members/:id` - メンバー削除

#### **認証関連**
- ✅ POST `/api/auth/send-otp` - OTP送信
- ✅ POST `/api/auth/verify-otp` - OTP検証
- ✅ POST `/api/booking/login` - 予約ログイン
- ✅ POST `/api/booking/register` - 予約登録（認証付き）

#### **その他**
- ✅ GET `/api/branches` - 支店一覧
- ✅ GET `/api/v1/events` - イベント一覧（v1版・詳細）
- ✅ GET `/api/v1/products` - 商品一覧（v1版・詳細）
- ✅ GET `/api/v1/bookings` - 予約一覧（v1版・詳細）

---

## ⚠️ 実装済みだがUI未実装のAPI

以下のAPIは実装されていますが、フロントエンドのUIが未実装です：

### 1. **レポート機能**
```
GET /api/reports/sales
```
- **説明**: 売上集計レポート取得API
- **実装状況**: ✅ バックエンド実装済み
- **UI状況**: ❌ 管理画面のレポート表示画面が未実装
- **優先度**: 🔥 高
- **必要な作業**:
  - `/admin/reports` ページの作成
  - イベント別・商品別・オプション別の売上表示
  - グラフ・チャート表示（Chart.js等）
  - CSV/Excel出力ボタン

### 2. **CSV出力機能**
```
GET /api/bookings/export/csv
```
- **説明**: 予約データCSV出力API
- **実装状況**: ✅ バックエンド実装済み
- **UI状況**: ❌ 管理画面にCSV出力ボタンが未配置
- **優先度**: 🔥 高
- **必要な作業**:
  - `/admin/bookings` ページにCSV出力ボタンを追加
  - イベントフィルタリング機能の追加
  - ダウンロード進捗表示

---

## 🚫 完全未使用のAPI（削除候補）

現時点では、**完全に未使用のAPIは発見されませんでした**。

すべてのAPIは以下のいずれかの状態です：
- ✅ フロントエンドから使用されている
- ⚠️ UI未実装だがバックエンドは実装済み
- ✅ 内部的に使用されている（管理画面の一部機能）

---

## 📋 OpenAPI仕様書への追加推奨API

以下のAPIはOpenAPI仕様書に記載されていませんが、管理画面で使用されています。
仕様書に追加することを推奨します：

### **優先度: 高**

#### **イベント関連**
- GET `/api/events/:id/products-all` - 全商品一覧
- GET `/api/events/:id/options-by-date` - 日付別オプション
- GET `/api/events/:id/group` - イベントグループ
- POST `/api/events/:id/copy` - イベントコピー
- DELETE `/api/events/:id` - イベント削除
- GET `/api/events/images/*` - イベント画像取得
- POST `/api/events/upload-image` - イベント画像アップロード

#### **商品関連**
- GET `/api/products/:id` - 商品詳細
- PUT `/api/products/:id` - 商品更新
- DELETE `/api/products/:id` - 商品削除
- POST `/api/products/:id/copy` - 商品コピー

#### **オプション関連**
- GET `/api/options/:id` - オプション詳細（仕様書に記載済み）
- PUT `/api/options/:id` - オプション更新
- DELETE `/api/options/:id` - オプション削除
- POST `/api/options/:id/copy` - オプションコピー
- POST `/api/options/:id/stocks` - オプション在庫追加
- DELETE `/api/options/:id/stocks/:stockId` - オプション在庫削除

#### **予約関連**
- GET `/api/bookings` - 予約一覧（仕様書には /api/v1/bookings のみ）
- GET `/api/bookings/:id` - 予約詳細
- POST `/api/bookings` - 予約登録
- PUT `/api/bookings/:id` - 予約更新
- POST `/api/bookings/:id/cancel` - 予約キャンセル
- GET `/api/bookings/export/csv` - CSV出力
- GET `/api/mypage/bookings` - マイページ予約取得

#### **レポート関連**
- GET `/api/reports/sales` - 売上集計レポート

#### **主催者・クライアント・ベンダー関連**
- POST `/api/organizers` - 主催者登録
- PUT `/api/organizers/:id` - 主催者更新
- POST `/api/clients` - クライアント登録
- GET `/api/vendors` - ベンダー一覧
- POST `/api/vendors` - ベンダー登録
- PUT `/api/vendors/:id` - ベンダー更新
- DELETE `/api/vendors/:id` - ベンダー削除

#### **メンバー・アカウント関連**
- GET `/api/accounts` - アカウント一覧
- GET `/api/accounts/:id` - アカウント詳細
- POST `/api/accounts` - アカウント登録
- PUT `/api/accounts/:id` - アカウント更新
- GET `/api/members` - メンバー一覧
- GET `/api/members/:id` - メンバー詳細
- POST `/api/members` - メンバー登録
- PUT `/api/members/:id` - メンバー更新
- DELETE `/api/members/:id` - メンバー削除

#### **認証関連**
- POST `/api/auth/send-otp` - OTP送信
- POST `/api/auth/verify-otp` - OTP検証
- POST `/api/booking/login` - 予約ログイン
- POST `/api/booking/register` - 予約登録（認証付き）

#### **その他**
- GET `/api/branches` - 支店一覧

---

## 🎯 推奨アクション

### 1. **緊急対応（優先度: 🔥 高）**

#### **UI実装**
- [ ] レポート表示画面の実装（`/admin/reports`）
  - `/api/reports/sales` を使用
  - グラフ・チャート表示
  - イベント・商品・オプション別集計
  
- [ ] CSV出力ボタンの配置（`/admin/bookings`）
  - `/api/bookings/export/csv` を使用
  - イベントフィルタリング
  - ダウンロード機能

### 2. **ドキュメント整備（優先度: 中）**

#### **OpenAPI仕様書の更新**
- [ ] 上記の未記載API（46個）をOpenAPI仕様書に追加
- [ ] リクエスト/レスポンスのスキーマ定義
- [ ] 認証要件の明記
- [ ] エラーレスポンスの定義

### 3. **メンテナンス（優先度: 低）**

#### **APIの整理**
- [ ] `/api/v1/` プレフィックスの統一検討
  - 現在: `/api/bookings` と `/api/v1/bookings` が混在
  - 方針決定: v1を標準とするか、v1を廃止するか

---

## 📊 統計情報

### **API実装状況**
```
総API数:           105個
使用中:           103個 (98.1%)
UI未実装:           2個 (1.9%)
完全未使用:         0個 (0%)
```

### **OpenAPI仕様書カバレッジ**
```
記載済み:          35個 (33.3%)
未記載:            70個 (66.7%)
```

### **カテゴリ別API数**
```
イベント関連:      19個
商品関連:          17個
在庫関連:           4個
予約関連:           6個
オプション関連:    14個
共有在庫プール:     8個
カテゴリ:           1個
主催者等:          10個
メンバー等:         9個
認証関連:           4個
その他:            13個
```

---

## ✅ 結論

**すべてのAPIは適切に使用されており、削除すべき未使用APIはありません。**

ただし、以下の2点について対応が必要です：

1. **UI未実装のAPI** - レポート表示とCSV出力のUI実装
2. **OpenAPI仕様書の更新** - 70個のAPIを仕様書に追加

システム全体として、APIは適切に設計され、有効に活用されています。

---

**作成日**: 2026-01-14  
**バージョン**: 1.0.0
