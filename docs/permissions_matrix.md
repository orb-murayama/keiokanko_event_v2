# 権限管理仕様書

## 目次
1. [権限レベル定義](#権限レベル定義)
2. [機能別権限マトリックス](#機能別権限マトリックス)
3. [権限レベル別詳細説明](#権限レベル別詳細説明)
4. [削除操作の特別ルール](#削除操作の特別ルール)
5. [実装における注意点](#実装における注意点)

---

## 権限レベル定義

| 権限レベル | 説明 | 対象者 |
|-----------|------|--------|
| **システム管理者** | 最高権限。全機能にアクセス可能。全てのデータの閲覧・編集・削除が可能。 | システム担当者 |
| **本社管理者** | 全機能にアクセス可能。削除操作以外の全ての操作が可能。 | 本社スタッフ |
| **支店管理者** | 一部制限あり。自分が担当するイベント関連のデータのみ操作可能。会員管理は不可。 | 支店スタッフ |

---

## 機能別権限マトリックス

| 機能 | システム管理者 | 本社管理者 | 支店管理者 |
|------|---------------|-----------|----------|
| **予約管理** | ⭕ 全て可能 | ⭕ 全て可能 | ⚠️ 制限あり（担当イベントのみ） |
| **イベント管理** | ⭕ 全て可能 | ⭕ 全て可能 | ⚠️ 制限あり（公開設定変更不可） |
| **商品管理** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |
| **オプション管理** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |
| **クライアント管理** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |
| **アカウント管理** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |
| **会員管理** | ⭕ 全て可能 | ⭕ 全て可能 | ❌ アクセス不可 |
| **販売会社管理** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |
| **主催者管理** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |
| **一括メール送信** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |
| **一括メッセージ送信** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |
| **一括書類送信** | ⭕ 全て可能 | ⭕ 全て可能 | ⭕ 全て可能 |

**凡例**:
- ⭕ **全て可能**: 閲覧、作成、編集、削除の全操作が可能
- ⚠️ **制限あり**: 一部の操作に制限がある（詳細は下記参照）
- ❌ **アクセス不可**: 機能自体にアクセス不可

---

## 権限レベル別詳細説明

### 1. システム管理者

**アクセス範囲**: 全機能・全データ

**特別な権限**:
- **削除操作の独占権**: 全ての一覧画面での削除ボタンは**システム管理者のみ**表示・実行可能
  - 予約削除
  - イベント削除
  - 商品削除
  - オプション削除
  - クライアント削除
  - アカウント削除
  - 会員削除
  - 販売会社削除
  - 主催者削除

**操作可能な機能**:
- 全機能の閲覧、作成、編集、削除
- システム設定の変更
- 権限管理
- データベース管理

---

### 2. 本社管理者

**アクセス範囲**: 全機能・全データ（削除操作以外）

**制限事項**:
- **削除操作不可**: 全ての一覧画面での削除ボタンは表示されない
  - 削除が必要な場合は、システム管理者に依頼

**操作可能な機能**:
- 全機能の閲覧、作成、編集
- イベントの公開設定変更
- 会員管理の全操作（閲覧、作成、編集）
- 一括操作（メール、メッセージ、書類送信）

---

### 3. 支店管理者

**アクセス範囲**: 一部機能・担当イベント関連データのみ

#### ⚠️ 制限のある機能

##### 3.1 予約管理
**制限内容**: 自分が担当するイベントの予約のみ操作可能

**具体的な制限**:
- **予約一覧**: 担当イベントの予約のみ表示
- **予約詳細**: 担当イベントの予約のみ閲覧可能
- **予約編集**: 担当イベントの予約のみ編集可能
- **予約作成**: 担当イベントの予約のみ作成可能
- **削除操作**: 不可（システム管理者のみ）

**担当判定基準**:
- `events.assigned_account_id` = ログインアカウントID
- または `events.assigned_branch_id` = ログインアカウントの支店ID

**画面動作**:
- 担当外のイベントの予約は一覧に表示されない
- 担当外の予約詳細URLに直接アクセスした場合は403エラー

##### 3.2 イベント管理
**制限内容**: 公開設定（enable_flg等）の変更が不可

**具体的な制限**:
- **イベント一覧**: 全イベント閲覧可能
- **イベント詳細**: 全イベント閲覧可能
- **イベント作成**: 可能（ただし作成後は非公開状態）
- **イベント編集**: 可能（ただし以下の項目は編集不可）
  - `enable_flg`（有効/無効フラグ）
  - `admin_only_login_start_date`（管理者専用ログイン開始日）
  - `admin_only_login_end_date`（管理者専用ログイン終了日）
  - `general_login_start_date`（一般ログイン開始日）
  - `general_login_end_date`（一般ログイン終了日）
- **削除操作**: 不可（システム管理者のみ）

**画面動作**:
- イベント編集画面で上記項目は読み取り専用（disabled）で表示
- 「このイベントを公開するには本社管理者に連絡してください」と注意書き表示

##### 3.3 会員管理
**制限内容**: 全操作不可

**具体的な制限**:
- **会員一覧**: アクセス不可（メニューに表示されない）
- **会員詳細**: アクセス不可（URLに直接アクセスした場合は403エラー）
- **会員作成**: 不可
- **会員編集**: 不可
- **会員削除**: 不可

**理由**: 個人情報保護のため、会員管理は本社管理者以上のみ

#### ⭕ 制限のない機能

##### 3.4 商品管理
**制限内容**: なし（全て可能）

**操作可能な機能**:
- 商品一覧の閲覧
- 商品詳細の閲覧
- 商品の新規作成
- 商品の編集
- 商品の削除（**システム管理者のみ**）

##### 3.5 オプション管理
**制限内容**: なし（全て可能）

**操作可能な機能**:
- オプション一覧の閲覧
- オプション詳細の閲覧
- オプションの新規作成
- オプションの編集
- オプションの削除（**システム管理者のみ**）

##### 3.6 クライアント管理
**制限内容**: なし（全て可能）

**操作可能な機能**:
- クライアント一覧の閲覧
- クライアント詳細の閲覧
- クライアントの新規作成
- クライアントの編集
- クライアントの削除（**システム管理者のみ**）

##### 3.7 アカウント管理
**制限内容**: なし（全て可能）

**操作可能な機能**:
- アカウント一覧の閲覧
- アカウント詳細の閲覧
- アカウントの新規作成
- アカウントの編集
- アカウントの削除（**システム管理者のみ**）

##### 3.8 販売会社管理
**制限内容**: なし（全て可能）

**操作可能な機能**:
- 販売会社一覧の閲覧
- 販売会社詳細の閲覧
- 販売会社の新規作成
- 販売会社の編集
- 販売会社の削除（**システム管理者のみ**）

##### 3.9 主催者管理
**制限内容**: なし（全て可能）

**操作可能な機能**:
- 主催者一覧の閲覧
- 主催者詳細の閲覧
- 主催者の新規作成
- 主催者の編集
- 主催者の削除（**システム管理者のみ**）

##### 3.10 一括メール送信
**制限内容**: なし（全て可能）

**操作可能な機能**:
- 一括メール送信画面へのアクセス
- メール送信対象の選択
- メールテンプレートの選択・編集
- メールの送信実行
- 送信履歴の閲覧

##### 3.11 一括メッセージ送信
**制限内容**: なし（全て可能）

**操作可能な機能**:
- 一括メッセージ送信画面へのアクセス
- メッセージ送信対象の選択
- メッセージテンプレートの選択・編集
- メッセージの送信実行
- 送信履歴の閲覧

##### 3.12 一括書類送信
**制限内容**: なし（全て可能）

**操作可能な機能**:
- 一括書類送信画面へのアクセス
- 書類送信対象の選択
- 書類テンプレートの選択・編集
- 書類の送信実行
- 送信履歴の閲覧

---

## 削除操作の特別ルール

### ❗ 重要：削除ボタンの表示・実行権限

**システム管理者のみが削除可能**

全ての管理画面の一覧ページにおいて、削除ボタンは**システム管理者にのみ表示**され、実行可能です。

#### 対象画面

以下の一覧画面での削除操作は、システム管理者のみ:

1. **予約一覧** (`/admin/bookings`)
2. **イベント一覧** (`/admin/events`)
3. **商品一覧** (`/admin/products`)
4. **オプション一覧** (`/admin/options`)
5. **クライアント一覧** (`/admin/clients`)
6. **アカウント一覧** (`/admin/accounts`)
7. **会員一覧** (`/admin/members`)
8. **販売会社一覧** (`/admin/vendors`)
9. **主催者一覧** (`/admin/organizers`)
10. **共有在庫プール一覧** (`/admin/shared-stock-pools`)
11. **在庫一覧** (`/admin/products/:id/stocks`, `/admin/options/:id/stocks`)

#### 実装方法

**フロントエンド（HTML/JavaScript）**:
```javascript
// ログインユーザーの権限を確認
if (currentUser.role === 'system_admin') {
  // 削除ボタンを表示
  deleteButton.style.display = 'inline-block';
} else {
  // 削除ボタンを非表示
  deleteButton.style.display = 'none';
}
```

**バックエンド（API）**:
```typescript
// 削除APIエンドポイント
app.delete('/api/bookings/:id', async (c) => {
  const user = c.get('user'); // 認証ミドルウェアから取得
  
  // システム管理者チェック
  if (user.role !== 'system_admin') {
    return c.json({ error: '削除権限がありません' }, 403);
  }
  
  // 削除処理
  // ...
});
```

#### 理由

- **データの整合性保護**: 誤削除による重大なデータ損失を防ぐ
- **監査証跡の保持**: 削除操作を特定のユーザーに限定することで、責任の所在を明確化
- **セキュリティ**: 悪意のある削除や誤操作からシステムを保護

---

## 実装における注意点

### 1. データベーススキーマ

#### accounts テーブルへの追加項目
```sql
ALTER TABLE accounts ADD COLUMN role TEXT NOT NULL DEFAULT 'branch';
-- role: 'system_admin' | 'head_office' | 'branch'

ALTER TABLE accounts ADD COLUMN branch_id INTEGER;
-- 支店管理者の場合、所属支店ID

ALTER TABLE accounts ADD COLUMN deleted_at TEXT;
-- ソフトデリート用
```

#### events テーブルへの追加項目
```sql
ALTER TABLE events ADD COLUMN assigned_account_id INTEGER;
-- イベント担当者ID（支店管理者の担当判定用）

ALTER TABLE events ADD COLUMN assigned_branch_id INTEGER;
-- イベント担当支店ID（支店管理者の担当判定用）

-- 外部キー制約
ALTER TABLE events ADD CONSTRAINT fk_events_assigned_account 
  FOREIGN KEY (assigned_account_id) REFERENCES accounts(id);
  
ALTER TABLE events ADD CONSTRAINT fk_events_assigned_branch 
  FOREIGN KEY (assigned_branch_id) REFERENCES branches(id);
```

### 2. 認証・認可ミドルウェア

#### 権限チェック関数（TypeScript例）
```typescript
// 権限レベルの定義
enum UserRole {
  SystemAdmin = 'system_admin',
  HeadOffice = 'head_office',
  Branch = 'branch'
}

// システム管理者チェック
function isSystemAdmin(user: User): boolean {
  return user.role === UserRole.SystemAdmin;
}

// 本社管理者以上チェック
function isHeadOfficeOrAbove(user: User): boolean {
  return user.role === UserRole.SystemAdmin || user.role === UserRole.HeadOffice;
}

// イベント担当チェック（支店管理者用）
function isEventAssigned(user: User, event: Event): boolean {
  if (user.role === UserRole.SystemAdmin || user.role === UserRole.HeadOffice) {
    return true; // 本社以上は全イベントアクセス可能
  }
  
  if (user.role === UserRole.Branch) {
    // 担当者IDまたは支店IDが一致するか確認
    return event.assigned_account_id === user.id || 
           event.assigned_branch_id === user.branch_id;
  }
  
  return false;
}

// 削除権限チェック
function canDelete(user: User): boolean {
  return user.role === UserRole.SystemAdmin;
}
```

### 3. フロントエンド実装

#### メニュー表示制御（JavaScript例）
```javascript
// ログインユーザーの権限を取得
const userRole = currentUser.role;

// 会員管理メニューの表示制御
const membersMenuItem = document.getElementById('menu-members');
if (userRole === 'branch') {
  membersMenuItem.style.display = 'none'; // 支店管理者は非表示
}

// 削除ボタンの表示制御
const deleteButtons = document.querySelectorAll('.btn-delete');
if (userRole !== 'system_admin') {
  deleteButtons.forEach(btn => {
    btn.style.display = 'none'; // システム管理者以外は非表示
  });
}

// イベント編集画面の公開設定フィールド制御
if (userRole === 'branch') {
  document.getElementById('enable_flg').disabled = true;
  document.getElementById('admin_only_login_start_date').disabled = true;
  document.getElementById('admin_only_login_end_date').disabled = true;
  document.getElementById('general_login_start_date').disabled = true;
  document.getElementById('general_login_end_date').disabled = true;
  
  // 注意書きを表示
  const notice = document.createElement('p');
  notice.className = 'notice-warning';
  notice.textContent = 'このイベントを公開するには本社管理者に連絡してください。';
  document.getElementById('event-form').prepend(notice);
}
```

#### API呼び出し時のエラーハンドリング
```javascript
async function deleteItem(itemId) {
  try {
    const response = await fetch(`/api/items/${itemId}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    if (response.status === 403) {
      alert('削除権限がありません。システム管理者に連絡してください。');
      return;
    }
    
    if (!response.ok) {
      throw new Error('削除に失敗しました');
    }
    
    alert('削除しました');
    location.reload();
  } catch (error) {
    console.error('削除エラー:', error);
    alert('削除に失敗しました');
  }
}
```

### 4. バックエンド実装

#### 予約一覧API（支店管理者フィルタリング例）
```typescript
app.get('/api/bookings', async (c) => {
  const user = c.get('user'); // 認証ミドルウェアから取得
  
  let query = `
    SELECT b.*, e.name as event_name
    FROM bookings b
    LEFT JOIN events e ON b.event_id = e.id
    WHERE b.deleted_at IS NULL
  `;
  
  // 支店管理者の場合、担当イベントのみフィルタリング
  if (user.role === 'branch') {
    query += ` AND (e.assigned_account_id = ? OR e.assigned_branch_id = ?)`;
    const bookings = await c.env.DB.prepare(query)
      .bind(user.id, user.branch_id)
      .all();
    return c.json(bookings);
  }
  
  // システム管理者・本社管理者は全予約取得
  const bookings = await c.env.DB.prepare(query).all();
  return c.json(bookings);
});
```

#### イベント更新API（公開設定制限例）
```typescript
app.put('/api/events/:id', async (c) => {
  const user = c.get('user');
  const eventId = c.req.param('id');
  const body = await c.req.json();
  
  // 支店管理者の場合、公開設定フィールドを除外
  if (user.role === 'branch') {
    delete body.enable_flg;
    delete body.admin_only_login_start_date;
    delete body.admin_only_login_end_date;
    delete body.general_login_start_date;
    delete body.general_login_end_date;
  }
  
  // イベント更新処理
  // ...
});
```

#### 削除API（権限チェック例）
```typescript
app.delete('/api/bookings/:id', async (c) => {
  const user = c.get('user');
  
  // システム管理者チェック
  if (user.role !== 'system_admin') {
    return c.json({ error: '削除権限がありません' }, 403);
  }
  
  const bookingId = c.req.param('id');
  
  // ソフトデリート実行
  await c.env.DB.prepare(`
    UPDATE bookings 
    SET deleted_at = datetime('now', 'localtime')
    WHERE id = ?
  `).bind(bookingId).run();
  
  return c.json({ success: true, message: '削除しました' });
});
```

#### 会員管理API（アクセス制限例）
```typescript
app.get('/api/members', async (c) => {
  const user = c.get('user');
  
  // 支店管理者はアクセス不可
  if (user.role === 'branch') {
    return c.json({ error: 'アクセス権限がありません' }, 403);
  }
  
  // 会員一覧取得
  const members = await c.env.DB.prepare(`
    SELECT * FROM members WHERE deleted_at IS NULL
  `).all();
  
  return c.json(members);
});
```

### 5. セキュリティ考慮事項

#### URL直接アクセスの防止
- フロントエンドでメニュー非表示にしても、URL直接アクセスは可能
- **必ずバックエンドAPIでも権限チェックを実施**

#### トークンベース認証
- JWTトークンにユーザーロールを含める
- トークン検証時に権限レベルも確認

#### ログ記録
- 権限エラー（403）が発生した場合、ログに記録
- 不正アクセスの監視・検知に活用

---

## まとめ

### 権限別の主な特徴

| 項目 | システム管理者 | 本社管理者 | 支店管理者 |
|------|---------------|-----------|----------|
| **削除操作** | ⭕ 可能 | ❌ 不可 | ❌ 不可 |
| **予約管理** | ⭕ 全予約 | ⭕ 全予約 | ⚠️ 担当イベントのみ |
| **イベント公開設定** | ⭕ 可能 | ⭕ 可能 | ❌ 不可 |
| **会員管理** | ⭕ 可能 | ⭕ 可能 | ❌ 不可 |
| **その他管理機能** | ⭕ 全て可能 | ⭕ 全て可能（削除以外） | ⭕ 全て可能（削除以外） |

### 実装の優先順位

1. **削除ボタンの表示制御**（フロントエンド） - 🔥 最優先
2. **削除APIの権限チェック**（バックエンド） - 🔥 最優先
3. **会員管理のアクセス制限**（フロント・バック両方） - 高
4. **予約管理の担当フィルタリング**（バックエンド） - 高
5. **イベント編集の公開設定制限**（フロント・バック両方） - 中
6. **メニュー表示制御**（フロントエンド） - 中
7. **URLアクセス制限**（バックエンド） - 中
8. **ログ記録**（バックエンド） - 低

---

## バージョン履歴

- **v1.0** (2026-02-20): 初版作成
  - 権限レベル定義
  - 機能別権限マトリックス
  - 削除操作の特別ルール追加
  - 実装例追加

---

## 参考資料

- データベーススキーマ: `/migrations/0000_consolidated_schema.sql`
- API仕様書: `/openapi.yaml`
- README: `/README.md`

---

**作成日**: 2026年2月20日  
**更新日**: 2026年2月20日  
**作成者**: システム開発チーム  
**ステータス**: 確定版（実装前）
