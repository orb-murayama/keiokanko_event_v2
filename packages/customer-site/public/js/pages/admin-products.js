// Admin Products List Page Script

// グローバル変数
let currentEventId = null;
let currentEventName = null;

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', async function() {
  console.log('商品一覧ページを初期化');
  
  try {
    // URLパラメータからevent_idとevent_nameを取得
    const urlParams = new URLSearchParams(window.location.search);
    currentEventId = urlParams.get('event_id');
    currentEventName = urlParams.get('event_name');
    
    // イベント一覧を読み込み
    await loadEvents();
    
    // event_idが指定されている場合、検索フォームに設定
    if (currentEventId) {
      document.getElementById('searchEventId').value = currentEventId;
      
      // パンくずリストにイベント名を表示
      if (currentEventName) {
        updateBreadcrumb(currentEventName);
      }
    }
    
    // 商品一覧を読み込み
    await loadProducts();
    
    // 検索フォームのイベント設定
    document.getElementById('searchForm').addEventListener('submit', handleSearch);
    document.getElementById('resetBtn').addEventListener('click', resetSearch);
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

// パンくずリストを更新
function updateBreadcrumb(eventName) {
  const breadcrumbContainer = document.querySelector('.breadcrumb');
  if (!breadcrumbContainer) return;
  
  // 既存のイベント名spanを削除
  const existingEventSpan = breadcrumbContainer.querySelector('.event-name-span');
  if (existingEventSpan) {
    existingEventSpan.remove();
  }
  
  // イベント名がある場合のみ追加
  if (eventName) {
    const eventSpan = document.createElement('span');
    eventSpan.className = 'event-name-span';
    eventSpan.style.color = '#3b82f6';
    eventSpan.style.fontWeight = '600';
    eventSpan.textContent = ` (${eventName})`;
    breadcrumbContainer.appendChild(eventSpan);
  }
}

// イベント一覧を読み込み
async function loadEvents() {
  try {
    const response = await fetch('/api/events?per_page=1000');
    if (!response.ok) throw new Error('イベント一覧の取得に失敗しました');
    
    const data = await response.json();
    const events = data.data || data.events || [];
    
    const select = document.getElementById('searchEventId');
    events.forEach(event => {
      const option = document.createElement('option');
      option.value = event.id;
      option.textContent = event.name;
      select.appendChild(option);
    });
  } catch (error) {
    console.error('イベント一覧読み込みエラー:', error);
  }
}

// 商品一覧を読み込み
async function loadProducts() {
  try {
    document.getElementById('loading').classList.remove('hidden');
    
    // 検索条件を取得
    const eventId = document.getElementById('searchEventId').value;
    const name = document.getElementById('searchName').value;
    const status = document.getElementById('searchStatus').value;
    
    // APIリクエストURLを構築
    let url = '/api/products?per_page=1000';
    if (eventId) url += `&event_id=${eventId}`;
    if (name) url += `&name=${encodeURIComponent(name)}`;
    if (status !== '') url += `&enable_flg=${status}`;
    
    const response = await fetch(url);
    if (!response.ok) throw new Error('商品一覧の取得に失敗しました');
    
    const data = await response.json();
    const products = data.products || data || [];
    
    // テーブルに表示
    renderProducts(products);
    
  } catch (error) {
    console.error('商品一覧読み込みエラー:', error);
    window.Utils.showError('商品一覧の読み込みに失敗しました');
  } finally {
    document.getElementById('loading').classList.add('hidden');
  }
}

// 商品一覧をテーブルに表示
function renderProducts(products) {
  const tbody = document.getElementById('productsTableBody');
  tbody.innerHTML = '';
  
  if (products.length === 0) {
    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 2rem; color: var(--text-muted);">商品が見つかりませんでした</td></tr>';
    return;
  }
  
  products.forEach(product => {
    const row = createProductRow(product);
    tbody.appendChild(row);
  });
}

// 商品行を作成
function createProductRow(product) {
  const tr = document.createElement('tr');
  
  // 販売期間
  const salesPeriod = `${formatDate(product.sales_start)} ～ ${formatDate(product.sales_end)}`;
  
  // 状態バッジ
  const statusBadge = product.enable_flg === 1 
    ? '<span class="badge badge-success">有効</span>' 
    : '<span class="badge badge-secondary">無効</span>';
  
  // 画像サムネイル
  const imageThumbnail = product.image_url 
    ? `<img src="${product.image_url}" alt="商品画像" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;">` 
    : '<span style="color: #999; font-size: 0.9em;">画像なし</span>';
  
  // event_idパラメータを構築
  const eventIdParam = currentEventId ? `?event_id=${currentEventId}` : '';
  const eventNameParam = currentEventName ? `&event_name=${encodeURIComponent(currentEventName)}` : '';
  const fullEventParam = currentEventId ? `${eventIdParam}${eventNameParam}` : '';
  
  tr.innerHTML = `
    <td>${product.id}</td>
    <td>${imageThumbnail}</td>
    <td>${escapeHtml(product.name || '')}</td>
    <td>${escapeHtml(product.event_name || '-')}</td>
    <td>${salesPeriod}</td>
    <td>${statusBadge}</td>
    <td>
      <a href="/admin/products/${product.id}/edit${fullEventParam}" class="action-link action-link-primary">
        <i class="fas fa-edit"></i> 編集
      </a>
      <a href="/admin/products/${product.id}/stocks${fullEventParam}" class="action-link action-link-info">
        <i class="fas fa-warehouse"></i> 在庫
      </a>
      <a href="/admin/products/${product.id}/shared-stocks${fullEventParam}" class="action-link action-link-secondary">
        <i class="fas fa-share-alt"></i> 共有在庫
      </a>
      <a href="/admin/products/${product.id}/form-fields${fullEventParam}" class="action-link action-link-warning">
        <i class="fas fa-cog"></i> フォーム設定
      </a>
      <button onclick="copyProduct(${product.id}, '${escapeHtml(product.name).replace(/'/g, "\\'")}'); return false;" class="action-link action-link-success" style="border: none; background: none; cursor: pointer; padding: 0;">
        <i class="fas fa-copy"></i> コピー
      </button>
      <button onclick="deleteProduct(${product.id}, '${escapeHtml(product.name).replace(/'/g, "\\'")}'); return false;" class="action-link action-link-danger" style="border: none; background: none; cursor: pointer; padding: 0;">
        <i class="fas fa-trash"></i> 削除
      </button>
    </td>
  `;
  
  return tr;
}

// 検索実行
async function handleSearch(e) {
  e.preventDefault();
  
  // 選択されたイベントIDとイベント名を取得
  const eventSelect = document.getElementById('searchEventId');
  const selectedEventId = eventSelect.value;
  const selectedEventName = eventSelect.options[eventSelect.selectedIndex]?.text || '';
  
  // currentEventIdとcurrentEventNameを更新
  currentEventId = selectedEventId || null;
  currentEventName = (selectedEventId && selectedEventName !== 'すべてのイベント') ? selectedEventName : null;
  
  // パンくずリストを更新
  updateBreadcrumb(currentEventName);
  
  await loadProducts();
}

// 検索リセット
function resetSearch() {
  document.getElementById('searchForm').reset();
  
  // currentEventIdとcurrentEventNameをクリア
  currentEventId = null;
  currentEventName = null;
  
  // パンくずリストをクリア
  updateBreadcrumb(null);
  
  loadProducts();
}

// 日時フォーマット
function formatDate(dateString) {
  if (!dateString) return '-';
  const date = new Date(dateString);
  // 日本時間（JST: UTC+9）で表示
  return date.toLocaleDateString('ja-JP', { 
    year: 'numeric', 
    month: '2-digit', 
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    timeZone: 'Asia/Tokyo'
  });
}

// HTMLエスケープ
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// 商品コピー
async function copyProduct(productId, productName) {
  if (!confirm(`商品「${productName}」をコピーしますか？\n\n在庫とフォーム設定も一緒にコピーされます。`)) {
    return;
  }
  
  window.Utils.showLoading(true);
  
  try {
    const response = await fetch(`/api/products/${productId}/copy`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '商品のコピーに失敗しました');
    }
    
    const result = await response.json();
    window.Utils.showSuccess(result.message || '商品をコピーしました');
    
    // 一覧を再読み込み
    setTimeout(() => {
      loadProducts();
    }, 1500);
    
  } catch (error) {
    console.error('Product copy error:', error);
    window.Utils.showError(error.message || '商品のコピーに失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

// 商品削除
async function deleteProduct(productId, productName) {
  if (!confirm(`商品「${productName}」を削除しますか？\n\nこの操作は取り消せません。`)) {
    return;
  }
  
  window.Utils.showLoading(true);
  
  try {
    const response = await fetch(`/api/products/${productId}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '商品の削除に失敗しました');
    }
    
    const result = await response.json();
    window.Utils.showSuccess(result.message || '商品を削除しました');
    
    // 一覧を再読み込み
    setTimeout(() => {
      loadProducts();
    }, 1500);
    
  } catch (error) {
    console.error('Product delete error:', error);
    window.Utils.showError(error.message || '商品の削除に失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

// グローバルに公開（HTMLから呼び出せるように）
window.copyProduct = copyProduct;
window.deleteProduct = deleteProduct;
