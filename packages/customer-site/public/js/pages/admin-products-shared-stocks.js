/**
 * 商品共有在庫設定ページ
 */

// URLからproductIdとevent情報を取得（クエリパラメータから）
const urlParams = new URLSearchParams(window.location.search);
const productId = urlParams.get('id');
const currentEventId = urlParams.get('event_id');
const currentEventName = urlParams.get('event_name');

// グローバル変数
let currentProduct = null;
let availablePools = [];
let priceBands = [];

/**
 * ページ初期化
 */
document.addEventListener('DOMContentLoaded', async () => {
  console.log('商品共有在庫設定ページを初期化');
  console.log('Product ID:', productId);
  console.log('Event ID:', currentEventId);
  
  // デバッグ: 5秒後に強制的にローディングを非表示
  setTimeout(() => {
    if (document.getElementById('loading').style.display !== 'none') {
      console.warn('ローディングタイムアウト - 強制的に非表示にします');
      document.getElementById('loading').style.display = 'none';
      if (document.getElementById('error').style.display === 'none') {
        showError('ページの読み込みに時間がかかりすぎています。再度お試しください。');
      }
    }
  }, 5000);
  
  if (!productId || productId === 'shared-stocks') {
    showError('商品IDが無効です。URLに ?id=商品ID を指定してください。');
    return;
  }

  try {
    // 商品情報を取得
    await loadProductInfo();
    
    // 価格帯を取得
    await loadPriceBands();
    
    // 利用可能な共有在庫プールを取得
    await loadAvailablePools();
    
    // 共有在庫設定を取得
    await loadSharedStocks();
    
    // 戻るリンクを更新
    updateBackLinks();
    
    // フォームを表示
    document.getElementById('addSharedStockFormContainer').style.display = 'block';
    document.getElementById('loading').style.display = 'none';
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    showError('データの読み込みに失敗しました: ' + (error.message || '不明なエラー'));
  }
});

/**
 * 商品情報を読み込む
 */
async function loadProductInfo() {
  try {
    const response = await window.API.get(`/api/products/${productId}`);
    const data = response.product || response; // productキーがある場合はそれを使用
    currentProduct = data;
    
    document.getElementById('productName').textContent = data.name || '-';
    document.getElementById('productIdDisplay').textContent = data.id || '-';
    document.getElementById('productNameBreadcrumb').textContent = data.name || '共有在庫設定';
    document.getElementById('pageTitle').textContent = `${data.name} - 共有在庫設定 | 管理画面`;
    document.getElementById('productInfo').style.display = 'block';
    
    console.log('商品情報を読み込みました:', data);
  } catch (error) {
    console.error('商品情報の取得に失敗:', error);
    throw new Error('商品情報の取得に失敗しました');
  }
}

/**
 * 価格帯を読み込む
 */
async function loadPriceBands() {
  try {
    const data = await window.API.get(`/api/products/${productId}/prices`);
    const prices = data.prices || [];
    
    // 価格カテゴリ名から価格帯（A, B, Cなど）を抽出
    const bands = [...new Set(prices
      .map(p => p.category_name ? p.category_name.charAt(0) : '')
      .filter(c => c.match(/[A-Z]/))
    )].sort();
    
    priceBands = bands;
    
    const priceBandSelect = document.getElementById('priceBand');
    priceBandSelect.innerHTML = '<option value="">選択してください</option>';
    
    bands.forEach(band => {
      const option = document.createElement('option');
      option.value = band;
      option.textContent = `${band}帯`;
      priceBandSelect.appendChild(option);
    });
    
    console.log('価格帯を読み込みました:', bands);
  } catch (error) {
    console.error('価格帯の取得に失敗:', error);
    // 価格帯がない場合も処理を続行
    console.warn('価格帯なしで続行します');
  }
}

/**
 * 利用可能な共有在庫プールを読み込む
 */
async function loadAvailablePools() {
  try {
    const data = await window.API.get('/api/shared-stock-pools/summary');
    availablePools = data.pools || [];
    
    const poolSelect = document.getElementById('poolName');
    poolSelect.innerHTML = '<option value="">選択してください</option>';
    
    availablePools.forEach(pool => {
      const option = document.createElement('option');
      const poolValue = pool.pool_code 
        ? `${pool.pool_name}|${pool.pool_code}` 
        : pool.pool_name;
      const poolDisplay = pool.pool_code 
        ? `${pool.pool_name} (${pool.pool_code})` 
        : pool.pool_name;
      
      option.value = poolValue;
      option.textContent = poolDisplay;
      poolSelect.appendChild(option);
    });
    
    console.log('共有在庫プールを読み込みました:', availablePools.length, '件');
  } catch (error) {
    console.error('共有在庫プールの取得に失敗:', error);
    throw new Error('共有在庫プールの取得に失敗しました');
  }
}

/**
 * 共有在庫設定を読み込む
 */
async function loadSharedStocks() {
  const loading = document.getElementById('stocksLoading');
  const error = document.getElementById('stocksError');
  const tableContainer = document.getElementById('stocksTableContainer');
  const tbody = document.getElementById('sharedStocksTable');
  
  try {
    loading.style.display = 'block';
    error.style.display = 'none';
    tableContainer.style.display = 'none';
    
    const sharedStocks = await window.API.get(`/api/products/${productId}/shared-stocks`);
    
    console.log('共有在庫設定を読み込みました:', sharedStocks.length, '件');
    
    if (sharedStocks.length === 0) {
      tbody.innerHTML = `
        <tr>
          <td colspan="7" class="text-center py-4 text-muted">
            <i class="fas fa-info-circle"></i>
            共有在庫設定がありません
          </td>
        </tr>
      `;
    } else {
      tbody.innerHTML = sharedStocks.map(stock => {
        const poolName = window.Utils.escapeHtml(stock.pool_name || '-');
        const date = window.Utils.escapeHtml(stock.date || '-');
        const timeSlot = window.Utils.escapeHtml(stock.time_slot_label || '-');
        const priceBand = window.Utils.escapeHtml(stock.price_band || '-');
        const totalStock = stock.total_stock || 0;
        const availableStock = stock.available_stock || 0;
        const stockName = window.Utils.escapeHtml(stock.stock_name || '-');
        const linkId = stock.id;
        
        return `
          <tr>
            <td>${poolName}</td>
            <td>${date}</td>
            <td>${timeSlot}</td>
            <td class="text-center">
              <span class="badge badge-info">${priceBand}</span>
            </td>
            <td class="text-center">
              <span class="font-semibold ${availableStock > 0 ? 'text-success' : 'text-muted'}">${availableStock}</span>
              <span class="text-muted">/ ${totalStock}</span>
            </td>
            <td>${stockName}</td>
            <td class="text-center">
              <button onclick="deleteSharedStock(${linkId})" 
                      class="btn btn-sm btn-danger" 
                      title="削除">
                <i class="fas fa-trash"></i>
              </button>
            </td>
          </tr>
        `;
      }).join('');
    }
    
    loading.style.display = 'none';
    tableContainer.style.display = 'block';
  } catch (err) {
    console.error('共有在庫設定の読み込みエラー:', err);
    loading.style.display = 'none';
    error.style.display = 'block';
    document.getElementById('stocksErrorMessage').textContent = 
      '共有在庫設定の読み込みに失敗しました: ' + (err.message || '不明なエラー');
  }
}

/**
 * 共有在庫を追加
 */
document.getElementById('addSharedStockForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  
  const submitBtn = e.target.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;
  
  try {
    // ボタンを無効化
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 追加中...';
    
    // フォームデータを取得
    const poolValue = document.getElementById('poolName').value;
    const [poolName, poolCode] = poolValue.split('|');
    
    const data = {
      pool_name: poolName,
      pool_code: poolCode || null,
      date_start: document.getElementById('dateStart').value,
      date_end: document.getElementById('dateEnd').value,
      price_band: document.getElementById('priceBand').value,
      stock_name: document.getElementById('stockName').value || null
    };
    
    console.log('共有在庫追加リクエスト:', data);
    
    // API呼び出し
    const result = await window.API.post(`/api/products/${productId}/shared-stocks/batch`, data);
    
    // 成功メッセージ
    alert(`共有在庫を追加しました（${result.added_count}件）`);
    
    // 共有在庫設定を再読み込み
    await loadSharedStocks();
    
    // フォームをリセット
    document.getElementById('addSharedStockForm').reset();
    
    console.log('共有在庫追加成功:', result);
  } catch (error) {
    console.error('共有在庫追加エラー:', error);
    alert('追加に失敗しました: ' + (error.message || '不明なエラー'));
  } finally {
    // ボタンを再有効化
    submitBtn.disabled = false;
    submitBtn.innerHTML = originalText;
  }
});

/**
 * フォームリセット
 */
document.getElementById('resetBtn').addEventListener('click', () => {
  document.getElementById('addSharedStockForm').reset();
});

/**
 * 共有在庫を削除
 */
window.deleteSharedStock = async function(linkId) {
  if (!confirm('この共有在庫設定を削除してもよろしいですか？')) {
    return;
  }
  
  try {
    await window.API.delete(`/api/products/${productId}/shared-stocks/${linkId}`);
    alert('共有在庫設定を削除しました');
    await loadSharedStocks();
    console.log('共有在庫削除成功:', linkId);
  } catch (error) {
    console.error('共有在庫削除エラー:', error);
    alert('削除に失敗しました: ' + (error.message || '不明なエラー'));
  }
};

/**
 * エラーを表示
 */
function showError(message) {
  document.getElementById('loading').style.display = 'none';
  document.getElementById('error').style.display = 'block';
  document.getElementById('errorMessage').textContent = message;
}

/**
 * 戻るリンクを更新（event_idがあれば含める）
 */
function updateBackLinks() {
  if (currentEventId) {
    const eventIdParam = `?event_id=${currentEventId}`;
    const eventNameParam = currentEventName ? `&event_name=${encodeURIComponent(currentEventName)}` : '';
    const fullParam = `${eventIdParam}${eventNameParam}`;
    
    // すべての商品一覧へのリンクを更新
    const backLinks = document.querySelectorAll('a[href="/admin/products"]');
    backLinks.forEach(link => {
      link.href = `/admin/products${fullParam}`;
    });
  }
}
