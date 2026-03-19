#!/bin/bash

# ============================================
# CDN脆弱性修正 - 実施当日スクリプト
# ============================================
# 実行日: 2026年3月10日
# 目的: CDNライブラリの脆弱性修正を安全に実施
# 所要時間: 約45分
# ============================================

set -e  # エラーが発生したら即座に停止

# 色付き出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログファイル
LOG_DIR="/home/user/webapp/logs"
mkdir -p $LOG_DIR
LOG_FILE="$LOG_DIR/security_fix_$(date +%Y%m%d_%H%M%S).log"

# ログ関数
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[ERROR $(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

warning() {
    echo -e "${YELLOW}[WARNING $(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

info() {
    echo -e "${BLUE}[INFO $(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

# ============================================
# フェーズ0: 事前確認
# ============================================
phase0_precheck() {
    log "============================================"
    log "フェーズ0: 事前確認開始"
    log "============================================"
    
    cd /home/user/webapp
    
    # 現在のディレクトリ確認
    info "現在のディレクトリ: $(pwd)"
    
    # Gitステータス確認
    info "Gitステータス確認中..."
    git status | tee -a $LOG_FILE
    
    # 未コミットの変更がある場合は警告
    if [[ -n $(git status --porcelain) ]]; then
        warning "未コミットの変更があります。先にコミットすることを推奨します。"
        read -p "続行しますか？ (y/N): " confirm
        if [[ $confirm != [yY] ]]; then
            error "処理を中断しました。"
            exit 1
        fi
    fi
    
    log "フェーズ0: 完了"
}

# ============================================
# フェーズ1: バックアップ作成
# ============================================
phase1_backup() {
    log "============================================"
    log "フェーズ1: バックアップ作成開始"
    log "============================================"
    
    BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="webapp_backup_before_cdn_fix_${BACKUP_DATE}.tar.gz"
    
    cd /home/user
    
    # プロジェクト全体のバックアップ
    info "プロジェクト全体をバックアップ中..."
    tar -czf $BACKUP_FILE webapp/ 2>&1 | tee -a $LOG_FILE
    
    # バックアップファイルサイズ確認
    BACKUP_SIZE=$(ls -lh $BACKUP_FILE | awk '{print $5}')
    log "バックアップファイル作成完了: $BACKUP_FILE (サイズ: $BACKUP_SIZE)"
    
    # AI Driveにもコピー（エラーは無視）
    info "AI Driveにバックアップをコピー中..."
    cp $BACKUP_FILE /mnt/aidrive/ 2>&1 | tee -a $LOG_FILE || warning "AI Driveへのコピーに失敗しました（続行します）"
    
    # 現在のコミットハッシュを記録
    cd /home/user/webapp
    CURRENT_COMMIT=$(git log -1 --oneline)
    echo "$CURRENT_COMMIT" > /tmp/current_commit.txt
    log "現在のコミット: $CURRENT_COMMIT"
    
    log "フェーズ1: 完了"
}

# ============================================
# フェーズ2: CDN修正スクリプト実行
# ============================================
phase2_fix_cdn() {
    log "============================================"
    log "フェーズ2: CDN修正スクリプト実行開始"
    log "============================================"
    
    cd /home/user/webapp
    
    # スクリプト実行権限確認
    if [[ ! -x scripts/fix-cdn-vulnerabilities.sh ]]; then
        info "スクリプトに実行権限を付与中..."
        chmod +x scripts/fix-cdn-vulnerabilities.sh
    fi
    
    # スクリプト実行
    info "CDN脆弱性修正スクリプトを実行中..."
    ./scripts/fix-cdn-vulnerabilities.sh 2>&1 | tee -a $LOG_FILE
    
    # 変更内容確認
    info "変更内容を確認中..."
    git diff 2>&1 | tee -a $LOG_FILE
    
    # 変更ファイル数確認
    CHANGED_FILES=$(git diff --name-only | wc -l)
    log "変更されたファイル数: $CHANGED_FILES"
    
    if [[ $CHANGED_FILES -eq 0 ]]; then
        warning "ファイルが変更されていません。スクリプトが正常に実行されなかった可能性があります。"
        read -p "続行しますか？ (y/N): " confirm
        if [[ $confirm != [yY] ]]; then
            error "処理を中断しました。"
            exit 1
        fi
    fi
    
    log "フェーズ2: 完了"
}

# ============================================
# フェーズ3: ビルドとローカルテスト
# ============================================
phase3_build_test() {
    log "============================================"
    log "フェーズ3: ビルドとローカルテスト開始"
    log "============================================"
    
    cd /home/user/webapp
    
    # ビルド
    info "プロジェクトをビルド中..."
    npm run build 2>&1 | tee -a $LOG_FILE
    BUILD_STATUS=$?
    
    if [[ $BUILD_STATUS -ne 0 ]]; then
        error "ビルドに失敗しました。ロールバックが必要です。"
        exit 1
    fi
    
    log "ビルド成功"
    
    # ポートクリーンアップ
    info "ポート3000をクリーンアップ中..."
    npm run clean-port 2>&1 | tee -a $LOG_FILE || true
    
    # PM2で起動
    info "PM2でアプリケーションを起動中..."
    pm2 start ecosystem.config.cjs 2>&1 | tee -a $LOG_FILE
    
    # 起動待機
    info "起動を待機中（10秒）..."
    sleep 10
    
    # PM2ステータス確認
    pm2 list 2>&1 | tee -a $LOG_FILE
    
    # ローカルテスト
    info "ローカル環境をテスト中..."
    
    # トップページ
    if curl -s http://localhost:3000/ > /dev/null; then
        log "✓ トップページ: OK"
    else
        error "✗ トップページ: FAILED"
        exit 1
    fi
    
    # ヘルスチェック
    if curl -s http://localhost:3000/api/health > /dev/null; then
        log "✓ ヘルスチェック: OK"
    else
        warning "✗ ヘルスチェック: FAILED"
    fi
    
    # PM2ログ確認（エラーがないか）
    info "PM2ログを確認中..."
    pm2 logs --nostream --lines 20 2>&1 | tee -a $LOG_FILE
    
    log "フェーズ3: 完了"
    
    # 手動確認を促す
    warning "============================================"
    warning "【重要】手動でブラウザテストを実施してください"
    warning "============================================"
    warning "以下のページをブラウザで確認してください："
    warning "1. http://localhost:3000/ (トップページ)"
    warning "2. http://localhost:3000/products (商品一覧)"
    warning "3. http://localhost:3000/booking (予約フォーム)"
    warning "4. http://localhost:3000/admin/login (管理画面)"
    warning ""
    warning "確認項目："
    warning "- ページが正常に表示される"
    warning "- Axiosを使用したAPI呼び出しが動作する"
    warning "- Vue.jsコンポーネントが正常に動作する"
    warning "- Font Awesomeアイコンが表示される"
    warning "- JavaScriptエラーがコンソールに表示されない"
    warning "============================================"
    
    read -p "ブラウザテストが完了し、問題がないことを確認しましたか？ (y/N): " confirm
    if [[ $confirm != [yY] ]]; then
        error "テストが完了していません。処理を中断しました。"
        exit 1
    fi
}

# ============================================
# フェーズ4: Gitコミット
# ============================================
phase4_commit() {
    log "============================================"
    log "フェーズ4: Gitコミット開始"
    log "============================================"
    
    cd /home/user/webapp
    
    # 変更をステージング
    info "変更をステージング中..."
    git add . 2>&1 | tee -a $LOG_FILE
    
    # コミット
    info "変更をコミット中..."
    git commit -m "fix: update CDN libraries to fix security vulnerabilities (Axios 1.7.9, Vue 3.5.13, FontAwesome 6.7.2)" 2>&1 | tee -a $LOG_FILE
    
    log "フェーズ4: 完了"
}

# ============================================
# フェーズ5: 本番デプロイ
# ============================================
phase5_deploy() {
    log "============================================"
    log "フェーズ5: 本番デプロイ開始"
    log "============================================"
    
    cd /home/user/webapp
    
    warning "============================================"
    warning "【警告】本番環境にデプロイします"
    warning "============================================"
    read -p "本番デプロイを実行しますか？ (y/N): " confirm
    if [[ $confirm != [yY] ]]; then
        warning "本番デプロイをスキップしました。"
        return
    fi
    
    # デプロイ
    info "Cloudflare Pagesにデプロイ中..."
    npm run deploy 2>&1 | tee -a $LOG_FILE
    DEPLOY_STATUS=$?
    
    if [[ $DEPLOY_STATUS -ne 0 ]]; then
        error "デプロイに失敗しました。"
        exit 1
    fi
    
    log "デプロイ成功"
    
    # デプロイURL（実際のURLは手動で確認）
    info "デプロイURL: https://webapp-geh.pages.dev"
    
    log "フェーズ5: 完了"
    
    # 手動確認を促す
    warning "============================================"
    warning "【重要】本番環境で手動テストを実施してください"
    warning "============================================"
    warning "以下のページをブラウザで確認してください："
    warning "1. https://webapp-geh.pages.dev/ (トップページ)"
    warning "2. https://webapp-geh.pages.dev/products (商品一覧)"
    warning "3. https://webapp-geh.pages.dev/booking (予約フォーム)"
    warning "4. https://webapp-geh.pages.dev/admin/login (管理画面)"
    warning "============================================"
    
    read -p "本番環境のテストが完了し、問題がないことを確認しましたか？ (y/N): " confirm
    if [[ $confirm != [yY] ]]; then
        error "本番環境のテストが完了していません。必要に応じてロールバックを検討してください。"
        exit 1
    fi
}

# ============================================
# フェーズ6: 完了報告
# ============================================
phase6_report() {
    log "============================================"
    log "フェーズ6: 完了報告"
    log "============================================"
    
    log "全ての処理が正常に完了しました。"
    log ""
    log "実施内容："
    log "- Axios: 1.6.0 → 1.7.9"
    log "- Vue.js: @3 → 3.5.13"
    log "- Font Awesome: 6.4.0 → 6.7.2"
    log ""
    log "バックアップファイル: /home/user/webapp_backup_before_cdn_fix_*.tar.gz"
    log "ログファイル: $LOG_FILE"
    log ""
    log "次のアクション："
    log "1. チームに完了報告"
    log "2. ドキュメント更新（security_fix_preparation.mdに実施結果を記録）"
    log "3. 数日間の監視"
    log ""
    log "============================================"
    log "セキュリティ修正実施完了"
    log "============================================"
}

# ============================================
# メイン処理
# ============================================
main() {
    log "============================================"
    log "CDN脆弱性修正 - 実施開始"
    log "実施日時: $(date +'%Y-%m-%d %H:%M:%S')"
    log "============================================"
    
    # 各フェーズを順次実行
    phase0_precheck
    phase1_backup
    phase2_fix_cdn
    phase3_build_test
    phase4_commit
    phase5_deploy
    phase6_report
    
    log "全ての処理が完了しました。"
}

# スクリプト実行
main
