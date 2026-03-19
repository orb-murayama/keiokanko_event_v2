#!/bin/bash

# 1. バックアップファイルを実行
echo "Restoring database from backup..."
npx wrangler d1 execute webapp-production --local --file=/home/user/uploaded_files/db_backup_20260213.sql

# 2. optionsテーブルにimage_url列を追加
echo "Adding image_url column to options table..."
npx wrangler d1 execute webapp-production --local --command="ALTER TABLE options ADD COLUMN image_url TEXT;"

echo "Database restoration complete!"
