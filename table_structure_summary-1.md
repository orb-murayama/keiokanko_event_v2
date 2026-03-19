# データベーステーブル構造一覧

## events テーブル (100 カラム)

| # | カラム名 | データ型 | NULL許可 | デフォルト値 |
|---|----------|----------|----------|--------------|
| 0 | id | INTEGER | YES | null |
| 1 | name | TEXT | NO | null |
| 2 | detail | TEXT | YES | null |
| 3 | contact | TEXT | NO | null |
| 4 | remarks | TEXT | YES | null |
| 5 | question | TEXT | YES | null |
| 6 | postage | INTEGER | YES | 0 |
| 7 | thanks_msg | TEXT | YES | null |
| 8 | note | TEXT | YES | null |
| 9 | client_id | INTEGER | NO | null |
| 10 | company_flg | INTEGER | YES | 0 |
| 11 | enable_flg | INTEGER | YES | 1 |
| 12 | payment_flg | INTEGER | YES | 0 |
| 13 | payment_cd | TEXT | YES | null |
| 14 | created_at | TEXT | YES | datetime('now', 'localtime') |
| 15 | modified_at | TEXT | YES | datetime('now', 'localtime') |
| 16 | customer_client_id | INTEGER | YES | null |
| 17 | vendor_id | INTEGER | YES | null |
| 18 | event_url | TEXT | YES | null |
| 19 | category | TEXT | YES | null |
| 20 | deleted_at | TEXT | YES | null |
| 21 | date_selection_type | TEXT | YES | 'single' |
| 22 | location | TEXT | YES | null |
| 23 | payment_methods | TEXT | YES | null |
| 24 | credit_fee_type | TEXT | YES | null |
| 25 | bank_fee_type | TEXT | YES | null |
| 26 | convenience_fee_type | TEXT | YES | null |
| 27 | registration_start_date | TEXT | YES | null |
| 28 | registration_end_date | TEXT | YES | null |
| 29 | event_start_date | TEXT | YES | null |
| 30 | event_end_date | TEXT | YES | null |
| 31 | admin_email | TEXT | YES | null |
| 32 | admin_name | TEXT | YES | null |
| 33 | name_en | TEXT | YES | null |
| 34 | detail_en | TEXT | YES | null |
| 35 | location_en | TEXT | YES | null |
| 36 | contact_en | TEXT | YES | null |
| 37 | remarks_en | TEXT | YES | null |
| 38 | thanks_msg_en | TEXT | YES | null |
| 39 | organizer_id | INTEGER | YES | null |
| 40 | admin_login_start_date | TEXT | YES | null |
| 41 | admin_login_end_date | TEXT | YES | null |
| 42 | admin_cc_email | TEXT | YES | null |
| 43 | sender_name | TEXT | YES | null |
| 44 | sender_email | TEXT | YES | null |
| 45 | email_signature | TEXT | YES | null |
| 46 | email_signature_en | TEXT | YES | null |
| 47 | bank_name | TEXT | YES | null |
| 48 | bank_branch | TEXT | YES | null |
| 49 | bank_account_type | TEXT | YES | null |
| 50 | bank_account_number | TEXT | YES | null |
| 51 | bank_account_name | TEXT | YES | null |
| 52 | bank_transfer_deadline | INTEGER | YES | null |
| 53 | store_code | TEXT | YES | null |
| 54 | convenience_payment_deadline | INTEGER | YES | null |
| 55 | available_convenience_stores | TEXT | YES | null |
| 56 | credit_fee_percentage | REAL | YES | null |
| 57 | credit_fee_fixed | INTEGER | YES | null |
| 58 | bank_fee_percentage | REAL | YES | null |
| 59 | bank_fee_fixed | INTEGER | YES | null |
| 60 | convenience_fee_percentage | REAL | YES | null |
| 61 | convenience_fee_fixed | INTEGER | YES | null |
| 62 | form_field_settings | TEXT | YES | null |
| 63 | auto_reply_enabled | INTEGER | YES | 0 |
| 64 | auto_reply_credit_payment | TEXT | YES | null |
| 65 | auto_reply_bank_payment | TEXT | YES | null |
| 66 | auto_reply_convenience_payment | TEXT | YES | null |
| 67 | auto_reply_credit_cancel | TEXT | YES | null |
| 68 | auto_reply_bank_cancel | TEXT | YES | null |
| 69 | auto_reply_convenience_cancel | TEXT | YES | null |
| 70 | auto_reply_credit_refund | TEXT | YES | null |
| 71 | auto_reply_bank_deposit | TEXT | YES | null |
| 72 | auto_reply_bank_refund | TEXT | YES | null |
| 73 | auto_reply_convenience_deposit | TEXT | YES | null |
| 74 | auto_reply_convenience_refund | TEXT | YES | null |
| 75 | auto_reply_credit_payment_en | TEXT | YES | null |
| 76 | auto_reply_bank_payment_en | TEXT | YES | null |
| 77 | auto_reply_convenience_payment_en | TEXT | YES | null |
| 78 | auto_reply_credit_cancel_en | TEXT | YES | null |
| 79 | auto_reply_bank_cancel_en | TEXT | YES | null |
| 80 | auto_reply_convenience_cancel_en | TEXT | YES | null |
| 81 | auto_reply_credit_refund_en | TEXT | YES | null |
| 82 | auto_reply_bank_deposit_en | TEXT | YES | null |
| 83 | auto_reply_bank_refund_en | TEXT | YES | null |
| 84 | auto_reply_convenience_deposit_en | TEXT | YES | null |
| 85 | auto_reply_convenience_refund_en | TEXT | YES | null |
| 86 | parent_event_id | INTEGER | YES | null |
| 87 | event_type | TEXT | YES | 'standalone' |
| 88 | payment_credit_card | INTEGER | YES | 0 |
| 89 | payment_bank_transfer | INTEGER | YES | 0 |
| 90 | payment_convenience_store | INTEGER | YES | 0 |
| 91 | cancel_policy | TEXT | YES | null |
| 92 | cancellation_policy_details | TEXT | YES | null |
| 93 | cancellation_days_1 | INTEGER | YES | null |
| 94 | cancellation_rate_1 | INTEGER | YES | null |
| 95 | cancellation_days_2 | INTEGER | YES | null |
| 96 | cancellation_rate_2 | INTEGER | YES | null |
| 97 | cancellation_days_3 | INTEGER | YES | null |
| 98 | cancellation_rate_3 | INTEGER | YES | null |
| 99 | image_url | TEXT | YES | null |

## products テーブル (38 カラム)

| # | カラム名 | データ型 | NULL許可 | デフォルト値 |
|---|----------|----------|----------|--------------|
| 0 | id | INTEGER | YES | null |
| 1 | client_id | INTEGER | NO | null |
| 2 | event_id | INTEGER | NO | null |
| 3 | name | TEXT | NO | null |
| 4 | sales_start | TEXT | NO | null |
| 5 | sales_end | TEXT | NO | null |
| 6 | closing_trade | INTEGER | NO | 0 |
| 7 | product_category_id | INTEGER | YES | null |
| 8 | description | TEXT | YES | null |
| 9 | remarks | TEXT | YES | null |
| 10 | fee_include | TEXT | YES | null |
| 11 | fee_exclude | TEXT | YES | null |
| 12 | cancel_policy | TEXT | YES | null |
| 13 | purchase_limit | INTEGER | YES | null |
| 14 | deposit_address | TEXT | YES | null |
| 15 | note | TEXT | YES | null |
| 16 | enable_flg | INTEGER | YES | 1 |
| 17 | created_at | TEXT | YES | datetime('now', 'localtime') |
| 18 | modified_at | TEXT | YES | datetime('now', 'localtime') |
| 19 | slot_type | INTEGER | YES | 0 |
| 20 | deleted_at | TEXT | YES | null |
| 21 | cancellation_days_1 | INTEGER | YES | null |
| 22 | cancellation_rate_1 | INTEGER | YES | null |
| 23 | cancellation_days_2 | INTEGER | YES | null |
| 24 | cancellation_rate_2 | INTEGER | YES | null |
| 25 | cancellation_days_3 | INTEGER | YES | null |
| 26 | cancellation_rate_3 | INTEGER | YES | null |
| 27 | cancellation_days_4 | INTEGER | YES | null |
| 28 | cancellation_rate_4 | INTEGER | YES | null |
| 29 | cancellation_days_5 | INTEGER | YES | null |
| 30 | cancellation_rate_5 | INTEGER | YES | null |
| 31 | common_names | TEXT | YES | null |
| 32 | cancellation_policy_details | TEXT | YES | null |
| 33 | price_unit | TEXT | YES | '人' |
| 34 | charge_type | TEXT | YES | 'per_person' |
| 35 | charge_description | TEXT | YES | null |
| 36 | form_field_settings | TEXT | YES | '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}' |
| 37 | image_url | TEXT | YES | null |

## options テーブル (13 カラム)

| # | カラム名 | データ型 | NULL許可 | デフォルト値 |
|---|----------|----------|----------|--------------|
| 0 | id | INTEGER | YES | null |
| 1 | event_id | INTEGER | NO | null |
| 2 | name | TEXT | NO | null |
| 3 | description | TEXT | YES | null |
| 4 | remarks | TEXT | YES | null |
| 5 | option_category_id | INTEGER | NO | null |
| 6 | cancel_policy | TEXT | YES | null |
| 7 | note | TEXT | YES | null |
| 8 | enable_flg | INTEGER | YES | 1 |
| 9 | created_at | TEXT | YES | datetime('now', 'localtime') |
| 10 | modified_at | TEXT | YES | datetime('now', 'localtime') |
| 11 | deleted_at | TEXT | YES | null |
| 12 | image_url | TEXT | YES | null |

## product_prices テーブル (10 カラム)

| # | カラム名 | データ型 | NULL許可 | デフォルト値 |
|---|----------|----------|----------|--------------|
| 0 | id | INTEGER | YES | null |
| 1 | product_id | INTEGER | NO | null |
| 2 | price | INTEGER | NO | null |
| 3 | category_name | TEXT | YES | null |
| 4 | created_at | TEXT | YES | datetime('now', 'localtime') |
| 5 | modified_at | TEXT | YES | datetime('now', 'localtime') |
| 6 | price_band | TEXT | YES | null |
| 7 | price_name | TEXT | YES | null |
| 8 | display_order | INTEGER | YES | 0 |
| 9 | slot_number | INTEGER | YES | 1 |

## product_stocks テーブル (13 カラム)

| # | カラム名 | データ型 | NULL許可 | デフォルト値 |
|---|----------|----------|----------|--------------|
| 0 | id | INTEGER | YES | null |
| 1 | product_id | INTEGER | NO | null |
| 2 | date | TEXT | NO | null |
| 3 | stock | INTEGER | NO | 0 |
| 4 | booked | INTEGER | NO | 0 |
| 5 | created_at | TEXT | YES | datetime('now', 'localtime') |
| 6 | modified_at | TEXT | YES | datetime('now', 'localtime') |
| 7 | time_slot_start | TEXT | YES | null |
| 8 | time_slot_end | TEXT | YES | null |
| 9 | time_slot_label | TEXT | YES | null |
| 10 | stock_name | TEXT | YES | null |
| 11 | shared_pool_id | INTEGER | YES | null |
| 12 | price_band | TEXT | YES | null |

## option_prices テーブル (6 カラム)

| # | カラム名 | データ型 | NULL許可 | デフォルト値 |
|---|----------|----------|----------|--------------|
| 0 | id | INTEGER | YES | null |
| 1 | option_id | INTEGER | NO | null |
| 2 | price | INTEGER | NO | null |
| 3 | category_name | TEXT | YES | null |
| 4 | created_at | TEXT | YES | datetime('now', 'localtime') |
| 5 | modified_at | TEXT | YES | datetime('now', 'localtime') |

## option_stocks テーブル (13 カラム)

| # | カラム名 | データ型 | NULL許可 | デフォルト値 |
|---|----------|----------|----------|--------------|
| 0 | id | INTEGER | YES | null |
| 1 | option_id | INTEGER | NO | null |
| 2 | date | TEXT | YES | null |
| 3 | stock | INTEGER | NO | 0 |
| 4 | booked | INTEGER | NO | 0 |
| 5 | created_at | TEXT | YES | datetime('now', 'localtime') |
| 6 | modified_at | TEXT | YES | datetime('now', 'localtime') |
| 7 | stock_name | TEXT | YES | null |
| 8 | price | INTEGER | YES | null |
| 9 | total_stock | INTEGER | YES | 0 |
| 10 | available_stock | INTEGER | YES | 0 |
| 11 | enable_flg | INTEGER | YES | 1 |
| 12 | shared_pool_id | INTEGER | YES | null |

