-- Add cancellation_fee_paid column to bookings table
ALTER TABLE bookings ADD COLUMN cancellation_fee_paid INTEGER DEFAULT 0;
