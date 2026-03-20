/**
 * Admin Panel Script
 * 管理画面共通のスクリプト
 */

/**
 * ログアウト処理
 */
function logout() {
  // Cookieを削除
  document.cookie = 'login=; path=/; max-age=0';
  // ログイン画面にリダイレクト
  window.location.href = '/admin/login';
}

/**
 * 管理画面の初期化
 */
function initAdmin() {
  // ログアウトボタンのイベント設定（複数のIDに対応）
  const logoutBtn = document.getElementById('logoutBtn') || document.getElementById('admin-logout-btn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', logout);
  }
}

// DOMContentLoadedで初期化
document.addEventListener('DOMContentLoaded', initAdmin);
