/**
 * 帳票一括生成ページ
 */

let selectedExcelFile = null;
let selectedCsvFile = null;
let currentJobId = null;
let statusCheckInterval = null;

// ページ初期化
document.addEventListener('DOMContentLoaded', function() {
  console.log('帳票一括生成ページ初期化');
  
  initializePage();
});

/**
 * ページ初期化
 */
function initializePage() {
  // ファイル選択イベント
  const excelInput = document.getElementById('excelTemplate');
  const csvInput = document.getElementById('bookingCsv');
  
  excelInput.addEventListener('change', handleExcelFileChange);
  csvInput.addEventListener('change', handleCsvFileChange);
  
  // フォーム送信
  const uploadForm = document.getElementById('uploadForm');
  uploadForm.addEventListener('submit', handleFormSubmit);
  
  // キャンセルボタン
  const cancelBtn = document.getElementById('cancelBtn');
  cancelBtn.addEventListener('click', handleCancel);
  
  // ログアウトボタン
  const logoutBtn = document.getElementById('logoutBtn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', function() {
      if (confirm('ログアウトしますか？')) {
        localStorage.removeItem('authToken');
        window.location.href = '/admin/login';
      }
    });
  }
}

/**
 * Excelファイル選択時の処理
 */
function handleExcelFileChange(event) {
  const file = event.target.files[0];
  const fileNameSpan = document.getElementById('excelTemplateName');
  const fileButton = document.getElementById('excelTemplateButton');
  
  if (file) {
    selectedExcelFile = file;
    fileNameSpan.textContent = `✓ ${file.name}`;
    fileNameSpan.classList.add('selected');
    fileButton.classList.add('has-file');
    console.log('Excelテンプレート選択:', file.name);
  } else {
    selectedExcelFile = null;
    fileNameSpan.textContent = 'ファイルが選択されていません';
    fileNameSpan.classList.remove('selected');
    fileButton.classList.remove('has-file');
  }
  
  updateGenerateButton();
}

/**
 * CSVファイル選択時の処理
 */
function handleCsvFileChange(event) {
  const file = event.target.files[0];
  const fileNameSpan = document.getElementById('bookingCsvName');
  const fileButton = document.getElementById('bookingCsvButton');
  
  if (file) {
    selectedCsvFile = file;
    fileNameSpan.textContent = `✓ ${file.name}`;
    fileNameSpan.classList.add('selected');
    fileButton.classList.add('has-file');
    console.log('予約番号CSV選択:', file.name);
  } else {
    selectedCsvFile = null;
    fileNameSpan.textContent = 'ファイルが選択されていません';
    fileNameSpan.classList.remove('selected');
    fileButton.classList.remove('has-file');
  }
  
  updateGenerateButton();
}

/**
 * 一括生成ボタンの有効/無効を更新
 */
function updateGenerateButton() {
  const generateBtn = document.getElementById('generateBtn');
  const canGenerate = selectedExcelFile && selectedCsvFile;
  
  generateBtn.disabled = !canGenerate;
}

/**
 * フォーム送信処理
 */
async function handleFormSubmit(event) {
  event.preventDefault();
  
  if (!selectedExcelFile || !selectedCsvFile) {
    showToast('Excelテンプレートと予約番号CSVの両方を選択してください', 'error');
    return;
  }
  
  // 確認ダイアログ
  const confirmed = confirm(
    '帳票の一括生成を開始します。\n' +
    '処理には時間がかかる場合があります。\n' +
    'よろしいですか？'
  );
  
  if (!confirmed) {
    return;
  }
  
  // FormData作成
  const formData = new FormData();
  formData.append('excel_template', selectedExcelFile);
  formData.append('booking_csv', selectedCsvFile);
  
  try {
    // アップロードボタンを無効化
    const generateBtn = document.getElementById('generateBtn');
    const cancelBtn = document.getElementById('cancelBtn');
    generateBtn.disabled = true;
    cancelBtn.disabled = true;
    generateBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> アップロード中...';
    
    console.log('一括生成API呼び出し開始');
    
    // API呼び出し
    const response = await fetch('/api/v2/bulk-documents/generate', {
      method: 'POST',
      body: formData
    });
    
    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.error || '一括生成の開始に失敗しました');
    }
    
    const result = await response.json();
    console.log('一括生成開始成功:', result);
    
    currentJobId = result.job_id;
    
    // 進捗セクションを表示
    showProgressSection(result.total);
    
    // ステータスチェック開始
    startStatusCheck();
    
    showToast(`処理を開始しました（${result.total}件）`, 'success');
    
  } catch (error) {
    console.error('一括生成エラー:', error);
    showToast(error.message, 'error');
    
    // ボタンを元に戻す
    const generateBtn = document.getElementById('generateBtn');
    const cancelBtn = document.getElementById('cancelBtn');
    generateBtn.disabled = false;
    cancelBtn.disabled = false;
    generateBtn.innerHTML = '<i class="fas fa-cogs"></i> 一括生成開始';
  }
}

/**
 * 進捗セクションを表示
 */
function showProgressSection(total) {
  const progressSection = document.getElementById('progressSection');
  const progressTotal = document.getElementById('progressTotal');
  const resultsTableBody = document.getElementById('resultsTableBody');
  
  progressTotal.textContent = total;
  resultsTableBody.innerHTML = ''; // クリア
  
  progressSection.classList.add('active');
  
  // フォームセクションを非表示
  document.getElementById('uploadForm').style.display = 'none';
}

/**
 * ステータスチェック開始
 */
function startStatusCheck() {
  // 2秒ごとにステータスをチェック
  statusCheckInterval = setInterval(async () => {
    await checkJobStatus();
  }, 2000);
  
  // 初回チェック
  checkJobStatus();
}

/**
 * ジョブステータスをチェック
 */
async function checkJobStatus() {
  if (!currentJobId) return;
  
  try {
    const response = await fetch(`/api/v2/bulk-documents/status/${currentJobId}`);
    
    if (!response.ok) {
      throw new Error('ステータスの取得に失敗しました');
    }
    
    const status = await response.json();
    console.log('ジョブステータス:', status);
    
    // 進捗を更新
    updateProgress(status);
    
    // 完了チェック
    if (status.status === 'completed' || status.status === 'failed') {
      clearInterval(statusCheckInterval);
      statusCheckInterval = null;
      
      if (status.status === 'completed') {
        showToast('すべての帳票生成が完了しました', 'success');
        updateProgressStatus('完了', false);
      } else {
        showToast('一部の処理でエラーが発生しました', 'warning');
        updateProgressStatus('エラーあり', false);
      }
    }
    
  } catch (error) {
    console.error('ステータスチェックエラー:', error);
  }
}

/**
 * 進捗状況を更新
 */
function updateProgress(status) {
  const progressCurrent = document.getElementById('progressCurrent');
  const progressBar = document.getElementById('progressBar');
  const resultsTableBody = document.getElementById('resultsTableBody');
  
  // 進捗カウント
  progressCurrent.textContent = status.completed;
  
  // 進捗バー
  const percentage = Math.round((status.completed / status.total) * 100);
  progressBar.style.width = `${percentage}%`;
  progressBar.textContent = `${percentage}%`;
  
  // 結果テーブルを更新
  if (status.results && status.results.length > 0) {
    resultsTableBody.innerHTML = '';
    
    status.results.forEach(result => {
      const row = document.createElement('tr');
      
      // 予約番号
      const bookingCell = document.createElement('td');
      bookingCell.textContent = result.booking_number;
      row.appendChild(bookingCell);
      
      // ステータス
      const statusCell = document.createElement('td');
      const statusBadge = document.createElement('span');
      statusBadge.className = 'status-badge';
      
      if (result.status === 'success') {
        statusBadge.classList.add('success');
        statusBadge.innerHTML = '<i class="fas fa-check-circle"></i> 成功';
      } else if (result.status === 'error') {
        statusBadge.classList.add('error');
        statusBadge.innerHTML = '<i class="fas fa-times-circle"></i> エラー';
      } else {
        statusBadge.classList.add('processing');
        statusBadge.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 処理中';
      }
      
      statusCell.appendChild(statusBadge);
      row.appendChild(statusCell);
      
      // ファイル名
      const filenameCell = document.createElement('td');
      filenameCell.textContent = result.filename || '-';
      row.appendChild(filenameCell);
      
      // エラー詳細
      const errorCell = document.createElement('td');
      if (result.error) {
        errorCell.innerHTML = `<span class="error-message">${result.error}</span>`;
      } else {
        errorCell.textContent = '-';
      }
      row.appendChild(errorCell);
      
      resultsTableBody.appendChild(row);
    });
  }
}

/**
 * 進捗ステータステキストを更新
 */
function updateProgressStatus(statusText, showSpinner = true) {
  const progressStatus = document.querySelector('.progress-status');
  
  if (showSpinner) {
    progressStatus.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${statusText}`;
  } else {
    progressStatus.innerHTML = `<i class="fas fa-check-circle"></i> ${statusText}`;
  }
}

/**
 * キャンセル処理
 */
function handleCancel() {
  if (currentJobId && statusCheckInterval) {
    // 処理中の場合
    const confirmed = confirm('処理をキャンセルして予約一覧に戻りますか？\n（既に開始した処理は継続されます）');
    if (confirmed) {
      clearInterval(statusCheckInterval);
      window.location.href = '/admin/bookings';
    }
  } else {
    // ファイル選択のみの場合
    window.location.href = '/admin/bookings';
  }
}

/**
 * トースト通知を表示
 */
function showToast(message, type = 'info') {
  // 既存のトーストがあれば削除
  const existingToast = document.querySelector('.toast');
  if (existingToast) {
    existingToast.remove();
  }
  
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.textContent = message;
  
  // スタイル
  toast.style.position = 'fixed';
  toast.style.top = '20px';
  toast.style.right = '20px';
  toast.style.padding = '15px 20px';
  toast.style.borderRadius = '6px';
  toast.style.boxShadow = '0 4px 6px rgba(0, 0, 0, 0.1)';
  toast.style.zIndex = '10000';
  toast.style.fontWeight = '600';
  toast.style.minWidth = '300px';
  
  if (type === 'success') {
    toast.style.backgroundColor = '#d4edda';
    toast.style.color = '#155724';
    toast.style.border = '1px solid #c3e6cb';
  } else if (type === 'error') {
    toast.style.backgroundColor = '#f8d7da';
    toast.style.color = '#721c24';
    toast.style.border = '1px solid #f5c6cb';
  } else if (type === 'warning') {
    toast.style.backgroundColor = '#fff3cd';
    toast.style.color = '#856404';
    toast.style.border = '1px solid #ffeaa7';
  } else {
    toast.style.backgroundColor = '#d1ecf1';
    toast.style.color = '#0c5460';
    toast.style.border = '1px solid #bee5eb';
  }
  
  document.body.appendChild(toast);
  
  // 3秒後に自動削除
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transition = 'opacity 0.3s';
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}
