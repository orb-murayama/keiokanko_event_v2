// Admin Event Form Page Script (HTML5版)

// グローバル変数
let isEditMode = false;
let eventId = null;
let currentImageUrl = null;

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', async function() {
  console.log('イベント登録・編集ページを初期化');
  
  // URLクエリパラメータからイベントIDを取得
  const urlParams = new URLSearchParams(window.location.search);
  const id = urlParams.get('id');
  
  if (id && id !== 'new') {
    isEditMode = true;
    eventId = id;
    console.log('編集モード: イベントID =', eventId);
  } else {
    console.log('新規登録モード');
  }
  
  try {
    // フォームHTMLを生成
    renderForm();
    
    // フォームイベント設定
    setupFormEvents();
    
    // 選択肢データを読み込み
    await loadClients();
    await loadOrganizers();
    await loadVendors();
    await loadCategories();
    await loadBranches();
    await loadParentEvents();
    
    // 担当者データを読み込み（編集モード用に先に読み込む必要がある）
    await initializeStaffSelector();
    
    // 編集モードの場合、イベントデータを読み込み
    if (isEditMode) {
      await loadEventData();
    }
    
    // ローディングを非表示、フォームを表示
    document.getElementById('loading').style.display = 'none';
    document.getElementById('eventFormContainer').style.display = 'block';
    
    console.log('初期化完了');
  } catch (error) {
    console.error('初期化エラー:', error);
    window.Utils.showError('ページの初期化に失敗しました');
  }
});

// フォームHTMLを生成
function renderForm() {
  const container = document.getElementById('eventFormContainer');
  if (!container) return;
  
  container.innerHTML = `
    <form id="eventForm" class="form-container">
      ${renderBasicSection()}
      ${renderStaffSection()}
      ${renderDatesSection()}
      ${renderContactSection()}
      ${renderPaymentSection()}
      ${renderCancellationPolicySection()}
      ${renderEmailSection()}
      ${renderConsentSection()}

      <!-- アクションボタン -->
      <div class="form-actions">
        <a href="/admin/events" class="btn btn-secondary">
          <i class="fas fa-times mr-2"></i>キャンセル
        </a>
        <button type="submit" class="btn btn-primary">
          <i class="fas fa-save mr-2"></i>${isEditMode ? '更新' : '登録'}
        </button>
      </div>
    </form>
  `;
}

// 基本情報セクション
function renderBasicSection() {
  return `
    <div class="form-section">
      <h3 class="form-section-title">
        <i class="fas fa-info-circle"></i>
        基本情報
      </h3>
      <div class="form-section-content">
        <div class="form-group full-width">
          <label for="name" class="form-label">イベント名<span class="required">*</span></label>
          <input type="text" id="name" name="name" class="form-control" required>
        </div>
        
        <div class="form-row">
          <div class="form-group" style="display:none">
            <label for="name_en" class="form-label">イベント名（英語）</label>
            <input type="text" id="name_en" name="name_en" class="form-control" disabled>
          </div>
          
          <div class="form-group">
            <label for="event_url" class="form-label">イベントURL<span class="required">*</span></label>
            <input type="text" id="event_url" name="event_url" class="form-control" required 
                   placeholder="例: summer-festival-2024">
            <small class="form-helper">半角英数字とハイフンのみ使用可能</small>
          </div>
        
          <div class="form-group">
            <label for="category" class="form-label">カテゴリ</label>
            <select id="category" name="category" class="form-control">
              <option value="">選択してください</option>
            </select>
          </div>
          
          <div class="form-group" style="grid-column: span 2;">
            <label for="event_detail_url" class="form-label">イベント詳細URL</label>
            <input type="url" id="event_detail_url" name="event_detail_url" 
                   class="form-control" 
                   placeholder="https://example.com/event-detail">
            <small class="form-helper">イベントの詳細ページURLを入力してください</small>
          </div>
        </div>
      
        <div class="form-row">
          <div class="form-group">
            <label for="client_id" class="form-label">クライアント<span class="required">*</span></label>
            <select id="client_id" name="client_id" class="form-control" required>
              <option value="">選択してください</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="organizer_id" class="form-label">主催者</label>
            <select id="organizer_id" name="organizer_id" class="form-control">
              <option value="">選択してください</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="vendor_id" class="form-label">販売会社</label>
            <select id="vendor_id" name="vendor_id" class="form-control">
              <option value="">選択してください</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="branch_code" class="form-label">支店</label>
            <select id="branch_code" name="branch_code" class="form-control">
              <option value="">選択してください</option>
            </select>
          </div>
        </div>
      
        <div class="form-row">
          <div class="form-group">
            <label for="enable_flg" class="form-label">状態</label>
            <select id="enable_flg" name="enable_flg" class="form-control">
              <option value="1">公開</option>
              <option value="0">非公開</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="event_type" class="form-label">イベント種別</label>
            <select id="event_type" name="event_type" class="form-control">
              <option value="standalone">単独イベント</option>
              <option value="parent">親イベント</option>
              <option value="child">子イベント</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="parent_event_id" class="form-label">親イベント</label>
            <select id="parent_event_id" name="parent_event_id" class="form-control">
              <option value="">なし</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="date_selection_type" class="form-label">日程選択方式</label>
            <select id="date_selection_type" name="date_selection_type" class="form-control">
              <option value="button">ボタン選択</option>
              <option value="calendar">カレンダー選択</option>
            </select>
          </div>
        </div>
        
        <!-- 参加者情報入力設定 -->
        <div class="form-group full-width">
          <label class="form-label">
            <i class="fas fa-user-edit"></i> 参加者情報入力
          </label>
          <div class="field-checkbox">
            <input type="checkbox" id="require_participant_info" name="require_participant_info" value="1">
            <label for="require_participant_info">入力する</label>
          </div>
          <small class="form-help">
            <i class="fas fa-info-circle"></i> チェックすると、予約時に参加者の詳細情報（氏名、連絡先など）の入力を求めます
          </small>
        </div>
        
        <div class="form-group full-width">
          <label for="detail" class="form-label">イベント詳細</label>
          <textarea id="detail" name="detail" rows="4" class="form-control"></textarea>
        </div>
        
        <div class="form-group full-width" style="display:none">
          <label for="detail_en" class="form-label">イベント詳細（英語）</label>
        <textarea id="detail_en" name="detail_en" rows="4" class="form-control" disabled></textarea>
      </div>
      
      <div class="form-row">
        <div class="form-group" style="grid-column: span 2;">
          <label for="location" class="form-label">開催場所</label>
          <input type="text" id="location" name="location" class="form-control">
        </div>
        
        <div class="form-group" style="grid-column: span 2; display:none">
          <label for="location_en" class="form-label">開催場所（英語）</label>
          <input type="text" id="location_en" name="location_en" class="form-control" disabled>
        </div>
      </div>
      
      <div class="form-group full-width">
        <label for="image" class="form-label">イベント画像</label>
        <input type="file" id="image" name="image" accept="image/*" class="form-control">
        <small class="form-helper">JPG, PNG, GIF, WebP (最大5MB)</small>
        
        <div id="imagePreview" class="image-preview hidden">
          <img id="previewImage" src="" alt="プレビュー">
        </div>
      </div>
    </div>
  `;
}

// 日程・期間セクション
function renderDatesSection() {
  return `
    <div class="form-section">
      <h3 class="form-section-title">
        <i class="fas fa-calendar"></i>
        日程・期間
      </h3>
      <div class="alert alert-info">
        <i class="fas fa-info-circle"></i>
        すべての日時は必須項目です
      </div>
      
      <div class="form-row">
        <div class="form-group">
          <label for="event_start_date" class="form-label">開催開始日<span class="required">*</span></label>
          <input type="date" id="event_start_date" name="event_start_date" class="form-control" required>
        </div>
        
        <div class="form-group">
          <label for="event_end_date" class="form-label">開催終了日<span class="required">*</span></label>
          <input type="date" id="event_end_date" name="event_end_date" class="form-control" required>
        </div>
        
        <div class="form-group">
          <label for="registration_start_date" class="form-label">受付開始日時<span class="required">*</span></label>
          <input type="datetime-local" id="registration_start_date" name="registration_start_date" class="form-control" required>
        </div>
        
        <div class="form-group">
          <label for="registration_end_date" class="form-label">受付終了日時<span class="required">*</span></label>
          <input type="datetime-local" id="registration_end_date" name="registration_end_date" class="form-control" required>
        </div>
      </div>
      
      <div class="form-row">
        <div class="form-group">
          <label for="admin_login_start_date" class="form-label">管理画面ログイン開始日時</label>
          <input type="datetime-local" id="admin_login_start_date" name="admin_login_start_date" class="form-control">
        </div>
        
        <div class="form-group">
          <label for="admin_login_end_date" class="form-label">管理画面ログイン終了日時</label>
          <input type="datetime-local" id="admin_login_end_date" name="admin_login_end_date" class="form-control">
        </div>
      </div>
    </div>
  `;
}

// 連絡先セクション
function renderContactSection() {
  return `
    <div class="form-section">
      <h3 class="form-section-title">
        <i class="fas fa-envelope"></i>
        連絡先
      </h3>
      
      <div class="form-row">
        <div class="form-group">
          <label for="admin_email" class="form-label">管理者メールアドレス</label>
          <input type="email" id="admin_email" name="admin_email" class="form-control">
        </div>
        
        <div class="form-group">
          <label for="admin_cc_email" class="form-label">CCメールアドレス</label>
          <input type="email" id="admin_cc_email" name="admin_cc_email" class="form-control">
        </div>
        
        <div class="form-group">
          <label for="sender_name" class="form-label">送信者名</label>
          <input type="text" id="sender_name" name="sender_name" class="form-control">
        </div>
        
        <div class="form-group">
          <label for="sender_email" class="form-label">送信者メールアドレス</label>
          <input type="email" id="sender_email" name="sender_email" class="form-control">
        </div>
      </div>
      
      <div class="form-group full-width">
        <label for="contact" class="form-label">連絡先<span class="required">*</span></label>
        <textarea id="contact" name="contact" rows="3" class="form-control" required></textarea>
      </div>
      
      <div class="form-group full-width" style="display:none">
        <label for="contact_en" class="form-label">連絡先（英語）</label>
        <textarea id="contact_en" name="contact_en" rows="3" class="form-control" disabled></textarea>
      </div>
      
      <div class="form-group full-width">
        <label for="remarks" class="form-label">備考</label>
        <textarea id="remarks" name="remarks" rows="4" class="form-control"></textarea>
      </div>
      
      <div class="form-group full-width" style="display:none">
        <label for="remarks_en" class="form-label">備考（英語）</label>
        <textarea id="remarks_en" name="remarks_en" rows="4" class="form-control" disabled></textarea>
      </div>
      
      <div class="form-group">
        <label for="thanks_msg" class="form-label">サンクスメッセージ</label>
        <textarea id="thanks_msg" name="thanks_msg" rows="4" class="form-control"></textarea>
      </div>
      
      <div class="form-group" style="display:none">
        <label for="thanks_msg_en" class="form-label">サンクスメッセージ（英語）</label>
        <textarea id="thanks_msg_en" name="thanks_msg_en" rows="4" class="form-control" disabled></textarea>
      </div>
      
      <div class="form-group">
        <label for="email_signature" class="form-label">メール署名</label>
        <textarea id="email_signature" name="email_signature" rows="4" class="form-control"></textarea>
      </div>
      
      <div class="form-group" style="display:none">
        <label for="email_signature_en" class="form-label">メール署名（英語）</label>
        <textarea id="email_signature_en" name="email_signature_en" rows="4" class="form-control" disabled></textarea>
      </div>
    </div>
  `;
}

// 担当者設定セクション
function renderStaffSection() {
  return `
    <div class="form-section">
      <h3 class="form-section-title">
        <i class="fas fa-users"></i>
        担当者設定
      </h3>
      <div class="form-section-content">
        <div class="form-group">
          <label class="form-label">
            担当者（複数選択可）
          </label>
          
          <!-- 選択済みタグ表示 -->
          <div class="selected-count" style="margin-bottom: 0.5rem; color: #6b7280; font-size: 0.875rem;">
            選択済み: <span id="selectedCount">0</span>名
          </div>
          <div id="selectedStaffTags" class="tags-container" 
               style="min-height: 80px; border: 1px solid #e5e7eb; border-radius: 0.375rem; padding: 0.75rem; margin-bottom: 1rem; background: #f9fafb;">
            <span style="color: #9ca3af; font-size: 0.875rem;">担当者が選択されていません</span>
          </div>
          
          <!-- 支店フィルタと検索 -->
          <div class="form-row" style="margin-bottom: 1rem;">
            <div class="form-group" style="margin-bottom: 0; flex: 1;">
              <label class="form-label" style="font-size: 0.875rem; margin-bottom: 0.25rem;">
                <i class="fas fa-building"></i> 支店で絞り込み
              </label>
              <select id="branchFilter" class="form-control">
                <option value="">すべての支店</option>
              </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 0; flex: 1;">
              <label class="form-label" style="font-size: 0.875rem; margin-bottom: 0.25rem;">
                <i class="fas fa-search"></i> 担当者を検索
              </label>
              <input type="text" id="staffSearch" class="form-control" 
                     placeholder="名前で検索...">
            </div>
          </div>
          
          <!-- 検索結果リスト -->
          <div id="staffList" class="staff-list" 
               style="border: 1px solid #e5e7eb; border-radius: 0.375rem; max-height: 300px; overflow-y: auto;">
            <div style="padding: 1rem; text-align: center; color: #9ca3af;">
              支店を選択するか、名前で検索してください
            </div>
          </div>
          
          <small class="form-hint">
            <i class="fas fa-info-circle"></i> 支店を選択して絞り込み、名前で検索して追加してください
          </small>
          
          <!-- Hidden inputs for form submission -->
          <div id="hiddenStaffInputs"></div>
        </div>
      </div>
    </div>
  `;
}

// 決済設定セクション
function renderPaymentSection() {
  return `
    <div class="form-section">
      <h3 class="form-section-title">
        <i class="fas fa-credit-card"></i>
        決済設定
      </h3>
      <div class="form-section-content">
        <div class="form-group">
        <label for="payment_flg" class="form-label">決済機能</label>
        <select id="payment_flg" name="payment_flg" class="form-control">
          <option value="0">使用しない</option>
          <option value="1">使用する</option>
        </select>
      </div>
      
      <div id="paymentSettings" style="display: none;">
        <div class="form-group">
          <label class="form-label">決済方法</label>
          <div class="checkbox-group">
            <label class="checkbox-label">
              <input type="checkbox" id="payment_credit_card" name="payment_credit_card" value="1">
              <span>クレジットカード決済</span>
            </label>
            <label class="checkbox-label">
              <input type="checkbox" id="payment_bank_transfer" name="payment_bank_transfer" value="1">
              <span>銀行振込</span>
            </label>
            <label class="checkbox-label">
              <input type="checkbox" id="payment_convenience_store" name="payment_convenience_store" value="1">
              <span>コンビニ決済</span>
            </label>
          </div>
        </div>
        
        <!-- クレジットカード設定 -->
        <div id="creditFeeSettings" class="payment-subsection" style="display: none;">
          <h4 class="subsection-title">クレジットカード設定</h4>
          
          <h5 class="subsection-subtitle">クレジットカード手数料</h5>
          <div class="form-group">
            <label class="form-label">手数料タイプ</label>
            <div class="radio-group">
              <label class="radio-label">
                <input type="radio" name="credit_fee_type" value="none" checked>
                <span>手数料を課金しない</span>
              </label>
              <label class="radio-label">
                <input type="radio" name="credit_fee_type" value="percentage">
                <span>決済金額の</span>
                <input type="number" id="credit_fee_percentage" name="credit_fee_percentage" 
                       class="inline-input" min="0" max="100" step="0.1" placeholder="0" style="width: 80px;">
                <span>%</span>
              </label>
              <label class="radio-label">
                <input type="radio" name="credit_fee_type" value="fixed">
                <span>一律</span>
                <input type="number" id="credit_fee_fixed" name="credit_fee_fixed" 
                       class="inline-input" min="0" step="1" placeholder="0" style="width: 100px;">
                <span>円</span>
              </label>
            </div>
          </div>
        </div>
        
        <!-- 銀行振込設定 -->
        <div id="bankFeeSettings" class="payment-subsection" style="display: none;">
          <h4 class="subsection-title">銀行振込設定</h4>
          <div class="form-row">
            <div class="form-group">
              <label for="bank_name" class="form-label">銀行名</label>
              <input type="text" id="bank_name" name="bank_name" class="form-control">
            </div>
            <div class="form-group">
              <label for="bank_branch" class="form-label">支店名</label>
              <input type="text" id="bank_branch" name="bank_branch" class="form-control">
            </div>
            <div class="form-group">
              <label for="bank_account_type" class="form-label">口座種別</label>
              <select id="bank_account_type" name="bank_account_type" class="form-control">
                <option value="">選択してください</option>
                <option value="普通">普通</option>
                <option value="当座">当座</option>
              </select>
            </div>
            <div class="form-group">
              <label for="bank_account_number" class="form-label">口座番号</label>
              <input type="text" id="bank_account_number" name="bank_account_number" class="form-control">
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="bank_account_name" class="form-label">口座名義</label>
              <input type="text" id="bank_account_name" name="bank_account_name" class="form-control">
            </div>
            <div class="form-group">
              <label for="bank_transfer_deadline" class="form-label">振込期限（日）</label>
              <input type="number" id="bank_transfer_deadline" name="bank_transfer_deadline" 
                     class="form-control" min="1" value="7">
            </div>
          </div>
          
          <h5 class="subsection-subtitle">銀行振込手数料</h5>
          <div class="form-group">
            <label class="form-label">手数料タイプ</label>
            <div class="radio-group">
              <label class="radio-label">
                <input type="radio" name="bank_fee_type" value="none" checked>
                <span>手数料を課金しない</span>
              </label>
              <label class="radio-label">
                <input type="radio" name="bank_fee_type" value="percentage">
                <span>決済金額の</span>
                <input type="number" id="bank_fee_percentage" name="bank_fee_percentage" 
                       class="inline-input" min="0" max="100" step="0.1" placeholder="0" style="width: 80px;">
                <span>%</span>
              </label>
              <label class="radio-label">
                <input type="radio" name="bank_fee_type" value="fixed">
                <span>一律</span>
                <input type="number" id="bank_fee_fixed" name="bank_fee_fixed" 
                       class="inline-input" min="0" step="1" placeholder="0" style="width: 100px;">
                <span>円</span>
              </label>
            </div>
          </div>
        </div>
        
        <!-- コンビニ決済設定 -->
        <div id="convenienceFeeSettings" class="payment-subsection" style="display: none;">
          <h4 class="subsection-title">コンビニ決済設定</h4>
          
          <div class="form-row">
            <div class="form-group">
              <label for="convenience_payment_deadline" class="form-label">支払期限（日）</label>
              <input type="number" id="convenience_payment_deadline" name="convenience_payment_deadline" 
                     class="form-control" min="1" value="7">
            </div>
          </div>
          
          <h5 class="subsection-subtitle">コンビニ決済手数料</h5>
          <div class="form-group">
            <label class="form-label">手数料タイプ</label>
            <div class="radio-group">
              <label class="radio-label">
                <input type="radio" name="convenience_fee_type" value="none" checked>
                <span>手数料を課金しない</span>
              </label>
              <label class="radio-label">
                <input type="radio" name="convenience_fee_type" value="percentage">
                <span>決済金額の</span>
                <input type="number" id="convenience_fee_percentage" name="convenience_fee_percentage" 
                       class="inline-input" min="0" max="100" step="0.1" placeholder="0" style="width: 80px;">
                <span>%</span>
              </label>
              <label class="radio-label">
                <input type="radio" name="convenience_fee_type" value="fixed">
                <span>一律</span>
                <input type="number" id="convenience_fee_fixed" name="convenience_fee_fixed" 
                       class="inline-input" min="0" step="1" placeholder="0" style="width: 100px;">
                <span>円</span>
              </label>
            </div>
          </div>
        </div>
      </div>
      </div>
      </div>
      </div>
      </div>
    </div>
  `;
}


// キャンセルポリシーセクション
function renderCancellationPolicySection() {
  return `
    <div class="form-section">
      <h3 class="form-section-title">
        <i class="fas fa-ban"></i>
        キャンセルポリシー
      </h3>
      <div class="form-section-content">
        <div class="form-group">
          <label for="cancel_policy" class="form-label">キャンセルポリシー</label>
          <textarea id="cancel_policy" name="cancel_policy" class="form-control" rows="3"></textarea>
        </div>

        <div class="form-group">
          <label for="cancellation_policy_details" class="form-label">キャンセルポリシー詳細</label>
          <textarea id="cancellation_policy_details" name="cancellation_policy_details" class="form-control" rows="3"></textarea>
        </div>

        <!-- キャンセル料率設定 -->
        <div class="form-group">
          <label class="form-label">キャンセル料率設定</label>
          <div id="cancellationRates">
            <!-- 最大5つのキャンセル料率 -->
            <div class="form-row" style="margin-bottom: 1rem;">
              <div class="form-group" style="flex: 1;">
                <label for="cancellation_days_1" class="form-label">日数1</label>
                <input type="number" id="cancellation_days_1" name="cancellation_days_1" class="form-control" min="0">
              </div>
              <div class="form-group" style="flex: 1;">
                <label for="cancellation_rate_1" class="form-label">料率1(%)</label>
                <input type="number" id="cancellation_rate_1" name="cancellation_rate_1" class="form-control" min="0" max="100">
              </div>
            </div>
            <div class="form-row" style="margin-bottom: 1rem;">
              <div class="form-group" style="flex: 1;">
                <label for="cancellation_days_2" class="form-label">日数2</label>
                <input type="number" id="cancellation_days_2" name="cancellation_days_2" class="form-control" min="0">
              </div>
              <div class="form-group" style="flex: 1;">
                <label for="cancellation_rate_2" class="form-label">料率2(%)</label>
                <input type="number" id="cancellation_rate_2" name="cancellation_rate_2" class="form-control" min="0" max="100">
              </div>
            </div>
            <div class="form-row" style="margin-bottom: 1rem;">
              <div class="form-group" style="flex: 1;">
                <label for="cancellation_days_3" class="form-label">日数3</label>
                <input type="number" id="cancellation_days_3" name="cancellation_days_3" class="form-control" min="0">
              </div>
              <div class="form-group" style="flex: 1;">
                <label for="cancellation_rate_3" class="form-label">料率3(%)</label>
                <input type="number" id="cancellation_rate_3" name="cancellation_rate_3" class="form-control" min="0" max="100">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  `;
}


// メール設定���クション
function renderEmailSection() {
  return `
    <div class="form-section">
      <h3 class="form-section-title">
        <i class="fas fa-paper-plane"></i>
        メール設定
        <a href="/email-placeholder-help.html" target="_blank" 
           style="margin-left: 15px; font-size: 14px; color: #f59e0b; text-decoration: none; font-weight: normal;"
           onclick="window.open(this.href, 'placeholderHelp', 'width=1100,height=800,scrollbars=yes'); return false;">
          <i class="fas fa-question-circle"></i> プレースホルダー一覧
        </a>
      </h3>
      <div class="form-section-content">
        <div class="form-group">
        <label class="checkbox-label">
          <input type="checkbox" id="auto_reply_enabled" name="auto_reply_enabled" value="1">
          <span>自動返信メールを有効にする</span>
        </label>
      </div>
      
      <div class="email-subsection">
        <h4 class="subsection-title">決済完了メール</h4>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_credit_payment" class="form-label">クレジットカード決済完了</label>
            <textarea id="auto_reply_credit_payment" name="auto_reply_credit_payment" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_credit_payment_en" class="form-label">クレジットカード決済完了（英語）</label>
            <textarea id="auto_reply_credit_payment_en" name="auto_reply_credit_payment_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_bank_payment" class="form-label">銀行振込受付完了</label>
            <textarea id="auto_reply_bank_payment" name="auto_reply_bank_payment" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_bank_payment_en" class="form-label">銀行振込受付完了（英語）</label>
            <textarea id="auto_reply_bank_payment_en" name="auto_reply_bank_payment_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_convenience_payment" class="form-label">コンビニ決済受付完了</label>
            <textarea id="auto_reply_convenience_payment" name="auto_reply_convenience_payment" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_convenience_payment_en" class="form-label">コンビニ決済受付完了（英語）</label>
            <textarea id="auto_reply_convenience_payment_en" name="auto_reply_convenience_payment_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
      </div>
      
      <div class="email-subsection">
        <h4 class="subsection-title">キャンセルメール</h4>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_credit_cancel" class="form-label">クレジットカードキャンセル</label>
            <textarea id="auto_reply_credit_cancel" name="auto_reply_credit_cancel" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_credit_cancel_en" class="form-label">クレジットカードキャンセル（英語）</label>
            <textarea id="auto_reply_credit_cancel_en" name="auto_reply_credit_cancel_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_bank_cancel" class="form-label">銀行振込キャンセル</label>
            <textarea id="auto_reply_bank_cancel" name="auto_reply_bank_cancel" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_bank_cancel_en" class="form-label">銀行振込キャンセル（英語）</label>
            <textarea id="auto_reply_bank_cancel_en" name="auto_reply_bank_cancel_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_convenience_cancel" class="form-label">コンビニ決済キャンセル</label>
            <textarea id="auto_reply_convenience_cancel" name="auto_reply_convenience_cancel" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_convenience_cancel_en" class="form-label">コンビニ決済キャンセル（英語）</label>
            <textarea id="auto_reply_convenience_cancel_en" name="auto_reply_convenience_cancel_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
      </div>
      
      <div class="email-subsection">
        <h4 class="subsection-title">返金メール</h4>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_credit_refund" class="form-label">クレジットカード返金</label>
            <textarea id="auto_reply_credit_refund" name="auto_reply_credit_refund" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_credit_refund_en" class="form-label">クレジットカード返金（英語）</label>
            <textarea id="auto_reply_credit_refund_en" name="auto_reply_credit_refund_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_bank_refund" class="form-label">銀行振込返金</label>
            <textarea id="auto_reply_bank_refund" name="auto_reply_bank_refund" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_bank_refund_en" class="form-label">銀行振込返金（英語）</label>
            <textarea id="auto_reply_bank_refund_en" name="auto_reply_bank_refund_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_convenience_refund" class="form-label">コンビニ決済返金</label>
            <textarea id="auto_reply_convenience_refund" name="auto_reply_convenience_refund" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_convenience_refund_en" class="form-label">コンビニ決済返金（英語）</label>
            <textarea id="auto_reply_convenience_refund_en" name="auto_reply_convenience_refund_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
      </div>
      
      <div class="email-subsection">
        <h4 class="subsection-title">入金確認メール</h4>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_bank_deposit" class="form-label">銀行振込入金確認</label>
            <textarea id="auto_reply_bank_deposit" name="auto_reply_bank_deposit" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_bank_deposit_en" class="form-label">銀行振込入金確認（英語）</label>
            <textarea id="auto_reply_bank_deposit_en" name="auto_reply_bank_deposit_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group full-width">
            <label for="auto_reply_convenience_deposit" class="form-label">コンビニ決済入金確認</label>
            <textarea id="auto_reply_convenience_deposit" name="auto_reply_convenience_deposit" 
                      rows="4" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-row" style="display:none">
          <div class="form-group full-width">
            <label for="auto_reply_convenience_deposit_en" class="form-label">コンビニ決済入金確認（英語）</label>
            <textarea id="auto_reply_convenience_deposit_en" name="auto_reply_convenience_deposit_en" 
                      rows="4" class="form-control" disabled></textarea>
          </div>
        </div>
      </div>
      </div>
      </div>
      </div>
    </div>
  `;
}

// 同意設定セクション
function renderConsentSection() {
  return `
    <div class="form-section">
      <h3 class="form-section-title">
        <i class="fas fa-file-signature"></i>
        個人情報・取引条件の同意設定
      </h3>
      <div class="form-section-content">
        <!-- 個人情報の取り扱い -->
        <div class="consent-subsection">
          <h4 class="subsection-title">個人情報の取り扱い</h4>
          
          <div class="form-row">
            <div class="form-group">
              <label class="checkbox-label">
                <input type="checkbox" id="privacy_policy_enabled" name="privacy_policy_enabled" value="1" checked>
                <span>個人情報同意を表示する</span>
              </label>
            </div>
          </div>
          
          <div class="form-row">
            <div class="form-group full-width">
              <label for="privacy_policy_title" class="form-label">タイトル</label>
              <input type="text" id="privacy_policy_title" name="privacy_policy_title" 
                     class="form-control" value="個人情報の取り扱いについて">
            </div>
          </div>
          
          <div class="form-row">
            <div class="form-group full-width">
              <label for="privacy_policy_content" class="form-label">
                内容（Markdown対応）
                <span class="help-text">見出し: ##、リンク: [テキスト](URL)、リスト: - 項目</span>
              </label>
              <textarea id="privacy_policy_content" name="privacy_policy_content" 
                        rows="10" class="form-control markdown-editor"></textarea>
            </div>
          </div>
          
          <div class="form-row">
            <div class="form-group full-width">
              <label for="privacy_policy_consent_text" class="form-label">同意チェックボックスのテキスト</label>
              <input type="text" id="privacy_policy_consent_text" name="privacy_policy_consent_text" 
                     class="form-control" value="上記の個人情報の取り扱いに同意します">
            </div>
          </div>
        </div>
        
        <!-- 旅行条件について -->
        <div class="consent-subsection">
          <h4 class="subsection-title">旅行条件について</h4>
          
          <div class="form-row">
            <div class="form-group">
              <label class="checkbox-label">
                <input type="checkbox" id="terms_enabled" name="terms_enabled" value="1" checked>
                <span>取引条件同意を表示する</span>
              </label>
            </div>
          </div>
          
          <div class="form-row">
            <div class="form-group full-width">
              <label for="terms_title" class="form-label">タイトル</label>
              <input type="text" id="terms_title" name="terms_title" 
                     class="form-control" value="旅行条件について">
            </div>
          </div>
          
          <div class="form-row">
            <div class="form-group full-width">
              <label for="terms_content" class="form-label">
                内容（Markdown対応）
                <span class="help-text">見出し: ##、リンク: [テキスト](URL)、リスト: - 項目</span>
              </label>
              <textarea id="terms_content" name="terms_content" 
                        rows="10" class="form-control markdown-editor"></textarea>
            </div>
          </div>
          
          <div class="form-row">
            <div class="form-group full-width">
              <label for="terms_consent_text" class="form-label">同意チェックボックスのテキスト</label>
              <input type="text" id="terms_consent_text" name="terms_consent_text" 
                     class="form-control" value="上記の旅行条件に同意します">
            </div>
          </div>
        </div>
      </div>
    </div>
  `;
}

// フォームイベント設定
function setupFormEvents() {
  console.log('========== setupFormEvents が呼び出されました ==========');
  const form = document.getElementById('eventForm');
  console.log('eventForm:', form);
  const imageInput = document.getElementById('image');
  
  // フォーム送信
  if (form) {
    form.addEventListener('submit', handleSubmit);
    console.log('フォーム送信イベントリスナーを設定しました');
  } else {
    console.error('eventForm が見つかりません');
  }
  
  // 画像プレビュー
  if (imageInput) {
    imageInput.addEventListener('change', handleImagePreview);
  }
  
  // イベント種別変更時の親イベント表示切り替え
  const eventType = document.getElementById('event_type');
  if (eventType) {
    eventType.addEventListener('change', function() {
      const parentEventGroup = document.getElementById('parentEventGroup');
      if (parentEventGroup) {
        parentEventGroup.style.display = this.value === 'child' ? 'block' : 'none';
      }
    });
  }
  
  // 決済設定の表示切り替え
  const paymentFlg = document.getElementById('payment_flg');
  if (paymentFlg) {
    paymentFlg.addEventListener('change', togglePaymentSettings);
  }
  
  // 各決済方法の手数料設定表示切り替え
  ['payment_credit_card', 'payment_bank_transfer', 'payment_convenience_store'].forEach(id => {
    const checkbox = document.getElementById(id);
    if (checkbox) {
      checkbox.addEventListener('change', function() {
        togglePaymentMethodSettings(id);
      });
    }
  });
  
  // クレジットカード手数料タイプの切り替え
  const creditFeeType = document.getElementById('credit_fee_type');
  if (creditFeeType) {
    creditFeeType.addEventListener('change', function() {
      const percentageGroup = document.getElementById('creditFeePercentageGroup');
      if (percentageGroup) {
        percentageGroup.style.display = this.value === 'percentage' ? 'block' : 'none';
      }
    });
  }
  
  // 担当者セレクターの初期化は DOMContentLoaded 内で await される
}

// クライアント読み込み
async function loadClients() {
  try {
    console.log('クライアント読み込み開始');
    const response = await fetch('/api/clients');
    
    if (!response.ok) {
      throw new Error('クライアントの読み込みに失敗しました');
    }
    
    const data = await response.json();
    const clients = Array.isArray(data) ? data : (data.clients || []);
    
    // client_id のセレクトボックス
    const clientSelect = document.getElementById('client_id');
    if (clientSelect) {
      clientSelect.innerHTML = '<option value="">選択してください</option>';
      clients.forEach(client => {
        const option = document.createElement('option');
        option.value = client.id;
        option.textContent = client.name;
        clientSelect.appendChild(option);
      });
    }
    
    console.log('クライアント読み込み完了:', clients.length, '件');
  } catch (error) {
    console.error('クライアント読み込みエラー:', error);
    throw error;
  }
}

// 主催者読み込み
async function loadOrganizers() {
  try {
    console.log('主催者読み込み開始');
    const response = await fetch('/api/organizers');
    
    if (!response.ok) {
      throw new Error('主催者の読み込みに失敗しました');
    }
    
    const data = await response.json();
    const organizers = Array.isArray(data) ? data : (data.organizers || []);
    
    const organizerSelect = document.getElementById('organizer_id');
    if (organizerSelect) {
      organizerSelect.innerHTML = '<option value="">選択してください</option>';
      organizers.forEach(organizer => {
        const option = document.createElement('option');
        option.value = organizer.id;
        option.textContent = organizer.name;
        organizerSelect.appendChild(option);
      });
    }
    
    console.log('主催者読み込み完了:', organizers.length, '件');
  } catch (error) {
    console.error('主催者読み込みエラー:', error);
    throw error;
  }
}

// 販売会社読み込み
async function loadVendors() {
  try {
    console.log('販売会社読み込み開始');
    const response = await fetch('/api/vendors');
    
    if (!response.ok) {
      console.warn('販売会社APIが見つかりません');
      return;
    }
    
    const data = await response.json();
    const vendors = Array.isArray(data) ? data : (data.vendors || []);
    
    const vendorSelect = document.getElementById('vendor_id');
    if (vendorSelect) {
      vendorSelect.innerHTML = '<option value="">選択してください</option>';
      vendors.forEach(vendor => {
        const option = document.createElement('option');
        option.value = vendor.id;
        option.textContent = vendor.name;
        vendorSelect.appendChild(option);
      });
    }
    
    console.log('販売会社読み込み完了:', vendors.length, '件');
  } catch (error) {
    console.error('販売会社読み込みエラー:', error);
    // 販売会社は必須ではないため、エラーでも継続
  }
}

// 親イベント読み込み
async function loadParentEvents() {
  try {
    console.log('親イベント読み込み開始');
    const response = await fetch('/api/v1/events?event_type=parent');
    
    if (!response.ok) {
      console.warn('親イベントの読み込みに失敗しました');
      return;
    }
    
    const data = await response.json();
    const events = data.data || data.events || (Array.isArray(data) ? data : []);
    
    const parentEventSelect = document.getElementById('parent_event_id');
    if (parentEventSelect) {
      parentEventSelect.innerHTML = '<option value="">選択してください</option>';
      events.forEach(event => {
        const option = document.createElement('option');
        option.value = event.id;
        option.textContent = event.name;
        parentEventSelect.appendChild(option);
      });
    }
    
    console.log('親イベント読み込み完了:', events.length, '件');
  } catch (error) {
    console.error('親イベント読み込みエラー:', error);
    // 親イベントは必須ではないため、エラーでも継続
  }
}

// カテゴリ読み込み
async function loadCategories() {
  try {
    console.log('カテゴリ読み込み開始');
    const response = await fetch('/api/v1/events/categories');
    
    if (!response.ok) {
      throw new Error('カテゴリの読み込みに失敗しました');
    }
    
    const data = await response.json();
    const categories = Array.isArray(data) ? data : (data.categories || []);
    
    const categorySelect = document.getElementById('category');
    if (categorySelect) {
      categorySelect.innerHTML = '<option value="">選択してください</option>';
      categories.forEach(category => {
        const option = document.createElement('option');
        option.value = category.id || category.name;
        option.textContent = category.name;
        categorySelect.appendChild(option);
      });
    }
    
    console.log('カテゴリ読み込み完了:', categories.length, '件');
  } catch (error) {
    console.error('カテゴリ読み込みエラー:', error);
    // カテゴリは必須ではないため、エラーでも継続
  }
}

// 支店読み込み
async function loadBranches() {
  try {
    console.log('支店読み込み開始');
    const response = await fetch('/api/branches');
    
    if (!response.ok) {
      throw new Error('支店の読み込みに失敗しました');
    }
    
    const data = await response.json();
    const branches = Array.isArray(data) ? data : (data.branches || []);
    
    const branchSelect = document.getElementById('branch_code');
    if (branchSelect) {
      branchSelect.innerHTML = '<option value="">選択してください</option>';
      branches.forEach(branch => {
        const option = document.createElement('option');
        option.value = branch.branch_code;
        option.textContent = `${branch.branch_name} (${branch.branch_code})`;
        branchSelect.appendChild(option);
      });
    }
    
    console.log('支店読み込み完了:', branches.length, '件');
  } catch (error) {
    console.error('支店読み込みエラー:', error);
    // 支店は必須ではないため、エラーでも継続
  }
}

// イベントデータ読み込み（編集時）
async function loadEventData() {
  try {
    console.log('イベントデータ読み込み開始:', eventId);
    const response = await fetch(`/api/events/${eventId}`);
    
    if (!response.ok) {
      throw new Error('イベントデータの読み込みに失敗しました');
    }
    
    const data = await response.json();
    const event = data.event || data;
    
    console.log('イベントデータ:', event);
    
    // フォームにデータを設定
    setFormData(event);
    
    // 画像プレビュー
    if (event.image_url) {
      currentImageUrl = event.image_url;
      showImagePreview(event.image_url);
    }
    
    // 既存担当者を読み込み
    await loadExistingStaff(eventId);
    
    console.log('イベントデータ読み込み完了');
  } catch (error) {
    console.error('イベントデータ読み込みエラー:', error);
    window.Utils.showError('イベントデータの読み込みに失敗しました');
  }
}

// フォームデータ設定
function setFormData(event) {
  // 基本情報
  setValue('name', event.name);
  setValue('name_en', event.name_en);
  setValue('detail', event.detail);
  setValue('detail_en', event.detail_en);
  setValue('location', event.location);
  setValue('location_en', event.location_en);
  setValue('event_url', event.event_url);
  setValue('category', event.category);
  
  // form_field_settings から event_detail_url を取得
  if (event.form_field_settings) {
    try {
      const settings = typeof event.form_field_settings === 'string' 
        ? JSON.parse(event.form_field_settings) 
        : event.form_field_settings;
      if (settings.event_detail_url) {
        setValue('event_detail_url', settings.event_detail_url);
      }
    } catch (e) {
      console.warn('form_field_settings parse error:', e);
    }
  }
  
  setValue('enable_flg', event.enable_flg);
  setValue('event_type', event.event_type);
  setValue('date_selection_type', event.date_selection_type);
  setCheckbox('require_participant_info', event.require_participant_info);
  
  // 組織・担当
  setValue('client_id', event.client_id);
  setValue('organizer_id', event.organizer_id);
  setValue('vendor_id', event.vendor_id);
  setValue('branch_code', event.branch_code);
  setValue('parent_event_id', event.parent_event_id);
  
  // 日程・期間
  setValue('event_start_date', event.event_start_date);
  setValue('event_end_date', event.event_end_date);
  setValue('registration_start_date', event.registration_start_date);
  setValue('registration_end_date', event.registration_end_date);
  setValue('admin_login_start_date', event.admin_login_start_date);
  setValue('admin_login_end_date', event.admin_login_end_date);
  
  // 連絡先
  setValue('contact', event.contact);
  setValue('contact_en', event.contact_en);
  setValue('remarks', event.remarks);
  setValue('remarks_en', event.remarks_en);
  setValue('thanks_msg', event.thanks_msg);
  setValue('thanks_msg_en', event.thanks_msg_en);
  setValue('admin_email', event.admin_email);
  setValue('admin_cc_email', event.admin_cc_email);
  setValue('sender_name', event.sender_name);
  setValue('sender_email', event.sender_email);
  setValue('email_signature', event.email_signature);
  setValue('email_signature_en', event.email_signature_en);
  
  // 決済設定
  setValue('payment_flg', event.payment_flg);
  setCheckbox('payment_credit_card', event.payment_credit_card);
  setCheckbox('payment_bank_transfer', event.payment_bank_transfer);
  setCheckbox('payment_convenience_store', event.payment_convenience_store);
  
  // 銀行振込設定
  setValue('bank_name', event.bank_name);
  setValue('bank_branch', event.bank_branch);
  setValue('bank_account_type', event.bank_account_type);
  setValue('bank_account_number', event.bank_account_number);
  setValue('bank_account_name', event.bank_account_name);
  setValue('bank_transfer_deadline', event.bank_transfer_deadline);
  
  // コンビニ決済設定
  setValue('store_code', event.store_code);
  setValue('convenience_payment_deadline', event.convenience_payment_deadline);
  
  // 利用可能コンビニの復元
  if (event.available_convenience_stores) {
    let stores = [];
    let storesData = event.available_convenience_stores;
    
    // 文字列の前後のダブルクォートを除去
    if (typeof storesData === 'string') {
      storesData = storesData.replace(/^["']|["']$/g, '');
    }
    
    // JSON配列またはカンマ区切り文字列に対応
    if (typeof storesData === 'string') {
      // JSON形式の場合はパース
      if (storesData.startsWith('[') || storesData.startsWith('{')) {
        try {
          stores = JSON.parse(storesData);
        } catch (e) {
          // パース失敗時はカンマ区切りとして処理
          stores = storesData.split(',');
        }
      } else {
        // カンマ区切りの場合
        stores = storesData.split(',');
      }
    } else if (Array.isArray(storesData)) {
      stores = storesData;
    }
    
    // チェックボックスにチェックを入れる
    stores.forEach(store => {
      const storeValue = typeof store === 'string' ? store.trim() : store;
      if (storeValue) {
        const checkbox = document.querySelector(`input[name="convenience_stores"][value="${storeValue}"]`);
        if (checkbox) {
          checkbox.checked = true;
        }
      }
    });
  }
  
  // 手数料設定（ラジオボタン）
  setRadio('credit_fee_type', event.credit_fee_type || 'none');
  setValue('credit_fee_percentage', event.credit_fee_percentage);
  setValue('credit_fee_fixed', event.credit_fee_fixed);
  setRadio('bank_fee_type', event.bank_fee_type || 'none');
  setValue('bank_fee_percentage', event.bank_fee_percentage);
  setValue('bank_fee_fixed', event.bank_fee_fixed);
  setRadio('convenience_fee_type', event.convenience_fee_type || 'none');
  setValue('convenience_fee_percentage', event.convenience_fee_percentage);
  setValue('convenience_fee_fixed', event.convenience_fee_fixed);
  
  // キャンセルポリシー
  setValue('cancel_policy', event.cancel_policy);
  setValue('cancellation_policy_details', event.cancellation_policy_details);
  setValue('cancellation_days_1', event.cancellation_days_1);
  setValue('cancellation_rate_1', event.cancellation_rate_1);
  setValue('cancellation_days_2', event.cancellation_days_2);
  setValue('cancellation_rate_2', event.cancellation_rate_2);
  setValue('cancellation_days_3', event.cancellation_days_3);
  setValue('cancellation_rate_3', event.cancellation_rate_3);
  
  // メール設定
  setCheckbox('auto_reply_enabled', event.auto_reply_enabled);
  setValue('auto_reply_credit_payment', event.auto_reply_credit_payment);
  setValue('auto_reply_bank_payment', event.auto_reply_bank_payment);
  setValue('auto_reply_convenience_payment', event.auto_reply_convenience_payment);
  setValue('auto_reply_credit_cancel', event.auto_reply_credit_cancel);
  setValue('auto_reply_bank_cancel', event.auto_reply_bank_cancel);
  setValue('auto_reply_convenience_cancel', event.auto_reply_convenience_cancel);
  
  // 同意設定
  if (event.consent) {
    setCheckbox('privacy_policy_enabled', event.consent.privacy_policy_enabled);
    setValue('privacy_policy_title', event.consent.privacy_policy_title);
    setValue('privacy_policy_content', event.consent.privacy_policy_content);
    setValue('privacy_policy_consent_text', event.consent.privacy_policy_consent_text);
    setCheckbox('terms_enabled', event.consent.terms_enabled);
    setValue('terms_title', event.consent.terms_title);
    setValue('terms_content', event.consent.terms_content);
    setValue('terms_consent_text', event.consent.terms_consent_text);
  }
  
  // 表示切り替えを実行
  togglePaymentSettings();
  togglePaymentMethodSettings('payment_credit_card');
  togglePaymentMethodSettings('payment_bank_transfer');
  togglePaymentMethodSettings('payment_convenience_store');
}

// 入力値設定ヘルパー
function setValue(id, value) {
  const element = document.getElementById(id);
  if (element && value !== null && value !== undefined) {
    element.value = value;
  }
}

function setCheckbox(id, value) {
  const element = document.getElementById(id);
  if (element) {
    element.checked = value === 1 || value === true;
  }
}

function setRadio(name, value) {
  if (!value) return;
  const radio = document.querySelector(`input[name="${name}"][value="${value}"]`);
  if (radio) {
    radio.checked = true;
  }
}

// 画像プレビュー処理
function handleImagePreview(event) {
  const file = event.target.files[0];
  if (file) {
    // ファイルサイズチェック (5MB)
    if (file.size > 5 * 1024 * 1024) {
      window.Utils.showError('画像サイズは5MB以下にしてください');
      event.target.value = '';
      return;
    }
    
    // プレビュー表示
    const reader = new FileReader();
    reader.onload = function(e) {
      showImagePreview(e.target.result);
    };
    reader.readAsDataURL(file);
  }
}

// 画像プレビュー表示
function showImagePreview(url) {
  const preview = document.getElementById('imagePreview');
  const previewImage = document.getElementById('previewImage');
  
  if (preview && previewImage) {
    previewImage.src = url;
    preview.classList.remove('hidden');
  }
}

// 画像アップロード
async function uploadImage(file) {
  const formData = new FormData();
  formData.append('image', file);
  
  try {
    const response = await fetch('/api/events/upload-image', {
      method: 'POST',
      body: formData
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || '画像のアップロードに失敗しました');
    }
    
    const result = await response.json();
    return result.image_url;
  } catch (error) {
    console.error('画像アップロードエラー:', error);
    throw error;
  }
}

// 決済設定の表示切り替え
function togglePaymentSettings() {
  const paymentFlg = document.getElementById('payment_flg');
  const paymentSettings = document.getElementById('paymentSettings');
  
  if (paymentSettings) {
    paymentSettings.style.display = paymentFlg && paymentFlg.value === '1' ? 'block' : 'none';
  }
}

// 決済方法の手数料設定表示切り替え
function togglePaymentMethodSettings(methodId) {
  const checkbox = document.getElementById(methodId);
  let settingsId = '';
  
  if (methodId === 'payment_credit_card') {
    settingsId = 'creditFeeSettings';
  } else if (methodId === 'payment_bank_transfer') {
    settingsId = 'bankFeeSettings';
  } else if (methodId === 'payment_convenience_store') {
    settingsId = 'convenienceFeeSettings';
  }
  
  const settings = document.getElementById(settingsId);
  if (settings) {
    settings.style.display = checkbox && checkbox.checked ? 'block' : 'none';
  }
}

// フォーム送信処理
async function handleSubmit(e) {
  console.log('========== handleSubmit が呼び出されました ==========');
  e.preventDefault();
  
  try {
    console.log('保存処理を開始します');
    window.Utils.showLoading(true);
    
    const form = document.getElementById('eventForm');
    console.log('フォーム:', form);
    const formData = new FormData(form);
    console.log('フォームデータ取得完了');
    
    // 画像アップロード
    let imageUrl = currentImageUrl;
    const imageFile = formData.get('image');
    if (imageFile && imageFile.size > 0) {
      imageUrl = await uploadImage(imageFile);
    }
    
    // フォームデータを JSON に変換
    const data = {
      name: formData.get('name'),
      name_en: formData.get('name_en') || null,
      detail: formData.get('detail') || '',
      detail_en: formData.get('detail_en') || null,
      location: formData.get('location') || null,
      location_en: formData.get('location_en') || null,
      contact: formData.get('contact'),
      contact_en: formData.get('contact_en') || null,
      remarks: formData.get('remarks') || '',
      remarks_en: formData.get('remarks_en') || null,
      thanks_msg: formData.get('thanks_msg') || '',
      thanks_msg_en: formData.get('thanks_msg_en') || null,
      
      organizer_id: formData.get('organizer_id') ? parseInt(formData.get('organizer_id')) : null,
      client_id: formData.get('client_id') ? parseInt(formData.get('client_id')) : null,
      branch_code: formData.get('branch_code') || null,
      enable_flg: parseInt(formData.get('enable_flg')) || 1,
      
      event_url: formData.get('event_url'),
      category: formData.get('category') || null,
      date_selection_type: formData.get('date_selection_type') || 'button',
      event_type: formData.get('event_type') || 'standalone',
      
      event_start_date: formData.get('event_start_date'),
      event_end_date: formData.get('event_end_date'),
      registration_start_date: formData.get('registration_start_date'),
      registration_end_date: formData.get('registration_end_date'),
      admin_login_start_date: formData.get('admin_login_start_date') || null,
      admin_login_end_date: formData.get('admin_login_end_date') || null,
      
      admin_email: formData.get('admin_email') || null,
      admin_cc_email: formData.get('admin_cc_email') || null,
      sender_name: formData.get('sender_name') || null,
      sender_email: formData.get('sender_email') || null,
      email_signature: formData.get('email_signature') || null,
      email_signature_en: formData.get('email_signature_en') || null,
      
      payment_flg: parseInt(formData.get('payment_flg')) || 0,
      payment_credit_card: document.getElementById('payment_credit_card')?.checked ? 1 : 0,
      payment_bank_transfer: document.getElementById('payment_bank_transfer')?.checked ? 1 : 0,
      payment_convenience_store: document.getElementById('payment_convenience_store')?.checked ? 1 : 0,
      
      bank_name: formData.get('bank_name') || null,
      bank_branch: formData.get('bank_branch') || null,
      bank_account_type: formData.get('bank_account_type') || null,
      bank_account_number: formData.get('bank_account_number') || null,
      bank_account_name: formData.get('bank_account_name') || null,
      bank_transfer_deadline: parseInt(formData.get('bank_transfer_deadline')) || 7,
      
      store_code: formData.get('store_code') || null,
      convenience_payment_deadline: parseInt(formData.get('convenience_payment_deadline')) || 7,
      convenience_stores: Array.from(document.querySelectorAll('input[name="convenience_stores"]:checked')).map(cb => cb.value).join(','),
      
      credit_fee_type: formData.get('credit_fee_type') || 'none',
      credit_fee_percentage: parseFloat(formData.get('credit_fee_percentage')) || 0,
      credit_fee_fixed: parseInt(formData.get('credit_fee_fixed')) || 0,
      bank_fee_type: formData.get('bank_fee_type') || 'none',
      bank_fee_percentage: parseFloat(formData.get('bank_fee_percentage')) || 0,
      bank_fee_fixed: parseInt(formData.get('bank_fee_fixed')) || 0,
      convenience_fee_type: formData.get('convenience_fee_type') || 'none',
      convenience_fee_percentage: parseFloat(formData.get('convenience_fee_percentage')) || 0,
      convenience_fee_fixed: parseInt(formData.get('convenience_fee_fixed')) || 0,
      
      auto_reply_enabled: document.getElementById('auto_reply_enabled')?.checked ? 1 : 0,
      auto_reply_credit_payment: formData.get('auto_reply_credit_payment') || null,
      auto_reply_bank_payment: formData.get('auto_reply_bank_payment') || null,
      auto_reply_convenience_payment: formData.get('auto_reply_convenience_payment') || null,
      auto_reply_credit_cancel: formData.get('auto_reply_credit_cancel') || null,
      auto_reply_bank_cancel: formData.get('auto_reply_bank_cancel') || null,
      auto_reply_convenience_cancel: formData.get('auto_reply_convenience_cancel') || null,
      auto_reply_credit_refund: formData.get('auto_reply_credit_refund') || null,
      auto_reply_bank_deposit: formData.get('auto_reply_bank_deposit') || null,
      auto_reply_bank_refund: formData.get('auto_reply_bank_refund') || null,
      auto_reply_convenience_deposit: formData.get('auto_reply_convenience_deposit') || null,
      auto_reply_convenience_refund: formData.get('auto_reply_convenience_refund') || null,
      auto_reply_credit_payment_en: formData.get('auto_reply_credit_payment_en') || null,
      auto_reply_bank_payment_en: formData.get('auto_reply_bank_payment_en') || null,
      auto_reply_convenience_payment_en: formData.get('auto_reply_convenience_payment_en') || null,
      auto_reply_credit_cancel_en: formData.get('auto_reply_credit_cancel_en') || null,
      auto_reply_bank_cancel_en: formData.get('auto_reply_bank_cancel_en') || null,
      auto_reply_convenience_cancel_en: formData.get('auto_reply_convenience_cancel_en') || null,
      auto_reply_credit_refund_en: formData.get('auto_reply_credit_refund_en') || null,
      auto_reply_bank_deposit_en: formData.get('auto_reply_bank_deposit_en') || null,
      auto_reply_bank_refund_en: formData.get('auto_reply_bank_refund_en') || null,
      auto_reply_convenience_deposit_en: formData.get('auto_reply_convenience_deposit_en') || null,
      auto_reply_convenience_refund_en: formData.get('auto_reply_convenience_refund_en') || null,
      
      vendor_id: formData.get('vendor_id') ? parseInt(formData.get('vendor_id')) : null,
      parent_event_id: formData.get('parent_event_id') ? parseInt(formData.get('parent_event_id')) : null,
      
      // キャンセルポリシー
      cancel_policy: formData.get('cancel_policy') || null,
      cancellation_policy_details: formData.get('cancellation_policy_details') || null,
      cancellation_days_1: formData.get('cancellation_days_1') ? parseInt(formData.get('cancellation_days_1')) : null,
      cancellation_rate_1: formData.get('cancellation_rate_1') ? parseInt(formData.get('cancellation_rate_1')) : null,
      cancellation_days_2: formData.get('cancellation_days_2') ? parseInt(formData.get('cancellation_days_2')) : null,
      cancellation_rate_2: formData.get('cancellation_rate_2') ? parseInt(formData.get('cancellation_rate_2')) : null,
      cancellation_days_3: formData.get('cancellation_days_3') ? parseInt(formData.get('cancellation_days_3')) : null,
      cancellation_rate_3: formData.get('cancellation_rate_3') ? parseInt(formData.get('cancellation_rate_3')) : null,
      
      // 同意設定
      consent: {
        privacy_policy_enabled: document.getElementById('privacy_policy_enabled')?.checked ? 1 : 0,
        privacy_policy_required: 1, // 常に必須
        privacy_policy_title: formData.get('privacy_policy_title') || '個人情報の取り扱いについて',
        privacy_policy_content: formData.get('privacy_policy_content') || '',
        privacy_policy_consent_text: formData.get('privacy_policy_consent_text') || '上記の個人情報の取り扱いに同意します',
        terms_enabled: document.getElementById('terms_enabled')?.checked ? 1 : 0,
        terms_required: 1, // 常に必須
        terms_title: formData.get('terms_title') || '旅行条件について',
        terms_content: formData.get('terms_content') || '',
        terms_consent_text: formData.get('terms_consent_text') || '上記の旅行条件に同意します'
      },
      
      // 参加者情報入力設定
      require_participant_info: document.getElementById('require_participant_info')?.checked ? 1 : 0,
      
      // イベント詳細URL
      event_detail_url: formData.get('event_detail_url') || null,
      
      image_url: imageUrl
    };
    
    console.log('送信データ:', data);
    
    // API呼び出し
    const url = isEditMode ? `/api/events/${eventId}` : '/api/events';
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
      throw new Error(error.error || '登録に失敗しました');
    }
    
    const result = await response.json();
    console.log('登録成功:', result);
    console.log('[handleSubmit] result.event:', result.event);
    console.log('[handleSubmit] selectedStaff:', Array.from(selectedStaff));
    
    window.Utils.showLoading(false);
    alert(isEditMode ? 'イベントを更新しました！' : 'イベントを登録しました！');
    
    // 担当者を保存
    const targetEventId = result.event ? result.event.id : (isEditMode ? eventId : null);
    console.log('[handleSubmit] targetEventId:', targetEventId);
    
    if (targetEventId) {
      console.log('[handleSubmit] 担当者保存を実行します');
      await saveEventStaff(targetEventId);
    } else {
      console.warn('[handleSubmit] イベントIDが取得できないため、担当者保存をスキップします');
    }
    
    window.location.href = '/admin/events';
    
  } catch (error) {
    console.error('送信エラー:', error);
    window.Utils.showLoading(false);
    window.Utils.showError(error.message);
  }
}

/**
 * ============================================================
 * 担当者管理機能
 * ============================================================
 */

let allStaff = []; // 全担当者データ
let selectedStaff = new Set(); // 選択済み担当者ID
let branches = []; // 支店リスト

/**
 * 担当者セレクターの初期化
 */
async function initializeStaffSelector() {
  try {
    // 支店リストを取得
    const branchResponse = await fetch('/api/branches?per_page=1000');
    if (branchResponse.ok) {
      const branchData = await branchResponse.json();
      branches = Array.isArray(branchData) ? branchData : (branchData.branches || branchData.data || []);
      renderBranchFilter();
      console.log('支店データ読み込み:', branches.length + '件');
    }
    
    // 全担当者を取得（支店担当者のみ、有効なアカウント）
    const staffResponse = await fetch('/api/accounts?role=branch&status=active');
    if (staffResponse.ok) {
      allStaff = await staffResponse.json();
      console.log('担当者データ読み込み:', allStaff.length + '名');
    }
    
    // イベントリスナー設定
    const branchFilter = document.getElementById('branchFilter');
    const staffSearch = document.getElementById('staffSearch');
    
    if (branchFilter) {
      branchFilter.addEventListener('change', filterStaffList);
    }
    if (staffSearch) {
      staffSearch.addEventListener('input', filterStaffList);
    }
    
    // 注意: 既存担当者の読み込みは loadEventData() で行われます
    
  } catch (error) {
    console.error('担当者データの読み込みエラー:', error);
  }
}

/**
 * 支店フィルタを描画
 */
function renderBranchFilter() {
  const select = document.getElementById('branchFilter');
  if (!select) return;
  
  select.innerHTML = '<option value="">すべての支店</option>';
  
  branches.forEach(branch => {
    const option = document.createElement('option');
    option.value = branch.id;
    option.textContent = branch.branch_name;
    select.appendChild(option);
  });
}

/**
 * 担当者リストをフィルタリング＆表示
 */
function filterStaffList() {
  const branchFilter = document.getElementById('branchFilter');
  const staffSearch = document.getElementById('staffSearch');
  
  if (!branchFilter || !staffSearch) return;
  
  const branchId = branchFilter.value;
  const searchQuery = staffSearch.value.toLowerCase();
  
  // フィルタリング
  let filtered = allStaff;
  
  // 支店フィルタ
  if (branchId) {
    filtered = filtered.filter(staff => staff.primary_branch_code === branches.find(b => b.id == branchId)?.branch_code);
  }
  
  // 検索フィルタ
  if (searchQuery) {
    filtered = filtered.filter(staff => 
      (staff.person_name && staff.person_name.toLowerCase().includes(searchQuery)) ||
      (staff.login_id && staff.login_id.toLowerCase().includes(searchQuery))
    );
  }
  
  // 描画
  renderStaffList(filtered);
}

/**
 * 担当者リストを描画
 */
function renderStaffList(staffList) {
  const container = document.getElementById('staffList');
  if (!container) return;
  
  if (staffList.length === 0) {
    container.innerHTML = `
      <div style="padding: 1rem; text-align: center; color: #9ca3af;">
        <i class="fas fa-info-circle"></i> 該当する担当者が見つかりません
      </div>
    `;
    return;
  }
  
  container.innerHTML = staffList.map(staff => {
    const isSelected = selectedStaff.has(staff.id);
    const displayName = staff.person_name || staff.login_id;
    return `
      <div class="staff-list-item ${isSelected ? 'selected' : ''}" 
           onclick="toggleStaff(${staff.id}, '${escapeHtml(displayName)}', '${escapeHtml(staff.branch_name || '')}')">
        ${isSelected ? '<i class="fas fa-check-circle staff-check"></i>' : '<i class="far fa-circle staff-check" style="color: #d1d5db;"></i>'}
        <span class="staff-name">${escapeHtml(displayName)}</span>
        <span class="staff-branch">${escapeHtml(staff.branch_name || '')}</span>
      </div>
    `;
  }).join('');
}

/**
 * 担当者の選択/解除をトグル
 */
function toggleStaff(staffId, staffName, branchName) {
  if (selectedStaff.has(staffId)) {
    removeStaff(staffId);
  } else {
    addStaff(staffId, staffName, branchName);
  }
}

/**
 * 担当者を追加
 */
function addStaff(staffId, staffName, branchName) {
  selectedStaff.add(staffId);
  renderSelectedTags();
  filterStaffList(); // リストを更新（チェックマーク表示のため）
}

/**
 * 担当者を削除
 */
function removeStaff(staffId) {
  selectedStaff.delete(staffId);
  renderSelectedTags();
  filterStaffList();
}

/**
 * 選択済みタグを描画
 */
function renderSelectedTags() {
  const container = document.getElementById('selectedStaffTags');
  const countSpan = document.getElementById('selectedCount');
  
  if (!container || !countSpan) return;
  
  countSpan.textContent = selectedStaff.size;
  
  if (selectedStaff.size === 0) {
    container.innerHTML = '<span style="color: #9ca3af; font-size: 0.875rem;">担当者が選択されていません</span>';
    updateHiddenInputs();
    return;
  }
  
  // 選択済み担当者のデータを取得
  const selectedData = Array.from(selectedStaff).map(id => 
    allStaff.find(staff => staff.id === id)
  ).filter(Boolean);
  
  container.innerHTML = selectedData.map(staff => {
    const displayName = staff.person_name || staff.login_id;
    return `
      <div class="staff-tag">
        <span>${escapeHtml(displayName)}（${escapeHtml(staff.branch_name || '')}）</span>
        <span class="staff-tag-remove" onclick="removeStaff(${staff.id})">×</span>
      </div>
    `;
  }).join('');
  
  updateHiddenInputs();
}

/**
 * Hidden inputsを更新（フォーム送信用）
 */
function updateHiddenInputs() {
  const container = document.getElementById('hiddenStaffInputs');
  if (!container) return;
  
  container.innerHTML = Array.from(selectedStaff).map(id => 
    `<input type="hidden" name="assigned_staff[]" value="${id}">`
  ).join('');
}

/**
 * 既存データを読み込み（編集モード）
 */
async function loadExistingStaff(eventId) {
  try {
    console.log('[loadExistingStaff] イベントID:', eventId, 'で担当者を取得します');
    const response = await fetch(`/api/events/${eventId}/staff`);
    if (response.ok) {
      const data = await response.json();
      console.log('[loadExistingStaff] APIレスポンス:', data);
      data.staff.forEach(staff => {
        selectedStaff.add(staff.account_id);
      });
      console.log('[loadExistingStaff] selectedStaff:', Array.from(selectedStaff));
      renderSelectedTags();
      console.log('既存担当者読み込み:', data.staff.length + '名');
    } else {
      console.error('[loadExistingStaff] APIエラー:', response.status, response.statusText);
    }
  } catch (error) {
    console.error('担当者データの読み込みエラー:', error);
  }
}

/**
 * イベント担当者を保存
 */
async function saveEventStaff(eventId) {
  try {
    const assignedStaff = Array.from(selectedStaff);
    
    const response = await fetch(`/api/events/${eventId}/staff`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ assigned_staff: assignedStaff })
    });
    
    if (!response.ok) {
      throw new Error('担当者の保存に失敗しました');
    }
    
    console.log('担当者保存成功:', assignedStaff.length + '名');
  } catch (error) {
    console.error('担当者保存エラー:', error);
  }
}

/**
 * HTMLエスケープ
 */
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
