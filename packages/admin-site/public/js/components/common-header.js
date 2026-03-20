/**
 * 共通ヘッダー・ナビゲーションコンポーネント
 * 全管理画面で統一されたヘッダーとナビゲーションを表示
 */

(function() {
  'use strict';

  // 現在のページパスを取得
  const currentPath = window.location.pathname;

  // ナビゲーションメニュー項目（roles で表示制御）
  const navItems = [
    {
      href: '/admin-dashboard.html',
      icon: 'fas fa-tachometer-alt',
      label: 'ダッシュボード',
      paths: ['/admin-dashboard.html', '/admin.html', '/index.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    },
    {
      href: '/bookings-list.html',
      icon: 'fas fa-clipboard-list',
      label: '予約管理',
      paths: ['/bookings-list.html', '/bookings-detail.html', '/bookings-edit.html', '/admin-bulk-emails.html', '/admin-bulk-documents.html', '/admin-bulk-messages.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール（担当イベントのみ）
    },
    {
      href: '/events-list.html',
      icon: 'fas fa-calendar-alt',
      label: 'イベント管理',
      paths: ['/events-list.html', '/events-form.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    },
    {
      href: '/products-list.html',
      icon: 'fas fa-box',
      label: '商品管理',
      paths: ['/products-list.html', '/products-edit.html', '/products-stocks.html', '/products-form-fields.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    },
    {
      href: '/options-list.html',
      icon: 'fas fa-sliders-h',
      label: 'オプション管理',
      paths: ['/options-list.html', '/options-edit.html', '/options-stocks.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    },
    {
      href: '/members-list.html',
      icon: 'fas fa-user-friends',
      label: '会員管理',
      paths: ['/members-list.html', '/members-edit.html'],
      roles: ['system_admin', 'admin'] // system_admin と admin のみ
    },
    {
      href: '/accounts-list.html',
      icon: 'fas fa-users',
      label: 'アカウント管理',
      paths: ['/accounts-list.html', '/accounts-edit.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    },
    {
      href: '/clients-list.html',
      icon: 'fas fa-building',
      label: 'クライアント管理',
      paths: ['/clients-list.html', '/clients-edit.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    },
    {
      href: '/vendors-list.html',
      icon: 'fas fa-handshake',
      label: '販売会社管理',
      paths: ['/vendors-list.html', '/vendors-edit.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    },
    {
      href: '/organizers-list.html',
      icon: 'fas fa-users-cog',
      label: '主催者管理',
      paths: ['/organizers-list.html', '/organizers-edit.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    },
    {
      href: '/admin-help.html',
      icon: 'fas fa-question-circle',
      label: 'ヘルプ',
      paths: ['/admin-help.html', '/email-placeholder-help.html', '/document-placeholder-help.html'],
      roles: ['system_admin', 'admin', 'branch'] // 全ロール
    }
  ];

  // ページタイトルとアイコンのマッピング
  const pageTitles = {
    '/admin': { icon: 'fas fa-tachometer-alt', title: '管理画面' },
    '/admin.html': { icon: 'fas fa-tachometer-alt', title: '管理画面' },
    '/bookings-list.html': { icon: 'fas fa-clipboard-list', title: '予約一覧' },
    '/bookings-detail.html': { icon: 'fas fa-file-alt', title: '予約詳細' },
    '/events-list.html': { icon: 'fas fa-calendar-alt', title: 'イベント一覧' },
    '/admin-event-form.html': { icon: 'fas fa-calendar-plus', title: 'イベント編集' },
    '/products-list.html': { icon: 'fas fa-box', title: '商品一覧' },
    '/admin-products.html': { icon: 'fas fa-box', title: '商品管理' },
    '/admin-product-form.html': { icon: 'fas fa-box', title: '商品編集' },
    '/options-list.html': { icon: 'fas fa-sliders-h', title: 'オプション一覧' },
    '/admin-option-form.html': { icon: 'fas fa-sliders-h', title: 'オプション編集' },
    '/admin-bulk-emails.html': { icon: 'fas fa-envelope', title: '一括メール送信' },
    '/admin-bulk-documents.html': { icon: 'fas fa-file-pdf', title: '帳票一括生成' },
    '/admin-bulk-messages.html': { icon: 'fas fa-comment-dots', title: '一括メッセージ登録' },
    '/accounts-list.html': { icon: 'fas fa-users', title: 'アカウント一覧' },
    '/accounts-edit.html': { icon: 'fas fa-user-edit', title: 'アカウント編集' },
    '/members-list.html': { icon: 'fas fa-user-friends', title: '会員一覧' },
    '/members-edit.html': { icon: 'fas fa-user-edit', title: '会員編集' },
    '/clients-list.html': { icon: 'fas fa-building', title: '顧客企業一覧' },
    '/clients-edit.html': { icon: 'fas fa-building', title: '顧客企業編集' },
    '/vendors-list.html': { icon: 'fas fa-handshake', title: '販売会社一覧' },
    '/vendors-edit.html': { icon: 'fas fa-handshake', title: '販売会社編集' },
    '/organizers-list.html': { icon: 'fas fa-users-cog', title: '主催者一覧' },
    '/organizers-edit.html': { icon: 'fas fa-users-cog', title: '主催者編集' },
    '/shared-stock-pools-list.html': { icon: 'fas fa-layer-group', title: '共有在庫プール一覧' },
    '/admin-help.html': { icon: 'fas fa-question-circle', title: 'ヘルプ' },
    '/email-placeholder-help.html': { icon: 'fas fa-envelope', title: 'メールプレースホルダー一覧' },
    '/document-placeholder-help.html': { icon: 'fas fa-file-pdf', title: '帳票プレースホルダー一覧' }
  };

  // 現在のページに対応するナビゲーション項目をアクティブにする
  function isActivePath(item) {
    return item.paths.some(path => currentPath === path || currentPath.startsWith(path));
  }

  // ナビゲーションHTMLを生成（ロールに応じてフィルタ）
  function generateNavHTML() {
    // 現在のユーザーロールを取得
    const currentUserRole = window.currentAdminUser?.role || 'branch';
    
    // ロールに応じてメニューをフィルタ
    const visibleItems = navItems.filter(item => {
      // roles が定義されていない場合は全ロール表示
      if (!item.roles || item.roles.length === 0) {
        return true;
      }
      // 現在のロールが許可リストに含まれているかチェック
      return item.roles.includes(currentUserRole);
    });
    
    return visibleItems.map(item => {
      const activeClass = isActivePath(item) ? 'active' : '';
      return `
        <li><a href="${item.href}" class="admin-nav-link ${activeClass}">
          <i class="${item.icon}"></i> ${item.label}
        </a></li>
      `;
    }).join('');
  }

  // ページタイトルを取得
  function getPageTitle() {
    const pageInfo = pageTitles[currentPath];
    if (pageInfo) {
      return `<i class="${pageInfo.icon}"></i> ${pageInfo.title}`;
    }
    // デフォルトタイトル
    return '<i class="fas fa-tachometer-alt"></i> 管理画面';
  }

  // サイドバーHTMLを生成
  function generateSidebarHTML() {
    const currentUserRole = window.currentAdminUser?.role || 'branch';
    const userName = window.currentAdminUser?.person_name || 'ユーザー';
    
    // ロールに応じてメニューをフィルタ
    const visibleItems = navItems.filter(item => {
      if (!item.roles || item.roles.length === 0) {
        return true;
      }
      return item.roles.includes(currentUserRole);
    });
    
    const menuHTML = visibleItems.map(item => {
      const activeClass = isActivePath(item) ? 'active' : '';
      return `
        <a href="${item.href}" class="sidebar-link ${activeClass}" data-label="${item.label}">
          <i class="${item.icon}"></i>
          <span>${item.label}</span>
        </a>
      `;
    }).join('');
    
    return `
      <aside class="admin-sidebar" id="adminSidebar">
        <div class="sidebar-header">
          <div class="sidebar-logo">
            <i class="fas fa-calendar-check"></i>
            <span>イベント予約</span>
          </div>
          <button class="sidebar-toggle" id="sidebarCollapseToggle" title="メニューを折りたたむ">
            <i class="fas fa-angle-left"></i>
          </button>
        </div>
        
        <div class="sidebar-user">
          <div class="user-avatar">
            <i class="fas fa-user-circle"></i>
          </div>
          <div class="user-info">
            <div class="user-name">${userName}</div>
            <div class="user-role">${getRoleLabel(currentUserRole)}</div>
          </div>
        </div>
        
        <nav class="sidebar-nav">
          ${menuHTML}
        </nav>
        
        <div class="sidebar-footer">
          <button id="sidebarLogoutBtn" class="sidebar-logout">
            <i class="fas fa-sign-out-alt"></i>
            <span>ログアウト</span>
          </button>
        </div>
      </aside>
      
      <div class="admin-overlay" id="adminOverlay"></div>
    `;
  }
  
  // ロールラベルを取得
  function getRoleLabel(role) {
    const roleLabels = {
      'system_admin': 'システム管理者',
      'admin': '本社管理者',
      'branch': '支店管理者'
    };
    return roleLabels[role] || '管理者';
  }
  
  // ヘッダーHTMLを生成（トップバー）
  function generateHeaderHTML() {
    return `
      <header class="admin-topbar">
        <div class="topbar-left">
          <button class="hamburger-btn" id="hamburgerBtn">
            <i class="fas fa-bars"></i>
          </button>
          <h1 class="topbar-title" id="headerText">${getPageTitle()}</h1>
        </div>
        <div class="topbar-right">
          <button id="logoutBtn" class="btn btn-logout">
            <i class="fas fa-sign-out-alt"></i>
            <span class="logout-text">ログアウト</span>
          </button>
        </div>
      </header>
    `;
  }

  // 既存のヘッダーとナビゲーションを置き換える
  function replaceHeader() {
    // DOMが完全に読み込まれるまで待機
    if (!document.body) {
      console.log('Body not ready, retrying...');
      setTimeout(replaceHeader, 50);
      return;
    }

    // 既存のヘッダー、ナビゲーション、サイドバーを削除
    const existingHeader = document.querySelector('header.admin-header, header.admin-topbar');
    const existingNav = document.querySelector('nav.admin-nav');
    const existingSidebar = document.querySelector('aside.admin-sidebar');
    const existingOverlay = document.querySelector('.admin-overlay');
    
    if (existingHeader) existingHeader.remove();
    if (existingNav) existingNav.remove();
    if (existingSidebar) existingSidebar.remove();
    if (existingOverlay) existingOverlay.remove();

    // bodyにサイドバーレイアウト用のクラスを追加
    document.body.classList.add('admin-layout');

    // サイドバーとヘッダーを挿入
    const sidebarHTML = generateSidebarHTML();
    const headerHTML = generateHeaderHTML();
    
    document.body.insertAdjacentHTML('afterbegin', sidebarHTML);
    document.body.insertAdjacentHTML('afterbegin', headerHTML);

    // イベントリスナーを設定
    setupEventListeners();
    
    console.log('ヘッダー生成完了 - 現在のロール:', window.currentAdminUser?.role);
  }
  
  // イベントリスナーを設定
  function setupEventListeners() {
    const sidebar = document.getElementById('adminSidebar');
    const overlay = document.getElementById('adminOverlay');
    
    // サイドバー折りたたみトグル（デスクトップ用）
    const collapseToggle = document.getElementById('sidebarCollapseToggle');
    if (collapseToggle) {
      collapseToggle.addEventListener('click', () => {
        sidebar?.classList.toggle('collapsed');
        document.body.classList.toggle('sidebar-collapsed');
        
        // LocalStorageに状態を保存
        const isCollapsed = sidebar?.classList.contains('collapsed');
        localStorage.setItem('sidebarCollapsed', isCollapsed ? 'true' : 'false');
        
        // アイコンを更新
        const icon = collapseToggle.querySelector('i');
        if (icon) {
          icon.className = isCollapsed ? 'fas fa-angle-right' : 'fas fa-angle-left';
        }
        
        // ツールチップを更新
        collapseToggle.title = isCollapsed ? 'メニューを展開' : 'メニューを折りたたむ';
      });
    }
    
    // ハンバーガーメニュー（モバイル用）
    const hamburgerBtn = document.getElementById('hamburgerBtn');
    if (hamburgerBtn) {
      hamburgerBtn.addEventListener('click', () => {
        sidebar?.classList.add('active');
        overlay?.classList.add('active');
        document.body.classList.add('sidebar-open');
      });
    }
    
    // オーバーレイクリック（モバイル用）
    if (overlay) {
      overlay.addEventListener('click', () => {
        sidebar?.classList.remove('active');
        overlay?.classList.remove('active');
        document.body.classList.remove('sidebar-open');
      });
    }
    
    // ログアウトボタン（トップバー）
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', handleLogout);
    }
    
    // ログアウトボタン（サイドバー）
    const sidebarLogoutBtn = document.getElementById('sidebarLogoutBtn');
    if (sidebarLogoutBtn) {
      sidebarLogoutBtn.addEventListener('click', handleLogout);
    }
    
    // LocalStorageから折りたたみ状態を復元
    const savedCollapsedState = localStorage.getItem('sidebarCollapsed');
    if (savedCollapsedState === 'true') {
      sidebar?.classList.add('collapsed');
      document.body.classList.add('sidebar-collapsed');
      const icon = collapseToggle?.querySelector('i');
      if (icon) {
        icon.className = 'fas fa-angle-right';
      }
      if (collapseToggle) {
        collapseToggle.title = 'メニューを展開';
      }
    }
  }
  
  // セッションチェック完了後にヘッダーを再生成
  document.addEventListener('adminAuthReady', function(e) {
    console.log('adminAuthReady イベント受信 - ヘッダー再生成:', e.detail.user.role);
    replaceHeader();
  });

  // ログアウト処理
  async function handleLogout() {
    if (confirm('ログアウトしますか？')) {
      // admin-auth.jsのログアウト関数を使用
      if (window.adminAuth) {
        await window.adminAuth.logout();
      } else {
        console.error('adminAuth が読み込まれていません - フォールバック処理を実行');
        // フォールバック: 直接APIを呼び出し
        try {
          await fetch('/api/admin/auth/logout', {
            method: 'POST',
            credentials: 'include'
          });
        } catch (error) {
          console.error('ログアウトエラー:', error);
        }
        // セッションストレージをクリア
        sessionStorage.clear();
        localStorage.clear();
        // ログインページにリダイレクト
        window.location.href = '/admin-login.html';
      }
    }
  }

  // DOMContentLoaded時に実行
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', replaceHeader);
  } else {
    // すでに読み込み済みの場合は即座に実行
    replaceHeader();
  }
})();
