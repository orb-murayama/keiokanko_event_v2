-- ============================================
-- 商品フォーム項目マスター
-- ============================================
-- 目的: 商品ごとにカスタマイズ可能な入力フォームを動的に管理
--      商品予約時に収集する顧客情報のフィールド定義を保存
-- 機能: フォーム項目の定義、項目タイプ、必須/任意、選択肢、親子条件、並び順
-- 
-- 使用例:
-- - 宿泊プラン: チェックイン日、チェックアウト日、部屋タイプ、人数
-- - 体験ツアー: 参加日時、参加人数、体験レベル、持ち物確認
-- - 食事プラン: 希望日時、人数、アレルギー情報、席の希望
-- - レンタル商品: 利用開始日、利用終了日、サイズ、配送先
-- ============================================

CREATE TABLE IF NOT EXISTS product_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,              -- 商品ID（products.id）
  field_type TEXT NOT NULL,                 -- フィールドタイプ（text/email/tel/select/radio/checkbox/textarea/date/number）
  field_name TEXT NOT NULL,                 -- フィールド名（内部識別用、例: checkin_date, room_type）
  field_label TEXT NOT NULL,                -- フィールドラベル（表示用、例: チェックイン日、部屋タイプ）
  field_options TEXT,                       -- 選択肢（JSON形式、select/radio/checkbox用）例: ["シングル","ツイン","ダブル"]
  is_required INTEGER DEFAULT 0,            -- 必須フラグ（1:必須/0:任意）
  description TEXT,                         -- 説明文（フィールドの補足説明）
  display_order INTEGER DEFAULT 0,          -- 表示順序（昇順）
  placeholder TEXT,                         -- プレースホルダー（入力例の表示）
  parent_field_id INTEGER,                  -- 親フィールドID（条件分岐用）
  parent_condition TEXT,                    -- 親フィールドの条件値（例: "希望する"）
  indent_level INTEGER DEFAULT 0,           -- インデント階層レベル（0:親、1:子、2:孫...）
  validation_rule TEXT,                     -- バリデーションルール（JSON形式、例: {"min":1,"max":10}）
  default_value TEXT,                       -- デフォルト値
  help_text TEXT,                           -- ヘルプテキスト（詳細なガイダンス）
  created_at TEXT DEFAULT (datetime('now','localtime')),
  modified_at TEXT DEFAULT (datetime('now','localtime'))
);

-- ============================================
-- インデックス
-- ============================================

-- 商品IDでの検索を高速化（商品詳細画面でのフォーム項目取得）
CREATE INDEX IF NOT EXISTS idx_product_form_fields_product_id 
ON product_form_fields(product_id);

-- 表示順序での並び替えを高速化
CREATE INDEX IF NOT EXISTS idx_product_form_fields_display_order 
ON product_form_fields(product_id, display_order);

-- 親子関係の検索を高速化（条件分岐フィールドの取得）
CREATE INDEX IF NOT EXISTS idx_product_form_fields_parent 
ON product_form_fields(parent_field_id);

-- ============================================
-- フィールドタイプ一覧
-- ============================================
-- text      : 1行テキスト（名前、住所など）
-- email     : メールアドレス（自動バリデーション）
-- tel       : 電話番号（自動フォーマット）
-- select    : ドロップダウン選択（1つ選択）
-- radio     : ラジオボタン（1つ選択）
-- checkbox  : チェックボックス（複数選択可）
-- textarea  : 複数行テキスト（備考、要望など）
-- date      : 日付選択（チェックイン、参加日など）
-- number    : 数値入力（人数、年齢など）
-- time      : 時刻選択（集合時間など）
-- datetime  : 日時選択（予約日時など）
-- file      : ファイルアップロード（証明書など）

-- ============================================
-- 使用例: 宿泊プランのフォーム項目
-- ============================================
-- 1. チェックイン日（date, 必須, display_order: 1）
-- 2. チェックアウト日（date, 必須, display_order: 2）
-- 3. 部屋タイプ（select, 必須, 選択肢: ["シングル","ツイン","ダブル"], display_order: 3）
-- 4. 宿泊人数（number, 必須, validation: {min:1, max:4}, display_order: 4）
-- 5. 朝食希望（radio, 任意, 選択肢: ["希望する","希望しない"], display_order: 5）
-- 6. 朝食の時間帯（select, 任意, 選択肢: ["7:00-8:00","8:00-9:00"], parent_field_id: 5, parent_condition: "希望する", display_order: 6）
-- 7. アレルギー情報（textarea, 任意, display_order: 7）
-- 8. 特別なご要望（textarea, 任意, display_order: 8）

-- ============================================
-- API設計
-- ============================================
-- GET    /api/products/:product_id/form-fields        - 商品のフォーム項目一覧取得
-- GET    /api/products/:product_id/form-fields/:id    - フォーム項目詳細取得
-- POST   /api/products/:product_id/form-fields        - フォーム項目作成
-- PUT    /api/products/:product_id/form-fields/:id    - フォーム項目更新
-- DELETE /api/products/:product_id/form-fields/:id    - フォーム項目削除
-- POST   /api/products/:product_id/form-fields/reorder - 表示順序の一括更新

-- ============================================
-- セキュリティとバリデーション
-- ============================================
-- 1. product_id は必須（外部キー制約相当の検証をアプリ層で実施）
-- 2. field_type は定義済みタイプのみ許可
-- 3. field_name は半角英数字とアンダースコアのみ
-- 4. 親子関係の循環参照を防止（parent_field_id の検証）
-- 5. 条件分岐は親フィールドが select/radio の場合のみ有効
-- 6. field_options は有効なJSON形式のみ許可
-- 7. display_order の重複は許可（同順の場合はID順）
-- 8. is_required は 0 または 1 のみ

-- ============================================
-- 運用ガイドライン
-- ============================================
-- 1. フォーム項目の追加・編集は管理者のみ
-- 2. 商品公開後のフォーム項目削除は慎重に（既存予約データへの影響）
-- 3. 必須項目の追加は既存予約データの整合性を確認
-- 4. display_order は 10, 20, 30... と10刻みで設定（後から項目を挿入しやすい）
-- 5. 条件分岐は最大3階層まで（複雑化を防止）
-- 6. field_name は変更しない（予約データとの紐付けに使用）
-- 7. 削除は論理削除を推奨（deleted_at カラム追加を検討）
