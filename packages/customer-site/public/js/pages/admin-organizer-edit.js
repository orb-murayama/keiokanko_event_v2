// 主催者編集ページ

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

// 主催者データを読み込み
async function loadOrganizer(id) {
  try {
    const response = await fetch(`/api/organizers/${id}`);
    
    if (!response.ok) {
      throw new Error('主催者の読み込みに失敗しました');
    }

    const organizer = await response.json();
    
    // フォームにデータを設定
    document.getElementById('organizerId').value = organizer.id;
    document.getElementById('name').value = organizer.name || '';
    document.getElementById('contactable_person').value = organizer.contactable_person || '';
    document.getElementById('branch_office').value = organizer.branch_office || '';
    document.getElementById('email').value = organizer.email || '';
    document.getElementById('tel').value = organizer.tel || '';
    document.getElementById('fax').value = organizer.fax || '';
    document.getElementById('zip').value = organizer.zip || '';
    document.getElementById('pref_id').value = organizer.pref_id || '';
    document.getElementById('addr').value = organizer.addr || '';
    document.getElementById('business_hours').value = organizer.business_hours || '';
    document.getElementById('closed_days').value = organizer.closed_days || '';
    document.getElementById('business_notes').value = organizer.business_notes || '';
    document.getElementById('registration_number').value = organizer.registration_number || '';
    document.getElementById('association_name').value = organizer.association_name || '';
    document.getElementById('association_membership').value = organizer.association_membership || '';
    document.getElementById('travel_manager_title').value = organizer.travel_manager_title || '';
    document.getElementById('travel_manager_name').value = organizer.travel_manager_name || '';
    document.getElementById('remarks').value = organizer.remarks || '';
    document.getElementById('reg_flg').checked = organizer.reg_flg === 1;

    // パスワードは表示しない（セキュリティのため）
    
  } catch (error) {
    console.error('Error:', error);
    alert('主催者の読み込みに失敗しました');
  }
}

// フォーム送信
async function submitForm(e) {
  e.preventDefault();

  const mode = document.getElementById('mode').value;
  const organizerId = document.getElementById('organizerId').value;

  // フォームデータ取得
  const formData = {
    name: document.getElementById('name').value.trim(),
    contactable_person: document.getElementById('contactable_person').value.trim(),
    branch_office: document.getElementById('branch_office').value.trim(),
    email: document.getElementById('email').value.trim(),
    tel: document.getElementById('tel').value.trim(),
    fax: document.getElementById('fax').value.trim(),
    zip: document.getElementById('zip').value.trim(),
    pref_id: parseInt(document.getElementById('pref_id').value) || null,
    addr: document.getElementById('addr').value.trim(),
    business_hours: document.getElementById('business_hours').value.trim(),
    closed_days: document.getElementById('closed_days').value.trim(),
    business_notes: document.getElementById('business_notes').value.trim(),
    registration_number: document.getElementById('registration_number').value.trim(),
    association_name: document.getElementById('association_name').value.trim(),
    association_membership: document.getElementById('association_membership').value.trim(),
    travel_manager_title: document.getElementById('travel_manager_title').value.trim(),
    travel_manager_name: document.getElementById('travel_manager_name').value.trim(),
    remarks: document.getElementById('remarks').value.trim(),
    reg_flg: document.getElementById('reg_flg').checked ? 1 : 0
  };

  // バリデーション
  if (!formData.name) {
    alert('主催者名を入力してください');
    return;
  }

  try {
    let response;
    
    if (mode === 'new') {
      // 新規登録
      response = await fetch('/api/organizers', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData)
      });
    } else {
      // 更新
      response = await fetch(`/api/organizers/${organizerId}`, {
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
    window.location.href = '/admin/organizers';

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
  document.getElementById('organizerForm').addEventListener('submit', submitForm);

  // 都道府県読み込み
  await loadPrefs();

  // URLパラメータからIDを取得
  const urlParams = new URLSearchParams(window.location.search);
  const id = urlParams.get('id');

  if (id === 'new') {
    // 新規登録モード
    document.getElementById('mode').value = 'new';
    document.getElementById('pageTitle').textContent = '主催者登録 | 管理画面';
    
    // headerText要素が存在する場合のみ更新（common-header.jsが生成するまで待つ）
    const headerText = document.getElementById('headerText');
    if (headerText) {
      headerText.textContent = '主催者登録';
    }
  } else if (id) {
    // 編集モード
    document.getElementById('mode').value = 'edit';
    document.getElementById('organizerId').value = id;
    document.getElementById('pageTitle').textContent = '主催者編集 | 管理画面';
    
    // headerText要素が存在する場合のみ更新（common-header.jsが生成するまで待つ）
    const headerText = document.getElementById('headerText');
    if (headerText) {
      headerText.textContent = '主催者編集';
    }
    
    // データ読み込み
    await loadOrganizer(id);
  }
});
