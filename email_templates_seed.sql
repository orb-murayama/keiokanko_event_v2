-- メールテンプレート（OTP送信用）
INSERT OR IGNORE INTO email_templates (
  template_name, 
  description, 
  from_email, 
  subject_template, 
  body_template, 
  is_active
) VALUES (
  'otp',
  'ワンタイムパスワード送信',
  'orb-japan@keio-kanko.co.jp',
  'ワンタイムパスワードのご案内',
  '<html><body><p>あなたのワンタイムパスワードは {{otp_code}} です。</p><p>このパスワードは10分間有効です。</p></body></html>',
  1
);

-- 予約完了メール用テンプレート（将来用）
-- INSERT OR IGNORE INTO email_templates (...) VALUES (...);
