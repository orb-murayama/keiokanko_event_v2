/**
 * アカウント一覧ページ
 */

// 現在のページネーション設定
let currentPage = 1;
let perPage = 20;
let totalCount = 0;

// 検索条件
let searchParams = {};

/**
 * ページ読み込み時の初期化
 */
document.addEventListener('DOMContentLoaded', () => {
  // ログアウトボタン
  const logoutBtn = document.getElementById('logoutBtn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', logout);
  }

  // 検索フォーム
  const searchForm = document.getElementById('searchForm');
  if (searchForm) {
    searchForm.addEventListener('submit', handleSearch);
  }

  // リセットボタン
  const resetBtn = document.getElementById('resetBtn');
  if (resetBtn) {
    resetBtn.addEventListener('click', handleReset);
  }

  // ページネーション
  const prevPage = document.getElementById('prevPage');
  const nextPage = document.getElementById('nextPage');
  if (prevPage) prevPage.addEventListener('click', () => changePage(currentPage - 1));
  if (nextPage) nextPage.addEventListener('click', () => changePage(currentPage + 1));

  // 初回データ読み込み
  loadAccounts();
});

/**
 * アカウント一覧を読み込み
 */
async function loadAccounts() {
  const loading = document.getElementById('loading');
  const errorMessage = document.getElementById('errorMessage');
  const tableBody = document.getElementById('accountsTableBody');

  try {
    // ローディング表示
    if (loading) loading.classList.remove('hidden');
    if (errorMessage) errorMessage.classList.add('hidden');

    // API呼び出し
    const params = new URLSearchParams({
      page: currentPage,
      per_page: perPage,
      ...searchParams
    });

    const response = await fetch(`/api/accounts?${params.toString()}`);
    if (!response.ok) {
      throw new Error('データの読み込みに失敗しました');
    }

    const data = await response.json();
    const accounts = data.accounts || data.data || [];
    totalCount = data.total || accounts.length;

    // テーブル更新
    renderAccountsTable(accounts);
    
    // ページネーション更新
    updatePagination();

  } catch (error) {
    console.error('アカウント読み込みエラー:', error);
    if (errorMessage) {
      errorMessage.textContent = 'データの読み込みに失敗しました: ' + error.message;
      errorMessage.classList.remove('hidden');
    }
    if (tableBody) {
      tableBody.innerHTML = '<tr><td colspan="9" class="text-center text-danger">データの読み込みに失敗しました</td></tr>';
    }
  } finally {
    if (loading) loading.classList.add('hidden');
  }
}

/**
 * アカウントテーブルをレンダリング
 */
function renderAccountsTable(accounts) {
  const tableBody = document.getElementById('accountsTableBody');
  if (!tableBody) return;

  if (accounts.length === 0) {
    tableBody.innerHTML = '<tr><td colspan="9" class="text-center">データがありません</td></tr>';
    return;
  }

  tableBody.innerHTML = accounts.map(account => {
    const accountTypeName = account.account_type === 'keio' ? '京王観光' : 'クライアント';
    const roleName = getRoleName(account.role);
    const statusBadge = account.enable_flg === 1 
      ? '<span class="badge badge-success">有効</span>' 
      : '<span class="badge badge-danger">無効</span>';
    
    // 支店またはクライアント名
    let belongTo = '-';
    if (account.account_type === 'keio' && account.primary_branch_code) {
      belongTo = `支店: ${account.primary_branch_code}`;
    } else if (account.account_type === 'client' && account.client_name) {
      belongTo = account.client_name;
    }

    return `
      <tr>
        <td>${account.id}</td>
        <td>${escapeHtml(account.login_id || '')}</td>
        <td>${escapeHtml(account.person_name || '')}</td>
        <td>${escapeHtml(account.email || '')}</td>
        <td>${accountTypeName}</td>
        <td>${roleName}</td>
        <td>${belongTo}</td>
        <td>${statusBadge}</td>
        <td>
          <a href="/admin/accounts/${account.id}/edit" class="action-link action-link-primary">
            <i class="fas fa-edit"></i> 編集
          </a>
          <a href="#" onclick="deleteAccount(${account.id}); return false;" class="action-link action-link-danger">
            <i class="fas fa-trash"></i> 削除
          </a>
        </td>
      </tr>
    `;
  }).join('');
}

/**
 * 権限名を取得
 */
function getRoleName(role) {
  const roleNames = {
    'system_admin': 'システム管理者',
    'admin': '本社管理者',
    'branch': '支店担当者',
    'client': 'クライアント'
  };
  return roleNames[role] || role;
}

/**
 * 検索処理
 */
function handleSearch(e) {
  e.preventDefault();
  
  searchParams = {};
  
  const loginId = document.getElementById('searchLoginId').value.trim();
  const personName = document.getElementById('searchPersonName').value.trim();
  const role = document.getElementById('searchRole').value;
  const status = document.getElementById('searchStatus').value;

  if (loginId) searchParams.login_id = loginId;
  if (personName) searchParams.person_name = personName;
  if (role) searchParams.role = role;
  if (status !== '') searchParams.enable_flg = status;

  currentPage = 1;
  loadAccounts();
}

/**
 * リセット処理
 */
function handleReset() {
  document.getElementById('searchForm').reset();
  searchParams = {};
  currentPage = 1;
  loadAccounts();
}

/**
 * ページ変更
 */
function changePage(page) {
  if (page < 1 || page > Math.ceil(totalCount / perPage)) return;
  currentPage = page;
  loadAccounts();
}

/**
 * ページネーション更新
 */
function updatePagination() {
  const pagination = document.getElementById('pagination');
  const paginationInfo = document.getElementById('paginationInfo');
  const prevPage = document.getElementById('prevPage');
  const nextPage = document.getElementById('nextPage');

  if (!pagination) return;

  const totalPages = Math.ceil(totalCount / perPage);
  const startIndex = (currentPage - 1) * perPage + 1;
  const endIndex = Math.min(currentPage * perPage, totalCount);

  if (paginationInfo) {
    paginationInfo.textContent = `全 ${totalCount} 件中 ${startIndex} - ${endIndex} 件を表示`;
  }

  if (prevPage) {
    prevPage.disabled = currentPage <= 1;
  }

  if (nextPage) {
    nextPage.disabled = currentPage >= totalPages;
  }

  if (totalCount > 0) {
    pagination.classList.remove('hidden');
  } else {
    pagination.classList.add('hidden');
  }
}

/**
 * アカウント削除
 */
async function deleteAccount(accountId) {
  if (!confirm('このアカウントを削除してもよろしいですか？')) {
    return;
  }

  try {
    const response = await fetch(`/api/accounts/${accountId}`, {
      method: 'DELETE'
    });

    if (!response.ok) {
      throw new Error('削除に失敗しました');
    }

    alert('アカウントを削除しました');
    loadAccounts();
  } catch (error) {
    console.error('削除エラー:', error);
    alert('削除に失敗しました: ' + error.message);
  }
}

/**
 * HTMLエスケープ
 */
function escapeHtml(text) {
  if (text === null || text === undefined) return '';
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

/**
 * ログアウト処理
 */
function logout() {
  if (confirm('ログアウトしますか？')) {
    document.cookie = 'login=; path=/; max-age=0';
    window.location.href = '/admin/login';
  }
}
