/**
 * API Client Module
 * すべてのAPIリクエストを一元管理
 */

const API_BASE = '/api';
const API_V1_BASE = '/api/v1';

/**
 * APIリクエストの基本関数
 * @param {string} url - リクエストURL
 * @param {object} options - fetchオプション
 * @returns {Promise<object>} レスポンスデータ
 */
async function request(url, options = {}) {
  try {
    const response = await fetch(url, {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    });

    if (!response.ok) {
      throw new Error(`HTTP Error: ${response.status} ${response.statusText}`);
    }

    return await response.json();
  } catch (error) {
    console.error('API Request Error:', error);
    throw error;
  }
}

/**
 * GETリクエスト
 */
async function get(url, params = {}) {
  const queryString = new URLSearchParams(params).toString();
  const fullUrl = queryString ? `${url}?${queryString}` : url;
  return request(fullUrl, { method: 'GET' });
}

/**
 * POSTリクエスト
 */
async function post(url, data = {}) {
  return request(url, {
    method: 'POST',
    body: JSON.stringify(data)
  });
}

/**
 * PUTリクエスト
 */
async function put(url, data = {}) {
  return request(url, {
    method: 'PUT',
    body: JSON.stringify(data)
  });
}

/**
 * DELETEリクエスト
 */
async function del(url) {
  return request(url, { method: 'DELETE' });
}

// ========================================
// Events API
// ========================================

const eventsAPI = {
  /**
   * イベント一覧を取得
   */
  async getAll(params = {}) {
    return get(`${API_V1_BASE}/events`, params);
  },

  /**
   * イベント詳細を取得
   */
  async getById(id) {
    return get(`${API_BASE}/events/${id}`);
  },

  /**
   * イベントの商品一覧を取得
   */
  async getProducts(eventId) {
    return get(`${API_BASE}/events/${eventId}/products`);
  },

  /**
   * イベントの利用可能日を取得
   */
  async getAvailableDates(eventId) {
    return get(`${API_BASE}/events/${eventId}/available-dates`);
  },

  /**
   * 日付別商品を取得
   */
  async getProductsByDate(eventId, date) {
    return get(`${API_BASE}/events/${eventId}/products-by-date`, { date });
  },

  /**
   * イベント作成
   */
  async create(data) {
    return post(`${API_V1_BASE}/events`, data);
  },

  /**
   * イベント更新
   */
  async update(id, data) {
    return put(`${API_V1_BASE}/events/${id}`, data);
  },

  /**
   * イベント削除
   */
  async delete(id) {
    return del(`${API_BASE}/events/${id}`);
  }
};

// ========================================
// Products API
// ========================================

const productsAPI = {
  /**
   * 商品詳細を取得
   */
  async getById(id) {
    return get(`${API_BASE}/products/${id}`);
  },

  /**
   * 商品の在庫を取得
   */
  async getStocks(productId, params = {}) {
    return get(`${API_BASE}/products/${productId}/stocks`, params);
  },

  /**
   * 商品作成
   */
  async create(data) {
    return post(`${API_V1_BASE}/products`, data);
  },

  /**
   * 商品更新
   */
  async update(id, data) {
    return put(`${API_V1_BASE}/products/${id}`, data);
  },

  /**
   * 商品削除
   */
  async delete(id) {
    return del(`${API_V1_BASE}/products/${id}`);
  }
};

// ========================================
// Bookings API
// ========================================

const bookingsAPI = {
  /**
   * 予約一覧を取得
   */
  async getAll(params = {}) {
    return get(`${API_V1_BASE}/bookings`, params);
  },

  /**
   * 予約詳細を取得
   */
  async getById(id) {
    return get(`${API_V1_BASE}/bookings/${id}`);
  },

  /**
   * 予約作成
   */
  async create(data) {
    return post(`${API_BASE}/bookings`, data);
  },

  /**
   * メールアドレスで予約を検索
   */
  async searchByEmail(email) {
    return get(`${API_BASE}/bookings/search`, { email });
  }
};

// ========================================
// Categories API
// ========================================

const categoriesAPI = {
  /**
   * カテゴリー一覧を取得
   */
  async getAll() {
    return get(`${API_V1_BASE}/categories`);
  }
};

// ========================================
// Organizers API
// ========================================

const organizersAPI = {
  /**
   * 主催者一覧を取得
   */
  async getAll() {
    return get(`${API_V1_BASE}/organizers`);
  }
};

// ========================================
// Clients API
// ========================================

const clientsAPI = {
  /**
   * クライアント一覧を取得
   */
  async getAll() {
    return get(`${API_BASE}/clients`);
  }
};

// ========================================
// Branches API
// ========================================

const branchesAPI = {
  /**
   * 支店一覧を取得
   */
  async getAll() {
    return get(`${API_BASE}/branches`);
  }
};

// グローバル変数として公開
if (typeof window !== 'undefined') {
  window.API = {
    request,
    get,
    post,
    put,
    del,
    eventsAPI,
    productsAPI,
    bookingsAPI,
    categoriesAPI,
    organizersAPI,
    clientsAPI,
    branchesAPI
  };
}
