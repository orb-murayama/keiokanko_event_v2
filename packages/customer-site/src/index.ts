import { Hono } from 'hono'
import { serveStatic } from 'hono/cloudflare-workers'
import type { Bindings } from '@keiokanko/shared'

// 静的HTMLのインポート
import indexHtml from '../public/index.html?raw'
import productDetailHtml from '../public/product-detail.html?raw'
import authEmailHtml from '../public/auth-email.html?raw'
import participantInfoHtml from '../public/participant-info.html?raw'
import paymentMethodHtml from '../public/payment-method.html?raw'
import bookingCompleteHtml from '../public/booking-complete.html?raw'
import gmoPaymentCreditHtml from '../public/gmo-payment-credit.html?raw'
import gmoPaymentConvenienceHtml from '../public/gmo-payment-convenience.html?raw'
import paymentCallbackHtml from '../public/payment-callback.html?raw'

const app = new Hono<{ Bindings: Bindings }>()

// 静的ファイルの配信
app.use('/static/*', serveStatic({ root: './' }))
app.use('/css/*', serveStatic({ root: './public' }))
app.use('/js/*', serveStatic({ root: './public' }))
app.use('/images/*', serveStatic({ root: './public' }))

// ルートページ - イベント一覧にリダイレクト
app.get('/', (c) => {
  return c.redirect('/product-list')
})

// イベント/商品一覧ページ
app.get('/index.html', (c) => {
  return c.html(indexHtml)
})

app.get('/product-list', (c) => {
  return c.html(indexHtml)
})

// 商品詳細ページ
app.get('/product-detail.html', (c) => {
  return c.html(productDetailHtml)
})

// 認証ページ
app.get('/auth-email.html', (c) => {
  return c.html(authEmailHtml)
})

// 参加者情報入力ページ
app.get('/participant-info.html', (c) => {
  return c.html(participantInfoHtml)
})

// 支払い方法選択ページ
app.get('/payment-method.html', (c) => {
  return c.html(paymentMethodHtml)
})

// 予約完了ページ
app.get('/booking-complete.html', (c) => {
  return c.html(bookingCompleteHtml)
})

// GMO決済ページ
app.get('/gmo-payment-credit.html', (c) => {
  return c.html(gmoPaymentCreditHtml)
})

app.get('/gmo-payment-convenience.html', (c) => {
  return c.html(gmoPaymentConvenienceHtml)
})

// 決済コールバック
app.get('/payment-callback.html', (c) => {
  return c.html(paymentCallbackHtml)
})

// ヘルスチェック
app.get('/health', (c) => {
  return c.json({ status: 'ok', service: 'customer-site' })
})

export default app
