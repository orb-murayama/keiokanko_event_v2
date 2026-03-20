/**
 * UI Components Module
 * 再利用可能なUIコンポーネント
 */

import { formatCurrency, formatDate, getJapaneseWeekday } from './utils.js';

/**
 * イベントカードコンポーネント
 * @param {object} event - イベントデータ
 * @returns {HTMLElement} イベントカード
 */
export function createEventCard(event) {
  const card = document.createElement('article');
  card.className = 'card event-card';
  
  // 画像
  const imageUrl = event.image_url || '/static/no-image.svg';
  
  // 日付範囲
  const dateRange = event.event_start_date === event.event_end_date
    ? formatDate(event.event_start_date, 'YYYY年MM月DD日')
    : `${formatDate(event.event_start_date, 'YYYY年MM月DD日')} 〜 ${formatDate(event.event_end_date, 'YYYY年MM月DD日')}`;
  
  card.innerHTML = `
    <a href="/events/${event.id}" class="event-card-link">
      <div class="event-card-image">
        <img src="${imageUrl}" alt="${event.name}" loading="lazy">
      </div>
      <div class="event-card-content">
        <h3 class="event-card-title">${event.name}</h3>
        <div class="event-card-meta">
          <span class="event-card-date">
            <i class="far fa-calendar-alt"></i>
            ${dateRange}
          </span>
          ${event.location ? `
            <span class="event-card-location">
              <i class="fas fa-map-marker-alt"></i>
              ${event.location}
            </span>
          ` : ''}
        </div>
        ${event.detail ? `
          <p class="event-card-description">${truncateText(event.detail, 100)}</p>
        ` : ''}
      </div>
    </a>
  `;
  
  return card;
}

/**
 * 商品カードコンポーネント
 * @param {object} product - 商品データ
 * @returns {HTMLElement} 商品カード
 */
export function createProductCard(product) {
  const card = document.createElement('article');
  card.className = 'card product-card';
  
  const imageUrl = product.image_url || '/static/no-image.svg';
  
  // 最安値を取得
  const minPrice = product.prices && product.prices.length > 0
    ? Math.min(...product.prices.map(p => p.price))
    : null;
  
  card.innerHTML = `
    <div class="product-card-image">
      <img src="${imageUrl}" alt="${product.name}" loading="lazy">
    </div>
    <div class="product-card-content">
      <h4 class="product-card-title">${product.name}</h4>
      ${product.description ? `
        <p class="product-card-description">${truncateText(product.description, 80)}</p>
      ` : ''}
      ${minPrice ? `
        <p class="product-card-price">
          ${formatCurrency(minPrice)}〜
        </p>
      ` : ''}
      <button class="btn btn-primary product-select-btn" data-product-id="${product.id}">
        選択する
      </button>
    </div>
  `;
  
  return card;
}

/**
 * オプションカードコンポーネント
 * @param {object} option - オプションデータ
 * @returns {HTMLElement} オプションカード
 */
export function createOptionCard(option) {
  const card = document.createElement('div');
  card.className = 'card option-card';
  
  const imageUrl = option.image_url || '/static/no-image.svg';
  
  // 最安値を取得
  const minPrice = option.prices && option.prices.length > 0
    ? Math.min(...option.prices.map(p => p.price))
    : null;
  
  card.innerHTML = `
    <div class="option-card-checkbox">
      <input type="checkbox" id="option-${option.id}" name="option" value="${option.id}">
    </div>
    <label for="option-${option.id}" class="option-card-label">
      <div class="option-card-image">
        <img src="${imageUrl}" alt="${option.name}" loading="lazy">
      </div>
      <div class="option-card-content">
        <h5 class="option-card-title">${option.name}</h5>
        ${option.description ? `
          <p class="option-card-description">${truncateText(option.description, 60)}</p>
        ` : ''}
        ${minPrice ? `
          <p class="option-card-price">
            ${formatCurrency(minPrice)}
          </p>
        ` : ''}
      </div>
    </label>
  `;
  
  return card;
}

/**
 * ページネーションコンポーネント
 * @param {number} currentPage - 現在のページ
 * @param {number} totalPages - 総ページ数
 * @param {Function} onPageChange - ページ変更時のコールバック
 * @returns {HTMLElement} ページネーション
 */
export function createPagination(currentPage, totalPages, onPageChange) {
  const pagination = document.createElement('nav');
  pagination.className = 'pagination';
  pagination.setAttribute('aria-label', 'ページネーション');
  
  const ul = document.createElement('ul');
  ul.className = 'pagination-list';
  
  // 前へボタン
  const prevLi = document.createElement('li');
  const prevBtn = document.createElement('button');
  prevBtn.className = 'pagination-btn';
  prevBtn.textContent = '前へ';
  prevBtn.disabled = currentPage === 1;
  prevBtn.addEventListener('click', () => onPageChange(currentPage - 1));
  prevLi.appendChild(prevBtn);
  ul.appendChild(prevLi);
  
  // ページ番号
  const startPage = Math.max(1, currentPage - 2);
  const endPage = Math.min(totalPages, currentPage + 2);
  
  for (let i = startPage; i <= endPage; i++) {
    const li = document.createElement('li');
    const btn = document.createElement('button');
    btn.className = `pagination-btn ${i === currentPage ? 'active' : ''}`;
    btn.textContent = i;
    btn.addEventListener('click', () => onPageChange(i));
    li.appendChild(btn);
    ul.appendChild(li);
  }
  
  // 次へボタン
  const nextLi = document.createElement('li');
  const nextBtn = document.createElement('button');
  nextBtn.className = 'pagination-btn';
  nextBtn.textContent = '次へ';
  nextBtn.disabled = currentPage === totalPages;
  nextBtn.addEventListener('click', () => onPageChange(currentPage + 1));
  nextLi.appendChild(nextBtn);
  ul.appendChild(nextLi);
  
  pagination.appendChild(ul);
  return pagination;
}

/**
 * モーダルダイアログコンポーネント
 * @param {string} title - タイトル
 * @param {string|HTMLElement} content - コンテンツ
 * @param {object} options - オプション
 * @returns {HTMLElement} モーダル
 */
export function createModal(title, content, options = {}) {
  const modal = document.createElement('div');
  modal.className = 'modal';
  modal.setAttribute('role', 'dialog');
  modal.setAttribute('aria-modal', 'true');
  modal.setAttribute('aria-labelledby', 'modal-title');
  
  const modalContent = document.createElement('div');
  modalContent.className = 'modal-content';
  
  const modalHeader = document.createElement('div');
  modalHeader.className = 'modal-header';
  
  const modalTitle = document.createElement('h3');
  modalTitle.id = 'modal-title';
  modalTitle.textContent = title;
  
  const closeBtn = document.createElement('button');
  closeBtn.className = 'modal-close';
  closeBtn.innerHTML = '&times;';
  closeBtn.setAttribute('aria-label', '閉じる');
  closeBtn.addEventListener('click', () => closeModal(modal));
  
  modalHeader.appendChild(modalTitle);
  modalHeader.appendChild(closeBtn);
  
  const modalBody = document.createElement('div');
  modalBody.className = 'modal-body';
  
  if (typeof content === 'string') {
    modalBody.innerHTML = content;
  } else {
    modalBody.appendChild(content);
  }
  
  modalContent.appendChild(modalHeader);
  modalContent.appendChild(modalBody);
  
  if (options.footer) {
    const modalFooter = document.createElement('div');
    modalFooter.className = 'modal-footer';
    modalFooter.appendChild(options.footer);
    modalContent.appendChild(modalFooter);
  }
  
  modal.appendChild(modalContent);
  
  // 背景クリックで閉じる
  modal.addEventListener('click', (e) => {
    if (e.target === modal) {
      closeModal(modal);
    }
  });
  
  // ESCキーで閉じる
  const handleEsc = (e) => {
    if (e.key === 'Escape') {
      closeModal(modal);
      document.removeEventListener('keydown', handleEsc);
    }
  };
  document.addEventListener('keydown', handleEsc);
  
  return modal;
}

/**
 * モーダルを開く
 * @param {HTMLElement} modal - モーダル要素
 */
export function openModal(modal) {
  document.body.appendChild(modal);
  setTimeout(() => modal.classList.add('show'), 10);
  document.body.style.overflow = 'hidden';
}

/**
 * モーダルを閉じる
 * @param {HTMLElement} modal - モーダル要素
 */
export function closeModal(modal) {
  modal.classList.remove('show');
  setTimeout(() => {
    modal.remove();
    document.body.style.overflow = '';
  }, 300);
}

/**
 * 確認ダイアログ
 * @param {string} message - メッセージ
 * @param {Function} onConfirm - 確認時のコールバック
 * @param {Function} onCancel - キャンセル時のコールバック
 */
export function confirmDialog(message, onConfirm, onCancel = null) {
  const footer = document.createElement('div');
  footer.className = 'modal-footer-actions';
  
  const confirmBtn = document.createElement('button');
  confirmBtn.className = 'btn btn-primary';
  confirmBtn.textContent = '確認';
  confirmBtn.addEventListener('click', () => {
    if (onConfirm) onConfirm();
    closeModal(modal);
  });
  
  const cancelBtn = document.createElement('button');
  cancelBtn.className = 'btn btn-secondary';
  cancelBtn.textContent = 'キャンセル';
  cancelBtn.addEventListener('click', () => {
    if (onCancel) onCancel();
    closeModal(modal);
  });
  
  footer.appendChild(confirmBtn);
  footer.appendChild(cancelBtn);
  
  const modal = createModal('確認', `<p>${message}</p>`, { footer });
  openModal(modal);
}

/**
 * テキストを切り詰める
 * @param {string} text - テキスト
 * @param {number} maxLength - 最大文字数
 * @returns {string} 切り詰められたテキスト
 */
function truncateText(text, maxLength) {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}

export default {
  createEventCard,
  createProductCard,
  createOptionCard,
  createPagination,
  createModal,
  openModal,
  closeModal,
  confirmDialog
};
