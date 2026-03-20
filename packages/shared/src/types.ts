// Cloudflare D1 Database Bindings
export type Bindings = {
  DB: D1Database
  KV: KVNamespace
  R2: R2Bucket
  BOOKING_FILES: R2Bucket
  CLOUDCONVERT_API_KEY: string
  BASIC_AUTH_USER?: string
  BASIC_AUTH_PASS?: string
  GMO_SHOP_ID?: string
  GMO_SHOP_PASS?: string
  GMO_CONFIG_ID?: string
  GMO_API_URL?: string
}

// Event types
export type Event = {
  id: number
  name: string
  detail?: string
  contact: string
  remarks?: string
  question?: string
  postage: number
  thanks_msg?: string
  note?: string
  client_id: number
  company_flg: number
  enable_flg: number
  payment_flg: number
  payment_cd?: string
  created_at: string
  modified_at: string
}

// Product types
export type Product = {
  id: number
  client_id: number
  event_id: number
  name: string
  sales_start: string
  sales_end: string
  closing_trade: number
  product_category_id?: number
  description?: string
  remarks?: string
  fee_include?: string
  fee_exclude?: string
  cancel_policy?: string
  purchase_limit?: number
  deposit_address?: string
  note?: string
  enable_flg: number
  created_at: string
  modified_at: string
}

export type ProductPrice = {
  id: number
  product_id: number
  price: number
  category_name?: string
  price_band: string // A-Z（価格帯記号）
  price_name?: string // 名称（大人、子供、幼児、シニア、80歳以上など）
  slot_number: number // 同一価格帯内での順番（1-5）
  display_order: number // 表示順
  created_at: string
  modified_at: string
}

export type ProductStock = {
  id: number
  product_id: number
  date: string
  stock: number
  booked: number
  created_at: string
  modified_at: string
}

// Option types
export type Option = {
  id: number
  event_id: number
  name: string
  description?: string
  remarks?: string
  option_category_id: number
  cancel_policy?: string
  note?: string
  enable_flg: number
  created_at: string
  modified_at: string
}

export type OptionPrice = {
  id: number
  option_id: number
  price: number
  category_name?: string
  created_at: string
  modified_at: string
}

// Customer types
export type Customer = {
  id: number
  family_name?: string
  first_name?: string
  family_kana?: string
  first_kana?: string
  sex?: number
  birth?: string
  mobile?: string
  tel?: string
  fax?: string
  email?: string
  zip?: string
  pref_id?: number
  city?: string
  addr?: string
  bldg?: string
  payment?: string
  answer?: string
  remark?: string
  mailme_flg: number
  contact?: string
  company_name?: string
  department_name?: string
  free1?: string
  free2?: string
  free3?: string
  free4?: string
  free5?: string
  free6?: string
  agent_number?: string
  enable_flg: number
  payment_select: number
  payment_status: number
  uniqid?: string
  created_at: string
  modified_at: string
  canceled_at?: string
}

// Booking types
export type ProductBooking = {
  id: number
  customer_id: number
  product_id: number
  product_stock_id?: number
  price: number
  quantity: number
  enable_flg: number
  created_at: string
  modified_at: string
  canceled_at?: string
}

export type OptionBooking = {
  id: number
  customer_id: number
  option_id: number
  option_stock_id?: number
  price: number
  quantity: number
  enable_flg: number
  created_at: string
  modified_at: string
  canceled_at?: string
}

// Email Template types
export type EmailTemplate = {
  id: number
  template_name: string
  description?: string
  from_email: string
  bcc_email?: string
  subject_template: string
  body_template: string
  is_active: number
  created_at: string
  modified_at: string
}

// Booking Email types
export type BookingEmail = {
  id: number
  booking_number: string
  from_email: string
  to_email: string
  bcc_email?: string
  subject: string
  body: string
  scheduled_send_at: string
  send_status: 'pending' | 'sent' | 'failed'
  sent_at?: string
  error_message?: string
  template_id?: number
  created_at: string
  modified_at: string
}

// Account types
export type Account = {
  id: number
  login_id: string
  person_name: string
  email: string
  role: 'system_admin' | 'admin' | 'branch'
  client_id: number
  enable_flg: number
  primary_branch_code?: string
  accessible_branches?: string
}
