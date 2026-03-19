# GMO リンクタイプ Plus 設定ガイド

## ⚠️ 重要な注意事項

### 1. 設定変更後は必ず新しいURLを生成すること
**管理画面で設定を変更した後は、必ず新しい決済URLを生成してテストしてください。**

- ❌ **間違い**: 設定変更前に生成した古いURLでテスト
- ✅ **正しい**: 設定変更後に新しく予約を作成し、新しいURLでテスト

**なぜ？**
- GMOの設定は、APIで決済URL生成時にその時点の設定が反映される
- 既に生成済みのURLには、後から変更した設定は反映されない

**対処方法:**
1. GMO管理画面で設定を保存
2. 自サイトで新しい予約を作成（新しいOrderIDで決済URL生成）
3. 新しく生成された決済URLで動作確認

---

### 2. 設定IDを必ず確認すること

**GMO管理画面の「設定ID」とAPIの「configid」が完全一致していることを確認してください。**

#### 現在の設定:
- **設定ID**: `keokanko7211`
- **環境変数**: `GMO_CONFIG_ID=keokanko7211`

#### 確認方法:

**GMO管理画面側:**
1. https://p01.mul-pay.jp/ にログイン
2. 左メニュー「リンクタイプ Plus」→「設定」
3. 設定一覧で「設定ID」列を確認
4. URLなどを設定した設定の「設定ID」をメモ

**API側（開発者ツールConsoleで確認）:**
1. https://webapp-geh.pages.dev/ で予約フローを実行
2. 開発者ツール → Console タブを開く
3. `🔧 [GMO] 環境変数確認:` のログで `configId:` の値を確認
4. GMO管理画面の設定IDと完全一致しているか確認

---

## 📋 GMO管理画面の設定手順

### 1. ログイン
- URL: https://p01.mul-pay.jp/
- ショップID: `tshop00075926`

### 2. 設定画面へ移動
1. 左メニュー「リンクタイプ Plus」をクリック
2. 「設定」をクリック
3. 設定ID「**keokanko7211**」を選択

### 3. 必須設定項目

| 項目 | 設定値 | 説明 |
|------|--------|------|
| **設定ID** | `keokanko7211` | ⚠️ APIと完全一致必須 |
| **完了時戻り先URL** | `https://webapp-geh.pages.dev/payment-callback?status=success` | 決済成功時のリダイレクト先 |
| **キャンセル時戻り先URL** | `https://webapp-geh.pages.dev/payment-callback?status=cancel` | キャンセル時のリダイレクト先 |
| **結果画面スキップフラグ** | `1` | 1=スキップする、0=表示する |
| **確認画面スキップフラグ** | `1` | 1=スキップする、0=表示する |
| **取引詳細初期表示フラグ** | `0` または `1` | お好みで設定 |

### 4. 保存
- 必ず「**保存**」ボタンをクリック
- 保存後、新しい予約で動作確認

---

## 🧪 テスト手順

### ステップ1: GMO管理画面で設定を保存
1. 上記の設定を入力
2. 「保存」ボタンをクリック
3. 保存完了メッセージを確認

### ステップ2: 新しい予約を作成
1. https://webapp-geh.pages.dev/ にアクセス
2. イベントを選択
3. 参加者情報を入力
4. 決済方法選択（クレジットカード または コンビニ）
5. 「予約を確定」ボタンをクリック

### ステップ3: 開発者ツールで確認
1. ブラウザの開発者ツール → Console タブを開く
2. 以下のログを確認:
   ```
   🔧 [GMO] 環境変数確認: {
     shopId: "tshop00075926",
     configId: "keokanko7211",  ← これが管理画面の設定IDと一致しているか確認
     apiUrl: "https://pt01.mul-pay.jp"
   }
   ```
3. `📤 [GMO] リクエスト送信:` でリクエストボディを確認
4. `✅ [GMO] 決済URL取得成功:` で新しいLinkUrlを確認

### ステップ4: GMO決済画面でテスト
1. GMO決済画面に自動遷移する
2. テストカード情報を入力（GMOから提供された情報）
3. 決済を完了
4. **自動的に** `https://webapp-geh.pages.dev/payment-callback?status=success` にリダイレクトされることを確認

### ステップ5: キャンセルのテスト
1. 新しい予約を作成
2. GMO決済画面で「キャンセル」をクリック
3. **自動的に** `https://webapp-geh.pages.dev/payment-callback?status=cancel` にリダイレクトされることを確認

---

## 🔧 トラブルシューティング

### Q1: 設定が反映されない
**A1:** 以下を確認してください:
1. GMO管理画面で「保存」ボタンをクリックしたか
2. 設定変更**後**に新しい予約を作成したか（古いURLは使わない）
3. 設定IDが完全一致しているか（Console で確認）

### Q2: リダイレクトされない
**A2:** 以下を確認してください:
1. GMO管理画面の「完了時戻り先URL」が正しく設定されているか
2. APIリクエストに `RetUrl`, `CompleteUrl`, `CancelUrl` などを送信していないか
   - 現在のコードでは送信していません ✅
3. 新しい予約で生成された新しいURLでテストしているか

### Q3: 設定IDがわからない
**A3:** 
1. GMO管理画面 → 「リンクタイプ Plus」→「設定」
2. 設定一覧の「設定ID」列を確認
3. 該当する設定の設定IDをメモ

---

## 📝 環境変数の設定

### Cloudflare Pages での設定方法:

```bash
# 設定ID（最も重要！）
npx wrangler pages secret put GMO_CONFIG_ID --project-name webapp
# 入力: keokanko7211

# ショップID
npx wrangler pages secret put GMO_SHOP_ID --project-name webapp
# 入力: tshop00075926

# ショップパスワード
npx wrangler pages secret put GMO_SHOP_PASS --project-name webapp
# 入力: （GMOから提供されたパスワード）

# APIエンドポイント（テスト環境）
npx wrangler pages secret put GMO_API_URL --project-name webapp
# 入力: https://pt01.mul-pay.jp
```

### 設定確認:
```bash
npx wrangler pages secret list --project-name webapp
```

---

## 📞 サポート

問題が解決しない場合は、以下の情報を共有してください:

1. GMO管理画面の設定スクリーンショット（設定ID「keokanko7211」の画面）
2. ブラウザの開発者ツール Console の全ログ
3. 実際にリダイレクトされたURL（成功時/キャンセル時）
4. エラーメッセージ（あれば）
