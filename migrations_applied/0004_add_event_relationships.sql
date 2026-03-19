-- イベント関連付け機能の追加（親子構造）
-- 作成日: 2025-12-26
-- 目的: 同一イベント内で複数の参加タイプ（出展者・来場者など）を管理

-- parent_event_id カラムを追加（親イベントのIDを格納）
ALTER TABLE events ADD COLUMN parent_event_id INTEGER;

-- event_type カラムを追加（イベントタイプを管理）
-- parent: 親イベント（複数の子イベントを持つ）
-- child: 子イベント（親イベントに紐付く）
-- standalone: 単独イベント（デフォルト）
ALTER TABLE events ADD COLUMN event_type TEXT DEFAULT 'standalone';

-- インデックス作成（検索パフォーマンス向上）
CREATE INDEX IF NOT EXISTS idx_events_parent_event_id ON events(parent_event_id);
CREATE INDEX IF NOT EXISTS idx_events_event_type ON events(event_type);

-- 既存データは全て standalone として扱う
UPDATE events SET event_type = 'standalone' WHERE event_type IS NULL;
