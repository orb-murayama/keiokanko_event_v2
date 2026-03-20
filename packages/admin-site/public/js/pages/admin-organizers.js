// 主催者一覧ページ

let currentPage = 1;
let currentSearch = {
  name: '',
  email: '',
  status: ''
};

// ページサイズ
const perPage = 20;

// ログアウト
function logout() {
  if (confirm('ログアウトしますか？')) {
    window.location.href = '/admin/logout';
  }
}

// 主催者一覧を読み込み
async function loadOrganizers(page = 1, search = {}) {
  currentPage = page;
  currentSearch = search;

  // クエリパラメータを構築
  const params = new URLSearchParams({
    page: page.toString(),
    per_page: perPage.toString()
  });

  if (search.name) params.append('name', search.name);
  if (search.email) params.append('email', search.email);
  if (search.status !== undefined && search.status !== '') {
    params.append('enable_flg', search.status);
  }

  try {
    const response = await fetch(`/api/organizers?${params.toString()}`);
    
    if (!response.ok) {
      throw new Error('主催者の読み込みに失敗しました');
    }

    const result = await response.json();
    
    // テーブル表示
    displayOrganizers(result.data);
    
    // ページネーション表示
    displayPagination(result.pagination);

  } catch (error) {
    console.error('Error:', error);
    alert('主催者の読み込みに失敗しました');
  }
}

// 主催者一覧を表示
function displayOrganizers(organizers) {
  const tbody = document.getElementById('organizerTableBody');
  
  if (!organizers || organizers.length === 0) {
    tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 2rem;">主催者が見つかりませんでした</td></tr>';
    return;
  }

  tbody.innerHTML = organizers.map(organizer => `
    <tr>
      <td>${organizer.id}</td>
      <td>${escapeHtml(organizer.name || '')}</td>
      <td>${escapeHtml(organizer.contactable_person || '')}</td>
      <td>${escapeHtml(organizer.branch_office || '')}</td>
      <td>${escapeHtml(organizer.email || '')}</td>
      <td>${escapeHtml(organizer.tel || '')}</td>
      <td>
        <span class="badge ${organizer.reg_flg === 1 ? 'badge-success' : 'badge-danger'}">
          ${organizer.reg_flg === 1 ? '有効' : '無効'}
        </span>
      </td>
      <td>${organizer.created_at ? new Date(organizer.created_at).toLocaleString('ja-JP') : ''}</td>
      <td class="action-cell">
        <a href="/admin/organizers/${organizer.id}/edit" class="action-link action-link-primary">
          <i class="fas fa-edit"></i> 編集
        </a>
        <button onclick="deleteOrganizer(${organizer.id}, '${escapeHtml(organizer.name)}')" 
                class="action-link action-link-danger" 
                style="background: none; border: none; cursor: pointer; padding: 0;">
          <i class="fas fa-trash"></i> 削除
        </button>
      </td>
    </tr>
  `).join('');
}

// ページネーション表示
function displayPagination(pagination) {
  const paginationDiv = document.getElementById('pagination');
  
  if (!pagination || pagination.total_pages <= 1) {
    paginationDiv.innerHTML = '';
    return;
  }

  let html = '<div class="pagination-container">';
  
  // 前へボタン
  if (pagination.page > 1) {
    html += `<button onclick="loadOrganizers(${pagination.page - 1}, currentSearch)" class="pagination-btn">前へ</button>`;
  }

  // ページ番号
  for (let i = 1; i <= pagination.total_pages; i++) {
    if (i === pagination.page) {
      html += `<span class="pagination-current">${i}</span>`;
    } else {
      html += `<button onclick="loadOrganizers(${i}, currentSearch)" class="pagination-btn">${i}</button>`;
    }
  }

  // 次へボタン
  if (pagination.page < pagination.total_pages) {
    html += `<button onclick="loadOrganizers(${pagination.page + 1}, currentSearch)" class="pagination-btn">次へ</button>`;
  }

  html += '</div>';
  paginationDiv.innerHTML = html;
}

// 主催者削除
async function deleteOrganizer(id, name) {
  if (!confirm(`主催者「${name}」を削除してもよろしいですか？\nこの操作は取り消せません。`)) {
    return;
  }

  try {
    const response = await fetch(`/api/organizers/${id}`, {
      method: 'DELETE'
    });

    if (!response.ok) {
      throw new Error('主催者の削除に失敗しました');
    }

    alert('主催者を削除しました');
    loadOrganizers(currentPage, currentSearch);

  } catch (error) {
    console.error('Error:', error);
    alert('主催者の削除に失敗しました');
  }
}

// HTMLエスケープ
function escapeHtml(text) {
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };
  return String(text).replace(/[&<>"']/g, m => map[m]);
}

// イベントリスナー
document.addEventListener('DOMContentLoaded', () => {
  // ログアウトボタン
  document.getElementById('logoutBtn').addEventListener('click', logout);

  // 検索フォーム
  document.getElementById('searchForm').addEventListener('submit', (e) => {
    e.preventDefault();
    
    const search = {
      name: document.getElementById('searchName').value.trim(),
      email: document.getElementById('searchEmail').value.trim(),
      status: document.getElementById('searchStatus').value
    };

    loadOrganizers(1, search);
  });

  // リセットボタン
  document.getElementById('resetBtn').addEventListener('click', () => {
    document.getElementById('searchForm').reset();
    loadOrganizers(1, {});
  });

  // 初回読み込み
  loadOrganizers(1, {});
});
