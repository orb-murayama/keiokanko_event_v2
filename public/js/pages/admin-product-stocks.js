/**
 * 商品在庫管理ページ (HTML5版)
 */

// グローバル変数
let productId = null;
let productData = null;
let priceBands = [];

/**
 * ページ初期化
 */
document.addEventListener('DOMContentLoaded', async () => {
  console.log('商品在庫管理ページを初期化');
  
  // URLからproductIdを取得
  const urlParams = new URLSearchParams(window.location.search);
  productId = urlParams.get('id');
  
  if (!productId) {
    window.Utils.showError('商品IDが指定されていません');
    return;
  }
  
  console.log('商品ID:', productId);
  
  try {
    // 商品情報を読み込み
    await loadProductInfo();
    
    // 価格帯を読み込み
    await loadPriceBands();
    
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
 * 商品情報を読み込み
 */
async function loadProductInfo() {
  try {
    const response = await window.API.get(`/api/products/${productId}`);
    productData = response.product;
    
    // タイトル更新
    document.getElementById('pageTitle').textContent = `在庫管理 - ${productData.name}`;
    document.getElementById('productName').textContent = productData.name;
    document.title = `在庫管理 - ${productData.name} | 管理画面`;
    
    // イベント名表示
    if (productData.event_name) {
      document.getElementById('eventName').textContent = `イベント: ${productData.event_name}`;
    }
    
    // パンくずリンク更新
    const productsLink = document.getElementById('productsLink');
    if (productData.event_id) {
      productsLink.href = `/admin/products?event_id=${productData.event_id}`;
    }
    
    console.log('商品情報を読み込みました:', productData);
  } catch (error) {
    console.error('商品情報の読み込みエラー:', error);
    throw error;
  }
}

/**
 * 価格帯を読み込み
 */
async function loadPriceBands() {
  try {
    const response = await window.API.get(`/api/products/${productId}/prices`);
    const prices = response.prices || [];
    
    // 価格帯を抽出（重複排除）
    priceBands = [...new Set(prices.map(p => p.price_band).filter(Boolean))];
    
    // セレクトボックスを更新
    const priceBandSelect = document.getElementById('priceBand');
    priceBandSelect.innerHTML = '<option value="">選択してください</option>';
    
    priceBands.forEach(band => {
      const option = document.createElement('option');
      option.value = band;
      option.textContent = band;
      priceBandSelect.appendChild(option);
    });
    
    console.log('価格帯を読み込みました:', priceBands);
  } catch (error) {
    console.error('価格帯の読み込みエラー:', error);
    // 価格帯がなくても処理を続行
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
    const response = await window.API.get(`/api/products/${productId}/stocks`);
    const stocks = response.stocks || [];
    
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
    if (a.date !== b.date) return a.date.localeCompare(b.date);
    return (a.stock_name || '').localeCompare(b.stock_name || '');
  });
  
  tbody.innerHTML = stocks.map(stock => {
    const available = stock.stock - stock.booked;
    
    return `
      <tr>
        <td>${window.Utils.formatDate(stock.date, 'YYYY/MM/DD')}</td>
        <td>${stock.stock_name || '<span class="text-muted">未設定</span>'}</td>
        <td class="text-center">
          ${stock.price_band ? `<span class="badge badge-info">${stock.price_band}</span>` : '<span class="text-muted">未設定</span>'}
        </td>
        <td class="text-right">
          <span class="text-primary font-bold">${stock.stock.toLocaleString()}</span>
        </td>
        <td class="text-right">
          <span class="text-danger">${stock.booked.toLocaleString()}</span>
        </td>
        <td class="text-right">
          <span class="font-bold ${available > 0 ? 'text-success' : 'text-muted'}">
            ${available.toLocaleString()}
          </span>
        </td>
        <td class="text-center">
          <button type="button" onclick="editStock(${stock.id}, '${stock.date}', '${(stock.stock_name || '').replace(/'/g, "\\'")}', '${stock.price_band || ''}', ${stock.stock})" 
            class="action-link action-link-primary">
            <i class="fas fa-edit"></i>編集
          </button>
          <button type="button" onclick="deleteStock(${stock.id})" 
            class="action-link action-link-danger">
            <i class="fas fa-trash"></i>削除
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
  const totalStock = stocks.reduce((sum, s) => sum + s.stock, 0);
  const totalBooked = stocks.reduce((sum, s) => sum + s.booked, 0);
  const totalAvailable = stocks.reduce((sum, s) => sum + (s.stock - s.booked), 0);
  
  summary.innerHTML = `
    <span class="summary-item">
      <i class="fas fa-box text-primary"></i>
      総在庫: <strong>${totalStock.toLocaleString()}</strong>
    </span>
    <span class="summary-item">
      <i class="fas fa-clipboard-check text-danger"></i>
      予約済: <strong>${totalBooked.toLocaleString()}</strong>
    </span>
    <span class="summary-item">
      <i class="fas fa-check-circle text-success"></i>
      利用可能: <strong>${totalAvailable.toLocaleString()}</strong>
    </span>
  `;
}

/**
 * 日付範囲から日付配列を生成
 */
function getDateRange(startDate, endDate) {
  const dates = [];
  const currentDate = new Date(startDate);
  const end = endDate ? new Date(endDate) : new Date(startDate);
  
  while (currentDate <= end) {
    dates.push(new Date(currentDate).toISOString().split('T')[0]);
    currentDate.setDate(currentDate.getDate() + 1);
  }
  
  return dates;
}

/**
 * フォームイベントを設定
 */
function setupFormEvents() {
  const form = document.getElementById('stockForm');
  
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const formData = new FormData(form);
    const stockId = formData.get('stock_id');
    
    // 編集モードの場合は単一日付で更新
    if (stockId) {
      const data = {
        product_id: parseInt(productId),
        date: formData.get('date_start'),
        stock_name: formData.get('stock_name') || null,
        price_band: formData.get('price_band') || null,
        stock: parseInt(formData.get('stock'))
      };
      
      try {
        window.Utils.showLoading(true);
        await window.API.put(`/api/stocks/${stockId}`, data);
        window.Utils.showSuccess('在庫を更新しました');
        cancelEdit();
        await loadStocks();
      } catch (error) {
        console.error('更新エラー:', error);
        window.Utils.showError('在庫の更新に失敗しました: ' + error.message);
      } finally {
        window.Utils.showLoading(false);
      }
      return;
    }
    
    // 新規登録（一括登録対応）
    const startDate = formData.get('date_start');
    const endDate = formData.get('date_end');
    const stockName = formData.get('stock_name') || null;
    const priceBand = formData.get('price_band') || null;
    const stock = parseInt(formData.get('stock'));
    
    // 日付範囲を取得
    const dates = getDateRange(startDate, endDate);
    
    // 確認メッセージ
    const confirmMessage = dates.length > 1 
      ? `${startDate} から ${endDate} までの ${dates.length} 日分の在庫を登録します。よろしいですか？`
      : `${startDate} の在庫を登録します。よろしいですか？`;
    
    if (!confirm(confirmMessage)) {
      return;
    }
    
    try {
      window.Utils.showLoading(true);
      
      // 各日付に対して在庫を登録
      let successCount = 0;
      let errorCount = 0;
      const errors = [];
      
      for (const date of dates) {
        const data = {
          product_id: parseInt(productId),
          date: date,
          stock_name: stockName,
          price_band: priceBand,
          stock: stock
        };
        
        try {
          await window.API.post('/api/stocks', data);
          successCount++;
        } catch (error) {
          errorCount++;
          errors.push(`${date}: ${error.message}`);
        }
      }
      
      // 結果を表示
      if (errorCount === 0) {
        window.Utils.showSuccess(`${successCount} 日分の在庫を登録しました`);
        form.reset();
        await loadStocks();
      } else {
        const message = `成功: ${successCount} 日分\n失敗: ${errorCount} 日分\n\nエラー詳細:\n${errors.join('\n')}`;
        alert(message);
        await loadStocks();
      }
    } catch (error) {
      console.error('登録エラー:', error);
      window.Utils.showError('在庫の登録に失敗しました: ' + error.message);
    } finally {
      window.Utils.showLoading(false);
    }
  });
}

/**
 * 在庫を編集
 */
function editStock(id, date, stockName, priceBand, stock) {
  document.getElementById('stockId').value = id;
  document.getElementById('stockDateStart').value = date;
  document.getElementById('stockDateEnd').value = '';
  document.getElementById('stockDateEnd').disabled = true;
  document.getElementById('stockName').value = stockName;
  document.getElementById('priceBand').value = priceBand;
  document.getElementById('stockQuantity').value = stock;
  
  document.getElementById('submitButtonText').textContent = '更新';
  document.getElementById('cancelButton').style.display = 'inline-flex';
  
  // フォームまでスクロール
  document.getElementById('stockForm').scrollIntoView({ behavior: 'smooth' });
}

/**
 * 編集をキャンセル
 */
function cancelEdit() {
  const form = document.getElementById('stockForm');
  form.reset();
  document.getElementById('stockId').value = '';
  document.getElementById('stockDateEnd').disabled = false;
  document.getElementById('submitButtonText').textContent = '登録';
  document.getElementById('cancelButton').style.display = 'none';
}

/**
 * 在庫を削除
 */
async function deleteStock(id) {
  if (!confirm('この在庫を削除してもよろしいですか？\n\n※予約済みの在庫は削除できません')) {
    return;
  }
  
  try {
    window.Utils.showLoading(true);
    await window.API.del(`/api/stocks/${id}`);
    window.Utils.showSuccess('在庫を削除しました');
    await loadStocks();
  } catch (error) {
    console.error('削除エラー:', error);
    window.Utils.showError('在庫の削除に失敗しました: ' + error.message);
  } finally {
    window.Utils.showLoading(false);
  }
}
