/**
 * オプション在庫管理ページ
 */

// グローバル変数
let optionId = null;
let optionData = null;

/**
 * ページ初期化
 */
document.addEventListener('DOMContentLoaded', async () => {
  console.log('オプション在庫管理ページを初期化');
  
  // URLからoptionIdを取得
  const urlParams = new URLSearchParams(window.location.search);
  optionId = urlParams.get('id');
  
  if (!optionId) {
    window.Utils.showError('オプションIDが指定されていません');
    return;
  }
  
  console.log('オプションID:', optionId);
  
  try {
    // オプション情報を読み込み
    await loadOptionInfo();
    
    // 在庫一覧を読み込み
    await loadStocks();
    
    // フォーム送信イベントを設定
    setupFormEvents();
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

/**
 * オプション情報を読み込み
 */
async function loadOptionInfo() {
  try {
    const response = await window.API.get(`/api/options/${optionId}`);
    optionData = response.option;
    
    // タイトル更新
    document.getElementById('pageTitle').textContent = `在庫管理 - ${optionData.name}`;
    document.getElementById('optionName').textContent = optionData.name;
    document.title = `在庫管理 - ${optionData.name} | 管理画面`;
    
    // イベント名表示
    if (optionData.event_name) {
      document.getElementById('eventName').textContent = `イベント: ${optionData.event_name}`;
    }
    
    // パンくずリンク更新
    const optionsLink = document.getElementById('optionsLink');
    if (optionData.event_id) {
      optionsLink.href = `/admin/options?event_id=${optionData.event_id}`;
    }
    
    console.log('オプション情報を読み込みました:', optionData);
  } catch (error) {
    console.error('オプション情報の読み込みエラー:', error);
    throw error;
  }
}

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
    const stocks = await window.API.get(`/api/options/${optionId}/stocks`);
    
    console.log('在庫データ:', stocks);
    
    renderStocksTable(stocks);
    updateStockSummary(stocks);
    
    loading.style.display = 'none';
    tableContainer.style.display = 'block';
  } catch (err) {
    console.error('在庫取得エラー:', err);
    loading.style.display = 'none';
    error.style.display = 'block';
    document.getElementById('errorMessage').textContent = '在庫情報の取得に失敗しました';
  }
}

/**
 * 在庫テーブルをレンダリング
 */
function renderStocksTable(stocks) {
  const tbody = document.getElementById('stocksTableBody');
  
  if (stocks.length === 0) {
    tbody.innerHTML = '<tr><td colspan="7" class="text-center empty-state">在庫が登録されていません</td></tr>';
    return;
  }
  
  // 日付でソート
  stocks.sort((a, b) => {
    const dateA = new Date(a.date);
    const dateB = new Date(b.date);
    return dateA - dateB;
  });
  
  tbody.innerHTML = stocks.map(stock => {
    const available = (stock.total_stock || stock.stock || 0) - (stock.booked || 0);
    const date = window.Utils.formatDate(stock.date, 'YYYY/MM/DD');
    const weekday = window.Utils.getJapaneseWeekday(stock.date);
    
    return `
      <tr>
        <td>
          ${date} (${weekday})
        </td>
        <td>${stock.stock_name || '-'}</td>
        <td class="text-right">${stock.price ? window.Utils.formatCurrency(stock.price) : '-'}</td>
        <td class="text-right">${stock.total_stock || stock.stock || 0}</td>
        <td class="text-right">${stock.booked || 0}</td>
        <td class="text-right">${available}</td>
        <td class="text-center">
          <button class="btn-icon btn-edit" onclick="editStock(${stock.id})" title="編集">
            <i class="fas fa-edit"></i>
          </button>
          <button class="btn-icon btn-delete" onclick="deleteStock(${stock.id})" title="削除">
            <i class="fas fa-trash"></i>
          </button>
        </td>
      </tr>
    `;
  }).join('');
}

/**
 * 在庫サマリーを更新
 */
function updateStockSummary(stocks) {
  const summary = document.getElementById('stockSummary');
  const totalStock = stocks.reduce((sum, s) => sum + (s.total_stock || s.stock || 0), 0);
  const totalBooked = stocks.reduce((sum, s) => sum + (s.booked || 0), 0);
  const totalAvailable = totalStock - totalBooked;
  
  summary.innerHTML = `
    <div class="summary-item">
      <span class="summary-label">総在庫:</span>
      <span class="summary-value">${totalStock}</span>
    </div>
    <div class="summary-item">
      <span class="summary-label">予約済:</span>
      <span class="summary-value">${totalBooked}</span>
    </div>
    <div class="summary-item">
      <span class="summary-label">利用可能:</span>
      <span class="summary-value">${totalAvailable}</span>
    </div>
  `;
}

/**
 * フォームイベントを設定
 */
function setupFormEvents() {
  const form = document.getElementById('stockForm');
  form.addEventListener('submit', handleFormSubmit);
}

/**
 * フォーム送信処理
 */
async function handleFormSubmit(e) {
  e.preventDefault();
  
  const stockId = document.getElementById('stockId').value;
  const dateStart = document.getElementById('stockDateStart').value;
  const dateEnd = document.getElementById('stockDateEnd').value;
  const stockName = document.getElementById('stockName').value;
  const price = document.getElementById('price').value;
  const stock = document.getElementById('stockQuantity').value;
  
  if (!dateStart) {
    window.Utils.showError('開始日を入力してください');
    return;
  }
  
  if (!stock || stock < 0) {
    window.Utils.showError('在庫数を正しく入力してください');
    return;
  }
  
  try {
    window.Utils.showLoading(true);
    
    if (stockId) {
      // 更新
      await updateStock(stockId, {
        date: dateStart,
        stock_name: stockName,
        price: price ? parseInt(price) : null,
        total_stock: parseInt(stock)
      });
      window.Utils.showSuccess('在庫を更新しました');
    } else {
      // 新規登録
      if (dateEnd && dateEnd !== dateStart) {
        // 期間一括登録
        await createStockRange({
          dateStart: dateStart,
          dateEnd: dateEnd,
          stockName: stockName,
          price: price ? parseInt(price) : null,
          totalStock: parseInt(stock)
        });
        window.Utils.showSuccess('在庫を一括登録しました');
      } else {
        // 単日登録
        await createStock({
          dateStart: dateStart,
          dateEnd: dateStart,
          stockName: stockName,
          price: price ? parseInt(price) : null,
          totalStock: parseInt(stock)
        });
        window.Utils.showSuccess('在庫を登録しました');
      }
    }
    
    // フォームリセット
    resetForm();
    
    // 在庫一覧を再読み込み
    await loadStocks();
    
  } catch (error) {
    console.error('在庫登録/更新エラー:', error);
    window.Utils.showError(error.message || '在庫の登録/更新に失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 在庫を新規作成
 */
async function createStock(data) {
  return await window.API.post(`/api/options/${optionId}/stocks`, data);
}

/**
 * 在庫を期間一括作成
 */
async function createStockRange(data) {
  return await window.API.post(`/api/options/${optionId}/stocks`, data);
}

/**
 * 在庫を更新
 */
async function updateStock(stockId, data) {
  return await window.API.put(`/api/options/${optionId}/stocks/${stockId}`, data);
}

/**
 * 在庫を編集
 */
async function editStock(stockId) {
  try {
    window.Utils.showLoading(true);
    
    // 在庫情報を取得
    const stocks = await window.API.get(`/api/options/${optionId}/stocks`);
    const stock = stocks.find(s => s.id === stockId);
    
    if (!stock) {
      window.Utils.showError('在庫が見つかりません');
      return;
    }
    
    // フォームに値を設定
    document.getElementById('stockId').value = stock.id;
    document.getElementById('stockDateStart').value = stock.date;
    document.getElementById('stockDateEnd').value = '';
    document.getElementById('stockName').value = stock.stock_name || '';
    document.getElementById('price').value = stock.price || '';
    document.getElementById('stockQuantity').value = stock.total_stock || stock.stock || 0;
    
    // ボタン表示切り替え
    document.getElementById('submitButtonText').textContent = '更新';
    document.getElementById('cancelButton').style.display = 'inline-block';
    
    // フォームまでスクロール
    document.getElementById('stockForm').scrollIntoView({ behavior: 'smooth' });
    
  } catch (error) {
    console.error('在庫編集エラー:', error);
    window.Utils.showError('在庫情報の取得に失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 在庫を削除
 */
async function deleteStock(stockId) {
  if (!confirm('この在庫を削除してもよろしいですか？')) {
    return;
  }
  
  try {
    window.Utils.showLoading(true);
    
    await window.API.del(`/api/options/${optionId}/stocks/${stockId}`);
    
    window.Utils.showSuccess('在庫を削除しました');
    
    // 在庫一覧を再読み込み
    await loadStocks();
    
  } catch (error) {
    console.error('在庫削除エラー:', error);
    window.Utils.showError('在庫の削除に失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 編集をキャンセル
 */
function cancelEdit() {
  resetForm();
}

/**
 * フォームをリセット
 */
function resetForm() {
  document.getElementById('stockForm').reset();
  document.getElementById('stockId').value = '';
  document.getElementById('submitButtonText').textContent = '登録';
  document.getElementById('cancelButton').style.display = 'none';
}
