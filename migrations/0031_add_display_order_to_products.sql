-- Migration: 0031_add_display_order_to_products
-- Description: Add display_order column to products table for sorting
-- Date: 2026-03-11

-- Add display_order column to products table
ALTER TABLE products ADD COLUMN display_order INTEGER DEFAULT 1;

-- Update existing products to have display_order = 1
UPDATE products SET display_order = 1 WHERE display_order IS NULL;
