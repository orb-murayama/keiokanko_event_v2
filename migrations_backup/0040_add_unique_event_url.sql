-- イベントURLにUNIQUE制約を追加
-- 同じイベントURLは許可しない（ただしNULLは許可）

-- まず、重複しているURLを持つコピーイベント（name が 'コピー' で始まる）のURLをNULLにする
UPDATE events 
SET event_url = NULL, modified_at = datetime('now', 'localtime')
WHERE name LIKE 'コピー%' 
  AND event_url IN (
    SELECT event_url 
    FROM events 
    WHERE event_url IS NOT NULL 
    GROUP BY event_url 
    HAVING COUNT(*) > 1
  );

-- UNIQUE INDEXを作成
CREATE UNIQUE INDEX IF NOT EXISTS idx_events_event_url ON events(event_url) WHERE event_url IS NOT NULL;
