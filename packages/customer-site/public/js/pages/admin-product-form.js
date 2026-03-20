/**
 * Admin Product Form Page Script
 * 商品登録・編集ページ（HTML5版）
 */

(function() {
'use strict';

// ページモードの判定
const urlPath = window.location.pathname;
const isEditMode = urlPath.includes('/edit');
const productId = isEditMode ? urlPath.split('/')[3] : null;

console.log('商品フォームページを初期化', { isEditMode, productId });

// グローバル変数
let currentImageUrl = '';
const priceBands = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
const usedBands = new Set();
let priceBandCounter = 0;

// ユーティリティ関数
const showLoading = (show) => {
  const loading = document.getElementById('loading');
  if (loading) {
    loading.classList.toggle('hidden', !show);
  }
};

const showError = (message) => {
  const errorDiv = document.getElementById('errorMessage');
  if (errorDiv) {
    errorDiv.textContent = message;
    errorDiv.classList.remove('hidden');
    errorDiv.style.cssText = 'background-color: #fee; color: #c00; padding: 1rem; margin: 1rem 0; border-radius: 0.375rem; border: 1px solid #fcc;';
    setTimeout(() => {
      errorDiv.classList.add('hidden');
    }, 5000);
  }
};

const showSuccess = (message) => {
  alert(message);
};

// 画像プレビュー設定
const setupImagePreview = () => {
  const imageFile = document.getElementById('imageFile');
  const previewImg = document.getElementById('previewImg');
  const noImageText = document.getElementById('noImageText');
  
  if (!imageFile || !previewImg || !noImageText) return;
  
  imageFile.addEventListener('change', (e) => {
    const file = e.target.files[0];
    
    if (!file) {
      previewImg.classList.add('hidden');
      noImageText.classList.remove('hidden');
      return;
    }
    
    // ファイルサイズチェック（5MB）
    if (file.size > 5 * 1024 * 1024) {
      showError('画像ファイルは5MB以下にしてください。');
      imageFile.value = '';
      return;
    }
    
    // プレビュー表示
    const reader = new FileReader();
    reader.onload = (event) => {
      previewImg.src = event.target.result;
      previewImg.classList.remove('hidden');
      noImageText.classList.add('hidden');
    };
    reader.readAsDataURL(file);
  });
};

// 価格帯グループの追加
const addPriceBand = () => {
  const availableBands = priceBands.filter(band => !usedBands.has(band));
  
  if (availableBands.length === 0) {
    showError('価格帯は最大26個（A～Z）まで追加できます。');
    return;
  }
  
  const defaultBand = availableBands[0];
  usedBands.add(defaultBand);
  
  const groupId = ++priceBandCounter;
  const container = document.getElementById('priceBandsContainer');
  
  // 価格帯選択のオプション
  const bandOptions = availableBands.map(band => 
    `<option value="${band}" ${band === defaultBand ? 'selected' : ''}>${band}</option>`
  ).join('');
  
  const groupHtml = `
    <div class="price-band-group" data-group-id="${groupId}" data-band="${defaultBand}" style="border: 2px solid #cbd5e1; border-radius: 0.5rem; padding: 1rem; margin-bottom: 1rem;">
      <div class="form-row" style="display: grid; grid-template-columns: 1fr auto; gap: 1rem; align-items: center; margin-bottom: 0.75rem;">
        <div class="form-group" style="margin: 0;">
          <label class="form-label">価格帯</label>
          <select class="price-band-select form-control" data-group-id="${groupId}">
            ${bandOptions}
          </select>
        </div>
        <button type="button" class="btn btn-danger remove-price-band-btn" data-group-id="${groupId}" style="margin-top: 1.75rem;">
          <i class="fas fa-trash"></i> 削除
        </button>
      </div>
      
      <div class="price-inputs" style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 0.75rem;">
        ${[1, 2, 3, 4, 5].map(i => `
          <div class="form-group" style="margin-bottom: 0;">
            <label class="form-label price-label-${i}" style="font-size: 0.75rem;">名称${i}</label>
            <input type="number" name="price_${defaultBand}_${i}" min="0" class="form-control" placeholder="価格" style="font-size: 0.8rem; padding: 0.4rem 0.5rem;">
          </div>
        `).join('')}
      </div>
    </div>
  `;
  
  container.insertAdjacentHTML('beforeend', groupHtml);
  
  // イベントリスナーを設定
  setupPriceBandEventListeners(groupId);
  
  // 共通名称の現在値を新しい価格帯のラベルに反映
  applyCommonNamesToNewBand(groupId);
};

// 価格帯のイベントリスナー設定
const setupPriceBandEventListeners = (groupId) => {
  // 削除ボタン
  const removeBtn = document.querySelector(`.remove-price-band-btn[data-group-id="${groupId}"]`);
  if (removeBtn) {
    removeBtn.addEventListener('click', () => {
      const group = document.querySelector(`.price-band-group[data-group-id="${groupId}"]`);
      if (group) {
        const band = group.dataset.band;
        usedBands.delete(band);
        group.remove();
      }
    });
  }
  
  // 価格帯選択の変更
  const select = document.querySelector(`.price-band-select[data-group-id="${groupId}"]`);
  if (select) {
    select.addEventListener('change', (e) => {
      const group = document.querySelector(`.price-band-group[data-group-id="${groupId}"]`);
      if (group) {
        const oldBand = group.dataset.band;
        const newBand = e.target.value;
        
        usedBands.delete(oldBand);
        usedBands.add(newBand);
        
        group.dataset.band = newBand;
        
        // 価格入力フィールドのname属性を更新
        const priceGroups = group.querySelectorAll('.form-group');
        priceGroups.forEach((priceGroup, index) => {
          const i = index + 1;
          const priceInput = priceGroup.querySelector('input[type="number"]');
          if (priceInput) {
            priceInput.name = `price_${newBand}_${i}`;
          }
        });
      }
    });
  }
};

// 共通名称設定の変更を価格設定ラベルに反映
const setupCommonNameListeners = () => {
  [1, 2, 3, 4, 5].forEach(i => {
    const input = document.getElementById(`commonName${i}`);
    if (input) {
      input.addEventListener('change', () => {
        updatePriceLabels(i, input.value.trim());
      });
    }
  });
};

// 価格設定のラベルを更新
const updatePriceLabels = (nameIndex, nameValue) => {
  const labelText = nameValue || `名称${nameIndex}`;
  const labels = document.querySelectorAll(`.price-label-${nameIndex}`);
  labels.forEach(label => {
    label.textContent = labelText;
  });
};

// 新しく追加した価格帯に共通名称を適用
const applyCommonNamesToNewBand = (groupId) => {
  const group = document.querySelector(`.price-band-group[data-group-id="${groupId}"]`);
  if (!group) return;
  
  // 共通名称1〜5の現在値を取得して適用
  [1, 2, 3, 4, 5].forEach(i => {
    const input = document.getElementById(`commonName${i}`);
    const nameValue = input ? input.value.trim() : '';
    
    if (nameValue) {
      const label = group.querySelector(`.price-label-${i}`);
      if (label) {
        label.textContent = nameValue;
      }
    }
  });
};

// イベント一覧の読み込み
const loadEvents = async () => {
  console.log('イベント一覧読み込み開始');
  try {
    const response = await fetch('/api/v1/events?per_page=1000');
    if (!response.ok) throw new Error('イベント一覧の取得に失敗しました');
    
    const data = await response.json();
    const eventSelect = document.getElementById('eventId');
    
    if (data.data && data.data.length > 0) {
      data.data.forEach(event => {
        const option = document.createElement('option');
        option.value = event.id;
        option.textContent = event.name;
        eventSelect.appendChild(option);
      });
      console.log(`${data.data.length}件のイベントを読み込みました`);
    }
  } catch (error) {
    console.error('イベント読み込みエラー:', error);
    showError('イベント一覧の読み込みに失敗しました。');
  }
};

// 商品データの読み込み（編集モード）
const loadProduct = async () => {
  if (!isEditMode || !productId) {
    console.log('編集モードではありません', { isEditMode, productId });
    return;
  }
  
  console.log('商品データ読み込み開始', { productId });
  
  try {
    showLoading(true);
    
    const response = await fetch(`/api/products/${productId}`);
    console.log('APIレスポンス:', response.status);
    
    if (!response.ok) throw new Error('商品データの取得に失敗しました');
    
    const data = await response.json();
    console.log('取得データ:', data);
    
    // レスポンスからproductオブジェクトを取得
    const product = data.product || data;
    console.log('商品情報:', product);
    
    // フォームにデータを設定
    const form = document.getElementById('productForm');
    if (!form) {
      console.error('フォームが見つかりません');
      throw new Error('フォームが見つかりません');
    }
    
    console.log('フォーム要素:', form);
    
    // 基本情報の設定
    const nameField = document.getElementById('name');
    const eventIdField = document.getElementById('eventId');
    
    // 販売情報設定の新フィールド
    const salesStartField = document.getElementById('salesStart');
    const salesEndField = document.getElementById('salesEnd');
    const closingDaysField = document.getElementById('closingDays');
    const descriptionField = document.getElementById('description');
    const feeIncludeField = document.getElementById('feeInclude');
    const feeExcludeField = document.getElementById('feeExclude');
    const cancelPolicyField = document.getElementById('cancelPolicy');
    const enableFlgField = document.getElementById('enableFlg');
    
    if (nameField) nameField.value = product.name || '';
    if (eventIdField) eventIdField.value = product.event_id || '';
    
    // 日時フィールドの設定（ISO 8601形式に変換）
    if (product.sales_start && salesStartField) {
      const salesStart = product.sales_start.replace(' ', 'T').substring(0, 16);
      console.log('販売開始:', product.sales_start, '→', salesStart);
      salesStartField.value = salesStart;
    }
    if (product.sales_end && salesEndField) {
      const salesEnd = product.sales_end.replace(' ', 'T').substring(0, 16);
      console.log('販売終了:', product.sales_end, '→', salesEnd);
      salesEndField.value = salesEnd;
    }
    
    // 販売情報設定の他のフィールド
    if (closingDaysField && product.closing_trade) closingDaysField.value = product.closing_trade;
    if (descriptionField && product.description) descriptionField.value = product.description;
    if (feeIncludeField && product.fee_include) feeIncludeField.value = product.fee_include;
    if (feeExcludeField && product.fee_exclude) feeExcludeField.value = product.fee_exclude;
    if (cancelPolicyField && product.cancel_policy) cancelPolicyField.value = product.cancel_policy;
    if (enableFlgField) enableFlgField.checked = product.enable_flg === 1;
    
    // 画像プレビュー
    if (product.image_url) {
      currentImageUrl = product.image_url;
      const previewImg = document.getElementById('previewImg');
      const noImageText = document.getElementById('noImageText');
      if (previewImg && noImageText) {
        previewImg.src = product.image_url;
        previewImg.classList.remove('hidden');
        noImageText.classList.add('hidden');
      }
    }
    
    // 単位フィールドの読み込み
    // 共通名称設定の読み込み
    const priceUnitField = form.querySelector('#priceUnit');
    const chargeTypeField = form.querySelector('#chargeType');
    const chargeDescField = form.querySelector('#chargeDescription');
    
    if (priceUnitField && product.price_unit) {
      priceUnitField.value = product.price_unit;
    }
    if (chargeTypeField && product.charge_type) {
      chargeTypeField.value = product.charge_type;
    }
    if (chargeDescField && product.charge_description) {
      chargeDescField.value = product.charge_description;
    }
    
    // 入力フォーム項目設定の読み込み
    console.log('=== フォーム設定読み込み ===');
    console.log('product.form_field_settings:', product.form_field_settings);
    
    if (product.form_field_settings) {
      try {
        const formSettings = typeof product.form_field_settings === 'string' 
          ? JSON.parse(product.form_field_settings) 
          : product.form_field_settings;
        
        console.log('パース後のformSettings:', formSettings);
        
        const formNameKanjiField = form.querySelector('#form_name_kanji');
        const formNameKanaField = form.querySelector('#form_name_kana');
        const formNameRomaField = form.querySelector('#form_name_roma');
        const formAddressField = form.querySelector('#form_address');
        const formTelField = form.querySelector('#form_tel');
        const formBirthDateField = form.querySelector('#form_birth_date');
        const formAgeField = form.querySelector('#form_age');
        
        console.log('フォーム要素:', {
          formNameKanjiField,
          formNameKanaField,
          formNameRomaField,
          formAddressField,
          formTelField,
          formBirthDateField,
          formAgeField
        });
        
        if (formNameKanjiField) formNameKanjiField.checked = formSettings.name_kanji === true;
        if (formNameKanaField) formNameKanaField.checked = formSettings.name_kana === true;
        if (formNameRomaField) formNameRomaField.checked = formSettings.name_roma === true;
        if (formAddressField) formAddressField.checked = formSettings.address === true;
        if (formTelField) formTelField.checked = formSettings.tel === true;
        if (formBirthDateField) formBirthDateField.checked = formSettings.birth_date === true;
        if (formAgeField) formAgeField.checked = formSettings.age === true;
        
        console.log('チェック状態設定完了');
      } catch (e) {
        console.error('フォーム設定の解析エラー:', e);
      }
    } else {
      console.log('form_field_settingsが存在しません');
    }
    
    // 共通名称と補足説明の読み込み
    if (product.common_names) {
      let commonNames = [];
      if (typeof product.common_names === 'string') {
        try {
          commonNames = JSON.parse(product.common_names);
        } catch (e) {
          console.error('共通名称のパースエラー:', e);
        }
      } else if (Array.isArray(product.common_names)) {
        commonNames = product.common_names;
      }
      
      commonNames.forEach((item, index) => {
        const nameIndex = index + 1;
        const nameField = form.querySelector(`#commonName${nameIndex}`);
        const descField = form.querySelector(`#commonDesc${nameIndex}`);
        
        if (typeof item === 'string') {
          // 文字列の場合は名称のみ
          if (nameField) {
            nameField.value = item || '';
            updatePriceLabels(nameIndex, item); // ラベル更新
          }
        } else if (typeof item === 'object' && item !== null) {
          // オブジェクトの場合は名称と補足説明
          if (nameField && item.name) {
            nameField.value = item.name || '';
            updatePriceLabels(nameIndex, item.name); // ラベル更新
          }
          if (descField && item.description) descField.value = item.description || '';
        }
      });
    }
    
    // 価格帯情報の読み込み
    console.log('価格情報:', product.prices);
    if (product.prices && Array.isArray(product.prices) && product.prices.length > 0) {
      // 価格帯別にグループ化
      const priceGroups = {};
      product.prices.forEach(price => {
        // price_bandがnullの場合、category_nameから抽出（例: "A-名称1" → "A"）
        let band = price.price_band;
        if (!band && price.category_name) {
          const match = price.category_name.match(/^([A-Z])-/);
          if (match) {
            band = match[1];
          }
        }
        // デフォルトはA
        band = band || 'A';
        
        if (!priceGroups[band]) {
          priceGroups[band] = [];
        }
        
        // category_nameから名称番号を抽出（例: "A-名称1" → 1）
        let nameIndex = price.display_order;
        if (!nameIndex && price.category_name) {
          const match = price.category_name.match(/名称(\d+)$/);
          if (match) {
            nameIndex = parseInt(match[1]);
          }
        }
        nameIndex = nameIndex || 1;
        
        priceGroups[band].push({
          ...price,
          nameIndex: nameIndex
        });
      });
      
      console.log('価格帯別グループ:', priceGroups);
      
      // 各価格帯のデータを設定
      Object.keys(priceGroups).sort().forEach(band => {
        addPriceBand();
        
        setTimeout(() => {
          // 最後に追加された価格帯グループを取得
          const groups = document.querySelectorAll('.price-band-group');
          const lastGroup = groups[groups.length - 1];
          
          if (lastGroup) {
            // 価格帯の選択
            const select = lastGroup.querySelector('.price-band-select');
            if (select) {
              select.value = band;
              select.dispatchEvent(new Event('change'));
            }
            
            // 価格情報を設定
            priceGroups[band].forEach(price => {
              const priceInput = lastGroup.querySelector(`input[name="price_${band}_${price.nameIndex}"]`);
              console.log(`価格設定: price_${band}_${price.nameIndex} = ${price.price}`, priceInput);
              if (priceInput) {
                priceInput.value = price.price || '';
              }
            });
          }
        }, 100);
      });
    } else {
      // 価格情報がない場合はデフォルトで1つ追加
      addPriceBand();
    }
    
    // キャンセル条件設定の読み込み
    if (product.cancellation_bands && Array.isArray(product.cancellation_bands)) {
      product.cancellation_bands.forEach((band, index) => {
        addCancellationBand();
        setTimeout(() => {
          const daysInput = form.querySelector(`input[name="cancellation_days_${cancellationBandCounter - 1}"]`);
          const rateInput = form.querySelector(`input[name="cancellation_rate_${cancellationBandCounter - 1}"]`);
          if (daysInput) daysInput.value = band.days || '';
          if (rateInput) rateInput.value = band.rate || '';
        }, 100);
      });
    }
    
    showLoading(false);
  } catch (error) {
    console.error('商品読み込みエラー:', error);
    showError('商品データの読み込みに失敗しました。');
    showLoading(false);
  }
};

// 画像のアップロード
const uploadImage = async (file) => {
  if (!file) return null;
  
  const formData = new FormData();
  formData.append('image', file);
  
  try {
    const response = await fetch('/api/products/upload-image', {
      method: 'POST',
      body: formData
    });
    
    if (!response.ok) throw new Error('画像アップロードに失敗しました');
    
    const result = await response.json();
    return result.image_url;
  } catch (error) {
    console.error('画像アップロードエラー:', error);
    throw error;
  }
};

// フォーム送信処理
const handleSubmit = async (e) => {
  e.preventDefault();
  
  const form = e.target;
  
  try {
    showLoading(true);
    
    // 画像アップロード
    let imageUrl = currentImageUrl;
    const imageFile = form.image.files[0];
    if (imageFile) {
      imageUrl = await uploadImage(imageFile);
    }
    
    // 共通名称と補足説明の収集
    const commonNames = [];
    console.log('=== 共通名称の収集開始 ===');
    for (let i = 1; i <= 5; i++) {
      const nameInput = form[`common_name_${i}`];
      const descInput = form[`common_desc_${i}`];
      console.log(`名称${i}の要素:`, nameInput, descInput);
      
      const name = nameInput?.value?.trim();
      const description = descInput?.value?.trim();
      console.log(`名称${i}の値: name="${name}", description="${description}"`);
      
      if (name) {
        const item = {
          label: `名称${i}`,
          name: name,
          description: description || ''
        };
        console.log(`名称${i}を追加:`, item);
        commonNames.push(item);
      }
    }
    console.log('最終的な共通名称配列:', commonNames);
    
    // キャンセルポリシー詳細の収集
    const cancellationPolicyDetails = [];
    for (let i = 1; i <= 5; i++) {
      const days = form[`cancellation_days_${i}`]?.value;
      const rate = form[`cancellation_rate_${i}`]?.value;
      if (days && rate) {
        cancellationPolicyDetails.push({
          days: parseInt(days),
          rate: parseFloat(rate)
        });
      }
    }
    
    // 価格情報の収集
    const prices = [];
    const priceBandGroups = document.querySelectorAll('.price-band-group');
    priceBandGroups.forEach(group => {
      const band = group.dataset.band;
      const priceInputs = group.querySelectorAll('input[type="number"]');
      
      priceInputs.forEach((input, index) => {
        const price = input.value;
        if (price && parseFloat(price) > 0) {
          const commonNameIndex = index + 1;
          prices.push({
            price_band: band,
            common_name_index: commonNameIndex,
            price: parseFloat(price)
          });
        }
      });
    });
    
    if (prices.length === 0) {
      showError('少なくとも1つの価格を設定してください。');
      showLoading(false);
      return;
    }
    
    // リクエストデータの作成
    const data = {
      name: form.name.value,
      event_id: parseInt(form.event_id.value),
      description: form.description?.value || null,
      remarks: null,  // 削除されたフィールド（API互換性のため）
      sales_start: form.sales_start.value.replace('T', ' '),
      sales_end: form.sales_end.value.replace('T', ' '),
      closing_trade: parseInt(form.closing_trade?.value || 0),
      purchase_limit: null,  // 削除されたフィールド（API互換性のため）
      price_unit: form.price_unit?.value || null,
      charge_type: form.charge_type?.value || 'per_person',
      charge_description: form.charge_description?.value || null,
      fee_include: form.fee_include?.value || null,
      fee_exclude: form.fee_exclude?.value || null,
      cancel_policy: form.cancel_policy?.value || null,
      enable_flg: form.enable_flg?.checked ? 1 : 0,
      common_names: commonNames,
      cancellation_policy_details: cancellationPolicyDetails,
      prices: prices,
      image_url: imageUrl || null,
      form_field_settings: JSON.stringify({
        name_kanji: form.form_name_kanji?.checked || false,
        name_kana: form.form_name_kana?.checked || false,
        name_roma: form.form_name_roma?.checked || false,
        address: form.form_address?.checked || false,
        tel: form.form_tel?.checked || false,
        birth_date: form.form_birth_date?.checked || false,
        age: form.form_age?.checked || false
      })
    };
    
    // フォーム設定のデバッグログ
    console.log('=== フォーム設定確認 ===');
    console.log('form_name_kanji要素:', form.form_name_kanji);
    console.log('form_name_kanji.checked:', form.form_name_kanji?.checked);
    console.log('form_field_settings:', data.form_field_settings);
    
    // API送信
    const url = isEditMode ? `/api/products/${productId}` : '/api/products';
    const method = isEditMode ? 'PUT' : 'POST';
    
    console.log('=== API送信情報 ===');
    console.log('編集モード:', isEditMode);
    console.log('商品ID:', productId);
    console.log('URL:', url);
    console.log('メソッド:', method);
    console.log('送信データ:', data);
    
    const response = await fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    });
    
    if (!response.ok) {
      const error = await response.json();
      console.error('APIエラー:', error);
      
      // UNIQUE制約エラーの場合、分かりやすいメッセージに変換
      if (error.error && error.error.includes('UNIQUE constraint')) {
        throw new Error('同じイベントで同じ商品名が既に存在します。商品名を変更してください。');
      }
      
      throw new Error(error.error || '保存に失敗しました');
    }
    
    showSuccess(isEditMode ? '商品を更新しました。' : '商品を登録しました。');
    window.location.href = '/admin/products';
    
  } catch (error) {
    console.error('保存エラー:', error);
    showError(error.message || '保存中にエラーが発生しました。');
    showLoading(false);
  }
};

// 初期化
document.addEventListener('DOMContentLoaded', async () => {
  console.log('商品フォーム初期化開始');
  
  try {
    // フォームHTMLを生成（イベントリスナーもこの中で設定される）
    renderForm();
    
    // 画像プレビュー設定
    setupImagePreview();
    setupCommonNameListeners(); // 共通名称の変更監視
    
    // フォーム送信
    const form = document.getElementById('productForm');
    if (form) {
      form.addEventListener('submit', handleSubmit);
    }
    
    // イベント一覧を読み込み
    await loadEvents();
    
    // 編集モードの場合は商品データを読み込み
    if (isEditMode) {
      await loadProduct();
    } else {
      // 新規作成の場合はデフォルトで1つ価格帯を追加
      addPriceBand();
    }
    
    // ローディングを非表示、フォームを表示
    document.getElementById('loading').style.display = 'none';
    document.getElementById('productFormContainer').style.display = 'block';
    
    console.log('商品フォーム初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    showError('ページの初期化に失敗しました');
  }
});

// フォームHTMLを生成
// 取消条件バンドの追加
let cancellationBandCounter = 0;
function addCancellationBand() {
  const container = document.getElementById('cancellationBands');
  if (!container) return;
  
  const bandId = cancellationBandCounter++;
  const bandDiv = document.createElement('div');
  bandDiv.className = 'form-group';
  bandDiv.style.marginBottom = '1.5rem';
  bandDiv.style.padding = '1rem';
  bandDiv.style.border = '1px solid #e5e7eb';
  bandDiv.style.borderRadius = '0.5rem';
  bandDiv.style.position = 'relative';
  
  bandDiv.innerHTML = `
    <button type="button" class="btn-icon" onclick="this.closest('div').remove();" 
            style="position: absolute; top: 0.5rem; right: 0.5rem;" title="削除">
      <i class="fas fa-times"></i>
    </button>
    <div class="form-row">
      <div class="form-group">
        <label class="form-label">キャンセル日数</label>
        <input type="number" name="cancellation_days_${bandId}" class="form-control" min="0" placeholder="例: 7">
      </div>
      <div class="form-group">
        <label class="form-label">キャンセル料率(%)</label>
        <input type="number" name="cancellation_rate_${bandId}" class="form-control" min="0" max="100" step="0.1" placeholder="例: 50">
      </div>
    </div>
  `;
  container.appendChild(bandDiv);
}

function renderForm() {
  const container = document.getElementById('productFormContainer');
  if (!container) return;
  
  container.innerHTML = `
    <form id="productForm" class="admin-form">
      <!-- 基本情報 -->
      <div class="form-section">
        <h3 class="form-section-title">
          <i class="fas fa-info-circle"></i>
          基本情報
        </h3>
        <div class="form-section-content">
          <div class="form-group">
            <label for="name" class="form-label">商品名</label>
            <input type="text" id="name" name="name" class="form-control" placeholder="サンプル商品A-2">
          </div>
          
          <div class="form-group">
            <label for="eventId" class="form-label">イベント</label>
            <select id="eventId" name="event_id" class="form-control">
              <option value="">選択してください</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="imageFile" class="form-label">商品画像</label>
            <input type="file" id="imageFile" name="image" accept="image/*" class="form-control">
            <small class="form-helper">JPG, PNG, GIF (最大10MB)</small>
            
            <div id="imagePreview" style="margin-top: 1rem;">
              <img id="previewImg" src="" alt="プレビュー" class="hidden" style="max-width: 300px; border-radius: 0.5rem;">
              <p id="noImageText" style="color: #6b7280;">画像が選択されていません</p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 販売情報設定 -->
      <div class="form-section">
        <h3 class="form-section-title">
          <i class="fas fa-cog"></i>
          販売情報設定
        </h3>
        <div class="form-section-content">
          <div class="form-row">
            <div class="form-group">
              <label for="salesStart" class="form-label">販売開始日</label>
              <input type="datetime-local" id="salesStart" name="sales_start" class="form-control">
            </div>
            
            <div class="form-group">
              <label for="salesEnd" class="form-label">販売終了日</label>
              <input type="datetime-local" id="salesEnd" name="sales_end" class="form-control">
            </div>
          </div>
          
          <div class="form-group">
            <label for="closingDays" class="form-label">締切日（何日前）</label>
            <input type="number" id="closingDays" name="closing_trade" class="form-control" min="0" placeholder="例：3">
            <small class="form-helper">イベント開始の何日前に予約を締め切るかを設定</small>
          </div>
          
          <div class="form-group">
            <label for="description" class="form-label">商品説明</label>
            <textarea id="description" name="description" rows="4" class="form-control" placeholder="商品の詳細説明を入力してください"></textarea>
          </div>
          
          <div class="form-group">
            <label for="feeInclude" class="form-label">料金に含まれるもの</label>
            <textarea id="feeInclude" name="fee_include" rows="3" class="form-control" placeholder="例：入場料、施設利用料、消費税"></textarea>
          </div>
          
          <div class="form-group">
            <label for="feeExclude" class="form-label">料金に含まれないもの</label>
            <textarea id="feeExclude" name="fee_exclude" rows="3" class="form-control" placeholder="例：飲食代、駐車場代、お土産代"></textarea>
          </div>
          
          <div class="form-group">
            <label for="cancelPolicy" class="form-label">キャンセルポリシー</label>
            <textarea id="cancelPolicy" name="cancel_policy" rows="4" class="form-control" placeholder="キャンセル規定を入力してください"></textarea>
          </div>
          
          <div class="form-group">
            <label class="form-label">公開状態</label>
            <div style="display: flex; align-items: center; gap: 0.5rem;">
              <input type="checkbox" id="enableFlg" name="enable_flg" value="1" checked>
              <label for="enableFlg" style="margin: 0; font-weight: normal;">公開する</label>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 入力フォーム項目設定 -->
      <div class="form-section">
        <h3 class="form-section-title">
          <i class="fas fa-wpforms"></i>
          入力フォーム項目設定
        </h3>
        <div class="form-section-content">
          <div class="form-group">
            <label class="form-label">予約フォームで表示する項目</label>
            <p class="form-helper">予約フォームで表示する項目を選択してください</p>
            
            <div class="checkbox-group">
              <label class="checkbox-label">
                <input type="checkbox" id="form_name_kanji" name="form_name_kanji" value="1" checked>
                <span>氏名（漢字）</span>
              </label>
              <label class="checkbox-label">
                <input type="checkbox" id="form_name_kana" name="form_name_kana" value="1" checked>
                <span>氏名（カナ）</span>
              </label>
              <label class="checkbox-label">
                <input type="checkbox" id="form_name_roma" name="form_name_roma" value="1">
                <span>氏名（ローマ字）</span>
              </label>
              <label class="checkbox-label">
                <input type="checkbox" id="form_address" name="form_address" value="1" checked>
                <span>住所</span>
              </label>
              <label class="checkbox-label">
                <input type="checkbox" id="form_tel" name="form_tel" value="1" checked>
                <span>電話番号</span>
              </label>
              <label class="checkbox-label">
                <input type="checkbox" id="form_birth_date" name="form_birth_date" value="1">
                <span>生年月日</span>
              </label>
              <label class="checkbox-label">
                <input type="checkbox" id="form_age" name="form_age" value="1">
                <span>年齢</span>
              </label>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 共通名称設定（全価格帯共通） -->
      <div class="form-section">
        <h3 class="form-section-title">
          <i class="fas fa-tags"></i>
          共通名称設定（全価格帯共通）
        </h3>
        <div class="form-section-content">
          <div class="form-row">
            <div class="form-group">
              <label for="priceUnit" class="form-label">単位</label>
              <input type="text" id="priceUnit" name="price_unit" class="form-control" placeholder="例：人、組、席">
            </div>
            
            <div class="form-group">
              <label for="chargeType" class="form-label">料金単位</label>
              <select id="chargeType" name="charge_type" class="form-control">
                <option value="per_person">1名料金</option>
                <option value="per_group">グループ料金</option>
              </select>
            </div>
          </div>
          
          <div class="form-group">
            <label for="chargeDescription" class="form-label">料金説明</label>
            <input type="text" id="chargeDescription" name="charge_description" class="form-control" placeholder="料金に関する説明を入力">
          </div>
          
          <!-- 名称1 -->
          <div class="form-row">
            <div class="form-group">
              <label for="commonName1" class="form-label">名称1</label>
              <input type="text" id="commonName1" name="common_name_1" class="form-control" placeholder="例：大人">
            </div>
            
            <div class="form-group">
              <label for="commonDesc1" class="form-label">補足説明</label>
              <input type="text" id="commonDesc1" name="common_desc_1" class="form-control" placeholder="例：18歳以上">
            </div>
          </div>
          
          <!-- 名称2 -->
          <div class="form-row">
            <div class="form-group">
              <label for="commonName2" class="form-label">名称2</label>
              <input type="text" id="commonName2" name="common_name_2" class="form-control" placeholder="例：子供">
            </div>
            
            <div class="form-group">
              <label for="commonDesc2" class="form-label">補足説明</label>
              <input type="text" id="commonDesc2" name="common_desc_2" class="form-control" placeholder="例：小学生以下">
            </div>
          </div>
          
          <!-- 名称3 -->
          <div class="form-row">
            <div class="form-group">
              <label for="commonName3" class="form-label">名称3</label>
              <input type="text" id="commonName3" name="common_name_3" class="form-control" placeholder="例：シニア">
            </div>
            
            <div class="form-group">
              <label for="commonDesc3" class="form-label">補足説明</label>
              <input type="text" id="commonDesc3" name="common_desc_3" class="form-control" placeholder="例：65歳以上">
            </div>
          </div>
          
          <!-- 名称4 -->
          <div class="form-row">
            <div class="form-group">
              <label for="commonName4" class="form-label">名称4</label>
              <input type="text" id="commonName4" name="common_name_4" class="form-control" placeholder="例：学生">
            </div>
            
            <div class="form-group">
              <label for="commonDesc4" class="form-label">補足説明</label>
              <input type="text" id="commonDesc4" name="common_desc_4" class="form-control" placeholder="例：学生証提示">
            </div>
          </div>
          
          <!-- 名称5 -->
          <div class="form-row">
            <div class="form-group">
              <label for="commonName5" class="form-label">名称5</label>
              <input type="text" id="commonName5" name="common_name_5" class="form-control" placeholder="例：幼児">
            </div>
            
            <div class="form-group">
              <label for="commonDesc5" class="form-label">補足説明</label>
              <input type="text" id="commonDesc5" name="common_desc_5" class="form-control" placeholder="例：3歳未満">
            </div>
          </div>
        </div>
      </div>
      
      <!-- 価格設定 -->
      <div class="form-section">
        <h3 class="form-section-title">
          <i class="fas fa-yen-sign"></i>
          価格設定
        </h3>
        <div class="form-section-content">
          <div id="priceBandsContainer">
            <!-- 価格帯は動的に追加 -->
          </div>
          <button type="button" id="addPriceBandBtn" class="btn btn-secondary" style="margin-top: 1rem;">
            <i class="fas fa-plus"></i>
            価格帯を追加
          </button>
        </div>
      </div>
      
      <!-- 取消条件設定 -->
      <div class="form-section">
        <h3 class="form-section-title">
          <i class="fas fa-ban"></i>
          取消条件設定
        </h3>
        <div class="form-section-content">
          <div id="cancellationBands">
            <!-- キャンセル条件バンドは動的に追加 -->
          </div>
          <button type="button" id="addCancellationBandBtn" class="btn btn-secondary" style="margin-top: 1rem;">
            <i class="fas fa-plus"></i>
            取消条件を追加
          </button>
        </div>
      </div>
      
      <div class="form-actions">
        <a href="/admin/products" class="btn btn-secondary">
          <i class="fas fa-times"></i>
          キャンセル
        </a>
        <button type="submit" class="btn btn-primary">
          <i class="fas fa-save"></i>
          ${isEditMode ? '更新' : '登録'}
        </button>
      </div>
    </form>
  `;
  
  // イベントリスナーを追加
  const addPriceBandBtn = document.getElementById('addPriceBandBtn');
  if (addPriceBandBtn) {
    addPriceBandBtn.addEventListener('click', addPriceBand);
  }
  
  const addCancellationBtn = document.getElementById('addCancellationBandBtn');
  if (addCancellationBtn) {
    addCancellationBtn.addEventListener('click', addCancellationBand);
  }
}

})(); // IIFE の終了
