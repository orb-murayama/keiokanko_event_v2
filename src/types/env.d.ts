// 環境変数の型定義
declare module 'cloudflare:test' {
  interface ProvidedEnv extends Env {}
}

export interface Env {
  // データベース
  DB: D1Database

  // ストレージ
  R2: R2Bucket
  BOOKING_FILES: R2Bucket

  // SMTP設定
  SMTP_HOST: string
  SMTP_PORT: string
  SMTP_USER: string
  SMTP_PASS: string
  DEFAULT_FROM_EMAIL: string

  // その他
  APP_MODE: string
}
