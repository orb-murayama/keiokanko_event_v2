-- ============================================
-- フォーム設定サンプルデータ (event_form_fields)
-- ============================================
-- イベントID=1 のサンプルフォーム設定

-- 基本情報セクション
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order, placeholder, description)
VALUES (1, 'text', 'company_name', '会社名', 1, 10, '例: 株式会社〇〇', '所属されている会社名を入力してください');

INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order, placeholder)
VALUES (1, 'text', 'department', '部署名', 0, 20, '例: 営業部');

INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order, placeholder)
VALUES (1, 'text', 'position', '役職', 0, 30, '例: 部長');

-- 連絡先情報
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order, placeholder, description)
VALUES (1, 'tel', 'emergency_contact', '緊急連絡先', 1, 40, '例: 090-1234-5678', '当日連絡可能な電話番号を入力してください');

INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order)
VALUES (1, 'email', 'sub_email', '予備メールアドレス', 0, 50);

-- 食事選択（プルダウン）
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, display_order, description)
VALUES (1, 'select', 'meal_type', '食事タイプ', '["和食", "洋食", "中華", "ベジタリアン"]', 1, 60, 'お好みの食事タイプをお選びください');

-- アレルギー有無（ラジオボタン）
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, display_order)
VALUES (1, 'radio', 'has_allergy', 'アレルギーの有無', '["なし", "あり"]', 1, 70);

-- アレルギー詳細（条件付き表示 - "あり"を選択した場合のみ表示）
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order, placeholder, parent_field_id, parent_condition, indent_level, description)
VALUES (1, 'textarea', 'allergy_details', 'アレルギー詳細', 1, 71, '例: 卵、小麦', 7, 'あり', 1, '具体的なアレルギー食材を記入してください');

-- 参加理由（複数選択チェックボックス）
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, display_order, description)
VALUES (1, 'checkbox', 'participation_reasons', '参加理由（複数選択可）', '["業務上必要", "興味がある", "上司の推薦", "ネットワーキング", "その他"]', 1, 80, '当てはまるものを全てお選びください');

-- その他の理由（条件付き表示 - "その他"を選択した場合のみ表示）
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order, placeholder, parent_field_id, parent_condition, indent_level)
VALUES (1, 'text', 'other_reason', 'その他の理由', 0, 81, '具体的な理由を入力してください', 9, 'その他', 1);

-- 宿泊希望
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, display_order)
VALUES (1, 'radio', 'accommodation_needed', '宿泊希望', '["不要", "必要"]', 1, 90);

-- 宿泊タイプ（条件付き表示 - "必要"を選択した場合のみ表示）
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, display_order, parent_field_id, parent_condition, indent_level)
VALUES (1, 'select', 'room_type', '部屋タイプ', '["シングル", "ツイン", "ダブル"]', 1, 91, 11, '必要', 1);

-- 特記事項
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order, placeholder, description)
VALUES (1, 'textarea', 'special_notes', '特記事項・ご要望', 0, 100, 'その他ご要望がございましたらご記入ください', '座席の希望や特別な配慮が必要な場合などご記入ください');

-- 個人情報同意
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, display_order, description)
VALUES (1, 'checkbox', 'privacy_agreement', '個人情報の取り扱いに同意する', '["同意する"]', 1, 110, '個人情報保護方針をご確認の上、チェックしてください');

-- ============================================
-- サンプルデータの説明
-- ============================================
-- このサンプルでは以下の機能を実装しています：
-- 1. 基本的なテキスト入力フィールド
-- 2. プルダウン選択（select）
-- 3. ラジオボタン（radio）
-- 4. チェックボックス（checkbox）
-- 5. 条件付き表示フィールド（parent_field_id, parent_condition を使用）
-- 6. インデント表示（indent_level を使用）
-- 7. 必須/任意の制御（is_required）
-- 8. プレースホルダーと説明文

-- ============================================
-- 動作確認用クエリ
-- ============================================
-- 全フィールドを表示順に取得
-- SELECT * FROM event_form_fields WHERE event_id = 1 ORDER BY display_order;

-- 条件付き表示フィールドの親子関係を確認
-- SELECT 
--   child.id, child.field_label, child.parent_field_id, 
--   parent.field_label as parent_label, child.parent_condition
-- FROM event_form_fields child
-- LEFT JOIN event_form_fields parent ON child.parent_field_id = parent.id
-- WHERE child.event_id = 1 AND child.parent_field_id IS NOT NULL
-- ORDER BY child.display_order;
