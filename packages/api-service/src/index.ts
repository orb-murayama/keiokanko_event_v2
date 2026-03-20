import { Hono } from 'hono'
import { cors } from 'hono/cors'
import type { Bindings } from '@keiokanko/shared'
import { createDatabaseAdapter } from '@keiokanko/shared'
import { GMOPaymentService, BookingService, EmailService, EmailTemplateEngine, DummyNotificationService } from '@keiokanko/shared'
import { requireAuth, requireRole, requireEventAccess } from '@keiokanko/shared'

// APIルートのインポート
import eventsRouter from './routes/events.js'
import productsRouter from './routes/products.js'
import optionsRouter from './routes/options.js'
import bookingsRouter from './routes/bookings.js'
import accountsRouter from './routes/accounts.js'
import organizersRouter from './routes/organizers.js'
import membersRouter from './routes/members.js'
import clientsRouter from './routes/clients.js'
import vendorsRouter from './routes/vendors.js'
import paymentsRouter from './routes/payments.js'
import sharedStockPoolsRouter from './routes/shared-stock-pools.js'
import emailTemplatesRouter from './routes/email-templates.js'
import adminRouter from './routes/admin.js'

const app = new Hono<{ Bindings: Bindings }>()

// CORS設定
app.use('/api/*', cors())

// ヘルスチェック
app.get('/health', (c) => {
  return c.json({ status: 'ok', service: 'api-service' })
})

// APIルートの登録
app.route('/api/events', eventsRouter)
app.route('/api/products', productsRouter)
app.route('/api/options', optionsRouter)
app.route('/api/bookings', bookingsRouter)
app.route('/api/accounts', accountsRouter)
app.route('/api/organizers', organizersRouter)
app.route('/api/members', membersRouter)
app.route('/api/clients', clientsRouter)
app.route('/api/vendors', vendorsRouter)
app.route('/api/payments', paymentsRouter)
app.route('/api/shared-stock-pools', sharedStockPoolsRouter)
app.route('/api/email-templates', emailTemplatesRouter)
app.route('/api/admin', adminRouter)

// V1 API（互換性のため）
app.route('/api/v1/events', eventsRouter)
app.route('/api/v1/products', productsRouter)
app.route('/api/v1/bookings', bookingsRouter)
app.route('/api/v1/organizers', organizersRouter)

// V2 API
app.route('/api/v2/bookings', bookingsRouter)
app.route('/api/v2/products', productsRouter)

export default app
