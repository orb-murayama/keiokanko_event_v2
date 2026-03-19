-- Migration: Add cancellation_rate_3 to events table
-- Date: 2026-02-10
-- Description: Add missing cancellation_rate_3 column to events table to align with database specifications

-- Add cancellation_rate_3 column
ALTER TABLE events ADD COLUMN cancellation_rate_3 INTEGER;

-- Comment: This column represents the cancellation fee rate (percentage) for cancellation period 3
-- Related columns: cancellation_days_3 (already exists)
