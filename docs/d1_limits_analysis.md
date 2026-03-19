# Cloudflare D1 制限とAWS MySQL移行の必要性

## 📊 現在のD1データベース状況

### データベース情報
```
DB ID:           123349c1-bc70-4887-9647-e4ca86222564
Name:            webapp-production
Created:         2026-02-19
Tables:          40テーブル
Database Size:   565 KB （現在）
Region:          ENAM（北米東部）
24h Read:        1,268クエリ
```

## ⚠️ Cloudflare D1の制限

### 無料プラン（Free）
| 項目 | 制限値 |
|------|--------|
| **データベースサイズ** | **500 MB** |
| **行数（読み取り）** | 500万行/日 |
| **行数（書き込み）** | 10万行/日 |
| **ストレージ** | 5 GB（全DB合計） |
| **データベース数** | 10個 |

### 有料プラン（Workers Paid: $5/月）
| 項目 | 制限値 |
|------|--------|
| **データベースサイズ** | **500 MB** ⚠️ 同じ |
| **行数（読み取り）** | 2,500万行/日 |
| **行数（書き込み）** | 5,000万行/日 |
| **ストレージ** | 50 GB（全DB合計） |
| **データベース数** | 50,000個 |

### 🚨 重大な制限
```
❌ 単一データベースサイズ: 最大 500 MB
   ↑ 有料プランでも変わらない！
```

## 📈 予想されるデータ成長

### テーブル別データ量予測（仮定）

| テーブル | 1レコードサイズ | 想定レコード数 | 合計サイズ |
|---------|----------------|---------------|-----------|
| **events** | 2 KB | 10,000 | 20 MB |
| **products** | 1.5 KB | 50,000 | 75 MB |
| **bookings** | 1 KB | 100,000 | 100 MB |
| **booking_items** | 500 B | 300,000 | 150 MB |
| **booking_payments** | 800 B | 150,000 | 120 MB |
| **members** | 1 KB | 50,000 | 50 MB |
| **accounts** | 800 B | 1,000 | 800 KB |
| **その他37テーブル** | - | - | 50 MB |
| **合計** | - | - | **565 MB** |

### 🔴 問題点
```
予想合計: 565 MB > D1制限: 500 MB
→ D1では収まらない！
```

## 🎯 大規模データに適したデータベース選択

### オプション1: AWS RDS MySQL（推奨）✅

#### 特徴
```
✅ データサイズ: 最大 64 TB
✅ 自動バックアップ
✅ 読み取りレプリカ対応
✅ 高可用性（Multi-AZ）
✅ 成熟した運用ツール
```

#### 構成
```
┌─────────────────────────────────────┐
│  Cloudflare Pages/Workers           │
│  (フロントエンド・API)              │
└─────────────────────────────────────┘
              ↓ HTTPS
┌─────────────────────────────────────┐
│  AWS API Gateway + Lambda           │
│  (データベースアクセスAPI)          │
└─────────────────────────────────────┘
              ↓ VPC Private
┌─────────────────────────────────────┐
│  AWS RDS MySQL                      │
│  - db.t3.small (2GB RAM)            │
│  - 100GB ストレージ                 │
│  - Multi-AZ（高可用性）             │
└─────────────────────────────────────┘
```

#### コスト
```
RDS MySQL (db.t3.small):   $30-40/月
ストレージ (100GB):         $10/月
Lambda + API Gateway:       $5-10/月
─────────────────────────────────────
合計:                       $45-60/月
```

### オプション2: PlanetScale（簡単）⭐

#### 特徴
```
✅ MySQL互換
✅ HTTP API（Cloudflare Workers対応）
✅ 自動スケーリング
✅ ブランチング機能（開発環境）
✅ オンラインスキーマ変更
```

#### プラン
| プラン | ストレージ | 行読取/月 | 行書込/月 | 料金 |
|--------|-----------|-----------|-----------|------|
| **Scaler** | 10 GB | 10億 | 1,000万 | **$29/月** |
| **Scaler Pro** | 100 GB | 100億 | 5,000万 | **$39/月** |
| **Enterprise** | カスタム | 無制限 | 無制限 | カスタム |

#### コード例
```typescript
// PlanetScaleのHTTP API使用
import { Client } from '@planetscale/database'

const client = new Client({
  host: c.env.PLANETSCALE_HOST,
  username: c.env.PLANETSCALE_USERNAME,
  password: c.env.PLANETSCALE_PASSWORD,
  fetch: (url, init) => {
    return fetch(url, {
      ...init,
      cache: undefined
    })
  }
})

// クエリ実行（既存コードとほぼ同じ構文）
const result = await client.execute(
  'SELECT * FROM events WHERE id = ?',
  [eventId]
)
```

### オプション3: Supabase PostgreSQL

#### 特徴
```
✅ PostgreSQL（より高機能）
✅ REST API自動生成
✅ リアルタイム同期
✅ 認証機能内蔵
✅ ファイルストレージ内蔵
```

#### プラン
| プラン | ストレージ | 転送量/月 | 料金 |
|--------|-----------|-----------|------|
| **Pro** | 8 GB | 50 GB | **$25/月** |
| **Team** | 100 GB | 250 GB | **$599/月** |

### オプション4: Neon PostgreSQL（サーバーレス）

#### 特徴
```
✅ PostgreSQL
✅ サーバーレス（自動スケール）
✅ ブランチング機能
✅ HTTP API
✅ 秒単位の課金
```

#### プラン
| プラン | ストレージ | コンピュート | 料金 |
|--------|-----------|-------------|------|
| **Launch** | 10 GB | 300時間/月 | **$19/月** |
| **Scale** | 50 GB | 750時間/月 | **$69/月** |

## 🔍 詳細比較

### A. パフォーマンス

| データベース | レイテンシー | スループット | 制限 |
|-------------|-------------|-------------|------|
| **D1 (現在)** | 1-5ms | 中 | 500MB |
| **PlanetScale** | 30-80ms | 高 | 10GB-100GB |
| **AWS RDS** | 50-200ms | 最高 | 64TB |
| **Supabase** | 40-100ms | 高 | 8GB-100GB |
| **Neon** | 40-120ms | 中-高 | 10GB-50GB |

### B. 移行の難易度

| データベース | 移行難易度 | コード変更量 | 開発期間 |
|-------------|-----------|-------------|---------|
| **PlanetScale** | ⭐⭐ 低 | 小（404箇所置換） | 1-2週間 |
| **AWS RDS** | ⭐⭐⭐ 中 | 大（404箇所+Lambda開発） | 3-4週間 |
| **Supabase** | ⭐⭐⭐ 中 | 中（404箇所+REST API化） | 2-3週間 |
| **Neon** | ⭐⭐ 低 | 小（404箇所置換） | 1-2週間 |

### C. 運用コスト（データ量500MB-10GB想定）

| データベース | 初期費用 | 月額 | スケール時 |
|-------------|---------|------|-----------|
| **PlanetScale** | $0 | $29-39 | 自動 |
| **AWS RDS** | $0 | $45-60 | 手動設定 |
| **Supabase** | $0 | $25-599 | 自動 |
| **Neon** | $0 | $19-69 | 自動 |

## 🎯 推奨ソリューション

### 🥇 第1推奨: PlanetScale

#### 理由
```
✅ MySQL互換（既存SQL流用可能）
✅ HTTP API（Cloudflare Workers完全対応）
✅ 移行コスト最小（1-2週間）
✅ 自動スケーリング
✅ コスパ良好（$29/月で10GB）
✅ オンラインスキーマ変更
```

#### 実装例
```typescript
// 1. PlanetScale SDKインストール
npm install @planetscale/database

// 2. 既存コード修正（最小限）
// Before (D1)
const event = await DB.prepare('SELECT * FROM events WHERE id = ?')
  .bind(eventId)
  .first()

// After (PlanetScale)
const result = await ps.execute('SELECT * FROM events WHERE id = ?', [eventId])
const event = result.rows[0]
```

### 🥈 第2推奨: Neon PostgreSQL

#### 理由
```
✅ サーバーレス（使った分だけ課金）
✅ HTTP API対応
✅ PostgreSQL（より高機能）
✅ ブランチング（開発環境簡単）
✅ 低コスト（$19/月から）
```

#### デメリット
```
❌ PostgreSQL方言への変換必要
   （SQLiteとの互換性がMySQLより低い）
```

### 🥉 第3推奨: AWS RDS MySQL

#### 理由
```
✅ 最大スケール（64TB）
✅ エンタープライズ対応
✅ 既存AWSインフラ統合
✅ 完全な制御
```

#### デメリット
```
❌ 移行コスト高（3-4週間）
❌ Lambda開発必要
❌ 運用コスト高（$45-60/月）
❌ レイテンシー大（50-200ms）
```

## 📋 移行チェックリスト

### フェーズ1: 事前準備（1週間）
- [ ] 現在のデータ量精査
- [ ] データ成長予測
- [ ] データベース選定
- [ ] 予算承認
- [ ] 移行計画作成

### フェーズ2: 環境構築（1週間）
- [ ] PlanetScale/Neon/AWSアカウント作成
- [ ] データベース作成
- [ ] マイグレーション実行（SQLite→MySQL変換）
- [ ] 初期データインポート
- [ ] 接続テスト

### フェーズ3: コード移行（1-2週間）
- [ ] データベースアクセス層抽象化
- [ ] 404箇所のDB呼び出し修正
- [ ] 型定義更新
- [ ] ユニットテスト実施
- [ ] 統合テスト実施

### フェーズ4: 並行運用（1週間）
- [ ] 両DB並行書き込み
- [ ] データ整合性確認
- [ ] パフォーマンステスト
- [ ] ロールバック手順確認

### フェーズ5: 本番切替（1日）
- [ ] メンテナンス通知
- [ ] 最終データ同期
- [ ] 環境変数切替
- [ ] 動作確認
- [ ] 監視設定

### フェーズ6: 事後対応（1週間）
- [ ] パフォーマンス監視
- [ ] エラー監視
- [ ] D1データバックアップ
- [ ] D1削除（1ヶ月後）

## 💡 即座のアクション

### ステップ1: データ量確認
```bash
# ローカルD1のテーブル一覧とサイズ取得
cd /home/user/webapp
npx wrangler d1 execute webapp-production --local \
  --command="SELECT name, SUM(pgsize) as size FROM dbstat GROUP BY name ORDER BY size DESC"

# 本番D1のテーブル一覧とサイズ取得
npx wrangler d1 execute webapp-production \
  --command="SELECT name FROM sqlite_master WHERE type='table'"
```

### ステップ2: PlanetScale評価（推奨）
```bash
# 1. PlanetScaleアカウント作成
# https://planetscale.com/

# 2. データベース作成
pscale database create webapp-production --region us-east

# 3. 接続情報取得
pscale connect webapp-production main

# 4. マイグレーション実行
pscale database dump webapp-production main > dump.sql
```

### ステップ3: コスト試算
```
現在のコスト:
- Cloudflare D1: $0
- Cloudflare Pages: $0
- Cloudflare R2: $0
合計: $0/月

移行後のコスト（PlanetScale）:
- PlanetScale Scaler: $29/月
- Cloudflare Pages: $0
- Cloudflare R2: $0
合計: $29/月

増加コスト: +$29/月
```

## 🚨 緊急度評価

### 現在のリスク
```
現在のDB使用量: 565 KB
D1制限: 500 MB

使用率: 0.11%  ← まだ余裕あり

ただし、予測データ量: 565 MB
→ すでに制限超過の見込み
```

### タイムライン
```
✅ 今すぐ: PlanetScale評価開始
⚠️ 1ヶ月以内: 移行計画確定
🚨 3ヶ月以内: 本番移行完了

理由: データが500MBを超えると
      D1への書き込みがエラーになる
```

---

**次のステップ**: PlanetScaleの評価を開始しますか？
