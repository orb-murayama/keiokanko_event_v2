-- Migration: Add consent fields for privacy policy and terms
-- Date: 2026-03-11
-- Description: Create event_consents table and add consent tracking to bookings

-- Create new table for event consent configuration
-- This approach avoids SQLite's ALTER TABLE column limit (127 columns)
CREATE TABLE IF NOT EXISTS event_consents (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  
  -- Privacy Policy Settings
  privacy_policy_enabled INTEGER DEFAULT 1,
  privacy_policy_required INTEGER DEFAULT 1,
  privacy_policy_title TEXT DEFAULT '個人情報の取り扱いについて',
  privacy_policy_content TEXT,
  privacy_policy_consent_text TEXT DEFAULT '上記の個人情報の取り扱いに同意します',
  
  -- Terms and Conditions Settings
  terms_enabled INTEGER DEFAULT 1,
  terms_required INTEGER DEFAULT 1,
  terms_title TEXT DEFAULT '旅行条件について',
  terms_content TEXT,
  terms_consent_text TEXT DEFAULT '上記の旅行条件に同意します',
  
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
  UNIQUE(event_id)
);

-- Add consent tracking fields to bookings table
ALTER TABLE bookings ADD COLUMN privacy_policy_agreed INTEGER DEFAULT 0;
ALTER TABLE bookings ADD COLUMN privacy_policy_agreed_at TEXT;
ALTER TABLE bookings ADD COLUMN terms_agreed INTEGER DEFAULT 0;
ALTER TABLE bookings ADD COLUMN terms_agreed_at TEXT;

-- Insert default consent settings for all existing events
INSERT INTO event_consents (event_id, privacy_policy_content, terms_content)
SELECT 
  id,
  '## 個人情報の取り扱いについて

弊社では、お客様の個人情報を適切に取り扱うため、以下の方針に基づき個人情報保護に努めております。

### 1. 個人情報の利用目的

お客様からご提供いただいた個人情報は、以下の目的で利用いたします：

- 旅行商品・サービスのご提供
- お客様からのお問い合わせへの対応
- 旅行に関する情報のご案内
- アンケート調査およびサービス向上のための分析
- その他、お客様との取引に付随する業務

### 2. 個人情報の第三者提供

お客様の個人情報は、以下の場合を除き、第三者に提供することはありません：

- お客様の同意がある場合
- 法令に基づく場合
- 旅行サービスの提供に必要な範囲で、運送機関・宿泊機関等へ提供する場合

### 3. 個人情報の管理

お客様の個人情報は、適切な安全対策を講じて管理し、紛失、漏洩、改ざん等を防止いたします。

### 4. お問い合わせ窓口

個人情報の取り扱いに関するお問い合わせは、以下までご連絡ください：

**京王観光株式会社**  
電話：03-XXXX-XXXX  
受付時間：平日 9:00～18:00',
  '## 旅行条件について

本旅行は、募集型企画旅行契約の条件に基づき実施いたします。

### 旅行条件説明書

詳細な旅行条件につきましては、以下の旅行条件説明書をご確認ください：

[旅行条件説明書（PDF）](https://keio.tabibako.net/assets/pdf/conditions_kokunai_boshuu_nt.pdf)

### 主な内容

- 旅行代金に含まれるもの
- 取消料・変更料
- 旅程保証
- 特別補償
- 個人情報の取り扱い
- その他の条件

ご不明な点がございましたら、お気軽にお問い合わせください。'
FROM events
WHERE NOT EXISTS (
  SELECT 1 FROM event_consents WHERE event_consents.event_id = events.id
);
