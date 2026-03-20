/**
 * アカウント編集ページ
 */

// URLパラメータからアカウントIDを取得
const urlParams = new URLSearchParams(window.location.search);
const accountId = urlParams.get('id') || 'new';
const isEditMode = accountId !== 'new';

let branches = [];
let clients = [];

/**
 * ページ読み込み時の初期化
 */
document.addEventListener('DOMContentLoaded', async () => {
  // ログアウトボタン
  const logoutBtn = document.getElementById('logoutBtn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', logout);
  }

  // フォーム送信
  const accountForm = document.getElementById('accountForm');
  if (accountForm) {
    accountForm.addEventListener('submit', handleSubmit);
  }

  // 表示制御イベント
  document.getElementById('account_type').addEventListener('change', updateFormVisibility);
  document.getElementById('role').addEventListener('change', updateFormVisibility);

  // hidden フィールドに値を設定
  document.getElementById('accountId').value = accountId;
  document.getElementById('mode').value = isEditMode ? 'edit' : 'create';

  // 初期化処理
  await initialize();
});

/**
 * 初期化処理
 */
async function initialize() {
  try {
    updatePageTitle();
    updatePasswordLabel();
    await loadBranches();
    await loadClients();
    await loadAccountData();
  } catch (error) {
    console.error('初期化エラー:', error);
    alert('初期化に失敗しました');
  }
}

/**
 * ページタイトル更新
 */
function updatePageTitle() {
  const title = isEditMode ? 'アカウント編集' : '新規アカウント登録';
  document.getElementById('pageTitle').textContent = title + ' | 管理画面';
  document.getElementById('headerText').textContent = title;
  document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> ' + 
    (isEditMode ? '更新する' : '登録する');
}

/**
 * パスワードラベル更新
 */
function updatePasswordLabel() {
  const label = document.getElementById('passwordLabel');
  const hint = document.getElementById('passwordHint');
  const passwordInput = document.getElementById('password');
  
  if (isEditMode) {
    label.innerHTML = '';
    passwordInput.removeAttribute('required');
    hint.textContent = '変更する場合のみ入力してください';
  } else {
    label.innerHTML = '<span class="text-danger">*</span>';
    passwordInput.setAttribute('required', 'required');
    hint.textContent = '';
  }
}

/**
 * フォーム表示制御
 */
function updateFormVisibility() {
  const accountType = document.getElementById('account_type').value;
  const role = document.getElementById('role').value;

  // 主所属支店と追加アクセス権限の表示制御
  const showBranchFields = accountType === 'keio' && role === 'branch';
  document.getElementById('primary_branch_section').style.display = showBranchFields ? 'block' : 'none';
  document.getElementById('accessible_branches_section').style.display = showBranchFields ? 'block' : 'none';
  
  // 必須マーク
  const primaryBranchRequired = document.getElementById('primaryBranchRequired');
  const primaryBranchSelect = document.getElementById('primary_branch_code');
  if (showBranchFields) {
    primaryBranchRequired.innerHTML = '<span class="text-danger">*</span>';
    primaryBranchSelect.setAttribute('required', 'required');
  } else {
    primaryBranchRequired.innerHTML = '';
    primaryBranchSelect.removeAttribute('required');
    primaryBranchSelect.value = '';
  }

  // 所属クライアントの表示制御
  const showClientField = accountType === 'client';
  document.getElementById('client_section').style.display = showClientField ? 'block' : 'none';
  
  // 必須マーク
  const clientRequired = document.getElementById('clientRequired');
  const clientSelect = document.getElementById('client_id');
  if (showClientField) {
    clientRequired.innerHTML = '<span class="text-danger">*</span>';
    clientSelect.setAttribute('required', 'required');
  } else {
    clientRequired.innerHTML = '';
    clientSelect.removeAttribute('required');
    clientSelect.value = '';
  }
}

/**
 * 支店リスト取得
 */
async function loadBranches() {
  try {
    const response = await fetch('/api/branches?per_page=1000');
    const data = await response.json();
    // APIは配列を直接返す、またはオブジェクトの場合はbranchesまたはdataプロパティを持つ
    branches = Array.isArray(data) ? data : (data.branches || data.data || []);
    console.log('支店データ読み込み:', branches.length + '件');
    
    // 主所属支店のselectを更新
    const primaryBranchSelect = document.getElementById('primary_branch_code');
    primaryBranchSelect.innerHTML = '<option value="">選択してください</option>';
    branches.forEach(branch => {
      const option = document.createElement('option');
      option.value = branch.branch_code;
      option.textContent = branch.branch_name;
      primaryBranchSelect.appendChild(option);
    });

    // チェックボックスを生成
    const checkboxContainer = document.getElementById('accessible_branches_checkboxes');
    checkboxContainer.innerHTML = '';
    branches.forEach(branch => {
      const label = document.createElement('label');
      label.className = 'form-checkbox';
      label.innerHTML = `
        <input type="checkbox" name="accessible_branches" value="${branch.branch_code}">
        <span>${branch.branch_name}</span>
      `;
      checkboxContainer.appendChild(label);
    });
  } catch (error) {
    console.error('支店データの取得に失敗:', error);
  }
}

/**
 * クライアントリスト取得
 */
async function loadClients() {
  try {
    const response = await fetch('/api/clients');
    const data = await response.json();
    clients = Array.isArray(data) ? data : (data.clients || data.data || []);
    
    const clientSelect = document.getElementById('client_id');
    clientSelect.innerHTML = '<option value="">選択してください</option>';
    clients.forEach(client => {
      const option = document.createElement('option');
      option.value = client.id;
      option.textContent = client.name;
      clientSelect.appendChild(option);
    });
  } catch (error) {
    console.error('クライアントデータの取得に失敗:', error);
  }
}

/**
 * アカウントデータ読み込み
 */
async function loadAccountData() {
  if (!isEditMode) return;

  try {
    const response = await fetch(`/api/accounts/${accountId}`);
    const account = await response.json();
    
    // フォームに値を設定
    document.getElementById('login_id').value = account.login_id || '';
    document.getElementById('person_name').value = account.person_name || '';
    document.getElementById('email').value = account.email || '';
    document.getElementById('tel').value = account.tel || '';
    document.getElementById('mobile').value = account.mobile || '';
    document.getElementById('account_type').value = account.account_type || 'keio';
    document.getElementById('role').value = account.role || '';
    document.getElementById('primary_branch_code').value = account.primary_branch_code || '';
    document.getElementById('client_id').value = account.client_id || '';
    document.getElementById('enable_flg').checked = account.enable_flg !== 0;
    document.getElementById('expiration_date').value = account.expiration_date || '';

    // 表示制御を更新
    updateFormVisibility();

    // 追加アクセス権限のチェックボックスを設定
    if (account.accessible_branches) {
      try {
        const accessibleBranches = JSON.parse(account.accessible_branches);
        accessibleBranches.forEach(branchCode => {
          const checkbox = document.querySelector(`input[name="accessible_branches"][value="${branchCode}"]`);
          if (checkbox) checkbox.checked = true;
        });
      } catch (error) {
        console.error('accessible_branchesのパースエラー:', error);
      }
    }
  } catch (error) {
    console.error('アカウントデータの読み込みエラー:', error);
    alert('データの読み込みに失敗しました');
  }
}

/**
 * フォーム送信
 */
async function handleSubmit(e) {
  e.preventDefault();

  try {
    // 追加アクセス権限を収集
    const accessibleBranches = Array.from(
      document.querySelectorAll('input[name="accessible_branches"]:checked')
    ).map(cb => cb.value);

    // フォームデータを収集
    const formData = {
      login_id: document.getElementById('login_id').value,
      person_name: document.getElementById('person_name').value,
      email: document.getElementById('email').value,
      tel: document.getElementById('tel').value || null,
      mobile: document.getElementById('mobile').value || null,
      account_type: document.getElementById('account_type').value,
      role: document.getElementById('role').value,
      primary_branch_code: document.getElementById('primary_branch_code').value || null,
      accessible_branches: accessibleBranches.length > 0 ? JSON.stringify(accessibleBranches) : null,
      client_id: document.getElementById('client_id').value || null,
      enable_flg: document.getElementById('enable_flg').checked ? 1 : 0,
      expiration_date: document.getElementById('expiration_date').value || null
    };

    // パスワードが入力されている場合のみ含める
    const password = document.getElementById('password').value;
    if (password) {
      formData.password = password;
    }

    // API送信
    if (isEditMode) {
      const response = await fetch(`/api/accounts/${accountId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (!response.ok) throw new Error('更新に失敗しました');
      alert('アカウント情報を更新しました');
    } else {
      const response = await fetch('/api/accounts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      if (!response.ok) throw new Error('登録に失敗しました');
      alert('アカウントを登録しました');
    }

    window.location.href = '/admin/accounts';
  } catch (error) {
    console.error('送信エラー:', error);
    alert(error.message || '送信に失敗しました');
  }
}

/**
 * ログアウト処理
 */
function logout() {
  if (confirm('ログアウトしますか？')) {
    document.cookie = 'login=; path=/; max-age=0';
    window.location.href = '/admin/login';
  }
}
