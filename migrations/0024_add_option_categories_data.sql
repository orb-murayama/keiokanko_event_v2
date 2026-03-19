-- ============================================
-- Migration: Add option categories data
-- Date: 2026-02-20
-- Description: Populate option_categories table with common categories
-- ============================================

-- Clear existing data
DELETE FROM option_categories;

-- Insert option categories
INSERT INTO option_categories (name, description, created_at, modified_at)
VALUES 
('食事', '食事オプション（朝食、昼食、夕食など）', datetime('now', 'localtime'), datetime('now', 'localtime')),
('交通', '交通オプション（バス、タクシー、電車など）', datetime('now', 'localtime'), datetime('now', 'localtime')),
('宿泊', '宿泊オプション（ホテルアップグレード、追加宿泊など）', datetime('now', 'localtime'), datetime('now', 'localtime')),
('アクティビティ', 'アクティビティオプション（体験、観光、レジャーなど）', datetime('now', 'localtime'), datetime('now', 'localtime')),
('ガイド', 'ガイドオプション（日本語ガイド、英語ガイドなど）', datetime('now', 'localtime'), datetime('now', 'localtime')),
('保険', '保険オプション（旅行保険、キャンセル保険など）', datetime('now', 'localtime'), datetime('now', 'localtime')),
('お土産', 'お土産オプション（特産品、記念品など）', datetime('now', 'localtime'), datetime('now', 'localtime')),
('設備', '設備オプション（Wi-Fi、レンタル機器など）', datetime('now', 'localtime'), datetime('now', 'localtime')),
('その他', 'その他のオプション', datetime('now', 'localtime'), datetime('now', 'localtime'));
