-- ============================================
-- Migration: Drop unused option_prices table
-- Date: 2026-02-20
-- Description: Remove option_prices table as it is not used in the system.
--              Prices are stored in option_stocks.price instead.
-- ============================================

-- Drop option_prices table
DROP TABLE IF EXISTS option_prices;
