import { Hono } from 'hono'
import { serveStatic } from 'hono/cloudflare-workers'
import { basicAuth } from 'hono/basic-auth'
import type { Bindings } from '@keiokanko/shared'
import { requireAuth, requireRole, requireEventAccess } from '@keiokanko/shared'

// 静的HTMLのインポート
import adminLoginHtml from '../public/admin-login.html?raw'
import adminDashboardHtml from '../public/admin-dashboard.html?raw'
import accountsListHtml from '../public/accounts-list.html?raw'
import accountsEditHtml from '../public/accounts-edit.html?raw'
import membersListHtml from '../public/members-list.html?raw'
import membersEditHtml from '../public/members-edit.html?raw'
import clientsListHtml from '../public/clients-list.html?raw'
import clientsEditHtml from '../public/clients-edit.html?raw'
import vendorsListHtml from '../public/vendors-list.html?raw'
import vendorsEditHtml from '../public/vendors-edit.html?raw'
import organizersListHtml from '../public/organizers-list.html?raw'
import organizersEditHtml from '../public/organizers-edit.html?raw'
import eventsListHtml from '../public/events-list.html?raw'
import eventsFormHtml from '../public/events-form.html?raw'
import productsListHtml from '../public/products-list.html?raw'
import productsEditHtml from '../public/products-edit.html?raw'
import productsStocksHtml from '../public/products-stocks.html?raw'
import productsSharedStocksHtml from '../public/products-shared-stocks.html?raw'
import productsFormFieldsHtml from '../public/products-form-fields.html?raw'
import optionsListHtml from '../public/options-list.html?raw'
import optionsEditHtml from '../public/options-edit.html?raw'
import optionsStocksHtml from '../public/options-stocks.html?raw'
import sharedStockPoolsListHtml from '../public/shared-stock-pools-list.html?raw'
import sharedStockPoolsManageHtml from '../public/shared-stock-pools-manage.html?raw'
import sharedStockPoolsNewHtml from '../public/shared-stock-pools-new.html?raw'
import bookingsListHtml from '../public/bookings-list.html?raw'
import bookingsDetailHtml from '../public/bookings-detail.html?raw'
import bookingsEditHtml from '../public/bookings-edit.html?raw'
import adminBulkMessagesHtml from '../public/admin-bulk-messages.html?raw'
import adminBulkDocumentsHtml from '../public/admin-bulk-documents.html?raw'
import adminBulkEmailsHtml from '../public/admin-bulk-emails.html?raw'
import adminProductsHtml from '../public/admin-products.html?raw'
import emailPlaceholderHelpHtml from '../public/email-placeholder-help.html?raw'
import documentPlaceholderHelpHtml from '../public/document-placeholder-help.html?raw'
import adminHelpHtml from '../public/admin-help.html?raw'

const app = new Hono<{ Bindings: Bindings }>()

// 静的ファイルの配信
app.use('/static/*', serveStatic({ root: './' }))
app.use('/css/*', serveStatic({ root: './public' }))
app.use('/js/*', serveStatic({ root: './public' }))

// Basic認証（環境変数から取得）
const routeAccessControl = (type: 'admin' | 'customer') => {
  return async (c: any, next: any) => {
    if (type === 'admin') {
      const authHeader = c.req.header('Authorization')
      if (!authHeader) {
        c.header('WWW-Authenticate', 'Basic realm="Admin Area"')
        return c.text('Unauthorized', 401)
      }
      
      const credentials = authHeader.replace('Basic ', '')
      const decoded = atob(credentials)
      const [username, password] = decoded.split(':')
      
      const validUsername = c.env.BASIC_AUTH_USERNAME || 'admin'
      const validPassword = c.env.BASIC_AUTH_PASSWORD || 'password'
      
      if (username !== validUsername || password !== validPassword) {
        return c.text('Forbidden', 403)
      }
    }
    await next()
  }
}

// ルートページ - ダッシュボードにリダイレクト
app.get('/', (c) => {
  return c.redirect('/admin-dashboard')
})

// 管理者ログインページ
app.get('/admin-login', (c) => {
  return c.html(adminLoginHtml)
})

app.get('/admin-login.html', (c) => {
  return c.html(adminLoginHtml)
})

// 管理者ダッシュボード
app.get('/admin-dashboard', routeAccessControl('admin'), (c) => {
  return c.html(adminDashboardHtml)
})

app.get('/admin-dashboard.html', routeAccessControl('admin'), (c) => {
  return c.html(adminDashboardHtml)
})

// アカウント管理
app.get('/accounts-list.html', routeAccessControl('admin'), (c) => {
  return c.html(accountsListHtml)
})

app.get('/accounts-edit.html', routeAccessControl('admin'), (c) => {
  return c.html(accountsEditHtml)
})

// メンバー管理
app.get('/members-list.html', routeAccessControl('admin'), (c) => {
  return c.html(membersListHtml)
})

app.get('/members-edit.html', routeAccessControl('admin'), (c) => {
  return c.html(membersEditHtml)
})

// クライアント管理
app.get('/clients-list.html', routeAccessControl('admin'), (c) => {
  return c.html(clientsListHtml)
})

app.get('/clients-edit.html', routeAccessControl('admin'), (c) => {
  return c.html(clientsEditHtml)
})

// ベンダー管理
app.get('/vendors-list.html', routeAccessControl('admin'), (c) => {
  return c.html(vendorsListHtml)
})

app.get('/vendors-edit.html', routeAccessControl('admin'), (c) => {
  return c.html(vendorsEditHtml)
})

// オーガナイザー管理
app.get('/organizers-list.html', routeAccessControl('admin'), (c) => {
  return c.html(organizersListHtml)
})

app.get('/organizers-edit.html', routeAccessControl('admin'), (c) => {
  return c.html(organizersEditHtml)
})

// イベント管理
app.get('/events-list.html', routeAccessControl('admin'), (c) => {
  return c.html(eventsListHtml)
})

app.get('/events-form.html', routeAccessControl('admin'), (c) => {
  return c.html(eventsFormHtml)
})

// 商品管理
app.get('/products-list.html', routeAccessControl('admin'), (c) => {
  return c.html(productsListHtml)
})

app.get('/products-edit.html', routeAccessControl('admin'), (c) => {
  return c.html(productsEditHtml)
})

app.get('/products-stocks.html', routeAccessControl('admin'), (c) => {
  return c.html(productsStocksHtml)
})

app.get('/products-shared-stocks.html', routeAccessControl('admin'), (c) => {
  return c.html(productsSharedStocksHtml)
})

app.get('/products-form-fields.html', routeAccessControl('admin'), (c) => {
  return c.html(productsFormFieldsHtml)
})

// オプション管理
app.get('/options-list.html', routeAccessControl('admin'), (c) => {
  return c.html(optionsListHtml)
})

app.get('/options-edit.html', routeAccessControl('admin'), (c) => {
  return c.html(optionsEditHtml)
})

app.get('/options-stocks.html', routeAccessControl('admin'), (c) => {
  return c.html(optionsStocksHtml)
})

// 共有在庫プール管理
app.get('/shared-stock-pools-list.html', routeAccessControl('admin'), (c) => {
  return c.html(sharedStockPoolsListHtml)
})

app.get('/shared-stock-pools-manage.html', routeAccessControl('admin'), (c) => {
  return c.html(sharedStockPoolsManageHtml)
})

app.get('/shared-stock-pools-new.html', routeAccessControl('admin'), (c) => {
  return c.html(sharedStockPoolsNewHtml)
})

// 予約管理
app.get('/bookings-list.html', routeAccessControl('admin'), (c) => {
  return c.html(bookingsListHtml)
})

app.get('/bookings-detail.html', routeAccessControl('admin'), (c) => {
  return c.html(bookingsDetailHtml)
})

app.get('/bookings-edit.html', routeAccessControl('admin'), (c) => {
  return c.html(bookingsEditHtml)
})

// 一括操作
app.get('/admin-bulk-messages.html', routeAccessControl('admin'), (c) => {
  return c.html(adminBulkMessagesHtml)
})

app.get('/admin-bulk-documents.html', routeAccessControl('admin'), (c) => {
  return c.html(adminBulkDocumentsHtml)
})

app.get('/admin-bulk-emails.html', routeAccessControl('admin'), (c) => {
  return c.html(adminBulkEmailsHtml)
})

app.get('/admin-products.html', routeAccessControl('admin'), (c) => {
  return c.html(adminProductsHtml)
})

// ヘルプページ
app.get('/email-placeholder-help.html', routeAccessControl('admin'), (c) => {
  return c.html(emailPlaceholderHelpHtml)
})

app.get('/document-placeholder-help.html', routeAccessControl('admin'), (c) => {
  return c.html(documentPlaceholderHelpHtml)
})

app.get('/admin-help.html', routeAccessControl('admin'), (c) => {
  return c.html(adminHelpHtml)
})

// ヘルスチェック
app.get('/health', (c) => {
  return c.json({ status: 'ok', service: 'admin-site' })
})

export default app
