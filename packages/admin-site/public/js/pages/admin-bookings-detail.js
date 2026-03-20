// Admin Bookings Detail Page Script (v2 API対応)

let bookingNumber = null;
let bookingData = null;
let productFormSettingsCache = {}; // 商品フォーム設定のキャッシュ

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', async function() {
  console.log('予約詳細ページを初期化');
  
  try {
    // URLから予約番号を取得
    bookingNumber = getBookingNumberFromUrl();
    
    if (!bookingNumber) {
      window.Utils.showError('予約番号が指定されていません');
      setTimeout(() => {
        window.location.href = '/admin/bookings';
      }, 2000);
      return;
    }
    
    // 予約詳細を読み込み
    await loadBookingDetail();
    
    // 予約変更ボタンのイベント設定
    document.getElementById('editBookingBtn').addEventListener('click', handleEditBooking);
    
    // キャンセルボタンのイベント設定
    document.getElementById('cancelBookingBtn').addEventListener('click', handleCancelBooking);
    
    // メモ保存ボタンのイベント設定
    document.getElementById('saveNotesBtn').addEventListener('click', saveBookingNotes);
    
    // 帳票生成ボタンのイベント設定
    const generateDocumentBtn = document.getElementById('generateDocumentBtnFiles');
    console.log('帳票生成ボタン要素:', generateDocumentBtn);
    if (generateDocumentBtn) {
      generateDocumentBtn.addEventListener('click', function(e) {
        console.log('帳票生成ボタンがクリックされました');
        openGenerateDocumentModal();
      });
      console.log('帳票生成ボタンのイベントリスナーを設定しました');
    } else {
      console.error('帳票生成ボタン（generateDocumentBtnFiles）が見つかりません');
    }
    
    // 帳票生成モーダルのイベント設定
    const closeGenerateDocModalBtn = document.getElementById('closeGenerateDocumentModal');
    if (closeGenerateDocModalBtn) {
      closeGenerateDocModalBtn.addEventListener('click', closeGenerateDocumentModal);
    }
    
    const cancelGenerateDocBtn = document.getElementById('cancelGenerateDocumentBtn');
    if (cancelGenerateDocBtn) {
      cancelGenerateDocBtn.addEventListener('click', closeGenerateDocumentModal);
    }
    
    const templateInput = document.getElementById('templateFileInput');
    if (templateInput) {
      templateInput.addEventListener('change', handleDocumentTemplateChange);
    }
    
    const confirmGenerateDocBtn = document.getElementById('confirmGenerateDocumentBtn');
    if (confirmGenerateDocBtn) {
      confirmGenerateDocBtn.addEventListener('click', handleStartGenerateDocument);
    }
    
    // 追加決済依頼ボタンのイベント設定
    const requestPaymentBtn = document.getElementById('requestPaymentBtn');
    if (requestPaymentBtn) {
      requestPaymentBtn.addEventListener('click', openRequestPaymentModal);
    }
    
    // 追加決済モーダルのイベント設定
    setupRequestPaymentModal();
    
    // メッセージ追加ボタンのイベント設定
    const addMessageBtn = document.getElementById('addMessageBtn');
    if (addMessageBtn) {
      addMessageBtn.addEventListener('click', () => openMessageModal());
    }
    
    // メッセージモーダルのイベント設定
    setupMessageModal();
    
    // ファイル編集モーダルのイベント設定
    setupEditFileModal();
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

// URLから予約番号を取得
function getBookingNumberFromUrl() {
  // クエリパラメータから取得（例: ?number=BK20240201-001 または ?id=BK20240201-001）
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get('number') || urlParams.get('id');
}

// 予約詳細を読み込み
async function loadBookingDetail() {
  try {
    document.getElementById('loading').classList.remove('hidden');
    
    // v2 API呼び出し
    const response = await fetch(`/api/v2/bookings/${bookingNumber}`);
    if (!response.ok) {
      if (response.status === 404) {
        throw new Error('予約が見つかりませんでした');
      }
      throw new Error('予約情報の取得に失敗しました');
    }
    
    const data = await response.json();
    bookingData = data;
    
    if (!bookingData.booking) {
      throw new Error('予約が見つかりませんでした');
    }
    
    // 詳細を表示（非同期関数なのでawaitする）
    await renderBookingDetail(bookingData);
    
    document.getElementById('loading').classList.add('hidden');
    document.getElementById('bookingDetail').classList.remove('hidden');
    
  } catch (error) {
    console.error('予約詳細読み込みエラー:', error);
    window.Utils.showError('予約詳細の読み込みに失敗しました');
    setTimeout(() => {
      window.location.href = '/admin/bookings';
    }, 2000);
  }
}

// 予約詳細を表示
async function renderBookingDetail(data) {
  const { booking, payments, items, refunds } = data;
  
  // 基本情報
  document.getElementById('bookingNumber').textContent = booking.booking_number || '-';
  document.getElementById('bookingStatus').textContent = getBookingStatusText(booking.status);
  document.getElementById('bookingStatus').className = `badge ${getBookingStatusClass(booking.status)}`;
  
  // 最新の決済ステータス
  const latestPayment = payments && payments.length > 0 ? payments[payments.length - 1] : null;
  if (latestPayment) {
    document.getElementById('paymentStatus').textContent = getPaymentStatusText(latestPayment.payment_status, latestPayment.payment_method);
    document.getElementById('paymentStatus').className = `badge ${getPaymentStatusClass(latestPayment.payment_status, latestPayment.payment_method)}`;
  } else {
    document.getElementById('paymentStatus').textContent = '-';
  }
  
  document.getElementById('createdAt').textContent = formatDateTime(booking.created_at);
  
  // イベント情報
  document.getElementById('eventName').textContent = booking.event_name || '-';
  
  // イベント期間
  let eventPeriod = '-';
  if (booking.event_start_date && booking.event_end_date) {
    const startDate = formatDate(booking.event_start_date);
    const endDate = formatDate(booking.event_end_date);
    eventPeriod = startDate === endDate ? startDate : `${startDate} 〜 ${endDate}`;
  } else if (booking.event_start_date) {
    eventPeriod = formatDate(booking.event_start_date);
  }
  document.getElementById('eventPeriod').textContent = eventPeriod;
  
  // クライアント・主催者・担当支店
  document.getElementById('clientName').textContent = booking.client_name || '-';
  document.getElementById('organizerName').textContent = booking.organizer_name || '-';
  document.getElementById('branchName').textContent = booking.branch_name || '-';
  
  // 顧客情報
  document.getElementById('customerName').textContent = booking.customer_name || '-';
  document.getElementById('customerEmail').textContent = booking.customer_email || '-';
  document.getElementById('customerPhone').textContent = booking.customer_phone || booking.customer_tel || '-';
  document.getElementById('customerAddress').textContent = booking.customer_address || '-';
  
  // 予約明細（非同期関数なのでawaitする）
  await renderItems(items || []);
  
  // 決済履歴
  renderPayments(payments || []);
  
  // 返金履歴
  if (refunds && refunds.length > 0) {
    renderRefunds(refunds);
    document.getElementById('refundsCard').classList.remove('hidden');
  }
  
  // 料金情報を表示
  if (data.payment_summary) {
    const summary = data.payment_summary;
    document.getElementById('transactionAmount').textContent = `¥${summary.transaction_amount.toLocaleString()}`;
    document.getElementById('paidAmount').textContent = `¥${summary.paid_amount.toLocaleString()}`;
    document.getElementById('pendingAmount').textContent = `¥${summary.pending_amount.toLocaleString()}`;
    document.getElementById('refundPendingAmount').textContent = `¥${summary.refund_pending_amount.toLocaleString()}`;
    document.getElementById('unbilledAmount').textContent = `¥${summary.unbilled_amount.toLocaleString()}`;
    document.getElementById('refundedAmount').textContent = `¥${summary.refunded_amount.toLocaleString()}`;
    document.getElementById('totalAmount').textContent = `¥${summary.total_amount.toLocaleString()}`;
    
    // 未請求金額 > 0 の場合、追加決済ボタンを表示
    const requestPaymentBtn = document.getElementById('requestPaymentBtn');
    if (requestPaymentBtn && summary.unbilled_amount > 0) {
      requestPaymentBtn.style.display = 'inline-block';
    } else if (requestPaymentBtn) {
      requestPaymentBtn.style.display = 'none';
    }
  }
  
  // キャンセル情報
  if (booking.status === 'canceled' || booking.status === 'fully_canceled') {
    document.getElementById('cancelInfo').style.display = 'block';
    
    // キャンセル日時
    if (booking.modified_at) {
      document.getElementById('canceledAt').textContent = formatDateTime(booking.modified_at);
    }
    
    // キャンセル理由
    if (booking.cancel_reason) {
      document.getElementById('cancelReason').textContent = booking.cancel_reason;
    } else {
      document.getElementById('cancelReason').textContent = '-';
    }
    
    // キャンセル料が設定されている場合
    if (booking.cancellation_fee > 0) {
      // キャンセル料計算情報を取得
      const cancellationInfo = calculateCancellationFeeInfo(booking, items || []);
      
      // ヘッダーとセルを表示
      document.getElementById('cancelParticipationDateHeader').style.display = 'table-cell';
      document.getElementById('cancelParticipationDate').style.display = 'table-cell';
      document.getElementById('cancelDaysUntilHeader').style.display = 'table-cell';
      document.getElementById('cancelDaysUntil').style.display = 'table-cell';
      document.getElementById('cancelRateHeader').style.display = 'table-cell';
      document.getElementById('cancelRate').style.display = 'table-cell';
      document.getElementById('cancellationFeeHeader').style.display = 'table-cell';
      document.getElementById('cancellationFee').style.display = 'table-cell';
      document.getElementById('cancellationFeeStatusHeader').style.display = 'table-cell';
      document.getElementById('cancellationFeeStatus').style.display = 'table-cell';
      
      // 表示
      if (cancellationInfo.participationDate) {
        document.getElementById('cancelParticipationDate').textContent = formatDate(cancellationInfo.participationDate);
      }
      if (cancellationInfo.daysUntil !== null) {
        document.getElementById('cancelDaysUntil').textContent = `${cancellationInfo.daysUntil}日前`;
      }
      document.getElementById('cancelRate').textContent = `${cancellationInfo.rate}%`;
      document.getElementById('cancellationFee').textContent = `¥${booking.cancellation_fee.toLocaleString()}`;
      
      // 支払い状況バッジ
      const isPaid = booking.cancellation_fee_paid === 1;
      const paidBadge = document.getElementById('cancellationFeePaidBadge');
      const markAsPaidSection = document.getElementById('markAsPaidSection');
      
      if (isPaid) {
        paidBadge.textContent = '支払い済み';
        paidBadge.className = 'badge badge-success';
        // 支払い済みの場合はボタンを非表示
        markAsPaidSection.style.display = 'none';
      } else {
        paidBadge.textContent = '未払い';
        paidBadge.className = 'badge badge-warning';
        // 未払いの場合、支払い済みボタンを表示
        markAsPaidSection.style.display = 'block';
      }
    } else {
      // キャンセル料が0円の場合はボタンを非表示
      document.getElementById('markAsPaidSection').style.display = 'none';
    }
  } else {
    // キャンセルされていない場合はセクションを非表示
    document.getElementById('cancelInfo').style.display = 'none';
  }
  
  // キャンセルボタンの表示制御
  const cancelBookingBtn = document.getElementById('cancelBookingBtn');
  if (cancelBookingBtn) {
    if (booking.status === 'active' || booking.status === 'confirmed' || booking.status === 'pending_payment') {
      cancelBookingBtn.classList.remove('hidden');
    } else {
      cancelBookingBtn.classList.add('hidden');
    }
  }
  
  // メモを表示
  document.getElementById('bookingNotes').value = booking.notes || '';
  
  // メッセージを読み込み
  loadMessages();
  
  // メール送信履歴を読み込み
  loadEmails();
}

// 予約明細を表示
async function renderItems(items) {
  const container = document.getElementById('itemsContainer');
  
  if (!items || items.length === 0) {
    container.innerHTML = '<p>明細がありません</p>';
    return;
  }
  
  let html = '';
  
  for (const [index, item] of items.entries()) {
    // 明細ごとにdivで囲む（背景色付き）
    html += '<div class="item-block">';
    // 明細タイトルに価格カテゴリ（大人/子供など）を表示
    const itemTitle = item.price_category 
      ? `${escapeHtml(item.item_name || '-')} (${escapeHtml(item.price_category)})`
      : escapeHtml(item.item_name || '-');
    html += `<h3><i class="fas fa-ticket-alt"></i>明細${index + 1}: ${itemTitle}</h3>`;
    
    html += '<table class="table"><thead><tr>';
    html += '<th>商品名</th><th>数量</th><th>単価</th><th>小計</th><th>参加日</th><th>ステータス</th>';
    html += '</tr></thead><tbody>';
    
    html += '<tr>';
    // 商品名に価格帯名称を追加表示
    const displayName = item.price_category 
      ? `${escapeHtml(item.item_name || '-')} - ${escapeHtml(item.price_category)}`
      : escapeHtml(item.item_name || '-');
    html += `<td>${displayName}</td>`;
    html += `<td>${item.quantity || 0}</td>`;
    html += `<td>¥${(item.unit_price || 0).toLocaleString()}</td>`;
    html += `<td>¥${(item.subtotal || 0).toLocaleString()}</td>`;
    html += `<td>${formatDate(item.participation_date) || '-'}</td>`;
    html += `<td><span class="badge ${getItemStatusClass(item.status)}">${getItemStatusText(item.status)}</span></td>`;
    html += '</tr>';
    html += '</tbody></table>';
    
    // ★★★ 商品の付加情報（category=1）を表示 ★★★
    const productCustomFields = await getProductCustomFields(item.item_id, item.item_type);
    console.log('🔍 [商品付加情報] item_id:', item.item_id, 'productCustomFields:', productCustomFields);
    console.log('🔍 [商品付加情報] item.product_custom_fields:', item.product_custom_fields);
    
    if (productCustomFields && productCustomFields.length > 0) {
      // itemからproduct_custom_fieldsを取得（booking_itemsテーブルのカラム）
      let productCustomData = {};
      if (item.product_custom_fields) {
        try {
          if (typeof item.product_custom_fields === 'string') {
            productCustomData = JSON.parse(item.product_custom_fields);
          } else {
            productCustomData = item.product_custom_fields;
          }
          console.log('🔍 [商品付加情報] productCustomData:', productCustomData);
        } catch (e) {
          console.warn('商品付加情報のパースエラー:', e);
        }
      } else {
        console.log('⚠️ [商品付加情報] item.product_custom_fields is null/undefined');
      }
      
      // 値が存在するフィールドのみ表示
      const fieldsWithValues = productCustomFields.filter(field => {
        return productCustomData[field.field_name] !== undefined && productCustomData[field.field_name] !== '';
      });
      
      console.log('🔍 [商品付加情報] fieldsWithValues:', fieldsWithValues);
      
      if (fieldsWithValues.length > 0) {
        html += '<div style="margin-top: 15px; padding: 12px; background: #fef3c7; border-left: 4px solid #f59e0b; border-radius: 4px;">';
        html += '<strong style="color: #92400e; display: block; margin-bottom: 8px;"><i class="fas fa-info-circle"></i> 商品の付加情報:</strong>';
        html += '<div style="color: #78350f;">';
        
        fieldsWithValues.forEach(field => {
          const value = productCustomData[field.field_name];
          html += `<div style="margin-bottom: 4px;"><strong>${escapeHtml(field.field_label)}:</strong> ${escapeHtml(value)}</div>`;
        });
        
        html += '</div>';
        html += '</div>';
      }
    } else {
      console.log('⚠️ [商品付加情報] No productCustomFields found for item_id:', item.item_id);
    }
    
    // 参加者情報（テーブル形式で詳細表示）
    // オプション商品の場合は参加者情報を表示しない
    console.log(`🔍 [参加者情報] item_id: ${item.item_id}, item_type: ${item.item_type}, item_name: ${item.item_name}`);
    if (item.item_type === 'product' && item.participants) {
      try {
        let participants;
        
        // JSON形式かどうかをチェック
        if (typeof item.participants === 'string') {
          // JSON形式の場合のみパース
          if (item.participants.trim().startsWith('[') || item.participants.trim().startsWith('{')) {
            participants = JSON.parse(item.participants);
          } else {
            // 単純な文字列の場合はスキップ（テーブル表示しない）
            console.log('参加者情報は単純な文字列です:', item.participants);
            participants = null;
          }
        } else {
          participants = item.participants;
        }
        
        if (participants && Array.isArray(participants) && participants.length > 0) {
          // カスタムフィールドのラベルを事前に取得
          const customFieldLabels = await getCustomFieldLabels(item.item_id, item.item_type);
          
          html += '<div style="margin-top: 15px;">';
          html += '<strong style="display: block; margin-bottom: 10px; color: #1e40af;"><i class="fas fa-users"></i> 参加者情報:</strong>';
          html += '<table class="table participants-table" style="margin: 0; background: white; border-collapse: collapse;"><tbody>';
          
          participants.forEach((p, pIndex) => {
            // 1行目: 参加者番号と基本情報
            html += '<tr style="background: #f9fafb; border-top: 2px solid #e5e7eb;">';
            html += `<td rowspan="2" style="width: 80px; text-align: center; vertical-align: middle; font-weight: bold; color: #6b7280; border-right: 1px solid #e5e7eb;">参加者<br>${pIndex + 1}</td>`;
            html += `<td style="padding: 8px;"><strong>姓名（漢字）:</strong></td>`;
            html += `<td style="padding: 8px;">${escapeHtml(p.lastname_kanji || p.lastname || '-')} ${escapeHtml(p.firstname_kanji || p.firstname || '-')}</td>`;
            html += `<td style="padding: 8px;"><strong>姓名（カナ）:</strong></td>`;
            html += `<td style="padding: 8px;">${escapeHtml(p.lastname_kana || '-')} ${escapeHtml(p.firstname_kana || '-')}</td>`;
            html += `<td style="padding: 8px;"><strong>年齢:</strong></td>`;
            html += `<td style="padding: 8px;">${p.age || '-'}</td>`;
            html += `<td style="padding: 8px;"><strong>性別:</strong></td>`;
            html += `<td style="padding: 8px;">${getGenderLabel(p.gender)}</td>`;
            html += '</tr>';
            
            // 2行目: 連絡先と付加情報
            html += '<tr style="background: #ffffff;">';
            html += `<td style="padding: 8px;"><strong>メール:</strong></td>`;
            html += `<td style="padding: 8px;">${escapeHtml(p.email || '-')}</td>`;
            html += `<td style="padding: 8px;"><strong>電話:</strong></td>`;
            html += `<td style="padding: 8px;">${escapeHtml(p.phone || '-')}</td>`;
            html += `<td style="padding: 8px;"><strong>生年月日:</strong></td>`;
            html += `<td style="padding: 8px;">${p.birth_date || p.birth || '-'}</td>`;
            
            // 付加情報（custom_fields）を表示
            html += `<td style="padding: 8px;"><strong>付加情報:</strong></td>`;
            html += '<td style="padding: 8px;">';
            if (p.custom_fields && Object.keys(p.custom_fields).length > 0) {
              const customFieldsArr = Object.entries(p.custom_fields).map(([key, value]) => {
                const label = customFieldLabels[key] || key; // ラベルがあればラベル、なければキー
                return `<div style="margin-bottom: 4px;"><strong>${escapeHtml(label)}:</strong> ${escapeHtml(value)}</div>`;
              });
              html += customFieldsArr.join('');
            } else {
              html += '-';
            }
            html += '</td>';
            html += '</tr>';
            
            // 住所がある場合は3行目を追加
            if (p.address && p.address !== '-') {
              html += '<tr style="background: #ffffff; border-bottom: 1px solid #e5e7eb;">';
              html += `<td colspan="2" style="padding: 8px;"><strong>住所:</strong></td>`;
              html += `<td colspan="7" style="padding: 8px;">${escapeHtml(p.address)}</td>`;
              html += '</tr>';
            }
          });
          
          html += '</tbody></table>';
          html += '</div>';
        }
      } catch (e) {
        console.error('参加者情報のパースエラー:', e);
        // エラーが発生してもスキップして続行
      }
    }
    
    html += '</div>'; // item-block終了
  }
  
  container.innerHTML = html;
}

// 決済履歴を表示
function renderPayments(payments) {
  const container = document.getElementById('paymentsContainer');
  
  if (!payments || payments.length === 0) {
    container.innerHTML = '<p>決済履歴がありません</p>';
    return;
  }
  
  let html = '<table class="table"><thead><tr>';
  html += '<th>決済番号</th><th>種別</th><th>決済方法</th><th>金額</th><th>ステータス</th><th>決済日</th><th style="min-width: 200px;">操作</th>';
  html += '</tr></thead><tbody>';
  
  payments.forEach(payment => {
    html += '<tr>';
    html += `<td>${escapeHtml(payment.payment_number || '-')}</td>`;
    html += `<td>${getPaymentTypeText(payment.payment_type)}</td>`;
    html += `<td>${getPaymentMethodText(payment.payment_method)}</td>`;
    
    // 返金レコードは金額をマイナス表示
    const displayAmount = payment.payment_type === 'refund' 
      ? `-¥${(payment.amount || 0).toLocaleString()}`
      : `¥${(payment.amount || 0).toLocaleString()}`;
    html += `<td>${displayAmount}</td>`;
    
    html += `<td><span class="badge ${getPaymentStatusClass(payment.payment_status, payment.payment_method)}">${getPaymentStatusText(payment.payment_status, payment.payment_method)}</span></td>`;
    html += `<td>${formatDateTime(payment.payment_date) || '-'}</td>`;
    
    // 操作ボタン
    html += '<td><div style="display: flex; gap: 5px; flex-wrap: wrap;">';
    
    // 0円予約（free）の場合は操作ボタンを表示しない
    if (payment.payment_method !== 'free') {
      // 決済待ち → 決済済み
      if (payment.payment_status === 'pending' && payment.payment_type !== 'refund') {
        html += `<button class="btn btn-sm btn-success" onclick="markAsCompleted(${payment.id})" title="決済済みに変更"><i class="fas fa-check"></i> 決済済み</button>`;
      }
      
      // 決済済み → 返金待ち（返金処理）
      if (payment.payment_status === 'completed' && payment.payment_type !== 'refund') {
        html += `<button class="btn btn-sm btn-warning" onclick="initiateRefund(${payment.id}, ${payment.amount})" title="返金処理"><i class="fas fa-undo"></i> 返金</button>`;
      }
      
      // 返金待ち → 返金済み
      if (payment.payment_status === 'refund_pending' && payment.payment_type === 'refund') {
        html += `<button class="btn btn-sm btn-primary" onclick="markAsRefunded(${payment.id})" title="返金済みに変更"><i class="fas fa-check-double"></i> 返金済み</button>`;
      }
      
      // 削除ボタン（決済待ちまたは返金待ちのみ削除可能）
      if (payment.payment_status === 'pending' || payment.payment_status === 'refund_pending') {
        html += `<button class="btn btn-sm btn-danger" onclick="deletePayment(${payment.id})" title="この決済を削除"><i class="fas fa-trash"></i> 削除</button>`;
      }
    } else {
      // 0円予約の場合は「操作不要」と表示
      html += '<span style="color: #059669; font-weight: 500;"><i class="fas fa-check-circle"></i> 操作不要</span>';
    }
    
    html += '</div></td>';
    html += '</tr>';
  });
  
  html += '</tbody></table>';
  container.innerHTML = html;
}

// 返金済みに変更
async function markAsRefunded(paymentId) {
  if (!confirm('この返金を「返金済み」に変更しますか？')) {
    return;
  }
  
  try {
    const response = await fetch(`/api/v2/booking-payments/${paymentId}/status`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        payment_status: 'refunded',
        refund_date: new Date().toISOString().split('T')[0]
      })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'ステータス更新に失敗しました');
    }
    
    window.Utils.showSuccess('返金済みに変更しました');
    // 再読み込み
    location.reload();
  } catch (error) {
    alert('エラー: ' + error.message);
  }
}
window.markAsRefunded = markAsRefunded;

// 決済待ち → 決済済みに変更
async function markAsCompleted(paymentId) {
  if (!confirm('この決済を「決済済み」に変更しますか？\n\n※この操作は、お客様が決済を完了した後に手動で反映する場合に使用します。')) {
    return;
  }
  
  try {
    const response = await fetch(`/api/v2/booking-payments/${paymentId}/status`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        payment_status: 'completed',
        payment_date: new Date().toISOString().split('T')[0]
      })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'ステータス更新に失敗しました');
    }
    
    window.Utils.showSuccess('決済済みに変更しました');
    location.reload();
  } catch (error) {
    alert('エラー: ' + error.message);
  }
}
window.markAsCompleted = markAsCompleted;

// 決済済み → 返金処理
async function initiateRefund(paymentId, amount) {
  const reason = prompt('返金理由を入力してください:\n\n例:\n- お客様都合によるキャンセル\n- イベント中止\n- 商品不具合', '');
  
  if (reason === null) {
    return; // キャンセル
  }
  
  if (!reason.trim()) {
    alert('返金理由を入力してください');
    return;
  }
  
  if (!confirm(`返金処理を実行しますか？\n\n返金額: ¥${amount.toLocaleString()}\n理由: ${reason}\n\n※返金待ちレコードが作成されます。実際の返金処理後に「返金済み」に変更してください。`)) {
    return;
  }
  
  try {
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/refund`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        payment_id: paymentId,
        refund_amount: amount,
        refund_reason: reason,
        refund_date: new Date().toISOString().split('T')[0]
      })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '返金処理に失敗しました');
    }
    
    window.Utils.showSuccess('返金処理を登録しました。返金完了後に「返金済み」に変更してください。');
    location.reload();
  } catch (error) {
    alert('エラー: ' + error.message);
  }
}
window.initiateRefund = initiateRefund;

// 決済削除
async function deletePayment(paymentId) {
  if (!confirm('この決済レコードを削除しますか？\n\n※この操作は取り消せません。\n※決済済みまたは返金済みのレコードは削除できません。')) {
    return;
  }
  
  try {
    const response = await fetch(`/api/v2/booking-payments/${paymentId}`, {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' }
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '決済の削除に失敗しました');
    }
    
    window.Utils.showSuccess('決済レコードを削除しました');
    location.reload();
  } catch (error) {
    alert('エラー: ' + error.message);
  }
}
window.deletePayment = deletePayment;

// 返金履歴を表示
function renderRefunds(refunds) {
  const container = document.getElementById('refundsContainer');
  
  let html = '<table class="table"><thead><tr>';
  html += '<th>返金日</th><th>決済番号</th><th>明細</th><th>返金額</th><th>返金理由</th>';
  html += '</tr></thead><tbody>';
  
  refunds.forEach(refund => {
    html += '<tr>';
    html += `<td>${formatDateTime(refund.refund_date) || '-'}</td>`;
    html += `<td>${escapeHtml(refund.payment_number || '-')}</td>`;
    html += `<td>${escapeHtml(refund.item_name || '全額返金')}</td>`;
    html += `<td>¥${(refund.refund_amount || 0).toLocaleString()}</td>`;
    html += `<td>${getRefundReasonText(refund.refund_reason)}</td>`;
    html += '</tr>';
  });
  
  html += '</tbody></table>';
  container.innerHTML = html;
}

// 予約キャンセル処理
async function handleCancelBooking() {
  const reason = prompt('キャンセル理由を入力してください（任意）:');
  
  if (!confirm('この予約を全てキャンセルしますか？\n\n※クレジットカード決済の場合はGMOでキャンセル処理を行います\n※銀行振込・コンビニ決済で入金済みの場合は返金待ちになります')) {
    return;
  }
  
  try {
    window.Utils.showInfo('キャンセル処理中...');
    
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/cancel`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + btoa('admin:admin')
      },
      body: JSON.stringify({
        cancel_reason: reason || undefined
      })
    });
    
    const result = await response.json();
    
    if (!response.ok) {
      throw new Error(result.error || 'キャンセル処理に失敗しました');
    }
    
    console.log('✅ キャンセル結果:', result);
    
    let message = '予約をキャンセルしました';
    if (result.refund_status === 'refund_pending') {
      message += '\n\n一部の決済は入金済みのため、返金待ちステータスになりました。';
    }
    
    window.Utils.showSuccess(message);
    await loadBookingDetail(); // 再読み込み
  } catch (error) {
    console.error('キャンセルエラー:', error);
    window.Utils.showError('予約のキャンセルに失敗しました: ' + error.message);
  }
}

// ユーティリティ関数

function getBookingStatusText(status) {
  const statusMap = {
    'active': '有効',
    'partially_canceled': '一部キャンセル',
    'fully_canceled': '全キャンセル',
    'completed': '完了',
    'reserved': '予約済み',
    'confirmed': '確定',
    'canceled': 'キャンセル'
  };
  return statusMap[status] || status || '-';
}

function getBookingStatusClass(status) {
  const classMap = {
    'active': 'badge-success',
    'partially_canceled': 'badge-warning',
    'fully_canceled': 'badge-danger',
    'completed': 'badge-info',
    'reserved': 'badge-primary',
    'confirmed': 'badge-success',
    'canceled': 'badge-danger'
  };
  return classMap[status] || 'badge-secondary';
}

function getPaymentStatusText(status, paymentMethod) {
  // 0円予約の場合は「お支払い不要」と表示
  if (paymentMethod === 'free' && status === 'pending') {
    return 'お支払い不要';
  }
  
  const statusMap = {
    'pending': '決済待ち',
    'completed': '決済済み',
    'canceled': '決済取消',
    'refund_pending': '返金待ち',
    'refunded': '返金済み',
    'failed': '決済失敗',
    'expired': '期限切れ',
    'partially_refunded': '一部返金済み'
  };
  return statusMap[status] || status || '-';
}

function getPaymentStatusClass(status, paymentMethod) {
  // 0円予約の場合は成功バッジ（緑色）を表示
  if (paymentMethod === 'free' && status === 'pending') {
    return 'badge-success';
  }
  
  const classMap = {
    'pending': 'badge-warning',
    'completed': 'badge-success',
    'canceled': 'badge-danger',
    'refund_pending': 'badge-warning',
    'refunded': 'badge-info',
    'failed': 'badge-danger',
    'expired': 'badge-secondary',
    'partially_refunded': 'badge-info'
  };
  return classMap[status] || 'badge-secondary';
}

function getPaymentTypeText(type) {
  const typeMap = {
    'immediate': '即時決済',
    'deferred': '後払い',
    'refund': '返金'
  };
  return typeMap[type] || type || '-';
}

function getPaymentMethodText(method) {
  const methodMap = {
    'credit_card': 'クレジットカード',
    'convenience_store': 'コンビニ決済',
    'bank_transfer': '銀行振込',
    'free': '無料',
    'refund': '-'
  };
  return methodMap[method] || method || '-';
}

function getItemStatusText(status) {
  const statusMap = {
    'active': '有効',
    'canceled': 'キャンセル',
    'refunded': '返金済み'
  };
  return statusMap[status] || status || '-';
}

function getItemStatusClass(status) {
  const classMap = {
    'active': 'badge-success',
    'canceled': 'badge-danger',
    'refunded': 'badge-info'
  };
  return classMap[status] || 'badge-secondary';
}

function getRefundReasonText(reason) {
  const reasonMap = {
    'customer_request': '顧客都合',
    'event_canceled': 'イベント中止',
    'error': 'システムエラー'
  };
  return reasonMap[reason] || reason || '-';
}

function formatDate(dateString) {
  if (!dateString) return null;
  try {
    const date = new Date(dateString);
    // 日本時間（JST: UTC+9）で表示
    return date.toLocaleDateString('ja-JP', { timeZone: 'Asia/Tokyo' });
  } catch (e) {
    return dateString;
  }
}

function formatDateTime(dateString) {
  if (!dateString) return null;
  try {
    const date = new Date(dateString);
    // 日本時間（JST: UTC+9）で表示
    return date.toLocaleString('ja-JP', { timeZone: 'Asia/Tokyo' });
  } catch (e) {
    return dateString;
  }
}

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

// 予約変更ボタンのハンドラー
function handleEditBooking() {
  if (!bookingNumber) return;
  
  // 予約変更画面に遷移（今後実装）
  window.location.href = `/bookings-edit.html?id=${bookingNumber}`;
}

// ========================================
// 追加決済依頼モーダル関連
// ========================================

// モーダルのイベントリスナーを設定
function setupRequestPaymentModal() {
  const modal = document.getElementById('requestPaymentModal');
  const closeBtn = document.getElementById('closeRequestPaymentModal');
  const cancelBtn = document.getElementById('cancelRequestPaymentBtn');
  const confirmBtn = document.getElementById('confirmRequestPaymentBtn');
  
  // 閉じるボタン
  if (closeBtn) {
    closeBtn.addEventListener('click', closeRequestPaymentModal);
  }
  
  // キャンセルボタン
  if (cancelBtn) {
    cancelBtn.addEventListener('click', closeRequestPaymentModal);
  }
  
  // 決済依頼を作成ボタン
  if (confirmBtn) {
    confirmBtn.addEventListener('click', handleConfirmRequestPayment);
  }
  
  // モーダル外クリックで閉じる
  if (modal) {
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        closeRequestPaymentModal();
      }
    });
  }
  
  // 決済方法の選択時にボーダーをハイライト
  const paymentMethodRadios = document.querySelectorAll('input[name="paymentMethod"]');
  paymentMethodRadios.forEach(radio => {
    radio.addEventListener('change', function() {
      // すべてのボーダーをリセット
      document.getElementById('paymentMethodCard').style.border = '2px solid #e9ecef';
      document.getElementById('paymentMethodConvenience').style.border = '2px solid #e9ecef';
      document.getElementById('paymentMethodBank').style.border = '2px solid #e9ecef';
      
      // 選択された項目をハイライト
      const selectedDiv = this.closest('div[id^="paymentMethod"]');
      if (selectedDiv) {
        selectedDiv.style.border = '2px solid #0d6efd';
      }
    });
  });
}

// モーダルを開く
function openRequestPaymentModal() {
  if (!bookingData || !bookingData.payment_summary) {
    window.Utils.showError('決済情報の取得に失敗しました');
    return;
  }
  
  const summary = bookingData.payment_summary;
  const booking = bookingData.booking;
  
  // 未請求金額が0以下の場合は開かない
  if (summary.unbilled_amount <= 0) {
    window.Utils.showError('未請求金額がありません');
    return;
  }
  
  // モーダルに情報を設定
  document.getElementById('modalBookingNumber').textContent = booking.booking_number || '-';
  document.getElementById('modalBookerName').textContent = (booking.booker_name || '-') + ' 様';
  document.getElementById('modalEventName').textContent = booking.event_name || '-';
  document.getElementById('modalAmount').textContent = `¥${summary.unbilled_amount.toLocaleString()}`;
  
  // 支払期限を計算（7日後）
  const dueDate = new Date();
  dueDate.setDate(dueDate.getDate() + 7);
  const dueDateStr = `${dueDate.getFullYear()}年${String(dueDate.getMonth() + 1).padStart(2, '0')}月${String(dueDate.getDate()).padStart(2, '0')}日`;
  
  document.getElementById('convenienceDueDate').textContent = dueDateStr + '（7日後）';
  document.getElementById('bankDueDate').textContent = dueDateStr + '（7日後）';
  
  // フォームをリセット
  document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
    radio.checked = false;
  });
  document.getElementById('paymentRemarks').value = '商品追加に伴う追加決済';
  
  // すべてのボーダーをリセット
  document.getElementById('paymentMethodCard').style.border = '2px solid #e9ecef';
  document.getElementById('paymentMethodConvenience').style.border = '2px solid #e9ecef';
  document.getElementById('paymentMethodBank').style.border = '2px solid #e9ecef';
  
  // モーダルを表示
  const modal = document.getElementById('requestPaymentModal');
  modal.classList.add('show');
}

// モーダルを閉じる
function closeRequestPaymentModal() {
  const modal = document.getElementById('requestPaymentModal');
  modal.classList.remove('show');
  modal.classList.remove('show');
}

// 決済依頼を作成
async function handleConfirmRequestPayment() {
  try {
    // 決済方法が選択されているか確認
    const paymentMethodRadio = document.querySelector('input[name="paymentMethod"]:checked');
    if (!paymentMethodRadio) {
      window.Utils.showError('決済方法を選択してください');
      return;
    }
    
    const paymentMethod = paymentMethodRadio.value;
    const remarks = document.getElementById('paymentRemarks').value.trim();
    const summary = bookingData.payment_summary;
    const booking = bookingData.booking;
    
    console.log('決済依頼を作成:', {
      booking_number: booking.booking_number,
      payment_method: paymentMethod,
      amount: summary.unbilled_amount,
      remarks: remarks
    });
    
    // ローディング表示
    window.Utils.showLoading(true);
    
    // API呼び出し
    const response = await fetch('/api/v2/booking-payments', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        booking_number: booking.booking_number,
        payment_type: 'deferred',
        payment_method: paymentMethod,
        amount: summary.unbilled_amount,
        remarks: remarks || null
      })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '決済依頼の作成に失敗しました');
    }
    
    const result = await response.json();
    console.log('決済依頼作成成功:', result);
    
    // モーダルを閉じる
    closeRequestPaymentModal();
    
    // 成功メッセージ
    window.Utils.showSuccess(`決済依頼を作成しました（${result.payment_number}）`);
    
    // 予約詳細を再読み込み
    await loadBookingDetail();
    
    window.Utils.showLoading(false);
    
  } catch (error) {
    console.error('決済依頼作成エラー:', error);
    window.Utils.showLoading(false);
    window.Utils.showError(error.message || '決済依頼の作成に失敗しました');
  }
}

// ========================================
// メッセージ管理機能
// ========================================

let currentEditingMessageId = null;

// メッセージ一覧を読み込み
async function loadMessages() {
  try {
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/messages`);
    
    if (!response.ok) {
      throw new Error('メッセージ一覧の取得に失敗しました');
    }
    
    const data = await response.json();
    renderMessages(data.messages || []);
    
  } catch (error) {
    console.error('メッセージ読み込みエラー:', error);
    document.getElementById('messagesContainer').innerHTML = '<p style="color: #dc3545;">メッセージの読み込みに失敗しました</p>';
  }
}

// メッセージ一覧を表示
function renderMessages(messages) {
  const container = document.getElementById('messagesContainer');
  
  if (!messages || messages.length === 0) {
    container.innerHTML = '<p style="color: #666; text-align: center; padding: 20px;">メッセージはまだ登録されていません</p>';
    return;
  }
  
  let html = '<div class="messages-list">';
  
  messages.forEach(message => {
    const statusBadge = getMessageStatusBadge(message.send_status, message.sent_at);
    // display_on_mypageフィールドは使用しない（常に表示）
    
    html += `
      <div class="message-item" style="border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; margin-bottom: 15px; background: #fff;">
        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 10px;">
          <div style="flex: 1;">
            <h4 style="margin: 0 0 5px 0; font-size: 16px; font-weight: bold;">
              <i class="fas fa-envelope" style="color: #0d6efd; margin-right: 8px;"></i>
              ${escapeHtml(message.title)}
            </h4>
            <div style="font-size: 13px; color: #666;">
              <i class="fas fa-clock" style="margin-right: 5px;"></i>
              表示日時: ${formatDateTime(message.scheduled_send_at)}
              ${statusBadge}
            </div>
          </div>
          <div style="display: flex; gap: 8px;">
            <button class="btn btn-sm btn-secondary" onclick="editMessage(${message.id})" title="編集">
              <i class="fas fa-edit"></i>
            </button>
            <button class="btn btn-sm btn-danger" onclick="deleteMessage(${message.id})" title="削除">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
        <div style="background: #f8f9fa; padding: 12px; border-radius: 4px; white-space: pre-wrap; font-size: 14px; line-height: 1.6; color: #495057;">
          ${escapeHtml(message.message)}
        </div>
        ${message.sent_at ? `
          <div style="font-size: 12px; color: #28a745; margin-top: 8px;">
            <i class="fas fa-check-circle"></i> 送信済み: ${formatDateTime(message.sent_at)}
          </div>
        ` : ''}
      </div>
    `;
  });
  
  html += '</div>';
  container.innerHTML = html;
}

// メッセージステータスバッジを取得
function getMessageStatusBadge(status, sentAt) {
  if (sentAt) {
    return '<span class="badge badge-success">送信済み</span>';
  }
  
  switch (status) {
    case 'pending':
      return '<span class="badge badge-warning">送信待ち</span>';
    case 'sent':
      return '<span class="badge badge-success">送信済み</span>';
    case 'failed':
      return '<span class="badge badge-danger">送信失敗</span>';
    case 'canceled':
      return '<span class="badge badge-secondary">キャンセル</span>';
    default:
      return `<span class="badge badge-secondary">${status}</span>`;
  }
}

// メッセージモーダルのイベント設定
function setupMessageModal() {
  const modal = document.getElementById('messageModal');
  const closeBtn = document.getElementById('closeMessageModal');
  const cancelBtn = document.getElementById('cancelMessageBtn');
  const confirmBtn = document.getElementById('confirmMessageBtn');
  
  // 閉じるボタン
  if (closeBtn) {
    closeBtn.addEventListener('click', closeMessageModal);
  }
  
  // キャンセルボタン
  if (cancelBtn) {
    cancelBtn.addEventListener('click', closeMessageModal);
  }
  
  // 確定ボタン
  if (confirmBtn) {
    confirmBtn.addEventListener('click', handleConfirmMessage);
  }
  
  // モーダル外クリックで閉じる
  if (modal) {
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        closeMessageModal();
      }
    });
  }
  
  // デフォルトの送信日時を設定（明日の10:00）
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  const dateInput = document.getElementById('messageScheduledDate');
  if (dateInput) {
    dateInput.value = tomorrow.toISOString().split('T')[0];
  }
}

// メッセージモーダルを開く
function openMessageModal(messageId = null) {
  currentEditingMessageId = messageId;
  
  const modal = document.getElementById('messageModal');
  const modalTitle = document.getElementById('messageModalTitle');
  const confirmBtnText = document.getElementById('confirmMessageBtnText');
  
  if (messageId) {
    // 編集モード
    modalTitle.textContent = 'メッセージ編集';
    confirmBtnText.textContent = 'メッセージを更新';
    
    // メッセージデータを読み込んで表示
    // TODO: APIから個別メッセージを取得する実装
    
  } else {
    // 新規作成モード
    modalTitle.textContent = 'メッセージ登録';
    confirmBtnText.textContent = 'メッセージを登録';
    
    // フォームをリセット
    document.getElementById('messageTitle').value = '';
    document.getElementById('messageContent').value = '';
    
    // デフォルトの送信日時を設定（明日の10:00）
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    document.getElementById('messageScheduledDate').value = tomorrow.toISOString().split('T')[0];
    document.getElementById('messageScheduledTime').value = '10:00';
  }
  
  // 予約情報を表示
  if (bookingData) {
    document.getElementById('messageModalBookingNumber').textContent = bookingData.booking.booking_number;
    document.getElementById('messageModalBookerName').textContent = bookingData.booking.booker_name || '-';
    document.getElementById('messageModalEmail').textContent = bookingData.booking.booker_email || '-';
  }
  
  // モーダルを表示（showクラスを追加）
  modal.classList.add('show');
}

// メッセージモーダルを閉じる
function closeMessageModal() {
  console.log('closeMessageModal called');
  const modal = document.getElementById('messageModal');
  console.log('modal element:', modal);
  if (modal) {
    console.log('modal classes before remove:', modal.className);
    modal.classList.remove('show');
    console.log('modal classes after remove:', modal.className);
    // フォームをリセット
    const titleEl = document.getElementById('messageTitle');
    const contentEl = document.getElementById('messageContent');
    const dateEl = document.getElementById('messageScheduledDate');
    const timeEl = document.getElementById('messageScheduledTime');
    
    if (titleEl) titleEl.value = '';
    if (contentEl) contentEl.value = '';
    if (dateEl) dateEl.value = '';
    if (timeEl) timeEl.value = '';
    
    currentEditingMessageId = null;
  } else {
    console.error('messageModal element not found!');
  }
}

// メッセージ確定処理
async function handleConfirmMessage() {
  try {
    window.Utils.showLoading(true);
    
    // 入力値を取得
    const title = document.getElementById('messageTitle').value.trim();
    const message = document.getElementById('messageContent').value.trim();
    const scheduledDate = document.getElementById('messageScheduledDate').value;
    const scheduledTime = document.getElementById('messageScheduledTime').value;
    
    // バリデーション
    if (!title) {
      window.Utils.showError('タイトルを入力してください');
      window.Utils.showLoading(false);
      return;
    }
    
    if (!message) {
      window.Utils.showError('メッセージを入力してください');
      window.Utils.showLoading(false);
      return;
    }
    
    if (!scheduledDate) {
      window.Utils.showError('送信日を選択してください');
      window.Utils.showLoading(false);
      return;
    }
    
    if (!scheduledTime) {
      window.Utils.showError('送信時刻を入力してください');
      window.Utils.showLoading(false);
      return;
    }
    
    // 送信日時を作成（YYYY-MM-DD HH:MM:SS形式）
    const scheduledSendAt = `${scheduledDate} ${scheduledTime}:00`;
    
    if (currentEditingMessageId) {
      // 更新
      const response = await fetch(`/api/v2/booking-messages/${currentEditingMessageId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          title,
          message,
          scheduled_send_at: scheduledSendAt
        })
      });
      
      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'メッセージの更新に失敗しました');
      }
      
      window.Utils.showSuccess('メッセージを更新しました');
      
    } else {
      // 新規作成
      const response = await fetch(`/api/v2/bookings/${bookingNumber}/messages`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          title,
          message,
          scheduled_send_at: scheduledSendAt
        })
      });
      
      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'メッセージの作成に失敗しました');
      }
      
      window.Utils.showSuccess('メッセージを登録しました');
    }
    
    // メッセージ一覧を再読み込み
    await loadMessages();
    
    window.Utils.showLoading(false);
    
    // モーダルを閉じる（成功後に閉じる）
    closeMessageModal();
    
  } catch (error) {
    console.error('メッセージ処理エラー:', error);
    window.Utils.showLoading(false);
    window.Utils.showError(error.message || 'メッセージの処理に失敗しました');
  }
}

// メッセージを編集
async function editMessage(messageId) {
  try {
    // メッセージ情報を取得
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/messages`);
    if (!response.ok) {
      throw new Error('メッセージ情報の取得に失敗しました');
    }
    
    const data = await response.json();
    const message = data.messages.find(m => m.id === messageId);
    
    if (!message) {
      throw new Error('メッセージが見つかりません');
    }
    
    // モーダルのタイトルを変更
    document.getElementById('messageModalTitle').textContent = 'メッセージ編集';
    document.getElementById('confirmMessageBtnText').textContent = 'メッセージを更新';
    
    // フォームに値を設定
    document.getElementById('messageTitle').value = message.title || '';
    document.getElementById('messageContent').value = message.message || '';
    
    // scheduled_send_at を日付と時刻に分割
    if (message.scheduled_send_at) {
      const dateTime = new Date(message.scheduled_send_at);
      const dateStr = dateTime.toISOString().split('T')[0];
      const timeStr = dateTime.toTimeString().slice(0, 5);
      document.getElementById('messageScheduledDate').value = dateStr;
      document.getElementById('messageScheduledTime').value = timeStr;
    }
    
    // 編集モードフラグを設定
    currentEditingMessageId = messageId;
    
    // モーダルを表示
    const modal = document.getElementById('messageModal');
    modal.classList.add('show');
    
  } catch (error) {
    console.error('編集エラー:', error);
    alert('メッセージの編集準備に失敗しました: ' + error.message);
  }
}

// メッセージを削除
async function deleteMessage(messageId) {
  if (!confirm('このメッセージを削除してもよろしいですか？')) {
    return;
  }
  
  try {
    window.Utils.showLoading(true);
    
    const response = await fetch(`/api/v2/booking-messages/${messageId}`, {
      method: 'DELETE'
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'メッセージの削除に失敗しました');
    }
    
    window.Utils.showSuccess('メッセージを削除しました');
    
    // メッセージ一覧を再読み込み
    await loadMessages();
    
    window.Utils.showLoading(false);
    
  } catch (error) {
    console.error('メッセージ削除エラー:', error);
    window.Utils.showLoading(false);
    window.Utils.showError(error.message || 'メッセージの削除に失敗しました');
  }
}

// ========================================
// 帳票生成機能
// ========================================

let selectedDocumentTemplate = null;
let currentGenerateJobId = null;

// 帳票生成モーダルを開く
function openGenerateDocumentModal() {
  if (!bookingData || !bookingData.booking) {
    window.Utils.showError('予約情報が取得できません');
    return;
  }
  
  const modal = document.getElementById('generateDocumentModal');
  const modalBookingNumber = document.getElementById('docModalBookingNumber');
  const modalBookerName = document.getElementById('docModalBookerName');
  const modalEventName = document.getElementById('docModalEventName');
  
  if (modal) {
    // 予約情報を表示（bookingData.bookingからアクセス）
    const booking = bookingData.booking;
    if (modalBookingNumber) modalBookingNumber.textContent = booking.booking_number || '-';
    if (modalBookerName) modalBookerName.textContent = booking.booker_name || booking.customer_name || '-';
    if (modalEventName) modalEventName.textContent = booking.event_name || '-';
    
    modal.classList.add('show');
    
    // 初期化
    selectedDocumentTemplate = null;
    const templateInput = document.getElementById('templateFileInput');
    if (templateInput) {
      templateInput.value = '';
    }
    document.getElementById('confirmGenerateDocumentBtn').disabled = true;
    document.getElementById('documentProgress').style.display = 'none';
    document.getElementById('documentSuccess').style.display = 'none';
    document.getElementById('documentError').style.display = 'none';
  }
}

// 帳票生成モーダルを閉じる
function closeGenerateDocumentModal() {
  const modal = document.getElementById('generateDocumentModal');
  if (modal) {
    modal.classList.remove('show');
  }
  
  // ジョブのポーリングを停止
  if (currentGenerateJobId) {
    currentGenerateJobId = null;
  }
}

// テンプレートファイル選択時
function handleDocumentTemplateChange(event) {
  const file = event.target.files[0];
  const startBtn = document.getElementById('confirmGenerateDocumentBtn');
  
  if (file) {
    selectedDocumentTemplate = file;
    if (startBtn) startBtn.disabled = false;
  } else {
    selectedDocumentTemplate = null;
    if (startBtn) startBtn.disabled = true;
  }
}

// 帳票生成開始
async function handleStartGenerateDocument() {
  if (!selectedDocumentTemplate) {
    window.Utils.showError('Excelテンプレートを選択してください');
    return;
  }
  
  if (!bookingNumber) {
    window.Utils.showError('予約番号が取得できません');
    return;
  }
  
  try {
    // ボタンを無効化
    document.getElementById('confirmGenerateDocumentBtn').disabled = true;
    document.getElementById('cancelGenerateDocumentBtn').disabled = true;
    
    // 進捗表示
    document.getElementById('documentProgress').style.display = 'block';
    document.getElementById('documentSuccess').style.display = 'none';
    document.getElementById('documentError').style.display = 'none';
    
    // FormData作成
    const formData = new FormData();
    formData.append('excel_template', selectedDocumentTemplate);
    
    // 予約番号のみのCSVを動的生成
    const csvContent = `予約番号\n${bookingNumber}`;
    const csvBlob = new Blob([csvContent], { type: 'text/csv;charset=utf-8' });
    formData.append('booking_csv', csvBlob, 'booking.csv');
    
    console.log('帳票生成API呼び出し開始:', bookingNumber);
    
    // 既存の一括生成APIを使用
    const response = await fetch('/api/v2/bulk-documents/generate', {
      method: 'POST',
      body: formData
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '帳票生成の開始に失敗しました');
    }
    
    const result = await response.json();
    console.log('帳票生成開始成功:', result);
    
    currentGenerateJobId = result.job_id;
    
    // 進捗をポーリング
    pollGenerateJobStatus(result.job_id);
    
  } catch (error) {
    console.error('帳票生成エラー:', error);
    
    // エラー表示
    document.getElementById('documentProgress').style.display = 'none';
    document.getElementById('documentError').style.display = 'block';
    document.getElementById('documentErrorMessage').textContent = error.message || '帳票生成に失敗しました';
    
    // ボタンを元に戻す
    document.getElementById('confirmGenerateDocumentBtn').disabled = false;
    document.getElementById('cancelGenerateDocumentBtn').disabled = false;
  }
}

// ジョブステータスをポーリング
async function pollGenerateJobStatus(jobId) {
  let attempts = 0;
  const maxAttempts = 120; // 最大4分（2秒×120回）
  
  const checkStatus = async () => {
    if (currentGenerateJobId !== jobId) {
      // モーダルが閉じられた場合は停止
      return;
    }
    
    try {
      const response = await fetch(`/api/v2/bulk-documents/status/${jobId}`);
      
      if (!response.ok) {
        throw new Error('ステータスの取得に失敗しました');
      }
      
      const status = await response.json();
      console.log('ジョブステータス:', status);
      
      // 完了チェック
      if (status.status === 'completed') {
        console.log('帳票生成完了:', status.results);
        
        const result = status.results[0];
        if (result && result.status === 'success') {
          // 成功表示
          document.getElementById('documentProgress').style.display = 'none';
          document.getElementById('documentSuccess').style.display = 'block';
          
          // 2秒後にモーダルを閉じて添付ファイル一覧を再読み込み
          setTimeout(async () => {
            closeGenerateDocumentModal();
            await loadBookingFiles(); // 添付ファイル一覧を再読み込み
          }, 2000);
          
        } else if (result && result.status === 'error') {
          throw new Error(result.error || '帳票生成に失敗しました');
        }
        
        return;
      }
      
      if (status.status === 'failed') {
        throw new Error(status.error || '帳票生成に失敗しました');
      }
      
      // 次のチェック
      attempts++;
      if (attempts < maxAttempts) {
        setTimeout(checkStatus, 2000);
      } else {
        throw new Error('処理がタイムアウトしました');
      }
      
    } catch (error) {
      console.error('ステータスチェックエラー:', error);
      
      // エラー表示
      document.getElementById('documentProgress').style.display = 'none';
      document.getElementById('documentError').style.display = 'block';
      document.getElementById('documentErrorMessage').textContent = error.message || '帳票生成に失敗しました';
      
      // ボタンを元に戻す
      document.getElementById('confirmGenerateDocumentBtn').disabled = false;
      document.getElementById('cancelGenerateDocumentBtn').disabled = false;
    }
  };
  
  // 初回チェック
  checkStatus();
}

// ========================================
// メール送信履歴機能
// ========================================

// メール送信履歴を読み込み
async function loadEmails() {
  try {
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/emails`);
    
    if (!response.ok) {
      throw new Error('メール送信履歴の取得に失敗しました');
    }
    
    const data = await response.json();
    displayEmails(data.emails || []);
    
  } catch (error) {
    console.error('メール送信履歴読み込みエラー:', error);
    document.getElementById('emailsContainer').innerHTML = '<p style="color: #dc3545;">メール送信履歴の読み込みに失敗しました</p>';
  }
}

// メール送信履歴を表示
function displayEmails(emails) {
  const container = document.getElementById('emailsContainer');
  
  if (!emails || emails.length === 0) {
    container.innerHTML = `
      <p style="text-align: center; color: #666; padding: 20px;">
        <i class="fas fa-envelope" style="font-size: 48px; opacity: 0.3; display: block; margin-bottom: 10px;"></i>
        メール送信履歴はありません
      </p>
    `;
    return;
  }
  
  let html = '<div style="display: flex; flex-direction: column; gap: 15px;">';
  
  emails.forEach(email => {
    const statusBadge = getEmailStatusBadge(email.send_status);
    const sentDate = email.sent_at ? formatDateTime(email.sent_at) : '-';
    const scheduledDate = email.scheduled_send_at ? formatDateTime(email.scheduled_send_at) : '-';
    
    html += `
      <div style="border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; background: #f8f9fa;">
        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 10px;">
          <div style="flex: 1;">
            <div style="font-size: 14px; font-weight: bold; margin-bottom: 5px;">
              ${email.subject || '(件名なし)'}
            </div>
            <div style="font-size: 12px; color: #666;">
              <i class="fas fa-paper-plane"></i> 送信先: ${email.to_email || '-'}
            </div>
          </div>
          <div style="display: flex; gap: 8px; align-items: center;">
            ${statusBadge}
            ${email.send_status !== 'sent' ? `
              <button 
                onclick="deleteEmail(${email.id})" 
                class="btn btn-sm btn-danger"
                style="padding: 4px 8px; font-size: 12px;"
                title="削除">
                <i class="fas fa-trash"></i>
              </button>
            ` : ''}
          </div>
        </div>
        
        <div style="font-size: 13px; color: #666; line-height: 1.6; margin-bottom: 10px;">
          ${email.body ? email.body.substring(0, 100) + (email.body.length > 100 ? '...' : '') : ''}
        </div>
        
        <div style="display: flex; gap: 15px; font-size: 12px; color: #666;">
          <div>
            <i class="fas fa-clock"></i> 送信予定: ${scheduledDate}
          </div>
          ${email.send_status === 'sent' ? `
            <div>
              <i class="fas fa-check"></i> 送信完了: ${sentDate}
            </div>
          ` : ''}
        </div>
      </div>
    `;
  });
  
  html += '</div>';
  
  container.innerHTML = html;
}

// メール送信ステータスのバッジを取得
function getEmailStatusBadge(status) {
  const badges = {
    'pending': '<span style="background: #ffc107; color: #000; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;">送信待ち</span>',
    'sent': '<span style="background: #28a745; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;">送信済み</span>',
    'failed': '<span style="background: #dc3545; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;">送信失敗</span>',
    'canceled': '<span style="background: #6c757d; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;">キャンセル</span>'
  };
  
  return badges[status] || '<span style="background: #6c757d; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;">不明</span>';
}

// メール削除
async function deleteEmail(emailId) {
  if (!confirm('このメールを削除しますか？')) {
    return;
  }
  
  try {
    const response = await fetch(`/api/v2/booking-emails/${emailId}`, {
      method: 'DELETE'
    });
    
    if (!response.ok) {
      throw new Error('メールの削除に失敗しました');
    }
    
    window.Utils.showSuccess('メールを削除しました');
    
    // メール一覧を再読み込み
    loadEmails();
    
  } catch (error) {
    console.error('メール削除エラー:', error);
    window.Utils.showError(error.message || 'メールの削除に失敗しました');
  }
}

// ========================================
// メモ保存機能
// ========================================

// メモを保存
async function saveBookingNotes() {
  try {
    const notes = document.getElementById('bookingNotes').value.trim();
    
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/notes`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ notes })
    });
    
    if (!response.ok) {
      throw new Error('メモの保存に失敗しました');
    }
    
    window.Utils.showSuccess('メモを保存しました');
    
  } catch (error) {
    console.error('メモ保存エラー:', error);
    window.Utils.showError(error.message || 'メモの保存に失敗しました');
  }
}

// ========================================
// ファイル編集モーダル
// ========================================

// ファイル編集モーダルのセットアップ
function setupEditFileModal() {
  const modal = document.getElementById('editFileModal');
  const closeBtn = document.getElementById('closeEditModal');
  const cancelBtn = document.getElementById('cancelEditBtn');
  const saveBtn = document.getElementById('saveEditBtn');
  
  // 閉じるボタン
  if (closeBtn) {
    closeBtn.addEventListener('click', closeEditFileModal);
  }
  
  // キャンセルボタン
  if (cancelBtn) {
    cancelBtn.addEventListener('click', closeEditFileModal);
  }
  
  // 保存ボタン
  if (saveBtn) {
    saveBtn.addEventListener('click', saveEditFile);
  }
  
  // モーダル外クリックで閉じる
  if (modal) {
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        closeEditFileModal();
      }
    });
  }
  
  // 無制限チェックボックスの動作
  const unlimitedCheck = document.getElementById('editUnlimitedCheck');
  const downloadLimit = document.getElementById('editDownloadLimit');
  
  if (unlimitedCheck && downloadLimit) {
    unlimitedCheck.addEventListener('change', function() {
      if (this.checked) {
        downloadLimit.value = 0;
        downloadLimit.disabled = true;
      } else {
        downloadLimit.disabled = false;
      }
    });
  }
}

// ファイル編集モーダルを開く
function openEditFileModal(fileId, displayName, downloadLimit) {
  const modal = document.getElementById('editFileModal');
  
  if (!modal) {
    console.error('ファイル編集モーダルが見つかりません');
    return;
  }
  
  // フォームに値をセット
  document.getElementById('editFileId').value = fileId;
  document.getElementById('editDisplayFilename').value = displayName || '';
  document.getElementById('editDownloadLimit').value = downloadLimit || 0;
  
  // 無制限チェックボックスの状態を設定
  const unlimitedCheck = document.getElementById('editUnlimitedCheck');
  const downloadLimitInput = document.getElementById('editDownloadLimit');
  
  if (downloadLimit === 0 || downloadLimit === null) {
    unlimitedCheck.checked = true;
    downloadLimitInput.disabled = true;
  } else {
    unlimitedCheck.checked = false;
    downloadLimitInput.disabled = false;
  }
  
  // エラーメッセージをクリア
  const errorDiv = document.getElementById('editError');
  if (errorDiv) {
    errorDiv.style.display = 'none';
    errorDiv.textContent = '';
  }
  
  // モーダルを表示
  modal.classList.add('show');
}

// ファイル編集モーダルを閉じる
function closeEditFileModal() {
  const modal = document.getElementById('editFileModal');
  
  if (modal) {
    modal.classList.remove('show');
  }
  
  // キャンセル時はフォームをリセットしない（保存せずに閉じる）
}

// ファイル編集を保存
async function saveEditFile() {
  try {
    const fileId = document.getElementById('editFileId').value;
    const displayName = document.getElementById('editDisplayFilename').value.trim();
    const downloadLimit = document.getElementById('editUnlimitedCheck').checked 
      ? 0 
      : parseInt(document.getElementById('editDownloadLimit').value);
    
    // バリデーション
    if (!displayName) {
      throw new Error('表示ファイル名を入力してください');
    }
    
    // API呼び出し（実装が必要）
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/files/${fileId}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        display_filename: displayName,
        download_limit: downloadLimit
      })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'ファイル情報の更新に失敗しました');
    }
    
    window.Utils.showSuccess('ファイル情報を更新しました');
    
    // 保存成功時のみフォームをリセット
    const form = document.getElementById('editFileForm');
    if (form) {
      form.reset();
    }
    
    closeEditFileModal();
    
    // ファイル一覧を再読み込み
    await loadBookingDetail();
    
  } catch (error) {
    console.error('ファイル編集エラー:', error);
    const errorDiv = document.getElementById('editError');
    if (errorDiv) {
      errorDiv.textContent = error.message;
      errorDiv.style.display = 'block';
    }
  }
}

// ========================================
// 表示用ヘルパー関数
// ========================================

/**
 * 性別コードをラベルに変換
 * @param {string|number} gender - 性別コード (1: 男性, 2: 女性)
 * @returns {string} - 性別ラベル
 */
function getGenderLabel(gender) {
  if (!gender) return '-';
  const genderStr = String(gender);
  
  const genderMap = {
    '1': '男性',
    '2': '女性',
    'male': '男性',
    'female': '女性',
    '男性': '男性',
    '女性': '女性'
  };
  
  return genderMap[genderStr] || gender;
}

/**
 * カスタムフィールドのラベルを取得
 * @param {number} itemId - 商品ID
 * @param {string} itemType - アイテムタイプ ('product' or 'option')
 * @returns {Promise<Object>} - {radio_1: "朝食", radio_2: "シャツ色"} の形式
 */
async function getCustomFieldLabels(itemId, itemType) {
  // オプション商品の場合はラベル取得をスキップ
  if (itemType !== 'product') {
    return {};
  }
  
  // キャッシュがあればそれを返す（参加者用）
  const cacheKey = `participant_${itemId}`;
  if (productFormSettingsCache[cacheKey]) {
    return productFormSettingsCache[cacheKey];
  }
  
  try {
    const response = await fetch(`/api/auth/product-form-settings/${itemId}`);
    if (!response.ok) {
      console.warn(`商品 ${itemId} のフォーム設定取得に失敗:`, response.status);
      return {};
    }
    
    const data = await response.json();
    const labels = {};
    
    // custom_fields から category=2 のラベルをマッピング（参加者用）
    if (data.custom_fields && Array.isArray(data.custom_fields)) {
      data.custom_fields.forEach(field => {
        if (field.category === 2 && field.field_name && field.field_label) {
          labels[field.field_name] = field.field_label;
        }
      });
    }
    
    // キャッシュに保存
    productFormSettingsCache[cacheKey] = labels;
    
    return labels;
  } catch (error) {
    console.error('カスタムフィールドラベル取得エラー:', error);
    return {};
  }
}

/**
 * 商品の付加情報（category=1）を取得
 * @param {number} itemId - 商品ID
 * @param {string} itemType - アイテムタイプ
 * @returns {Promise<Array>} - [{field_name, field_label, field_type, field_options}, ...]
 */
async function getProductCustomFields(itemId, itemType) {
  // オプション商品の場合はスキップ
  if (itemType !== 'product') {
    return [];
  }
  
  // キャッシュがあればそれを返す（商品用）
  const cacheKey = `product_${itemId}`;
  if (productFormSettingsCache[cacheKey]) {
    return productFormSettingsCache[cacheKey];
  }
  
  try {
    const response = await fetch(`/api/auth/product-form-settings/${itemId}`);
    if (!response.ok) {
      console.warn(`商品 ${itemId} のフォーム設定取得に失敗:`, response.status);
      return [];
    }
    
    const data = await response.json();
    const productFields = [];
    
    // custom_fields から category=1 のフィールドを抽出（商品用）
    if (data.custom_fields && Array.isArray(data.custom_fields)) {
      data.custom_fields.forEach(field => {
        if (field.category === 1) {
          productFields.push({
            field_name: field.field_name,
            field_label: field.field_label,
            field_type: field.field_type,
            field_options: field.field_options
          });
        }
      });
    }
    
    // キャッシュに保存
    productFormSettingsCache[cacheKey] = productFields;
    
    return productFields;
  } catch (error) {
    console.error('商品付加情報取得エラー:', error);
    return [];
  }
}

// ========================================
// キャンセル料計算関数
// ========================================
function calculateCancellationFeeInfo(booking, items) {
  // 最も近い参加日を取得
  const participationDates = items
    .map(item => item.participation_date)
    .filter(date => date)
    .sort();
  
  if (participationDates.length === 0) {
    return {
      participationDate: null,
      daysUntil: null,
      rate: 0
    };
  }
  
  const nearestDate = participationDates[0];
  
  // キャンセル日（modified_at）を使用
  const cancelDate = new Date(booking.modified_at || booking.created_at);
  cancelDate.setHours(0, 0, 0, 0);
  
  const participationDate = new Date(nearestDate + 'T00:00:00');
  const daysUntil = Math.floor((participationDate - cancelDate) / (1000 * 60 * 60 * 24));
  
  // キャンセル料率を取得
  const days1 = booking.cancellation_days_1 || 0;
  const rate1 = booking.cancellation_rate_1 || 100;
  const days2 = booking.cancellation_days_2 || 1;
  const rate2 = booking.cancellation_rate_2 || 10;
  const days3 = booking.cancellation_days_3 || 10;
  const rate3 = booking.cancellation_rate_3 || 1;
  
  let rate = 0;
  
  if (daysUntil > days3) {
    rate = 0;
  } else if (daysUntil > days2) {
    rate = rate3;
  } else if (daysUntil > days1) {
    rate = rate2;
  } else {
    rate = rate1;
  }
  
  return {
    participationDate: nearestDate,
    daysUntil,
    rate
  };
}

// ========================================
// キャンセル料支払い済みマーク
// ========================================
async function markCancellationFeePaid() {
  if (!bookingNumber) return;
  
  if (!confirm('このキャンセル料を「支払い済み」としてマークしますか？\n\n※この操作は取り消しできません')) {
    return;
  }
  
  try {
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/mark-cancellation-fee-paid`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + btoa('admin:admin')
      }
    });
    
    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.error || '更新に失敗しました');
    }
    
    window.Utils.showSuccess('キャンセル料を「支払い済み」にしました');
    await loadBookingDetail(); // 再読み込み
  } catch (error) {
    console.error('支払い済みマークエラー:', error);
    window.Utils.showError('支払い済みマークに失敗しました: ' + error.message);
  }
}

// イベントリスナー設定
document.addEventListener('DOMContentLoaded', () => {
  const markFeePaidBtn = document.getElementById('markFeePaidBtn');
  if (markFeePaidBtn) {
    markFeePaidBtn.addEventListener('click', markCancellationFeePaid);
  }
});

