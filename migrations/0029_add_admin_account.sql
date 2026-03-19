-- 初期管理者アカウントを作成
-- パスワード認証ではなくOTP認証を使用するため、passwordフィールドは使用しない

INSERT OR IGNORE INTO accounts (
  id,
  login_id,
  password,
  person_name,
  email,
  role,
  enable_flg,
  account_type
) VALUES (
  1,
  'admin',
  'unused',  -- パスワード認証は使用しない（OTP認証）
  'システム管理者',
  'admin@example.com',  -- 実際のメールアドレスに変更してください
  'system_admin',
  1,
  'keio'
);
