// オプション一覧管理
let currentOptions = [];

// ページ初期化
document.addEventListener('DOMContentLoaded', async () => {
  console.log('オプション一覧ページを初期化');
  
  try {
    // イベント一覧を読み込み
    await loadEvents();
    
    // カテゴリー一覧を読み込み
    await loadCategories();
    
    // オプション一覧を読み込み
    await loadOptions();
    
    // 検索フォームのイベントリスナーを設定
    document.getElementById('searchForm').addEventListener('submit', handleSearch);
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

// イベント一覧を読み込み
async function loadEvents() {
  try {
    const response = await window.API.get('/api/v1/events?per_page=1000');
    const events = response.data;
    
    const selectElement = document.getElementById('searchEvent');
    events.forEach(event => {
      const option = document.createElement('option');
      option.value = event.id;
      option.textContent = event.name;
      selectElement.appendChild(option);
    });
    
    console.log('イベント一覧を読み込みました:', events.length, '件');
  } catch (error) {
    console.error('イベント読み込みエラー:', error);
  }
}

// カテゴリー一覧を読み込み
async function loadCategories() {
  try {
    const categories = await window.API.get('/api/option-categories');
    
    const selectElement = document.getElementById('searchCategory');
    categories.forEach(cat => {
      const option = document.createElement('option');
      option.value = cat.id;
      option.textContent = cat.name;
      selectElement.appendChild(option);
    });
    
    console.log('カテゴリー一覧を読み込みました:', categories.length, '件');
  } catch (error) {
    console.error('カテゴリー読み込みエラー:', error);
  }
}

// オプション一覧を読み込み
async function loadOptions() {
  try {
    window.Utils.showLoading(true);
    
    // 検索パラメータを取得
    const params = new URLSearchParams();
    const name = document.getElementById('searchName').value;
    const eventId = document.getElementById('searchEvent').value;
    const categoryId = document.getElementById('searchCategory').value;
    const enableFlg = document.getElementById('searchStatus').value;
    
    if (name) params.append('name', name);
    if (eventId) params.append('event_id', eventId);
    if (categoryId) params.append('option_category_id', categoryId);
    if (enableFlg !== '') params.append('enable_flg', enableFlg);
    
    const queryString = params.toString();
    const url = queryString ? `/api/options?${queryString}` : '/api/options';
    
    const response = await window.API.get(url);
    const options = response.options || [];  // レスポンス構造に合わせて修正
    currentOptions = options;
    
    // テーブルをレンダリング
    renderOptionsTable(options);
    
    console.log('オプション一覧を読み込みました:', options.length, '件');
  } catch (error) {
    console.error('オプション読み込みエラー:', error);
    window.Utils.showError('オプションの読み込みに失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

// オプション一覧テーブルをレンダリング
function renderOptionsTable(options) {
  const tbody = document.getElementById('optionsTableBody');
  tbody.innerHTML = '';
  
  if (options.length === 0) {
    tbody.innerHTML = '<tr><td colspan="7" class="text-center">オプションが見つかりませんでした</td></tr>';
    return;
  }
  
  options.forEach(option => {
    const tr = createOptionRow(option);
    tbody.appendChild(tr);
  });
}

// オプション行を作成
function createOptionRow(option) {
  const tr = document.createElement('tr');
  
  // 画像サムネイル
  const imageThumbnail = option.image_url 
    ? `<img src="${option.image_url}" alt="オプション画像" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;">` 
    : '<span style="color: #999; font-size: 0.9em;">画像なし</span>';
  
  // 状態バッジ
  const statusBadge = option.enable_flg === 1 
    ? '<span class="badge badge-success">有効</span>' 
    : '<span class="badge badge-secondary">無効</span>';
  
  tr.innerHTML = `
    <td>${option.id}</td>
    <td>${imageThumbnail}</td>
    <td>${escapeHtml(option.name || '')}</td>
    <td>${escapeHtml(option.event_name || '-')}</td>
    <td>${escapeHtml(option.category_name || '-')}</td>
    <td>${statusBadge}</td>
    <td>
      <a href="/admin/options/${option.id}/edit" class="action-link action-link-primary">
        <i class="fas fa-edit"></i> 編集
      </a>
      <a href="/admin/options/${option.id}/stocks" class="action-link action-link-info">
        <i class="fas fa-warehouse"></i> 在庫
      </a>
      <button onclick="copyOption(${option.id}, '${escapeHtml(option.name).replace(/'/g, "\\'")}'); return false;" class="action-link action-link-success" style="border: none; background: none; cursor: pointer; padding: 0;">
        <i class="fas fa-copy"></i> コピー
      </button>
      <button onclick="deleteOption(${option.id}, '${escapeHtml(option.name).replace(/'/g, "\\'")}'); return false;" class="action-link action-link-danger" style="border: none; background: none; cursor: pointer; padding: 0;">
        <i class="fas fa-trash"></i> 削除
      </button>
    </td>
  `;
  
  return tr;
}

// 検索実行
async function handleSearch(e) {
  e.preventDefault();
  await loadOptions();
}

// 検索リセット
function resetSearch() {
  document.getElementById('searchForm').reset();
  loadOptions();
}

// オプションコピー
async function copyOption(optionId, optionName) {
  if (!confirm(`オプション「${optionName}」をコピーしますか？\n\n在庫と設定も一緒にコピーされます。`)) {
    return;
  }
  
  window.Utils.showLoading(true);
  
  try {
    const result = await window.API.post(`/api/options/${optionId}/copy`);
    window.Utils.showSuccess(result.message || 'オプションをコピーしました');
    
    // 一覧を再読み込み
    setTimeout(() => {
      loadOptions();
    }, 1500);
    
  } catch (error) {
    console.error('Option copy error:', error);
    window.Utils.showError(error.message || 'オプションのコピーに失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

// オプション削除
async function deleteOption(optionId, optionName) {
  if (!confirm(`オプション「${optionName}」を削除しますか？\n\nこの操作は取り消せません。`)) {
    return;
  }
  
  window.Utils.showLoading(true);
  
  try {
    await window.API.del(`/api/options/${optionId}`);
    window.Utils.showSuccess('オプションを削除しました');
    
    // 一覧を再読み込み
    setTimeout(() => {
      loadOptions();
    }, 1500);
    
  } catch (error) {
    console.error('Option delete error:', error);
    window.Utils.showError(error.message || 'オプションの削除に失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

// HTMLエスケープ
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// グローバルに公開（HTMLから呼び出せるように）
window.copyOption = copyOption;
window.deleteOption = deleteOption;
window.resetSearch = resetSearch;
