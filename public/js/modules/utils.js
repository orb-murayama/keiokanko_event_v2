/**
 * Utilities Module
 * 共通ユーティリティ関数
 */

/**
 * 日付フォーマット
 * @param {string|Date} date - 日付
 * @param {string} format - フォーマット ('YYYY-MM-DD', 'YYYY/MM/DD', 'MM/DD')
 * @returns {string} フォーマット済み日付
 */
function formatDate(date, format = 'YYYY-MM-DD') {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');

  switch (format) {
    case 'YYYY-MM-DD':
      return `${year}-${month}-${day}`;
    case 'YYYY/MM/DD':
      return `${year}/${month}/${day}`;
    case 'MM/DD':
      return `${month}/${day}`;
    case 'YYYY年MM月DD日':
      return `${year}年${month}月${day}日`;
    default:
      return `${year}-${month}-${day}`;
  }
}

/**
 * 日本語の曜日を取得
 * @param {string|Date} date - 日付
 * @returns {string} 曜日
 */
function getJapaneseWeekday(date) {
  const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
  const d = new Date(date);
  return weekdays[d.getDay()];
}

/**
 * 金額フォーマット
 * @param {number} amount - 金額
 * @param {boolean} includeYen - 円記号を含めるか
 * @returns {string} フォーマット済み金額
 */
function formatCurrency(amount, includeYen = true) {
  const formatted = Number(amount).toLocaleString('ja-JP');
  return includeYen ? `${formatted}円` : formatted;
}

/**
 * URLパラメータを取得
 * @param {string} name - パラメータ名
 * @returns {string|null} パラメータ値
 */
function getUrlParameter(name) {
  const params = new URLSearchParams(window.location.search);
  return params.get(name);
}

/**
 * オブジェクトをURLパラメータに変換
 * @param {object} params - パラメータオブジェクト
 * @returns {string} URLパラメータ文字列
 */
function objectToQueryString(params) {
  return new URLSearchParams(params).toString();
}

/**
 * エラーメッセージを表示
 * @param {string} message - エラーメッセージ
 * @param {HTMLElement} container - 表示先コンテナ（省略時はid="errorMessage"またはalert）
 */
function showError(message, container = null) {
  console.error('Error:', message);
  
  // まず id="errorMessage" を探す（新しいHTML5ページ用）
  const errorElement = document.getElementById('errorMessage');
  
  if (errorElement) {
    // HTML5ページの場合
    errorElement.textContent = message;
    errorElement.classList.remove('hidden');
    
    setTimeout(() => {
      errorElement.classList.add('hidden');
      errorElement.textContent = '';
    }, 5000);
  } else if (container) {
    // 旧ページの場合: containerに追加
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message alert alert-danger';
    errorDiv.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
    container.appendChild(errorDiv);
    
    setTimeout(() => errorDiv.remove(), 5000);
  } else {
    // フォールバック: alert
    alert('エラー: ' + message);
  }
}

/**
 * 成功メッセージを表示
 * @param {string} message - 成功メッセージ
 * @param {HTMLElement} container - 表示先コンテナ（オプショナル）
 */
function showSuccess(message, container = null) {
  console.log('Success:', message);
  
  // まず id="successMessage" を探す
  const successElement = document.getElementById('successMessage');
  
  if (successElement) {
    successElement.textContent = message;
    successElement.classList.remove('hidden');
    
    setTimeout(() => {
      successElement.classList.add('hidden');
      successElement.textContent = '';
    }, 3000);
  } else if (container) {
    const successDiv = document.createElement('div');
    successDiv.className = 'success-message alert alert-success';
    successDiv.innerHTML = `<i class="fas fa-check-circle"></i> ${message}`;
    container.appendChild(successDiv);
    
    setTimeout(() => successDiv.remove(), 3000);
  } else {
    alert(message);
  }
}

/**
 * ローディング表示
 * @param {boolean} show - 表示/非表示
 * @param {HTMLElement} container - 表示先コンテナ（オプショナル）
 */
function showLoading(show, container = null) {
  console.log('showLoading called:', show);
  
  // まず id="loadingOverlay" を探す（admin-form-fieldsページ用）
  let loadingElement = document.getElementById('loadingOverlay');
  
  // 次に id="loading" を探す（他のHTML5ページ用）
  if (!loadingElement) {
    loadingElement = document.getElementById('loading');
  }
  
  console.log('loadingElement:', loadingElement);
  
  if (loadingElement) {
    // HTML5ページの場合: loadingOverlayまたはloadingを表示/非表示
    if (show) {
      loadingElement.style.display = 'flex';
      console.log('Loading shown');
    } else {
      loadingElement.style.display = 'none';
      console.log('Loading hidden');
    }
  } else if (container) {
    // 旧ページの場合: 動的にloaderを作成
    const existingLoader = container.querySelector('.loader');
    
    if (show) {
      if (!existingLoader) {
        const loader = document.createElement('div');
        loader.className = 'loader';
        loader.innerHTML = '<div class="spinner"></div>';
        container.appendChild(loader);
      }
    } else {
      if (existingLoader) {
        existingLoader.remove();
      }
    }
  }
}

/**
 * デバウンス関数
 * @param {Function} func - 実行する関数
 * @param {number} wait - 待機時間（ミリ秒）
 * @returns {Function} デバウンスされた関数
 */
function debounce(func, wait = 300) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

/**
 * スロットル関数
 * @param {Function} func - 実行する関数
 * @param {number} limit - 制限時間（ミリ秒）
 * @returns {Function} スロットルされた関数
 */
function throttle(func, limit = 300) {
  let inThrottle;
  return function executedFunction(...args) {
    if (!inThrottle) {
      func(...args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

/**
 * HTMLエスケープ
 * @param {string} str - エスケープする文字列
 * @returns {string} エスケープされた文字列
 */
function escapeHtml(str) {
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}

/**
 * バリデーション: メールアドレス
 * @param {string} email - メールアドレス
 * @returns {boolean} 有効性
 */
function validateEmail(email) {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
}

/**
 * バリデーション: 電話番号（日本）
 * @param {string} tel - 電話番号
 * @returns {boolean} 有効性
 */
function validateTel(tel) {
  const re = /^0\d{9,10}$/;
  return re.test(tel.replace(/-/g, ''));
}

/**
 * バリデーション: 郵便番号（日本）
 * @param {string} zip - 郵便番号
 * @returns {boolean} 有効性
 */
function validateZip(zip) {
  const re = /^\d{3}-?\d{4}$/;
  return re.test(zip);
}

/**
 * ストレージ操作: 保存
 * @param {string} key - キー
 * @param {any} value - 値
 */
function saveToStorage(key, value) {
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch (error) {
    console.error('Storage Save Error:', error);
  }
}

/**
 * ストレージ操作: 取得
 * @param {string} key - キー
 * @returns {any} 値
 */
function getFromStorage(key) {
  try {
    const item = localStorage.getItem(key);
    return item ? JSON.parse(item) : null;
  } catch (error) {
    console.error('Storage Get Error:', error);
    return null;
  }
}

/**
 * ストレージ操作: 削除
 * @param {string} key - キー
 */
function removeFromStorage(key) {
  try {
    localStorage.removeItem(key);
  } catch (error) {
    console.error('Storage Remove Error:', error);
  }
}

// グローバル変数として公開（全ページで使用可能）
if (typeof window !== 'undefined') {
  window.Utils = {
    formatDate,
    getJapaneseWeekday,
    formatCurrency,
    getUrlParameter,
    objectToQueryString,
    showError,
    showSuccess,
    showLoading,
    debounce,
    throttle,
    escapeHtml,
    validateEmail,
    validateTel,
    validateZip,
    saveToStorage,
    getFromStorage,
    removeFromStorage
  };
}
