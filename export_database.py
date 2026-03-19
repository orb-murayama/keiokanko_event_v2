#!/usr/bin/env python3
import sqlite3
import os
from datetime import datetime

# データベースファイルのパスを検索
db_path = None
for root, dirs, files in os.walk('.wrangler/state/v3/d1'):
    for file in files:
        if file.endswith('.sqlite'):
            db_path = os.path.join(root, file)
            break
    if db_path:
        break

if not db_path:
    print("エラー: データベースファイルが見つかりません")
    exit(1)

print(f"データベース: {db_path}")

# 接続
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# 出力ファイル名
today = datetime.now().strftime('%Y%m%d')
schema_file = f'db_schema_{today}.sql'
data_file = f'db_data_{today}.sql'
full_file = f'db_full_backup_{today}.sql'

print(f"エクスポート開始...")

# 1. スキーマをエクスポート
with open(schema_file, 'w', encoding='utf-8') as f:
    f.write("-- Database Schema Export\n")
    f.write(f"-- Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    f.write("-- ========================================\n\n")
    
    # 全テーブルのCREATE文を取得
    cursor.execute("SELECT sql FROM sqlite_master WHERE type='table' AND sql IS NOT NULL ORDER BY name")
    for row in cursor.fetchall():
        f.write(row[0] + ";\n\n")

print(f"✓ スキーマをエクスポート: {schema_file}")

# 2. データをエクスポート
with open(data_file, 'w', encoding='utf-8') as f:
    f.write("-- Database Data Export\n")
    f.write(f"-- Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    f.write("-- ========================================\n\n")
    f.write("PRAGMA foreign_keys=OFF;\n")
    f.write("BEGIN TRANSACTION;\n\n")
    
    # 全テーブル名を取得
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name")
    tables = [row[0] for row in cursor.fetchall()]
    
    for table in tables:
        # テーブルのデータを取得
        cursor.execute(f"SELECT COUNT(*) FROM {table}")
        count = cursor.fetchone()[0]
        
        if count > 0:
            f.write(f"-- Table: {table} ({count} rows)\n")
            
            # カラム情報を取得
            cursor.execute(f"PRAGMA table_info({table})")
            columns = [col[1] for col in cursor.fetchall()]
            
            # データを取得
            cursor.execute(f"SELECT * FROM {table}")
            rows = cursor.fetchall()
            
            for row in rows:
                # 値をエスケープ
                values = []
                for val in row:
                    if val is None:
                        values.append("NULL")
                    elif isinstance(val, str):
                        # シングルクォートをエスケープ
                        escaped = val.replace("'", "''")
                        values.append(f"'{escaped}'")
                    else:
                        values.append(str(val))
                
                insert_sql = f"INSERT INTO {table} ({','.join(columns)}) VALUES ({','.join(values)});\n"
                f.write(insert_sql)
            
            f.write("\n")
        else:
            f.write(f"-- Table: {table} (0 rows)\n\n")
    
    f.write("COMMIT;\n")
    f.write("PRAGMA foreign_keys=ON;\n")

print(f"✓ データをエクスポート: {data_file}")

# 3. 完全バックアップ（スキーマ+データ）
with open(full_file, 'w', encoding='utf-8') as f:
    f.write("-- Full Database Backup\n")
    f.write(f"-- Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    f.write("-- ========================================\n\n")
    f.write("PRAGMA foreign_keys=OFF;\n")
    f.write("BEGIN TRANSACTION;\n\n")
    
    # スキーマ
    f.write("-- ========================================\n")
    f.write("-- SCHEMA\n")
    f.write("-- ========================================\n\n")
    
    cursor.execute("SELECT sql FROM sqlite_master WHERE type='table' AND sql IS NOT NULL ORDER BY name")
    for row in cursor.fetchall():
        f.write(row[0] + ";\n\n")
    
    # データ
    f.write("-- ========================================\n")
    f.write("-- DATA\n")
    f.write("-- ========================================\n\n")
    
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name")
    tables = [row[0] for row in cursor.fetchall()]
    
    total_rows = 0
    for table in tables:
        cursor.execute(f"SELECT COUNT(*) FROM {table}")
        count = cursor.fetchone()[0]
        total_rows += count
        
        if count > 0:
            f.write(f"-- Table: {table} ({count} rows)\n")
            
            cursor.execute(f"PRAGMA table_info({table})")
            columns = [col[1] for col in cursor.fetchall()]
            
            cursor.execute(f"SELECT * FROM {table}")
            rows = cursor.fetchall()
            
            for row in rows:
                values = []
                for val in row:
                    if val is None:
                        values.append("NULL")
                    elif isinstance(val, str):
                        escaped = val.replace("'", "''")
                        values.append(f"'{escaped}'")
                    else:
                        values.append(str(val))
                
                insert_sql = f"INSERT INTO {table} ({','.join(columns)}) VALUES ({','.join(values)});\n"
                f.write(insert_sql)
            
            f.write("\n")
    
    f.write("COMMIT;\n")
    f.write("PRAGMA foreign_keys=ON;\n")

print(f"✓ 完全バックアップ: {full_file}")

# 統計情報
cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")
table_count = len(cursor.fetchall())

conn.close()

print(f"\n=== エクスポート完了 ===")
print(f"テーブル数: {table_count}")
print(f"総レコード数: {total_rows}")
print(f"\n生成されたファイル:")
print(f"  1. {schema_file} - スキーマのみ")
print(f"  2. {data_file} - データのみ")
print(f"  3. {full_file} - 完全バックアップ")
