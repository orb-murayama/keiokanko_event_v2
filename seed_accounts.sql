-- アカウントのテストデータ

-- 1. システム管理者（最高権限）
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  1, 
  'admin', 
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  '管理者 太郎',
  'admin@example.com',
  NULL,
  'admin',
  1,
  'keio',
  NULL,
  NULL
);

-- 2. クライアント管理者（クライアントA用）
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  2,
  'client_admin_a',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  '企業管理者 花子',
  'client_a@example.com',
  1,
  'client_admin',
  1,
  'keio',
  'tokyo',
  'tokyo,osaka,nagoya'
);

-- 3. クライアントスタッフ（クライアントA用）
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  3,
  'client_staff_a',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  '企業スタッフ 次郎',
  'staff_a@example.com',
  1,
  'client_staff',
  1,
  'keio',
  'tokyo',
  'tokyo'
);

-- 4. クライアント管理者（クライアントB用）
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  4,
  'client_admin_b',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  '企業管理者 三郎',
  'client_b@example.com',
  2,
  'client_admin',
  1,
  'keio',
  'osaka',
  'osaka,kyoto'
);

-- 5. イベント企画担当
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  5,
  'event_planner',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  'イベント企画 美咲',
  'planner@example.com',
  NULL,
  'planner',
  1,
  'keio',
  NULL,
  NULL
);

-- 6. 予約管理担当
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  6,
  'booking_manager',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  '予約管理 健太',
  'booking@example.com',
  NULL,
  'manager',
  1,
  'keio',
  NULL,
  NULL
);

-- 7. カスタマーサポート
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  7,
  'support',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  'サポート 優子',
  'support@example.com',
  NULL,
  'support',
  1,
  'keio',
  NULL,
  NULL
);

-- 8. 無効化されたアカウント（テスト用）
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  8,
  'disabled_user',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  '無効ユーザー',
  'disabled@example.com',
  NULL,
  'staff',
  0,
  'keio',
  NULL,
  NULL
);

-- 9. 営業担当
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  9,
  'sales',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  '営業担当 大輔',
  'sales@example.com',
  NULL,
  'sales',
  1,
  'keio',
  'tokyo',
  'tokyo,osaka,nagoya,fukuoka'
);

-- 10. 経理担当
INSERT OR IGNORE INTO accounts (
  id, login_id, password, person_name, email, client_id, role, 
  enable_flg, account_type, primary_branch_code, accessible_branches
) VALUES (
  10,
  'accounting',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  '経理担当 真理子',
  'accounting@example.com',
  NULL,
  'accounting',
  1,
  'keio',
  NULL,
  NULL
);
