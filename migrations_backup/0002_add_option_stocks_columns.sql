-- Add missing columns to option_stocks table
ALTER TABLE option_stocks ADD COLUMN stock_name TEXT;
ALTER TABLE option_stocks ADD COLUMN price INTEGER;
ALTER TABLE option_stocks ADD COLUMN total_stock INTEGER DEFAULT 0;
ALTER TABLE option_stocks ADD COLUMN available_stock INTEGER DEFAULT 0;
ALTER TABLE option_stocks ADD COLUMN enable_flg INTEGER DEFAULT 1;
