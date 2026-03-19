# アカウントテストデータ

## テストアカウント一覧

### 共通パスワード
すべてのテストアカウントのパスワードは **`admin123`** です。

### アカウント詳細

| ID | ログインID | 氏名 | メールアドレス | 役割 | 有効 | 説明 |
|----|-----------|------|---------------|------|------|------|
| 1 | `admin` | 管理者 太郎 | admin@example.com | admin | ✅ | システム管理者（最高権限） |
| 2 | `client_admin_a` | 企業管理者 花子 | client_a@example.com | client_admin | ✅ | クライアントA管理者（東京・大阪・名古屋） |
| 3 | `client_staff_a` | 企業スタッフ 次郎 | staff_a@example.com | client_staff | ✅ | クライアントAスタッフ（東京のみ） |
| 4 | `client_admin_b` | 企業管理者 三郎 | client_b@example.com | client_admin | ✅ | クライアントB管理者（大阪・京都） |
| 5 | `event_planner` | イベント企画 美咲 | planner@example.com | planner | ✅ | イベント企画担当 |
| 6 | `booking_manager` | 予約管理 健太 | booking@example.com | manager | ✅ | 予約管理担当 |
| 7 | `support` | サポート 優子 | support@example.com | support | ✅ | カスタマーサポート |
| 8 | `disabled_user` | 無効ユーザー | disabled@example.com | staff | ❌ | 無効化されたアカウント（テスト用） |
| 9 | `sales` | 営業担当 大輔 | sales@example.com | sales | ✅ | 営業担当（東京・大阪・名古屋・福岡） |
| 10 | `accounting` | 経理担当 真理子 | accounting@example.com | accounting | ✅ | 経理担当 |

## データ投入方法

### ローカル開発環境
```bash
cd /home/user/webapp
npx wrangler d1 execute webapp-production --local --file=./seed_accounts.sql
```

### 本番環境
```bash
cd /home/user/webapp
npx wrangler d1 execute webapp-production --remote --file=./seed_accounts.sql
```

## データ確認

### データベースで確認
```bash
npx wrangler d1 execute webapp-production --local --command="SELECT id, login_id, person_name, role, enable_flg FROM accounts"
```

### APIで確認
```bash
curl http://localhost:3000/api/accounts | jq '.'
```

### ブラウザで確認
- アカウント一覧画面: https://3000-ib4b640jlamofc0mqgpvk-583b4d74.sandbox.novita.ai/accounts-list.html

## ログインテスト例

### 管理者でログイン
```
ログインID: admin
パスワード: admin123
```

### クライアント管理者でログイン
```
ログインID: client_admin_a
パスワード: admin123
```

## 注意事項

1. **パスワードハッシュ**: すべてのパスワードは bcrypt でハッシュ化されています
2. **有効/無効フラグ**: ID=8 のアカウントのみ無効化されています（テスト用）
3. **クライアント紐付け**: ID=2,3,4 はクライアントに紐付いています
4. **支店アクセス権限**: 一部のアカウントは特定の支店のみアクセス可能です

## データリセット

データベースをリセットして再投入する場合：
```bash
# データベースをクリア
npx wrangler d1 execute webapp-production --local --command="DELETE FROM accounts"

# テストデータを再投入
npx wrangler d1 execute webapp-production --local --file=./seed_accounts.sql
```
