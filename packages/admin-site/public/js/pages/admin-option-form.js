/**
 * Admin Option Form Script
 * オプション登録・編集ページ（HTML5版）
 */

// グローバル変数
let isEditMode = false;
let optionId = null;
let events = [];
let categories = [];

// ページ読み込み時に実行
document.addEventListener('DOMContentLoaded', async () => {
  try {
    console.log('オプションフォームを初期化');
    
    // 編集モードかどうか判定
    isEditMode = window.optionId !== undefined;
    optionId = window.optionId;
    
    // イベントとカテゴリを取得
    await loadEvents();
    await loadCategories();
    
    // フォームをレンダリング
    renderForm();
    
    // 編集モードの場合はデータを読み込む
    if (isEditMode) {
      await loadOptionData();
    }
    
    // フォーム送信イベント
    document.getElementById('optionForm').addEventListener('submit', handleSubmit);
    
    // 画像ファイル選択時のプレビュー
    document.getElementById('image').addEventListener('change', handleImagePreview);
    
  } catch (error) {
    console.error('初期化エラー:', error);
    showError('ページの初期化に失敗しました: ' + error.message);
  }
});

// 画像プレビュー処理
function handleImagePreview(e) {
  const file = e.target.files[0];
  if (!file) {
    document.getElementById('imagePreview').classList.add('hidden');
    return;
  }
  
  // ファイルサイズチェック（5MB）
  if (file.size > 5 * 1024 * 1024) {
    alert('画像サイズは5MB以下にしてください');
    e.target.value = '';
    return;
  }
  
  // プレビュー表示
  const reader = new FileReader();
  reader.onload = function(e) {
    document.getElementById('previewImage').src = e.target.result;
    document.getElementById('imagePreview').classList.remove('hidden');
  };
  reader.readAsDataURL(file);
}

// 画像アップロード処理
async function uploadImage(file) {
  try {
    const formData = new FormData();
    formData.append('image', file);
    
    const response = await fetch('/api/options/upload-image', {
      method: 'POST',
      body: formData
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '画像アップロードに失敗しました');
    }
    
    const result = await response.json();
    return result.image_url;
  } catch (error) {
    console.error('画像アップロードエラー:', error);
    throw error;
  }
}

// イベント一覧を取得
async function loadEvents() {
  try {
    const response = await fetch('/api/v1/events');
    if (!response.ok) throw new Error('イベント情報の取得に失敗しました');
    const data = await response.json();
    events = data.data || [];
    console.log('イベント取得:', events.length, '件');
  } catch (error) {
    console.error('イベント取得エラー:', error);
    throw error;
  }
}

// カテゴリ一覧を取得
async function loadCategories() {
  try {
    const response = await fetch('/api/option-categories');
    if (!response.ok) throw new Error('カテゴリ情報の取得に失敗しました');
    const data = await response.json();
    // APIは配列を直接返す
    categories = Array.isArray(data) ? data : (data.categories || []);
    console.log('カテゴリ取得:', categories.length, '件');
  } catch (error) {
    console.error('カテゴリ取得エラー:', error);
    throw error;
  }
}

// フォームをレンダリング
function renderForm() {
  const container = document.getElementById('formContainer');
  
  const eventOptions = events.map(event => 
    `<option value="${event.id}">${event.name}</option>`
  ).join('');
  
  const categoryOptions = categories.map(cat => 
    `<option value="${cat.id}">${cat.name}</option>`
  ).join('');
  
  container.innerHTML = `
    <form id="optionForm" class="space-y-6">
      <!-- 基本情報 -->
      <div>
        <h2 class="text-xl font-bold text-gray-800 mb-4 pb-2 border-b-2 border-purple-200 flex items-center gap-2">
          <i class="fas fa-info-circle text-purple-600"></i>
          基本情報
        </h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">
              オプション名 <span class="text-red-500">*</span>
            </label>
            <input type="text" id="name" name="name" required
                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                   placeholder="例：お弁当セット">
          </div>
          
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">
              イベント <span class="text-red-500">*</span>
            </label>
            <select id="event_id" name="event_id" required
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent">
              <option value="">選択してください</option>
              ${eventOptions}
            </select>
          </div>
          
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">
              カテゴリ <span class="text-red-500">*</span>
            </label>
            <select id="option_category_id" name="option_category_id" required
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent">
              <option value="">選択してください</option>
              ${categoryOptions}
            </select>
          </div>
          
          <div>
            <label class="block text-sm font-semibold text-gray-700 mb-1">
              状態
            </label>
            <select id="enable_flg" name="enable_flg"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent">
              <option value="1">販売中</option>
              <option value="0">停止中</option>
            </select>
          </div>
        </div>
        
        <div class="mt-4">
          <label class="block text-sm font-semibold text-gray-700 mb-1">
            説明
          </label>
          <textarea id="description" name="description" rows="3"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                    placeholder="オプションの説明を入力してください"></textarea>
        </div>
        
        <div class="mt-4">
          <label class="block text-sm font-semibold text-gray-700 mb-1">
            備考
          </label>
          <textarea id="remarks" name="remarks" rows="2"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                    placeholder="内部メモなど"></textarea>
        </div>
        
        <div class="mt-4">
          <label class="block text-sm font-semibold text-gray-700 mb-1">
            画像
          </label>
          <div class="space-y-3">
            <!-- 画像プレビュー -->
            <div id="imagePreview" class="hidden">
              <img id="previewImage" src="" alt="プレビュー" class="w-48 h-48 object-cover rounded-lg border-2 border-gray-300">
            </div>
            
            <!-- 画像アップロード -->
            <div>
              <input type="file" id="image" name="image" accept="image/*"
                     class="block w-full text-sm text-gray-500
                            file:mr-4 file:py-2 file:px-4
                            file:rounded-lg file:border-0
                            file:text-sm file:font-semibold
                            file:bg-purple-50 file:text-purple-700
                            hover:file:bg-purple-100">
              <p class="text-sm text-gray-500 mt-1">
                <i class="fas fa-info-circle"></i>
                対応形式：JPG、PNG、GIF、WebP（最大5MB）
              </p>
            </div>
            
            <!-- または画像URL -->
            <div>
              <label class="block text-xs font-semibold text-gray-600 mb-1">
                または画像URL
              </label>
              <input type="url" id="image_url" name="image_url"
                     class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                     placeholder="https://example.com/image.jpg">
            </div>
          </div>
        </div>
      </div>
      
      <!-- アクションボタン -->
      <div class="flex gap-3 pt-4 border-t border-gray-200">
        <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-lg font-semibold transition flex items-center gap-2">
          <i class="fas fa-save"></i>
          ${isEditMode ? '更新' : '登録'}
        </button>
        <a href="/admin/options" class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded-lg font-semibold transition flex items-center gap-2">
          <i class="fas fa-times"></i>
          キャンセル
        </a>
      </div>
    </form>
  `;
}

// オプションデータを読み込む（編集モード）
async function loadOptionData() {
  try {
    console.log('オプションデータ読み込み:', optionId);
    
    const response = await fetch(`/api/options/${optionId}`);
    if (!response.ok) throw new Error('オプション情報の取得に失敗しました');
    
    const data = await response.json();
    const option = data.option;
    
    console.log('オプションデータ:', option);
    
    // フォームに値を設定
    document.getElementById('name').value = option.name || '';
    document.getElementById('event_id').value = option.event_id || '';
    document.getElementById('option_category_id').value = option.option_category_id || '';
    document.getElementById('enable_flg').value = option.enable_flg !== undefined ? option.enable_flg : 1;
    document.getElementById('description').value = option.description || '';
    document.getElementById('remarks').value = option.remarks || '';
    document.getElementById('image_url').value = option.image_url || '';
    
    // 既存画像のプレビュー表示
    if (option.image_url) {
      document.getElementById('previewImage').src = option.image_url;
      document.getElementById('imagePreview').classList.remove('hidden');
    }
    
  } catch (error) {
    console.error('オプションデータ読み込みエラー:', error);
    showError('オプション情報の読み込みに失敗しました: ' + error.message);
  }
}

// フォーム送信処理
async function handleSubmit(e) {
  e.preventDefault();
  
  try {
    // 画像アップロード処理
    let imageUrl = document.getElementById('image_url').value.trim() || null;
    const imageFile = document.getElementById('image').files[0];
    
    if (imageFile) {
      console.log('画像アップロード開始:', imageFile.name);
      imageUrl = await uploadImage(imageFile);
      console.log('画像アップロード完了:', imageUrl);
    }
    
    // フォームデータを収集
    const formData = {
      name: document.getElementById('name').value.trim(),
      event_id: parseInt(document.getElementById('event_id').value),
      option_category_id: parseInt(document.getElementById('option_category_id').value),
      enable_flg: parseInt(document.getElementById('enable_flg').value),
      description: document.getElementById('description').value.trim(),
      remarks: document.getElementById('remarks').value.trim(),
      image_url: imageUrl
    };
    
    console.log('送信データ:', formData);
    
    // API呼び出し
    let response;
    if (isEditMode) {
      response = await fetch(`/api/options/${optionId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
    } else {
      response = await fetch('/api/options', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
    }
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '登録に失敗しました');
    }
    
    const result = await response.json();
    console.log('登録成功:', result);
    
    alert(isEditMode ? 'オプションを更新しました！' : 'オプションを登録しました！');
    window.location.href = '/admin/options';
    
  } catch (error) {
    console.error('送信エラー:', error);
    showError(error.message);
  }
}

// エラー表示
function showError(message) {
  const container = document.getElementById('formContainer');
  const errorDiv = document.createElement('div');
  errorDiv.className = 'bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4';
  errorDiv.innerHTML = `
    <div class="flex items-center gap-2">
      <i class="fas fa-exclamation-triangle"></i>
      <span>${message}</span>
    </div>
  `;
  container.insertBefore(errorDiv, container.firstChild);
  
  // 3秒後に自動で消す
  setTimeout(() => errorDiv.remove(), 5000);
}
