let currentPage = 1;
let currentSearch = '';
const perPage = 20;

function logout() {
    if (confirm('ログアウトしますか？')) {
        window.location.href = '/admin/logout';
    }
}

async function loadMembers(page = 1, search = '') {
    try {
        currentPage = page;
        currentSearch = search;

        const params = new URLSearchParams({
            page: page.toString(),
            per_page: perPage.toString()
        });

        if (search) {
            params.append('search', search);
        }

        const response = await fetch('/api/members?' + params.toString());
        
        if (!response.ok) {
            throw new Error('会員一覧の取得に失敗しました');
        }

        const result = await response.json();
        displayMembers(result.data);
        displayPagination(result.pagination);
    } catch (error) {
        console.error('Error:', error);
        alert('会員一覧の読み込みに失敗しました');
    }
}

function displayMembers(members) {
    const tbody = document.getElementById('membersTableBody');
    
    if (members.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center">会員が見つかりませんでした</td></tr>';
        return;
    }

    tbody.innerHTML = members.map(member => `
        <tr>
            <td>${member.id}</td>
            <td>${member.email}</td>
            <td>${member.family_name} ${member.first_name}</td>
            <td>${member.family_kana} ${member.first_kana}</td>
            <td>${member.mobile || ''}</td>
            <td>${member.enable_flg ? '有効' : '無効'}</td>
            <td>${member.created_at ? new Date(member.created_at).toLocaleDateString('ja-JP') : ''}</td>
            <td>
                <a href="/admin/members/${member.id}/edit" class="action-link action-link-primary">
                    <i class="fas fa-edit"></i> 編集
                </a>
                <a href="#" onclick="deleteMember(${member.id}); return false;" class="action-link action-link-danger">
                    <i class="fas fa-trash"></i> 削除
                </a>
            </td>
        </tr>
    `).join('');
}

function displayPagination(pagination) {
    const paginationDiv = document.getElementById('pagination');
    
    if (pagination.total_pages <= 1) {
        paginationDiv.innerHTML = '';
        return;
    }

    let html = '<div class="pagination-info">';
    html += `全${pagination.total}件中 ${(pagination.page - 1) * pagination.per_page + 1}〜${Math.min(pagination.page * pagination.per_page, pagination.total)}件を表示`;
    html += '</div><div class="pagination-buttons">';

    if (pagination.page > 1) {
        html += `<button onclick="loadMembers(${pagination.page - 1}, '${currentSearch}')" class="pagination-btn">前へ</button>`;
    }

    const startPage = Math.max(1, pagination.page - 2);
    const endPage = Math.min(pagination.total_pages, pagination.page + 2);

    for (let i = startPage; i <= endPage; i++) {
        const activeClass = i === pagination.page ? 'active' : '';
        html += `<button onclick="loadMembers(${i}, '${currentSearch}')" class="pagination-btn ${activeClass}">${i}</button>`;
    }

    if (pagination.page < pagination.total_pages) {
        html += `<button onclick="loadMembers(${pagination.page + 1}, '${currentSearch}')" class="pagination-btn">次へ</button>`;
    }

    html += '</div>';
    paginationDiv.innerHTML = html;
}

function searchMembers() {
    const searchInput = document.getElementById('searchInput');
    const search = searchInput.value.trim();
    loadMembers(1, search);
}

function resetSearch() {
    const searchInput = document.getElementById('searchInput');
    searchInput.value = '';
    loadMembers(1, '');
}

async function deleteMember(id) {
    if (!confirm('この会員を削除してもよろしいですか？')) {
        return;
    }

    try {
        const response = await fetch(`/api/members/${id}`, {
            method: 'DELETE'
        });

        if (!response.ok) {
            throw new Error('会員の削除に失敗しました');
        }

        alert('会員を削除しました');
        loadMembers(currentPage, currentSearch);
    } catch (error) {
        console.error('Error:', error);
        alert('会員の削除に失敗しました');
    }
}

// 初回読み込み
document.addEventListener('DOMContentLoaded', () => {
    loadMembers();
    
    // リセットボタンのイベントリスナー
    const resetBtn = document.getElementById('resetBtn');
    if (resetBtn) {
        resetBtn.addEventListener('click', resetSearch);
    }
    
    // CSVテンプレートダウンロードボタン
    const downloadCsvTemplateBtn = document.getElementById('downloadCsvTemplateBtn');
    if (downloadCsvTemplateBtn) {
        downloadCsvTemplateBtn.addEventListener('click', downloadCsvTemplate);
    }
    
    // CSVアップロードボタン
    const uploadCsvBtn = document.getElementById('uploadCsvBtn');
    if (uploadCsvBtn) {
        uploadCsvBtn.addEventListener('click', () => {
            document.getElementById('csvFileInput').click();
        });
    }
    
    // CSVファイル選択時
    const csvFileInput = document.getElementById('csvFileInput');
    if (csvFileInput) {
        csvFileInput.addEventListener('change', handleCsvUpload);
    }
});

// ========================================
// CSV会員一括登録機能
// ========================================

// CSVテンプレートダウンロード
async function downloadCsvTemplate() {
    const button = document.getElementById('downloadCsvTemplateBtn');
    
    try {
        console.log('CSVテンプレートダウンロード開始');
        
        // ボタンを無効化
        button.disabled = true;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ダウンロード中...';
        
        const response = await fetch('/api/v2/members/csv-template');
        
        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'ダウンロードに失敗しました');
        }
        
        // Blobとしてダウンロード
        const blob = await response.blob();
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        
        // ファイル名をContent-Dispositionヘッダーから取得
        const contentDisposition = response.headers.get('Content-Disposition');
        let filename = '会員一括登録テンプレート.csv';
        if (contentDisposition) {
            const match = contentDisposition.match(/filename\*?=['"]?([^'";\n]+)['"]?/);
            if (match && match[1]) {
                filename = decodeURIComponent(match[1]);
            }
        }
        
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
        console.log('CSVテンプレートダウンロード完了:', filename);
        
    } catch (error) {
        console.error('CSVテンプレートダウンロードエラー:', error);
        alert(`エラー: ${error.message}`);
    } finally {
        // ボタンを復元
        button.disabled = false;
        button.innerHTML = '<i class="fas fa-download"></i> CSVテンプレート';
    }
}

// CSVアップロード処理
async function handleCsvUpload(e) {
    const file = e.target.files[0];
    if (!file) return;
    
    console.log('CSVアップロード開始:', {
        filename: file.name,
        size: file.size
    });
    
    // 確認ダイアログ
    if (!confirm('CSVファイルから会員を一括登録します。よろしいですか？\n※既に登録されているメールアドレスはスキップされます。')) {
        e.target.value = ''; // ファイル選択をリセット
        return;
    }
    
    const resultDiv = document.getElementById('csvUploadResult');
    const uploadButton = document.getElementById('uploadCsvBtn');
    
    try {
        // ボタンを無効化
        if (uploadButton) {
            uploadButton.disabled = true;
            uploadButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> アップロード中...';
        }
        
        // 進捗表示
        if (resultDiv) {
            resultDiv.style.display = 'block';
            resultDiv.className = 'alert alert-info';
            resultDiv.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 処理中...';
        }
        
        // FormDataを作成
        const formData = new FormData();
        formData.append('csv_file', file);
        
        // APIリクエスト
        const response = await fetch('/api/v2/members/csv-upload', {
            method: 'POST',
            body: formData
        });
        
        const result = await response.json();
        
        if (result.success) {
            console.log('CSVアップロード成功:', result);
            
            // 成功メッセージ
            let message = `<strong>登録完了！</strong><br>${result.message}`;
            
            // スキップした行がある場合は詳細を表示
            if (result.skippedRows && result.skippedRows.length > 0) {
                message += '<br><br><strong>スキップした行：</strong><br>';
                message += '<ul style="margin: 0.5rem 0; padding-left: 1.5rem;">';
                result.skippedRows.forEach(skip => {
                    message += `<li>${skip.line}行目（${skip.email}）: ${skip.reason}</li>`;
                });
                message += '</ul>';
            }
            
            if (resultDiv) {
                resultDiv.className = 'alert alert-success';
                resultDiv.innerHTML = message;
            }
            
            // 会員一覧を再読み込み
            setTimeout(() => {
                loadMembers(1, '');
            }, 1500);
            
        } else {
            throw new Error(result.error || 'アップロードに失敗しました');
        }
        
    } catch (error) {
        console.error('CSVアップロードエラー:', error);
        
        if (resultDiv) {
            resultDiv.className = 'alert alert-danger';
            resultDiv.innerHTML = `<strong>エラー：</strong> ${error.message}`;
        }
        
        alert(`エラー: ${error.message}`);
        
    } finally {
        // ボタンを復元
        if (uploadButton) {
            uploadButton.disabled = false;
            uploadButton.innerHTML = '<i class="fas fa-upload"></i> CSV一括登録';
        }
        
        // ファイル選択をリセット
        e.target.value = '';
    }
}
