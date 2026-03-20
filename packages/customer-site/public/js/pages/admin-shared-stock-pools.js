/**
 * 共有在庫プール管理ページ
 */

// ページ初期化
document.addEventListener('DOMContentLoaded', async () => {
  console.log('共有在庫プール管理ページを初期化');
  
  try {
    // プール一覧を読み込み
    await loadPools();
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

/**
 * プール一覧を読み込み
 */
async function loadPools() {
  const loading = document.getElementById('loading');
  const error = document.getElementById('error');
  const tableContainer = document.getElementById('poolsTableContainer');
  
  loading.style.display = 'block';
  error.style.display = 'none';
  tableContainer.style.display = 'none';
  
  try {
    const data = await window.API.get('/api/shared-stock-pools/summary');
    const pools = data.pools || [];
    
    console.log('プールデータ:', pools);
    
    renderPoolsTable(pools);
    
    loading.style.display = 'none';
    tableContainer.style.display = 'block';
  } catch (err) {
    console.error('プール取得エラー:', err);
    loading.style.display = 'none';
    error.style.display = 'block';
    document.getElementById('errorMessage').textContent = 'データの取得に失敗しました';
  }
}

/**
 * プールテーブルをレンダリング
 */
function renderPoolsTable(pools) {
  const tbody = document.getElementById('poolsTableBody');
  
  if (pools.length === 0) {
    tbody.innerHTML = '<tr><td colspan="6" class="text-center empty-state">共有在庫プールがありません</td></tr>';
    return;
  }
  
  tbody.innerHTML = pools.map(pool => {
    const poolName = window.Utils.escapeHtml(pool.pool_name || '');
    const poolCode = pool.pool_code ? window.Utils.escapeHtml(pool.pool_code) : '';
    const description = pool.description ? window.Utils.escapeHtml(pool.description) : '';
    const dateCount = pool.date_count || 0;
    const firstDate = pool.first_date ? window.Utils.formatDate(pool.first_date, 'YYYY/MM/DD') : '-';
    const lastDate = pool.last_date ? window.Utils.formatDate(pool.last_date, 'YYYY/MM/DD') : '-';
    const totalStock = pool.total_stock_sum || 0;
    const booked = pool.booked_sum || 0;
    const available = pool.available_stock_sum || 0;
    
    return `
      <tr>
        <td>
          <div class="font-medium">${poolName}</div>
          ${poolCode ? `<div class="text-muted text-sm">コード: ${poolCode}</div>` : ''}
          ${description ? `<div class="text-muted text-sm mt-1">${description}</div>` : ''}
        </td>
        <td>
          <div>${dateCount}日分</div>
          <div class="text-muted text-sm">${firstDate} ～ ${lastDate}</div>
        </td>
        <td class="text-right">
          <span class="font-semibold text-primary">${totalStock.toLocaleString()}</span>
        </td>
        <td class="text-right">
          <span class="font-semibold text-danger">${booked.toLocaleString()}</span>
        </td>
        <td class="text-right">
          <span class="font-semibold ${available > 0 ? 'text-success' : 'text-muted'}">
            ${available.toLocaleString()}
          </span>
        </td>
        <td class="text-center">
          <a href="/admin/shared-stock-pools/manage?pool_name=${encodeURIComponent(poolName)}&pool_code=${encodeURIComponent(poolCode)}" 
             class="btn btn-sm btn-primary" 
             style="display: inline-block; background-color: #2563eb; color: #ffffff; text-decoration: none;"
             title="在庫管理">
            <i class="fas fa-boxes"></i>
            在庫管理
          </a>
        </td>
      </tr>
    `;
  }).join('');
}
