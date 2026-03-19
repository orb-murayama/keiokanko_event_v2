-- Add image_url column to events table
ALTER TABLE events ADD COLUMN image_url TEXT;

-- Update existing events with a default placeholder image
UPDATE events SET image_url = '/static/images/event-placeholder.jpg' WHERE image_url IS NULL;
