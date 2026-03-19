/**
 * 管理画面認証チェック用共通JavaScript
 * すべての管理画面ページで読み込まれ、セッション状態を確認します
 */

(function() {
  'use strict';

  // ログインページのURL（リダイレクト先）
  const LOGIN_URL = '/admin-login.html';
  
  // セッションチェックAPIのURL
  const SESSION_API_URL = '/api/admin/auth/session';
  
  // セッションチェック実行フラグ（多重実行防止）
  let isCheckingSession = false;

  /**
   * セッション状態をチェック
   * @returns {Promise<boolean>} セッションが有効ならtrue
   */
  async function checkSession() {
    if (isCheckingSession) {
      return false;
    }
    
    isCheckingSession = true;
    
    try {
      // Cookieから自動的にセッショントークンが送信される
      const response = await fetch(SESSION_API_URL, {
        method: 'GET',
        credentials: 'include', // Cookieを自動送信
        headers: {
          'Accept': 'application/json'
        }
      });
      
      if (!response.ok) {
        console.warn('セッションチェック失敗:', response.status);
        return false;
      }
      
      const data = await response.json();
      
      // セッションが有効かチェック
      if (data.authenticated && data.account) {
        console.log('セッション有効:', data.account.email);
        
        // 管理者情報をグローバル変数に保存（他のスクリプトから参照可能）
        window.currentAdminUser = data.account;
        
        return true;
      } else {
        console.warn('セッション無効');
        return false;
      }
      
    } catch (error) {
      console.error('セッションチェックエラー:', error);
      return false;
    } finally {
      isCheckingSession = false;
    }
  }

  /**
   * ログインページにリダイレクト
   */
  function redirectToLogin() {
    console.log('ログインページにリダイレクト');
    
    // 現在のURLをクエリパラメータとして保存（ログイン後に戻れるように）
    const currentPath = window.location.pathname + window.location.search;
    const redirectUrl = `${LOGIN_URL}?redirect=${encodeURIComponent(currentPath)}`;
    
    window.location.href = redirectUrl;
  }

  /**
   * ログアウト処理
   * @returns {Promise<boolean>} ログアウト成功ならtrue
   */
  async function logout() {
    try {
      // Cookieから自動的にセッショントークンが送信される
      const response = await fetch('/api/admin/auth/logout', {
        method: 'POST',
        credentials: 'include', // Cookieを自動送信
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      });
      
      if (!response.ok) {
        console.error('ログアウト失敗:', response.status);
      } else {
        const data = await response.json();
        console.log('ログアウト成功:', data.message);
      }
      
      // sessionStorageをクリア
      sessionStorage.clear();
      
      // ユーザー情報をクリア
      delete window.currentAdminUser;
      
      // ログインページにリダイレクト
      window.location.href = LOGIN_URL;
      
      return true;
      
    } catch (error) {
      console.error('ログアウトエラー:', error);
      
      // エラーでもセッションストレージをクリアしてログインページへ
      sessionStorage.clear();
      delete window.currentAdminUser;
      window.location.href = LOGIN_URL;
      
      return false;
    }
  }

  /**
   * ページ読み込み時にセッションチェックを実行
   */
  async function initAuth() {
    // 現在のページがログインページの場合はチェックしない
    if (window.location.pathname.includes('admin-login')) {
      console.log('ログインページのためセッションチェックをスキップ');
      return;
    }
    
    console.log('セッションチェック開始...');
    
    const isValid = await checkSession();
    
    if (!isValid) {
      console.warn('セッション無効 - ログインページにリダイレクトします');
      redirectToLogin();
    } else {
      console.log('セッション有効 - ページ表示を継続');
      
      // カスタムイベントを発火してセッションチェック完了を通知
      const event = new CustomEvent('adminAuthReady', {
        detail: { user: window.currentAdminUser }
      });
      document.dispatchEvent(event);
    }
  }

  /**
   * 定期的なセッションチェック（5分ごと）
   */
  function startPeriodicCheck() {
    // 5分ごとにセッションチェック
    setInterval(async () => {
      console.log('定期セッションチェック実行');
      const isValid = await checkSession();
      
      if (!isValid) {
        alert('セッションの有効期限が切れました。再度ログインしてください。');
        redirectToLogin();
      }
    }, 5 * 60 * 1000); // 5分
  }

  // グローバル関数としてエクスポート
  window.adminAuth = {
    checkSession: checkSession,
    logout: logout,
    redirectToLogin: redirectToLogin,
    getCurrentUser: () => window.currentAdminUser
  };

  // DOMContentLoaded後に初期化
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      initAuth();
      startPeriodicCheck();
    });
  } else {
    // すでに読み込み済みの場合は即座に実行
    initAuth();
    startPeriodicCheck();
  }

})();
