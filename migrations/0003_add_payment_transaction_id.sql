-- Add payment_transaction_id column to booking_payments table
ALTER TABLE booking_payments ADD COLUMN payment_transaction_id TEXT;

-- Create index for payment_transaction_id
CREATE INDEX IF NOT EXISTS idx_booking_payments_transaction_id ON booking_payments(payment_transaction_id);
