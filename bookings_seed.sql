-- 予約データのテストデータ

-- 商品予約データ（5件）
INSERT OR IGNORE INTO product_bookings (id, booking_number, customer_id, product_id, price, quantity, booking_status, payment_status) VALUES
  (1, 'BK-2025-001', 1, 1, 5000, 1, 'confirmed', 'paid'),
  (2, 'BK-2025-002', 2, 2, 3000, 2, 'reserved', 'pending'),
  (3, 'BK-2025-003', 3, 3, 10000, 1, 'confirmed', 'paid'),
  (4, 'BK-2025-004', 4, 4, 8000, 1, 'reserved', 'pending'),
  (5, 'BK-2025-005', 5, 5, 15000, 3, 'confirmed', 'paid');
