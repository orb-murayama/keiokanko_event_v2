#!/bin/bash

echo "========================================="
echo "価格帯フォーマット修正スクリプト"
echo "========================================="
echo ""

# Cloudflare API Tokenが設定されているか確認
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo "❌ エラー: CLOUDFLARE_API_TOKEN環境変数が設定されていません"
  echo ""
  echo "以下の手順で設定してください："
  echo "1. Cloudflare Dashboard (https://dash.cloudflare.com/) にログイン"
  echo "2. My Profile → API Tokens → Create Token"
  echo "3. 以下の権限を持つトークンを作成："
  echo "   - Account | D1 | Edit"
  echo "4. トークンをコピーして以下のコマンドを実行："
  echo "   export CLOUDFLARE_API_TOKEN='your-token-here'"
  echo ""
  exit 1
fi

echo "✅ Cloudflare API Token確認完了"
echo ""

# 本番環境に適用するか確認
echo "⚠️  本番環境（webapp-production）のデータベースを修正します"
read -p "続行しますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "❌ キャンセルしました"
  exit 0
fi

echo ""
echo "📝 SQLスクリプトを実行中..."
echo ""

npx wrangler d1 execute webapp-production --remote --file=migrations/fix_price_band_format.sql

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ 修正が完了しました！"
  echo ""
  echo "以下のURLで確認してください："
  echo "https://webapp-geh.pages.dev/products-edit?id=8&event_id=4"
  echo ""
else
  echo ""
  echo "❌ エラーが発生しました"
  echo "詳細は PRICE_BAND_FIX.md を参照してください"
  echo ""
  exit 1
fi
