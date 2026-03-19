-- Add payment_details column to booking_payments table
ALTER TABLE booking_payments ADD COLUMN payment_details TEXT;

-- Add payment_code column (for convenience store payment code)
ALTER TABLE booking_payments ADD COLUMN payment_code TEXT;

-- Add payment_due_date column (for convenience store payment deadline)
ALTER TABLE booking_payments ADD COLUMN payment_due_date TEXT;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_booking_payments_payment_code ON booking_payments(payment_code);
