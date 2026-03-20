/**
 * Admin Bookings Edit Page Script
 * 予約変更画面
 * Updated: 2026-03-04 - Fixed gender and custom fields
 */

let bookingNumber = null;
let bookingData = null;
let bookingItems = []; // 予約明細リスト（既存 + 新規追加）
let formFields = {}; // 商品ごとのフォームフィールド設定
let productFieldSettings = {}; // 商品ごとのform_field_settings（参加者入力項目）

// 参加者データを新形式に変換（後方互換性）
function migrateParticipantData(participant) {
  // 既に新形式の場合はそのまま返す
  if (participant.lastname_kanji !== undefined) {
    return participant;
  }
  
  // 旧形式を新形式に変換
  return {
    lastname_kanji: participant.lastname || '',
    firstname_kanji: participant.firstname || '',
    lastname_kana: participant.lastname_kana || '',
    firstname_kana: participant.firstname_kana || '',
    lastname_roman: participant.lastname_roman || '',
    firstname_roman: participant.firstname_roman || '',
    age: participant.age || null,
    gender: participant.gender || '',
    email: participant.email || '',
    phone: participant.phone || '',
    birth_date: participant.birth || participant.birth_date || '',
    address: participant.address || '',
    custom_fields: participant.custom_fields || {}
  };
}

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', async function() {
  console.log('🚀 [v1772607400000] 予約変更ページを初期化');
  
  try {
    // URLから予約番号を取得
    const urlParams = new URLSearchParams(window.location.search);
    bookingNumber = urlParams.get('id');
    
    if (!bookingNumber) {
      showError('予約番号が指定されていません');
      setTimeout(() => {
        window.location.href = '/admin/bookings';
      }, 2000);
      return;
    }
    
    // 戻るボタンとキャンセルボタンのリンク設定
    document.getElementById('backToDetailBtn').href = `/bookings-detail.html?id=${bookingNumber}`;
    document.getElementById('cancelBtn').href = `/bookings-detail.html?id=${bookingNumber}`;
    
    // 予約データを読み込み
    await loadBookingData();
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    showError('ページの初期化に失敗しました');
  }
});

// 予約データを読み込み
async function loadBookingData() {
  try {
    showLoading(true);
    
    console.log('Loading booking data for:', bookingNumber);
    
    // v2 API呼び出し（編集用データ取得）
    const response = await fetch(`/api/v2/bookings/${bookingNumber}/edit-data`);
    if (!response.ok) {
      if (response.status === 404) {
        throw new Error('予約が見つかりません');
      }
      throw new Error('予約の読み込みに失敗しました');
    }
    
    bookingData = await response.json();
    console.log('Booking data loaded:', bookingData);
    
    // bookingItemsを初期化
    bookingItems = bookingData.items ? [...bookingData.items] : [];
    console.log('bookingItems initialized:', bookingItems.length);
    
    // 基本情報を表示
    document.getElementById('bookingNumber').textContent = bookingData.booking.booking_number;
    document.getElementById('eventName').textContent = bookingData.booking.event_name || '-';
    document.getElementById('bookerName').textContent = bookingData.booking.booker_name || '-';
    document.getElementById('bookerEmail').textContent = bookingData.booking.booker_email || '-';
    
    // 各商品のform_field_settingsを取得（renderBookingItemsの前に実行）
    const productIds = [...new Set(bookingItems
      .filter(item => item.item_type === 'product' && item.item_id)
      .map(item => item.item_id))];
    
    console.log('取得する商品ID一覧:', productIds);
    
    for (const productId of productIds) {
      try {
        const productResponse = await fetch(`/api/products/${productId}`);
        if (productResponse.ok) {
          const productData = await productResponse.json();
          if (productData.product && productData.product.form_field_settings) {
            productFieldSettings[productId] = productData.product.form_field_settings;
            console.log(`商品ID ${productId} の参加者情報設定を取得:`, productFieldSettings[productId]);
          }
        }
      } catch (error) {
        console.error(`商品ID ${productId} の設定取得エラー:`, error);
      }
    }
    
    console.log('全商品の参加者情報設定:', productFieldSettings);
    
    // 予約明細と参加者情報を表示（商品設定取得後に実行）
    await renderBookingItems();
    
    // フォームを表示
    document.getElementById('editForm').classList.remove('hidden');
    
    // イベントリスナーを設定（フォーム表示後）
    setupEventListeners();
    
    showLoading(false);
    
  } catch (error) {
    console.error('予約データ読み込みエラー:', error);
    showError(error.message || '予約データの読み込みに失敗しました');
    showLoading(false);
  }
}

// 予約明細と参加者情報を表示
async function renderBookingItems() {
  const container = document.getElementById('bookingItemsContainer');
  container.innerHTML = '';
  
  if (!bookingItems || bookingItems.length === 0) {
    container.innerHTML = '<p>予約明細がありません</p>';
    return;
  }
  
  // formFieldsMapをグローバル変数に格納
  console.log('bookingData.formFieldsMap:', bookingData.formFieldsMap);
  for (const itemId in bookingData.formFieldsMap) {
    formFields[itemId] = bookingData.formFieldsMap[itemId];
    console.log(`Loaded ${bookingData.formFieldsMap[itemId].length} fields for itemId: ${itemId}`);
  }
  
  // product_id でもアクセスできるようにマッピングを追加（重要：これがないとカスタムフィールドが表示されない）
  console.log('🔄 Starting product_id mapping for', bookingItems.length, 'items');
  for (const item of bookingItems) {
    console.log('Processing item:', { id: item.id, product_id: item.product_id, hasFields: !!formFields[item.id] });
    if (item.product_id && formFields[item.id]) {
      formFields[item.product_id] = formFields[item.id];
      console.log(`✅ Mapped product_id ${item.product_id} -> itemId ${item.id} (${formFields[item.id].length} fields)`);
    } else {
      console.warn(`⚠️ Cannot map item ${item.id}: product_id=${item.product_id}, hasFields=${!!formFields[item.id]}`);
    }
  }
  
  console.log('📦 formFields after loading (including product_id mapping):', formFields);
  console.log('Keys in formFields:', Object.keys(formFields));
  
  for (const item of bookingItems) {
    const itemCard = createBookingItemCard(item);
    container.appendChild(itemCard);
  }
}

// 予約明細カードを作成
function createBookingItemCard(item) {
  const card = document.createElement('div');
  card.className = 'admin-card mb-3';
  card.dataset.itemId = item.id;
  
  let participants = [];
  try {
    participants = JSON.parse(item.participants || '[]');
    // 旧形式データを新形式に変換
    participants = participants.map(p => migrateParticipantData(p));
  } catch (e) {
    participants = [];
  }
  
  // カードヘッダー
  const header = document.createElement('div');
  header.className = 'card-header';
  
  // 商品名表示（価格帯名称を含む）
  const displayName = item.price_category 
    ? `${escapeHtml(item.item_name || item.product_name || '商品名なし')} - ${escapeHtml(item.price_category)}`
    : escapeHtml(item.item_name || item.product_name || '商品名なし');
  
  header.innerHTML = `
    <h3 class="card-title">
      <i class="fas fa-ticket-alt"></i>
      ${displayName}
    </h3>
    <div style="display: flex; gap: 1rem; align-items: center;">
      <div style="font-size: 0.875rem; color: #6b7280;">
        参加日: <input type="date" 
          class="form-control" 
          style="display: inline-block; width: auto; padding: 0.25rem 0.5rem;" 
          value="${item.participation_date || ''}"
          data-item-id="${item.id}"
          onchange="updateParticipationDate('${item.id}', this.value)">
      </div>
      <div style="font-size: 0.875rem; color: #6b7280;">
        予約数: 
        <input type="number" 
          class="form-control" 
          style="display: inline-block; width: 80px; padding: 0.25rem 0.5rem;" 
          value="${item.quantity}" 
          min="1"
          data-item-id="${item.id}"
          onchange="updateQuantity('${item.id}', this.value)">
        名
      </div>
      <div style="font-size: 0.875rem; color: #6b7280;" id="priceInfo-${item.id}">
        単価: ¥${(item.unit_price || 0).toLocaleString()}
      </div>
      ${item.item_type === 'product' && item.item_id ? `
      <div style="font-size: 0.875rem;">
        <button type="button" 
          class="btn btn-sm btn-outline-primary" 
          onclick="changePriceCategory('${item.id}', ${item.item_id})"
          style="padding: 0.25rem 0.5rem; font-size: 0.75rem;">
          <i class="fas fa-edit"></i> 価格帯変更
        </button>
      </div>
      ` : ''}
    </div>
  `;
  
  // カードボディ
  const body = document.createElement('div');
  body.className = 'card-body';
  
  // 自由入力商品（カスタム商品）、オプション商品、手数料の場合は参加者情報入力欄を非表示
  if (item.item_type === 'custom' || item.item_type === 'option' || item.item_type === 'fee') {
    // カスタム商品・オプション商品・手数料の場合は参加者情報不要
    const noParticipantsMessage = document.createElement('div');
    noParticipantsMessage.style.cssText = 'padding: 1rem; color: #6b7280; font-size: 0.875rem; text-align: center; background: #f9fafb; border-radius: 0.375rem;';
    noParticipantsMessage.innerHTML = '<i class="fas fa-info-circle"></i> この商品は参加者情報の入力は不要です';
    body.appendChild(noParticipantsMessage);
  } else {
    // 登録商品の場合は参加者リストを表示
    const participantsContainer = document.createElement('div');
    participantsContainer.id = `participants-${item.id}`;
    
    // 既存の参加者を表示
    for (let i = 0; i < item.quantity; i++) {
      const participant = participants[i] || {};
      const participantForm = createParticipantForm(item.id, i, participant, item.item_id, item.product_id);
      participantsContainer.appendChild(participantForm);
    }
    
    body.appendChild(participantsContainer);
    
    // CSV操作ボタンを追加
    const csvActions = document.createElement('div');
    csvActions.className = 'csv-actions';
    csvActions.style.cssText = 'margin-top: 1rem; padding-top: 1rem; border-top: 1px solid #e5e7eb; display: flex; gap: 0.5rem; align-items: center;';
    
    csvActions.innerHTML = `
      <button type="button" class="btn-download-csv" data-item-id="${item.id}" 
        style="padding: 0.4rem 0.8rem; font-size: 0.875rem; background: #6c757d; color: white; border: none; border-radius: 0.375rem; cursor: pointer; display: flex; align-items: center; gap: 0.3rem;">
        <i class="fas fa-download" style="font-size: 0.75rem;"></i>
        CSVテンプレートダウンロード
      </button>
      <input type="file" class="csv-file-input" data-item-id="${item.id}" accept=".csv" style="display:none">
      <button type="button" class="btn-upload-csv" data-item-id="${item.id}"
        style="padding: 0.4rem 0.8rem; font-size: 0.875rem; background: #0d6efd; color: white; border: none; border-radius: 0.375rem; cursor: pointer; display: flex; align-items: center; gap: 0.3rem;">
        <i class="fas fa-upload" style="font-size: 0.75rem;"></i>
        CSVアップロード
      </button>
      <div class="csv-result" data-item-id="${item.id}" 
        style="margin-left: 1rem; font-size: 0.875rem;"></div>
    `;
    
    body.appendChild(csvActions);
  }
  
  card.appendChild(header);
  card.appendChild(body);
  
  return card;
}

// 参加者フォームを作成
function createParticipantForm(itemId, index, participant, productId, productIdForFields) {
  // productIdForFields がない場合は productId を使用
  const fieldProductId = productIdForFields || productId;
  
  const form = document.createElement('div');
  form.className = 'participant-form';
  form.style.cssText = 'border: 1px solid #e5e7eb; padding: 0.5rem 0.75rem; margin-bottom: 0.5rem; border-radius: 0.375rem; background: #f9fafb;';
  
  // 商品の参加者情報設定を取得
  const fieldSettings = productFieldSettings[productId] || {};
  console.log(`参加者${index + 1}のフィールド設定:`, fieldSettings);
  
  // フィールド定義
  const allFields = [
    { key: 'lastname_kanji', label: '姓（漢字）', type: 'text', width: '0.8fr' },
    { key: 'firstname_kanji', label: '名（漢字）', type: 'text', width: '0.8fr' },
    { key: 'lastname_kana', label: '姓（カナ）', type: 'text', width: '0.8fr' },
    { key: 'firstname_kana', label: '名（カナ）', type: 'text', width: '0.8fr' },
    { key: 'lastname_roman', label: '姓（ローマ字）', type: 'text', width: '0.8fr' },
    { key: 'firstname_roman', label: '名（ローマ字）', type: 'text', width: '0.8fr' },
    { key: 'age', label: '年齢', type: 'number', width: '80px' },
    { key: 'gender', label: '性別', type: 'select', width: '100px', options: [{ value: '', label: '選択' }, { value: '1', label: '男性' }, { value: '2', label: '女性' }, { value: '9', label: 'その他' }] },
    { key: 'email', label: 'メール', type: 'email', width: '1.5fr' },
    { key: 'phone', label: '電話', type: 'tel', width: '1fr' },
    { key: 'birth_date', label: '生年月日', type: 'date', width: '1fr' },
    { key: 'address', label: '住所', type: 'text', width: '2fr' }
  ];
  
  // 表示するフィールドをフィルタリング
  const visibleFields = allFields.filter(field => fieldSettings[field.key] === true);
  
  console.log(`参加者${index + 1}のvisibleFields:`, visibleFields.map(f => f.key));
  
  if (visibleFields.length === 0) {
    // 設定がない場合は、デフォルトで姓名（漢字）と電話のみ表示
    console.warn('商品の参加者情報設定が取得できませんでした。デフォルトの3項目を表示します。');
    visibleFields.push(
      allFields.find(f => f.key === 'lastname_kanji'),
      allFields.find(f => f.key === 'firstname_kanji'),
      allFields.find(f => f.key === 'phone')
    );
  }
  
  // グリッドカラムを動的生成
  const gridColumns = visibleFields.map(f => f.width).join(' ');
  
  // HTMLを生成
  let fieldsHTML = visibleFields.map(field => {
    const value = participant[field.key] || '';
    const required = fieldSettings[field.key] === true ? 'required' : '';
    const requiredMark = required ? '<span class="required">*</span>' : '';
    
    if (field.type === 'select') {
      const optionsHTML = field.options.map(opt => {
        const optValue = typeof opt === 'object' ? opt.value : opt;
        const optLabel = typeof opt === 'object' ? opt.label : opt;
        return `<option value="${optValue}" ${String(value) === String(optValue) ? 'selected' : ''}>${optLabel}</option>`;
      }).join('');
      
      return `
        <div class="form-group" style="margin-bottom: 0;">
          <label class="form-label" style="font-size: 0.75rem; margin-bottom: 0.2rem;">${field.label}${requiredMark}</label>
          <select class="form-control"
            style="padding: 0.3rem 0.4rem; font-size: 0.8125rem;"
            data-item-id="${itemId}"
            data-participant-index="${index}"
            data-field="${field.key}"
            ${required}>
            ${optionsHTML}
          </select>
        </div>
      `;
    } else {
      return `
        <div class="form-group" style="margin-bottom: 0;">
          <label class="form-label" style="font-size: 0.75rem; margin-bottom: 0.2rem;">${field.label}${requiredMark}</label>
          <input type="${field.type}" 
            class="form-control" 
            style="padding: 0.3rem 0.4rem; font-size: 0.8125rem;"
            data-item-id="${itemId}"
            data-participant-index="${index}"
            data-field="${field.key}"
            value="${escapeHtml(value)}"
            ${field.type === 'number' ? 'min="0"' : ''}
            ${required}>
        </div>
      `;
    }
  }).join('');
  
  form.innerHTML = `
    <h4 style="margin-bottom: 0.4rem; font-size: 0.875rem; font-weight: 600; color: #374151;">
      <i class="fas fa-user" style="font-size: 0.8125rem;"></i> 参加者 ${index + 1}
    </h4>
    
    <div class="form-row" style="display: grid; grid-template-columns: ${gridColumns}; gap: 0.4rem; margin-bottom: 0.5rem;">
      ${fieldsHTML}
    </div>
    
    <div id="custom-fields-${itemId}-${index}">
      <!-- カスタムフィールドをここに追加 -->
    </div>
  `;
  
  // カスタムフィールドを追加
  setTimeout(() => {
    renderCustomFields(itemId, index, participant, fieldProductId);
  }, 0);
  
  return form;
}

// カスタムフィールドを表示
function renderCustomFields(itemId, participantIndex, participant, productId) {
  const container = document.getElementById(`custom-fields-${itemId}-${participantIndex}`);
  if (!container) {
    console.warn(`Container not found: custom-fields-${itemId}-${participantIndex}`);
    return;
  }
  
  // フィールドを検索: 優先順位は productId > itemId
  let fields = [];
  let fieldKey = null;
  
  if (productId && formFields[productId]) {
    fields = formFields[productId];
    fieldKey = productId;
    console.log(`✅ Found fields by productId: ${productId}`);
  } else if (formFields[itemId]) {
    fields = formFields[itemId];
    fieldKey = itemId;
    console.log(`✅ Found fields by itemId: ${itemId}`);
  }
  
  const customFieldsData = participant.custom_fields || {};
  
  console.log(`renderCustomFields called:`, {
    itemId,
    participantIndex,
    productId,
    fieldKey,
    fieldsCount: fields.length,
    fields: fields,
    customFieldsData,
    availableKeys: Object.keys(formFields)
  });
  
  if (fields.length === 0) {
    console.warn(`❌ No fields found for itemId: ${itemId}, productId: ${productId}`);
    console.warn(`Available formFields keys:`, Object.keys(formFields));
    return;
  }
  
  // カスタムフィールドセクションヘッダー
  const header = document.createElement('h5');
  header.style.cssText = 'margin-top: 0.5rem; margin-bottom: 0.4rem; font-size: 0.875rem; font-weight: 600; color: #4b5563;';
  header.innerHTML = '<i class="fas fa-list-ul"></i> 付加情報';
  container.appendChild(header);
  
  // display_order でソート
  const sortedFields = [...fields].sort((a, b) => (a.display_order || 0) - (b.display_order || 0));
  
  // グリッドコンテナを作成（最大3カラム）
  const gridContainer = document.createElement('div');
  gridContainer.id = `custom-fields-grid-${itemId}-${participantIndex}`;
  gridContainer.style.cssText = 'display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 0.4rem; margin-bottom: 0.5rem;';
  
  // フィールドマップを作成（親子関係の参照用）
  const fieldMap = {};
  sortedFields.forEach(field => {
    fieldMap[field.id] = field;
  });
  
  for (const field of sortedFields) {
    const fieldEl = createCustomField(itemId, participantIndex, field, customFieldsData, fieldMap);
    
    // 親子関係がある場合、初期表示/非表示を設定
    if (field.parent_field_id && field.parent_field_id !== 'null' && field.parent_field_id !== null) {
      const parentField = fieldMap[field.parent_field_id];
      if (parentField) {
        // 初期状態で親の値をチェック
        const parentValue = customFieldsData[parentField.field_name] || '';
        const shouldShow = parentValue === field.parent_condition;
        fieldEl.style.display = shouldShow ? '' : 'none';
        fieldEl.dataset.parentFieldId = field.parent_field_id;
        fieldEl.dataset.parentCondition = field.parent_condition;
      }
    }
    
    gridContainer.appendChild(fieldEl);
  }
  
  container.appendChild(gridContainer);
}

// カスタムフィールド要素を作成
function createCustomField(itemId, participantIndex, field, customFieldsData, fieldMap) {
  const formGroup = document.createElement('div');
  formGroup.className = 'form-group';
  formGroup.style.cssText = 'margin-bottom: 0;';
  formGroup.dataset.fieldId = field.id;
  
  const label = document.createElement('label');
  label.className = 'form-label';
  label.style.cssText = 'font-size: 0.75rem; margin-bottom: 0.2rem;';
  label.textContent = field.field_label;
  if (field.is_required) {
    const required = document.createElement('span');
    required.className = 'required';
    required.textContent = ' *';
    label.appendChild(required);
  }
  
  let input;
  const fieldValue = customFieldsData[field.field_name] || '';
  
  // 共通のインラインスタイル
  const inputStyle = 'padding: 0.3rem 0.4rem; font-size: 0.8125rem;';
  
  switch (field.field_type) {
    case 'text':
      input = document.createElement('input');
      input.type = 'text';
      input.className = 'form-control';
      input.style.cssText = inputStyle;
      input.value = fieldValue;
      break;
      
    case 'textarea':
      input = document.createElement('textarea');
      input.className = 'form-control';
      input.style.cssText = inputStyle;
      input.rows = 2;
      input.value = fieldValue;
      break;
      
    case 'select':
    case 'radio':
      input = document.createElement('select');
      input.className = 'form-control';
      input.style.cssText = inputStyle;
      const options = JSON.parse(field.field_options || '[]');
      
      const defaultOption = document.createElement('option');
      defaultOption.value = '';
      defaultOption.textContent = '選択';
      input.appendChild(defaultOption);
      
      options.forEach(opt => {
        const option = document.createElement('option');
        option.value = opt;
        option.textContent = opt;
        if (opt === fieldValue) option.selected = true;
        input.appendChild(option);
      });
      break;
      
    case 'checkbox':
      input = document.createElement('div');
      const options2 = JSON.parse(field.field_options || '[]');
      const selectedValues = Array.isArray(fieldValue) ? fieldValue : (fieldValue ? [fieldValue] : []);
      
      options2.forEach(opt => {
        const label2 = document.createElement('label');
        label2.style.cssText = 'display: inline-block; margin-right: 1rem; margin-bottom: 0.3rem; font-size: 0.8125rem;';
        
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.value = opt;
        checkbox.checked = selectedValues.includes(opt);
        checkbox.dataset.itemId = itemId;
        checkbox.dataset.participantIndex = participantIndex;
        checkbox.dataset.customField = field.field_name;
        
        label2.appendChild(checkbox);
        label2.appendChild(document.createTextNode(' ' + opt));
        input.appendChild(label2);
      });
      break;
      
    case 'date':
      input = document.createElement('input');
      input.type = 'date';
      input.className = 'form-control';
      input.style.cssText = inputStyle;
      input.value = fieldValue;
      break;
      
    default:
      input = document.createElement('input');
      input.type = 'text';
      input.className = 'form-control';
      input.style.cssText = inputStyle;
      input.value = fieldValue;
  }
  
  if (input.tagName !== 'DIV') {
    input.dataset.itemId = itemId;
    input.dataset.participantIndex = participantIndex;
    input.dataset.customField = field.field_name;
    input.dataset.fieldId = field.id;
    if (field.is_required) input.required = true;
    
    // 親フィールドの場合、子フィールドの表示/非表示を制御
    input.addEventListener('change', function() {
      handleParentFieldChange(itemId, participantIndex, field.id, this.value, fieldMap);
    });
  }
  
  formGroup.appendChild(label);
  formGroup.appendChild(input);
  
  return formGroup;
}

// 親フィールドの変更時に子フィールドの表示/非表示を制御
function handleParentFieldChange(itemId, participantIndex, parentFieldId, parentValue, fieldMap) {
  const gridContainer = document.getElementById(`custom-fields-grid-${itemId}-${participantIndex}`);
  if (!gridContainer) return;
  
  // このフィールドを親とする子フィールドを探す
  const childFields = gridContainer.querySelectorAll(`[data-parent-field-id="${parentFieldId}"]`);
  
  childFields.forEach(childField => {
    const requiredCondition = childField.dataset.parentCondition;
    const shouldShow = parentValue === requiredCondition;
    
    // 表示/非表示を切り替え
    childField.style.display = shouldShow ? '' : 'none';
    
    // 非表示の場合、入力値をクリア
    if (!shouldShow) {
      const input = childField.querySelector('input, select, textarea');
      if (input) {
        if (input.type === 'checkbox') {
          input.checked = false;
        } else {
          input.value = '';
        }
      }
    }
  });
}

// 参加者を追加
// 参加日を更新
window.updateParticipationDate = function(itemId, newDate) {
  console.log(`参加日を更新: item=${itemId}, date=${newDate}`);
  // 保存時に一括で更新するため、ここでは何もしない
};

// 数量を更新
window.updateQuantity = async function(itemId, newQuantity) {
  const quantity = parseInt(newQuantity);
  if (isNaN(quantity) || quantity < 1) {
    showError('数量は1以上で指定してください');
    return;
  }
  
  // 明細を取得
  const item = bookingData.items.find(i => i.id === itemId);
  if (!item) return;
  
  // 参加者数を取得
  let participants = [];
  try {
    participants = JSON.parse(item.participants || '[]');
  } catch (e) {
    participants = [];
  }
  
  // 数量が減った場合、参加者数をチェック
  if (quantity < participants.length) {
    if (!confirm(`参加者数（${participants.length}名）が新しい数量（${quantity}名）を超えています。超過分の参加者情報は削除されます。よろしいですか？`)) {
      // キャンセルされた場合、元の値に戻す
      const input = document.querySelector(`input[data-item-id="${itemId}"][type="number"]`);
      if (input) input.value = item.quantity;
      return;
    }
  }
  
  // 数量を更新
  item.quantity = quantity;
  console.log(`bookingData.items更新: itemId=${itemId}, 旧数量→新数量=${quantity}`);
  console.log('更新後のitem:', JSON.stringify(item, null, 2));
  
  // カード全体を再描画
  const card = document.querySelector(`[data-item-id="${itemId}"]`);
  if (card) {
    const newCard = createBookingItemCard(item);
    card.replaceWith(newCard);
    console.log(`カード再描画完了: itemId=${itemId}`);
  } else {
    console.error(`カードが見つかりません: itemId=${itemId}`);
  }
  
  console.log(`数量を更新: itemId=${itemId}, 新数量=${quantity}`);
};

// 保存処理
async function handleSave() {
  console.log('========== handleSave が呼び出されました ==========');
  console.log('bookingData:', bookingData);
  console.log('bookingItems:', bookingItems);
  try {
    showLoading(true);
    
    // バリデーション
    const isValid = validateForm();
    if (!isValid) {
      showLoading(false);
      return;
    }
    
    console.log('保存処理を開始');
    
    // 新規明細を先に作成
    const newItems = bookingItems.filter(item => item.isNew);
    for (const newItem of newItems) {
      console.log(`\n=== 新規明細の作成: ${newItem.product_name} ===`);
      console.log('新規明細データ:', newItem);
      
      // 自由入力商品かどうかを判定
      const isCustomItem = newItem.isCustom || newItem.product_id === 0;
      
      const requestData = {
        booking_id: bookingData.booking.id,
        product_id: newItem.product_id,
        stock_id: newItem.stock_id || null,
        stock_type: newItem.stock_type || 'individual', // stock_typeを追加
        participation_date: newItem.participation_date,
        quantity: newItem.quantity,
        unit_price: newItem.unit_price || newItem.price || 0,
        price_category: newItem.price_category || null
      };
      
      // 自由入力商品の場合は商品名と備考を追加
      if (isCustomItem) {
        requestData.item_name = newItem.product_name || newItem.item_name;
        requestData.remarks = newItem.remarks || null;
      }
      
      console.log('送信データ:', requestData);
      
      const createResponse = await fetch('/api/v2/booking-items', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(requestData)
      });
      
      if (!createResponse.ok) {
        const error = await createResponse.json();
        console.error('新規明細作成エラー:', error);
        throw new Error(error.error || '新規明細の作成に失敗しました');
      }
      
      const createdItem = await createResponse.json();
      console.log(`新規明細を作成しました (ID: ${createdItem.id})`);
      
      // 作成された明細IDを保存（参加者情報更新用）
      newItem.realId = createdItem.id;
      
      // DOM要素のdata-item-id属性を実IDに更新
      const oldId = newItem.id;
      const newId = createdItem.id;
      
      // 参加者フォームコンテナのIDを更新
      const participantsContainer = document.getElementById(`participants-${oldId}`);
      if (participantsContainer) {
        participantsContainer.id = `participants-${newId}`;
      }
      
      // 全てのdata-item-id属性を更新
      const elementsToUpdate = document.querySelectorAll(`[data-item-id="${oldId}"]`);
      elementsToUpdate.forEach(el => {
        el.dataset.itemId = newId;
      });
      
      console.log(`DOM要素のIDを更新: ${oldId} → ${newId}`);
      
      newItem.isNew = false;
    }
    
    // 既存明細と新規作成した明細の参加者情報と数量を収集・更新
    const allItems = [...bookingData.items, ...newItems];
    for (const item of allItems) {
      // 実際のIDを使用（新規作成した場合はrealId、既存の場合はid）
      const actualItemId = item.realId || item.id;
      
      console.log(`\n=== 予約明細 ${actualItemId} の処理開始 ===`);
      console.log('item.item_type:', item.item_type);
      console.log('item.quantity (bookingData):', item.quantity);
      
      // カスタム商品（自由入力）の場合は参加者情報の収集・更新をスキップ
      const participants = (item.item_type === 'custom') ? [] : collectParticipants(actualItemId);
      const participationDateInput = document.querySelector(`input[type="date"][data-item-id="${actualItemId}"]`);
      const quantityInput = document.querySelector(`input[type="number"][data-item-id="${actualItemId}"]`);
      
      const participationDate = participationDateInput ? participationDateInput.value : item.participation_date;
      const quantity = quantityInput ? parseInt(quantityInput.value) : item.quantity;
      
      console.log('DOM quantityInput.value:', quantityInput ? quantityInput.value : 'なし');
      console.log('使用する quantity:', quantity);
      console.log('participants.length:', participants.length);
      
      console.log(`予約明細 ${actualItemId} を更新:`, {
        participants: participants.length,
        quantity,
        participationDate
      });
      
      // ★重要: 数量を先に更新（参加者数チェックの前に数量を増やす必要がある）
      // 常に数量と参加日を更新（参加者数との整合性を保つため）
      // 価格帯情報も一緒に送信
      const bookingItem = bookingItems.find(bi => (bi.realId || bi.id) === actualItemId);
      const quantityResponse = await fetch(`/api/v2/booking-items/${actualItemId}/quantity`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
          quantity, 
          participation_date: participationDate,
          unit_price: bookingItem?.unit_price,
          price_category: bookingItem?.price_category,
          stock_id: bookingItem?.stock_id || null,
          stock_type: bookingItem?.stock_type || 'individual' // stock_typeを追加
        })
      });
      
      if (!quantityResponse.ok) {
        const error = await quantityResponse.json();
        throw new Error(error.error || '数量の更新に失敗しました');
      }
      
      console.log(`予約明細 ${actualItemId} の数量と参加日を更新しました（数量: ${quantity}）`);
      
      // 参加者情報を更新（カスタム商品の場合はスキップ、数量更新後なので、新しい数量でチェックされる）
      if (item.item_type !== 'custom') {
        const participantsResponse = await fetch(`/api/v2/booking-items/${actualItemId}/participants`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ participants })
        });
        
        if (!participantsResponse.ok) {
          const error = await participantsResponse.json();
          throw new Error(error.error || '参加者情報の更新に失敗しました');
        }
        
        console.log(`予約明細 ${actualItemId} の参加者情報を更新しました`);
      } else {
        console.log(`予約明細 ${actualItemId} はカスタム商品のため、参加者情報の更新をスキップしました`);
      }
    }
    
    showSuccess('予約情報を更新しました');
    console.log('保存処理が完了しました');
    
    // 2秒後に予約詳細画面に戻る
    setTimeout(() => {
      window.location.href = `/bookings-detail.html?id=${bookingNumber}`;
    }, 2000);
    
  } catch (error) {
    console.error('保存エラー:', error);
    showError(error.message || '保存に失敗しました');
    showLoading(false);
  }
}

// フォームのバリデーション
function validateForm() {
  // バリデーションを無効化（必須チェックなし）
  console.log('バリデーションスキップ（必須チェック無効）');
  return true;
  
  /* 元のバリデーションコード（無効化済み）
  // 全ての必須フィールドをチェック
  const requiredFields = document.querySelectorAll('[required]');
  const emptyFields = [];
  
  for (const field of requiredFields) {
    // 表示されているフィールドのみチェック（親子関係で非表示のフィールドは除外）
    const isVisible = field.offsetParent !== null;
    if (isVisible && !field.value.trim()) {
      emptyFields.push(field);
    }
  }
  
  if (emptyFields.length > 0) {
    showError('必須項目を入力してください');
    emptyFields[0].focus();
    emptyFields[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
    return false;
  }
  
  // 各予約明細で少なくとも1人の参加者が必要（カスタム商品は除外）
  for (const item of bookingData.items) {
    // カスタム商品（自由入力）の場合は参加者情報不要
    if (item.item_type === 'custom') {
      continue;
    }
    
    const container = document.getElementById(`participants-${item.id}`);
    if (!container) continue;
    
    const participantForms = container.querySelectorAll('.participant-form');
    if (participantForms.length === 0) {
      showError(`${item.item_name}の参加者情報を入力してください`);
      return false;
    }
    
    // 各参加者の姓・名が入力されているかチェック
    for (let i = 0; i < participantForms.length; i++) {
      // 新形式のフィールド名でチェック
      const lastnameKanji = participantForms[i].querySelector(`[data-participant-index="${i}"][data-field="lastname_kanji"]`);
      const firstnameKanji = participantForms[i].querySelector(`[data-participant-index="${i}"][data-field="firstname_kanji"]`);
      
      // 旧形式のフィールド名も試す（後方互換性）
      const lastname = lastnameKanji || participantForms[i].querySelector(`[data-participant-index="${i}"][data-field="lastname"]`);
      const firstname = firstnameKanji || participantForms[i].querySelector(`[data-participant-index="${i}"][data-field="firstname"]`);
      
      if (!lastname || !lastname.value.trim() || !firstname || !firstname.value.trim()) {
        showError(`参加者 ${i + 1} の氏名を入力してください（${item.item_name}）`);
        if (lastname && !lastname.value.trim()) lastname.focus();
        else if (firstname && !firstname.value.trim()) firstname.focus();
        return false;
      }
    }
  }
  
  return true;
  */
}

// 参加者情報を収集
function collectParticipants(itemId) {
  const participants = [];
  const container = document.getElementById(`participants-${itemId}`);
  if (!container) return participants;
  
  // 実際の参加者フォームの数を取得
  const participantForms = container.querySelectorAll('.participant-form');
  
  participantForms.forEach((form, index) => {
    const participant = {
      lastname_kanji: '',
      firstname_kanji: '',
      lastname_kana: '',
      firstname_kana: '',
      lastname_roman: '',
      firstname_roman: '',
      age: null,
      gender: '',
      email: '',
      phone: '',
      birth_date: '',
      address: '',
      custom_fields: {}
    };
    
    // 基本フィールドを収集
    const fields = form.querySelectorAll(`[data-item-id="${itemId}"][data-participant-index="${index}"][data-field]`);
    fields.forEach(field => {
      const fieldName = field.dataset.field;
      let value = field.value;
      
      if (fieldName === 'age' && value) {
        value = parseInt(value);
      }
      
      participant[fieldName] = value;
    });
    
    // カスタムフィールドを収集
    const customFieldLabels = new Set();
    const customFields = form.querySelectorAll(`[data-item-id="${itemId}"][data-participant-index="${index}"][data-custom-field]`);
    
    customFields.forEach(field => {
      const fieldLabel = field.dataset.customField;
      
      // 同じラベルのフィールドが複数ある場合（チェックボックス）
      if (customFieldLabels.has(fieldLabel)) return;
      
      if (field.type === 'checkbox') {
        // チェックボックスの場合、全てのチェック状態を確認
        const checkboxes = form.querySelectorAll(`[data-item-id="${itemId}"][data-participant-index="${index}"][data-custom-field="${fieldLabel}"]`);
        const checkedValues = [];
        checkboxes.forEach(cb => {
          if (cb.checked) checkedValues.push(cb.value);
        });
        participant.custom_fields[fieldLabel] = checkedValues.length > 0 ? checkedValues : '';
        customFieldLabels.add(fieldLabel);
      } else {
        participant.custom_fields[fieldLabel] = field.value;
        customFieldLabels.add(fieldLabel);
      }
    });
    
    participants.push(participant);
  });
  
  return participants;
}

// ユーティリティ関数
function showLoading(show) {
  document.getElementById('loading').style.display = show ? 'block' : 'none';
}

function showError(message) {
  const el = document.getElementById('errorMessage');
  el.textContent = message;
  el.classList.remove('hidden');
  
  setTimeout(() => {
    el.classList.add('hidden');
  }, 5000);
}

function showSuccess(message) {
  const el = document.getElementById('successMessage');
  el.textContent = message;
  el.classList.remove('hidden');
  
  setTimeout(() => {
    el.classList.add('hidden');
  }, 5000);
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

// ============================================
// 商品追加機能
// ============================================

let currentEventId = null;
let availableProducts = [];
let selectedProduct = null;

// モーダルを開く
async function openProductSelectModal() {
  console.log('openProductSelectModal が呼び出されました');
  
  const modal = document.getElementById('productSelectModal');
  console.log('modal:', modal);
  
  if (!modal) {
    console.error('モーダル要素が見つかりません');
    showError('モーダル要素が見つかりません');
    return;
  }
  
  // タブを登録商品にリセット
  currentTab = 'registered';
  const tabRegistered = document.getElementById('tabRegistered');
  const tabCustom = document.getElementById('tabCustom');
  const registeredTab = document.getElementById('registeredProductTab');
  const customTab = document.getElementById('customProductTab');
  
  if (tabRegistered && tabCustom && registeredTab && customTab) {
    tabRegistered.classList.add('active');
    tabCustom.classList.remove('active');
    tabRegistered.style.color = '#0d6efd';
    tabRegistered.style.borderBottomColor = '#0d6efd';
    tabCustom.style.color = '#6c757d';
    tabCustom.style.borderBottomColor = 'transparent';
    registeredTab.style.display = 'block';
    customTab.style.display = 'none';
  }
  
  // カスタム商品フォームをリセット
  resetCustomProductForm();
  
  modal.classList.add('show');
  console.log('モーダルにshowクラスを追加しました');
  
  // イベントIDを取得（bookingDataから）
  if (bookingData && bookingData.booking && bookingData.booking.event_id) {
    currentEventId = bookingData.booking.event_id;
    console.log('イベントID:', currentEventId);
    await loadProducts();
  } else {
    console.error('イベント情報が見つかりません。bookingData:', bookingData);
    showError('イベント情報の取得に失敗しました');
  }
}

// 商品一覧を取得
async function loadProducts() {
  const loadingEl = document.getElementById('productLoading');
  const listEl = document.getElementById('productList');
  const errorEl = document.getElementById('productError');
  
  loadingEl.classList.remove('hidden');
  listEl.classList.add('hidden');
  errorEl.classList.add('hidden');
  
  try {
    const response = await fetch(`/api/products?event_id=${currentEventId}`);
    if (!response.ok) throw new Error('商品の取得に失敗しました');
    
    const data = await response.json();
    availableProducts = data.products || [];
    
    if (availableProducts.length === 0) {
      errorEl.textContent = 'このイベントに商品が登録されていません';
      errorEl.classList.remove('hidden');
      loadingEl.classList.add('hidden');
      return;
    }
    
    renderProductList(availableProducts);
    loadingEl.classList.add('hidden');
    listEl.classList.remove('hidden');
  } catch (error) {
    console.error('商品取得エラー:', error);
    errorEl.textContent = error.message;
    errorEl.classList.remove('hidden');
    loadingEl.classList.add('hidden');
  }
}

// 商品リストを描画
function renderProductList(products) {
  const listEl = document.getElementById('productList');
  
  if (products.length === 0) {
    listEl.innerHTML = '<p class="text-center" style="padding: 2rem; color: #6b7280;">該当する商品がありません</p>';
    return;
  }
  
  listEl.innerHTML = products.map(product => `
    <div class="product-card" data-product-id="${product.id}" style="padding: 1rem; border: 2px solid #e5e7eb; border-radius: 8px; margin-bottom: 1rem; cursor: pointer; transition: all 0.2s;">
      <div style="display: flex; justify-content: space-between; align-items: start;">
        <div style="flex: 1;">
          <h4 style="margin: 0 0 0.5rem 0; font-size: 1.1rem;">${escapeHtml(product.name)}</h4>
          <p style="margin: 0; color: #6b7280; font-size: 0.9rem;">${escapeHtml(product.description || '')}</p>
        </div>
        <div style="text-align: right;">
          <div style="font-size: 1.2rem; font-weight: bold; color: #1e40af; margin-bottom: 0.5rem;">
            ¥${(product.price || 0).toLocaleString()}
          </div>
          <div style="font-size: 0.9rem; color: ${product.stock > 0 ? '#16a34a' : '#dc2626'};">
            <i class="fas fa-box"></i> 
            ${product.stock > 0 ? `在庫: ${product.stock}` : '在庫なし'}
          </div>
        </div>
      </div>
    </div>
  `).join('');
  
  // クリックイベントを設定
  listEl.querySelectorAll('.product-card').forEach(card => {
    card.addEventListener('click', () => {
      const productId = parseInt(card.dataset.productId);
      selectProduct(productId);
    });
  });
}

// 商品を選択
async function selectProduct(productId) {
  selectedProduct = availableProducts.find(p => p.id === productId);
  
  if (!selectedProduct) return;
  
  // 選択状態をUIに反映
  document.querySelectorAll('.product-card').forEach(card => {
    if (parseInt(card.dataset.productId) === productId) {
      card.style.borderColor = '#3b82f6';
      card.style.backgroundColor = '#eff6ff';
    } else {
      card.style.borderColor = '#e5e7eb';
      card.style.backgroundColor = '#ffffff';
    }
  });
  
  // 商品の価格帯一覧と在庫データを取得
  let prices = [];
  let availableStocks = [];
  
  try {
    // 商品詳細を取得（form_field_settingsを含む）
    const productDetailResponse = await fetch(`/api/products/${productId}`);
    if (productDetailResponse.ok) {
      const productDetail = await productDetailResponse.json();
      if (productDetail.product && productDetail.product.form_field_settings) {
        productFieldSettings[productId] = productDetail.product.form_field_settings;
        console.log('商品の参加者情報設定を取得:', productFieldSettings[productId]);
      }
    }
    
    // 価格帯取得
    console.log('価格帯取得開始:', productId);
    const priceResponse = await fetch(`/api/v2/products/${productId}/prices`);
    if (!priceResponse.ok) throw new Error('価格帯情報の取得に失敗しました');
    
    const priceData = await priceResponse.json();
    prices = priceData.prices || [];
    console.log('取得した価格帯数:', prices.length, prices);
    
    // 価格帯情報を商品に追加
    selectedProduct.prices = prices;
    
  } catch (error) {
    console.error('価格帯取得エラー:', error);
    showError('価格帯情報の取得に失敗しました');
    return;
  }
  
  try {
    // 在庫取得
    console.log('在庫取得開始:', productId);
    const response = await fetch(`/api/products/${productId}/stocks`);
    if (!response.ok) throw new Error('在庫情報の取得に失敗しました');
    
    const data = await response.json();
    const stocks = data.stocks || [];
    console.log('取得した在庫数:', stocks.length);
    
    // 在庫のある日付のみをフィルタリング
    availableStocks = stocks.filter(s => (s.stock - s.booked) > 0);
    console.log('利用可能在庫数:', availableStocks.length);
    
    // 商品に在庫情報を追加
    selectedProduct.stocks = availableStocks;
    
  } catch (error) {
    console.error('在庫取得エラー:', error);
    showError('在庫情報の取得に失敗しました');
    return;
  }
  
  // 選択詳細を表示
  console.log('selectedProductDetail表示開始');
  document.getElementById('selectedProductDetail').classList.remove('hidden');
  document.getElementById('selectedProductName').textContent = selectedProduct.name;
  
  // 価格は価格帯選択後に表示
  document.getElementById('selectedProductPrice').textContent = '価格帯を選択してください';
  
  // 価格帯ドロップダウンを更新（selectedProductDetail表示後）
  console.log('価格帯ドロップダウン更新開始');
  const priceCategorySelect = document.getElementById('selectedPriceCategory');
  if (!priceCategorySelect) {
    console.error('selectedPriceCategory要素が見つかりません');
    showError('価格帯選択UIの初期化に失敗しました');
    return;
  }
  
  console.log('priceCategorySelect要素取得成功:', priceCategorySelect);
  priceCategorySelect.innerHTML = '<option value="">選択してください</option>';
  
  if (prices.length === 0) {
    console.warn('価格帯が0件です');
    priceCategorySelect.innerHTML = '<option value="">価格帯が設定されていません</option>';
    priceCategorySelect.disabled = true;
  } else {
    console.log('価格帯オプション追加開始:', prices.length, '件');
    prices.forEach(price => {
      const option = document.createElement('option');
      option.value = price.id;
      option.textContent = `${price.price_name} - ¥${price.price.toLocaleString()}`;
      option.dataset.price = price.price;
      option.dataset.priceName = price.price_name;
      option.dataset.priceBand = price.price_band || '';  // 価格帯を追加
      priceCategorySelect.appendChild(option);
      console.log('追加:', price.price_name, price.price, '価格帯:', price.price_band);
    });
    priceCategorySelect.disabled = false;
    console.log('価格帯ドロップダウン更新完了');
    
    // 価格帯変更時に単価を更新
    priceCategorySelect.removeEventListener('change', handlePriceCategoryChange);
    priceCategorySelect.addEventListener('change', handlePriceCategoryChange);
  }
  
  // 在庫情報を更新
  if (availableStocks.length === 0) {
    document.getElementById('selectedProductStock').textContent = '在庫なし';
    document.getElementById('selectedProductStock').style.color = '#dc2626';
    document.getElementById('confirmProductSelect').disabled = true;
    showError('選択した商品は在庫がありません');
    return;
  }
  
  // 日付選択フィールドを更新
  const dateInput = document.getElementById('selectedParticipationDate');
  
  // 最初の在庫がある日付をデフォルトに設定
  if (availableStocks.length > 0) {
    dateInput.value = availableStocks[0].date;
    dateInput.min = availableStocks[0].date;
    dateInput.max = availableStocks[availableStocks.length - 1].date;
    
    // 在庫数を更新
    updateStockDisplay(availableStocks[0].date);
  }
  
  // 日付変更時に在庫数を更新
  dateInput.removeEventListener('change', handleDateChange);
  dateInput.addEventListener('change', handleDateChange);
  
  // 追加ボタンは価格帯選択後に有効化
  document.getElementById('confirmProductSelect').disabled = true;
}

// 価格帯変更時の処理
function handlePriceCategoryChange(e) {
  const select = e.target;
  const selectedOption = select.options[select.selectedIndex];
  
  if (!selectedOption || !selectedOption.value) {
    document.getElementById('selectedProductPrice').textContent = '価格帯を選択してください';
    document.getElementById('confirmProductSelect').disabled = true;
    return;
  }
  
  const price = parseInt(selectedOption.dataset.price);
  const priceName = selectedOption.dataset.priceName;
  
  // 単価を更新
  document.getElementById('selectedProductPrice').textContent = `¥${price.toLocaleString()}`;
  
  // 選択した商品に価格情報を保存
  if (selectedProduct) {
    selectedProduct.selectedPrice = price;
    selectedProduct.selectedPriceName = priceName;
  }
  
  // 追加ボタンを有効化
  document.getElementById('confirmProductSelect').disabled = false;
}

// 日付変更時の処理
function handleDateChange(e) {
  const selectedDate = e.target.value;
  updateStockDisplay(selectedDate);
}

// 在庫表示を更新
function updateStockDisplay(date) {
  if (!selectedProduct || !selectedProduct.stocks) return;
  
  const stock = selectedProduct.stocks.find(s => s.date === date);
  const stockEl = document.getElementById('selectedProductStock');
  const quantityInput = document.getElementById('selectedQuantity');
  
  if (stock) {
    const available = stock.stock - stock.booked;
    stockEl.textContent = `在庫: ${available} 個`;
    stockEl.style.color = available > 0 ? '#16a34a' : '#dc2626';
    
    // 数量の最大値を在庫数に設定
    quantityInput.max = available;
    if (parseInt(quantityInput.value) > available) {
      quantityInput.value = available;
    }
    
    document.getElementById('confirmProductSelect').disabled = available <= 0;
  } else {
    stockEl.textContent = '在庫なし';
    stockEl.style.color = '#dc2626';
    quantityInput.max = 0;
    quantityInput.value = 0;
    document.getElementById('confirmProductSelect').disabled = true;
  }
}

// 商品検索ハンドラ
function handleProductSearch(e) {
  const keyword = e.target.value.toLowerCase();
  const filtered = availableProducts.filter(p => 
    p.name.toLowerCase().includes(keyword) || 
    (p.description && p.description.toLowerCase().includes(keyword))
  );
  renderProductList(filtered);
}

// モーダルを閉じる
function closeProductSelectModal() {
  document.getElementById('productSelectModal').classList.remove('show');
  selectedProduct = null;
  document.getElementById('selectedProductDetail').classList.add('hidden');
  document.getElementById('productSearch').value = '';
  document.getElementById('confirmProductSelect').disabled = true;
}

// 商品選択確定ハンドラ
async function handleProductSelect() {
  // カスタム商品タブの場合
  if (currentTab === 'custom') {
    addCustomProduct();
    return;
  }
  
  // 登録商品タブの場合
  if (!selectedProduct) return;
  
  const participationDate = document.getElementById('selectedParticipationDate').value;
  const quantity = parseInt(document.getElementById('selectedQuantity').value) || 1;
  
  // 価格帯選択の確認
  const priceCategorySelect = document.getElementById('selectedPriceCategory');
  const selectedOption = priceCategorySelect.options[priceCategorySelect.selectedIndex];
  
  if (!selectedOption || !selectedOption.value) {
    alert('価格帯を選択してください');
    return;
  }
  
  if (!participationDate) {
    alert('参加日を選択してください');
    return;
  }
  
  // 選択した日付の在庫を確認
  const stock = selectedProduct.stocks.find(s => s.date === participationDate);
  if (!stock) {
    alert('選択した日付は在庫がありません');
    return;
  }
  
  const available = stock.stock - stock.booked;
  if (quantity < 1 || quantity > available) {
    alert(`数量は1～${available}の範囲で指定してください`);
    return;
  }
  
  // 商品名と価格帯情報、stock_id、stock_typeを保存（モーダルを閉じる前に）
  const productName = selectedProduct.name;
  const unitPrice = parseInt(selectedOption.dataset.price);
  const priceName = selectedOption.dataset.priceName;
  const priceBand = selectedOption.dataset.priceBand;
  const stockId = stock.stock_id || stock.id; // stock_idを取得
  const stockType = stock.stock_type || 'individual'; // stock_typeを取得
  
  // 価格帯と価格名を結合（例: "A-大人"）
  const fullPriceCategory = priceBand && priceName ? `${priceBand}-${priceName}` : priceName;
  
  console.log('🔍 選択された商品情報:', {
    product: selectedProduct,
    priceName: priceName,
    priceBand: priceBand,
    fullPriceCategory: fullPriceCategory,
    priceDataset: selectedOption.dataset
  });
  
  // フォーム設定を先にロード
  if (selectedProduct.id && !productFieldSettings[selectedProduct.id]) {
    console.log('フォーム設定をロード中...', selectedProduct.id);
    await loadProductFormFields(selectedProduct.id);
    console.log('フォーム設定ロード完了:', productFieldSettings[selectedProduct.id]);
  }
  
  // 新規明細を追加
  addNewBookingItem(selectedProduct, participationDate, quantity, unitPrice, fullPriceCategory, stockId, stockType);
  
  // モーダルを閉じる
  closeProductSelectModal();
  
  // 成功メッセージ表示
  showSuccess(`「${productName} - ${fullPriceCategory}」を追加しました`);
}
  
// 新規明細カードを追加
function addNewBookingItem(product, participationDate, quantity, unitPrice, priceCategory, stockId, stockType) {
  // 新規明細オブジェクトを作成（IDは'new_'プレフィックス）
  const newItemId = `new_${Date.now()}`;
  
  console.log('📝 新規明細作成:', {
    product: product,
    priceCategory: priceCategory,
    productName: product.name
  });
  
  const newItem = {
    id: newItemId,
    booking_id: bookingData.booking.id,
    product_id: product.id,
    item_id: product.id, // 商品IDを追加
    item_type: 'product', // 商品タイプを明示
    product_name: priceCategory ? `${product.name} - ${priceCategory}` : product.name,
    item_name: product.name,
    participation_date: participationDate,
    quantity: quantity,
    unit_price: unitPrice || product.price || 0,
    price_category: priceCategory || '',
    subtotal: (unitPrice || product.price || 0) * quantity,
    stock_id: stockId || null, // stock_idを追加
    stock_type: stockType || 'individual', // stock_typeを追加
    participants: [], // 空の参加者リスト
    isNew: true // 新規フラグ
  };
  
  console.log('✅ 作成された明細:', newItem);
  
  // bookingItemsに追加
  bookingItems.push(newItem);
  
  // UIに反映（既存のitemCardを削除して再描画）
  renderBookingItems();
  
  // 料金情報を再計算
  recalculateTotals();
}

// 参加日を更新（グローバル関数）
window.updateParticipationDate = function(itemId, newDate) {
  console.log('参加日更新:', itemId, newDate);
  const item = bookingItems.find(i => String(i.id) === String(itemId));
  if (item) {
    item.participation_date = newDate;
    console.log('参加日を更新しました');
  }
};

// 数量を更新（グローバル関数）
window.updateQuantity = function(itemId, newQuantity) {
  console.log('数量更新:', itemId, newQuantity);
  const item = bookingItems.find(i => String(i.id) === String(itemId));
  if (item) {
    const qty = parseInt(newQuantity) || 1;
    item.quantity = qty;
    item.subtotal = (item.unit_price || 0) * qty;
    
    // 参加者フォームを再生成
    const participantsContainer = document.getElementById(`participants-${itemId}`);
    if (participantsContainer && item.item_type === 'product') {
      participantsContainer.innerHTML = '';
      for (let i = 0; i < qty; i++) {
        const participant = (item.participants && item.participants[i]) || {};
        const participantForm = createParticipantForm(itemId, i, participant, item.item_id, item.product_id);
        participantsContainer.appendChild(participantForm);
      }
    }
    
    recalculateTotals();
    console.log('数量を更新しました');
  }
};

// 料金情報を再計算
function recalculateTotals() {
  let totalAmount = 0;
  
  bookingItems.forEach(item => {
    const itemTotal = (item.unit_price || item.price || 0) * (item.quantity || 0);
    totalAmount += itemTotal;
  });
  
  // 画面に反映（合計金額の更新）
  const totalEl = document.getElementById('totalAmount');
  if (totalEl) {
    totalEl.textContent = `¥${totalAmount.toLocaleString()}`;
  }
  
  // 明細情報セクションを更新
  updateItemsSummary();
}

// 明細情報サマリーを更新
function updateItemsSummary() {
  const summaryEl = document.getElementById('itemsSummary');
  if (!summaryEl) return;
  
  const itemsHtml = bookingItems.map(item => {
    const unitPrice = item.unit_price || item.price || 0;
    const itemTotal = unitPrice * (item.quantity || 0);
    const itemName = item.price_category 
      ? `${escapeHtml(item.product_name || item.item_name)} - ${escapeHtml(item.price_category)}`
      : escapeHtml(item.product_name || item.item_name);
    
    return `
      <div style="display: flex; justify-content: space-between; padding: 0.5rem 0; border-bottom: 1px solid #e5e7eb;">
        <div>
          <div style="font-weight: 500;">${itemName}</div>
          <div style="font-size: 0.875rem; color: #6b7280;">
            ¥${unitPrice.toLocaleString()} × ${item.quantity}
          </div>
        </div>
        <div style="font-weight: 600; color: #1e40af;">
          ¥${itemTotal.toLocaleString()}
        </div>
      </div>
    `;
  }).join('');
  
  summaryEl.innerHTML = itemsHtml;
}

// イベントリスナーを設定
function setupEventListeners() {
  console.log('イベントリスナーを設定中...');
  
  // 保存ボタン
  const saveBtn = document.getElementById('saveBtn');
  console.log('saveBtn:', saveBtn);
  if (saveBtn) {
    saveBtn.addEventListener('click', () => {
      console.log('保存ボタンがクリックされました');
      handleSave();
    });
    console.log('保存ボタンのイベントリスナーを設定しました');
  } else {
    console.error('saveBtn が見つかりません');
  }
  
  // 「別のプランを追加」ボタン
  const addPlanBtn = document.getElementById('addPlanBtn');
  console.log('addPlanBtn:', addPlanBtn);
  if (addPlanBtn) {
    addPlanBtn.addEventListener('click', openProductSelectModal);
    console.log('「別のプランを追加」ボタンのイベントリスナーを設定しました');
  } else {
    console.error('addPlanBtn が見つかりません');
  }
  
  // モーダル関連のイベント設定
  const closeProductModalBtn = document.getElementById('closeProductModal');
  if (closeProductModalBtn) {
    closeProductModalBtn.addEventListener('click', closeProductSelectModal);
    console.log('モーダル閉じるボタンのイベントリスナーを設定しました');
  }
  
  const cancelProductSelectBtn = document.getElementById('cancelProductSelect');
  if (cancelProductSelectBtn) {
    cancelProductSelectBtn.addEventListener('click', closeProductSelectModal);
    console.log('キャンセルボタンのイベントリスナーを設定しました');
  }
  
  const confirmProductSelectBtn = document.getElementById('confirmProductSelect');
  if (confirmProductSelectBtn) {
    confirmProductSelectBtn.addEventListener('click', handleProductSelect);
    console.log('商品選択確定ボタンのイベントリスナーを設定しました');
  }
  
  const productSearchInput = document.getElementById('productSearch');
  if (productSearchInput) {
    productSearchInput.addEventListener('input', handleProductSearch);
    console.log('商品検索のイベントリスナーを設定しました');
  }
  
  // タブ切替のイベント設定
  setupProductTabs();
  
  // カスタム商品の小計計算
  setupCustomProductCalculation();

  
  console.log('イベントリスナーの設定完了');
}

// ========================================
// タブ切替とカスタム商品関連
// ========================================

let currentTab = 'registered'; // 'registered' or 'custom'

// タブ切替の設定
function setupProductTabs() {
  const tabRegistered = document.getElementById('tabRegistered');
  const tabCustom = document.getElementById('tabCustom');
  const registeredTab = document.getElementById('registeredProductTab');
  const customTab = document.getElementById('customProductTab');
  const confirmBtn = document.getElementById('confirmProductSelect');
  
  if (!tabRegistered || !tabCustom || !registeredTab || !customTab) {
    console.error('タブ要素が見つかりません');
    return;
  }
  
  // 登録商品タブをクリック
  tabRegistered.addEventListener('click', () => {
    currentTab = 'registered';
    
    // タブのスタイル変更
    tabRegistered.classList.add('active');
    tabCustom.classList.remove('active');
    tabRegistered.style.color = '#0d6efd';
    tabRegistered.style.borderBottomColor = '#0d6efd';
    tabCustom.style.color = '#6c757d';
    tabCustom.style.borderBottomColor = 'transparent';
    
    // コンテンツの表示切替
    registeredTab.style.display = 'block';
    customTab.style.display = 'none';
    
    // ボタンのテキスト変更
    if (confirmBtn) {
      confirmBtn.innerHTML = '<i class="fas fa-plus"></i> 追加';
      confirmBtn.disabled = !selectedProduct; // 登録商品タブでは商品選択が必要
    }
    
    console.log('登録商品タブに切り替えました');
  });
  
  // 自由入力タブをクリック
  tabCustom.addEventListener('click', () => {
    currentTab = 'custom';
    
    // タブのスタイル変更
    tabCustom.classList.add('active');
    tabRegistered.classList.remove('active');
    tabCustom.style.color = '#0d6efd';
    tabCustom.style.borderBottomColor = '#0d6efd';
    tabRegistered.style.color = '#6c757d';
    tabRegistered.style.borderBottomColor = 'transparent';
    
    // コンテンツの表示切替
    customTab.style.display = 'block';
    registeredTab.style.display = 'none';
    
    // ボタンのテキスト変更
    if (confirmBtn) {
      confirmBtn.innerHTML = '<i class="fas fa-plus"></i> 追加';
      confirmBtn.disabled = false; // 自由入力タブでは常に有効
    }
    
    console.log('自由入力タブに切り替えました');
  });
  
  console.log('タブ切替のイベントリスナーを設定しました');
}

// カスタム商品の小計計算
function setupCustomProductCalculation() {
  const priceInput = document.getElementById('customProductPrice');
  const quantityInput = document.getElementById('customProductQuantity');
  const subtotalDisplay = document.getElementById('customProductSubtotal');
  
  if (!priceInput || !quantityInput || !subtotalDisplay) {
    console.error('カスタム商品の入力要素が見つかりません');
    return;
  }
  
  function updateSubtotal() {
    const price = parseInt(priceInput.value) || 0;
    const quantity = parseInt(quantityInput.value) || 1;
    const subtotal = price * quantity;
    
    // 小計を表示（マイナスの場合は赤色）
    subtotalDisplay.textContent = `¥${subtotal.toLocaleString()}`;
    if (subtotal < 0) {
      subtotalDisplay.style.color = '#dc3545'; // 赤色
    } else {
      subtotalDisplay.style.color = '#0d6efd'; // 青色
    }
  }
  
  priceInput.addEventListener('input', updateSubtotal);
  quantityInput.addEventListener('input', updateSubtotal);
  
  console.log('カスタム商品の小計計算を設定しました');
}

// カスタム商品を追加
function addCustomProduct() {
  const name = document.getElementById('customProductName').value.trim();
  const price = parseInt(document.getElementById('customProductPrice').value);
  const quantity = parseInt(document.getElementById('customProductQuantity').value) || 1;
  const remarks = document.getElementById('customProductRemarks').value.trim();
  
  console.log('カスタム商品を追加:', { name, price, quantity, remarks });
  
  // バリデーション
  if (!name) {
    alert('商品名を入力してください');
    return;
  }
  
  if (isNaN(price)) {
    alert('単価を入力してください');
    return;
  }
  
  // 新規明細を作成
  const subtotal = price * quantity;
  const newItem = {
    id: `new_${Date.now()}`,
    booking_id: bookingData.booking.id,
    item_type: 'custom',
    item_id: 0,  // カスタム商品はID=0
    item_name: name,
    unit_price: price,
    quantity: quantity,
    subtotal: subtotal,
    price: price,  // 互換性のため
    product_id: 0,
    product_name: name,
    participation_date: null,
    participants: [],
    remarks: remarks || null,
    isNew: true,
    isCustom: true  // カスタム商品フラグ
  };
  
  console.log('作成したカスタム商品:', newItem);
  
  // bookingItemsに追加
  bookingItems.push(newItem);
  
  // UIを更新
  renderBookingItems();
  updateTotals();
  
  // モーダルを閉じる
  closeProductSelectModal();
  
  // 成功メッセージ
  showSuccess(`「${name}」を追加しました`);
  
  console.log('カスタム商品を追加しました:', newItem);
}

// カスタム商品フォームをリセット
function resetCustomProductForm() {
  document.getElementById('customProductName').value = '';
  document.getElementById('customProductPrice').value = '';
  document.getElementById('customProductQuantity').value = '1';
  document.getElementById('customProductRemarks').value = '';
  document.getElementById('customProductSubtotal').textContent = '¥0';
  document.getElementById('customProductSubtotal').style.color = '#0d6efd';
}

// ========================================
// CSV参加者アップロード機能
// ========================================

// CSVダウンロードボタンのイベントリスナー
document.addEventListener('click', async (e) => {
  if (e.target.closest('.btn-download-csv')) {
    const button = e.target.closest('.btn-download-csv');
    const itemId = button.dataset.itemId;
    
    console.log('CSVテンプレートダウンロード開始:', itemId);
    
    try {
      // ボタンを無効化
      button.disabled = true;
      button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ダウンロード中...';
      
      const response = await fetch(`/api/v2/booking-items/${itemId}/participants/template`);
      
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'ダウンロードに失敗しました');
      }
      
      // Blobとしてダウンロード
      const blob = await response.blob();
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      
      // ファイル名をContent-Dispositionヘッダーから取得
      const contentDisposition = response.headers.get('Content-Disposition');
      let filename = 'participants_template.csv';
      if (contentDisposition) {
        const match = contentDisposition.match(/filename\*?=['"]?([^'";\n]+)['"]?/);
        if (match && match[1]) {
          filename = decodeURIComponent(match[1]);
        }
      }
      
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
      
      console.log('CSVテンプレートダウンロード完了:', filename);
      
      // 成功メッセージ
      const resultDiv = document.querySelector(`.csv-result[data-item-id="${itemId}"]`);
      if (resultDiv) {
        resultDiv.innerHTML = '<span style="color: #198754;"><i class="fas fa-check-circle"></i> ダウンロード完了</span>';
        setTimeout(() => {
          resultDiv.innerHTML = '';
        }, 3000);
      }
      
    } catch (error) {
      console.error('CSVテンプレートダウンロードエラー:', error);
      
      const resultDiv = document.querySelector(`.csv-result[data-item-id="${itemId}"]`);
      if (resultDiv) {
        resultDiv.innerHTML = `<span style="color: #dc3545;"><i class="fas fa-exclamation-circle"></i> ${error.message}</span>`;
      }
    } finally {
      // ボタンを復元
      button.disabled = false;
      button.innerHTML = '<i class="fas fa-download"></i> CSVテンプレートダウンロード';
    }
  }
});

// CSVアップロードボタンのイベントリスナー
document.addEventListener('click', (e) => {
  if (e.target.closest('.btn-upload-csv')) {
    const button = e.target.closest('.btn-upload-csv');
    const itemId = button.dataset.itemId;
    const fileInput = document.querySelector(`.csv-file-input[data-item-id="${itemId}"]`);
    
    if (fileInput) {
      fileInput.click();
    }
  }
});

// CSVファイル選択時のイベントリスナー
document.addEventListener('change', async (e) => {
  if (e.target.classList.contains('csv-file-input')) {
    const fileInput = e.target;
    const itemId = fileInput.dataset.itemId;
    const file = fileInput.files[0];
    
    if (!file) return;
    
    console.log('CSVアップロード開始:', {
      itemId,
      filename: file.name,
      size: file.size
    });
    
    // 確認ダイアログ
    if (!confirm('CSVファイルをアップロードすると、既存の参加者情報は上書きされます。よろしいですか？')) {
      fileInput.value = ''; // ファイル選択をリセット
      return;
    }
    
    const resultDiv = document.querySelector(`.csv-result[data-item-id="${itemId}"]`);
    const uploadButton = document.querySelector(`.btn-upload-csv[data-item-id="${itemId}"]`);
    
    try {
      // ボタンを無効化
      if (uploadButton) {
        uploadButton.disabled = true;
        uploadButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> アップロード中...';
      }
      
      // 進捗表示
      if (resultDiv) {
        resultDiv.innerHTML = '<span style="color: #0d6efd;"><i class="fas fa-spinner fa-spin"></i> 処理中...</span>';
      }
      
      // FormDataを作成
      const formData = new FormData();
      formData.append('csv_file', file);
      
      // APIリクエスト
      const response = await fetch(`/api/v2/booking-items/${itemId}/participants/upload`, {
        method: 'POST',
        body: formData
      });
      
      const result = await response.json();
      
      if (result.success) {
        console.log('CSVアップロード成功:', result);
        
        // 成功メッセージ
        if (resultDiv) {
          resultDiv.innerHTML = `<span style="color: #198754;"><i class="fas fa-check-circle"></i> ${result.message}</span>`;
        }
        
        showSuccess(result.message || '参加者情報をアップロードしました');
        
        // 3秒後にページをリロード
        setTimeout(() => {
          location.reload();
        }, 1500);
        
      } else {
        throw new Error(result.error || 'アップロードに失敗しました');
      }
      
    } catch (error) {
      console.error('CSVアップロードエラー:', error);
      
      if (resultDiv) {
        resultDiv.innerHTML = `<span style="color: #dc3545;"><i class="fas fa-exclamation-circle"></i> エラー: ${error.message}</span>`;
      }
      
      showError(error.message || 'CSVのアップロードに失敗しました');
      
    } finally {
      // ボタンを復元
      if (uploadButton) {
        uploadButton.disabled = false;
        uploadButton.innerHTML = '<i class="fas fa-upload"></i> CSVアップロード';
      }
      
      // ファイル選択をリセット
      fileInput.value = '';
    }
  }
});

// ========================================
// 価格帯変更機能
// ========================================

// 価格帯変更モーダルを開く
async function changePriceCategory(itemId, productId) {
  try {
    // itemIdを数値に変換（文字列で渡される場合があるため）
    const numericItemId = typeof itemId === 'string' ? parseInt(itemId, 10) : itemId;
    
    // 商品の価格帯一覧を取得
    const response = await fetch(`/api/v2/products/${productId}/prices`);
    const data = await response.json();
    
    if (!data.prices || data.prices.length === 0) {
      alert('この商品には価格帯が設定されていません');
      return;
    }
    
    // 現在の予約明細を取得
    const currentItem = bookingItems.find(item => item.id === numericItemId);
    if (!currentItem) {
      console.error('予約明細が見つかりません:', { itemId, numericItemId, bookingItems });
      alert('予約明細が見つかりません');
      return;
    }
    
    // モーダルを作成
    const modal = document.createElement('div');
    modal.className = 'modal show';
    modal.style.display = 'flex';
    modal.innerHTML = `
      <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header">
          <h3><i class="fas fa-edit"></i> 価格帯変更</h3>
          <button type="button" class="close-btn" onclick="this.closest('.modal').remove()">×</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label class="form-label">現在の価格帯</label>
            <div class="detail-value">${currentItem.price_category || '未設定'} - ¥${(currentItem.unit_price || 0).toLocaleString()}</div>
          </div>
          <div class="form-group">
            <label class="form-label">新しい価格帯を選択 <span class="required">*</span></label>
            <select class="form-control" id="newPriceCategory" required style="width: 100%; min-width: 350px;">
              <option value="">選択してください</option>
              ${data.prices.map(price => {
                // 価格帯名称を組み立て（price_band + price_name）
                const categoryName = price.price_band && price.price_name 
                  ? `${price.price_band}-${price.price_name}` 
                  : (price.category_name || price.price_name || '');
                return `
                  <option value="${price.id}" 
                    data-price="${price.price}" 
                    data-category-name="${escapeHtml(categoryName)}"
                    ${currentItem.price_category === categoryName ? 'selected' : ''}>
                    ${escapeHtml(categoryName)} - ¥${price.price.toLocaleString()}
                  </option>
                `;
              }).join('')}
            </select>
          </div>
          <div class="alert alert-info" style="margin-top: 1rem; padding: 0.75rem; font-size: 0.875rem;">
            <i class="fas fa-info-circle"></i> 価格帯を変更すると、単価が自動的に更新されます。
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" onclick="this.closest('.modal').remove()">キャンセル</button>
          <button type="button" class="btn btn-primary" onclick="confirmPriceCategoryChange(${itemId})">変更</button>
        </div>
      </div>
    `;
    
    document.body.appendChild(modal);
    
  } catch (error) {
    console.error('価格帯取得エラー:', error);
    alert('価格帯の取得に失敗しました');
  }
}

// 価格帯変更を確定
function confirmPriceCategoryChange(itemId) {
  // itemIdを数値に変換
  const numericItemId = typeof itemId === 'string' ? parseInt(itemId, 10) : itemId;
  
  const select = document.getElementById('newPriceCategory');
  
  if (!select || !select.value) {
    alert('価格帯を選択してください');
    return;
  }
  
  const selectedOption = select.options[select.selectedIndex];
  const newPrice = parseInt(selectedOption.dataset.price);
  const newCategoryName = selectedOption.dataset.categoryName; // data-category-name を取得
  
  // 予約明細を更新
  const item = bookingItems.find(item => item.id === numericItemId);
  if (item) {
    item.unit_price = newPrice;
    item.price_category = newCategoryName; // price_band-price_name 形式で保存
    item.subtotal = newPrice * item.quantity;
    
    // 画面を再描画
    renderBookingItems();
    
    // 成功メッセージ
    showSuccess(`価格帯を「${newCategoryName}」に変更しました（単価: ¥${newPrice.toLocaleString()}）`);
  } else {
    console.error('予約明細が見つかりません:', { itemId, numericItemId, bookingItems });
    alert('予約明細が見つかりません');
  }
  
  // モーダルを閉じる
  document.querySelector('.modal.show')?.remove();
}

// グローバルスコープに追加
window.changePriceCategory = changePriceCategory;
window.confirmPriceCategoryChange = confirmPriceCategoryChange;
// Force new deployment - 1772607166
