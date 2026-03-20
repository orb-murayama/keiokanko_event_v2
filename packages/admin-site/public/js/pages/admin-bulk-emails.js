// Admin Bulk Emails Page Script

let currentJobId = null;
let templates = [];
let currentJobTotal = 0;  // 登録総数を保存

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', async function() {
  console.log('一括メール送信ページを初期化');
  
  try {
    // テンプレート一覧を読み込み
    await loadTemplates();
    
    // デフォルトの送信日時を設定（明日の10:00）
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    document.getElementById('scheduledDate').value = tomorrow.toISOString().split('T')[0];
    
    // テンプレート選択イベント
    document.getElementById('templateSelect').addEventListener('change', handleTemplateSelect);
    
    // テンプレート保存ボタン
    document.getElementById('saveTemplateBtn').addEventListener('click', handleSaveTemplate);
    document.getElementById('cancelSaveBtn').addEventListener('click', closeSaveTemplateModal);
    document.getElementById('confirmSaveBtn').addEventListener('click', confirmSaveTemplate);
    
    // プレビューボタン
    document.getElementById('previewBtn').addEventListener('click', handlePreview);
    
    // フォーム送信
    document.getElementById('bulkEmailForm').addEventListener('submit', handleSubmit);
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

// テンプレート一覧を読み込み
async function loadTemplates() {
  try {
    const response = await fetch('/api/v2/email-templates');
    if (!response.ok) {
      throw new Error('テンプレートの取得に失敗しました');
    }
    
    const data = await response.json();
    templates = data.templates || [];
    
    // セレクトボックスをクリアして再構築
    const select = document.getElementById('templateSelect');
    select.innerHTML = '<option value="">新規作成（テンプレートなし）</option>';
    
    templates.forEach(template => {
      const option = document.createElement('option');
      option.value = template.id;
      option.textContent = template.template_name + (template.description ? ` - ${template.description}` : '');
      select.appendChild(option);
    });
    
    console.log('テンプレート数:', templates.length);
  } catch (error) {
    console.error('テンプレート読み込みエラー:', error);
    // エラーでも続行
  }
}

// テンプレート選択時
function handleTemplateSelect(event) {
  const templateId = event.target.value;
  
  if (!templateId) {
    // 新規作成の場合はクリア
    document.getElementById('fromEmail').value = '';
    document.getElementById('bccEmail').value = '';
    document.getElementById('emailSubject').value = '';
    document.getElementById('emailBody').value = '';
    return;
  }
  
  // テンプレートを検索
  const template = templates.find(t => t.id === parseInt(templateId));
  
  if (template) {
    document.getElementById('fromEmail').value = template.from_email || '';
    document.getElementById('bccEmail').value = template.bcc_email || '';
    document.getElementById('emailSubject').value = template.subject_template || '';
    document.getElementById('emailBody').value = template.body_template || '';
  }
}

// プレビュー表示
async function handlePreview() {
  try {
    // 入力値を取得
    const subjectTemplate = document.getElementById('emailSubject').value.trim();
    const bodyTemplate = document.getElementById('emailBody').value.trim();
    const csvFile = document.getElementById('bookingCsv').files[0];
    
    if (!subjectTemplate || !bodyTemplate) {
      window.Utils.showError('件名と本文を入力してください');
      return;
    }
    
    if (!csvFile) {
      window.Utils.showError('予約番号CSVファイルを選択してください');
      return;
    }
    
    window.Utils.showLoading(true);
    
    // CSVから最初の予約番号を取得
    const csvText = await csvFile.text();
    const lines = csvText.split('\n');
    let firstBookingNumber = null;
    
    for (const line of lines) {
      const trimmed = line.trim();
      if (trimmed && trimmed.startsWith('BK')) {
        firstBookingNumber = trimmed.split(',')[0].trim();
        break;
      }
    }
    
    if (!firstBookingNumber) {
      window.Utils.showError('CSVファイルに有効な予約番号が見つかりません');
      window.Utils.showLoading(false);
      return;
    }
    
    console.log('プレビュー対象予約番号:', firstBookingNumber);
    
    // プレビューAPIを呼び出し
    const response = await fetch('/api/v2/bulk-emails/preview', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        booking_number: firstBookingNumber,
        subject_template: subjectTemplate,
        body_template: bodyTemplate
      })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'プレビューの生成に失敗しました');
    }
    
    const data = await response.json();
    
    // プレビューを表示
    const preview = data.preview || data;
    document.getElementById('previewTo').textContent = preview.to_email || '-';
    document.getElementById('previewSubject').textContent = preview.subject || '-';
    document.getElementById('previewBody').textContent = preview.body || '-';
    document.getElementById('previewArea').style.display = 'block';
    
    // プレビューエリアまでスクロール
    document.getElementById('previewArea').scrollIntoView({ behavior: 'smooth', block: 'start' });
    
    window.Utils.showLoading(false);
    
  } catch (error) {
    console.error('プレビューエラー:', error);
    window.Utils.showLoading(false);
    window.Utils.showError(error.message || 'プレビューの表示に失敗しました');
  }
}

// フォーム送信
async function handleSubmit(event) {
  event.preventDefault();
  
  try {
    // 入力値を取得
    const templateId = document.getElementById('templateSelect').value;
    const fromEmail = document.getElementById('fromEmail').value.trim();
    const bccEmail = document.getElementById('bccEmail').value.trim();
    const subjectTemplate = document.getElementById('emailSubject').value.trim();
    const bodyTemplate = document.getElementById('emailBody').value.trim();
    const scheduledDate = document.getElementById('scheduledDate').value;
    const scheduledTime = document.getElementById('scheduledTime').value;
    const sendNow = document.getElementById('sendNow').checked;
    const csvFile = document.getElementById('bookingCsv').files[0];
    
    // バリデーション
    if (!fromEmail) {
      window.Utils.showError('差出人メールアドレスを入力してください');
      return;
    }
    
    if (!subjectTemplate) {
      window.Utils.showError('メールタイトルを入力してください');
      return;
    }
    
    if (!bodyTemplate) {
      window.Utils.showError('メール本文を入力してください');
      return;
    }
    
    if (!sendNow && (!scheduledDate || !scheduledTime)) {
      window.Utils.showError('送信日時を指定してください');
      return;
    }
    
    if (!csvFile) {
      window.Utils.showError('予約番号CSVファイルを選択してください');
      return;
    }
    
    // 確認ダイアログ
    if (!confirm('メール送信を登録します。よろしいですか？')) {
      return;
    }
    
    // ボタンを無効化
    document.getElementById('submitBtn').disabled = true;
    document.getElementById('previewBtn').disabled = true;
    
    // 進捗表示
    document.getElementById('progressArea').style.display = 'block';
    document.getElementById('resultArea').style.display = 'none';
    document.getElementById('progressBar').style.width = '0%';
    document.getElementById('progressBar').textContent = '0%';
    document.getElementById('progressText').textContent = '処理を開始しています...';
    
    // 送信日時を作成
    const scheduledSendAt = sendNow ? 
      new Date().toISOString().replace('T', ' ').substring(0, 19) :
      `${scheduledDate} ${scheduledTime}:00`;
    
    // CSVファイルを読み込んで予約番号配列を作成
    const csvText = await csvFile.text();
    const lines = csvText.split('\n');
    const bookingNumbers = [];
    
    for (const line of lines) {
      const trimmed = line.trim();
      if (trimmed && trimmed.startsWith('BK')) {
        bookingNumbers.push(trimmed.split(',')[0].trim());
      }
    }
    
    if (bookingNumbers.length === 0) {
      window.Utils.showError('CSVファイルに有効な予約番号が見つかりません');
      document.getElementById('submitBtn').disabled = false;
      document.getElementById('previewBtn').disabled = false;
      return;
    }
    
    // リクエストボディを作成
    const requestBody = {
      from_email: fromEmail,
      subject_template: subjectTemplate,
      body_template: bodyTemplate,
      scheduled_send_at: scheduledSendAt,
      booking_numbers: bookingNumbers
    };
    
    if (templateId) requestBody.template_id = parseInt(templateId);
    if (bccEmail) requestBody.bcc_email = bccEmail;
    
    console.log('一括メール登録開始:', {
      from: fromEmail,
      scheduledSendAt,
      sendNow,
      bookingCount: bookingNumbers.length
    });
    
    // APIを呼び出し
    const response = await fetch('/api/v2/bulk-emails/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(requestBody)
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'メール登録に失敗しました');
    }
    
    const result = await response.json();
    console.log('一括メール登録開始成功:', result);
    
    currentJobId = result.job_id;
    currentJobTotal = result.total || 0;  // 登録総数を保存
    
    // 進捗をポーリング
    pollJobStatus(result.job_id);
    
  } catch (error) {
    console.error('送信エラー:', error);
    window.Utils.showError(error.message || 'メール登録に失敗しました');
    
    // ボタンを元に戻す
    document.getElementById('submitBtn').disabled = false;
    document.getElementById('previewBtn').disabled = false;
    document.getElementById('progressArea').style.display = 'none';
  }
}

// ジョブステータスをポーリング
async function pollJobStatus(jobId) {
  let attempts = 0;
  const maxAttempts = 120; // 最大4分
  
  const checkStatus = async () => {
    if (currentJobId !== jobId) {
      return;
    }
    
    try {
      const response = await fetch(`/api/v2/bulk-emails/status/${jobId}`);
      
      if (!response.ok) {
        throw new Error('ステータスの取得に失敗しました');
      }
      
      const status = await response.json();
      console.log('ジョブステータス:', status);
      
      // 進捗を更新
      const percentage = status.total > 0 ? Math.round((status.registered / status.total) * 100) : 0;
      document.getElementById('progressBar').style.width = `${percentage}%`;
      document.getElementById('progressBar').textContent = `${percentage}%`;
      
      if (status.status === 'processing') {
        document.getElementById('progressText').textContent = `処理中... (${status.registered}/${status.total})`;
      }
      
      // 完了チェック
      if (status.status === 'completed') {
        console.log('一括メール登録完了:', status.results);
        
        // 進捗を100%に
        document.getElementById('progressBar').style.width = '100%';
        document.getElementById('progressBar').textContent = '100%';
        document.getElementById('progressText').textContent = '完了しました！';
        
        // 進捗エリアを非表示
        setTimeout(() => {
          document.getElementById('progressArea').style.display = 'none';
        }, 1000);
        
        // 結果を表示
        displayResults(status);
        
        // ボタンを有効化
        document.getElementById('submitBtn').disabled = false;
        document.getElementById('previewBtn').disabled = false;
        
        window.Utils.showSuccess('メール登録が完了しました');
        return;
      }
      
      if (status.status === 'failed') {
        throw new Error(status.error || 'メール登録に失敗しました');
      }
      
      // 次のチェック
      attempts++;
      if (attempts < maxAttempts) {
        setTimeout(checkStatus, 2000);
      } else {
        throw new Error('処理がタイムアウトしました');
      }
      
    } catch (error) {
      console.error('ステータスチェックエラー:', error);
      window.Utils.showError(error.message);
      
      // ボタンを元に戻す
      document.getElementById('submitBtn').disabled = false;
      document.getElementById('previewBtn').disabled = false;
      document.getElementById('progressArea').style.display = 'none';
    }
  };
  
  // 初回チェック
  checkStatus();
}

// 結果を表示
function displayResults(status) {
  // results プロパティが存在しない場合のフォールバック
  const results = status.results || [];
  const successCount = results.filter(r => r.status === 'success').length;
  const errorCount = results.filter(r => r.status === 'error').length;
  
  // 詳細情報がない場合は、登録件数から推測
  const totalCount = status.total || currentJobTotal || 0;
  const registeredCount = status.registered || totalCount;
  
  // サマリー
  const summaryHtml = `
    <p style="margin: 0; font-size: 16px; font-weight: bold;">
      <i class="fas fa-check-circle" style="color: #28a745;"></i> 登録成功: ${results.length > 0 ? successCount : registeredCount}件
      ${errorCount > 0 ? `<br><i class="fas fa-exclamation-triangle" style="color: #ffc107;"></i> エラー: ${errorCount}件` : ''}
      ${results.length === 0 && registeredCount > 0 ? '<br><small style="font-weight: normal; color: #666;">※ 詳細な結果情報は利用できません</small>' : ''}
    </p>
  `;
  
  document.getElementById('resultSummary').innerHTML = summaryHtml;
  
  // テーブル（結果詳細がある場合のみ表示）
  if (results.length > 0) {
    let tableHtml = `
      <table style="width: 100%; border-collapse: collapse; margin-top: 15px;">
        <thead>
          <tr style="background: #f8f9fa; border-bottom: 2px solid #dee2e6;">
            <th style="padding: 12px; text-align: left; font-weight: bold;">予約番号</th>
            <th style="padding: 12px; text-align: left; font-weight: bold;">送信先</th>
            <th style="padding: 12px; text-align: center; font-weight: bold;">ステータス</th>
            <th style="padding: 12px; text-align: left; font-weight: bold;">備考</th>
          </tr>
        </thead>
        <tbody>
    `;
    
    results.forEach(result => {
      const statusBadge = result.status === 'success' ? 
        '<span style="background: #28a745; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">成功</span>' :
        '<span style="background: #dc3545; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">エラー</span>';
      
      tableHtml += `
        <tr style="border-bottom: 1px solid #dee2e6;">
          <td style="padding: 10px;">${result.booking_number}</td>
          <td style="padding: 10px;">${result.to_email || '-'}</td>
          <td style="padding: 10px; text-align: center;">${statusBadge}</td>
          <td style="padding: 10px; color: ${result.error ? '#dc3545' : '#666'};">
            ${result.error || '-'}
          </td>
        </tr>
      `;
    });
    
    tableHtml += `
        </tbody>
      </table>
    `;
    
    document.getElementById('resultTable').innerHTML = tableHtml;
  } else {
    // 結果詳細がない場合は、簡易メッセージを表示
    document.getElementById('resultTable').innerHTML = `
      <div style="background: #e7f3ff; border-left: 4px solid #0d6efd; padding: 15px; margin-top: 15px; border-radius: 4px;">
        <p style="margin: 0 0 10px 0; font-size: 14px; color: #495057;">
          <i class="fas fa-info-circle" style="color: #0d6efd;"></i> 
          メール登録が完了しました。
        </p>
        <p style="margin: 0; font-size: 13px; color: #666; line-height: 1.6;">
          登録されたメールは、各予約の詳細画面で確認できます：<br>
          <strong>予約管理</strong> → <strong>予約詳細</strong> → <strong>メール送信セクション</strong>
        </p>
      </div>
    `;
  }
  
  document.getElementById('resultArea').style.display = 'block';
  
  // 結果エリアまでスクロール
  document.getElementById('resultArea').scrollIntoView({ behavior: 'smooth', block: 'start' });
}

// ========================================
// テンプレート保存機能
// ========================================

// テンプレート保存ボタンクリック
function handleSaveTemplate() {
  // 入力値を検証
  const fromEmail = document.getElementById('fromEmail').value.trim();
  const subject = document.getElementById('emailSubject').value.trim();
  const body = document.getElementById('emailBody').value.trim();
  
  if (!fromEmail || !subject || !body) {
    window.Utils.showError('差出人、件名、本文を入力してください');
    return;
  }
  
  // メールアドレスの簡易バリデーション
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(fromEmail)) {
    window.Utils.showError('差出人のメールアドレスが正しくありません');
    return;
  }
  
  // モーダルを表示
  document.getElementById('saveTemplateModal').style.display = 'flex';
  document.getElementById('templateName').focus();
}

// テンプレート保存モーダルを閉じる
function closeSaveTemplateModal() {
  document.getElementById('saveTemplateModal').style.display = 'none';
  document.getElementById('templateName').value = '';
  document.getElementById('templateDescription').value = '';
}

// テンプレート保存確認
async function confirmSaveTemplate() {
  const templateName = document.getElementById('templateName').value.trim();
  
  if (!templateName) {
    window.Utils.showError('テンプレート名を入力してください');
    return;
  }
  
  try {
    window.Utils.showLoading(true);
    
    const response = await fetch('/api/v2/email-templates', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        template_name: templateName,
        description: document.getElementById('templateDescription').value.trim() || null,
        from_email: document.getElementById('fromEmail').value.trim(),
        bcc_email: document.getElementById('bccEmail').value.trim() || null,
        subject_template: document.getElementById('emailSubject').value.trim(),
        body_template: document.getElementById('emailBody').value.trim()
      })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'テンプレートの保存に失敗しました');
    }
    
    const result = await response.json();
    window.Utils.showSuccess(`テンプレート「${templateName}」を保存しました`);
    
    // モーダルを閉じる
    closeSaveTemplateModal();
    
    // テンプレート一覧を再読み込み
    await loadTemplates();
    
    // 保存したテンプレートを自動選択
    document.getElementById('templateSelect').value = result.id;
    
  } catch (error) {
    console.error('テンプレート保存エラー:', error);
    window.Utils.showError(error.message);
  } finally {
    window.Utils.showLoading(false);
  }
}
