/**
 * 共有在庫プール在庫管理ページ
 */

let poolName = '';
let poolCode = '';

// ページ初期化
document.addEventListener('DOMContentLoaded', async () => {
  console.log('共有在庫プール在庫管理ページを初期化');
  console.log('window.API:', window.API);
  console.log('window.Utils:', window.Utils);
  
  // URLからプール情報を取得
  const urlParams = new URLSearchParams(window.location.search);
  poolName = urlParams.get('pool_name') || '';
  poolCode = urlParams.get('pool_code') || '';
  
  console.log('poolName:', poolName);
  console.log('poolCode:', poolCode);
  
  if (!poolName) {
    console.error('プール名が指定されていません');
    const loading = document.getElementById('loading');
    const error = document.getElementById('error');
    if (loading) loading.style.display = 'none';
    if (error) {
      error.style.display = 'block';
      document.getElementById('errorMessage').textContent = 'プール名が指定されていません';
    }
    setTimeout(() => {
      window.location.href = '/shared-stock-pools-list.html';
    }, 2000);
    return;
  }
  
  // ページタイトルとヘッダーを更新
  const pageTitle = document.getElementById('pageTitle');
  const poolNameBreadcrumb = document.getElementById('poolNameBreadcrumb');
  const poolNameDisplay = document.getElementById('poolNameDisplay');
  const poolCodeDisplay = document.getElementById('poolCodeDisplay');
  
  if (pageTitle) pageTitle.textContent = `${poolName} - 在庫管理 | 管理画面`;
  if (poolNameBreadcrumb) poolNameBreadcrumb.textContent = poolName;
  if (poolNameDisplay) poolNameDisplay.textContent = poolName;
  if (poolCodeDisplay) poolCodeDisplay.textContent = poolCode || '-';
  
  try {
    // 在庫一覧を読み込み
    await loadStocks();
    
    // フォームイベントを設定
    setupFormEvents();
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

/**
 * 在庫一覧を読み込み
 */
async function loadStocks() {
  const loading = document.getElementById('loading');
  const error = document.getElementById('error');
  const tableContainer = document.getElementById('stocksTableContainer');
  
  loading.style.display = 'block';
  error.style.display = 'none';
  tableContainer.style.display = 'none';
  
  try {
    console.log('在庫データ取得を開始');
    // プール名でフィルタリングして在庫を取得
    const url = `/api/shared-stock-pools/by-name?pool_name=${encodeURIComponent(poolName)}&pool_code=${encodeURIComponent(poolCode)}`;
    console.log('API URL:', url);
    const data = await window.API.get(url);
    console.log('API応答:', data);
    const stocks = data.stocks || [];
    
    console.log('在庫データ:', stocks);
    
    renderStocksTable(stocks);
    updateSummary(stocks);
    
    loading.style.display = 'none';
    tableContainer.style.display = 'block';
  } catch (err) {
    console.error('在庫取得エラー:', err);
    console.error('エラー詳細:', err.message, err.stack);
    loading.style.display = 'none';
    error.style.display = 'block';
    document.getElementById('errorMessage').textContent = '在庫データの取得に失敗しました: ' + (err.message || '不明なエラー');
  }
}

/**
 * 在庫テーブルをレンダリング
 */
function renderStocksTable(stocks) {
  const tbody = document.getElementById('stocksTableBody');
  
  if (stocks.length === 0) {
    tbody.innerHTML = '<tr><td colspan="6" class="text-center empty-state">在庫データがありません</td></tr>';
    return;
  }
  
  // 日付順にソート
  stocks.sort((a, b) => {
    const dateCompare = (a.date || '').localeCompare(b.date || '');
    if (dateCompare !== 0) return dateCompare;
    return (a.time_slot_start || '').localeCompare(b.time_slot_start || '');
  });
  
  tbody.innerHTML = stocks.map(stock => {
    const id = stock.id;
    const date = stock.date ? window.Utils.formatDate(stock.date, 'YYYY/MM/DD') : '-';
    const timeSlotLabel = stock.time_slot_label ? window.Utils.escapeHtml(stock.time_slot_label) : '';
    const timeSlotStart = stock.time_slot_start || '';
    const timeSlotEnd = stock.time_slot_end || '';
    const timeSlot = timeSlotLabel || (timeSlotStart && timeSlotEnd ? `${timeSlotStart} - ${timeSlotEnd}` : (timeSlotStart || '-'));
    const totalStock = stock.total_stock || 0;
    const booked = stock.booked || 0;
    const available = stock.available_stock || 0;
    
    return `
      <tr>
        <td>${date}</td>
        <td>
          ${timeSlot !== '-' ? `<span class="badge badge-info">${timeSlot}</span>` : '<span class="text-muted">-</span>'}
        </td>
        <td class="text-center">
          <span class="font-semibold text-primary">${totalStock.toLocaleString()}</span>
        </td>
        <td class="text-center">
          <span class="${booked > 0 ? 'text-danger' : 'text-muted'}">${booked.toLocaleString()}</span>
        </td>
        <td class="text-center">
          <span class="font-semibold ${available > 0 ? 'text-success' : 'text-muted'}">
            ${available.toLocaleString()}
          </span>
        </td>
        <td class="text-center">
          <button onclick="showEditForm(${id})" class="btn btn-sm btn-primary" 
                  style="display: inline-block; background-color: #2563eb; color: #ffffff; text-decoration: none;">
            <i class="fas fa-edit"></i> 編集
          </button>
          <button onclick="deleteStock(${id})" class="btn btn-sm btn-danger ml-2"
                  style="display: inline-block;">
            <i class="fas fa-trash"></i> 削除
          </button>
        </td>
      </tr>
    `;
  }).join('');
}

/**
 * 統計サマリーを更新
 */
function updateSummary(stocks) {
  const totalStock = stocks.reduce((sum, s) => sum + (s.total_stock || 0), 0);
  const booked = stocks.reduce((sum, s) => sum + (s.booked || 0), 0);
  const available = stocks.reduce((sum, s) => sum + (s.available_stock || 0), 0);
  
  const totalStockSum = document.getElementById('totalStockSum');
  const bookedSum = document.getElementById('bookedSum');
  const availableSum = document.getElementById('availableSum');
  
  if (totalStockSum) totalStockSum.textContent = totalStock.toLocaleString();
  if (bookedSum) bookedSum.textContent = booked.toLocaleString();
  if (availableSum) availableSum.textContent = available.toLocaleString();
}

/**
 * フォームイベントを設定
 */
function setupFormEvents() {
  // 追加フォーム送信
  const addStockForm = document.getElementById('addStockForm');
  if (addStockForm) {
    addStockForm.addEventListener('submit', handleAddSubmit);
  }
  
  // リセットボタン
  const resetAddBtn = document.getElementById('resetAddBtn');
  if (resetAddBtn) {
    resetAddBtn.addEventListener('click', resetAddForm);
  }
  
  // 編集フォーム送信
  const editStockForm = document.getElementById('editStockForm');
  if (editStockForm) {
    editStockForm.addEventListener('submit', handleEditSubmit);
  }
  
  // キャンセルボタン
  const cancelEditBtn = document.getElementById('cancelEditBtn');
  if (cancelEditBtn) {
    cancelEditBtn.addEventListener('click', hideEditForm);
  }
}

/**
 * 追加フォーム送信処理
 */
async function handleAddSubmit(e) {
  e.preventDefault();
  
  const startDate = document.getElementById('addDateStart').value;
  const endDate = document.getElementById('addDateEnd').value || startDate;
  const timeSlotLabel = document.getElementById('addTimeSlotLabel').value || null;
  const timeSlotStart = document.getElementById('addTimeSlotStart').value || null;
  const timeSlotEnd = document.getElementById('addTimeSlotEnd').value || null;
  const totalStock = parseInt(document.getElementById('addTotalStock').value);
  
  if (!startDate || isNaN(totalStock) || totalStock < 0) {
    window.Utils.showError('必須項目を正しく入力してください');
    return;
  }
  
  // 日付範囲を生成
  const dates = getDateRange(startDate, endDate);
  
  const baseData = {
    pool_name: poolName,
    pool_code: poolCode || null,
    description: null,
    time_slot_label: timeSlotLabel,
    time_slot_start: timeSlotStart,
    time_slot_end: timeSlotEnd,
    total_stock: totalStock,
    enable_flg: 1
  };
  
  try {
    window.Utils.showLoading(true);
    
    let successCount = 0;
    for (const date of dates) {
      await window.API.post('/api/shared-stock-pools', {
        ...baseData,
        date: date
      });
      successCount++;
    }
    
    window.Utils.showSuccess(`${successCount}件の在庫を追加しました（${startDate} ～ ${endDate}）`);
    resetAddForm();
    await loadStocks();
  } catch (error) {
    console.error('追加エラー:', error);
    window.Utils.showError('在庫の追加に失敗しました: ' + (error.message || ''));
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 編集フォーム送信処理
 */
async function handleEditSubmit(e) {
  e.preventDefault();
  
  const id = document.getElementById('editStockId').value;
  const date = document.getElementById('editDate').value;
  const timeSlotLabel = document.getElementById('editTimeSlotLabel').value || null;
  const timeSlotStart = document.getElementById('editTimeSlotStart').value || null;
  const timeSlotEnd = document.getElementById('editTimeSlotEnd').value || null;
  const totalStock = parseInt(document.getElementById('editTotalStock').value);
  
  if (!date || isNaN(totalStock) || totalStock < 0) {
    window.Utils.showError('必須項目を正しく入力してください');
    return;
  }
  
  const data = {
    pool_name: poolName,
    pool_code: poolCode || null,
    description: null,
    date: date,
    time_slot_label: timeSlotLabel,
    time_slot_start: timeSlotStart,
    time_slot_end: timeSlotEnd,
    total_stock: totalStock,
    enable_flg: 1
  };
  
  try {
    window.Utils.showLoading(true);
    
    await window.API.put(`/api/shared-stock-pools/${id}`, data);
    
    window.Utils.showSuccess('在庫を更新しました');
    hideEditForm();
    await loadStocks();
  } catch (error) {
    console.error('更新エラー:', error);
    window.Utils.showError('在庫の更新に失敗しました: ' + (error.message || ''));
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 追加フォームをリセット
 */
function resetAddForm() {
  document.getElementById('addStockForm').reset();
  hideEditForm();
}

/**
 * 編集フォームを表示
 */
async function showEditForm(id) {
  try {
    window.Utils.showLoading(true);
    
    const data = await window.API.get(`/api/shared-stock-pools/${id}`);
    const pool = data.pool;
    
    document.getElementById('editStockId').value = pool.id;
    document.getElementById('editDate').value = pool.date;
    document.getElementById('editTimeSlotLabel').value = pool.time_slot_label || '';
    document.getElementById('editTimeSlotStart').value = pool.time_slot_start || '';
    document.getElementById('editTimeSlotEnd').value = pool.time_slot_end || '';
    document.getElementById('editTotalStock').value = pool.total_stock;
    
    document.getElementById('editFormSection').style.display = 'block';
    
    // スムーズスクロール
    document.getElementById('editFormSection').scrollIntoView({ behavior: 'smooth', block: 'center' });
  } catch (error) {
    console.error('在庫情報取得エラー:', error);
    window.Utils.showError('在庫情報の取得に失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 編集フォームを非表示
 */
function hideEditForm() {
  document.getElementById('editFormSection').style.display = 'none';
  document.getElementById('editStockForm').reset();
}

/**
 * 在庫を削除
 */
async function deleteStock(id) {
  if (!confirm('この在庫を削除してもよろしいですか？')) {
    return;
  }
  
  try {
    window.Utils.showLoading(true);
    
    await window.API.del(`/api/shared-stock-pools/${id}`);
    
    window.Utils.showSuccess('在庫を削除しました');
    await loadStocks();
  } catch (error) {
    console.error('削除エラー:', error);
    window.Utils.showError('在庫の削除に失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 日付範囲を生成
 */
function getDateRange(startDate, endDate) {
  const dates = [];
  const currentDate = new Date(startDate);
  const end = new Date(endDate);
  
  while (currentDate <= end) {
    dates.push(new Date(currentDate).toISOString().split('T')[0]);
    currentDate.setDate(currentDate.getDate() + 1);
  }
  
  return dates;
}
