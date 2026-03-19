-- Add deleted_at column to products table
ALTER TABLE products ADD COLUMN deleted_at DATETIME;

-- Add deleted_at column to options table
ALTER TABLE options ADD COLUMN deleted_at DATETIME;

-- Create indexes for better query performance
CREATE INDEX idx_products_deleted_at ON products(deleted_at);
CREATE INDEX idx_options_deleted_at ON options(deleted_at);
