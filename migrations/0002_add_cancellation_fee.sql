-- Add cancellation_fee column to bookings table
ALTER TABLE bookings ADD COLUMN cancellation_fee INTEGER DEFAULT 0;
