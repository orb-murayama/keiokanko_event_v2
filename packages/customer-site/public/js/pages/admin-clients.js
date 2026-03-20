let currentPage = 1;
let currentSearch = {
  name: '',
  email: '',
  status: ''
};
const perPage = 20;

function logout() {
  if (confirm('ログアウトしますか？')) {
    window.location.href = '/admin/logout';
  }
}

async function loadClients(page = 1, search = {}) {
  try {
    currentPage = page;
    currentSearch = search;

    const params = new URLSearchParams({
      page: page.toString(),
      per_page: perPage.toString()
    });

    if (search.name) {
      params.append('name', search.name);
    }
    if (search.email) {
      params.append('email', search.email);
    }
    if (search.status !== undefined && search.status !== '') {
      params.append('enable_flg', search.status);
    }

    const response = await fetch('/api/clients?' + params.toString());
    
    if (!response.ok) {
      throw new Error('クライアント一覧の取得に失敗しました');
    }

    const result = await response.json();
    // APIが配列を返す場合とオブジェクトを返す場合の両方に対応
    const clients = Array.isArray(result) ? result : (result.data || []);
    const pagination = result.pagination || { page: 1, per_page: perPage, total: clients.length, total_pages: 1 };
    displayClients(clients);
    displayPagination(pagination);
  } catch (error) {
    console.error('Error:', error);
    alert('クライアント一覧の読み込みに失敗しました');
  }
}

function displayClients(clients) {
  const tbody = document.getElementById('clientsTableBody');
  
  if (clients.length === 0) {
    tbody.innerHTML = '<tr><td colspan="8" class="text-center">クライアントが見つかりませんでした</td></tr>';
    return;
  }

  tbody.innerHTML = clients.map(client => `
    <tr>
      <td>${client.id}</td>
      <td>${client.name}</td>
      <td>${client.contactable_person || ''}</td>
      <td>${client.email || ''}</td>
      <td>${client.tel || ''}</td>
      <td>${client.reg_flg ? '有効' : '無効'}</td>
      <td>${client.created_at ? new Date(client.created_at).toLocaleDateString('ja-JP') : ''}</td>
      <td>
        <a href="/admin/clients/${client.id}/edit" class="action-link action-link-primary">
          <i class="fas fa-edit"></i> 編集
        </a>
        <a href="#" onclick="deleteClient(${client.id}, '${client.name}'); return false;" class="action-link action-link-danger">
          <i class="fas fa-trash"></i> 削除
        </a>
      </td>
    </tr>
  `).join('');
}

function displayPagination(pagination) {
  const paginationDiv = document.getElementById('pagination');
  
  if (pagination.total_pages <= 1) {
    paginationDiv.innerHTML = '';
    return;
  }

  let html = '<div class="pagination-info">';
  html += `全${pagination.total}件中 ${(pagination.page - 1) * pagination.per_page + 1}〜${Math.min(pagination.page * pagination.per_page, pagination.total)}件を表示`;
  html += '</div><div class="pagination-buttons">';

  if (pagination.page > 1) {
    html += `<button onclick="loadClients(${pagination.page - 1}, currentSearch)" class="pagination-btn">前へ</button>`;
  }

  const startPage = Math.max(1, pagination.page - 2);
  const endPage = Math.min(pagination.total_pages, pagination.page + 2);

  for (let i = startPage; i <= endPage; i++) {
    const activeClass = i === pagination.page ? 'active' : '';
    html += `<button onclick="loadClients(${i}, currentSearch)" class="pagination-btn ${activeClass}">${i}</button>`;
  }

  if (pagination.page < pagination.total_pages) {
    html += `<button onclick="loadClients(${pagination.page + 1}, currentSearch)" class="pagination-btn">次へ</button>`;
  }

  html += '</div>';
  paginationDiv.innerHTML = html;
}

function searchClients() {
  const searchName = document.getElementById('searchName').value.trim();
  const searchEmail = document.getElementById('searchEmail').value.trim();
  const searchStatus = document.getElementById('searchStatus').value;
  
  const search = {
    name: searchName,
    email: searchEmail,
    status: searchStatus
  };
  
  loadClients(1, search);
}

function resetSearch() {
  document.getElementById('searchName').value = '';
  document.getElementById('searchEmail').value = '';
  document.getElementById('searchStatus').value = '';
  loadClients(1, {});
}

async function deleteClient(id, name) {
  if (!confirm(`クライアント「${name}」を削除してもよろしいですか?\n\nこの操作は取り消せません。`)) {
    return;
  }

  try {
    const response = await fetch(`/api/clients/${id}`, {
      method: 'DELETE'
    });

    if (!response.ok) {
      throw new Error('クライアントの削除に失敗しました');
    }

    alert('クライアントを削除しました');
    loadClients(currentPage, currentSearch);
  } catch (error) {
    console.error('Error:', error);
    alert('クライアントの削除に失敗しました');
  }
}

// 初回読み込み
document.addEventListener('DOMContentLoaded', () => {
  loadClients();
  
  // 検索フォームのイベントリスナー
  const searchForm = document.getElementById('searchForm');
  if (searchForm) {
    searchForm.addEventListener('submit', (e) => {
      e.preventDefault();
      searchClients();
    });
  }
  
  // リセットボタンのイベントリスナー
  const resetBtn = document.getElementById('resetBtn');
  if (resetBtn) {
    resetBtn.addEventListener('click', resetSearch);
  }
  
  // ログアウトボタンのイベントリスナー
  const logoutBtn = document.getElementById('logoutBtn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', logout);
  }
});
