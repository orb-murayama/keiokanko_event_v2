// Admin Bookings List Page Script

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', async function() {
  console.log('予約一覧ページを初期化');
  
  try {
    // イベント・クライアント一覧を読み込み
    await loadEvents();
    await loadClients();
    
    // 予約一覧を読み込み
    await loadBookings();
    
    // 検索フォームのイベント設定
    document.getElementById('searchForm').addEventListener('submit', handleSearch);
    document.getElementById('resetBtn').addEventListener('click', resetSearch);
    
    // CSV出力ボタン
    document.getElementById('exportCsvBtn').addEventListener('click', exportCsv);
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

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

// クライアント一覧を読み込み
async function loadClients() {
  try {
    const response = await fetch('/api/clients?per_page=1000');
    if (!response.ok) throw new Error('クライアント一覧の取得に失敗しました');
    
    const data = await response.json();
    const clients = data.data || data.clients || [];
    
    const select = document.getElementById('searchClientId');
    clients.forEach(client => {
      const option = document.createElement('option');
      option.value = client.id;
      option.textContent = client.name;
      select.appendChild(option);
    });
  } catch (error) {
    console.error('クライアント一覧読み込みエラー:', error);
  }
}

// 予約一覧を読み込み
async function loadBookings(page = 1) {
  try {
    document.getElementById('loading').classList.remove('hidden');
    
    // 検索条件を取得
    const eventId = document.getElementById('searchEventId').value;
    const clientId = document.getElementById('searchClientId').value;
    const branchCode = document.getElementById('searchBranchCode').value;
    const bookingNumber = document.getElementById('searchBookingNumber').value;
    const bookingStatus = document.getElementById('searchBookingStatus').value;
    const paymentStatus = document.getElementById('searchPaymentStatus').value;
    const createdAtFrom = document.getElementById('searchCreatedAtFrom').value;
    const createdAtTo = document.getElementById('searchCreatedAtTo').value;
    
    // APIリクエストURLを構築（v2 APIに変更）
    let url = `/api/v2/bookings?page=${page}&per_page=50`;
    if (eventId) url += `&event_id=${eventId}`;
    if (bookingNumber) url += `&booking_number=${encodeURIComponent(bookingNumber)}`;
    if (bookingStatus) url += `&booking_status=${bookingStatus}`;
    if (paymentStatus) url += `&payment_status=${paymentStatus}`;
    if (createdAtFrom) url += `&created_at_from=${createdAtFrom}`;
    if (createdAtTo) url += `&created_at_to=${createdAtTo}`;
    
    const response = await fetch(url);
    if (!response.ok) throw new Error('予約一覧の取得に失敗しました');
    
    const data = await response.json();
    const bookings = data.data || [];
    const pagination = data.pagination || {};
    
    // テーブルに表示
    renderBookings(bookings);
    
    // ページネーション表示
    if (pagination.total_pages > 1) {
      renderPagination(pagination);
    } else {
      document.getElementById('pagination').classList.add('hidden');
    }
    
  } catch (error) {
    console.error('予約一覧読み込みエラー:', error);
    window.Utils.showError('予約一覧の読み込みに失敗しました');
  } finally {
    document.getElementById('loading').classList.add('hidden');
  }
}

// 予約一覧をテーブルに表示
function renderBookings(bookings) {
  const tbody = document.getElementById('bookingsTableBody');
  tbody.innerHTML = '';
  
  if (bookings.length === 0) {
    tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 2rem; color: var(--text-muted);">予約が見つかりませんでした</td></tr>';
    return;
  }
  
  bookings.forEach(booking => {
    const row = createBookingRow(booking);
    tbody.appendChild(row);
  });
}

// 予約行を作成
function createBookingRow(booking) {
  const tr = document.createElement('tr');
  
  // 予約ステータスバッジ
  const bookingStatusBadge = getBookingStatusBadge(booking.booking_status);
  
  // 支払いステータスバッジ
  const paymentStatusBadge = getPaymentStatusBadge(booking.latest_payment_status);
  
  // 金額をフォーマット
  const priceFormatted = booking.total_amount ? `¥${booking.total_amount.toLocaleString()}` : '-';
  
  // 予約日時をフォーマット
  const createdAt = booking.created_at ? formatDateTime(booking.created_at) : '-';
  
  tr.innerHTML = `
    <td>${escapeHtml(booking.booking_number || '-')}</td>
    <td>${escapeHtml(booking.event_name || '-')}</td>
    <td>-</td>
    <td>${escapeHtml(booking.customer_name || '-')}</td>
    <td>${priceFormatted}</td>
    <td>${bookingStatusBadge}</td>
    <td>${paymentStatusBadge}</td>
    <td>${createdAt}</td>
    <td>
      <a href="/bookings-detail.html?id=${encodeURIComponent(booking.booking_number)}" class="action-link action-link-primary">
        <i class="fas fa-eye"></i> 詳細
      </a>
    </td>
  `;
  
  return tr;
}

// 予約ステータスバッジを取得
function getBookingStatusBadge(status) {
  const statusMap = {
    'active': { text: '有効', class: 'badge-success' },
    'partially_canceled': { text: '一部キャンセル', class: 'badge-warning' },
    'fully_canceled': { text: '全キャンセル', class: 'badge-danger' },
    'completed': { text: '完了', class: 'badge-secondary' },
    'reserved': { text: '予約済み', class: 'badge-info' },
    'confirmed': { text: '確定', class: 'badge-success' },
    'canceled': { text: 'キャンセル', class: 'badge-danger' }
  };
  
  const statusInfo = statusMap[status] || { text: status || '-', class: 'badge-secondary' };
  return `<span class="badge ${statusInfo.class}">${statusInfo.text}</span>`;
}

// 支払いステータスバッジを取得
function getPaymentStatusBadge(status) {
  const statusMap = {
    'pending': { text: '未払い', class: 'badge-warning' },
    'completed': { text: '完了', class: 'badge-success' },
    'failed': { text: '失敗', class: 'badge-danger' },
    'expired': { text: '期限切れ', class: 'badge-danger' },
    'refunded': { text: '返金済み', class: 'badge-secondary' },
    'partially_refunded': { text: '一部返金', class: 'badge-warning' },
    'canceled': { text: 'キャンセル', class: 'badge-danger' }
  };
  
  const statusInfo = statusMap[status] || { text: status || '-', class: 'badge-secondary' };
  return `<span class="badge ${statusInfo.class}">${statusInfo.text}</span>`;
}

// ページネーション表示
function renderPagination(pagination) {
  const paginationDiv = document.getElementById('pagination');
  paginationDiv.innerHTML = '';
  paginationDiv.classList.remove('hidden');
  
  const currentPage = pagination.page || 1;
  const totalPages = pagination.total_pages || 1;
  
  // 前へボタン
  if (currentPage > 1) {
    const prevBtn = createPaginationButton('前へ', currentPage - 1);
    paginationDiv.appendChild(prevBtn);
  }
  
  // ページ番号ボタン
  const startPage = Math.max(1, currentPage - 2);
  const endPage = Math.min(totalPages, currentPage + 2);
  
  for (let i = startPage; i <= endPage; i++) {
    const btn = createPaginationButton(i, i, i === currentPage);
    paginationDiv.appendChild(btn);
  }
  
  // 次へボタン
  if (currentPage < totalPages) {
    const nextBtn = createPaginationButton('次へ', currentPage + 1);
    paginationDiv.appendChild(nextBtn);
  }
}

// ページネーションボタンを作成
function createPaginationButton(text, page, isActive = false) {
  const button = document.createElement('button');
  button.textContent = text;
  button.className = `pagination-btn ${isActive ? 'active' : ''}`;
  button.addEventListener('click', () => loadBookings(page));
  return button;
}

// 検索実行
async function handleSearch(e) {
  e.preventDefault();
  await loadBookings(1);
}

// 検索リセット
function resetSearch() {
  document.getElementById('searchForm').reset();
  loadBookings(1);
}

// CSV出力
async function exportCsv() {
  try {
    // 検索条件を取得
    const eventId = document.getElementById('searchEventId').value;
    const clientId = document.getElementById('searchClientId').value;
    const branchCode = document.getElementById('searchBranchCode').value;
    const bookingNumber = document.getElementById('searchBookingNumber').value;
    const bookingStatus = document.getElementById('searchBookingStatus').value;
    const paymentStatus = document.getElementById('searchPaymentStatus').value;
    const createdAtFrom = document.getElementById('searchCreatedAtFrom').value;
    const createdAtTo = document.getElementById('searchCreatedAtTo').value;
    
    // APIリクエストURLを構築
    let url = '/api/bookings/export/csv?';
    const params = [];
    if (eventId) params.push(`event_id=${eventId}`);
    if (clientId) params.push(`client_id=${clientId}`);
    if (branchCode) params.push(`branch_code=${encodeURIComponent(branchCode)}`);
    if (bookingNumber) params.push(`booking_number=${encodeURIComponent(bookingNumber)}`);
    if (bookingStatus) params.push(`booking_status=${bookingStatus}`);
    if (paymentStatus) params.push(`payment_status=${paymentStatus}`);
    if (createdAtFrom) params.push(`created_at_from=${createdAtFrom}`);
    if (createdAtTo) params.push(`created_at_to=${createdAtTo}`);
    url += params.join('&');
    
    // CSVダウンロード
    window.location.href = url;
    
  } catch (error) {
    console.error('CSV出力エラー:', error);
    window.Utils.showError('CSV出力に失敗しました');
  }
}

// 日付フォーマット
function formatDate(dateString) {
  if (!dateString) return '-';
  const date = new Date(dateString);
  // 日本時間（JST: UTC+9）で表示
  return date.toLocaleDateString('ja-JP', { year: 'numeric', month: '2-digit', day: '2-digit', timeZone: 'Asia/Tokyo' });
}

// 日時フォーマット
function formatDateTime(dateString) {
  if (!dateString) return '-';
  const date = new Date(dateString);
  // 日本時間（JST: UTC+9）で表示
  return date.toLocaleString('ja-JP', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    timeZone: 'Asia/Tokyo'
  });
}

// HTML エスケープ
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
