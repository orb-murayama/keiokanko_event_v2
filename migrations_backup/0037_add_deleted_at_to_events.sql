-- Add deleted_at column for soft delete
ALTER TABLE events ADD COLUMN deleted_at DATETIME;

-- Create index for better query performance
CREATE INDEX idx_events_deleted_at ON events(deleted_at);
