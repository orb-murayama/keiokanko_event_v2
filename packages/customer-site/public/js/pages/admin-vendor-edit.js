// 仕入先編集ページ

// ログアウト
function logout() {
  if (confirm('ログアウトしますか？')) {
    window.location.href = '/admin/logout';
  }
}

// 都道府県一覧を読み込み
async function loadPrefs() {
  try {
    const response = await fetch('/api/prefs');
    if (!response.ok) {
      throw new Error('都道府県の読み込みに失敗しました');
    }

    const prefs = await response.json();
    const prefSelect = document.getElementById('pref_id');
    
    prefs.forEach(pref => {
      const option = document.createElement('option');
      option.value = pref.id;
      option.textContent = pref.name;
      prefSelect.appendChild(option);
    });

  } catch (error) {
    console.error('Error:', error);
  }
}

// 仕入先データを読み込み
async function loadVendor(id) {
  try {
    const response = await fetch(`/api/vendors/${id}`);
    
    if (!response.ok) {
      throw new Error('仕入先の読み込みに失敗しました');
    }

    const vendor = await response.json();
    
    // フォームにデータを設定
    document.getElementById('vendorId').value = vendor.id;
    document.getElementById('name').value = vendor.name || '';
    document.getElementById('contactable_person').value = vendor.contactable_person || '';
    document.getElementById('email').value = vendor.email || '';
    document.getElementById('tel').value = vendor.tel || '';
    document.getElementById('fax').value = vendor.fax || '';
    document.getElementById('zip').value = vendor.zip || '';
    document.getElementById('pref_id').value = vendor.pref_id || '';
    document.getElementById('addr').value = vendor.addr || '';
    document.getElementById('business_hours').value = vendor.business_hours || '';
    document.getElementById('closed_days').value = vendor.closed_days || '';
    document.getElementById('business_notes').value = vendor.business_notes || '';
    document.getElementById('remarks').value = vendor.remarks || '';
    document.getElementById('reg_flg').checked = vendor.reg_flg === 1;

    // パスワードは表示しない（セキュリティのため）
    
  } catch (error) {
    console.error('Error:', error);
    alert('仕入先の読み込みに失敗しました');
  }
}

// フォーム送信
async function submitForm(e) {
  e.preventDefault();

  const mode = document.getElementById('mode').value;
  const vendorId = document.getElementById('vendorId').value;

  // フォームデータ取得
  const formData = {
    name: document.getElementById('name').value.trim(),
    contactable_person: document.getElementById('contactable_person').value.trim(),
    email: document.getElementById('email').value.trim(),
    tel: document.getElementById('tel').value.trim(),
    fax: document.getElementById('fax').value.trim(),
    zip: document.getElementById('zip').value.trim(),
    pref_id: parseInt(document.getElementById('pref_id').value) || null,
    addr: document.getElementById('addr').value.trim(),
    business_hours: document.getElementById('business_hours').value.trim(),
    closed_days: document.getElementById('closed_days').value.trim(),
    business_notes: document.getElementById('business_notes').value.trim(),
    remarks: document.getElementById('remarks').value.trim(),
    reg_flg: document.getElementById('reg_flg').checked ? 1 : 0
  };

  // バリデーション
  if (!formData.name) {
    alert('販売会社名を入力してください');
    return;
  }

  try {
    let response;
    
    if (mode === 'new') {
      // 新規登録
      response = await fetch('/api/vendors', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData)
      });
    } else {
      // 更新
      response = await fetch(`/api/vendors/${vendorId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData)
      });
    }

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '保存に失敗しました');
    }

    alert('保存しました');
    window.location.href = '/admin/vendors';

  } catch (error) {
    console.error('Error:', error);
    alert(error.message || '保存に失敗しました');
  }
}

// 初期化
document.addEventListener('DOMContentLoaded', async () => {
  // ログアウトボタン
  document.getElementById('logoutBtn').addEventListener('click', logout);

  // フォーム送信
  document.getElementById('vendorForm').addEventListener('submit', submitForm);

  // 都道府県読み込み
  await loadPrefs();

  // URLパラメータからIDを取得
  const urlParams = new URLSearchParams(window.location.search);
  const id = urlParams.get('id');

  if (id === 'new') {
    // 新規登録モード
    document.getElementById('mode').value = 'new';
    document.getElementById('pageTitle').textContent = '販売会社登録 | 管理画面';
    document.getElementById('headerText').textContent = '販売会社登録';
  } else if (id) {
    // 編集モード
    document.getElementById('mode').value = 'edit';
    document.getElementById('vendorId').value = id;
    document.getElementById('pageTitle').textContent = '販売会社編集 | 管理画面';
    document.getElementById('headerText').textContent = '販売会社編集';
    
    // データ読み込み
    await loadVendor(id);
  }
});
