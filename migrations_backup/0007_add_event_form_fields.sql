-- イベント申込フォームフィールド設定テーブル

CREATE TABLE IF NOT EXISTS event_form_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  field_type TEXT NOT NULL, -- 'select', 'checkbox', 'radio', 'text', 'textarea', 'file', 'date'
  field_name TEXT NOT NULL, -- フィールド名（例：gender, age_group）
  field_label TEXT NOT NULL, -- 項目名（例：性別、年齢層）
  field_options TEXT, -- 選択肢（JSON形式: ["選択肢1", "選択肢2", ...]）
  is_required INTEGER DEFAULT 0, -- 0:任意 1:必須
  description TEXT, -- 説明文
  display_order INTEGER DEFAULT 0, -- 表示順
  placeholder TEXT, -- プレースホルダー
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (event_id) REFERENCES events(id)
);

CREATE INDEX IF NOT EXISTS idx_event_form_fields_event_id ON event_form_fields(event_id);
CREATE INDEX IF NOT EXISTS idx_event_form_fields_display_order ON event_form_fields(display_order);

-- サンプルデータ
INSERT INTO event_form_fields (event_id, field_type, field_name, field_label, field_options, is_required, description, display_order) VALUES
(1, 'text', 'company_name', '会社名', NULL, 0, '法人の方のみご記入ください', 1),
(1, 'select', 'age_group', '年齢層', '["20歳未満", "20代", "30代", "40代", "50代", "60歳以上"]', 1, 'ご来場者の年齢層をお選びください', 2),
(1, 'radio', 'participation_count', '参加人数', '["1名", "2名", "3-5名", "6名以上"]', 1, NULL, 3),
(1, 'checkbox', 'interests', '興味のあるプログラム', '["花火大会", "屋台グルメ", "音楽ライブ", "子供向けイベント"]', 0, '複数選択可能です', 4),
(1, 'textarea', 'special_requests', 'ご要望・お問い合わせ', NULL, 0, 'アレルギーや車椅子の利用など、特別なご要望がございましたらご記入ください', 5),
(1, 'date', 'preferred_date', '希望日', NULL, 0, '複数日程がある場合、ご希望の日付をお選びください', 6);
