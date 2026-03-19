#!/bin/bash

echo "# データベーステーブル構造一覧"
echo ""
echo "## 主要テーブルのカラム比較"
echo ""

# 関数: テーブルのカラムを表示
show_table_columns() {
    table=$1
    echo "### $table テーブル"
    echo ""
    
    # 現在のDBからカラムを取得
    npx wrangler d1 execute webapp-production --local --command="PRAGMA table_info($table)" 2>&1 | \
        grep -E '"cid"|"name"|"type"' | \
        paste - - - | \
        awk -F'"' '{printf "| %2s | %-40s | %-15s |\n", $4, $8, $12}' | \
        sed '1i| ID | カラム名 | データ型 |\n|----|-----------------------------------------|-----------------|'
    
    echo ""
    
    # カラム数をカウント
    count=$(npx wrangler d1 execute webapp-production --local --command="PRAGMA table_info($table)" 2>&1 | grep '"name":' | wc -l)
    echo "**合計: $count カラム**"
    echo ""
}

# 主要テーブルのカラムを表示
show_table_columns "events"
show_table_columns "products" 
show_table_columns "options"
show_table_columns "product_prices"
show_table_columns "product_stocks"
show_table_columns "option_prices"
show_table_columns "option_stocks"
