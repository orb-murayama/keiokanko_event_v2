-- ============================================
-- 商品フォーム項目マスター - シードデータ（ステップ1: 親フィールド）
-- ============================================

-- ============================================
-- 宿泊プラン（product_id: 1）の親フィールド
-- ============================================

-- 基本情報
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, placeholder, validation_rule, help_text) VALUES
(1, 'date', 'checkin_date', 'チェックイン日', NULL, 1, 'ご宿泊開始日をお選びください', 10, '2024-04-01', '{"min":"today"}', 'チェックイン時間は15:00以降です'),
(1, 'date', 'checkout_date', 'チェックアウト日', NULL, 1, 'ご宿泊終了日をお選びください', 20, '2024-04-02', '{"min":"today+1"}', 'チェックアウト時間は11:00までです'),
(1, 'select', 'room_type', '部屋タイプ', '["シングル","ツイン","ダブル","スイート"]', 1, 'ご希望の部屋タイプをお選びください', 30, NULL, NULL, '料金は部屋タイプにより異なります'),
(1, 'number', 'guest_count', '宿泊人数', NULL, 1, '宿泊される人数を入力してください', 40, '2', '{"min":1,"max":4}', '1部屋あたりの最大人数は4名様までです');

-- 朝食オプション（親）
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, placeholder, parent_field_id, parent_condition, indent_level) VALUES
(1, 'radio', 'breakfast_option', '朝食希望', '["希望する","希望しない"]', 0, '朝食の有無をお選びください', 50, NULL, NULL, NULL, 0);

-- 追加情報
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, is_required, description, display_order, placeholder) VALUES
(1, 'textarea', 'allergy_info', 'アレルギー情報', 0, '食物アレルギーがある場合はご記入ください', 80, '例: 卵、乳製品、小麦など'),
(1, 'textarea', 'special_requests', '特別なご要望', 0, 'その他ご要望がございましたらご記入ください', 90, '例: 高層階希望、禁煙室希望など');

-- ============================================
-- 体験ツアー（product_id: 2）の親フィールド
-- ============================================

-- 参加情報
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, placeholder, validation_rule, help_text) VALUES
(2, 'date', 'tour_date', '参加希望日', NULL, 1, 'ツアー参加日をお選びください', 10, '2024-04-15', '{"min":"today+3"}', '予約は3日前までにお願いします'),
(2, 'select', 'tour_time', '希望時間帯', '["午前の部（9:00-12:00）","午後の部（13:00-16:00）"]', 1, 'ご希望の時間帯をお選びください', 20, NULL, NULL, '所要時間は約3時間です'),
(2, 'number', 'participant_count', '参加人数', NULL, 1, '参加される人数を入力してください', 30, '2', '{"min":1,"max":10}', '最少催行人数2名、最大10名までです'),
(2, 'radio', 'experience_level', '体験レベル', '["初心者","経験者"]', 1, '体験レベルをお選びください', 40, NULL, NULL, NULL, 0);

-- 送迎オプション（親）
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, parent_field_id, parent_condition, indent_level, help_text) VALUES
(2, 'radio', 'pickup_option', '送迎希望', '["希望する","希望しない（現地集合）"]', 0, '送迎の有無をお選びください', 60, NULL, NULL, 0, '送迎は無料です（一部エリア除く）');

-- 追加情報
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, is_required, description, display_order, placeholder) VALUES
(2, 'textarea', 'health_info', '健康状態について', 0, '持病や健康上の注意事項があればご記入ください', 90, '例: 高血圧、心臓疾患など');

INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, placeholder) VALUES
(2, 'checkbox', 'consent_items', '同意事項', '["参加規約に同意する","キャンセルポリシーに同意する","安全管理に協力する"]', 1, '以下の項目をご確認の上、チェックしてください', 100, NULL);
