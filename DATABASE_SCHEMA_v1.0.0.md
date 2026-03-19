# データベーススキーマ v1.0.0

## 概要
イベント管理システム v1.0.0 のデータベーススキーマドキュメント

- **データベース**: Cloudflare D1 (SQLite)
- **マイグレーション数**: 47ファイル
- **作成日**: 2025-12-24
- **バージョン**: 1.0.0

## マイグレーションファイル

全てのマイグレーションファイルは `migrations/` ディレクトリに保存されています：

```
migrations/
├── 0001_initial_schema.sql                 # 初期スキーマ（全テーブル定義）
├── 0002_add_time_slot_support.sql          # タイムスロット対応
├── 0003_add_price_bands.sql                # 価格帯追加
├── 0004_fix_price_bands_slots.sql          # 価格帯・スロット修正
├── 0005_restructure_price_bands.sql        # 価格帯再構築
├── 0006_add_stock_name_and_price_band.sql  # 在庫名・価格帯追加
├── 0007_add_event_form_fields.sql          # イベントフォームフィールド追加
├── 0008_add_booking_form_responses.sql     # 予約フォームレスポンス追加
├── 0009_add_price_unit_fields.sql          # 価格単位フィールド追加
├── 0010_add_field_tree_structure.sql       # フィールドツリー構造追加
├── 0011_add_otp_table.sql                  # OTPテーブル追加
├── 0012_add_product_prices_columns.sql     # 商品価格カラム追加
├── 0013_add_shared_stock_pools.sql         # 共有在庫プール追加
├── 0014_add_price_band_to_shared_stocks.sql # 共有在庫に価格帯追加
├── 0015_add_price_to_option_shared_stocks.sql # オプション共有在庫に価格追加
├── 0016_add_payment_methods_and_bank_info.sql # 支払方法・銀行情報追加
├── 0017_add_organizer_details_to_clients.sql  # クライアントに主催者詳細追加
├── 0018_add_position_to_clients.sql        # クライアントに役職追加
├── 0018_add_product_json_fields.sql        # 商品にJSONフィールド追加
├── 0019_add_customer_client_to_events.sql  # イベントに顧客クライアント追加
├── 0020_add_client_code_to_clients.sql     # クライアントにクライアントコード追加
├── 0021_create_accounts_table.sql          # アカウントテーブル作成
├── 0022_create_members_table.sql           # メンバーテーブル作成
├── 0023_migrate_bookings_to_members.sql    # 予約データをメンバーに移行
├── 0024_add_booking_number.sql             # 予約番号追加
├── 0025_add_booking_details.sql            # 予約詳細追加
├── 0026_add_form_field_settings.sql        # フォームフィールド設定追加
├── 0027_create_option_stocks.sql           # オプション在庫テーブル作成
├── 0028_add_price_to_option_stocks.sql     # オプション在庫に価格追加
├── 0029_remove_consume_quantity_from_option_shared_stocks.sql # オプション共有在庫から消費数削除
├── 0030_remove_consume_quantity_from_product_shared_stocks.sql # 商品共有在庫から消費数削除
├── 0031_add_files_to_bookings.sql          # 予約にファイル追加
├── 0032_create_booking_options.sql         # 予約オプションテーブル作成
├── 0033_add_event_fields.sql               # イベントフィールド追加（大規模）
├── 0034_add_remaining_event_fields.sql     # 残りのイベントフィールド追加
├── 0035_add_english_fields_to_events.sql   # イベントに英語フィールド追加
├── 0036_add_email_english_fields.sql       # メール英語フィールド追加
├── 0037_add_deleted_at_to_events.sql       # イベントに削除日時追加
├── 0038_add_deleted_at_to_products_and_options.sql # 商品・オプションに削除日時追加
├── 0039_drop_products_unique_index.sql     # 商品のユニークインデックス削除
├── 0040_add_unique_event_url.sql           # イベントURLにユニーク制約追加
├── 0041_create_vendors_table.sql           # 販売会社テーブル作成
├── 0042_extend_vendors_table.sql           # 販売会社テーブル拡張
├── 0043_add_vendor_id_to_events.sql        # イベントに販売会社ID追加
├── 0044_add_cancellation_terms_to_products.sql # 商品にキャンセル条件追加
├── 0045_add_date_selection_type_to_events.sql  # イベントに日付選択タイプ追加
├── 0046_add_location_to_events.sql         # イベントに開催場所追加
└── 0047_create_categories_table.sql        # カテゴリテーブル作成
```

## 主要テーブル一覧

### 1. イベント管理
- **events**: イベント基本情報（70+カラム）
  - 基本情報: name, detail, location, contact, remarks, thanks_msg
  - 多言語: name_en, detail_en, location_en, contact_en, remarks_en, thanks_msg_en
  - 紐付け: client_id, customer_client_id, organizer_id, vendor_id
  - URL設定: event_url（ユニーク制約）
  - カテゴリ: category（JSON配列）
  - 日付設定: event_start_date, event_end_date, registration_start_date, registration_end_date
  - 管理ログイン: admin_login_start_date, admin_login_end_date
  - メール設定: admin_email, admin_cc_email, sender_name, sender_email
  - メールシグニチャ: email_signature, email_signature_en
  - 支払設定: payment_flg, payment_methods（ビットフラグ: 1=クレジット, 2=銀行, 4=コンビニ）
  - 銀行情報: bank_name, bank_branch, bank_account_type, bank_account_number, bank_account_name
  - 店舗コード: store_code
  - 支払期限: bank_transfer_deadline, convenience_payment_deadline
  - **コンビニ設定**: available_convenience_stores（JSON配列）
  - 手数料設定（クレジットカード）: credit_fee_type, credit_fee_percentage, credit_fee_fixed
  - 手数料設定（銀行振込）: bank_fee_type, bank_fee_percentage, bank_fee_fixed
  - 手数料設定（コンビニ）: convenience_fee_type, convenience_fee_percentage, convenience_fee_fixed
  - フォーム設定: form_field_settings（JSON: name_kanji, name_kana, name_roma, address, tel, birth_date, age）
  - オートリプライ: auto_reply_enabled（フラグ）
  - オートリプライメッセージ（日本語）:
    - auto_reply_credit_payment（クレジット決済完了）
    - auto_reply_bank_payment（銀行振込案内）
    - auto_reply_convenience_payment（コンビニ決済案内）
    - auto_reply_credit_cancel（クレジット決済キャンセル）
    - auto_reply_bank_cancel（銀行振込キャンセル）
    - auto_reply_convenience_cancel（コンビニ決済キャンセル）
    - auto_reply_credit_refund（クレジット返金）
    - auto_reply_bank_deposit（銀行入金確認）
    - auto_reply_bank_refund（銀行返金）
    - auto_reply_convenience_deposit（コンビニ入金確認）
    - auto_reply_convenience_refund（コンビニ返金）
  - オートリプライメッセージ（英語）: 上記11項目の _en 版
  - フラグ: enable_flg, date_selection_type
  - タイムスタンプ: created_at, modified_at, deleted_at

### 2. クライアント・組織管理
- **clients**: クライアント（主催者）情報
  - 基本情報: name, contactable_person, branch_office, accounted_person
  - 住所: zip, pref_id, addr
  - 連絡先: tel, fax, email
  - その他: remarks, reg_flg, group_id, position, client_code
  - 主催者詳細: organizer_details（追加フィールド）

- **vendors**: 販売会社情報
  - 基本情報: name, code
  - 連絡先: contact_person, email, tel
  - 住所: zip, pref_id, addr
  - その他: remarks, enable_flg

### 3. 商品・オプション管理
- **products**: 商品情報
  - 基本情報: name, description, remarks
  - 期間: sales_start, sales_end, closing_trade
  - 価格: fee_include, fee_exclude
  - キャンセル: cancel_policy, cancellation_terms（JSON）
  - 紐付け: event_id, client_id, product_category_id
  - JSONフィールド: 追加データ保存用

- **product_prices**: 商品価格（カテゴリ別）
- **product_stocks**: 商品在庫（日付別）
- **product_shared_stocks**: 共有在庫プール

- **options**: オプション情報
  - 基本情報: name, description, remarks
  - カテゴリ: option_category_id
  - キャンセル: cancel_policy

- **option_prices**: オプション価格
- **option_stocks**: オプション在庫（日付別・価格付き）
- **option_shared_stocks**: オプション共有在庫
- **option_inherited_products**: オプション-商品紐付け

### 4. 予約管理
- **customers**: 顧客（申込者）情報
  - 個人情報: family_name, first_name, family_kana, first_kana
  - 属性: sex, birth, email, mobile, tel
  - 住所: zip, pref_id, city, addr, bldg
  - 法人: company_name, department_name
  - 支払: payment_select, payment_status
  - カスタムフィールド: free1～free6

- **members**: メンバー情報（customers移行後）
- **accounts**: アカウント情報

- **product_bookings**: 商品予約
- **option_bookings**: オプション予約
- **booking_options**: 予約オプション詳細（追加テーブル）

### 5. フォーム・設定管理
- **option_forms**: オプションフォーム設定
  - フォームタイプ: form_type（1:数量入力, 2:単一選択, 3:複数選択）

- **booking_form_responses**: 予約フォームレスポンス
- **field_tree_structure**: フィールドツリー構造

### 6. カテゴリ・マスタ
- **product_categories**: 商品カテゴリ
- **option_categories**: オプションカテゴリ
- **categories**: イベントカテゴリ（新規）
- **prefs**: 都道府県マスタ（47都道府県）

### 7. 認証・セキュリティ
- **otp**: ワンタイムパスワード

## インデックス

各テーブルには適切なインデックスが設定されています：
- 外部キー（`_id`カラム）
- 検索頻度の高いカラム（email, enable_flg等）
- ユニーク制約（events.event_url等）

## データ型

- **INTEGER**: ID、数値、フラグ
- **TEXT**: 文字列、日付（ISO 8601形式）
- **JSON文字列**: 
  - events.category（カテゴリID配列）
  - events.available_convenience_stores（コンビニ店舗配列）
  - events.form_field_settings（フォーム表示設定オブジェクト）
  - products.cancellation_terms（キャンセル条件）

## 制約

- **PRIMARY KEY**: 全テーブルに`id`カラム（AUTOINCREMENT）
- **FOREIGN KEY**: 外部キー制約（参照整合性）
- **UNIQUE**: ユニーク制約（events.event_url等）
- **DEFAULT**: デフォルト値（enable_flg=1, created_at=現在日時等）

## マイグレーション適用方法

### ローカル環境
```bash
npx wrangler d1 migrations apply webapp-production --local
```

### 本番環境
```bash
npx wrangler d1 migrations apply webapp-production
```

## バックアップと復元

### スキーマのみ復元
```bash
# 全マイグレーションを順次適用
npx wrangler d1 migrations apply webapp-production --local
```

### データ含む完全復元
プロジェクトバックアップ（tar.gz）を展開することで、`.wrangler/state/v3/d1/`配下のローカルD1データベースも復元されます。

## 注意事項

1. **ローカル開発**: `--local`フラグで`.wrangler/state/v3/d1/`のSQLiteを使用
2. **本番環境**: Cloudflare D1の分散データベースを使用
3. **JSON処理**: JavaScriptで`JSON.stringify()`/`JSON.parse()`を使用
4. **ビットフラグ**: `payment_methods`は複数支払方法をビット演算で管理
   - 1 (0001): クレジットカード
   - 2 (0010): 銀行振込
   - 4 (0100): コンビニ決済
   - 7 (0111): 全て有効

## 変更履歴

- **v1.0.0** (2025-12-24): 初回リリース版
  - 全47マイグレーション適用
  - イベント管理機能完全実装
  - 多言語対応
  - オートリプライ11項目対応
  - コンビニ複数選択対応
