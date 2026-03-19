let fieldCounter = 0;

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

// 成功トースト通知を表示
function showSuccessToast(message) {
    const toast = document.createElement('div');
    toast.className = 'fixed top-4 right-4 bg-green-600 text-white px-6 py-4 rounded-lg shadow-xl flex items-center gap-3 z-[10000] animate-slide-in';
    toast.innerHTML = `
        <i class="fas fa-check-circle text-2xl"></i>
        <div>
            <div class="font-semibold">成功</div>
            <div class="text-sm opacity-90">${message}</div>
        </div>
    `;
    
    document.body.appendChild(toast);
    
    // 3秒後にフェードアウト
    setTimeout(() => {
        toast.style.transition = 'opacity 0.5s ease-out';
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 500);
    }, 3000);
}

// フィールドを追加
function addField(fieldData = null, parentFieldId = null, parentCondition = null) {
    const container = document.getElementById('formFieldsContainer');
    const fieldId = fieldData?.id || `new_${fieldCounter++}`;
    const fieldType = fieldData?.field_type || 'text';
    const fieldName = fieldData?.field_name || '';
    const fieldLabel = fieldData?.field_label || '';
    const fieldOptions = fieldData?.field_options 
        ? (typeof fieldData.field_options === 'string' ? JSON.parse(fieldData.field_options) : fieldData.field_options)
        : [];
    const isRequired = fieldData?.is_required || 0;
    const description = fieldData?.description || '';
    const placeholder = fieldData?.placeholder || '';
    const displayOrder = fieldData?.display_order || container.children.length;
    const indentLevel = fieldData?.indent_level || (parentFieldId ? 1 : 0);
    
    // 親フィールド情報
    const hasParent = parentFieldId || fieldData?.parent_field_id;
    const actualParentId = parentFieldId || fieldData?.parent_field_id || null;
    const actualCondition = parentCondition || fieldData?.parent_condition || null;

    // フィールドタイプ選択肢
    const typeOptions = fieldTypes.map(type => 
        `<option value="${type.value}" ${type.value === fieldType ? 'selected' : ''}>
            ${type.label}
        </option>`
    ).join('');

    // 選択肢入力欄の表示制御
    const showOptions = ['select', 'radio', 'checkbox'].includes(fieldType);
    const optionsHtml = fieldOptions.map((opt, idx) => 
        `<div class="flex gap-2 mb-2">
            <input type="text" value="${opt}" class="flex-1 px-3 py-2 border rounded text-sm option-value">
            <button type="button" class="text-red-600 hover:bg-red-50 px-3 py-2 rounded remove-option-btn">
                <i class="fas fa-times"></i>
            </button>
        </div>`
    ).join('');

    // インデントを計算（20pxずつ）
    const indentPx = indentLevel * 20;
    
    // 親フィールド情報の表示
    const parentInfoHtml = hasParent ? `
        <div class="bg-yellow-50 border border-yellow-300 rounded-lg p-3 mb-3">
            <div class="flex items-center gap-2 text-sm text-yellow-800">
                <i class="fas fa-level-up-alt fa-rotate-90"></i>
                <span class="font-semibold">条件分岐:</span>
                <span>「<span id="parent_label_${fieldId}"></span>」が「${actualCondition}」の場合に表示</span>
            </div>
        </div>
    ` : '';

    const fieldHtml = `
        <div class="field-item bg-white border-2 ${hasParent ? 'border-blue-300' : 'border-gray-300'} rounded-lg p-5 mb-4" 
             data-field-id="${fieldId}" 
             data-order="${displayOrder}"
             data-indent="${indentLevel}"
             data-parent-id="${actualParentId || ''}"
             data-parent-condition="${actualCondition || ''}"
             style="margin-left: ${indentPx}px;">
            <input type="hidden" name="field_${fieldId}_id" value="${fieldData?.id || fieldId}">
            <input type="hidden" name="field_${fieldId}_order" value="${displayOrder}" class="field-order">
            <input type="hidden" name="field_${fieldId}_parent_id" value="${actualParentId || ''}">
            <input type="hidden" name="field_${fieldId}_parent_condition" value="${actualCondition || ''}">
            <input type="hidden" name="field_${fieldId}_indent" value="${indentLevel}">
            
            ${parentInfoHtml}
            
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center gap-3">
                    <button type="button" class="drag-handle cursor-move text-gray-400 hover:text-gray-600">
                        <i class="fas fa-grip-vertical text-xl"></i>
                    </button>
                    <h3 class="text-md font-bold text-gray-800">
                        <i class="fas ${hasParent ? 'fa-arrow-right text-blue-600' : 'fa-wpforms text-blue-600'} mr-2"></i>
                        フィールド #${displayOrder + 1} ${hasParent ? '(子フィールド)' : ''}
                    </h3>
                </div>
                <div class="flex gap-2">
                    <button type="button" class="add-child-btn ${['select', 'radio', 'checkbox'].includes(fieldType) ? '' : 'hidden'} bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700 text-sm" data-field-id="${fieldId}">
                        <i class="fas fa-plus mr-1"></i>子フィールド追加
                    </button>
                    <button type="button" class="remove-field-btn text-red-600 hover:bg-red-50 px-3 py-1 rounded">
                        <i class="fas fa-trash mr-1"></i>削除
                    </button>
                </div>
            </div>

            <div class="grid md:grid-cols-2 gap-4 mb-4">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        フィールドタイプ <span class="text-red-600">*</span>
                    </label>
                    <select name="field_${fieldId}_type" required class="field-type-select w-full px-4 py-3 border border-gray-300 rounded-lg" data-field-id="${fieldId}">
                        ${typeOptions}
                    </select>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        フィールド名（英数字） <span class="text-red-600">*</span>
                    </label>
                    <input type="text" name="field_${fieldId}_name" required value="${fieldName}" 
                        pattern="[a-zA-Z0-9_]+" placeholder="例: age_group"
                        class="field-name-input w-full px-4 py-3 border border-gray-300 rounded-lg">
                </div>
            </div>

            <div class="grid md:grid-cols-2 gap-4 mb-4">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        項目名（表示名） <span class="text-red-600">*</span>
                    </label>
                    <input type="text" name="field_${fieldId}_label" required value="${fieldLabel}" 
                        placeholder="例: 年齢層"
                        class="field-label-input w-full px-4 py-3 border border-gray-300 rounded-lg" data-field-id="${fieldId}">
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        プレースホルダー
                    </label>
                    <input type="text" name="field_${fieldId}_placeholder" value="${placeholder}" 
                        placeholder="例: 選択してください"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg">
                </div>
            </div>

            <div class="mb-4">
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    説明文
                </label>
                <textarea name="field_${fieldId}_description" rows="2" 
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg"
                    placeholder="ユーザーへの補足説明">${description}</textarea>
            </div>

            <div class="mb-4">
                <label class="flex items-center gap-2">
                    <input type="checkbox" name="field_${fieldId}_required" value="1" ${isRequired ? 'checked' : ''}
                        class="w-4 h-4">
                    <span class="text-sm font-semibold text-gray-700">必須入力にする</span>
                </label>
            </div>

            <div class="options-container ${showOptions ? '' : 'hidden'}" data-field-id="${fieldId}">
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                    選択肢 <span class="text-red-600">*</span>
                </label>
                <div class="options-list mb-2">
                    ${optionsHtml}
                </div>
                <button type="button" class="add-option-btn text-blue-600 hover:bg-blue-50 px-3 py-2 rounded text-sm">
                    <i class="fas fa-plus mr-1"></i>選択肢を追加
                </button>
            </div>
        </div>
    `;

    container.insertAdjacentHTML('beforeend', fieldHtml);
    
    // 親フィールドのラベルを更新
    if (hasParent) {
        updateParentLabel(fieldId, actualParentId);
    }
}

// 親フィールドのラベルを更新
function updateParentLabel(childFieldId, parentFieldId) {
    const parentField = document.querySelector(`.field-item[data-field-id="${parentFieldId}"]`);
    if (parentField) {
        const parentLabel = parentField.querySelector('.field-label-input').value;
        const labelElement = document.getElementById(`parent_label_${childFieldId}`);
        if (labelElement) {
            labelElement.textContent = parentLabel;
        }
    }
}

// フィールドタイプ変更時の処理
document.addEventListener('change', (e) => {
    if (e.target.classList.contains('field-type-select')) {
        const fieldItem = e.target.closest('.field-item');
        const fieldId = fieldItem.dataset.fieldId;
        const optionsContainer = fieldItem.querySelector('.options-container');
        const addChildBtn = fieldItem.querySelector('.add-child-btn');
        const selectedType = e.target.value;
        
        if (['select', 'radio', 'checkbox'].includes(selectedType)) {
            optionsContainer.classList.remove('hidden');
            addChildBtn.classList.remove('hidden');
        } else {
            optionsContainer.classList.add('hidden');
            addChildBtn.classList.add('hidden');
        }
    }
});

// フィールドラベル変更時に子フィールドの表示を更新
document.addEventListener('input', (e) => {
    if (e.target.classList.contains('field-label-input')) {
        const fieldId = e.target.dataset.fieldId;
        const newLabel = e.target.value;
        
        // このフィールドを親とする全ての子フィールドのラベルを更新
        document.querySelectorAll(`.field-item[data-parent-id="${fieldId}"]`).forEach(childField => {
            const childFieldId = childField.dataset.fieldId;
            const labelElement = document.getElementById(`parent_label_${childFieldId}`);
            if (labelElement) {
                labelElement.textContent = newLabel;
            }
        });
    }
});

// 子フィールドを追加
document.addEventListener('click', (e) => {
    if (e.target.closest('.add-child-btn')) {
        const btn = e.target.closest('.add-child-btn');
        const parentFieldId = btn.dataset.fieldId;
        const parentField = document.querySelector(`.field-item[data-field-id="${parentFieldId}"]`);
        const parentType = parentField.querySelector('.field-type-select').value;
        
        if (!['select', 'radio', 'checkbox'].includes(parentType)) {
            alert('選択肢を持つフィールド（プルダウン、ラジオボタン、チェックボックス）のみ子フィールドを追加できます');
            return;
        }
        
        // 親フィールドの選択肢を取得
        const options = Array.from(parentField.querySelectorAll('.option-value'))
            .map(input => input.value.trim())
            .filter(val => val !== '');
        
        if (options.length === 0) {
            alert('親フィールドの選択肢を先に設定してください');
            return;
        }
        
        // モーダルで選択肢を選ばせる
        showConditionModal(options, parentFieldId, parentField);
    }
});

// 条件選択モーダルを表示
function showConditionModal(options, parentFieldId, parentField) {
    // モーダルHTMLを作成
    const modalHtml = `
        <div id="conditionModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" style="z-index: 9999;">
            <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">
                    <i class="fas fa-code-branch text-blue-600 mr-2"></i>
                    条件分岐の設定
                </h3>
                <p class="text-sm text-gray-600 mb-4">
                    どの選択肢が選ばれた時に子フィールドを表示しますか？
                </p>
                <div class="mb-6">
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        親フィールドの値が:
                    </label>
                    <select id="conditionSelect" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        <option value="">選択してください</option>
                        ${options.map(opt => `<option value="${opt}">${opt}</option>`).join('')}
                    </select>
                </div>
                <div class="flex gap-3 justify-end">
                    <button type="button" id="cancelCondition" class="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition">
                        <i class="fas fa-times mr-1"></i>キャンセル
                    </button>
                    <button type="button" id="confirmCondition" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                        <i class="fas fa-check mr-1"></i>OK
                    </button>
                </div>
            </div>
        </div>
    `;
    
    // モーダルを追加
    document.body.insertAdjacentHTML('beforeend', modalHtml);
    
    const modal = document.getElementById('conditionModal');
    const select = document.getElementById('conditionSelect');
    const confirmBtn = document.getElementById('confirmCondition');
    const cancelBtn = document.getElementById('cancelCondition');
    
    // セレクトボックスにフォーカス
    setTimeout(() => select.focus(), 100);
    
    // キャンセルボタン
    cancelBtn.addEventListener('click', () => {
        modal.remove();
    });
    
    // OKボタン
    confirmBtn.addEventListener('click', () => {
        const selectedOption = select.value;
        
        if (!selectedOption) {
            alert('選択肢を選んでください');
            return;
        }
        
        // モーダルを閉じる
        modal.remove();
        
        // 子フィールドを追加
        const parentIndent = parseInt(parentField.dataset.indent) || 0;
        const childFieldData = {
            indent_level: parentIndent + 1,
            parent_field_id: parentFieldId,
            parent_condition: selectedOption
        };
        
        addField(childFieldData, parentFieldId, selectedOption);
        updateFieldNumbers();
        
        // 追加された子フィールドを取得（最後に追加されたフィールド）
        const container = document.getElementById('formFieldsContainer');
        const newChildField = container.lastElementChild;
        
        // 成功メッセージを表示
        showSuccessToast(`子フィールドを追加しました（条件: 「${selectedOption}」）`);
        
        // 新しいフィールドまでスクロール＆ハイライト
        setTimeout(() => {
            newChildField.scrollIntoView({ behavior: 'smooth', block: 'center' });
            
            // ハイライトアニメーション
            newChildField.classList.add('highlight-new-field');
            setTimeout(() => {
                newChildField.classList.remove('highlight-new-field');
            }, 2000);
        }, 100);
    });
    
    // モーダル外をクリックしたら閉じる
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.remove();
        }
    });
    
    // Escapeキーで閉じる
    document.addEventListener('keydown', function escHandler(e) {
        if (e.key === 'Escape' && document.getElementById('conditionModal')) {
            modal.remove();
            document.removeEventListener('keydown', escHandler);
        }
    });
}

// 選択肢を追加
document.addEventListener('click', (e) => {
    if (e.target.closest('.add-option-btn')) {
        const btn = e.target.closest('.add-option-btn');
        const fieldItem = btn.closest('.field-item');
        const optionsList = fieldItem.querySelector('.options-list');
        
        const optionHtml = `
            <div class="flex gap-2 mb-2">
                <input type="text" placeholder="選択肢を入力" class="flex-1 px-3 py-2 border rounded text-sm option-value">
                <button type="button" class="text-red-600 hover:bg-red-50 px-3 py-2 rounded remove-option-btn">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        `;
        optionsList.insertAdjacentHTML('beforeend', optionHtml);
    }
});

// 選択肢を削除
document.addEventListener('click', (e) => {
    if (e.target.closest('.remove-option-btn')) {
        const btn = e.target.closest('.remove-option-btn');
        btn.closest('.flex').remove();
    }
});

// フィールドを削除
document.addEventListener('click', (e) => {
    if (e.target.closest('.remove-field-btn')) {
        if (confirm('このフィールドを削除してもよろしいですか？\n（子フィールドも全て削除されます）')) {
            const btn = e.target.closest('.remove-field-btn');
            const fieldItem = btn.closest('.field-item');
            const fieldId = fieldItem.dataset.fieldId;
            
            // 子フィールドも削除
            removeChildFields(fieldId);
            
            fieldItem.remove();
            updateFieldNumbers();
        }
    }
});

// 子フィールドを再帰的に削除
function removeChildFields(parentFieldId) {
    const childFields = document.querySelectorAll(`.field-item[data-parent-id="${parentFieldId}"]`);
    childFields.forEach(childField => {
        const childFieldId = childField.dataset.fieldId;
        // 孫フィールドも削除
        removeChildFields(childFieldId);
        childField.remove();
    });
}

// フィールド番号を更新
function updateFieldNumbers() {
    const fields = document.querySelectorAll('.field-item');
    fields.forEach((field, index) => {
        const hasParent = field.dataset.parentId;
        field.querySelector('h3').innerHTML = `
            <i class="fas ${hasParent ? 'fa-arrow-right text-blue-600' : 'fa-wpforms text-blue-600'} mr-2"></i>
            フィールド #${index + 1} ${hasParent ? '(子フィールド)' : ''}
        `;
        field.querySelector('.field-order').value = index;
        field.dataset.order = index;
    });
}

// フォーム送信
document.getElementById('formFieldsForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const eventId = document.getElementById('eventId').value;
    const fields = [];
    const fieldItems = document.querySelectorAll('.field-item');
    
    fieldItems.forEach((item, index) => {
        const fieldId = item.dataset.fieldId;
        const id = document.querySelector(`[name="field_${fieldId}_id"]`)?.value || null;
        const fieldType = document.querySelector(`[name="field_${fieldId}_type"]`).value;
        const fieldName = document.querySelector(`[name="field_${fieldId}_name"]`).value;
        const fieldLabel = document.querySelector(`[name="field_${fieldId}_label"]`).value;
        const placeholder = document.querySelector(`[name="field_${fieldId}_placeholder"]`)?.value || '';
        const description = document.querySelector(`[name="field_${fieldId}_description"]`)?.value || '';
        const isRequired = document.querySelector(`[name="field_${fieldId}_required"]`)?.checked ? 1 : 0;
        const parentFieldId = document.querySelector(`[name="field_${fieldId}_parent_id"]`)?.value || null;
        const parentCondition = document.querySelector(`[name="field_${fieldId}_parent_condition"]`)?.value || null;
        const indentLevel = parseInt(document.querySelector(`[name="field_${fieldId}_indent"]`)?.value) || 0;
        
        // 必須フィールドのチェック
        if (!fieldName || !fieldLabel) {
            alert(`フィールド ${index + 1}: フィールド名とラベルは必須です`);
            throw new Error('Required fields missing');
        }
        
        // 選択肢を収集
        let options = null;
        if (['select', 'radio', 'checkbox'].includes(fieldType)) {
            const optionInputs = item.querySelectorAll('.option-value');
            options = Array.from(optionInputs)
                .map(input => input.value.trim())
                .filter(val => val !== '');
            
            // 選択肢が空の場合は警告を表示するが、保存は続行
            if (options.length === 0) {
                console.warn(`${fieldLabel}の選択肢が設定されていません`);
                // 空配列として保存
                options = [];
            }
        }
        
        fields.push({
            id: id,
            field_type: fieldType,
            field_name: fieldName,
            field_label: fieldLabel,
            field_options: options ? JSON.stringify(options) : null,
            is_required: isRequired,
            description: description || null,
            placeholder: placeholder || null,
            display_order: index,
            parent_field_id: parentFieldId && parentFieldId !== '' ? parentFieldId : null,
            parent_condition: parentCondition || null,
            indent_level: indentLevel
        });
    });
    
    try {
        const response = await axios.post(`/api/events/${eventId}/form-fields`, { fields });
        alert('フォーム設定を保存しました！');
        window.location.reload();
    } catch (error) {
        console.error('Error:', error);
        alert('保存に失敗しました: ' + (error.response?.data?.error || error.message));
    }
});

// 既存フィールドを読み込む
async function loadFields() {
    const eventId = document.getElementById('eventId').value;
    try {
        const response = await axios.get(`/api/events/${eventId}/form-fields`);
        const fields = response.data.fields || [];
        
        if (fields.length > 0) {
            fields.forEach(field => addField(field));
        } else {
            // 既存フィールドがない場合は1つ追加
            addField();
        }
    } catch (error) {
        console.error('Failed to load fields:', error);
        // エラーでも1つは追加
        addField();
    }
}

// ページ読み込み時の初期化
window.addEventListener('DOMContentLoaded', () => {
    loadFields();
});

// フィールド追加ボタン
document.getElementById('addFieldBtn')?.addEventListener('click', () => addField());
