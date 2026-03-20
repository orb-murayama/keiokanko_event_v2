// オプション編集・新規登録
let optionId = null;
let isEditMode = false;

// ページ初期化
document.addEventListener('DOMContentLoaded', async () => {
  console.log('オプション編集ページを初期化');
  
  try {
    // URLからoptionIdを取得
    const urlParams = new URLSearchParams(window.location.search);
    optionId = urlParams.get('id');
    isEditMode = optionId && optionId !== 'new';
    
    // modeを設定
    document.getElementById('mode').value = isEditMode ? 'edit' : 'new';
    
    // タイトルを更新
    const pageTitle = isEditMode ? 'オプション編集' : '新規オプション登録';
    document.title = pageTitle + ' | 管理画面';
    document.getElementById('formTitle').textContent = pageTitle;
    document.getElementById('submitBtnText').textContent = isEditMode ? '更新する' : '登録する';
    
    // イベント一覧を読み込み
    await loadEvents();
    
    // カテゴリー一覧を読み込み
    await loadCategories();
    
    // 編集モードの場合、オプション情報を読み込み
    if (isEditMode) {
      await loadOptionData();
    }
    
    // 画像プレビュー処理を設定
    setupImagePreview();
    
    // フォーム送信イベントを設定
    document.getElementById('optionForm').addEventListener('submit', handleSubmit);
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

// イベント一覧を読み込み
async function loadEvents() {
  try {
    const response = await window.API.get('/api/v1/events?per_page=1000');
    const events = response.data;
    
    const selectElement = document.getElementById('event_id');
    events.forEach(event => {
      const option = document.createElement('option');
      option.value = event.id;
      option.textContent = event.name;
      selectElement.appendChild(option);
    });
    
    console.log('イベント一覧を読み込みました:', events.length, '件');
  } catch (error) {
    console.error('イベント読み込みエラー:', error);
    window.Utils.showError('イベント一覧の読み込みに失敗しました');
  }
}

// カテゴリー一覧を読み込み
async function loadCategories() {
  try {
    const categories = await window.API.get('/api/option-categories');
    
    const selectElement = document.getElementById('option_category_id');
    categories.forEach(cat => {
      const option = document.createElement('option');
      option.value = cat.id;
      option.textContent = cat.name;
      selectElement.appendChild(option);
    });
    
    console.log('カテゴリー一覧を読み込みました:', categories.length, '件');
  } catch (error) {
    console.error('カテゴリー読み込みエラー:', error);
    window.Utils.showError('カテゴリー一覧の読み込みに失敗しました');
  }
}

// オプションデータを読み込み
async function loadOptionData() {
  try {
    window.Utils.showLoading(true);
    
    const response = await window.API.get(`/api/options/${optionId}`);
    const option = response.option;
    
    // フォームに値を設定
    document.getElementById('optionId').value = option.id;
    document.getElementById('name').value = option.name || '';
    document.getElementById('event_id').value = option.event_id || '';
    document.getElementById('option_category_id').value = option.option_category_id || '';
    document.getElementById('enable_flg').value = option.enable_flg !== undefined ? option.enable_flg : 1;
    document.getElementById('description').value = option.description || '';
    document.getElementById('remarks').value = option.remarks || '';
    document.getElementById('cancel_policy').value = option.cancel_policy || '';
    document.getElementById('note').value = option.note || '';
    document.getElementById('image_url').value = option.image_url || '';
    
    // 画像プレビューを表示
    if (option.image_url) {
      const imagePreview = document.getElementById('imagePreview');
      const noImageText = document.getElementById('noImageText');
      const clearImageBtn = document.getElementById('clearImageBtn');
      
      imagePreview.src = option.image_url;
      imagePreview.style.display = 'block';
      noImageText.style.display = 'none';
      clearImageBtn.style.display = 'inline-block';
    }
    
    console.log('オプション情報を読み込みました:', option);
  } catch (error) {
    console.error('オプション読み込みエラー:', error);
    window.Utils.showError('オプション情報の読み込みに失敗しました');
  } finally {
    window.Utils.showLoading(false);
  }
}

// 画像プレビュー処理を設定
function setupImagePreview() {
  const imageFile = document.getElementById('imageFile');
  const imagePreview = document.getElementById('imagePreview');
  const noImageText = document.getElementById('noImageText');
  const clearImageBtn = document.getElementById('clearImageBtn');
  
  // ファイル選択時
  imageFile.addEventListener('change', function(e) {
    const file = e.target.files[0];
    if (!file) return;
    
    // ファイルサイズチェック（5MB制限）
    if (file.size > 5 * 1024 * 1024) {
      window.Utils.showError('画像ファイルは5MB以下にしてください');
      e.target.value = '';
      return;
    }
    
    // 画像タイプチェック
    if (!file.type.match('image.*')) {
      window.Utils.showError('画像ファイルを選択してください');
      e.target.value = '';
      return;
    }
    
    // プレビュー表示
    const reader = new FileReader();
    reader.onload = function(e) {
      imagePreview.src = e.target.result;
      imagePreview.style.display = 'block';
      noImageText.style.display = 'none';
      clearImageBtn.style.display = 'inline-block';
    };
    reader.readAsDataURL(file);
  });
  
  // 画像クリアボタン
  clearImageBtn.addEventListener('click', function() {
    imageFile.value = '';
    imagePreview.src = '';
    imagePreview.style.display = 'none';
    noImageText.style.display = 'block';
    clearImageBtn.style.display = 'none';
    document.getElementById('image_url').value = '';
  });
}

// フォーム送信処理
async function handleSubmit(e) {
  e.preventDefault();
  
  try {
    window.Utils.showLoading(true);
    
    const formData = new FormData(e.target);
    const data = Object.fromEntries(formData.entries());
    
    // 画像ファイルがある場合は先にアップロード
    const imageFile = document.getElementById('imageFile');
    if (imageFile.files && imageFile.files[0]) {
      const file = imageFile.files[0];
      const imageFormData = new FormData();
      imageFormData.append('image', file);
      
      try {
        const uploadResponse = await fetch('/api/options/upload-image', {
          method: 'POST',
          body: imageFormData
        });
        
        if (uploadResponse.ok) {
          const uploadResult = await uploadResponse.json();
          if (uploadResult.image_url) {
            data.image_url = uploadResult.image_url;
          }
        }
      } catch (uploadError) {
        console.error('画像アップロードエラー:', uploadError);
        // 画像アップロード失敗は警告のみ
        window.Utils.showError('画像のアップロードに失敗しました（続行します）');
      }
    }
    
    // 既存の画像URLを保持
    if (!data.image_url && document.getElementById('image_url').value) {
      data.image_url = document.getElementById('image_url').value;
    }
    
    let response;
    if (isEditMode) {
      // 更新
      response = await window.API.put(`/api/options/${optionId}`, data);
      window.Utils.showSuccess('オプションを更新しました！');
    } else {
      // 新規作成
      response = await window.API.post('/api/options', data);
      window.Utils.showSuccess('オプションを登録しました！');
    }
    
    // 一覧ページに遷移
    setTimeout(() => {
      window.location.href = '/admin/options';
    }, 1500);
    
  } catch (error) {
    console.error('送信エラー:', error);
    const message = isEditMode ? '更新に失敗しました' : '登録に失敗しました';
    window.Utils.showError(`${message}: ${error.message || '不明なエラー'}`);
  } finally {
    window.Utils.showLoading(false);
  }
}
