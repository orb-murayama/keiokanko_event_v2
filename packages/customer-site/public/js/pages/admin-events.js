/**
 * Admin Events Page Script
 * イベント管理ページ
 */

// グローバル変数
let currentPage = 1;
let perPage = 20;
let totalPages = 1;
let categoryMap = {};
let branchMap = {};
let clientMap = {};

/**
 * ページ読み込み時の初期化
 */
async function initEventsPage() {
  console.log('🔵 initEventsPage() 開始');
  
  try {
    await Promise.all([
      loadCategories(),
      loadBranches(),
      loadClients()
    ]);
    await loadEvents();
    
    // 検索フォームのイベント設定
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
      searchForm.addEventListener('submit', handleSearch);
    }
    
    // リセットボタン
    const resetBtn = document.getElementById('resetBtn');
    if (resetBtn) {
      resetBtn.addEventListener('click', resetSearch);
    }
    
    // イベントテーブルのクリックイベントをデリゲート
    const tableBody = document.getElementById('eventsTableBody');
    if (tableBody) {
      tableBody.addEventListener('click', handleTableClick);
    }
    
    console.log('✅ initEventsPage() 完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました。');
  }
}

/**
 * カテゴリーマスタを読み込み
 */
async function loadCategories() {
  try {
    const response = await window.API.categoriesAPI.getAll();
    const categories = response.data || [];
    categories.forEach(cat => {
      categoryMap[cat.id] = cat.name;
    });
  } catch (error) {
    console.error('カテゴリー読み込みエラー:', error);
  }
}

/**
 * 支店一覧を読み込み
 */
async function loadBranches() {
  try {
    const response = await window.API.branchesAPI.getAll();
    const branches = response.data || [];
    const select = document.getElementById('searchBranchCode');
    
    branches.forEach(branch => {
      branchMap[branch.branch_code] = branch.branch_full_name;
      
      if (select) {
        const option = document.createElement('option');
        option.value = branch.branch_code;
        option.textContent = branch.branch_full_name;
        select.appendChild(option);
      }
    });
  } catch (error) {
    console.error('支店読み込みエラー:', error);
  }
}

/**
 * クライアント一覧を読み込み
 */
async function loadClients() {
  try {
    const response = await window.API.clientsAPI.getAll();
    const clients = response.data || [];
    const select = document.getElementById('searchClientId');
    
    clients.forEach(client => {
      clientMap[client.id] = client.name;
      
      if (select) {
        const option = document.createElement('option');
        option.value = client.id;
        option.textContent = client.name;
        select.appendChild(option);
      }
    });
  } catch (error) {
    console.error('クライアント読み込みエラー:', error);
  }
}

/**
 * 主催者一覧を読み込み
 * （削除：主催者は表示しない）
 */
// async function loadOrganizers() { ... }

/**
 * イベント一覧を読み込み
 */
async function loadEvents(page = 1) {
  console.log('🟢 loadEvents() 呼び出し - page:', page);
  
  const tableBody = document.getElementById('eventsTableBody');
  const loadingDiv = document.getElementById('loading');
  const paginationDiv = document.getElementById('pagination');
  
  if (!tableBody) return;
  
  // ローディング表示
  window.Utils.showLoading(true, loadingDiv);
  tableBody.innerHTML = '';
  
  try {
    // 検索パラメータを取得
    const params = getSearchParams();
    params.page = page;
    params.per_page = perPage;
    
    console.log('📡 API呼び出し - params:', params);
    const response = await window.API.eventsAPI.getAll(params);
    console.log('📥 API応答 - events:', response.events?.length || response.data?.length || 0, '件');
    
    const events = response.events || response.data || [];
    const pagination = response.pagination || {};
    
    currentPage = page;
    totalPages = pagination.total_pages || 1;
    
    window.Utils.showLoading(false, loadingDiv);
    
    if (events.length === 0) {
      tableBody.innerHTML = `
        <tr>
          <td colspan="8" class="px-4 py-8 text-center text-gray-500">
            該当するイベントが見つかりませんでした。
          </td>
        </tr>
      `;
      if (paginationDiv) paginationDiv.classList.add('hidden');
      return;
    }
    
    // テーブル行を生成
    events.forEach(event => {
      const row = createEventRow(event);
      tableBody.appendChild(row);
    });
    
    console.log('✅ テーブル行を', events.length, '件追加');
    
    // ページネーション更新
    updatePagination(pagination);
    
  } catch (error) {
    window.Utils.showLoading(false, loadingDiv);
    console.error('イベント読み込みエラー:', error);
    tableBody.innerHTML = `
      <tr>
        <td colspan="8" class="px-4 py-8 text-center text-red-500">
          イベントの読み込みに失敗しました。
        </td>
      </tr>
    `;
  }
}

/**
 * イベント行を作成
 */
function createEventRow(event) {
  const tr = document.createElement('tr');
  tr.className = 'border-b hover:bg-gray-50';
  
  // 開催期間（yyyy/mm/dd形式で表示）
  const dateRange = event.event_start_date === event.event_end_date
    ? window.Utils.formatDate(event.event_start_date, 'YYYY/MM/DD')
    : `${window.Utils.formatDate(event.event_start_date, 'YYYY/MM/DD')} - ${window.Utils.formatDate(event.event_end_date, 'YYYY/MM/DD')}`;
  
  // ステータスバッジ
  const statusBadge = event.enable_flg === 1
    ? '<span class="admin-badge success">有効</span>'
    : '<span class="admin-badge danger">無効</span>';
  
  // カテゴリー名
  const categoryName = categoryMap[event.category] || '-';
  
  // 支店名
  const branchName = event.branch_name || event.branch_full_name || branchMap[event.branch_code] || '-';
  
  // クライアント名
  const clientName = event.client_name || clientMap[event.client_id] || '-';
  
  tr.innerHTML = `
    <td class="px-4 py-3 text-sm">${event.id}</td>
    <td class="px-4 py-3">
      <a href="/admin/events/${event.id}/edit" class="text-blue-600 hover:underline font-medium">
        ${event.name}
      </a>
    </td>
    <td class="px-4 py-3 text-sm">${branchName}</td>
    <td class="px-4 py-3 text-sm">${clientName}</td>
    <td class="px-4 py-3 text-sm">${dateRange}</td>
    <td class="px-4 py-3">${statusBadge}</td>
    <td class="px-4 py-3">
      <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
        <a href="/admin/events/${event.id}/edit" 
           class="action-link action-link-primary">
          <i class="fas fa-edit"></i>編集
        </a>
        <a href="/admin/bookings?event_id=${event.id}" 
           class="action-link action-link-info">
          <i class="fas fa-calendar-check"></i>予約
        </a>
        <a href="/admin/products?event_id=${event.id}&event_name=${encodeURIComponent(event.name)}" 
           class="action-link action-link-success">
          <i class="fas fa-boxes"></i>商品
        </a>
        <a href="/admin/options?event_id=${event.id}&event_name=${encodeURIComponent(event.name)}" 
           class="action-link action-link-info">
          <i class="fas fa-puzzle-piece"></i>オプション
        </a>
        <button class="copy-event-btn action-link action-link-warning" 
                data-event-id="${event.id}"
                data-event-name="${event.name}"
                style="background: none; border: none; cursor: pointer; padding: 0;">
          <i class="fas fa-copy"></i>コピー
        </button>
        <button class="delete-event-btn action-link action-link-danger"
                data-event-id="${event.id}"
                style="background: none; border: none; cursor: pointer; padding: 0;">
          <i class="fas fa-trash"></i>削除
        </button>
      </div>
    </td>
  `;
  
  return tr;
}

/**
 * 検索パラメータを取得
 */
function getSearchParams() {
  const params = {};
  
  const name = document.getElementById('searchName')?.value;
  if (name) params.name = name;
  
  const branchCode = document.getElementById('searchBranchCode')?.value;
  if (branchCode) params.branch_code = branchCode;
  
  const clientId = document.getElementById('searchClientId')?.value;
  if (clientId) params.client_id = clientId;
  
  // 主催者フィルタは削除（表示しない）
  
  const dateFrom = document.getElementById('searchDateFrom')?.value;
  if (dateFrom) params.date_from = dateFrom;
  
  const dateTo = document.getElementById('searchDateTo')?.value;
  if (dateTo) params.date_to = dateTo;
  
  return params;
}

/**
 * 検索フォーム送信処理
 */
function handleSearch(e) {
  e.preventDefault();
  currentPage = 1;
  loadEvents(1);
}

/**
 * 検索リセット
 */
function resetSearch() {
  document.getElementById('searchForm')?.reset();
  currentPage = 1;
  loadEvents(1);
}

/**
 * ページネーション更新
 */
function updatePagination(pagination) {
  const paginationDiv = document.getElementById('pagination');
  const paginationInfo = document.getElementById('paginationInfo');
  const prevBtn = document.getElementById('prevPageBtn');
  const nextBtn = document.getElementById('nextPageBtn');
  
  if (!paginationDiv) return;
  
  const total = pagination.total || 0;
  const from = ((currentPage - 1) * perPage) + 1;
  const to = Math.min(currentPage * perPage, total);
  
  if (paginationInfo) {
    paginationInfo.textContent = `${from} - ${to} 件 / 全 ${total} 件`;
  }
  
  if (prevBtn) {
    prevBtn.disabled = currentPage <= 1;
  }
  
  if (nextBtn) {
    nextBtn.disabled = currentPage >= totalPages;
  }
  
  paginationDiv.classList.remove('hidden');
}

/**
 * テーブル内のボタンクリックを処理
 */
function handleTableClick(event) {
  const target = event.target.closest('button');
  if (!target) return;
  
  // コピーボタン
  if (target.classList.contains('copy-event-btn')) {
    const eventId = target.dataset.eventId;
    const eventName = target.dataset.eventName;
    if (eventId && eventName) {
      copyEvent(parseInt(eventId), eventName);
    }
    return;
  }
  
  // 削除ボタン
  if (target.classList.contains('delete-event-btn')) {
    const eventId = target.dataset.eventId;
    if (eventId) {
      deleteEvent(parseInt(eventId));
    }
    return;
  }
}

/**
 * ページ移動
 */
window.goToPage = function(page) {
  if (page < 1 || page > totalPages) return;
  loadEvents(page);
};

/**
 * イベント削除
 */
window.deleteEvent = async function(eventId) {
  if (!confirm('このイベントを削除してもよろしいですか？\n関連する商品、在庫、予約情報も削除されます。')) {
    return;
  }
  
  try {
    await window.API.eventsAPI.delete(eventId);
    window.Utils.showSuccess('イベントを削除しました。');
    loadEvents(currentPage);
  } catch (error) {
    console.error('削除エラー:', error);
    window.Utils.showError('イベントの削除に失敗しました。');
  }
};

/**
 * イベントコピー
 */
window.copyEvent = async function(eventId, eventName) {
  const newName = prompt(`イベントをコピーします。\n新しいイベント名を入力してください：`, `${eventName}（コピー）`);
  
  if (!newName || newName.trim() === '') {
    return;
  }
  
  if (!confirm(`「${eventName}」を「${newName}」としてコピーしますか？\n\n※商品、価格帯、在庫、オプション、フォームフィールド情報もコピーされます。`)) {
    return;
  }
  
  window.Utils.showLoading(true);
  
  try {
    const response = await fetch(`/api/v1/events/${eventId}/copy`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ new_name: newName })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'コピーに失敗しました');
    }
    
    const result = await response.json();
    window.Utils.showSuccess(`${result.message}\n\n詳細:\n・商品: ${result.copied_products}件\n・在庫: ${result.copied_stocks}件\n・オプション: ${result.copied_options}件\n・フォームフィールド: ${result.copied_form_fields}件`);
    
    // イベント一覧をリロード
    setTimeout(() => {
      loadEvents(currentPage);
    }, 1500);
  } catch (error) {
    console.error('コピーエラー:', error);
    window.Utils.showError(`イベントのコピーに失敗しました。\n${error.message}`);
  } finally {
    window.Utils.showLoading(false);
  }
};

// 初期化
document.addEventListener('DOMContentLoaded', initEventsPage);
