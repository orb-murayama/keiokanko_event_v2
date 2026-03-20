/**
 * 通知サービス
 * 
 * 管理者への通知機能を提供します。
 * 現在はコンソールログのみですが、将来的にメール送信機能を追加します。
 */

export interface NotificationService {
  sendAdminAlert(alert: AdminAlert): Promise<void>
}

export interface AdminAlert {
  type: 'GMO_VOID_FAILED' | 'GMO_CAPTURE_FAILED' | 'STOCK_SHORTAGE' | 'SYSTEM_ERROR'
  severity: 'critical' | 'warning' | 'info'
  title: string
  message: string
  details?: Record<string, any>
  timestamp: Date
}

/**
 * ダミー通知サービス（現在）
 * 
 * コンソールログに出力するのみです。
 * メール機能実装後、EmailNotificationServiceに切り替えます。
 */
export class DummyNotificationService implements NotificationService {
  async sendAdminAlert(alert: AdminAlert): Promise<void> {
    const severityEmoji = {
      critical: '🚨',
      warning: '⚠️',
      info: 'ℹ️'
    }

    console.log(`${severityEmoji[alert.severity]} [管理者通知（未実装）]`, {
      type: alert.type,
      severity: alert.severity,
      title: alert.title,
      message: alert.message,
      details: alert.details,
      timestamp: alert.timestamp.toISOString()
    })

    // TODO: メール機能実装後に実際の送信処理を追加
    // 実装例:
    // await this.emailService.send({
    //   to: ['admin@example.com'],
    //   subject: `[${alert.severity.toUpperCase()}] ${alert.title}`,
    //   body: this.formatAlertEmail(alert)
    // })
  }

  private formatAlertEmail(alert: AdminAlert): string {
    return `
【アラート種別】${alert.type}
【重要度】${alert.severity}
【発生時刻】${alert.timestamp.toISOString()}

【メッセージ】
${alert.message}

【詳細情報】
${JSON.stringify(alert.details, null, 2)}

---
このメールは自動送信されています。
    `.trim()
  }
}

/**
 * メール通知サービス（将来の実装用）
 * 
 * メール機能追加後に使用します。
 * 
 * 使用例:
 * ```typescript
 * const emailService = new EmailService(env.EMAIL_API_KEY, env.EMAIL_API_ENDPOINT)
 * const notification = new EmailNotificationService(emailService, ['admin@example.com'])
 * 
 * await notification.sendAdminAlert({
 *   type: 'GMO_VOID_FAILED',
 *   severity: 'critical',
 *   title: 'GMO仮売上取消失敗',
 *   message: '予約番号 BK20260312-001 の仮売上取消に失敗しました',
 *   details: { booking_number: 'BK20260312-001', error: '...' },
 *   timestamp: new Date()
 * })
 * ```
 */
export class EmailNotificationService implements NotificationService {
  constructor(
    private emailService: EmailService,
    private adminEmails: string[]
  ) {}

  async sendAdminAlert(alert: AdminAlert): Promise<void> {
    const severityLabel = {
      critical: 'CRITICAL',
      warning: 'WARNING',
      info: 'INFO'
    }

    const subject = `[${severityLabel[alert.severity]}] ${alert.title}`
    const body = this.formatAlertEmail(alert)

    try {
      await this.emailService.send({
        to: this.adminEmails,
        subject: subject,
        body: body
      })

      console.log('✅ [Email] 管理者通知送信完了:', {
        type: alert.type,
        severity: alert.severity,
        recipients: this.adminEmails
      })

    } catch (error) {
      console.error('❌ [Email] 管理者通知送信失敗:', error)
      // メール送信失敗でもシステムは継続
    }
  }

  private formatAlertEmail(alert: AdminAlert): string {
    return `
【アラート種別】${alert.type}
【重要度】${alert.severity}
【発生時刻】${alert.timestamp.toISOString()}

【メッセージ】
${alert.message}

【詳細情報】
${JSON.stringify(alert.details, null, 2)}

---
このメールは自動送信されています。
    `.trim()
  }
}

/**
 * メール送信サービスインターフェース（将来の実装用）
 */
export interface EmailService {
  send(params: {
    to: string[]
    subject: string
    body: string
  }): Promise<void>
}

/**
 * メール送信サービス実装例（将来）
 * 
 * SendGrid、AWS SES、Resendなどを使用して実装します。
 * 
 * ```typescript
 * export class SendGridEmailService implements EmailService {
 *   constructor(private apiKey: string) {}
 *   
 *   async send(params: { to: string[]; subject: string; body: string }): Promise<void> {
 *     await fetch('https://api.sendgrid.com/v3/mail/send', {
 *       method: 'POST',
 *       headers: {
 *         'Content-Type': 'application/json',
 *         'Authorization': `Bearer ${this.apiKey}`
 *       },
 *       body: JSON.stringify({
 *         personalizations: [{ to: params.to.map(email => ({ email })) }],
 *         from: { email: 'noreply@example.com' },
 *         subject: params.subject,
 *         content: [{ type: 'text/plain', value: params.body }]
 *       })
 *     })
 *   }
 * }
 * ```
 */
