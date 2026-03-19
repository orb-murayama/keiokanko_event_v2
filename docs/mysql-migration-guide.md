# D1 (SQLite) から MySQL 8 への移行ガイド

## 📋 目次
1. [データ型の違い](#1-データ型の違い)
2. [SQL構文の違い](#2-sql構文の違い)
3. [トランザクション・ロック](#3-トランザクションロック)
4. [パフォーマンス最適化](#4-パフォーマンス最適化)
5. [文字エンコーディング](#5-文字エンコーディング)
6. [JSON型の活用](#6-json型の活用)
7. [接続・デプロイ方法](#7-接続デプロイ方法)
8. [移行手順](#8-移行手順)

---

## ⚠️ 最重要ポイント

### Cloudflare Workers/Pagesの制約
**Cloudflare WorkersからはMySQL直接接続が不可能です！**

本番環境でMySQL 8を使用する場合、以下のいずれかの構成が必要です：

1. **別サーバーにAPIサーバーを立てる（推奨）**
2. **PlanetScale（HTTP API対応MySQL）を使用**
3. **D1を継続利用**

---

## 1. データ型の違い

### 基本的なマッピング表

| SQLite (D1)      | MySQL 8                | 推奨事項                                  |
|------------------|------------------------|-------------------------------------------|
| INTEGER          | BIGINT UNSIGNED        | AUTO_INCREMENTはBIGINT推奨（大量データ対応）|
| TEXT             | VARCHAR(255), TEXT     | 255文字以下はVARCHAR、超える場合はTEXT     |
| TEXT (長文)      | TEXT, MEDIUMTEXT       | 詳細説明などはTEXT、超大量はMEDIUMTEXT     |
| REAL             | DECIMAL(10,2)          | 金額はDECIMAL（精度保証）                 |
| INTEGER (flag)   | TINYINT(1)             | フラグ類は0/1のTINYINT(1)                 |
| TEXT (datetime)  | DATETIME               | タイムスタンプはDATETIME                  |
| TEXT (JSON)      | JSON                   | MySQL 8のJSON型を活用                     |

### 具体例: eventsテーブル

#### 現在のSQLite版
```sql
CREATE TABLE events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  detail TEXT,
  branch_code TEXT,
  enable_flg INTEGER DEFAULT 1,
  created_at TEXT DEFAULT (datetime('now'))
);
```

#### MySQL 8推奨版
```sql
CREATE TABLE events (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'イベントID',
  name VARCHAR(255) NOT NULL COMMENT 'イベント名',
  detail TEXT COMMENT '詳細説明',
  branch_code CHAR(2) COMMENT '担当支店コード',
  enable_flg TINYINT(1) NOT NULL DEFAULT 1 COMMENT '有効フラグ',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  modified_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP 
    ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  
  INDEX idx_name (name),
  INDEX idx_branch_code (branch_code),
  INDEX idx_enable_flg (enable_flg),
  
  FOREIGN KEY (branch_code) REFERENCES branches(branch_code) 
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 2. SQL構文の違い

### 日付・時刻関数の変更

| 機能               | SQLite (D1)                  | MySQL 8                      |
|--------------------|------------------------------|------------------------------|
| 現在日時           | datetime('now')              | NOW(), CURRENT_TIMESTAMP     |
| 日付のみ           | date('now')                  | CURDATE()                    |
| 日付計算           | date('now', '+7 days')       | DATE_ADD(NOW(), INTERVAL 7 DAY)|

**修正例:**
```sql
-- SQLite
WHERE created_at >= date('now', '-30 days')

-- MySQL 8
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
```

### 文字列連結

```sql
-- SQLite
SELECT name || ' - ' || location FROM events;

-- MySQL 8
SELECT CONCAT(name, ' - ', location) FROM events;
```

### LIKE検索の大文字小文字

- **SQLite**: デフォルトで区別しない
- **MySQL**: utf8mb4_unicode_ci なら区別しない（推奨設定）

---

## 3. トランザクション・ロック

### 主な違い

**SQLite (D1):**
- ファイルベースロック
- 書き込みは1つずつ（シリアル）

**MySQL 8:**
- InnoDB: 行レベルロック
- 複数の同時書き込み可能
- **デッドロックの可能性あり**

### デッドロック対策（重要）

```javascript
async function executeWithRetry(query, params, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await pool.execute(query, params);
    } catch (error) {
      if (error.code === 'ER_LOCK_DEADLOCK' && i < maxRetries - 1) {
        // 指数バックオフでリトライ
        await new Promise(resolve => 
          setTimeout(resolve, 100 * Math.pow(2, i))
        );
        continue;
      }
      throw error;
    }
  }
}
```

---

## 4. パフォーマンス最適化

### インデックス戦略（超重要）

```sql
-- 単一カラムインデックス
CREATE INDEX idx_events_name ON events(name);
CREATE INDEX idx_events_branch_code ON events(branch_code);

-- 複合インデックス（よく一緒に検索する場合）
CREATE INDEX idx_events_branch_enable 
  ON events(branch_code, enable_flg);
```

### EXPLAINでクエリ分析

```sql
EXPLAIN SELECT * FROM events 
WHERE branch_code = '01' AND enable_flg = 1
ORDER BY event_start_date DESC
LIMIT 20;
```

---

## 5. 文字エンコーディング

### 必須設定: utf8mb4

```sql
-- データベース作成時
CREATE DATABASE keio_event 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 全テーブルに適用
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**理由:**
- ✅ `utf8mb4`: 絵文字対応
- ❌ `utf8`: 絵文字非対応（非推奨）

---

## 6. JSON型の活用

### JSON型への変換

**SQLite (現在):**
```sql
convenience_stores TEXT  -- JSON文字列
```

**MySQL 8 (推奨):**
```sql
convenience_stores JSON COMMENT 'コンビニ設定'
```

### JSON操作

```sql
-- JSON値の取得
SELECT JSON_EXTRACT(form_field_settings, '$.name_kanji') 
FROM events;

-- JSON配列の検索
SELECT * FROM events
WHERE JSON_CONTAINS(convenience_stores, '"711"');
```

---

## 7. 接続・デプロイ方法

### ⚠️ Cloudflare Pagesの制約

**重要: Cloudflare WorkersからMySQL直接接続は不可！**

### 解決策1: 別サーバーにAPIサーバー構築（推奨）

```
[Cloudflare Pages] ─→ [Node.js API Server] ─→ [MySQL 8]
 (静的ファイル)        (Express/Hono)          (データベース)
```

**構成例:**
- フロントエンド: Cloudflare Pages
- バックエンド: Render/Railway/VPS (Node.js + Express)
- データベース: MySQL 8

### 解決策2: PlanetScale使用

```
[Cloudflare Pages] ─→ [PlanetScale HTTP API] ─→ [MySQL互換DB]
```

PlanetScaleはHTTP APIを提供しているため、Workers/Pagesから接続可能。

### 解決策3: D1継続利用

開発・本番の両方でD1を使い続ける（最もシンプル）。

---

## 8. 移行手順

### Step 1: スキーマ変換

```bash
# 現在のスキーマをエクスポート
npx wrangler d1 execute webapp-production --local \
  --command=".schema" > schema_sqlite.sql

# 手動でMySQL形式に変換
# - INTEGER → BIGINT UNSIGNED
# - TEXT → VARCHAR(n) or TEXT
# - datetime('now') → CURRENT_TIMESTAMP
# - ENGINE, CHARSET追加
```

### Step 2: データエクスポート

```bash
npx wrangler d1 execute webapp-production --local \
  --command=".dump" > data_sqlite.sql
```

### Step 3: MySQL環境構築

```bash
# Dockerを使う場合
docker run -d \
  --name mysql8 \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=keio_event \
  -p 3306:3306 \
  mysql:8.0 \
  --character-set-server=utf8mb4 \
  --collation-server=utf8mb4_unicode_ci
```

### Step 4: スキーマ作成

```sql
CREATE DATABASE keio_event 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE keio_event;
SOURCE mysql_schema.sql;
```

### Step 5: アプリケーションコード修正

```javascript
// D1版（Cloudflare）
const result = await env.DB.prepare(
  'SELECT * FROM events WHERE id = ?'
).bind(id).first();

// MySQL版（Node.js + mysql2）
import mysql from 'mysql2/promise';

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  charset: 'utf8mb4',
  connectionLimit: 10
});

const [rows] = await pool.execute(
  'SELECT * FROM events WHERE id = ?',
  [id]
);
const result = rows[0];
```

---

## 9. 推奨アーキテクチャ

### 本番環境構成

```
┌─────────────────────┐
│ Cloudflare Pages    │  静的ファイル配信
│ (HTML/CSS/JS)       │
└──────────┬──────────┘
           │ HTTPS
           ↓
┌─────────────────────┐
│ API Server          │  Node.js + Express/Hono
│ (Render/Railway)    │  PORT: 3001
└──────────┬──────────┘
           │ TCP
           ↓
┌─────────────────────┐
│ MySQL 8 Database    │  データベース
│ (同じVPS or 別サーバー)│  PORT: 3306
└─────────────────────┘
```

---

## 10. チェックリスト

移行前の確認:

- [ ] **アーキテクチャの決定** (APIサーバー構成 or PlanetScale or D1継続)
- [ ] スキーマ変換完了（全テーブル）
- [ ] インデックス設計完了
- [ ] 文字エンコーディング設定（utf8mb4）
- [ ] JSON型への変換
- [ ] 日付関数の書き換え
- [ ] デッドロック対策実装
- [ ] 接続プール設定
- [ ] データ整合性確認

---

## 11. まとめ

### 最重要ポイント

1. **Cloudflare PagesからMySQL直接接続は不可**
   - 別途APIサーバーが必要
   - または PlanetScale使用
   - またはD1継続利用

2. **データ型は適切にマッピング**
   - INTEGER → BIGINT UNSIGNED
   - TEXT → VARCHAR/TEXT
   - JSON文字列 → JSON型

3. **文字エンコーディングはutf8mb4必須**
   - 絵文字対応
   - 日本語対応

4. **インデックスは必須**
   - パフォーマンスに大きく影響
   - WHERE句で使うカラムに作成

5. **デッドロック対策を実装**
   - リトライ処理
   - トランザクション分離レベル検討

---

## 12. 参考リソース

- [MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- [mysql2 (Node.js)](https://www.npmjs.com/package/mysql2)
- [PlanetScale](https://planetscale.com/)
- [Render (APIサーバーホスティング)](https://render.com/)
