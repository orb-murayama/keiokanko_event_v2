-- Migration: Add stock_type column to booking_items table
-- Purpose: Distinguish between individual stock (product_stocks/option_stocks) 
--          and shared stock (shared_stock_pools) for correct inventory management
-- Date: 2026-03-12

-- Add stock_type column to booking_items
-- Values: 'individual' for product_stocks/option_stocks
--         'shared' for shared_stock_pools
ALTER TABLE booking_items ADD COLUMN stock_type TEXT DEFAULT 'individual';

-- Update existing records: if stock_id exists, check which table it belongs to
-- Note: This is a one-time data migration for existing records
-- For products: check if stock_id exists in product_stocks (individual) or shared_stock_pools (shared)
UPDATE booking_items 
SET stock_type = 'shared'
WHERE item_type = 'product' 
  AND stock_id IS NOT NULL
  AND stock_id NOT IN (SELECT id FROM product_stocks);

-- For options: check if stock_id exists in option_stocks (individual) or shared_stock_pools (shared)
UPDATE booking_items 
SET stock_type = 'shared'
WHERE item_type = 'option' 
  AND stock_id IS NOT NULL
  AND stock_id NOT IN (SELECT id FROM option_stocks);
