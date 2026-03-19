-- マイグレーション: eventsテーブルにクライアント企業IDカラムを追加

-- クライアント企業ID（client_idは主催者用、customer_client_idはクライアント企業用）
ALTER TABLE events ADD COLUMN customer_client_id INTEGER;
