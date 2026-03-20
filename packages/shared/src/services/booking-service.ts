import type { DatabaseAdapter } from '../database/types'
import type { GMOPaymentService } from './gmo-payment-service'
import type { NotificationService } from './notification-service'
import {
  type CreateBookingRequest,
  type CreateBookingResponse,
  type StockRow,
  BookingError
} from './booking-types'

/**
 * 予約サービス
 * 
 * 予約作成処理を担当します。
 * トランザクション制御、在庫管理、GMO決済、エラーハンドリングを実装。
 */
export class BookingService {
  constructor(
    private db: DatabaseAdapter,
    private gmo: GMOPaymentService,
    private notification: NotificationService
  ) {}

  /**
   * 予約作成（決済完了後）
   */
  async createBookingWithPayment(data: CreateBookingRequest): Promise<CreateBookingResponse> {
    let gmoAccessId: string | null = null
    let gmoAccessPass: string | null = null
    let bookingNumber: string | null = null
    let paymentId: number | null = null

    try {
      console.log('🚀 [予約作成] 開始:', {
        event_id: data.event_id,
        booker_email: data.booker.email,
        items_count: data.items.length,
        total_amount: data.total_amount,
        payment_method: data.payment_method
      })

      // ========== Phase 1: 事前チェック（トランザクション外） ==========

      // GMO情報を保存（エラー時の取消用）
      // GMOレスポンスは2つの形式がある:
      // 1. gmo_details.credit.AccessID (古い形式)
      // 2. gmo_details.transactionresult.AccessID (新しい形式)
      gmoAccessId = data.gmo_details?.transactionresult?.AccessID || data.gmo_details?.credit?.AccessID || null
      gmoAccessPass = data.gmo_details?.transactionresult?.AccessPass || data.gmo_details?.credit?.AccessPass || null

      console.log('📋 [予約作成] GMO情報確認:', {
        has_access_id: !!gmoAccessId,
        has_access_pass: !!gmoAccessPass,
        gmo_order_id: data.gmo_order_id,
        gmo_details_exists: !!data.gmo_details,
        gmo_details_type: typeof data.gmo_details,
        gmo_details_structure: data.gmo_details ? Object.keys(data.gmo_details) : [],
        transactionresult_exists: !!data.gmo_details?.transactionresult,
        credit_exists: !!data.gmo_details?.credit,
        raw_gmo_details: data.gmo_details ? JSON.stringify(data.gmo_details).substring(0, 200) : null
      })

      // ========== Phase 2: DBトランザクション ==========

      await this.db.beginTransaction()

      // ① 在庫チェック（FOR UPDATE でロック取得）
      console.log('📦 [在庫チェック] 開始')
      await this.checkStockAvailability(data.items)
      console.log('✅ [在庫チェック] 完了')

      // ② 会員情報の処理
      console.log('👤 [会員処理] 開始')
      const memberId = await this.processMember(data)
      console.log('✅ [会員処理] 完了:', memberId)

      // ③ 予約番号生成
      bookingNumber = await this.generateBookingNumber()
      console.log('🔢 [予約番号] 生成:', bookingNumber)

      // ④ 予約グループ作成
      const bookingId = await this.createBookingGroup(
        bookingNumber,
        memberId,
        data,
        gmoAccessId,
        gmoAccessPass
      )
      console.log('✅ [予約グループ] 作成完了:', bookingId)

      // ⑤ 決済情報保存
      const paymentNumber = await this.generatePaymentNumber()
      paymentId = await this.createPayment(
        bookingId,
        bookingNumber,
        paymentNumber,
        data
      )
      console.log('✅ [決済情報] 作成完了:', paymentNumber)

      // ⑥ カード情報保存（クレジットカードの場合のみ）
      if (data.payment_method === 'credit_card' && data.card_info) {
        await this.saveCardInfo(
          paymentId,
          bookingNumber,
          data.card_info,
          gmoAccessId,
          data.gmo_order_id
        )
        console.log('✅ [カード情報] 保存完了')
      }

      // ⑦ 予約明細作成
      await this.createBookingItems(
        bookingId,
        paymentId,
        data
      )
      console.log('✅ [予約明細] 作成完了')

      // ⑧ 在庫減算
      await this.decrementStock(data.items)
      console.log('✅ [在庫減算] 完了')

      // コミット
      await this.db.commit()
      console.log('✅ [DBトランザクション] コミット完了')

      // ========== Phase 3: 売上確定（トランザクション外） ==========

      console.log('💳 [売上確定] 条件チェック:', {
        payment_method: data.payment_method,
        is_credit_card: data.payment_method === 'credit_card',
        has_gmoAccessId: !!gmoAccessId,
        has_gmoAccessPass: !!gmoAccessPass,
        will_capture: data.payment_method === 'credit_card' && !!gmoAccessId && !!gmoAccessPass
      })

      if (data.payment_method === 'credit_card' && gmoAccessId && gmoAccessPass) {
        console.log('💳 [売上確定] GMO認証情報:', {
          accessId_length: gmoAccessId.length,
          accessPass_length: gmoAccessPass.length,
          accessId_prefix: gmoAccessId.substring(0, 8) + '...',
          accessPass_prefix: gmoAccessPass.substring(0, 8) + '...',
          gmo_order_id: data.gmo_order_id,
          booking_number: bookingNumber
        })
        
        const captureAmount = data.final_amount || data.total_amount  // 手数料込みの金額
        
        await this.capturePayment(
          gmoAccessId,
          gmoAccessPass,
          data.gmo_order_id || bookingNumber,  // GMOに登録されたOrderIDを使用
          bookingNumber,  // ログ用の予約番号
          captureAmount,   // 手数料込みの金額でCapture
          paymentId,
          paymentNumber
        )
      } else {
        console.log('⏭️ [売上確定] スキップ:', {
          reason: !data.payment_method || data.payment_method !== 'credit_card' 
            ? '決済方法がクレジットカードではない'
            : 'GMO AccessID/PassがなL'
        })
      }

      // ========== Phase 4: 成功レスポンス ==========

      console.log('🎉 [予約作成] 完了:', bookingNumber)

      return {
        success: true,
        booking_id: bookingId,
        booking_number: bookingNumber,
        payment_number: paymentNumber,
        message: '予約が完了しました'
      }

    } catch (error) {
      console.error('❌ [予約作成] エラー:', error)

      // DBロールバック
      try {
        await this.db.rollback()
        console.log('✅ [DBロールバック] 完了')
      } catch (rollbackError) {
        console.error('❌ [DBロールバック] 失敗:', rollbackError)
      }

      // GMO仮売上取消（クレジットカードの場合のみ）
      if (data.payment_method === 'credit_card' && gmoAccessId && gmoAccessPass) {
        await this.voidPayment(
          gmoAccessId,
          gmoAccessPass,
          bookingNumber || data.gmo_order_id || '',
          data
        )
      }

      // エラーレスポンス
      if (error instanceof BookingError) {
        throw error
      }

      // 元のエラーを含めて新しいBookingErrorを作成
      const originalMessage = error instanceof Error ? error.message : String(error)
      const detailedMessage = `予約の作成に失敗しました: ${originalMessage}`
      
      console.error('❌ [予約作成] 詳細エラー:', {
        message: originalMessage,
        stack: error instanceof Error ? error.stack : undefined
      })

      throw new BookingError(
        'BOOKING_CREATION_FAILED',
        detailedMessage
      )
    }
  }

  /**
   * 在庫チェック
   */
  private async checkStockAvailability(items: CreateBookingRequest['items']): Promise<void> {
    for (const item of items) {
      // 手数料アイテムは在庫チェック不要
      if (item.type === 'fee') continue
      if (!item.stock_id) continue

      const stockTable = this.getStockTable(item.stock_type, item.type)
      // カラム名の選択: shared_stock_poolsのみ'total_stock'、それ以外は'stock'
      const stockColumn = 'stock'

      // 在庫情報取得（D1ではFOR UPDATEが使えないため通常のSELECT）
      // MySQL移行時はFOR UPDATEを追加してロック取得
      const stock = await this.db.execute<StockRow>(
        `SELECT ${stockColumn} as stock, booked FROM ${stockTable} WHERE id = ?`,
        [item.stock_id]
      )

      if (!stock) {
        throw new BookingError('STOCK_NOT_FOUND', `在庫ID ${item.stock_id} が見つかりません`)
      }

      const available = stock.stock - stock.booked
      if (available < item.quantity) {
        throw new BookingError(
          'INSUFFICIENT_STOCK',
          `${item.name} の在庫が不足しています（必要: ${item.quantity}, 利用可能: ${available}）`
        )
      }
    }
  }

  /**
   * 会員情報の処理
   */
  private async processMember(data: CreateBookingRequest): Promise<number> {
    if (data.is_new_member) {
      // 新規会員登録
      const memberId = await this.db.insert(
        `INSERT INTO members (
          email, family_name, first_name, family_kana, first_kana,
          tel, mobile, zip, addr, enable_flg, email_verified,
          created_at, modified_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1, datetime('now', '+9 hours'), datetime('now', '+9 hours'))`,
        [
          data.booker.email,
          data.booker.family_name,
          data.booker.first_name,
          data.booker.family_kana,
          data.booker.first_kana,
          data.booker.tel,
          data.booker.mobile || null,
          data.booker.zip || null,
          data.booker.addr || null
        ]
      )
      return memberId
    } else {
      // 既存会員検索
      const member = await this.db.execute<{ id: number }>(
        `SELECT id FROM members WHERE email = ?`,
        [data.booker.email]
      )
      return member?.id || 0
    }
  }

  /**
   * 予約番号生成
   */
  private async generateBookingNumber(): Promise<string> {
    const today = new Date().toISOString().split('T')[0].replace(/-/g, '')
    const lastBooking = await this.db.execute<{ booking_number: string }>(
      `SELECT booking_number FROM bookings 
       WHERE booking_number LIKE ? 
       ORDER BY booking_number DESC LIMIT 1`,
      [`BK${today}%`]
    )

    let seq = 1
    if (lastBooking) {
      const lastSeq = parseInt(lastBooking.booking_number.slice(-3))
      seq = lastSeq + 1
    }

    return `BK${today}-${String(seq).padStart(3, '0')}`
  }

  /**
   * 決済番号生成
   */
  private async generatePaymentNumber(): Promise<string> {
    const today = new Date().toISOString().split('T')[0].replace(/-/g, '')
    const lastPayment = await this.db.execute<{ payment_number: string }>(
      `SELECT payment_number FROM booking_payments 
       WHERE payment_number LIKE ? 
       ORDER BY payment_number DESC LIMIT 1`,
      [`PAY${today}%`]
    )

    let seq = 1
    if (lastPayment) {
      const lastSeq = parseInt(lastPayment.payment_number.slice(-3))
      seq = lastSeq + 1
    }

    return `PAY${today}-${String(seq).padStart(3, '0')}`
  }

  /**
   * 予約グループ作成
   */
  private async createBookingGroup(
    bookingNumber: string,
    memberId: number,
    data: CreateBookingRequest,
    gmoAccessId: string | null,
    gmoAccessPass: string | null
  ): Promise<number> {
    const bookingStatus = data.payment_method === 'bank_transfer' ? 'pending_payment' : 'confirmed'

    const bookingId = await this.db.insert(
      `INSERT INTO bookings (
        booking_number, member_id, event_id, status,
        booker_name, booker_email, booker_phone,
        gmo_order_id, gmo_access_id, gmo_access_pass,
        created_at, modified_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now', '+9 hours'), datetime('now', '+9 hours'))`,
      [
        bookingNumber,
        memberId,
        data.event_id,
        bookingStatus,
        `${data.booker.family_name} ${data.booker.first_name}`,
        data.booker.email,
        data.booker.tel,
        data.gmo_order_id || null,
        gmoAccessId,
        gmoAccessPass
      ]
    )

    return bookingId
  }

  /**
   * 決済情報作成
   */
  private async createPayment(
    bookingId: number,
    bookingNumber: string,
    paymentNumber: string,
    data: CreateBookingRequest
  ): Promise<number> {
    const paymentStatus = 'pending'  // 仮売上状態
    const paymentDate = data.payment_method === 'convenience' ? null : new Date().toISOString()

    // 手数料の計算
    const finalAmount = data.final_amount || data.total_amount
    const paymentFee = data.payment_fee || 0
    const netAmount = data.total_amount  // 商品代金（手数料抜き）

    const paymentId = await this.db.insert(
      `INSERT INTO booking_payments (
        booking_id, booking_number, payment_number,
        payment_type, payment_method, payment_status,
        amount, net_amount, fee_amount,
        payment_date,
        created_at, modified_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now', '+9 hours'), datetime('now', '+9 hours'))`,
      [
        bookingId,
        bookingNumber,
        paymentNumber,
        'immediate',
        data.payment_method,
        paymentStatus,
        finalAmount,      // 総支払額（手数料込み）
        netAmount,        // 商品代金のみ
        paymentFee,       // 決済手数料
        paymentDate
      ]
    )

    return paymentId
  }

  /**
   * カード情報保存
   */
  private async saveCardInfo(
    paymentId: number,
    bookingNumber: string,
    cardInfo: NonNullable<CreateBookingRequest['card_info']>,
    gmoAccessId: string | null,
    gmoOrderId: string | undefined
  ): Promise<void> {
    await this.db.insert(
      `INSERT INTO booking_card_transactions (
        payment_id, booking_number,
        card_last4, card_exp_month, card_exp_year,
        card_holder_name, transaction_status,
        gmo_transaction_id, gmo_order_id,
        created_at, modified_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now', '+9 hours'), datetime('now', '+9 hours'))`,
      [
        paymentId,
        bookingNumber,
        cardInfo.last4,
        cardInfo.exp_month,
        cardInfo.exp_year,
        cardInfo.holder_name,
        'completed',
        gmoAccessId,
        gmoOrderId || null
      ]
    )
  }

  /**
   * 予約明細作成
   */
  private async createBookingItems(
    bookingId: number,
    paymentId: number,
    data: CreateBookingRequest
  ): Promise<void> {
    // 参加者情報をグループ化
    const itemParticipantsMap = new Map<string, any[]>()

    for (const participant of data.participants) {
      const key = `${participant.item_type}-${participant.item_id}-${participant.stock_id}-${participant.category}`
      if (!itemParticipantsMap.has(key)) {
        itemParticipantsMap.set(key, [])
      }
      itemParticipantsMap.get(key)!.push({
        lastname: participant.family_name,
        firstname: participant.first_name,
        lastname_kana: participant.family_kana,
        firstname_kana: participant.first_kana,
        email: participant.email || '',
        phone: participant.tel || '',
        age: participant.age || '',
        gender: participant.sex || '',
        birth: participant.birth_date || '',
        address: participant.addr || '',
        custom_fields: participant.custom_fields || {}
      })
    }

    // 各商品の予約明細を作成
    for (const item of data.items) {
      const key = `${item.type}-${item.id}-${item.stock_id}-${item.category}`
      const itemParticipants = itemParticipantsMap.get(key) || []

      await this.db.insert(
        `INSERT INTO booking_items (
          booking_id, payment_id, item_type, item_id, item_name,
          quantity, unit_price, subtotal,
          participation_date, price_category,
          stock_id, stock_type,
          participants, product_custom_fields,
          created_at, modified_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now', '+9 hours'), datetime('now', '+9 hours'))`,
        [
          bookingId,
          paymentId,
          item.type,
          item.id,
          item.name,
          item.quantity,
          item.unit_price,
          item.unit_price * item.quantity,
          data.participation_date,
          item.category || null,
          item.stock_id || null,
          item.stock_type || 'individual',
          JSON.stringify(itemParticipants),
          JSON.stringify(item.product_custom_fields || {})
        ]
      )
    }
  }

  /**
   * 在庫減算
   */
  private async decrementStock(items: CreateBookingRequest['items']): Promise<void> {
    for (const item of items) {
      // 手数料アイテムは在庫減算不要
      if (item.type === 'fee') continue
      if (!item.stock_id) continue

      const stockTable = this.getStockTable(item.stock_type, item.type)
      // カラム名の選択:
      // - product_stocks: 'stock'
      // - option_stocks: 'total_stock'
      // - shared_stock_pools: 'total_stock'
      const stockColumn = 'stock'

      // 在庫チェック付き更新
      const affectedRows = await this.db.update(
        `UPDATE ${stockTable} 
         SET booked = booked + ?, 
             modified_at = datetime('now', '+9 hours')
         WHERE id = ? AND (${stockColumn} - booked) >= ?`,
        [item.quantity, item.stock_id, item.quantity]
      )

      // 更新件数が0の場合は在庫不足（他のユーザーが同時に予約した）
      if (affectedRows === 0) {
        throw new BookingError(
          'INSUFFICIENT_STOCK',
          `${item.name} の在庫が不足しています（予約処理中に在庫が減少しました）`
        )
      }
    }
  }

  /**
   * 売上確定
   */
  private async capturePayment(
    gmoAccessId: string,
    gmoAccessPass: string,
    gmoOrderId: string,       // GMOに登録されたOrderID
    bookingNumber: string,     // 予約番号（ログ用）
    totalAmount: number,
    paymentId: number,
    paymentNumber: string
  ): Promise<void> {
    try {
      console.log('💳 [GMO Capture] 売上確定開始:', {
        accessId: gmoAccessId ? '***' : 'なし',
        accessPass: gmoAccessPass ? '***' : 'なし',
        gmoOrderId,
        bookingNumber,
        amount: totalAmount,
        paymentId
      })

      const result = await this.gmo.capture({
        accessId: gmoAccessId,
        accessPass: gmoAccessPass,
        orderId: gmoOrderId,  // GMOのOrderIDを使用
        amount: totalAmount
      })

      console.log('💳 [GMO Capture] API応答:', {
        success: result.success,
        tranId: result.tranId,
        errorCode: result.errorCode,
        errorInfo: result.errorInfo
      })

      if (!result.success) {
        console.error('⚠️ [GMO Capture] 売上確定失敗（予約は作成済み）:', result.error)

        // 管理者に通知
        await this.notification.sendAdminAlert({
          type: 'GMO_CAPTURE_FAILED',
          severity: 'warning',
          title: 'GMO売上確定失敗（手動確定が必要）',
          message: `予約番号 ${bookingNumber} の売上確定に失敗しました。予約は作成済みですが、決済が仮売上のままです。管理画面から手動で売上確定を行ってください。`,
          details: {
            booking_number: bookingNumber,
            payment_number: paymentNumber,
            amount: totalAmount,
            error: result.error,
            error_code: result.errorCode,
            error_info: result.errorInfo
          },
          timestamp: new Date()
        })

        return
      }

      // 決済ステータスを「完了」に更新
      await this.db.update(
        `UPDATE booking_payments
         SET payment_status = 'completed',
             payment_date = datetime('now', '+9 hours'),
             modified_at = datetime('now', '+9 hours')
         WHERE id = ?`,
        [paymentId]
      )

      console.log('✅ [GMO Capture] 売上確定完了:', result.tranId)

    } catch (error) {
      console.error('❌ [GMO Capture] 例外エラー:', error)

      // 管理者に通知
      await this.notification.sendAdminAlert({
        type: 'GMO_CAPTURE_FAILED',
        severity: 'warning',
        title: 'GMO売上確定例外エラー',
        message: `予約番号 ${bookingNumber} の売上確定で例外が発生しました。`,
        details: {
          booking_number: bookingNumber,
          payment_number: paymentNumber,
          amount: totalAmount,
          error: error.message
        },
        timestamp: new Date()
      })
    }
  }

  /**
   * 仮売上取消
   */
  private async voidPayment(
    gmoAccessId: string,
    gmoAccessPass: string,
    orderId: string,
    data: CreateBookingRequest
  ): Promise<void> {
    try {
      console.log('🔄 [GMO Void] 仮売上取消開始')

      const result = await this.gmo.void({
        accessId: gmoAccessId,
        accessPass: gmoAccessPass,
        orderId: orderId
      })

      if (!result.success) {
        console.error('❌ [GMO Void] 仮売上取消失敗:', result.error)

        // 管理者に通知（緊急）
        await this.notification.sendAdminAlert({
          type: 'GMO_VOID_FAILED',
          severity: 'critical',
          title: 'GMO仮売上取消失敗（至急対応必要）',
          message: `予約番号 ${orderId} の仮売上取消に失敗しました。予約は作成されていませんが、顧客のカードに仮売上が残っています。GMO管理画面から手動で取消を行ってください。`,
          details: {
            booking_number: orderId,
            amount: data.total_amount,
            gmo_order_id: data.gmo_order_id,
            gmo_access_id: gmoAccessId,
            booker_email: data.booker.email,
            booker_name: `${data.booker.family_name} ${data.booker.first_name}`,
            error: result.error,
            error_code: result.errorCode,
            error_info: result.errorInfo
          },
          timestamp: new Date()
        })

        return
      }

      console.log('✅ [GMO Void] 仮売上取消完了:', result.tranId)

    } catch (error) {
      console.error('❌ [GMO Void] 例外エラー:', error)

      // 管理者に通知（緊急）
      await this.notification.sendAdminAlert({
        type: 'GMO_VOID_FAILED',
        severity: 'critical',
        title: 'GMO仮売上取消例外エラー',
        message: `予約番号 ${orderId} の仮売上取消で例外が発生しました。`,
        details: {
          booking_number: orderId,
          amount: data.total_amount,
          booker_email: data.booker.email,
          error: error.message
        },
        timestamp: new Date()
      })
    }
  }

  /**
   * 在庫テーブル名取得
   */
  private getStockTable(stockType: string | undefined, itemType: string | undefined): string {
    // デフォルト値を設定
    const effectiveStockType = stockType || 'individual'
    const effectiveItemType = itemType || 'product'

    console.log('📦 [在庫テーブル判定]:', { stockType: effectiveStockType, itemType: effectiveItemType })

    if (effectiveStockType === 'shared') {
      return 'shared_stock_pools'
    } else if (effectiveItemType === 'product') {
      return 'product_stocks'
    } else {
      return 'option_stocks'
    }
  }
}
