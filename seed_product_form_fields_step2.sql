-- ============================================
-- 商品フォーム項目マスター - シードデータ（ステップ2: 子フィールド）
-- ============================================

-- ============================================
-- 宿泊プラン（product_id: 1）の子フィールド
-- ============================================

-- 朝食オプションの子フィールド
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, parent_field_id, parent_condition, indent_level) 
SELECT 
  1, 
  'select', 
  'breakfast_time', 
  '朝食の時間帯', 
  '["7:00-7:30","7:30-8:00","8:00-8:30","8:30-9:00","9:00-9:30"]', 
  0, 
  'ご希望の朝食時間帯をお選びください', 
  60, 
  id, 
  '希望する', 
  1
FROM product_form_fields 
WHERE product_id=1 AND field_name='breakfast_option';

INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, parent_field_id, parent_condition, indent_level) 
SELECT 
  1, 
  'checkbox', 
  'breakfast_menu', 
  '朝食メニュー', 
  '["和食","洋食","アレルギー対応食"]', 
  0, 
  'ご希望のメニューを選択してください（複数選択可）', 
  70, 
  id, 
  '希望する', 
  1
FROM product_form_fields 
WHERE product_id=1 AND field_name='breakfast_option';

-- ============================================
-- 体験ツアー（product_id: 2）の子フィールド
-- ============================================

-- 経験者向け追加情報
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, field_options, is_required, description, display_order, parent_field_id, parent_condition, indent_level) 
SELECT 
  2, 
  'select', 
  'equipment_rental', 
  '装備レンタル', 
  '["必要","不要（持参）"]', 
  0, 
  '装備のレンタル希望をお選びください', 
  50, 
  id, 
  '経験者', 
  1
FROM product_form_fields 
WHERE product_id=2 AND field_name='experience_level';

-- 送迎オプションの子フィールド
INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, is_required, description, display_order, placeholder, parent_field_id, parent_condition, indent_level, help_text) 
SELECT 
  2, 
  'text', 
  'pickup_location', 
  '送迎場所（住所）', 
  0, 
  '送迎希望の場合、お迎え場所を入力してください', 
  70, 
  '例: 〇〇ホテル、△△駅など',
  id, 
  '希望する', 
  1,
  NULL
FROM product_form_fields 
WHERE product_id=2 AND field_name='pickup_option';

INSERT INTO product_form_fields (product_id, field_type, field_name, field_label, is_required, description, display_order, placeholder, parent_field_id, parent_condition, indent_level, help_text) 
SELECT 
  2, 
  'time', 
  'pickup_time', 
  '希望送迎時刻', 
  0, 
  'ご希望の送迎時刻をお選びください', 
  80,
  NULL,
  id, 
  '希望する', 
  1,
  '集合時刻の30分前が目安です'
FROM product_form_fields 
WHERE product_id=2 AND field_name='pickup_option';

-- ============================================
-- 確認SQL
-- ============================================
-- SELECT id, field_name, field_label, field_type, is_required, display_order, parent_field_id, indent_level 
-- FROM product_form_fields 
-- WHERE product_id = 1 
-- ORDER BY display_order;
