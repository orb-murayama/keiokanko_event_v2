// URLパラメータからmemberIdを取得
const urlParams = new URLSearchParams(window.location.search);
const memberId = urlParams.get('id');
const isEditMode = memberId && memberId !== 'new';

function logout() {
    if (confirm('ログアウトしますか？')) {
        window.location.href = '/admin/logout';
    }
}

async function loadPrefs() {
    try {
        const response = await fetch('/api/prefs');
        if (!response.ok) throw new Error('都道府県の取得に失敗しました');
        
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

async function loadMemberData() {
    if (!isEditMode) return;

    try {
        const response = await fetch(`/api/members/${memberId}`);
        if (!response.ok) throw new Error('会員情報の取得に失敗しました');
        
        const member = await response.json();
        
        document.getElementById('family_name').value = member.family_name || '';
        document.getElementById('first_name').value = member.first_name || '';
        document.getElementById('family_kana').value = member.family_kana || '';
        document.getElementById('first_kana').value = member.first_kana || '';
        document.getElementById('last_name_en').value = member.last_name_en || '';
        document.getElementById('first_name_en').value = member.first_name_en || '';
        document.getElementById('email').value = member.email || '';
        document.getElementById('tel').value = member.tel || '';
        document.getElementById('mobile').value = member.mobile || '';
        document.getElementById('sex').value = member.sex || '';
        document.getElementById('birth').value = member.birth || '';
        document.getElementById('zip').value = member.zip || '';
        document.getElementById('pref_id').value = member.pref_id || '';
        document.getElementById('addr').value = member.addr || '';
        document.getElementById('enable_flg').checked = member.enable_flg === 1;

        // タイトルとラベルを更新
        const pageTitle = document.getElementById('pageTitle');
        if (pageTitle) {
            pageTitle.innerHTML = '<i class="fas fa-user-edit"></i> 会員編集';
        }
        
        const passwordLabel = document.getElementById('passwordLabel');
        if (passwordLabel) {
            passwordLabel.innerHTML = 'パスワード <small>(変更する場合のみ入力)</small>';
        }
        
        const passwordInput = document.getElementById('password');
        if (passwordInput) {
            passwordInput.removeAttribute('required');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('会員情報の読み込みに失敗しました');
    }
}

async function searchAddress() {
    const zip = document.getElementById('zip').value.replace(/[^0-9]/g, '');
    
    if (zip.length !== 7) {
        alert('7桁の郵便番号を入力してください');
        return;
    }

    try {
        const response = await fetch(`https://zipcloud.ibsnet.co.jp/api/search?zipcode=${zip}`);
        if (!response.ok) throw new Error('郵便番号検索に失敗しました');
        
        const data = await response.json();
        
        if (data.results) {
            const result = data.results[0];
            const prefName = result.address1;
            const city = result.address2;
            const town = result.address3;
            
            const prefSelect = document.getElementById('pref_id');
            for (let i = 0; i < prefSelect.options.length; i++) {
                if (prefSelect.options[i].text === prefName) {
                    prefSelect.value = prefSelect.options[i].value;
                    break;
                }
            }
            
            document.getElementById('addr').value = city + town;
            alert('住所を入力しました');
        } else {
            alert('郵便番号に該当する住所が見つかりませんでした');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('住所検索に失敗しました');
    }
}

document.getElementById('memberForm').addEventListener('submit', async (e) => {
    e.preventDefault();

    const password = document.getElementById('password').value;

    if (!isEditMode && !password) {
        alert('新規作成時はパスワードを入力してください');
        return;
    }

    const data = {
        family_name: document.getElementById('family_name').value,
        first_name: document.getElementById('first_name').value,
        family_kana: document.getElementById('family_kana').value || null,
        first_kana: document.getElementById('first_kana').value || null,
        last_name_en: document.getElementById('last_name_en').value || null,
        first_name_en: document.getElementById('first_name_en').value || null,
        email: document.getElementById('email').value,
        tel: document.getElementById('tel').value || null,
        mobile: document.getElementById('mobile').value || null,
        sex: document.getElementById('sex').value || null,
        birth: document.getElementById('birth').value || null,
        zip: document.getElementById('zip').value || null,
        pref_id: document.getElementById('pref_id').value ? parseInt(document.getElementById('pref_id').value) : null,
        addr: document.getElementById('addr').value || null,
        enable_flg: document.getElementById('enable_flg').checked ? 1 : 0
    };

    if (password) {
        data.password = password;
    }

    try {
        const url = isEditMode ? `/api/members/${memberId}` : '/api/members';
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

        alert(isEditMode ? '会員情報を更新しました' : '会員を登録しました');
        window.location.href = '/admin/members';
    } catch (error) {
        console.error('Error:', error);
        alert(error.message);
    }
});

async function initialize() {
    await loadPrefs();
    await loadMemberData();
}

// DOMContentLoadedで初期化
document.addEventListener('DOMContentLoaded', () => {
    initialize();
});
