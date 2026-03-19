#!/bin/bash

cd /home/user/webapp

# 親イベントと子イベント、商品を投入

# 東京モーターショー2025（親イベント）
npx wrangler d1 execute webapp-production --local --command="INSERT OR IGNORE INTO events (id, name, detail, location, contact, event_url, event_type, parent_event_id, event_start_date, event_end_date, registration_start_date, registration_end_date, organizer_id, client_id, customer_client_id, enable_flg, date_selection_type) VALUES (20, '東京モーターショー2025', '日本最大級の自動車展示会。最新モデルや次世代技術を一堂に展示します。', '東京ビッグサイト', 'info@motorshow2025.jp', 'https://example.com/motorshow-2025', 'parent', NULL, '2025-10-01', '2025-10-10', '2025-05-01 00:00:00', '2025-09-30 23:59:59', 1, 1, 1, 1, 'button');" 2>&1 | grep -c "successfully"

# 出展者登録（子イベント）
npx wrangler d1 execute webapp-production --local --command="INSERT OR IGNORE INTO events (id, name, detail, location, contact, event_url, event_type, parent_event_id, event_start_date, event_end_date, registration_start_date, registration_end_date, organizer_id, client_id, customer_client_id, enable_flg, date_selection_type) VALUES (21, '東京モーターショー2025 - 出展者登録', '東京モーターショー2025の出展者向け登録です。ブース申込みと出展料金のお支払いをお願いします。', '東京ビッグサイト', 'exhibitor@motorshow2025.jp', 'https://example.com/motorshow-2025-exhibitor', 'child', 20, '2025-10-01', '2025-10-10', '2025-05-01 00:00:00', '2025-08-31 23:59:59', 1, 1, 1, 1, 'button');" 2>&1 | grep -c "successfully"

# 来場者チケット（子イベント）
npx wrangler d1 execute webapp-production --local --command="INSERT OR IGNORE INTO events (id, name, detail, location, contact, event_url, event_type, parent_event_id, event_start_date, event_end_date, registration_start_date, registration_end_date, organizer_id, client_id, customer_client_id, enable_flg, date_selection_type) VALUES (22, '東京モーターショー2025 - 来場者チケット', '東京モーターショー2025の来場者向けチケット販売です。一般入場券と特別観覧席をご用意しています。', '東京ビッグサイト', 'visitor@motorshow2025.jp', 'https://example.com/motorshow-2025-visitor', 'child', 20, '2025-10-01', '2025-10-10', '2025-06-01 00:00:00', '2025-10-10 18:00:00', 1, 1, 1, 1, 'calendar');" 2>&1 | grep -c "successfully"

# 商品投入（出展者向け）
npx wrangler d1 execute webapp-production --local --command="INSERT OR IGNORE INTO products (id, event_id, name, description, enable_flg, slot_type, client_id) VALUES (101, 21, 'スタンダードブース（3m×3m）', '基本的な展示ブース。壁面パネル、照明、電源込み。', 1, 'none', 1), (102, 21, 'プレミアムブース（6m×6m）', '広々とした展示ブース。特等エリアに配置、追加照明・電源付き。', 1, 'none', 1), (103, 21, 'コーナーブース（4m×4m）', '角地の目立つブース。2面展示可能、追加看板設置可。', 1, 'none', 1);" 2>&1 | grep -c "successfully"

# 商品投入（来場者向け）
npx wrangler d1 execute webapp-production --local --command="INSERT OR IGNORE INTO products (id, event_id, name, description, enable_flg, slot_type, client_id) VALUES (201, 22, '一般入場券（1日券）', '会期中の1日有効な入場券。全展示エリア観覧可能。', 1, 'date', 1), (202, 22, '通し券（全日程）', '会期中すべての日程で入場可能。何度でもご来場いただけます。', 1, 'none', 1), (203, 22, 'VIP入場券（1日券）', '専用ラウンジ利用可、優先入場、記念品付き。', 1, 'date', 1);" 2>&1 | grep -c "successfully"

# 商品価格投入（出展者向け）
npx wrangler d1 execute webapp-production --local --command="INSERT OR IGNORE INTO product_prices (product_id, price, price_name, display_order) VALUES (101, 500000, '基本プラン', 1), (102, 1200000, '基本プラン', 1), (103, 800000, '基本プラン', 1);" 2>&1 | grep -c "successfully"

# 商品価格投入（来場者向け）
npx wrangler d1 execute webapp-production --local --command="INSERT OR IGNORE INTO product_prices (product_id, price, price_name, display_order) VALUES (201, 3000, '1日券', 1), (202, 15000, '通し券', 1), (203, 15000, 'VIP 1日券', 1);" 2>&1 | grep -c "successfully"

echo "サンプルデータ投入完了！"
