# 完全なAPI一覧

## オプション管理API (Options Management)

### 基本CRUD操作
| メソッド | エンドポイント | 説明 | 実装状況 |
|---------|--------------|------|---------|
| GET | `/api/options` | オプション一覧取得（検索対応） | ✅ 完了 |
| GET | `/api/options/:id` | オプション詳細取得 | ✅ 完了 |
| POST | `/api/options` | オプション作成 | ✅ 完了 |
| PUT | `/api/options/:id` | オプション更新（部分更新対応） | ✅ 完了 |
| DELETE | `/api/options/:id` | オプション削除（論理削除） | ✅ 完了 |
| POST | `/api/options/:id/copy` | オプションコピー | ✅ 完了 |

### 共有在庫関連
| メソッド | エンドポイント | 説明 | 実装状況 |
|---------|--------------|------|---------|
| GET | `/api/options/:id/shared-stocks` | 共有在庫紐付け一覧取得 | ✅ 完了 |
| POST | `/api/options/:id/shared-stocks` | 共有在庫紐付け（単一） | ✅ 完了 |
| POST | `/api/options/:id/shared-stocks/batch` | 共有在庫紐付け（一括） | ✅ 完了 |
| DELETE | `/api/options/:optionId/shared-stocks/:id` | 共有在庫紐付け削除 | ✅ 完了 |

### 在庫管理
| メソッド | エンドポイント | 説明 | 実装状況 |
|---------|--------------|------|---------|
| POST | `/api/options/:id/stocks` | オプション在庫追加 | ✅ 完了 |
| DELETE | `/api/options/:id/stocks/:stockId` | オプション在庫削除 | ✅ 完了 |

---

## 共有在庫プールAPI (Shared Stock Pools)

### 基本CRUD操作
| メソッド | エンドポイント | 説明 | 実装状況 |
|---------|--------------|------|---------|
| GET | `/api/shared-stock-pools` | 共有在庫プール一覧取得 | ✅ 完了 |
| GET | `/api/shared-stock-pools/summary` | 共有在庫プール集計一覧取得 | ✅ 完了 |
| GET | `/api/shared-stock-pools/by-name` | 名前・コードで在庫検索 | ✅ 完了 |
| GET | `/api/shared-stock-pools/:id` | 共有在庫プール詳細取得 | ✅ 完了 |
| POST | `/api/shared-stock-pools` | 共有在庫プール作成（単一） | ✅ 完了 |
| POST | `/api/shared-stock-pools/batch` | 共有在庫プール作成（一括） | ✅ 完了 |
| PUT | `/api/shared-stock-pools/:id` | 共有在庫プール更新（部分更新） | ✅ 完了 |
| DELETE | `/api/shared-stock-pools/:id` | 共有在庫プール削除（論理削除） | ✅ 完了 |

---

## 商品管理API (Products Management)

### 基本CRUD操作
| メソッド | エンドポイント | 説明 | 実装状況 |
|---------|--------------|------|---------|
| GET | `/api/products` | 商品一覧取得 | ✅ 完了 |
| GET | `/api/products/:id` | 商品詳細取得 | ✅ 完了 |
| POST | `/api/products` | 商品作成 | ✅ 完了 |
| POST | `/api/products/:id/copy` | 商品コピー | ✅ 完了 |
| DELETE | `/api/products/:id` | 商品削除（論理削除） | ✅ 完了 |

### 共有在庫関連
| メソッド | エンドポイント | 説明 | 実装状況 |
|---------|--------------|------|---------|
| POST | `/api/products/:id/shared-stocks` | 共有在庫紐付け（単一） | ✅ 完了 |
| POST | `/api/products/:id/shared-stocks/batch` | 共有在庫紐付け（一括） | ✅ 完了 |
| DELETE | `/api/products/:productId/shared-stocks/:id` | 共有在庫紐付け削除 | ✅ 完了 |

---

## フロントエンドのAPI化状況

### 完全にAPI化された画面
✅ **オプション管理画面** (`/admin/options`)
- SSR → API + JavaScript に完全移行
- 検索機能: API経由でフィルタリング
- 削除・コピー: ページリロード不要
- リアルタイムデータ更新

### 部分的にAPI化された画面
⚠️ **共有在庫プール管理画面** (`/admin/shared-stock-pools`)
- サマリーAPI: `GET /api/shared-stock-pools/summary` 実装済み
- 日別在庫API: `GET /api/shared-stock-pools/by-name` 実装済み
- フロントエンド: SSRとAPIのハイブリッド状態
- 今後の対応: 完全API化を推奨

### SSRのまま（API化未着手）
❌ 以下の画面はまだSSRのままです：
- 商品管理画面 (`/admin/products`)
- 予約管理画面 (`/admin/bookings`)
- イベント管理画面 (`/admin/events`)
- その他管理画面

---

## データベーステーブル構造

### options（オプションマスタ）
- `id`, `event_id`, `name`, `description`, `remarks`
- `option_category_id`, `enable_flg`
- `created_at`, `modified_at`, `deleted_at`（論理削除）

### option_prices（オプション価格）
- `id`, `option_id`, `price`, `category_name`
- `created_at`, `modified_at`

### option_shared_stocks（オプション共有在庫紐付け）
- `id`, `option_id`, `shared_stock_pool_id`
- `stock_name`, `consume_quantity`, `priority`, `enable_flg`
- `created_at`, `modified_at`

### shared_stock_pools（共有在庫プール）
- `id`, `pool_name`, `pool_code`, `description`
- `date`, `time_slot_start`, `time_slot_end`, `time_slot_label`
- `total_stock`, `booked`, `enable_flg`
- `created_at`, `modified_at`

---

## APIテストコマンド

### オプション管理
```bash
# 一覧取得
curl -s http://localhost:3000/api/options | jq '.'

# 詳細取得
curl -s http://localhost:3000/api/options/1 | jq '.'

# 更新
curl -s -X PUT http://localhost:3000/api/options/1 \
  -H "Content-Type: application/json" \
  -d '{"description": "更新された説明"}' | jq '.'

# 削除
curl -s -X DELETE http://localhost:3000/api/options/1 | jq '.'

# 検索（販売中のみ）
curl -s "http://localhost:3000/api/options?status=1" | jq '.'
```

### 共有在庫プール管理
```bash
# 集計一覧
curl -s http://localhost:3000/api/shared-stock-pools/summary | jq '.'

# 名前・コードで検索
curl -s "http://localhost:3000/api/shared-stock-pools/by-name?pool_name=新しいバス&pool_code=BUS002" | jq '.'

# 詳細取得
curl -s http://localhost:3000/api/shared-stock-pools/1 | jq '.'

# 更新
curl -s -X PUT http://localhost:3000/api/shared-stock-pools/1 \
  -H "Content-Type: application/json" \
  -d '{"total_stock": 100}' | jq '.'
```

---

## 今後の開発推奨事項

### 優先度: 高
1. **商品管理画面のAPI化** - オプション管理と同様の方式で実装
2. **予約管理画面のAPI化** - 予約データのリアルタイム更新
3. **共有在庫プール管理画面の完全API化** - 現在はハイブリッド状態

### 優先度: 中
4. **イベント管理画面のAPI化**
5. **全APIのエラーハンドリング統一**
6. **APIレスポンスのページネーション実装**

### 優先度: 低
7. **API認証・認可の実装**
8. **APIドキュメントの自動生成（Swagger/OpenAPI）**

---

## GitHubリポジトリ
https://github.com/maikeura/keiokanko_event

## 最終更新
- コミット: `8c5a07c`
- 日付: 2025-12-24
- 主な変更:
  - オプション管理のInternal Server Error解消
  - PUT /api/options/:id 追加（部分更新対応）
  - 管理画面のSSR → API + JavaScript完全移行
  - API仕様書（API_OPTIONS.md）追加
