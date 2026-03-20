/**
 * Home Page Script
 * トップページの動的コンテンツ
 */

import { eventsAPI } from '../modules/api.js';
import { createEventCard } from '../modules/components.js';
import { showLoading, showError } from '../modules/utils.js';

/**
 * 人気のイベントを読み込み
 */
async function loadPopularEvents() {
  const container = document.getElementById('popular-events');
  if (!container) return;
  
  showLoading(true, container);
  
  try {
    const response = await eventsAPI.getAll({ per_page: 6 });
    const events = response.events || response.data || [];
    
    showLoading(false, container);
    
    if (events.length === 0) {
      container.innerHTML = '<p class="text-center">現在公開中のイベントはありません。</p>';
      return;
    }
    
    // イベントカードを生成
    events.forEach(event => {
      const card = createEventCard(event);
      container.appendChild(card);
    });
    
  } catch (error) {
    showLoading(false, container);
    showError('イベントの読み込みに失敗しました。', container);
    console.error('Failed to load events:', error);
  }
}

/**
 * モバイルメニューの制御
 */
function initMobileMenu() {
  const navToggle = document.querySelector('.nav-toggle');
  const navMenu = document.querySelector('.nav-menu');
  
  if (!navToggle || !navMenu) return;
  
  navToggle.addEventListener('click', () => {
    const isExpanded = navToggle.getAttribute('aria-expanded') === 'true';
    navToggle.setAttribute('aria-expanded', !isExpanded);
    navMenu.classList.toggle('show');
  });
  
  // メニュー外クリックで閉じる
  document.addEventListener('click', (e) => {
    if (!navToggle.contains(e.target) && !navMenu.contains(e.target)) {
      navToggle.setAttribute('aria-expanded', 'false');
      navMenu.classList.remove('show');
    }
  });
}

/**
 * スムーズスクロール
 */
function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
}

/**
 * 初期化
 */
document.addEventListener('DOMContentLoaded', () => {
  loadPopularEvents();
  initMobileMenu();
  initSmoothScroll();
});
