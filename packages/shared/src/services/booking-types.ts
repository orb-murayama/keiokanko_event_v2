/**
 * 予約サービス - 型定義
 */

export interface CreateBookingRequest {
  // イベント情報
  event_id: number
  event_name: string
  participation_date: string

  // 予約者情報
  booker: {
    email: string
    family_name: string
    first_name: string
    family_kana: string
    first_kana: string
    tel: string
    mobile?: string
    zip?: string
    addr?: string
  }

  // 参加者情報
  participants: Array<{
    item_type: string
    item_id: number
    stock_id: number
    category: string
    family_name: string
    first_name: string
    family_kana: string
    first_kana: string
    email?: string
    tel?: string
    age?: string
    sex?: string
    birth_date?: string
    addr?: string
    custom_fields?: Record<string, any>
  }>

  // 商品情報
  items: Array<{
    type?: 'product' | 'option' | 'fee' // 'fee'を追加: 手数料アイテム用
    id: number
    name: string
    stock_id: number | null
    stock_type?: 'individual' | 'shared' // オプショナル（デフォルト: 'individual'）
    category: string | null
    quantity: number
    unit_price: number
    product_custom_fields?: Record<string, any>
  }>

  // 決済情報
  total_amount: number           // 商品代金の合計（手数料抜き）
  final_amount?: number          // 最終支払額（手数料込み）
  payment_fee?: number           // 決済手数料
  payment_method: 'credit_card' | 'convenience' | 'bank_transfer'
  is_new_member: boolean

  // GMO情報
  gmo_order_id?: string
  gmo_details?: {
    // 古い形式
    credit?: {
      AccessID: string
      AccessPass: string
      OrderID: string
      Status: string
    }
    // 新しい形式
    transactionresult?: {
      AccessID: string
      AccessPass: string
      OrderID: string
      Result: string
      Processdate: string
      ErrCode: string | null
      ErrInfo: string | null
      Paymethod: string
    }
  }

  // カード情報（下4桁のみ）
  card_info?: {
    last4: string
    exp_month: string
    exp_year: string
    holder_name: string
  }
}

export interface CreateBookingResponse {
  success: boolean
  booking_id: number
  booking_number: string
  payment_number: string
  message: string
}

export interface StockRow {
  id: number
  stock: number
  booked: number
}

/**
 * 予約エラー
 */
export class BookingError extends Error {
  constructor(
    public code: string,
    message: string
  ) {
    super(message)
    this.name = 'BookingError'
  }
}
