-- Change all datetime('now', 'localtime') to datetime('now', '+9 hours') for JST
-- Note: SQLite does not support ALTER COLUMN DEFAULT directly
-- This migration documents the change for reference
-- Actual implementation will be done in application code

-- For new tables created after this migration, use:
-- created_at TEXT DEFAULT (datetime('now', '+9 hours'))
-- modified_at TEXT DEFAULT (datetime('now', '+9 hours'))

-- Existing tables will continue to use their current DEFAULT values
-- But INSERT/UPDATE statements in application code will use datetime('now', '+9 hours')
