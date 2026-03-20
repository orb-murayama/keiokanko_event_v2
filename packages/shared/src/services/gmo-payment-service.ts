/**
 * GMO Payment Gateway サービス
 * 
 * GMO決済APIとの通信を担当します。
 * - 売上確定（CAPTURE / SALES）
 * - 仮売上取消（VOID）
 */

export interface GMOCaptureRequest {
  accessId: string
  accessPass: string
  orderId: string
  amount: number
}

export interface GMOVoidRequest {
  accessId: string
  accessPass: string
  orderId: string
}

export interface GMOResponse {
  success: boolean
  orderId?: string
  tranId?: string
  tranDate?: string
  error?: string
  errorCode?: string
  errorInfo?: string
}

export class GMOPaymentService {
  constructor(
    private shopId: string,
    private shopPass: string,
    private apiUrl: string
  ) {}

  /**
   * 売上確定（CAPTURE）
   * 
   * 仮売上状態のカード決済を売上確定します。
   * これにより、顧客のカードから実際に引き落としが行われます。
   */
  async capture(params: GMOCaptureRequest): Promise<GMOResponse> {
    console.log('💳 [GMO Capture] 売上確定開始:', {
      orderId: params.orderId,
      amount: params.amount,
      accessIdLength: params.accessId?.length,
      accessPassLength: params.accessPass?.length,
      hasAccessId: !!params.accessId,
      hasAccessPass: !!params.accessPass
    })

    try {
      const requestParams = new URLSearchParams({
        ShopID: this.shopId,
        ShopPass: this.shopPass,
        AccessID: params.accessId,
        AccessPass: params.accessPass,
        JobCd: 'SALES',  // 売上確定
        Amount: String(params.amount)
      })

      console.log('📤 [GMO Capture] リクエストパラメータ:', {
        ShopID: this.shopId,
        ShopPass_length: this.shopPass?.length,
        JobCd: 'SALES',
        Amount: String(params.amount),
        AccessID_length: params.accessId?.length,
        AccessPass_length: params.accessPass?.length,
        apiUrl: this.apiUrl,
        note: 'OrderID is NOT sent to GMO (uses AccessID instead)'
      })

      console.log('📤 [GMO Capture] 完全なリクエストボディ:', requestParams.toString())

      const response = await fetch(`${this.apiUrl}/payment/AlterTran.idPass`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: requestParams.toString()
      })

      const text = await response.text()
      console.log('📥 [GMO Capture] レスポンス:', text)
      console.log('📥 [GMO Capture] HTTPステータス:', response.status)
      console.log('📥 [GMO Capture] APIエンドポイント:', `${this.apiUrl}/payment/AlterTran.idPass`)
      console.log('📥 [GMO Capture] 送信したAccessID（先頭10文字）:', params.accessId.substring(0, 10) + '...')
      console.log('📥 [GMO Capture] 送信したAccessPass（先頭10文字）:', params.accessPass.substring(0, 10) + '...')

      // レスポンスをパース（key=value&key=value形式）
      const result = new URLSearchParams(text)
      const errCode = result.get('ErrCode')
      const errInfo = result.get('ErrInfo')

      if (errCode) {
        console.error('❌ [GMO Capture] エラー:', {
          errCode,
          errInfo,
          orderId: params.orderId
        })

        return {
          success: false,
          orderId: params.orderId,
          error: `GMO売上確定失敗: ${errCode}`,
          errorCode: errCode,
          errorInfo: errInfo || undefined
        }
      }

      const tranId = result.get('TranID')
      const tranDate = result.get('TranDate')

      console.log('✅ [GMO Capture] 成功:', {
        orderId: params.orderId,
        tranId,
        tranDate
      })

      return {
        success: true,
        orderId: params.orderId,
        tranId: tranId || undefined,
        tranDate: tranDate || undefined
      }

    } catch (error) {
      console.error('❌ [GMO Capture] 例外エラー:', error)
      return {
        success: false,
        orderId: params.orderId,
        error: `GMO売上確定例外: ${error.message}`
      }
    }
  }

  /**
   * 仮売上取消（VOID）
   * 
   * 仮売上状態のカード決済を取消します。
   * 顧客のカード枠が解放され、返金処理は不要です。
   * 
   * Note: 売上確定後は使用できません（その場合はREFUNDが必要）
   */
  async void(params: GMOVoidRequest): Promise<GMOResponse> {
    console.log('🔄 [GMO Void] 仮売上取消開始:', {
      orderId: params.orderId
    })

    try {
      const requestParams = new URLSearchParams({
        ShopID: this.shopId,
        ShopPass: this.shopPass,
        AccessID: params.accessId,
        AccessPass: params.accessPass,
        JobCd: 'VOID'  // 仮売上取消
      })

      const response = await fetch(`${this.apiUrl}/payment/AlterTran.idPass`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: requestParams.toString()
      })

      const text = await response.text()
      console.log('📥 [GMO Void] レスポンス:', text)

      // レスポンスをパース
      const result = new URLSearchParams(text)
      const errCode = result.get('ErrCode')
      const errInfo = result.get('ErrInfo')

      if (errCode) {
        console.error('❌ [GMO Void] エラー:', {
          errCode,
          errInfo,
          orderId: params.orderId
        })

        return {
          success: false,
          orderId: params.orderId,
          error: `GMO仮売上取消失敗: ${errCode}`,
          errorCode: errCode,
          errorInfo: errInfo || undefined
        }
      }

      const tranId = result.get('TranID')

      console.log('✅ [GMO Void] 成功:', {
        orderId: params.orderId,
        tranId
      })

      return {
        success: true,
        orderId: params.orderId,
        tranId: tranId || undefined
      }

    } catch (error) {
      console.error('❌ [GMO Void] 例外エラー:', error)
      return {
        success: false,
        orderId: params.orderId,
        error: `GMO仮売上取消例外: ${error.message}`
      }
    }
  }
}
