#!/bin/bash

# ============================================
# ロールバックスクリプト
# ============================================
# 目的: CDN脆弱性修正で問題が発生した場合の緊急ロールバック
# 所要時間: 約5-15分
# ============================================

set -e

# 色付き出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ログ関数
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR $(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING $(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

# ============================================
# ロールバック方法選択
# ============================================
echo ""
warning "============================================"
warning "ロールバック方法を選択してください"
warning "============================================"
echo ""
echo "1. Git reset（最も簡単、推奨）"
echo "   - 前のコミットに戻す"
echo "   - 所要時間: 5分"
echo ""
echo "2. バックアップから完全復元（確実）"
echo "   - プロジェクト全体を復元"
echo "   - 所要時間: 15分"
echo ""
echo "3. キャンセル"
echo ""
read -p "選択してください (1/2/3): " choice

case $choice in
    1)
        # ============================================
        # 方法1: Git reset
        # ============================================
        log "============================================"
        log "Git resetによるロールバック開始"
        log "============================================"
        
        cd /home/user/webapp
        
        # 現在のコミット確認
        warning "現在のコミット:"
        git log -1 --oneline
        echo ""
        
        # 前のコミット確認
        warning "ロールバック先のコミット:"
        git log -2 --oneline | tail -1
        echo ""
        
        read -p "このコミットに戻しますか？ (y/N): " confirm
        if [[ $confirm != [yY] ]]; then
            error "ロールバックを中断しました。"
            exit 1
        fi
        
        # PM2停止
        log "PM2を停止中..."
        pm2 delete all 2>/dev/null || true
        
        # ポートクリーンアップ
        log "ポート3000をクリーンアップ中..."
        fuser -k 3000/tcp 2>/dev/null || true
        
        # Git reset
        log "前のコミットに戻しています..."
        git reset --hard HEAD~1
        
        # 再ビルド
        log "プロジェクトを再ビルド中..."
        npm run build
        
        # PM2再起動
        log "PM2を再起動中..."
        pm2 start ecosystem.config.cjs
        
        # 起動待機
        sleep 10
        
        # 動作確認
        log "動作確認中..."
        if curl -s http://localhost:3000/ > /dev/null; then
            log "✓ トップページ: OK"
        else
            error "✗ トップページ: FAILED"
        fi
        
        # 本番デプロイのロールバック
        warning ""
        warning "本番環境もロールバックしますか？"
        read -p "(y/N): " deploy_confirm
        
        if [[ $deploy_confirm == [yY] ]]; then
            log "本番環境をロールバック中..."
            git push -f origin main
            npm run deploy
            log "本番環境のロールバックが完了しました。"
        fi
        
        log "============================================"
        log "ロールバック完了"
        log "============================================"
        ;;
        
    2)
        # ============================================
        # 方法2: バックアップから完全復元
        # ============================================
        log "============================================"
        log "バックアップからの完全復元開始"
        log "============================================"
        
        # バックアップファイル検索
        warning "利用可能なバックアップファイル:"
        ls -lht /home/user/webapp_backup_before_cdn_fix_*.tar.gz 2>/dev/null || {
            error "バックアップファイルが見つかりません。"
            exit 1
        }
        echo ""
        
        read -p "最新のバックアップファイルから復元しますか？ (y/N): " confirm
        if [[ $confirm != [yY] ]]; then
            error "復元を中断しました。"
            exit 1
        fi
        
        # 最新のバックアップファイルを取得
        BACKUP_FILE=$(ls -t /home/user/webapp_backup_before_cdn_fix_*.tar.gz 2>/dev/null | head -1)
        log "使用するバックアップ: $BACKUP_FILE"
        
        # PM2停止
        log "PM2を停止中..."
        cd /home/user/webapp
        pm2 delete all 2>/dev/null || true
        
        # ポートクリーンアップ
        log "ポート3000をクリーンアップ中..."
        fuser -k 3000/tcp 2>/dev/null || true
        
        # 現在のプロジェクトを退避
        log "現在のプロジェクトを退避中..."
        cd /home/user
        BROKEN_DIR="webapp_broken_$(date +%Y%m%d_%H%M%S)"
        mv webapp $BROKEN_DIR
        log "退避先: $BROKEN_DIR"
        
        # バックアップから復元
        log "バックアップから復元中..."
        tar -xzf $BACKUP_FILE
        
        # 復元確認
        if [[ -d /home/user/webapp ]]; then
            log "✓ プロジェクトの復元が完了しました"
        else
            error "✗ プロジェクトの復元に失敗しました"
            exit 1
        fi
        
        # PM2再起動
        log "PM2を再起動中..."
        cd /home/user/webapp
        pm2 start ecosystem.config.cjs
        
        # 起動待機
        sleep 10
        
        # 動作確認
        log "動作確認中..."
        if curl -s http://localhost:3000/ > /dev/null; then
            log "✓ トップページ: OK"
        else
            error "✗ トップページ: FAILED"
        fi
        
        # 本番デプロイのロールバック
        warning ""
        warning "本番環境もロールバックしますか？"
        read -p "(y/N): " deploy_confirm
        
        if [[ $deploy_confirm == [yY] ]]; then
            log "本番環境をロールバック中..."
            git push -f origin main
            npm run deploy
            log "本番環境のロールバックが完了しました。"
        fi
        
        log "============================================"
        log "完全復元完了"
        log "============================================"
        log "破損したプロジェクトは $BROKEN_DIR に保存されています。"
        ;;
        
    3)
        log "ロールバックをキャンセルしました。"
        exit 0
        ;;
        
    *)
        error "無効な選択です。"
        exit 1
        ;;
esac

# ============================================
# 完了報告
# ============================================
log ""
log "ロールバックが完了しました。"
log ""
log "次のアクション:"
log "1. ブラウザでローカル環境を確認: http://localhost:3000/"
log "2. 必要に応じて本番環境を確認: https://webapp-geh.pages.dev/"
log "3. 問題が解決しない場合は技術担当に連絡"
log ""
log "PM2ログ確認コマンド: pm2 logs --nostream"
log ""
