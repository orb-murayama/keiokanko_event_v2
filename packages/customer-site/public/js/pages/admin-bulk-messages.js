/**
 * 一括メッセージ登録画面
 */

let csvData = null;

document.addEventListener('DOMContentLoaded', () => {
  initializePage();
});

function initializePage() {
  const uploadForm = document.getElementById('uploadForm');
  const previewBtn = document.getElementById('previewBtn');
  const csvFile = document.getElementById('csvFile');

  // CSVファイル選択時
  csvFile.addEventListener('change', () => {
    csvData = null;
    document.getElementById('previewSection').classList.add('hidden');
    document.getElementById('resultSection').classList.add('hidden');
  });

  // プレビューボタン
  previewBtn.addEventListener('click', handlePreview);

  // フォーム送信
  uploadForm.addEventListener('submit', handleUpload);

  // ログアウト
  document.getElementById('logoutBtn')?.addEventListener('click', handleLogout);
}

// プレビュー処理
async function handlePreview() {
  const csvFileInput = document.getElementById('csvFile');
  const file = csvFileInput.files[0];

  if (!file) {
    showError('CSVファイルを選択してください');
    return;
  }

  try {
    const text = await file.text();
    const lines = text.split('\n').filter(line => line.trim());

    if (lines.length === 0) {
      showError('CSVファイルが空です');
      return;
    }

    // ヘッダー行
    const header = lines[0];
    const dataLines = lines.slice(1);

    if (dataLines.length > 1000) {
      showError('CSVファイルは最大1000行までです');
      return;
    }

    // データをパース
    const data = [];
    for (let i = 0; i < Math.min(dataLines.length, 10); i++) {
      const columns = dataLines[i].split(',').map(col => col.trim().replace(/^"|"$/g, ''));
      if (columns.length >= 5) {
        data.push({
          bookingNumber: columns[0],
          email: columns[1],
          title: columns[2],
          message: columns[3],
          scheduledSendAt: columns[4]
        });
      }
    }

    // プレビュー表示
    displayPreview(data, dataLines.length);
  } catch (error) {
    console.error('プレビューエラー:', error);
    showError('CSVファイルの読み込みに失敗しました');
  }
}

// プレビュー表示
function displayPreview(data, totalCount) {
  const previewSection = document.getElementById('previewSection');
  const previewContent = document.getElementById('previewContent');

  let html = `<p class="mb-3"><strong>総件数:</strong> ${totalCount}件`;
  if (totalCount > 10) {
    html += ` <small class="text-muted">（最初の10件を表示）</small>`;
  }
  html += `</p>`;

  html += '<div class="table-container">';
  html += '<table class="table">';
  html += '<thead><tr>';
  html += '<th>予約番号</th><th>メールアドレス</th><th>タイトル</th><th>メッセージ</th><th>送信日時</th>';
  html += '</tr></thead>';
  html += '<tbody>';

  data.forEach(row => {
    html += '<tr>';
    html += `<td>${escapeHtml(row.bookingNumber)}</td>`;
    html += `<td>${escapeHtml(row.email)}</td>`;
    html += `<td>${escapeHtml(row.title)}</td>`;
    html += `<td>${escapeHtml(row.message.substring(0, 50))}${row.message.length > 50 ? '...' : ''}</td>`;
    html += `<td>${escapeHtml(row.scheduledSendAt)}</td>`;
    html += '</tr>';
  });

  html += '</tbody></table>';
  html += '</div>';

  previewContent.innerHTML = html;
  previewSection.classList.remove('hidden');
}

// アップロード処理
async function handleUpload(e) {
  e.preventDefault();

  const csvFileInput = document.getElementById('csvFile');
  const displayOnMypage = document.getElementById('displayOnMypage').checked;
  const file = csvFileInput.files[0];

  if (!file) {
    showError('CSVファイルを選択してください');
    return;
  }

  const formData = new FormData();
  formData.append('csv_file', file);
  formData.append('display_on_mypage', displayOnMypage ? '1' : '0');

  showLoading();

  try {
    const response = await fetch('/api/booking-messages/bulk-upload', {
      method: 'POST',
      body: formData
    });

    const result = await response.json();

    if (!response.ok) {
      throw new Error(result.error || 'アップロードに失敗しました');
    }

    displayResult(result);
  } catch (error) {
    console.error('アップロードエラー:', error);
    showError(error.message || 'アップロードに失敗しました');
  } finally {
    hideLoading();
  }
}

// 結果表示
function displayResult(result) {
  const resultSection = document.getElementById('resultSection');
  const resultContent = document.getElementById('resultContent');

  let html = '<div class="result-summary">';
  html += `<div class="alert alert-info">`;
  html += `<p><strong>処理完了</strong></p>`;
  html += `<p>総件数: ${result.total}件</p>`;
  html += `<p class="text-success">✅ 成功: ${result.success_count}件</p>`;
  html += `<p class="text-danger">❌ エラー: ${result.error_count}件</p>`;
  html += `</div>`;
  html += '</div>';

  // エラーがある場合は詳細表示
  if (result.results.errors.length > 0) {
    html += '<div class="mt-4">';
    html += '<h3 class="mb-2">エラー詳細</h3>';
    html += '<div class="table-container">';
    html += '<table class="table">';
    html += '<thead><tr><th>行番号</th><th>エラー内容</th></tr></thead>';
    html += '<tbody>';

    result.results.errors.forEach(error => {
      html += '<tr>';
      html += `<td>${error.line}</td>`;
      html += `<td class="text-danger">${escapeHtml(error.error)}</td>`;
      html += '</tr>';
    });

    html += '</tbody></table>';
    html += '</div>';
    html += '</div>';
  }

  // 成功したデータの一部を表示
  if (result.results.success.length > 0) {
    html += '<div class="mt-4">';
    html += '<h3 class="mb-2">登録成功</h3>';
    html += '<div class="table-container">';
    html += '<table class="table">';
    html += '<thead><tr><th>行番号</th><th>予約番号</th></tr></thead>';
    html += '<tbody>';

    result.results.success.slice(0, 10).forEach(success => {
      html += '<tr>';
      html += `<td>${success.line}</td>`;
      html += `<td>${escapeHtml(success.booking_number)}</td>`;
      html += '</tr>';
    });

    if (result.results.success.length > 10) {
      html += `<tr><td colspan="2" class="text-center">...他 ${result.results.success.length - 10}件</td></tr>`;
    }

    html += '</tbody></table>';
    html += '</div>';
    html += '</div>';
  }

  resultContent.innerHTML = html;
  resultSection.classList.remove('hidden');

  // 成功メッセージ
  if (result.error_count === 0) {
    showSuccess(`${result.success_count}件のメッセージを登録しました`);
  } else {
    showWarning(`${result.success_count}件を登録しました（${result.error_count}件のエラーがあります）`);
  }
}

// ユーティリティ関数
function showLoading() {
  document.getElementById('loading').classList.remove('hidden');
}

function hideLoading() {
  document.getElementById('loading').classList.add('hidden');
}

function showError(message) {
  alert(`エラー: ${message}`);
}

function showSuccess(message) {
  alert(message);
}

function showWarning(message) {
  alert(`警告: ${message}`);
}

function escapeHtml(text) {
  if (!text) return '';
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

function handleLogout() {
  if (confirm('ログアウトしますか？')) {
    window.location.href = '/login.html';
  }
}
