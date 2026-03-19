#!/bin/bash

# 主要テーブルのリスト
TABLES="events products options product_prices product_stocks option_prices option_stocks"

echo "=== データベーステーブル構造比較 ==="
echo ""

for table in $TABLES; do
    echo "## テーブル: $table"
    echo ""
    
    # バックアップファイルからカラムを取得
    backup_cols=$(grep -A 200 "CREATE TABLE $table " /home/user/uploaded_files/db_backup_20260213.sql 2>/dev/null | \
        grep -E "^\s+[a-z_]+" | \
        awk '{print $1}' | \
        sed 's/,$//' | \
        sort | \
        uniq | \
        grep -v "^$")
    
    # 現在のDBからカラムを取得
    current_cols=$(npx wrangler d1 execute webapp-production --local --command="PRAGMA table_info($table)" 2>&1 | \
        grep '"name":' | \
        awk -F'"' '{print $4}' | \
        sort)
    
    # カラム数を比較
    backup_count=$(echo "$backup_cols" | wc -l)
    current_count=$(echo "$current_cols" | wc -l)
    
    echo "バックアップ: $backup_count カラム"
    echo "現在のDB: $current_count カラム"
    echo ""
    
    # バックアップにあって現在のDBにないカラム
    missing=$(comm -23 <(echo "$backup_cols") <(echo "$current_cols"))
    if [ -n "$missing" ]; then
        echo "❌ バックアップにあって現在のDBにないカラム:"
        echo "$missing" | sed 's/^/  - /'
        echo ""
    fi
    
    # 現在のDBにあってバックアップにないカラム
    extra=$(comm -13 <(echo "$backup_cols") <(echo "$current_cols"))
    if [ -n "$extra" ]; then
        echo "✅ 現在のDBにあってバックアップにないカラム:"
        echo "$extra" | sed 's/^/  - /'
        echo ""
    fi
    
    # 一致している場合
    if [ -z "$missing" ] && [ -z "$extra" ]; then
        echo "✅ 完全一致"
        echo ""
    fi
    
    echo "---"
    echo ""
done
