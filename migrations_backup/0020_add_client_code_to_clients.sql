-- マイグレーション: clientsテーブルにクライアントID（文字列）カラムを追加

ALTER TABLE clients ADD COLUMN client_code TEXT;

-- ユニークインデックスを作成
CREATE UNIQUE INDEX idx_clients_client_code ON clients(client_code) WHERE client_code IS NOT NULL;
