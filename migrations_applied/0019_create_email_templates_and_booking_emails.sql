-- メールテンプレートテーブル
CREATE TABLE IF NOT EXISTS email_templates (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  template_name TEXT NOT NULL UNIQUE,
  description TEXT,
  from_email TEXT NOT NULL,
  bcc_email TEXT,
  subject_template TEXT NOT NULL,
  body_template TEXT NOT NULL,
  is_active INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime'))
);

CREATE INDEX IF NOT EXISTS idx_email_templates_active ON email_templates(is_active);

-- 予約メールテーブル
CREATE TABLE IF NOT EXISTS booking_emails (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_number TEXT NOT NULL,
  from_email TEXT NOT NULL,
  to_email TEXT NOT NULL,
  bcc_email TEXT,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  scheduled_send_at DATETIME NOT NULL,
  send_status TEXT DEFAULT 'pending', -- pending, sent, failed
  sent_at DATETIME,
  error_message TEXT,
  template_id INTEGER,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (template_id) REFERENCES email_templates(id)
);

CREATE INDEX IF NOT EXISTS idx_booking_emails_booking ON booking_emails(booking_number);
CREATE INDEX IF NOT EXISTS idx_booking_emails_status ON booking_emails(send_status);
CREATE INDEX IF NOT EXISTS idx_booking_emails_scheduled ON booking_emails(scheduled_send_at);

-- サンプルテンプレート
INSERT INTO email_templates (template_name, description, from_email, subject_template, body_template) VALUES
('予約確認メール', 'お客様への予約確認メール', 'noreply@example.com', '【{{event_name}}】ご予約確認', '{{booker_name}} 様

この度は{{event_name}}にお申し込みいただき、誠にありがとうございます。

■ご予約内容
予約番号: {{booking_number}}
イベント名: {{event_name}}
開催期間: {{event_start_date}} 〜 {{event_end_date}}

ご不明な点がございましたら、お気軽にお問い合わせください。

どうぞよろしくお願いいたします。');
