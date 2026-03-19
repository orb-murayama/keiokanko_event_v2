-- Add sales control columns to options table (same as products)
ALTER TABLE options ADD COLUMN sales_start TEXT;
ALTER TABLE options ADD COLUMN sales_end TEXT;
ALTER TABLE options ADD COLUMN closing_trade INTEGER DEFAULT 0;
ALTER TABLE options ADD COLUMN purchase_limit INTEGER;

-- Set default values for existing records
UPDATE options 
SET sales_start = '2026-01-01T00:00', 
    sales_end = '2026-12-31T23:59',
    closing_trade = 0
WHERE sales_start IS NULL;
