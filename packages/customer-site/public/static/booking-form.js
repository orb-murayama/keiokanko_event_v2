// 条件分岐フィールドの表示/非表示を更新
function updateConditionalFields() {
    // 全ての条件分岐フィールドを取得
    const conditionalFields = document.querySelectorAll('[data-parent-field]');
    
    conditionalFields.forEach(fieldContainer => {
        const parentFieldName = fieldContainer.dataset.parentField;
        const requiredValue = fieldContainer.dataset.parentCondition;
        
        // 親フィールドの値を取得
        const parentField = document.querySelector(`[name="custom_${parentFieldName}"]`);
        if (!parentField) {
            return;
        }
        
        let currentValue = null;
        
        // フィールドタイプによって値の取得方法を変える
        if (parentField.type === 'radio') {
            const checkedRadio = document.querySelector(`[name="custom_${parentFieldName}"]:checked`);
            currentValue = checkedRadio ? checkedRadio.value : null;
        } else if (parentField.type === 'checkbox') {
            // チェックボックスの場合、チェックされた値を配列で取得
            const checkedBoxes = document.querySelectorAll(`[name="custom_${parentFieldName}"]:checked`);
            const values = Array.from(checkedBoxes).map(cb => cb.value);
            // 必要な値が含まれているかチェック
            if (values.includes(requiredValue)) {
                currentValue = requiredValue;
            }
        } else {
            currentValue = parentField.value;
        }
        
        // 条件に一致するかチェック
        if (currentValue === requiredValue) {
            fieldContainer.style.display = 'block';
            // 必須フィールドを有効化
            const inputs = fieldContainer.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                if (input.dataset.originalRequired === 'true') {
                    input.required = true;
                }
            });
        } else {
            fieldContainer.style.display = 'none';
            // 値をクリア
            const inputs = fieldContainer.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                if (input.type === 'checkbox' || input.type === 'radio') {
                    input.checked = false;
                } else {
                    input.value = '';
                }
                // 必須フィールドを無効化（非表示時はバリデーションしない）
                if (input.required) {
                    input.dataset.originalRequired = 'true';
                    input.required = false;
                }
            });
        }
    });
}

// 合計金額の計算
function updateTotalPrice() {
    let total = 0;
    
    // チケット料金の計算
    const quantityInputs = document.querySelectorAll('.quantity-input');
    quantityInputs.forEach(input => {
        const quantity = parseInt(input.value) || 0;
        const price = parseInt(input.dataset.price) || 0;
        total += quantity * price;
    });
    
    // オプション料金の計算
    const optionInputs = document.querySelectorAll('.option-quantity');
    optionInputs.forEach(input => {
        const quantity = parseInt(input.value) || 0;
        const price = parseInt(input.dataset.optionPrice) || 0;
        total += quantity * price;
    });
    
    document.getElementById('totalPrice').textContent = `¥${total.toLocaleString()}`;
}

// 数量入力フィールドにイベントリスナーを追加
document.addEventListener('DOMContentLoaded', () => {
    const quantityInputs = document.querySelectorAll('.quantity-input');
    quantityInputs.forEach(input => {
        input.addEventListener('input', updateTotalPrice);
    });
    
    // オプション数量入力フィールドにもイベントリスナーを追加
    const optionInputs = document.querySelectorAll('.option-quantity');
    optionInputs.forEach(input => {
        input.addEventListener('input', updateTotalPrice);
    });
    
    // 条件分岐フィールドの表示制御を初期化
    updateConditionalFields();
    
    // 親フィールドの変更を監視
    document.addEventListener('change', (e) => {
        if (e.target.hasAttribute('data-has-children')) {
            updateConditionalFields();
        }
    });
});
    
    // フォーム送信処理
    const form = document.getElementById('bookingForm');
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const formData = new FormData(form);
        
        // 在庫IDの取得
        const stockId = formData.get('stock_id');
        if (!stockId) {
            alert('日付・時間帯を選択してください');
            return;
        }
        
        // 数量と価格の収集
        const quantities = {};
        const prices = [];
        let totalQuantity = 0;
        
        quantityInputs.forEach((input, index) => {
            const quantity = parseInt(input.value) || 0;
            if (quantity > 0) {
                const price = parseInt(input.dataset.price);
                const name = input.dataset.name;
                quantities[`quantity_${index}`] = quantity;
                prices.push({
                    price: price,
                    quantity: quantity,
                    name: name
                });
                totalQuantity += quantity;
            }
        });
        
        if (totalQuantity === 0) {
            alert('チケットを1枚以上選択してください');
            return;
        }
        
        // オプションデータの収集
        const options = [];
        const optionInputs = document.querySelectorAll('.option-quantity');
        optionInputs.forEach(input => {
            const quantity = parseInt(input.value) || 0;
            if (quantity > 0) {
                const optionId = parseInt(input.dataset.optionId);
                const price = parseInt(input.dataset.optionPrice);
                const name = input.dataset.optionName;
                options.push({
                    option_id: optionId,
                    quantity: quantity,
                    price: price,
                    name: name
                });
            }
        });
        
        // カスタムフィールドの収集
        const customFields = {};
        const customInputs = document.querySelectorAll('[name^="custom_"]');
        customInputs.forEach(input => {
            const name = input.name;
            
            if (input.type === 'checkbox') {
                // チェックボックスは配列として収集
                if (!customFields[name]) {
                    customFields[name] = [];
                }
                if (input.checked) {
                    customFields[name].push(input.value);
                }
            } else if (input.type === 'radio') {
                // ラジオボタンはチェックされたもののみ
                if (input.checked) {
                    customFields[name] = input.value;
                }
            } else {
                // その他のフィールド
                if (input.value) {
                    customFields[name] = input.value;
                }
            }
        });
        
        // チェックボックス配列をJSON文字列に変換
        for (const key in customFields) {
            if (Array.isArray(customFields[key])) {
                customFields[key] = customFields[key].join(', ');
            }
        }
        
        // 送信データの構築
        const bookingData = {
            event_id: formData.get('event_id'),
            product_id: formData.get('product_id'),
            stock_id: stockId,
            family_name: formData.get('family_name'),
            first_name: formData.get('first_name'),
            family_kana: formData.get('family_kana'),
            first_kana: formData.get('first_kana'),
            email: formData.get('email'),
            tel: formData.get('tel'),
            quantities: quantities,
            prices: prices,
            options: options,
            custom_fields: customFields
        };
        
        try {
            // 送信ボタンを無効化
            const submitButton = form.querySelector('button[type="submit"]');
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 処理中...';
            
            const response = await axios.post('/api/bookings', bookingData);
            
            if (response.data.success) {
                // 予約完了ページへリダイレクト
                window.location.href = `/events/${bookingData.event_id}/booking/complete?customer_id=${response.data.customer_id}`;
            } else {
                alert('予約に失敗しました: ' + (response.data.error || '不明なエラー'));
                submitButton.disabled = false;
                submitButton.innerHTML = '<i class="fas fa-check-circle"></i> 予約を確定する';
            }
        } catch (error) {
            console.error('Booking error:', error);
            alert('予約に失敗しました: ' + (error.response?.data?.error || error.message));
            const submitButton = form.querySelector('button[type="submit"]');
            submitButton.disabled = false;
            submitButton.innerHTML = '<i class="fas fa-check-circle"></i> 予約を確定する';
        }
    });
});
