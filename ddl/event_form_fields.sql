-- ============================================
-- フォーム設定テーブル (event_form_fields)
-- ============================================
-- イベント予約フォームのカスタムフィールド設定を管理するテーブル
-- 動的にフォーム項目を追加・編集・削除できる機能を提供

CREATE TABLE IF NOT EXISTS `event_form_fields` (
  -- 基本情報
  `id` INTEGER PRIMARY KEY AUTOINCREMENT COMMENT 'フォームフィールドID（主キー）',
  `event_id` INTEGER NOT NULL COMMENT 'イベントID（外部キー：events.id）',
  
  -- フィールド定義
  `field_type` TEXT NOT NULL COMMENT 'フィールドタイプ（text, textarea, select, radio, checkbox, date, email, tel, number, file）',
  `field_name` TEXT NOT NULL COMMENT 'フィールド名（フォーム送信時のname属性、英数字とアンダースコアのみ）',
  `field_label` TEXT NOT NULL COMMENT 'フィールドラベル（画面表示用の日本語名）',
  `field_options` TEXT NULL COMMENT '選択肢（select, radio, checkbox用。JSON形式またはカンマ区切り）',
  
  -- バリデーション
  `is_required` INTEGER NOT NULL DEFAULT 0 COMMENT '必須フラグ（1:必須/0:任意）',
  `description` TEXT NULL COMMENT '説明文（フィールドの補足説明、ヘルプテキスト）',
  
  -- 表示制御
  `display_order` INTEGER NOT NULL DEFAULT 0 COMMENT '表示順序（昇順で表示、0が最初）',
  `placeholder` TEXT NULL COMMENT 'プレースホルダー（入力欄の例示テキスト）',
  
  -- 条件付き表示
  `parent_field_id` INTEGER NULL COMMENT '親フィールドID（条件付き表示用、他のフィールドの値に依存）',
  `parent_condition` TEXT NULL COMMENT '表示条件（親フィールドの値がこの条件を満たす場合に表示）',
  `indent_level` INTEGER NOT NULL DEFAULT 0 COMMENT 'インデントレベル（0:通常、1以上:階層表示）',
  
  -- タイムスタンプ
  `created_at` TEXT NOT NULL DEFAULT (datetime('now', 'localtime')) COMMENT '作成日時',
  `modified_at` TEXT NOT NULL DEFAULT (datetime('now', 'localtime')) COMMENT '更新日時',
  
  -- インデックス
  CONSTRAINT fk_event_form_fields_event FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT fk_event_form_fields_parent FOREIGN KEY (`parent_field_id`) REFERENCES `event_form_fields` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- インデックス作成
CREATE INDEX IF NOT EXISTS `idx_event_form_fields_event_id` ON `event_form_fields` (`event_id`);
CREATE INDEX IF NOT EXISTS `idx_event_form_fields_display_order` ON `event_form_fields` (`event_id`, `display_order`);
CREATE INDEX IF NOT EXISTS `idx_event_form_fields_parent_field_id` ON `event_form_fields` (`parent_field_id`);

-- ============================================
-- フィールドタイプの説明
-- ============================================
-- text: 1行テキスト入力
-- textarea: 複数行テキスト入力
-- select: プルダウン選択
-- radio: ラジオボタン（単一選択）
-- checkbox: チェックボックス（複数選択）
-- date: 日付入力
-- email: メールアドレス入力
-- tel: 電話番号入力
-- number: 数値入力
-- file: ファイルアップロード

-- ============================================
-- 使用例
-- ============================================
-- 例1: テキスト入力（必須）
-- INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, is_required, display_order, placeholder)
-- VALUES (1, 'text', 'company_name', '会社名', 1, 1, '例: 株式会社〇〇');

-- 例2: プルダウン選択
-- INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, display_order)
-- VALUES (1, 'select', 'meal_type', '食事タイプ', '["和食", "洋食", "中華"]', 1, 2);

-- 例3: 条件付き表示フィールド
-- INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, parent_field_id, parent_condition, indent_level, display_order)
-- VALUES (1, 'text', 'allergy_details', 'アレルギー詳細', 5, 'あり', 1, 6);

-- ============================================
-- 注意事項
-- ============================================
-- 1. field_name は英数字とアンダースコアのみ使用可能（データベースカラム名の制約に準拠）
-- 2. field_options は JSON形式推奨（["選択肢1", "選択肢2", ...]）
-- 3. parent_field_id を使用する場合、循環参照に注意
-- 4. display_order は連番でなくても良い（10, 20, 30...のように間隔を空けると挿入が容易）
-- 5. 条件付き表示は最大2階層まで推奨（UXの観点から）
