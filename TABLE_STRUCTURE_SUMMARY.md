# データベーステーブル構造一覧（サマリー）

## 概要

| テーブル名 | カラム数 | 主な用途 | image_url |
|-----------|---------|---------|-----------|
| **events** | 100 | イベント情報 | ✅ あり |
| **products** | 38 | 商品情報 | ✅ あり |
| **options** | 13 | オプション情報 | ✅ あり |
| **product_prices** | 10 | 商品価格 | ❌ なし |
| **product_stocks** | 13 | 商品在庫 | ❌ なし |
| **option_prices** | 6 | オプション価格 | ❌ なし |
| **option_stocks** | 13 | オプション在庫 | ❌ なし |

---

## 1. events テーブル (100カラム)

### 基本情報
- `id` - PRIMARY KEY
- `name` - イベント名 (TEXT, NOT NULL)
- `detail` - 詳細説明 (TEXT)
- `contact` - 連絡先 (TEXT, NOT NULL)
- `location` - 開催場所 (TEXT)
- `category` - カテゴリー (TEXT)
- **`image_url`** - イベント画像URL (TEXT) ✅

### 日付関連
- `event_start_date` - 開催開始日
- `event_end_date` - 開催終了日
- `registration_start_date` - 受付開始日
- `registration_end_date` - 受付終了日
- `date_selection_type` - 日付選択タイプ (デフォルト: 'single')

### 支払い関連
- `payment_flg` - 支払いフラグ
- `payment_methods` - 支払い方法
- `payment_credit_card` - クレジット対応
- `payment_bank_transfer` - 銀行振込対応
- `payment_convenience_store` - コンビニ対応
- `credit_fee_percentage` - クレジット手数料率
- `bank_fee_fixed` - 銀行手数料固定額
- `convenience_fee_fixed` - コンビニ手数料固定額

### キャンセルポリシー
- `cancel_policy` - キャンセルポリシー
- `cancellation_days_1~3` - キャンセル日数
- `cancellation_rate_1~3` - キャンセル率

### 多言語対応
- `name_en` - 英語名
- `detail_en` - 英語詳細
- `location_en` - 英語場所
- `contact_en` - 英語連絡先

### その他
- `organizer_id` - 主催者ID (FOREIGN KEY)
- `client_id` - クライアントID (FOREIGN KEY)
- `enable_flg` - 有効フラグ (デフォルト: 1)
- `created_at` / `modified_at` - タイムスタンプ

---

## 2. products テーブル (38カラム)

### 基本情報
- `id` - PRIMARY KEY
- `name` - 商品名 (TEXT, NOT NULL)
- `description` - 商品説明 (TEXT)
- `remarks` - 注意事項 (TEXT)
- `fee_include` - 料金に含まれるもの (TEXT)
- `fee_exclude` - 料金に含まれないもの (TEXT)
- **`image_url`** - 商品画像URL (TEXT) ✅

### 関連
- `event_id` - イベントID (FOREIGN KEY, NOT NULL)
- `client_id` - クライアントID (FOREIGN KEY, NOT NULL)
- `product_category_id` - 商品カテゴリーID

### 販売期間
- `sales_start` - 販売開始日 (TEXT, NOT NULL)
- `sales_end` - 販売終了日 (TEXT, NOT NULL)
- `closing_trade` - 締切時間 (INTEGER, デフォルト: 0)

### キャンセルポリシー
- `cancel_policy` - キャンセルポリシー
- `cancellation_days_1~5` - キャンセル日数 (最大5段階)
- `cancellation_rate_1~5` - キャンセル率 (最大5段階)
- `cancellation_policy_details` - 詳細

### 料金設定
- `price_unit` - 価格単位 (デフォルト: '人')
- `charge_type` - 料金タイプ (デフォルト: 'per_person')
- `charge_description` - 料金説明
- `common_names` - 共通名称

### その他
- `purchase_limit` - 購入制限
- `slot_type` - スロットタイプ
- `form_field_settings` - フォーム設定 (JSON)
- `enable_flg` - 有効フラグ (デフォルト: 1)

---

## 3. options テーブル (13カラム)

### 基本情報
- `id` - PRIMARY KEY
- `name` - オプション名 (TEXT, NOT NULL)
- `description` - 説明 (TEXT)
- `remarks` - 注意事項 (TEXT)
- **`image_url`** - オプション画像URL (TEXT) ✅

### 関連
- `event_id` - イベントID (FOREIGN KEY, NOT NULL)
- `option_category_id` - オプションカテゴリーID (FOREIGN KEY, NOT NULL)

### その他
- `cancel_policy` - キャンセルポリシー
- `note` - 備考
- `enable_flg` - 有効フラグ (デフォルト: 1)
- `created_at` / `modified_at` - タイムスタンプ
- `deleted_at` - 削除日時

---

## 4. product_prices テーブル (10カラム)

### 基本情報
- `id` - PRIMARY KEY
- `product_id` - 商品ID (FOREIGN KEY, NOT NULL)
- `price` - 価格 (INTEGER, NOT NULL)
- `category_name` - カテゴリー名 (例: '大人', '子供')
- `price_name` - 価格名称
- `price_band` - 価格帯 (例: 'スタンダード', 'プレミアム')

### その他
- `display_order` - 表示順序 (デフォルト: 0)
- `slot_number` - スロット番号 (デフォルト: 1)
- `created_at` / `modified_at` - タイムスタンプ

---

## 5. product_stocks テーブル (13カラム)

### 基本情報
- `id` - PRIMARY KEY
- `product_id` - 商品ID (FOREIGN KEY, NOT NULL)
- `date` - 日付 (TEXT, NOT NULL)
- `stock` - 在庫数 (INTEGER, NOT NULL, デフォルト: 0)
- `booked` - 予約済み数 (INTEGER, NOT NULL, デフォルト: 0)

### タイムスロット
- `time_slot_start` - 開始時刻
- `time_slot_end` - 終了時刻
- `time_slot_label` - ラベル

### その他
- `stock_name` - 在庫名
- `price_band` - 価格帯
- `shared_pool_id` - 共有プールID
- `created_at` / `modified_at` - タイムスタンプ

---

## 6. option_prices テーブル (6カラム)

### 基本情報
- `id` - PRIMARY KEY
- `option_id` - オプションID (FOREIGN KEY, NOT NULL)
- `price` - 価格 (INTEGER, NOT NULL)
- `category_name` - カテゴリー名 (例: '大人', '子供')
- `created_at` / `modified_at` - タイムスタンプ

---

## 7. option_stocks テーブル (13カラム)

### 基本情報
- `id` - PRIMARY KEY
- `option_id` - オプションID (FOREIGN KEY, NOT NULL)
- `date` - 日付 (TEXT)
- `stock` - 在庫数 (INTEGER, NOT NULL, デフォルト: 0)
- `booked` - 予約済み数 (INTEGER, NOT NULL, デフォルト: 0)

### 在庫管理
- `stock_name` - 在庫名
- `price` - 価格
- `total_stock` - 総在庫数 (デフォルト: 0)
- `available_stock` - 利用可能在庫数 (デフォルト: 0)
- `enable_flg` - 有効フラグ (デフォルト: 1)

### その他
- `shared_pool_id` - 共有プールID
- `created_at` / `modified_at` - タイムスタンプ

---

## image_url カラムの存在確認

| テーブル | image_url | 追加されたマイグレーション |
|---------|-----------|------------------------|
| events | ✅ あり | 0025_add_image_url_to_events.sql |
| products | ✅ あり | 0024_add_image_url_to_products.sql |
| options | ✅ あり | 0026_add_image_url_to_options.sql |
| product_prices | ❌ なし | - |
| product_stocks | ❌ なし | - |
| option_prices | ❌ なし | - |
| option_stocks | ❌ なし | - |

**結論**: イベント、商品、オプションの3つのメインテーブルには`image_url`カラムが存在します。価格テーブルと在庫テーブルには画像URLは不要です（親テーブルの画像を使用）。

---

## データベース整合性チェック結果

✅ **全テーブルが正常に作成されています**
✅ **バックアップデータは正常に復元されています**
✅ **image_urlカラムは必要なテーブルに存在します**
✅ **外部キー関係も正常に機能しています**

**最終更新**: 2026年2月18日
