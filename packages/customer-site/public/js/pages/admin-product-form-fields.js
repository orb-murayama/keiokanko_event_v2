/**
 * Admin Product Form Fields Page Script
 * 商品申込フォーム設定ページ
 */

// グローバル変数
// URLパラメータから商品IDとevent情報を取得
const urlParams = new URLSearchParams(window.location.search);
const productId = urlParams.get('id');
const currentProductId = productId; // サジェスト機能で使用
const currentEventId = urlParams.get('event_id');
const currentEventName = urlParams.get('event_name');
const entityType = 'product'; // 'product' を使用
let productData = null;
let fieldCounter = 0;
let formFields = [];

// フィールドタイプの定義
const fieldTypes = [
  { value: 'text', label: 'テキスト', icon: 'fa-font' },
  { value: 'textarea', label: 'テキストエリア', icon: 'fa-align-left' },
  { value: 'select', label: 'プルダウン', icon: 'fa-caret-square-down' },
  { value: 'radio', label: 'ラジオボタン', icon: 'fa-dot-circle' },
  { value: 'checkbox', label: 'チェックボックス', icon: 'fa-check-square' },
  { value: 'date', label: 'カレンダー', icon: 'fa-calendar' },
  { value: 'file', label: 'ファイルアップロード', icon: 'fa-file-upload' }
];

/**
 * ページ読み込み時の初期化
 */
async function initFormFieldsPage() {
  console.log('=== 商品フォーム設定初期化開始 ===');
  window.Utils.showLoading(true);
  
  try {
    // URLパラメータから商品IDを取得
    console.log('ProductID:', productId);
    
    if (!productId) {
      window.Utils.showError('商品IDが指定されていません。');
      return;
    }
    
    // 商品情報とフォームフィールドを読み込み
    console.log('データ読み込み開始');
    await Promise.all([
      loadProductInfo(),
      loadFormFields()
    ]);
    console.log('データ読み込み完了');
    
    // フォーム送信イベント
    const form = document.getElementById('formFieldsForm');
    if (form) {
      form.addEventListener('submit', handleSubmit);
    }
    
    // フィールド追加ボタン
    const addBtn = document.getElementById('addFieldBtn');
    if (addBtn) {
      addBtn.addEventListener('click', () => addField());
    }
    
    // キャンセルリンクとパンくずリンクを更新
    updateBackLinks();
    
    console.log('=== 初期化完了 ===');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました。');
  } finally {
    console.log('window.Utils.showLoading(false) 実行');
    window.Utils.showLoading(false);
  }
}

/**
 * 商品情報を読み込み
 */
async function loadProductInfo() {
  try {
    const response = await fetch(`/api/products/${productId}`);
    if (!response.ok) {
      throw new Error('商品情報の取得に失敗しました');
    }
    
    const data = await response.json();
    productData = data.product || data;
    
    // 商品名を表示
    const nameDisplay = document.getElementById('productNameDisplay');
    if (nameDisplay) {
      nameDisplay.textContent = productData.name;
    }
    
  } catch (error) {
    console.error('商品情報読み込みエラー:', error);
    throw error;
  }
}

/**
 * フォームフィールド一覧を読み込み
 */
async function loadFormFields() {
  try {
    const response = await fetch(`/api/products/${productId}/form-fields`);
    if (!response.ok) {
      throw new Error('フォームフィールドの取得に失敗しました');
    }
    
    const data = await response.json();
    formFields = data.fields || [];
    
    // フィールドを表示
    renderFormFields();
    
  } catch (error) {
    console.error('フォームフィールド読み込みエラー:', error);
    window.Utils.showError('フォームフィールドの読み込みに失敗しました。');
  }
}

/**
 * フォームフィールドを表示
 */
function renderFormFields() {
  const container = document.getElementById('formFieldsContainer');
  if (!container) return;
  
  container.innerHTML = '';
  
  if (formFields.length === 0) {
    // フィールドがない場合は空のまま（メッセージは表示しない）
    return;
  }
  
  // 親フィールドのラベルを設定
  formFields.forEach((field, index) => {
    if (field.parent_field_id && field.parent_field_id !== 'null') {
      // 親フィールドを検索
      const parentField = formFields.find(f => f.id === field.parent_field_id);
      if (parentField) {
        // 親フィールドの表示順を計算（display_orderではなく配列インデックス+1）
        const parentIndex = formFields.indexOf(parentField);
        field.parent_label = `フィールド${parentIndex + 1}（${parentField.field_label}）`;
      } else {
        field.parent_label = '親フィールド';
      }
    }
    addField(field, index);
  });
}

/**
 * フィールドを追加
 */
function addField(fieldData = null, index = null) {
  const container = document.getElementById('formFieldsContainer');
  if (!container) return;
  
  // .form-field-item クラスを持つ要素だけをカウント
  const existingFields = container.querySelectorAll('.form-field-item');
  console.log('addField called, existing fields:', existingFields.length);
  console.log('fieldCounter:', fieldCounter);
  
  const fieldId = fieldData?.id || `new_${fieldCounter++}`;
  const fieldType = fieldData?.field_type || 'text';
  const fieldName = fieldData?.field_name || '';
  const fieldLabel = fieldData?.field_label || '';
  const fieldOptions = fieldData?.field_options 
    ? (typeof fieldData.field_options === 'string' ? JSON.parse(fieldData.field_options) : fieldData.field_options)
    : [];
  const isRequired = fieldData?.is_required || 0;
  const category = fieldData?.category || 1; // デフォルトは「商品」
  const description = fieldData?.description || '';
  const placeholder = fieldData?.placeholder || '';
  const displayOrder = index !== null ? index : existingFields.length;
  const parentFieldId = (fieldData?.parent_field_id && fieldData.parent_field_id !== 'null') ? fieldData.parent_field_id : null;
  const parentCondition = (fieldData?.parent_condition && fieldData.parent_condition !== 'null') ? fieldData.parent_condition : null;
  const parentLabel = fieldData?.parent_label || '';
  const hasParent = parentFieldId !== null && parentFieldId !== undefined;
  
  console.log('displayOrder:', displayOrder, 'will show as:', displayOrder + 1);
  
  const fieldDiv = document.createElement('div');
  fieldDiv.className = 'form-field-item admin-card mb-4 p-4';
  fieldDiv.dataset.fieldId = fieldId;
  fieldDiv.dataset.displayOrder = displayOrder;
  if (parentFieldId) {
    fieldDiv.dataset.parentFieldId = parentFieldId;
    fieldDiv.dataset.parentCondition = parentCondition;
  }
  
  fieldDiv.innerHTML = `
    ${hasParent ? `
      <div class="bg-yellow-50 border border-yellow-300 rounded-lg p-3 mb-3" style="background-color: #fefce8; border-color: #fde047; border-width: 1px; border-radius: 0.5rem; padding: 0.75rem; margin-bottom: 0.75rem;">
        <div class="d-flex items-center gap-2" style="font-size: 0.875rem; color: #92400e;">
          <i class="fas fa-level-up-alt fa-rotate-90"></i>
          <span style="font-weight: 600;">条件分岐:</span>
          <span>「${parentLabel || '親フィールド'}」が「${parentCondition}」の場合に表示</span>
        </div>
      </div>
      <input type="hidden" class="parent-field-id-input" value="${parentFieldId}">
      <input type="hidden" class="parent-condition-input" value="${parentCondition}">
      <input type="hidden" class="parent-label-input" value="${parentLabel}">
    ` : ''}
    <div class="d-flex items-center justify-between mb-3">
      <h3 class="fw-bold">
        <i class="fas ${hasParent ? 'fa-arrow-right text-blue-600' : getFieldIcon(fieldType)}"></i>
        フィールド ${displayOrder + 1} ${hasParent ? '(子フィールド)' : ''}
      </h3>
      <div class="d-flex gap-2">
        <button type="button" class="btn btn-sm btn-success add-child-field-btn ${['select', 'radio', 'checkbox'].includes(fieldType) ? '' : 'hidden'}" title="子フィールド追加">
          <i class="fas fa-plus"></i> 子フィールド追加
        </button>
        <button type="button" class="btn-icon move-up-btn" title="上へ移動">
          <i class="fas fa-arrow-up"></i>
        </button>
        <button type="button" class="btn-icon move-down-btn" title="下へ移動">
          <i class="fas fa-arrow-down"></i>
        </button>
        <button type="button" class="btn-icon delete-field-btn" title="削除">
          <i class="fas fa-trash"></i>
        </button>
      </div>
    </div>
    
    <div class="row gap-3">
      <div class="col-md-3">
        <label class="admin-label">
          フィールドタイプ <span class="text-danger">*</span>
        </label>
        <select class="admin-input field-type-select" required>
          ${fieldTypes.map(type => `
            <option value="${type.value}" ${fieldType === type.value ? 'selected' : ''}>
              ${type.label}
            </option>
          `).join('')}
        </select>
      </div>
      
      <div class="col-md-3">
        <label class="admin-label">
          フィールド名 <span class="text-danger">*</span>
        </label>
        <input type="text" class="admin-input field-name-input" value="${fieldName}" 
               placeholder="例：email" required>
      </div>
      
      <div class="col-md-4">
        <label class="admin-label">
          ラベル <span class="text-danger">*</span>
        </label>
        <input type="text" class="admin-input field-label-input" value="${fieldLabel}" 
               placeholder="例：メールアドレス" required>
      </div>
      
      <div class="col-md-2">
        <label class="admin-label">
          必須
        </label>
        <label class="d-flex items-center gap-2 mt-2">
          <input type="checkbox" class="field-required-checkbox" ${isRequired ? 'checked' : ''}>
          <span>必須項目</span>
        </label>
      </div>
      
      <div class="col-md-2">
        <label class="admin-label">
          区分 <span class="text-danger">*</span>
        </label>
        <div class="d-flex gap-3 mt-2">
          <label class="d-flex items-center gap-2">
            <input type="radio" name="category-${fieldId}" class="field-category-radio" value="1" ${category === 1 ? 'checked' : ''}>
            <span>商品</span>
          </label>
          <label class="d-flex items-center gap-2">
            <input type="radio" name="category-${fieldId}" class="field-category-radio" value="2" ${category === 2 ? 'checked' : ''}>
            <span>参加者毎</span>
          </label>
        </div>
      </div>
    </div>
    
    <!-- 選択肢セクション（フィールドタイプの直後に配置） -->
    <div class="options-container mt-3 ${['select', 'radio', 'checkbox'].includes(fieldType) ? '' : 'hidden'}">
      <label class="admin-label">
        選択肢 <span class="text-danger">*</span>
      </label>
      <div class="options-list">
        ${fieldOptions.length > 0 ? fieldOptions.map((option, i) => `
          <div class="d-flex gap-2 mb-2 option-item">
            <input type="text" class="admin-input option-input" value="${option}" placeholder="選択肢 ${i + 1}">
            <button type="button" class="btn-icon btn-danger remove-option-btn">
              <i class="fas fa-times"></i>
            </button>
          </div>
        `).join('') : `
          <div class="d-flex gap-2 mb-2 option-item">
            <input type="text" class="admin-input option-input" placeholder="選択肢 1">
            <button type="button" class="btn-icon btn-danger remove-option-btn">
              <i class="fas fa-times"></i>
            </button>
          </div>
        `}
      </div>
      <button type="button" class="btn btn-sm btn-secondary add-option-btn mt-2">
        <i class="fas fa-plus"></i> 選択肢を追加
      </button>
    </div>
    
    <div class="row gap-3 mt-3">
      <div class="col-md-6">
        <label class="admin-label">
          プレースホルダー
        </label>
        <input type="text" class="admin-input field-placeholder-input" value="${placeholder}" 
               placeholder="例：example@domain.com">
      </div>
      
      <div class="col-md-6">
        <label class="admin-label">
          説明
        </label>
        <input type="text" class="admin-input field-description-input" value="${description}" 
               placeholder="例：連絡可能なメールアドレスを入力してください">
      </div>
    </div>
  `;
  
  container.appendChild(fieldDiv);
  
  // イベントリスナーを設定
  setupFieldEventListeners(fieldDiv);
  
  // 追加されたフィールドのDOM要素を返す
  return fieldDiv;
}

/**
 * フィールドアイテムのイベントリスナーを設定
 */
function setupFieldEventListeners(fieldDiv) {
  // フィールドタイプ変更
  const typeSelect = fieldDiv.querySelector('.field-type-select');
  if (typeSelect) {
    typeSelect.addEventListener('change', (e) => {
      const optionsContainer = fieldDiv.querySelector('.options-container');
      const addChildBtn = fieldDiv.querySelector('.add-child-field-btn');
      if (['select', 'radio', 'checkbox'].includes(e.target.value)) {
        optionsContainer.classList.remove('hidden');
        if (addChildBtn) addChildBtn.classList.remove('hidden');
      } else {
        optionsContainer.classList.add('hidden');
        if (addChildBtn) addChildBtn.classList.add('hidden');
      }
    });
  }
  
  // 上へ移動
  const moveUpBtn = fieldDiv.querySelector('.move-up-btn');
  if (moveUpBtn) {
    moveUpBtn.addEventListener('click', () => moveField(fieldDiv, -1));
  }
  
  // 下へ移動
  const moveDownBtn = fieldDiv.querySelector('.move-down-btn');
  if (moveDownBtn) {
    moveDownBtn.addEventListener('click', () => moveField(fieldDiv, 1));
  }
  
  // 削除
  const deleteBtn = fieldDiv.querySelector('.delete-field-btn');
  if (deleteBtn) {
    deleteBtn.addEventListener('click', () => deleteField(fieldDiv));
  }
  
  // 選択肢追加
  const addOptionBtn = fieldDiv.querySelector('.add-option-btn');
  if (addOptionBtn) {
    addOptionBtn.addEventListener('click', () => addOption(fieldDiv));
  }
  
  // 子フィールド追加
  const addChildBtn = fieldDiv.querySelector('.add-child-field-btn');
  if (addChildBtn) {
    addChildBtn.addEventListener('click', () => showChildFieldModal(fieldDiv));
  }
  
  // 選択肢削除（デリゲーション）
  const optionsList = fieldDiv.querySelector('.options-list');
  if (optionsList) {
    optionsList.addEventListener('click', (e) => {
      if (e.target.closest('.remove-option-btn')) {
        const optionDiv = e.target.closest('.d-flex');
        optionDiv.remove();
      }
    });
  }
}

/**
 * フィールドタイプに対応するアイコンを取得
 */
function getFieldIcon(fieldType) {
  const type = fieldTypes.find(t => t.value === fieldType);
  return type ? type.icon : 'fa-question';
}

/**
 * フィールドを移動
 */
function moveField(fieldDiv, direction) {
  const container = document.getElementById('formFieldsContainer');
  const items = Array.from(container.children);
  const index = items.indexOf(fieldDiv);
  const newIndex = index + direction;
  
  if (newIndex < 0 || newIndex >= items.length) {
    return;
  }
  
  if (direction === -1) {
    container.insertBefore(fieldDiv, items[newIndex]);
  } else {
    container.insertBefore(items[newIndex], fieldDiv);
  }
  
  // 表示順を更新
  updateDisplayOrder();
}

/**
 * フィールドを削除
 */
function deleteField(fieldDiv) {
  if (!confirm('このフィールドを削除してもよろしいですか？')) {
    return;
  }
  
  fieldDiv.remove();
  updateDisplayOrder();
}

/**
 * 選択肢を追加
 */
function addOption(fieldDiv) {
  const optionsList = fieldDiv.querySelector('.options-list');
  const optionCount = optionsList.children.length;
  
  const optionDiv = document.createElement('div');
  optionDiv.className = 'd-flex gap-2 mb-2 option-item';
  optionDiv.innerHTML = `
    <input type="text" class="admin-input option-input" placeholder="選択肢 ${optionCount + 1}">
    <button type="button" class="btn-icon btn-danger remove-option-btn">
      <i class="fas fa-times"></i>
    </button>
  `;
  
  optionsList.appendChild(optionDiv);
}

/**
 * 表示順を更新
 */
function updateDisplayOrder() {
  const container = document.getElementById('formFieldsContainer');
  const items = Array.from(container.children);
  
  items.forEach((item, index) => {
    item.dataset.displayOrder = index;
    const heading = item.querySelector('h3');
    if (heading) {
      const icon = heading.querySelector('i').outerHTML;
      heading.innerHTML = `${icon} フィールド ${index + 1}`;
    }
  });
}

/**
 * フォーム送信
 */
async function handleSubmit(event) {
  event.preventDefault();
  
  const container = document.getElementById('formFieldsContainer');
  const fieldItems = Array.from(container.children);
  
  const fields = fieldItems.map((item, index) => {
    const fieldId = item.dataset.fieldId;
    const fieldType = item.querySelector('.field-type-select').value;
    const fieldName = item.querySelector('.field-name-input').value;
    const fieldLabel = item.querySelector('.field-label-input').value;
    const isRequired = item.querySelector('.field-required-checkbox').checked ? 1 : 0;
    const categoryRadio = item.querySelector('.field-category-radio:checked');
    const category = categoryRadio ? parseInt(categoryRadio.value) : 1; // デフォルトは「商品」
    const description = item.querySelector('.field-description-input').value;
    const placeholder = item.querySelector('.field-placeholder-input').value;
    
    // 親子フィールド情報を取得
    const parentFieldId = item.dataset.parentFieldId || null;
    const parentCondition = item.dataset.parentCondition || null;
    const indentLevel = parentFieldId ? 1 : 0;
    
    let fieldOptions = null;
    if (['select', 'radio', 'checkbox'].includes(fieldType)) {
      const optionInputs = item.querySelectorAll('.options-list input');
      const options = Array.from(optionInputs)
        .map(input => input.value.trim())
        .filter(value => value !== '');
      
      // 旧実装と同じくJSON文字列に変換
      fieldOptions = options.length > 0 ? JSON.stringify(options) : null;
    }
    
    return {
      id: fieldId.startsWith('new_') ? null : parseInt(fieldId),
      temp_id: fieldId, // 一時IDを保持（バックエンドでのマッピング用）
      field_type: fieldType,
      field_name: fieldName,
      field_label: fieldLabel,
      field_options: fieldOptions,
      is_required: isRequired,
      category: category,
      description: description || null,
      placeholder: placeholder || null,
      display_order: index,
      parent_field_id: parentFieldId && parentFieldId !== '' ? (parentFieldId.startsWith('new_') ? parentFieldId : parseInt(parentFieldId)) : null,
      parent_condition: parentCondition || null,
      indent_level: indentLevel
    };
  });
  
  window.Utils.showLoading(true);
  
  try {
    const response = await fetch(`/api/products/${productId}/form-fields`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ fields })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'フォームフィールドの保存に失敗しました');
    }
    
    const result = await response.json();
    window.Utils.showSuccess('フォームフィールドを保存しました。');
    
    // 一覧をリロード
    setTimeout(() => {
      window.location.reload();
    }, 1500);
    
  } catch (error) {
    console.error('保存エラー:', error);
    window.Utils.showError(`フォームフィールドの保存に失敗しました。\n${error.message}`);
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 子フィールド追加のモーダルを表示
 */
function showChildFieldModal(parentFieldDiv) {
  const parentFieldId = parentFieldDiv.dataset.fieldId;
  
  // 新規フィールドの場合は警告を表示
  if (parentFieldId && parentFieldId.startsWith('new_')) {
    if (!confirm('警告: この親フィールドはまだ保存されていません。\n\n子フィールドを追加する前に、一度「保存」ボタンをクリックしてフォームを保存することを強く推奨します。\n\n保存せずに続行すると、親子関係が正しく設定されない可能性があります。\n\nそれでも続行しますか？')) {
      return;
    }
  }
  
  // 親フィールドの表示順を取得
  const container = document.getElementById('formFieldsContainer');
  const allFields = Array.from(container.querySelectorAll('.form-field-item'));
  const parentIndex = allFields.indexOf(parentFieldDiv);
  
  // 親フィールドのラベルを取得（新規/既存両方に対応）
  const parentLabelInput = parentFieldDiv.querySelector('.field-label-input');
  const parentLabel = parentLabelInput ? parentLabelInput.value.trim() : '';
  
  if (!parentLabel) {
    window.Utils.showError('親フィールドのラベル（項目名）を先に入力してください。');
    return;
  }
  
  // 表示用の親ラベル（フィールド番号 + ラベル）
  const displayParentLabel = `フィールド${parentIndex + 1}（${parentLabel}）`;
  
  // 親フィールドの選択肢を取得
  const optionInputs = parentFieldDiv.querySelectorAll('.option-input');
  const options = Array.from(optionInputs)
    .map(input => input.value.trim())
    .filter(val => val !== '');
  
  if (options.length === 0) {
    window.Utils.showError('親フィールドの選択肢を先に設定してください。');
    return;
  }
  
  // モーダルHTML
  const modalHtml = `
    <div id="childFieldModal" class="modal-overlay" style="position: fixed; inset: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 9999;">
      <div class="modal-content" style="background: white; border-radius: 0.5rem; padding: 2rem; max-width: 28rem; width: 90%; margin: 1rem;">
        <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 1rem;">
          <i class="fas fa-code-branch" style="color: #7c3aed; margin-right: 0.5rem;"></i>
          条件分岐の設定
        </h3>
        <p style="font-size: 0.875rem; color: #6b7280; margin-bottom: 1rem;">
          どの選択肢が選ばれた時に子フィールドを表示しますか？
        </p>
        <div style="margin-bottom: 1.5rem;">
          <label style="display: block; font-weight: 600; color: #374151; margin-bottom: 0.5rem; font-size: 0.875rem;">
            親フィールド「${displayParentLabel}」の値が:
          </label>
          <select id="childFieldCondition" class="admin-input" style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #d1d5db; border-radius: 0.375rem;">
            <option value="">選択してください</option>
            ${options.map(opt => `<option value="${opt}">${opt}</option>`).join('')}
          </select>
        </div>
        <div style="display: flex; gap: 0.75rem; justify-content: flex-end;">
          <button type="button" id="cancelChildField" class="btn btn-secondary">
            <i class="fas fa-times"></i> キャンセル
          </button>
          <button type="button" id="confirmChildField" class="btn btn-primary">
            <i class="fas fa-check"></i> OK
          </button>
        </div>
      </div>
    </div>
  `;
  
  document.body.insertAdjacentHTML('beforeend', modalHtml);
  
  const modal = document.getElementById('childFieldModal');
  const select = document.getElementById('childFieldCondition');
  const confirmBtn = document.getElementById('confirmChildField');
  const cancelBtn = document.getElementById('cancelChildField');
  
  // キャンセル
  cancelBtn.addEventListener('click', () => {
    modal.remove();
  });
  
  // OK
  confirmBtn.addEventListener('click', () => {
    const condition = select.value;
    
    if (!condition) {
      window.Utils.showError('条件を選択してください。');
      return;
    }
    
    modal.remove();
    
    // 子フィールドを追加（表示用の親ラベルを渡す）
    addChildField(parentFieldId, condition, displayParentLabel);
  });
}

/**
 * 子フィールドを追加
 */
function addChildField(parentFieldId, parentCondition, parentLabel) {
  // 通常のフィールドとして追加し、parent情報を保持
  const fieldData = {
    parent_field_id: parentFieldId,
    parent_condition: parentCondition,
    parent_label: parentLabel  // 親ラベルも保存
  };
  
  // フィールドを追加してDOM要素を取得
  const newFieldDiv = addField(fieldData, null);
  
  // 追加したフィールドまでスムーズにスクロール
  if (newFieldDiv) {
    setTimeout(() => {
      newFieldDiv.scrollIntoView({ 
        behavior: 'smooth', 
        block: 'center'
      });
      
      // フィールドを軽くハイライト表示（ユーザーに追加されたことを視覚的に示す）
      newFieldDiv.style.transition = 'background-color 0.5s ease';
      newFieldDiv.style.backgroundColor = '#fef3c7'; // 薄い黄色
      
      setTimeout(() => {
        newFieldDiv.style.backgroundColor = '';
      }, 2000);
    }, 100);
  }
  
  window.Utils.showSuccess(`条件「${parentCondition}」の子フィールドを追加しました。`);
}

/**
 * 戻るリンクを更新（event_idがあれば含める）
 */
function updateBackLinks() {
  if (currentEventId) {
    const eventIdParam = `?event_id=${currentEventId}`;
    const eventNameParam = currentEventName ? `&event_name=${encodeURIComponent(currentEventName)}` : '';
    const fullParam = `${eventIdParam}${eventNameParam}`;
    
    // パンくずリストのリンク更新
    const productsLink = document.getElementById('productsLink');
    if (productsLink) {
      productsLink.href = `/admin/products${fullParam}`;
    }
    
    // キャンセルボタンのリンク更新
    const cancelLink = document.querySelector('a[href="/admin/products"]');
    if (cancelLink) {
      cancelLink.href = `/admin/products${fullParam}`;
    }
  }
}

// 初期化
document.addEventListener('DOMContentLoaded', initFormFieldsPage);

// ========================================
// フォーム設定コピー機能（サジェスト）
// ========================================

let selectedSourceProductId = null;
let suggestDebounceTimer = null;

// 商品検索入力のイベントリスナー
const productSearchInput = document.getElementById('productSearchInput');
if (productSearchInput) {
  productSearchInput.addEventListener('input', handleProductSearch);
  productSearchInput.addEventListener('focus', handleProductSearch);
  
  // クリック外でサジェストを閉じる
  document.addEventListener('click', (e) => {
    if (!e.target.closest('#productSearchInput') && !e.target.closest('#productSuggestList')) {
      document.getElementById('productSuggestList').style.display = 'none';
    }
  });
}

// コピーボタンのイベントリスナー
const copyFormFieldsBtn = document.getElementById('copyFormFieldsBtn');
if (copyFormFieldsBtn) {
  copyFormFieldsBtn.addEventListener('click', handleCopyFormFields);
}

// 商品検索（サジェスト）
function handleProductSearch(e) {
  const keyword = e.target.value.trim();
  
  // デバウンス処理
  clearTimeout(suggestDebounceTimer);
  
  if (keyword.length === 0) {
    // 空の場合は全商品を表示
    suggestDebounceTimer = setTimeout(() => fetchProductSuggestions(''), 300);
  } else {
    suggestDebounceTimer = setTimeout(() => fetchProductSuggestions(keyword), 300);
  }
}

// 商品サジェスト取得
async function fetchProductSuggestions(keyword) {
  const suggestList = document.getElementById('productSuggestList');
  
  try {
    const params = new URLSearchParams({
      exclude_id: currentProductId || '',
      search: keyword
    });
    
    const response = await fetch(`/api/v2/products/form-fields/templates?${params}`);
    const result = await response.json();
    
    if (!result.success) {
      throw new Error(result.error || 'サジェスト取得に失敗しました');
    }
    
    // サジェストリストを表示
    displayProductSuggestions(result.products);
    
  } catch (error) {
    console.error('商品サジェスト取得エラー:', error);
    suggestList.innerHTML = `
      <div class="suggest-empty">
        <i class="fas fa-exclamation-circle"></i> 取得に失敗しました
      </div>
    `;
    suggestList.style.display = 'block';
  }
}

// サジェストリスト表示
function displayProductSuggestions(products) {
  const suggestList = document.getElementById('productSuggestList');
  
  if (products.length === 0) {
    suggestList.innerHTML = `
      <div class="suggest-empty">
        <i class="fas fa-info-circle"></i> 該当する商品が見つかりません
      </div>
    `;
    suggestList.style.display = 'block';
    return;
  }
  
  suggestList.innerHTML = products.map(product => `
    <div class="suggest-item" data-product-id="${product.id}" data-product-name="${escapeHtml(product.name)}">
      <div class="suggest-item-name">${escapeHtml(product.name)}</div>
      <div class="suggest-item-info">
        <i class="fas fa-list"></i> ${product.field_count || 0}項目
      </div>
    </div>
  `).join('');
  
  suggestList.style.display = 'block';
  
  // サジェスト項目のクリックイベント
  suggestList.querySelectorAll('.suggest-item').forEach(item => {
    item.addEventListener('click', () => {
      const productId = item.dataset.productId;
      const productName = item.dataset.productName;
      
      // 選択された商品をセット
      selectedSourceProductId = productId;
      document.getElementById('productSearchInput').value = productName;
      document.getElementById('copyFormFieldsBtn').disabled = false;
      
      // サジェストを閉じる
      suggestList.style.display = 'none';
    });
  });
}

// フォーム設定コピー実行
async function handleCopyFormFields() {
  if (!selectedSourceProductId) {
    alert('コピー元の商品を選択してください');
    return;
  }
  
  const sourceProductName = document.getElementById('productSearchInput').value;
  
  // 確認ダイアログ
  if (!confirm(
    `「${sourceProductName}」のフォーム設定をコピーします。\n\n` +
    `現在の設定は全て削除されますが、よろしいですか？`
  )) {
    return;
  }
  
  const copyButton = document.getElementById('copyFormFieldsBtn');
  const resultMessage = document.getElementById('copyResultMessage');
  
  try {
    // ボタンを無効化
    copyButton.disabled = true;
    copyButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> コピー中...';
    
    // 進捗表示
    resultMessage.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 処理中...';
    resultMessage.style.color = '#0d6efd';
    
    // APIリクエスト
    const response = await fetch(`/api/v2/products/${currentProductId}/form-fields/copy`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        source_product_id: selectedSourceProductId
      })
    });
    
    const result = await response.json();
    
    if (result.success) {
      console.log('フォーム設定コピー成功:', result);
      
      // 成功メッセージ
      resultMessage.innerHTML = `<i class="fas fa-check-circle"></i> ${result.message}`;
      resultMessage.style.color = '#198754';
      
      window.Utils.showSuccess(result.message || 'フォーム設定をコピーしました');
      
      // 2秒後にページをリロード
      setTimeout(() => {
        location.reload();
      }, 2000);
      
    } else {
      throw new Error(result.error || 'コピーに失敗しました');
    }
    
  } catch (error) {
    console.error('フォーム設定コピーエラー:', error);
    
    resultMessage.innerHTML = `<i class="fas fa-exclamation-circle"></i> エラー: ${error.message}`;
    resultMessage.style.color = '#dc3545';
    
    window.Utils.showError(error.message || 'フォーム設定のコピーに失敗しました');
    
    // ボタンを復元
    copyButton.disabled = false;
    copyButton.innerHTML = '<i class="fas fa-copy"></i> 設定';
  }
}

// HTML エスケープ
function escapeHtml(text) {
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };
  return text.replace(/[&<>"']/g, m => map[m]);
}
