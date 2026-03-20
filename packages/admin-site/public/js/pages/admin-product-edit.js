// Admin Product Edit Page Script

let isEditMode = false;
let productId = null;
let priceBandCounter = 0;
let currentEventId = null;
let currentEventName = null;

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', async function() {
  console.log('商品編集ページを初期化');
  
  // URLクエリパラメータからproduct IDとevent情報を取得
  const urlParams = new URLSearchParams(window.location.search);
  const id = urlParams.get('id');
  currentEventId = urlParams.get('event_id');
  currentEventName = urlParams.get('event_name');
  
  // キャンセルボタンのリンクを更新
  updateCancelLink();
  
  if (id && id !== 'new') {
    isEditMode = true;
    productId = id;
    document.getElementById('formTitle').textContent = '商品編集';
    console.log('編集モード: 商品ID =', productId);
  } else {
    console.log('新規登録モード');
  }
  
  try {
    // ローディングを非表示、フォームを表示（イベントリスナー設定前に表示）
    const loadingEl = document.getElementById('loading');
    const formEl = document.getElementById('productForm');
    const priceBandsContainer = document.getElementById('priceBandsContainer');
    
    if (!loadingEl || !formEl || !priceBandsContainer) {
      throw new Error('必要なDOM要素が見つかりません');
    }
    
    loadingEl.style.display = 'none';
    formEl.style.display = 'block';
    
    // キャンセルリンクを更新（フォーム表示後）
    updateCancelLink();
    
    // イベント一覧を読み込み
    await loadEvents();
    
    // 商品カテゴリー一覧を読み込み
    await loadProductCategories();
    
    // 編集モードの場合、商品データを読み込み
    if (isEditMode) {
      await loadProductData();
    } else {
      // 新規モードの場合は1つの価格帯を追加
      addPriceBand();
    }
    
    // フォームイベント設定
    formEl.addEventListener('submit', handleSubmit);
    
    // 画像アップロードイベント
    document.getElementById('imageFile').addEventListener('change', handleImageChange);
    document.getElementById('removeImageBtn').addEventListener('click', removeImage);
    
    // 価格帯追加ボタン
    document.getElementById('addPriceBandBtn').addEventListener('click', () => addPriceBand());
    
    // 共通名称が変更されたら価格帯のラベルを更新
    for (let i = 1; i <= 5; i++) {
      const nameInput = document.querySelector(`input[name="common_name_${i}"]`);
      if (nameInput) {
        nameInput.addEventListener('input', updatePriceBandLabels);
      }
    }
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

// キャンセルリンクを更新
function updateCancelLink() {
  const cancelLink = document.querySelector('a[href="/admin/products"]');
  if (cancelLink && currentEventId) {
    const eventIdParam = `?event_id=${currentEventId}`;
    const eventNameParam = currentEventName ? `&event_name=${encodeURIComponent(currentEventName)}` : '';
    cancelLink.href = `/admin/products${eventIdParam}${eventNameParam}`;
  }
}

// イベント一覧を読み込み
async function loadEvents() {
  try {
    const response = await fetch('/api/events?per_page=1000');
    if (!response.ok) throw new Error('イベント一覧の取得に失敗しました');
    
    const data = await response.json();
    const events = data.data || data.events || [];
    
    const select = document.getElementById('event_id');
    events.forEach(event => {
      if (event.enable_flg === 1) {
        const option = document.createElement('option');
        option.value = event.id;
        option.textContent = event.name;
        select.appendChild(option);
      }
    });
  } catch (error) {
    console.error('イベント一覧読み込みエラー:', error);
    throw error;
  }
}

// 商品カテゴリー一覧を読み込み
async function loadProductCategories() {
  try {
    const response = await fetch('/api/product-categories');
    if (!response.ok) throw new Error('商品カテゴリー一覧の取得に失敗しました');
    
    const data = await response.json();
    const categories = data.categories || data || [];
    
    const select = document.getElementById('product_category_id');
    categories.forEach(category => {
      const option = document.createElement('option');
      option.value = category.id;
      option.textContent = category.name;
      select.appendChild(option);
    });
  } catch (error) {
    console.error('商品カテゴリー一覧読み込みエラー:', error);
    // エラーでも続行（カテゴリーは必須ではない）
  }
}

// 商品データを読み込み
async function loadProductData() {
  try {
    console.log('商品データ読み込み開始:', productId);
    const response = await fetch(`/api/products/${productId}`);
    
    if (!response.ok) {
      throw new Error('商品データの読み込みに失敗しました');
    }
    
    const data = await response.json();
    const product = data.product || data;
    
    console.log('商品データ:', product);
    
    // フォームにデータを設定
    setFormData(product);
    
    // 画像を設定
    if (product.image_url) {
      showImagePreview(product.image_url);
    }
    
    // 価格帯データを復元（restorePriceBands内で空の場合は自動的に1つ追加される）
    // APIレスポンスは { product: {..., prices: [...] } } の形式
    restorePriceBands(product.prices || []);
    
    console.log('商品データ読み込み完了');
  } catch (error) {
    console.error('商品データ読み込みエラー:', error);
    window.Utils.showError('商品データの読み込みに失敗しました');
  }
}

// フォームデータ設定
function setFormData(product) {
  // 基本情報
  setValue('event_id', product.event_id);
  setValue('product_category_id', product.product_category_id);
  setValue('name', product.name);
  setValue('sales_start', formatDateTimeLocal(product.sales_start));
  setValue('sales_end', formatDateTimeLocal(product.sales_end));
  setValue('closing_trade', product.closing_trade);
  setValue('purchase_limit', product.purchase_limit);
  setValue('enable_flg', product.enable_flg);
  setValue('display_order', product.display_order || 1);
  setValue('image_url', product.image_url);
  
  // 単位・料金単位・料金説明
  setValue('price_unit', product.price_unit || '人');
  setValue('charge_type', product.charge_type || 'per_person');
  setValue('charge_description', product.charge_description);
  
  // 商品説明
  setValue('description', product.description);
  setValue('remarks', product.remarks);
  setValue('note', product.note);
  
  // 料金情報
  setValue('fee_include', product.fee_include);
  setValue('fee_exclude', product.fee_exclude);
  setValue('deposit_address', product.deposit_address);
  
  // 共通名称設定（common_namesから復元）
  if (product.common_names) {
    try {
      const commonNames = typeof product.common_names === 'string' 
        ? JSON.parse(product.common_names) 
        : product.common_names;
      
      if (Array.isArray(commonNames)) {
        commonNames.forEach((item, index) => {
          const i = index + 1;
          setValue(`common_name_${i}`, item.name || '');
          setValue(`common_desc_${i}`, item.description || '');
        });
      }
    } catch (e) {
      console.error('共通名称のパースエラー:', e);
    }
  }
  
  // 参加者情報設定を復元
  if (product.form_field_settings) {
    try {
      const fieldSettings = typeof product.form_field_settings === 'string' 
        ? JSON.parse(product.form_field_settings) 
        : product.form_field_settings;
      
      // 各フィールドのチェック状態を設定
      const fieldIds = [
        'age', 'gender', 'email', 'phone', 'birth_date', 'address'
      ];
      
      fieldIds.forEach(fieldId => {
        const checkbox = document.getElementById(`field_${fieldId}`);
        if (checkbox) {
          checkbox.checked = fieldSettings[fieldId] === true;
        }
      });
      
      // 姓名統合フィールドの設定
      // lastname_kanji と firstname_kanji が両方 true なら name_kanji をチェック
      const nameKanjiCheckbox = document.getElementById('field_name_kanji');
      if (nameKanjiCheckbox) {
        nameKanjiCheckbox.checked = fieldSettings.lastname_kanji === true && fieldSettings.firstname_kanji === true;
      }
      
      const nameKanaCheckbox = document.getElementById('field_name_kana');
      if (nameKanaCheckbox) {
        nameKanaCheckbox.checked = fieldSettings.lastname_kana === true && fieldSettings.firstname_kana === true;
      }
      
      const nameRomanCheckbox = document.getElementById('field_name_roman');
      if (nameRomanCheckbox) {
        nameRomanCheckbox.checked = fieldSettings.lastname_roman === true && fieldSettings.firstname_roman === true;
      }
      
      console.log('参加者情報設定を復元しました:', fieldSettings);
    } catch (e) {
      console.error('参加者情報設定のパースエラー:', e);
    }
  }
}

// 価格帯データを復元
function restorePriceBands(prices) {
  console.log('価格帯データを復元:', prices);
  
  // 既存の価格帯をクリア
  const container = document.getElementById('priceBandsContainer');
  if (container) {
    container.innerHTML = '';
  }
  
  // カウンターをリセット
  priceBandCounter = 0;
  
  // category_nameから価格帯とスロットを解析（例: "A-名称1" → 価格帯A, スロット1）
  const priceBandData = {};
  
  prices.forEach(priceItem => {
    const categoryName = priceItem.category_name || '';
    const parts = categoryName.split('-');
    
    if (parts.length === 2) {
      const band = parts[0].trim(); // "A", "B", etc.
      const slotPart = parts[1].trim(); // "名称1"
      
      // 末尾の数字を抽出
      let slot = '';
      for (let i = slotPart.length - 1; i >= 0; i--) {
        const char = slotPart[i];
        if (char >= '0' && char <= '9') {
          slot = char + slot;
        } else {
          break;
        }
      }
      
      if (slot) {
        if (!priceBandData[band]) {
          priceBandData[band] = {};
        }
        priceBandData[band][slot] = priceItem.price;
      }
    }
  });
  
  console.log('解析された価格帯データ:', priceBandData);
  
  // 価格帯がない場合はデフォルトで1つ追加
  if (Object.keys(priceBandData).length === 0) {
    console.log('価格帯データがないため、デフォルトを追加');
    addPriceBand();
    return;
  }
  
  // 価格帯を追加
  const bands = Object.keys(priceBandData).sort();
  bands.forEach(bandLetter => {
    addPriceBand(bandLetter, priceBandData[bandLetter]);
  });
}

// 入力値設定ヘルパー
function setValue(id, value) {
  const element = document.getElementById(id) || document.querySelector(`[name="${id}"]`);
  if (element && value !== null && value !== undefined) {
    element.value = value;
  }
}

// 日時をdatetime-local形式に変換
function formatDateTimeLocal(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  // 日本時間（JST: UTC+9）に変換
  const jstDate = new Date(date.toLocaleString('en-US', { timeZone: 'Asia/Tokyo' }));
  const year = jstDate.getFullYear();
  const month = String(jstDate.getMonth() + 1).padStart(2, '0');
  const day = String(jstDate.getDate()).padStart(2, '0');
  const hours = String(jstDate.getHours()).padStart(2, '0');
  const minutes = String(jstDate.getMinutes()).padStart(2, '0');
  return `${year}-${month}-${day}T${hours}:${minutes}`;
}

// 共通名称設定を取得する関数
function getCommonNameLabels() {
  const labels = [];
  for (let i = 1; i <= 5; i++) {
    const nameElement = document.querySelector(`input[name="common_name_${i}"]`);
    const name = nameElement ? nameElement.value.trim() : '';
    if (name) {
      labels.push(`名称${i}（${name}）`);
    } else {
      labels.push(`名称${i}`);
    }
  }
  return labels;
}

// 価格帯を追加
function addPriceBand(bandLetter = null, priceData = null) {
  priceBandCounter++;
  const bandId = 'band_' + priceBandCounter;
  const displayLetter = bandLetter || String.fromCharCode(64 + priceBandCounter); // A, B, C...
  
  // 共通名称設定のラベルを取得
  const commonLabels = getCommonNameLabels();
  
  const bandHtml = `
    <div class="form-section" id="${bandId}" data-band-letter="${displayLetter}" style="border-left: 4px solid #2563eb; background-color: #f9fafb;">
      <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.75rem;">
        <h4 style="font-size: 0.875rem; font-weight: 700; color: #1f2937; margin: 0;">
          <i class="fas fa-layer-group" style="color: #16a34a; margin-right: 0.25rem;"></i>
          価格帯 ${displayLetter}
        </h4>
        <button type="button" onclick="removePriceBand('${bandId}')" class="btn btn-sm btn-danger" style="font-size: 0.875rem;">
          <i class="fas fa-trash" style="margin-right: 0.25rem;"></i>削除
        </button>
      </div>
      <div style="display: flex; flex-direction: column; gap: 0.5rem;">
        <div style="display: grid; grid-template-columns: auto repeat(5, 1fr); gap: 0.5rem; align-items: center;">
          <div></div>
          <span class="price-label" style="font-size: 0.75rem; font-weight: 700; text-align: center;">${commonLabels[0]}</span>
          <span class="price-label" style="font-size: 0.75rem; font-weight: 700; text-align: center;">${commonLabels[1]}</span>
          <span class="price-label" style="font-size: 0.75rem; font-weight: 700; text-align: center;">${commonLabels[2]}</span>
          <span class="price-label" style="font-size: 0.75rem; font-weight: 700; text-align: center;">${commonLabels[3]}</span>
          <span class="price-label" style="font-size: 0.75rem; font-weight: 700; text-align: center;">${commonLabels[4]}</span>
        </div>
        <div style="display: grid; grid-template-columns: auto repeat(5, 1fr); gap: 0.5rem; align-items: center;">
          <span style="font-size: 0.75rem; font-weight: 700;">価格</span>
          <input type="number" name="price_${priceBandCounter}_1" min="0" placeholder="0" value="${priceData && priceData[1] !== undefined ? priceData[1] : ''}" class="form-control" style="font-size: 0.875rem; padding: 0.5rem;">
          <input type="number" name="price_${priceBandCounter}_2" min="0" placeholder="0" value="${priceData && priceData[2] !== undefined ? priceData[2] : ''}" class="form-control" style="font-size: 0.875rem; padding: 0.5rem;">
          <input type="number" name="price_${priceBandCounter}_3" min="0" placeholder="0" value="${priceData && priceData[3] !== undefined ? priceData[3] : ''}" class="form-control" style="font-size: 0.875rem; padding: 0.5rem;">
          <input type="number" name="price_${priceBandCounter}_4" min="0" placeholder="0" value="${priceData && priceData[4] !== undefined ? priceData[4] : ''}" class="form-control" style="font-size: 0.875rem; padding: 0.5rem;">
          <input type="number" name="price_${priceBandCounter}_5" min="0" placeholder="0" value="${priceData && priceData[5] !== undefined ? priceData[5] : ''}" class="form-control" style="font-size: 0.875rem; padding: 0.5rem;">
        </div>
      </div>
    </div>
  `;
  
  const container = document.getElementById('priceBandsContainer');
  if (!container) {
    console.error('priceBandsContainer が見つかりません');
    return;
  }
  container.insertAdjacentHTML('beforeend', bandHtml);
}

// 価格帯を削除
window.removePriceBand = function(bandId) {
  const band = document.getElementById(bandId);
  if (band) {
    const container = document.getElementById('priceBandsContainer');
    if (container.children.length <= 1) {
      window.Utils.showError('最低1つの価格帯が必要です');
      return;
    }
    band.remove();
  }
};

// 価格帯のラベルを更新
function updatePriceBandLabels() {
  const commonLabels = getCommonNameLabels();
  
  // すべての価格帯のラベルを更新
  const priceBands = document.querySelectorAll('#priceBandsContainer > div');
  priceBands.forEach(band => {
    const labels = band.querySelectorAll('.price-label');
    labels.forEach((label, index) => {
      if (index < commonLabels.length) {
        label.textContent = commonLabels[index];
      }
    });
  });
}

// 画像変更処理
function handleImageChange(e) {
  const file = e.target.files[0];
  if (!file) return;
  
  // ファイルサイズチェック（5MB）
  if (file.size > 5 * 1024 * 1024) {
    window.Utils.showError('画像サイズは5MB以下にしてください');
    e.target.value = '';
    return;
  }
  
  // プレビュー表示
  const reader = new FileReader();
  reader.onload = function(e) {
    showImagePreview(e.target.result);
  };
  reader.readAsDataURL(file);
}

// 画像プレビュー表示
function showImagePreview(url) {
  document.getElementById('previewImage').src = url;
  document.getElementById('imagePreview').style.display = 'block';
}

// 画像削除
function removeImage() {
  document.getElementById('image_url').value = '';
  document.getElementById('previewImage').src = '';
  document.getElementById('imagePreview').style.display = 'none';
  document.getElementById('imageFile').value = '';
}

// フォーム送信処理
async function handleSubmit(e) {
  e.preventDefault();
  
  try {
    const formData = new FormData(e.target);
    const data = {};
    
    // 基本フィールドを取得
    formData.forEach((value, key) => {
      // 価格フィールド、共通名称、参加者情報設定は後で処理
      if (!key.startsWith('price_') && 
          !key.startsWith('common_name_') && 
          !key.startsWith('common_desc_') &&
          !key.startsWith('field_')) {
        if (['event_id', 'closing_trade', 'purchase_limit', 'enable_flg', 'display_order'].includes(key)) {
          data[key] = value ? parseInt(value) : (key === 'display_order' ? 1 : 0);
        } else {
          data[key] = value || null;
        }
      }
    });
    
    // client_idを追加（仮に1）
    data.client_id = 1;
    
    // 共通名称を配列形式で収集
    const commonNames = [];
    for (let i = 1; i <= 5; i++) {
      const name = formData.get(`common_name_${i}`) || '';
      const description = formData.get(`common_desc_${i}`) || '';
      if (name) {
        commonNames.push({ name, description });
      }
    }
    // バックエンドでJSON.stringify()するため、ここでは配列のまま送る
    data.common_names = commonNames;
    
    // 価格帯データを配列形式で収集
    const prices = [];
    const priceBands = document.querySelectorAll('#priceBandsContainer > div');
    
    priceBands.forEach((band, index) => {
      const bandLetter = band.getAttribute('data-band-letter');
      const bandNumber = index + 1;
      
      for (let slot = 1; slot <= 5; slot++) {
        const priceInput = formData.get(`price_${bandNumber}_${slot}`);
        
        // 価格が入力されている場合（0円を含む）のみ登録
        if (priceInput !== null && priceInput !== '') {
          const price = parseInt(priceInput);
          
          // 数値として有効な場合のみ追加（0円も含む）
          if (!isNaN(price) && price >= 0) {
            const commonName = commonNames[slot - 1] ? commonNames[slot - 1].name : `名称${slot}`;
            prices.push({
              price_band: bandLetter,
              category_name: `${bandLetter}-名称${slot}`,
              price_name: commonName,
              price: price,
              slot_number: slot,
              display_order: index
            });
          }
        }
      }
    });
    
    data.prices = prices;
    
    // 参加者情報設定を収集
    const nameKanjiChecked = document.getElementById('field_name_kanji')?.checked || false;
    const nameKanaChecked = document.getElementById('field_name_kana')?.checked || false;
    const nameRomanChecked = document.getElementById('field_name_roman')?.checked || false;
    
    const formFieldSettings = {
      name_kanji: nameKanjiChecked,
      lastname_kanji: nameKanjiChecked,
      firstname_kanji: nameKanjiChecked,
      name_kana: nameKanaChecked,
      lastname_kana: nameKanaChecked,
      firstname_kana: nameKanaChecked,
      name_roman: nameRomanChecked,
      lastname_roman: nameRomanChecked,
      firstname_roman: nameRomanChecked,
      age: document.getElementById('field_age')?.checked || false,
      gender: document.getElementById('field_gender')?.checked || false,
      email: document.getElementById('field_email')?.checked || false,
      phone: document.getElementById('field_phone')?.checked || false,
      birth_date: document.getElementById('field_birth_date')?.checked || false,
      address: document.getElementById('field_address')?.checked || false
    };
    
    // JSON文字列として送信
    data.form_field_settings = JSON.stringify(formFieldSettings);
    
    console.log('参加者情報設定:', formFieldSettings);
    
    // 画像ファイルがある場合は先にアップロード
    const imageFile = document.getElementById('imageFile');
    if (imageFile && imageFile.files && imageFile.files[0]) {
      const file = imageFile.files[0];
      const imageFormData = new FormData();
      imageFormData.append('image', file);
      
      const uploadResponse = await fetch('/api/products/upload-image', {
        method: 'POST',
        body: imageFormData
      });
      
      if (uploadResponse.ok) {
        const uploadData = await uploadResponse.json();
        data.image_url = uploadData.image_url;
      }
    }
    
    console.log('送信データ:', data);
    
    // API呼び出し
    const url = isEditMode ? `/api/products/${productId}` : '/api/products';
    const method = isEditMode ? 'PUT' : 'POST';
    
    const response = await fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '保存に失敗しました');
    }
    
    const result = await response.json();
    console.log('保存成功:', result);
    
    window.Utils.showSuccess(isEditMode ? '商品を更新しました' : '商品を登録しました');
    
    // 一覧画面に戻る（event_idがあれば含める）
    setTimeout(() => {
      let redirectUrl = '/admin/products';
      if (currentEventId) {
        redirectUrl += `?event_id=${currentEventId}`;
        if (currentEventName) {
          redirectUrl += `&event_name=${encodeURIComponent(currentEventName)}`;
        }
      }
      window.location.href = redirectUrl;
    }, 1000);
    
  } catch (error) {
    console.error('保存エラー:', error);
    window.Utils.showError(error.message || '保存に失敗しました');
  }
}
