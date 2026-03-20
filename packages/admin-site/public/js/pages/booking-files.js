// ==================== Booking Files Management ====================

// グローバル変数
let currentBookingNumber = null;
let selectedFile = null;

// 初期化
document.addEventListener('DOMContentLoaded', () => {
  // URLから予約番号を取得
  const urlParams = new URLSearchParams(window.location.search);
  currentBookingNumber = urlParams.get('id');
  
  if (currentBookingNumber) {
    loadBookingFiles();
  }
  
  // イベントリスナー設定
  setupEventListeners();
});

// イベントリスナー設定
function setupEventListeners() {
  // ファイル追加ボタン
  document.getElementById('addFileBtn')?.addEventListener('click', () => {
    openUploadModal();
  });
  
  // モーダル閉じるボタン
  document.getElementById('closeModal')?.addEventListener('click', closeUploadModal);
  document.getElementById('cancelUploadBtn')?.addEventListener('click', closeUploadModal);
  document.getElementById('closePreviewModal')?.addEventListener('click', closePreviewModal);
  document.getElementById('closeEditModal')?.addEventListener('click', closeEditModal);
  
  // ファイル選択ボタン
  document.getElementById('selectFileBtn')?.addEventListener('click', () => {
    document.getElementById('pdfFileInput').click();
  });
  
  // ファイル選択
  document.getElementById('pdfFileInput')?.addEventListener('change', handleFileSelect);
  
  // ファイル削除ボタン
  document.getElementById('removeFileBtn')?.addEventListener('click', removeSelectedFile);
  
  // Drag & Drop
  const dropZone = document.getElementById('dropZone');
  if (dropZone) {
    dropZone.addEventListener('dragover', handleDragOver);
    dropZone.addEventListener('dragleave', handleDragLeave);
    dropZone.addEventListener('drop', handleDrop);
  }
  
  // 無制限チェックボックス
  document.getElementById('unlimitedCheck')?.addEventListener('change', (e) => {
    const downloadLimit = document.getElementById('downloadLimit');
    if (e.target.checked) {
      downloadLimit.value = 0;
      downloadLimit.disabled = true;
    } else {
      downloadLimit.disabled = false;
    }
  });
  
  document.getElementById('editUnlimitedCheck')?.addEventListener('change', (e) => {
    const downloadLimit = document.getElementById('editDownloadLimit');
    if (e.target.checked) {
      downloadLimit.value = 0;
      downloadLimit.disabled = true;
    } else {
      downloadLimit.disabled = false;
    }
  });
  
  // アップロードボタン
  document.getElementById('uploadBtn')?.addEventListener('click', handleUpload);
  
  // 編集保存ボタン
  document.getElementById('saveEditBtn')?.addEventListener('click', handleEditSave);
  
  // モーダル外クリックで閉じる
  window.addEventListener('click', (e) => {
    if (e.target.classList.contains('modal')) {
      e.target.style.display = 'none';
    }
  });
}

// ファイル一覧読み込み
async function loadBookingFiles() {
  try {
    const response = await fetch(`/api/booking-files/${currentBookingNumber}`);
    const data = await response.json();
    
    if (data.files && data.files.length > 0) {
      renderFiles(data.files);
    } else {
      document.getElementById('filesContainer').innerHTML = '<p style="text-align: center; color: #999;">添付ファイルがありません</p>';
    }
  } catch (error) {
    console.error('ファイル一覧取得エラー:', error);
    document.getElementById('filesContainer').innerHTML = '<p style="text-align: center; color: #e74c3c;">ファイル一覧の読み込みに失敗しました</p>';
  }
}

// ファイル一覧表示
function renderFiles(files) {
  const container = document.getElementById('filesContainer');
  
  let html = '<div class="files-list">';
  
  files.forEach(file => {
    const isUnlimited = file.download_limit === 0;
    const isLimitReached = !isUnlimited && file.download_count >= file.download_limit;
    const downloadText = isUnlimited 
      ? '無制限' 
      : `${file.download_count}/${file.download_limit}回`;
    
    html += `
      <div class="file-item">
        <div class="file-icon">
          <i class="fas fa-file-pdf" style="color: #e74c3c; font-size: 32px;"></i>
        </div>
        <div class="file-info">
          <div class="file-name">${escapeHtml(file.display_filename)}</div>
          <div class="file-meta">
            <span><i class="fas fa-download"></i> ダウンロード: ${downloadText}</span>
            ${isLimitReached ? '<span class="badge badge-danger">上限達成</span>' : ''}
            <span><i class="fas fa-calendar"></i> ${formatDate(file.created_at)}</span>
            <span><i class="fas fa-hdd"></i> ${formatFileSize(file.file_size)}</span>
          </div>
        </div>
        <div class="file-actions">
          <button class="btn btn-sm btn-info" onclick="previewFile(${file.id})">
            <i class="fas fa-eye"></i> プレビュー
          </button>
          <button class="btn btn-sm btn-success" onclick="downloadFile(${file.id})">
            <i class="fas fa-download"></i> ダウンロード
          </button>
          <button class="btn btn-sm btn-warning" onclick="editFile(${file.id}, '${escapeHtml(file.display_filename)}', ${file.download_limit})">
            <i class="fas fa-edit"></i> 編集
          </button>
          <button class="btn btn-sm btn-danger" onclick="deleteFile(${file.id}, '${escapeHtml(file.display_filename)}')">
            <i class="fas fa-trash"></i> 削除
          </button>
        </div>
      </div>
    `;
  });
  
  html += '</div>';
  container.innerHTML = html;
}

// アップロードモーダルを開く
function openUploadModal() {
  document.getElementById('uploadModal').style.display = 'flex';
  // フォームリセット
  document.getElementById('uploadForm').reset();
  document.getElementById('uploadError').style.display = 'none';
  removeSelectedFile();
}

// アップロードモーダルを閉じる
function closeUploadModal() {
  document.getElementById('uploadModal').style.display = 'none';
}

// プレビューモーダルを閉じる
function closePreviewModal() {
  document.getElementById('previewModal').style.display = 'none';
  document.getElementById('pdfPreview').src = '';
}

// 編集モーダルを閉じる
function closeEditModal() {
  document.getElementById('editFileModal').style.display = 'none';
}

// ファイル選択処理
function handleFileSelect(e) {
  const file = e.target.files[0];
  if (file) {
    validateAndDisplayFile(file);
  }
}

// Drag Over処理
function handleDragOver(e) {
  e.preventDefault();
  e.stopPropagation();
  e.currentTarget.classList.add('drag-over');
}

// Drag Leave処理
function handleDragLeave(e) {
  e.preventDefault();
  e.stopPropagation();
  e.currentTarget.classList.remove('drag-over');
}

// Drop処理
function handleDrop(e) {
  e.preventDefault();
  e.stopPropagation();
  e.currentTarget.classList.remove('drag-over');
  
  const files = e.dataTransfer.files;
  if (files.length > 0) {
    validateAndDisplayFile(files[0]);
  }
}

// ファイル検証と表示
function validateAndDisplayFile(file) {
  // PDFチェック
  if (file.type !== 'application/pdf') {
    showUploadError('PDFファイルのみアップロード可能です');
    return;
  }
  
  // サイズチェック (10MB)
  if (file.size > 10 * 1024 * 1024) {
    showUploadError('ファイルサイズが10MBを超えています');
    return;
  }
  
  // ファイル情報を保存
  selectedFile = file;
  
  // ファイル情報を表示
  document.getElementById('fileName').textContent = file.name;
  document.getElementById('fileSize').textContent = `(${formatFileSize(file.size)})`;
  document.getElementById('dropZone').style.display = 'none';
  document.getElementById('fileInfo').style.display = 'flex';
  
  // 表示ファイル名を自動入力（拡張子なし）
  const displayName = file.name.replace('.pdf', '');
  document.getElementById('displayFilename').value = displayName;
  
  // エラーをクリア
  document.getElementById('uploadError').style.display = 'none';
}

// 選択ファイル削除
function removeSelectedFile() {
  selectedFile = null;
  document.getElementById('pdfFileInput').value = '';
  document.getElementById('dropZone').style.display = 'flex';
  document.getElementById('fileInfo').style.display = 'none';
  document.getElementById('uploadError').style.display = 'none';
}

// アップロード処理
async function handleUpload() {
  if (!selectedFile) {
    showUploadError('ファイルを選択してください');
    return;
  }
  
  const displayFilename = document.getElementById('displayFilename').value.trim();
  if (!displayFilename) {
    showUploadError('表示ファイル名を入力してください');
    return;
  }
  
  const downloadLimit = parseInt(document.getElementById('downloadLimit').value) || 0;
  
  const uploadBtn = document.getElementById('uploadBtn');
  uploadBtn.disabled = true;
  uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> アップロード中...';
  
  try {
    const formData = new FormData();
    formData.append('pdf_file', selectedFile);
    formData.append('booking_number', currentBookingNumber);
    formData.append('display_filename', displayFilename);
    formData.append('download_limit', downloadLimit.toString());
    
    const response = await fetch('/api/booking-files/upload', {
      method: 'POST',
      body: formData
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.error || 'アップロードに失敗しました');
    }
    
    // 成功
    alert('ファイルをアップロードしました');
    closeUploadModal();
    loadBookingFiles();
  } catch (error) {
    console.error('アップロードエラー:', error);
    showUploadError(error.message);
  } finally {
    uploadBtn.disabled = false;
    uploadBtn.innerHTML = 'アップロード';
  }
}

// プレビュー表示
function previewFile(fileId) {
  const modal = document.getElementById('previewModal');
  const iframe = document.getElementById('pdfPreview');
  
  iframe.src = `/api/booking-files/download/${fileId}?preview=true`;
  modal.style.display = 'flex';
}

// ダウンロード
function downloadFile(fileId) {
  window.open(`/api/booking-files/download/${fileId}`, '_blank');
}

// ファイル編集
function editFile(fileId, displayFilename, downloadLimit) {
  document.getElementById('editFileId').value = fileId;
  document.getElementById('editDisplayFilename').value = displayFilename;
  document.getElementById('editDownloadLimit').value = downloadLimit;
  document.getElementById('editUnlimitedCheck').checked = downloadLimit === 0;
  document.getElementById('editDownloadLimit').disabled = downloadLimit === 0;
  document.getElementById('editError').style.display = 'none';
  document.getElementById('editFileModal').style.display = 'flex';
}

// ファイル編集保存
async function handleEditSave() {
  const fileId = document.getElementById('editFileId').value;
  const displayFilename = document.getElementById('editDisplayFilename').value.trim();
  const downloadLimit = parseInt(document.getElementById('editDownloadLimit').value) || 0;
  
  if (!displayFilename) {
    showEditError('表示ファイル名を入力してください');
    return;
  }
  
  const saveBtn = document.getElementById('saveEditBtn');
  saveBtn.disabled = true;
  saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 保存中...';
  
  try {
    const response = await fetch(`/api/booking-files/${fileId}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        display_filename: displayFilename,
        download_limit: downloadLimit
      })
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.error || '更新に失敗しました');
    }
    
    alert('ファイル情報を更新しました');
    closeEditModal();
    loadBookingFiles();
  } catch (error) {
    console.error('更新エラー:', error);
    showEditError(error.message);
  } finally {
    saveBtn.disabled = false;
    saveBtn.innerHTML = '保存';
  }
}

// ファイル削除
async function deleteFile(fileId, displayFilename) {
  if (!confirm(`「${displayFilename}」を削除してもよろしいですか？\n\nこの操作は取り消せません。`)) {
    return;
  }
  
  try {
    const response = await fetch(`/api/booking-files/${fileId}`, {
      method: 'DELETE'
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.error || '削除に失敗しました');
    }
    
    alert('ファイルを削除しました');
    loadBookingFiles();
  } catch (error) {
    console.error('削除エラー:', error);
    alert(`削除に失敗しました: ${error.message}`);
  }
}

// エラー表示
function showUploadError(message) {
  const errorDiv = document.getElementById('uploadError');
  errorDiv.textContent = message;
  errorDiv.style.display = 'block';
}

function showEditError(message) {
  const errorDiv = document.getElementById('editError');
  errorDiv.textContent = message;
  errorDiv.style.display = 'block';
}

// ファイルサイズフォーマット
function formatFileSize(bytes) {
  if (bytes === 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

// 日付フォーマット
function formatDate(dateString) {
  if (!dateString) return '-';
  try {
    const date = new Date(dateString);
    // 日本時間（JST: UTC+9）で表示
    return date.toLocaleDateString('ja-JP', { timeZone: 'Asia/Tokyo' });
  } catch (e) {
    return dateString;
  }
}

// HTMLエスケープ
function escapeHtml(text) {
  if (!text) return '';
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };
  return text.toString().replace(/[&<>"']/g, m => map[m]);
}
