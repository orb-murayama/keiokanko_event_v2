-- ========================================
-- キャンセルポリシーを商品からイベントに移動 (Step 2/3)
-- eventsテーブルに残りのカラムを追加
-- ========================================

ALTER TABLE events ADD COLUMN cancellation_policy_details TEXT;
