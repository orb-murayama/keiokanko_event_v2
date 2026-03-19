# 予約管理システム - データベース設計書

## 概要
予約管理システムのデータベース設計書です。イベント予約、商品予約、オプション予約を管理します。

作成日: 2026-02-06  
バージョン: 1.0

---

## テーブル一覧

| No | テーブル名 | 説明 | 主キー |
|----|-----------|------|--------|
| 1 | customers | 顧客情報 | id |
| 2 | product_bookings | 商品予約 | id |
| 3 | option_bookings | オプション予約 | id |
| 4 | bookings | 統合予約 | id |
| 5 | booking_items | 予約明細 | id |

---

## ER図

```
┌─────────────────┐
│   events        │
│─────────────────│
│ id (PK)         │
│ name            │
│ client_id       │
└─────────────────┘
         │
         │ 1:N
         ▼
┌─────────────────┐
│   products      │
│─────────────────│
│ id (PK)         │
│ event_id (FK)   │
│ name            │
└─────────────────┘
         │
         │ 1:N
         ▼
┌─────────────────────────┐        ┌─────────────────┐
│  product_bookings       │   N:1  │   customers     │
│─────────────────────────│◄───────│─────────────────│
│ id (PK)                 │        │ id (PK)         │
│ booking_number          │        │ family_name     │
│ customer_id (FK)        │        │ first_name      │
│ product_id (FK)         │        │ email           │
│ product_stock_id (FK)   │        │ mobile          │
│ price                   │        │ branch_code     │
│ quantity                │        │ ...             │
│ booking_status          │        └─────────────────┘
│ payment_status          │               │
│ participants (JSON)     │               │ 1:N
│ price_items (JSON)      │               ▼
│ participation_date      │        ┌─────────────────┐
│ payment_method          │        │ option_bookings │
│ branch_code             │        │─────────────────│
│ ...                     │        │ id (PK)         │
└─────────────────────────┘        │ customer_id(FK) │
                                   │ option_id (FK)  │
┌─────────────────┐                │ price           │
│   bookings      │                │ quantity        │
│─────────────────│                └─────────────────┘
│ id (PK)         │
│ booking_number  │◄───┐
│ member_id (FK)  │    │
│ event_id (FK)   │    │ 1:N
│ total_amount    │    │
│ status          │    │
│ payment_status  │    │
└─────────────────┘    │
                       │
                ┌──────┴──────────┐
                │  booking_items  │
                │─────────────────│
                │ id (PK)         │
                │ booking_id (FK) │
                │ item_type       │
                │ item_id         │
                │ item_name       │
                │ quantity        │
                │ unit_price      │
                │ subtotal        │
                └─────────────────┘
```

---

## 1. customers（顧客）

### 説明
予約を行う顧客の基本情報を管理するテーブル。

### テーブル定義

| カラム名 | データ型 | NULL | デフォルト | 説明 |
|---------|---------|------|-----------|------|
| id | INTEGER | NO | AUTO | 顧客ID（主キー） |
| family_name | TEXT | YES | - | 姓 |
| first_name | TEXT | YES | - | 名 |
| family_kana | TEXT | YES | - | 姓（かな） |
| first_kana | TEXT | YES | - | 名（かな） |
| sex | INTEGER | YES | - | 性別（1:男性, 2:女性） |
| birth | TEXT | YES | - | 生年月日（YYYY-MM-DD） |
| mobile | TEXT | YES | - | 携帯電話番号 |
| tel | TEXT | YES | - | 固定電話番号 |
| fax | TEXT | YES | - | FAX番号 |
| email | TEXT | YES | - | メールアドレス |
| zip | TEXT | YES | - | 郵便番号 |
| pref_id | INTEGER | YES | - | 都道府県ID |
| city | TEXT | YES | - | 市区町村 |
| addr | TEXT | YES | - | 番地 |
| bldg | TEXT | YES | - | 建物名・部屋番号 |
| password | TEXT | YES | - | パスワード（ハッシュ化） |
| company_name | TEXT | YES | - | 会社名 |
| department_name | TEXT | YES | - | 部署名 |
| branch_code | TEXT | YES | - | 担当支店コード |
| enable_flg | INTEGER | YES | 1 | 有効フラグ（1:有効, 0:無効） |
| created_at | TEXT | YES | NOW | 作成日時 |
| modified_at | TEXT | YES | NOW | 更新日時 |
| canceled_at | TEXT | YES | - | キャンセル日時 |

### インデックス
- `idx_customers_email` ON (email)
- `idx_customers_branch_code` ON (branch_code)

---

## 2. product_bookings（商品予約）

### 説明
商品（イベント参加券など）の予約情報を管理するテーブル。参加者情報、料金明細、支払い情報などを含む。

### テーブル定義

| カラム名 | データ型 | NULL | デフォルト | 説明 |
|---------|---------|------|-----------|------|
| id | INTEGER | NO | AUTO | 予約ID（主キー） |
| booking_number | TEXT | YES | - | 予約番号（例: BK20240201-001） |
| customer_id | INTEGER | NO | - | 顧客ID（外部キー → customers.id） |
| product_id | INTEGER | NO | - | 商品ID（外部キー → products.id） |
| product_stock_id | INTEGER | YES | - | 商品在庫ID（外部キー → product_stocks.id） |
| price | INTEGER | NO | - | 合計金額 |
| quantity | INTEGER | NO | 1 | 数量 |
| booking_status | TEXT | YES | 'reserved' | 予約ステータス（reserved/confirmed/canceled） |
| payment_status | TEXT | YES | 'pending' | 支払いステータス（pending/completed/failed） |
| participation_date | TEXT | YES | - | 参加日（YYYY-MM-DD） |
| payment_method | TEXT | YES | - | 支払い方法（credit_card/bank_transfer/convenience_store） |
| payment_date | TEXT | YES | - | 支払い日時 |
| payment_transaction_id | TEXT | YES | - | 決済トランザクションID |
| participants | TEXT | YES | - | 参加者情報（JSON配列） |
| price_items | TEXT | YES | - | 料金明細（JSON配列） |
| remarks | TEXT | YES | - | 備考 |
| branch_code | TEXT | YES | - | 担当支店コード |
| qr_code_url | TEXT | YES | - | QRコードURL |
| pdf_file_url | TEXT | YES | - | PDF証明書URL |
| enable_flg | INTEGER | YES | 1 | 有効フラグ |
| created_at | TEXT | YES | NOW | 作成日時 |
| modified_at | TEXT | YES | NOW | 更新日時 |
| canceled_at | TEXT | YES | - | キャンセル日時 |

### JSON形式フィールド

**participants（参加者情報）:**
```json
[
  {
    "name": "山田太郎",
    "age": 39,
    "gender": "男性"
  },
  {
    "name": "山田花子",
    "age": 37,
    "gender": "女性"
  }
]
```

**price_items（料金明細）:**
```json
[
  {
    "name": "一般入場券",
    "price": 2500,
    "quantity": 2,
    "subtotal": 5000
  }
]
```

### インデックス
- `idx_product_bookings_customer_id` ON (customer_id)
- `idx_product_bookings_product_id` ON (product_id)
- `idx_product_bookings_booking_number` ON (booking_number)
- `idx_product_bookings_booking_status` ON (booking_status)
- `idx_product_bookings_payment_status` ON (payment_status)
- `idx_product_bookings_created_at` ON (created_at)
- `idx_product_bookings_participation_date` ON (participation_date)
- `idx_product_bookings_branch_code` ON (branch_code)

---

## 3. option_bookings（オプション予約）

### 説明
追加オプション（食事、記念品など）の予約情報を管理するテーブル。

### テーブル定義

| カラム名 | データ型 | NULL | デフォルト | 説明 |
|---------|---------|------|-----------|------|
| id | INTEGER | NO | AUTO | オプション予約ID（主キー） |
| customer_id | INTEGER | NO | - | 顧客ID（外部キー → customers.id） |
| option_id | INTEGER | NO | - | オプションID（外部キー → options.id） |
| option_stock_id | INTEGER | YES | - | オプション在庫ID（外部キー → option_stocks.id） |
| price | INTEGER | NO | - | 料金 |
| quantity | INTEGER | NO | 1 | 数量 |
| enable_flg | INTEGER | YES | 1 | 有効フラグ |
| created_at | TEXT | YES | NOW | 作成日時 |
| modified_at | TEXT | YES | NOW | 更新日時 |
| canceled_at | TEXT | YES | - | キャンセル日時 |

### インデックス
- `idx_option_bookings_customer_id` ON (customer_id)
- `idx_option_bookings_option_id` ON (option_id)

---

## 4. bookings（統合予約）

### 説明
会員による統合予約を管理するテーブル。複数の商品・オプションをまとめた予約に使用。

### テーブル定義

| カラム名 | データ型 | NULL | デフォルト | 説明 |
|---------|---------|------|-----------|------|
| id | INTEGER | NO | AUTO | 予約ID（主キー） |
| booking_number | TEXT | NO | - | 予約番号（UNIQUE） |
| member_id | INTEGER | NO | - | 会員ID（外部キー → members.id） |
| event_id | INTEGER | NO | - | イベントID（外部キー → events.id） |
| booking_date | DATE | NO | - | 予約日 |
| total_amount | INTEGER | NO | - | 合計金額 |
| status | TEXT | NO | 'pending' | 予約ステータス（pending/confirmed/canceled） |
| payment_status | TEXT | YES | 'unpaid' | 支払いステータス（unpaid/paid/refunded） |
| payment_method | TEXT | YES | - | 支払い方法 |
| is_proxy | BOOLEAN | YES | 0 | 代理予約フラグ（0:本人, 1:代理） |
| booker_family_name | TEXT | NO | - | 予約者姓 |
| booker_first_name | TEXT | NO | - | 予約者名 |
| booker_tel | TEXT | NO | - | 予約者電話番号 |
| booker_email | TEXT | NO | - | 予約者メールアドレス |
| booker_addr | TEXT | NO | - | 予約者住所 |
| created_at | TEXT | YES | NOW | 作成日時 |
| modified_at | TEXT | YES | NOW | 更新日時 |

### インデックス
- `idx_bookings_member_id` ON (member_id)
- `idx_bookings_event_id` ON (event_id)
- `idx_bookings_booking_number` ON (booking_number)

---

## 5. booking_items（予約明細）

### 説明
統合予約の明細を管理するテーブル。1つの予約に含まれる複数の商品・オプションを明細として保存。

### テーブル定義

| カラム名 | データ型 | NULL | デフォルト | 説明 |
|---------|---------|------|-----------|------|
| id | INTEGER | NO | AUTO | 明細ID（主キー） |
| booking_id | INTEGER | NO | - | 予約ID（外部キー → bookings.id） |
| item_type | TEXT | NO | - | 明細タイプ（product/option） |
| item_id | INTEGER | NO | - | 商品ID or オプションID |
| item_name | TEXT | NO | - | 商品名 or オプション名 |
| stock_id | INTEGER | YES | - | 在庫ID |
| price_category | TEXT | YES | - | 料金カテゴリ |
| quantity | INTEGER | NO | - | 数量 |
| unit_price | INTEGER | NO | - | 単価 |
| subtotal | INTEGER | NO | - | 小計 |
| created_at | TEXT | YES | NOW | 作成日時 |

### インデックス
- `idx_booking_items_booking_id` ON (booking_id)
- `idx_booking_items_item` ON (item_type, item_id)

---

## ビュー定義

### v_product_bookings_list

**説明:** 商品予約一覧を表示するための読み取り専用ビュー。関連テーブルを結合して表示に必要な情報をまとめる。

**定義:**
```sql
CREATE VIEW v_product_bookings_list AS
SELECT 
  pb.id,
  pb.booking_number,
  pb.booking_status,
  pb.payment_status,
  pb.price,
  pb.quantity,
  pb.participation_date,
  pb.branch_code,
  pb.created_at,
  pb.modified_at,
  pb.canceled_at,
  (c.family_name || ' ' || c.first_name) as customer_name,
  c.email as customer_email,
  c.mobile as customer_phone,
  p.name as product_name,
  p.id as product_id,
  e.name as event_name,
  e.id as event_id,
  e.client_id
FROM product_bookings pb
LEFT JOIN customers c ON pb.customer_id = c.id
LEFT JOIN products p ON pb.product_id = p.id
LEFT JOIN events e ON p.event_id = e.id
WHERE pb.enable_flg = 1;
```

---

## ステータス定義

### booking_status（予約ステータス）
- `reserved`: 予約済み（確定前）
- `confirmed`: 確定済み
- `canceled`: キャンセル

### payment_status（支払いステータス）
- `pending`: 未払い
- `completed`: 支払い完了
- `failed`: 支払い失敗

### payment_method（支払い方法）
- `credit_card`: クレジットカード
- `bank_transfer`: 銀行振込
- `convenience_store`: コンビニ決済

---

## データ制約

### 外部キー制約
- product_bookings.customer_id → customers.id
- product_bookings.product_id → products.id
- product_bookings.product_stock_id → product_stocks.id
- option_bookings.customer_id → customers.id
- option_bookings.option_id → options.id
- option_bookings.option_stock_id → option_stocks.id
- bookings.member_id → members.id
- bookings.event_id → events.id
- booking_items.booking_id → bookings.id

### UNIQUE制約
- bookings.booking_number（予約番号の一意性）

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|---------|
| 1.0 | 2026-02-06 | 初版作成 |
