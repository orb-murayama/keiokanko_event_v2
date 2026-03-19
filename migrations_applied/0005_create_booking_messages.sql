-- ========================================
-- 予約メッセージテーブル
-- ========================================
-- 目的: 予約に紐づくメッセージ（お客様通信）を管理
-- 用途: 一括メッセージ登録、マイページ表示、送信履歴管理

CREATE TABLE IF NOT EXISTS booking_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,              -- 予約ID（bookings.id）
  booking_number TEXT NOT NULL,             -- 予約番号（検索用）
  recipient_email TEXT NOT NULL,            -- 送信先メールアドレス
  title TEXT NOT NULL,                      -- タイトル
  message TEXT NOT NULL,                    -- メッセージ内容
  scheduled_send_at TEXT NOT NULL,          -- 送信予定日時（YYYY-MM-DD HH:MM:SS）
  sent_at TEXT,                             -- 実際の送信日時
  send_status TEXT DEFAULT 'pending',       -- 送信ステータス（pending/sent/failed）
  display_on_mypage INTEGER DEFAULT 1,      -- マイページに表示するか（0=非表示, 1=表示）
  created_by TEXT,                          -- 登録者
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_booking_messages_booking ON booking_messages(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_messages_number ON booking_messages(booking_number);
CREATE INDEX IF NOT EXISTS idx_booking_messages_status ON booking_messages(send_status);
CREATE INDEX IF NOT EXISTS idx_booking_messages_scheduled ON booking_messages(scheduled_send_at);
CREATE INDEX IF NOT EXISTS idx_booking_messages_mypage ON booking_messages(display_on_mypage);

-- ========================================
-- 送信ステータスの定義
-- ========================================
-- pending: 送信待ち（デフォルト）
-- sent: 送信済み
-- failed: 送信失敗
-- canceled: キャンセル

-- ========================================
-- 使用例
-- ========================================
-- 1. メッセージの登録
-- INSERT INTO booking_messages (booking_id, booking_number, recipient_email, title, message, scheduled_send_at, display_on_mypage)
-- VALUES (1, 'BK20260209-001', 'customer@example.com', 'イベント変更のお知らせ', '開催日が変更になりました', '2026-02-10 10:00:00', 1);
--
-- 2. 予約に紐づくメッセージ一覧取得
-- SELECT * FROM booking_messages WHERE booking_number = 'BK20260209-001' ORDER BY scheduled_send_at DESC;
--
-- 3. マイページ表示用メッセージ取得
-- SELECT * FROM booking_messages WHERE booking_number = 'BK20260209-001' AND display_on_mypage = 1 ORDER BY scheduled_send_at DESC;
--
-- 4. 送信待ちメッセージ取得
-- SELECT * FROM booking_messages WHERE send_status = 'pending' AND scheduled_send_at <= datetime('now', 'localtime') ORDER BY scheduled_send_at ASC;
