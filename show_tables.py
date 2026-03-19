import subprocess
import json

tables = ['events', 'products', 'options', 'product_prices', 'product_stocks', 'option_prices', 'option_stocks']

print("# データベーステーブル構造一覧\n")

for table in tables:
    cmd = f'npx wrangler d1 execute webapp-production --local --command="PRAGMA table_info({table})"'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd='/home/user/webapp')
    
    try:
        # JSONを探す
        lines = result.stdout.split('\n')
        json_started = False
        json_lines = []
        
        for line in lines:
            if line.strip().startswith('['):
                json_started = True
            if json_started:
                json_lines.append(line)
        
        data = json.loads('\n'.join(json_lines))
        columns = data[0]['results']
        
        print(f"## {table} テーブル ({len(columns)} カラム)\n")
        print("| # | カラム名 | データ型 | NULL許可 | デフォルト値 |")
        print("|---|----------|----------|----------|--------------|")
        
        for col in columns:
            null_ok = "YES" if col['notnull'] == 0 else "NO"
            default = col['dflt_value'] if col['dflt_value'] else "-"
            print(f"| {col['cid']} | {col['name']} | {col['type']} | {null_ok} | {default} |")
        
        print()
        
    except Exception as e:
        print(f"エラー: {table} テーブルの処理に失敗 - {e}\n")
