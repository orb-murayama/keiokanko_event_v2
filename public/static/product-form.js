let priceBandCounter = 0;
const usedBands = new Set();
const priceBands = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

// URLからproductIdを取得
const urlPath = window.location.pathname;
const productId = urlPath.includes('/products/') && urlPath.includes('/edit') 
    ? urlPath.split('/products/')[1].split('/edit')[0] 
    : null;
const isEditMode = !!productId;

console.log('編集モード:', isEditMode, 'productId:', productId);

// 画像プレビュー処理
const imageFileInput = document.getElementById('imageFile');
const previewImg = document.getElementById('previewImg');
const noImageText = document.getElementById('noImageText');

if (imageFileInput) {
    imageFileInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            // ファイルサイズチェック（5MB）
            if (file.size > 5 * 1024 * 1024) {
                alert('ファイルサイズが大きすぎます。5MB以下のファイルを選択してください。');
                e.target.value = '';
                return;
            }

            // プレビュー表示
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
                previewImg.classList.remove('hidden');
                noImageText.classList.add('hidden');
            };
            reader.readAsDataURL(file);
        } else {
            previewImg.classList.add('hidden');
            noImageText.classList.remove('hidden');
        }
    });
}

// 価格帯グループを追加
function addPriceBand() {
    const container = document.getElementById('priceBandsContainer');
    const groupId = priceBandCounter++;
    
    // 使用可能な価格帯を取得
    const availableBands = priceBands.filter(band => !usedBands.has(band));
    if (availableBands.length === 0) {
        alert('すべての価格帯（A-Z）が使用されています');
        return;
    }
    
    const defaultBand = availableBands[0];
    usedBands.add(defaultBand);
    
    const bandOptions = availableBands.map(band =>
        `<option value="${band}" ${band === defaultBand ? 'selected' : ''}>${band}</option>`
    ).join('');
    
    const groupHtml = `
        <div class="price-band-group bg-white border-2 border-gray-300 rounded-lg p-5" data-group-id="${groupId}" data-band="${defaultBand}">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center gap-3">
                    <label class="text-sm font-bold text-gray-700">価格帯:</label>
                    <select class="price-band-select px-3 py-2 border border-gray-300 rounded-lg text-sm font-bold" data-group-id="${groupId}">
                        ${bandOptions}
                    </select>
                </div>
                <button type="button" class="remove-band-btn text-red-600 hover:bg-red-50 px-3 py-1 rounded" data-group-id="${groupId}">
                    <i class="fas fa-trash mr-1"></i>削除
                </button>
            </div>
            
            <div class="bg-gray-50 p-4 rounded">
                <h4 class="text-sm font-bold text-gray-700 mb-3">価格設定（最大5枠）</h4>
                <p class="text-xs text-gray-600 mb-3">
                    <i class="fas fa-info-circle mr-1"></i>
                    上で設定した名称に対応する価格を入力してください。
                </p>
                <div class="space-y-2">
                    <div class="grid grid-cols-12 gap-2 items-center">
                        <div class="col-span-4">
                            <label class="text-xs font-bold text-gray-700">名称1の価格</label>
                        </div>
                        <div class="col-span-6">
                            <input type="number" name="band_${groupId}_price_1" required min="0" placeholder="10000" class="w-full px-3 py-2 border rounded text-sm">
                        </div>
                        <div class="col-span-2">
                            <span class="text-xs text-gray-500">円</span>
                        </div>
                    </div>
                    <div class="grid grid-cols-12 gap-2 items-center">
                        <div class="col-span-4">
                            <label class="text-xs font-bold text-gray-700">名称2の価格</label>
                        </div>
                        <div class="col-span-6">
                            <input type="number" name="band_${groupId}_price_2" min="0" placeholder="7000" class="w-full px-3 py-2 border rounded text-sm">
                        </div>
                        <div class="col-span-2">
                            <span class="text-xs text-gray-500">円</span>
                        </div>
                    </div>
                    <div class="grid grid-cols-12 gap-2 items-center">
                        <div class="col-span-4">
                            <label class="text-xs font-bold text-gray-700">名称3の価格</label>
                        </div>
                        <div class="col-span-6">
                            <input type="number" name="band_${groupId}_price_3" min="0" placeholder="5000" class="w-full px-3 py-2 border rounded text-sm">
                        </div>
                        <div class="col-span-2">
                            <span class="text-xs text-gray-500">円</span>
                        </div>
                    </div>
                    <div class="grid grid-cols-12 gap-2 items-center">
                        <div class="col-span-4">
                            <label class="text-xs font-bold text-gray-700">名称4の価格</label>
                        </div>
                        <div class="col-span-6">
                            <input type="number" name="band_${groupId}_price_4" min="0" placeholder="8000" class="w-full px-3 py-2 border rounded text-sm">
                        </div>
                        <div class="col-span-2">
                            <span class="text-xs text-gray-500">円</span>
                        </div>
                    </div>
                    <div class="grid grid-cols-12 gap-2 items-center">
                        <div class="col-span-4">
                            <label class="text-xs font-bold text-gray-700">名称5の価格</label>
                        </div>
                        <div class="col-span-6">
                            <input type="number" name="band_${groupId}_price_5" min="0" placeholder="6000" class="w-full px-3 py-2 border rounded text-sm">
                        </div>
                        <div class="col-span-2">
                            <span class="text-xs text-gray-500">円</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    container.insertAdjacentHTML('beforeend', groupHtml);
}

// 価格帯グループを削除
document.addEventListener('click', (e) => {
    if (e.target.closest('.remove-band-btn')) {
        const btn = e.target.closest('.remove-band-btn');
        const groupId = btn.dataset.groupId;
        const group = document.querySelector(`.price-band-group[data-group-id="${groupId}"]`);
        const band = group.dataset.band;
        usedBands.delete(band);
        group.remove();
    }
});

// 価格帯変更時の処理
document.addEventListener('change', (e) => {
    if (e.target.classList.contains('price-band-select')) {
        const groupId = e.target.dataset.groupId;
        const group = document.querySelector(`.price-band-group[data-group-id="${groupId}"]`);
        const oldBand = group.dataset.band;
        const newBand = e.target.value;
        
        if (usedBands.has(newBand) && newBand !== oldBand) {
            alert(`価格帯${newBand}は既に使用されています`);
            e.target.value = oldBand;
            return;
        }
        
        usedBands.delete(oldBand);
        usedBands.add(newBand);
        group.dataset.band = newBand;
    }
});

// 価格帯追加ボタン
document.getElementById('addPriceBandButton').addEventListener('click', addPriceBand);

// 編集モード: 既存データを読み込む
async function loadProductData() {
    if (!isEditMode) {
        // 新規登録モード：初期価格帯を1つ追加
        addPriceBand();
        return;
    }

    try {
        console.log('商品データ読み込み開始:', productId);
        const response = await axios.get(`/api/products/${productId}`);
        const product = response.data.product;
        const prices = response.data.prices || [];

        console.log('商品データ:', product);
        console.log('価格データ:', prices);

        // 基本情報を入力
        document.querySelector('[name="name"]').value = product.name || '';
        document.querySelector('[name="event_id"]').value = product.event_id || '';
        document.querySelector('[name="sales_start"]').value = product.sales_start || '';
        document.querySelector('[name="sales_end"]').value = product.sales_end || '';
        document.querySelector('[name="closing_trade"]').value = product.closing_trade || 0;
        document.querySelector('[name="description"]').value = product.description || '';
        document.querySelector('[name="remarks"]').value = product.remarks || '';
        document.querySelector('[name="fee_include"]').value = product.fee_include || '';
        document.querySelector('[name="fee_exclude"]').value = product.fee_exclude || '';
        document.querySelector('[name="cancel_policy"]').value = product.cancel_policy || '';
        document.querySelector('[name="purchase_limit"]').value = product.purchase_limit || '';
        document.querySelector('[name="enable_flg"]').value = product.enable_flg || 1;
        document.querySelector('[name="price_unit"]').value = product.price_unit || '人';
        document.querySelector('[name="charge_type"]').value = product.charge_type || 'per_person';
        document.querySelector('[name="charge_description"]').value = product.charge_description || '';

        // 画像プレビュー表示
        if (product.image_url) {
            console.log('画像URL:', product.image_url);
            previewImg.src = product.image_url;
            previewImg.classList.remove('hidden');
            noImageText.classList.add('hidden');
        }

        // 価格データから共通名称を抽出
        const commonNamesMap = new Map();
        prices.forEach(p => {
            if (!commonNamesMap.has(p.slot_number)) {
                commonNamesMap.set(p.slot_number, {
                    name: p.name,
                    description: p.description || ''
                });
            }
        });

        // 共通名称を入力
        commonNamesMap.forEach((data, slotNumber) => {
            document.querySelector(`[name="common_name_${slotNumber}"]`).value = data.name;
            if (data.description) {
                document.querySelector(`[name="common_desc_${slotNumber}"]`).value = data.description;
            }
        });

        // 価格帯別にグループ化
        const bandGroups = new Map();
        prices.forEach(p => {
            if (!bandGroups.has(p.band)) {
                bandGroups.set(p.band, []);
            }
            bandGroups.get(p.band).push(p);
        });

        // 価格帯グループを追加
        bandGroups.forEach((pricesInBand, band) => {
            addPriceBand();
            const groupId = priceBandCounter - 1;
            const group = document.querySelector(`.price-band-group[data-group-id="${groupId}"]`);
            
            // 価格帯を設定
            const selectElement = group.querySelector('.price-band-select');
            selectElement.value = band;
            usedBands.delete(group.dataset.band);
            usedBands.add(band);
            group.dataset.band = band;

            // 価格を入力
            pricesInBand.forEach(p => {
                const input = group.querySelector(`[name="band_${groupId}_price_${p.slot_number}"]`);
                if (input) {
                    input.value = p.price;
                }
            });
        });

        console.log('商品データ読み込み完了');
    } catch (error) {
        console.error('商品データ読み込みエラー:', error);
        alert('商品データの読み込みに失敗しました: ' + (error.response?.data?.error || error.message));
    }
}

// ページ読み込み時に実行
window.addEventListener('DOMContentLoaded', loadProductData);

// フォーム送信
document.getElementById('productForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const priceBandGroups = document.querySelectorAll('.price-band-group');
    
    if (priceBandGroups.length === 0) {
        alert('少なくとも1つの価格帯を追加してください');
        return;
    }
    
    // 共通名称を取得
    const commonNames = [];
    const commonDescs = [];
    for (let i = 1; i <= 5; i++) {
        const name = formData.get(`common_name_${i}`);
        const desc = formData.get(`common_desc_${i}`);
        if (name && name.trim() !== '') {
            commonNames.push(name.trim());
            commonDescs.push(desc?.trim() || '');
        }
    }
    
    if (commonNames.length === 0) {
        alert('少なくとも1つの名称を設定してください');
        return;
    }
    
    // すべての価格帯グループからデータを収集
    const priceData = [];
    priceBandGroups.forEach((group) => {
        const band = group.dataset.band;
        const groupId = group.dataset.groupId;
        
        // 各名称に対応する価格を取得
        commonNames.forEach((name, index) => {
            const slotNumber = index + 1;
            const price = formData.get(`band_${groupId}_price_${slotNumber}`);
            
            if (price && price !== '') {
                priceData.push({
                    band: band,
                    slot_number: slotNumber,
                    name: name,
                    price: parseInt(price),
                    description: commonDescs[index]
                });
            }
        });
    });
    
    if (priceData.length === 0) {
        alert('少なくとも1つの価格を設定してください');
        return;
    }
    
    // 基本データ
    const data = {
        name: formData.get('name'),
        event_id: formData.get('event_id'),
        sales_start: formData.get('sales_start'),
        sales_end: formData.get('sales_end'),
        closing_trade: formData.get('closing_trade') || 0,
        description: formData.get('description') || '',
        remarks: formData.get('remarks') || '',
        fee_include: formData.get('fee_include') || '',
        fee_exclude: formData.get('fee_exclude') || '',
        cancel_policy: formData.get('cancel_policy') || '',
        purchase_limit: formData.get('purchase_limit') || null,
        enable_flg: formData.get('enable_flg') || 1,
        price_unit: formData.get('price_unit') || '人',
        charge_type: formData.get('charge_type') || 'per_person',
        charge_description: formData.get('charge_description') || '',
        prices: priceData
    };
    
    try {
        // 画像アップロード処理
        const imageFile = formData.get('image');
        if (imageFile && imageFile.size > 0) {
            console.log('画像アップロード開始');
            const imageFormData = new FormData();
            imageFormData.append('image', imageFile);
            imageFormData.append('product_id', isEditMode ? productId : 'temp');

            const uploadResponse = await axios.post('/api/products/upload-image', imageFormData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            });

            data.image_url = uploadResponse.data.url;
            console.log('画像アップロード完了:', data.image_url);
        }

        // 商品登録/更新
        let response;
        if (isEditMode) {
            response = await axios.put(`/api/products/${productId}`, data);
            alert('商品を更新しました！');
        } else {
            response = await axios.post('/api/products', data);
            alert('商品を登録しました！');
        }
        
        window.location.href = '/admin/products';
    } catch (error) {
        console.error('Error:', error);
        alert((isEditMode ? '更新' : '登録') + 'に失敗しました: ' + (error.response?.data?.error || error.message));
    }
});
