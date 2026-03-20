/**
 * 共有在庫プール新規登録ページ
 */

// ページ初期化
document.addEventListener('DOMContentLoaded', () => {
  console.log('共有在庫プール新規登録ページを初期化');
  
  // フォーム送信イベント
  document.getElementById('newPoolForm').addEventListener('submit', handleSubmit);
  
  console.log('初期化完了');
});

/**
 * フォーム送信処理
 */
async function handleSubmit(e) {
  e.preventDefault();
  
  const poolName = document.getElementById('poolName').value.trim();
  const poolCode = document.getElementById('poolCode').value.trim() || null;
  const description = document.getElementById('description').value.trim() || null;
  const dateStart = document.getElementById('dateStart').value;
  const dateEnd = document.getElementById('dateEnd').value || dateStart;
  const timeSlotLabel = document.getElementById('timeSlotLabel').value.trim() || null;
  const totalStock = parseInt(document.getElementById('totalStock').value);
  
  if (!poolName || !dateStart || isNaN(totalStock) || totalStock < 0) {
    window.Utils.showError('必須項目を正しく入力してください');
    return;
  }
  
  // 日付範囲を生成
  const dates = getDateRange(dateStart, dateEnd);
  
  const baseData = {
    pool_name: poolName,
    pool_code: poolCode,
    description: description,
    time_slot_label: timeSlotLabel,
    time_slot_start: null,
    time_slot_end: null,
    total_stock: totalStock,
    enable_flg: 1
  };
  
  try {
    window.Utils.showLoading(true);
    
    let successCount = 0;
    for (const date of dates) {
      await window.API.post('/api/shared-stock-pools', {
        ...baseData,
        date: date
      });
      successCount++;
    }
    
    window.Utils.showSuccess(`プールを登録しました（${successCount}件の在庫を作成）`);
    
    // 2秒後に一覧ページへ遷移
    setTimeout(() => {
      window.location.href = '/shared-stock-pools-list.html';
    }, 2000);
  } catch (error) {
    console.error('登録エラー:', error);
    window.Utils.showError('プールの登録に失敗しました: ' + (error.message || ''));
  } finally {
    window.Utils.showLoading(false);
  }
}

/**
 * 日付範囲を生成
 */
function getDateRange(startDate, endDate) {
  const dates = [];
  const currentDate = new Date(startDate);
  const end = new Date(endDate);
  
  while (currentDate <= end) {
    dates.push(new Date(currentDate).toISOString().split('T')[0]);
    currentDate.setDate(currentDate.getDate() + 1);
  }
  
  return dates;
}
