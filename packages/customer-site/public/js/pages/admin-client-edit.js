// URLパラメータからIDを取得
const urlParams = new URLSearchParams(window.location.search);
const clientId = urlParams.get('id');
const isEditMode = clientId && clientId !== 'new';

function logout() {
  if (confirm('ログアウトしますか？')) {
    window.location.href = '/admin/logout';
  }
}

async function loadPrefs() {
  try {
    const response = await fetch('/api/prefs');
    if (!response.ok) {
      throw new Error('都道府県の取得に失敗しました');
    }
    const prefs = await response.json();
    const prefSelect = document.getElementById('pref_id');
    if (prefSelect) {
      prefs.forEach(pref => {
        const option = document.createElement('option');
        option.value = pref.id;
        option.textContent = pref.name;
        prefSelect.appendChild(option);
      });
    }
  } catch (error) {
    console.error('Error loading prefs:', error);
  }
}

async function loadClientData() {
  if (!isEditMode) {
    return;
  }

  try {
    const response = await fetch(`/api/clients/${clientId}`);
    
    if (!response.ok) {
      throw new Error('クライアント情報の取得に失敗しました');
    }

    const client = await response.json();
    
    // フォームに値を設定（DBフィールド名に合わせる）
    document.getElementById('clientId').value = client.id || '';
    document.getElementById('name').value = client.name || '';
    document.getElementById('client_code').value = client.client_code || '';
    document.getElementById('contact_person').value = client.contactable_person || '';
    document.getElementById('position').value = client.position || '';
    document.getElementById('branch_office').value = client.branch_office || '';
    document.getElementById('accounted_person').value = client.accounted_person || '';
    document.getElementById('email').value = client.email || '';
    document.getElementById('tel').value = client.tel || '';
    document.getElementById('fax').value = client.fax || '';
    document.getElementById('zip').value = client.zip || '';
    document.getElementById('pref_id').value = client.pref_id || '';
    document.getElementById('addr').value = client.addr || '';
    document.getElementById('remarks').value = client.remarks || '';
    document.getElementById('enable_flg').checked = client.reg_flg === 1;
    
    // タイトルを更新
    const pageTitle = document.getElementById('pageTitle');
    if (pageTitle) {
      pageTitle.textContent = 'クライアント編集 | 管理画面';
    }
    
    const headerText = document.getElementById('headerText');
    if (headerText) {
      headerText.textContent = 'クライアント編集';
    }
  } catch (error) {
    console.error('Error:', error);
    alert('クライアント情報の取得に失敗しました');
  }
}

async function saveClient(data) {
  try {
    const url = isEditMode ? `/api/clients/${clientId}` : '/api/clients';
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
      throw new Error(error.error || 'クライアントの保存に失敗しました');
    }

    alert(isEditMode ? 'クライアント情報を更新しました' : 'クライアントを登録しました');
    window.location.href = '/admin/clients';
  } catch (error) {
    console.error('Error:', error);
    alert(error.message);
  }
}

// フォーム送信処理
document.addEventListener('DOMContentLoaded', () => {
  loadPrefs();
  loadClientData();
  
  const clientForm = document.getElementById('clientForm');
  if (clientForm) {
    clientForm.addEventListener('submit', async (e) => {
      e.preventDefault();

      const data = {
        name: document.getElementById('name').value.trim(),
        client_code: document.getElementById('client_code').value.trim(),
        contactable_person: document.getElementById('contact_person').value.trim(),
        position: document.getElementById('position').value.trim() || null,
        branch_office: document.getElementById('branch_office').value.trim() || null,
        accounted_person: document.getElementById('accounted_person').value.trim() || null,
        email: document.getElementById('email').value.trim(),
        tel: document.getElementById('tel').value.trim(),
        fax: document.getElementById('fax').value.trim() || null,
        zip: document.getElementById('zip').value.trim(),
        pref_id: parseInt(document.getElementById('pref_id').value),
        addr: document.getElementById('addr').value.trim(),
        remarks: document.getElementById('remarks').value.trim() || null,
        reg_flg: document.getElementById('enable_flg').checked ? 1 : 0
      };

      await saveClient(data);
    });
  }
  
  // ログアウトボタンのイベントリスナー
  const logoutBtn = document.getElementById('logoutBtn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', logout);
  }
});
