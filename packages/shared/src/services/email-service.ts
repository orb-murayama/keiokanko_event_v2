import nodemailer from 'nodemailer'
import type { Transporter, SendMailOptions } from 'nodemailer'

export interface EmailOptions {
  from?: string
  to: string | string[]
  cc?: string | string[]
  bcc?: string | string[]
  subject: string
  html?: string
  text?: string
  replyTo?: string
  attachments?: Array<{
    filename: string
    content: Buffer | string
    contentType?: string
  }>
}

export interface EmailResult {
  success: boolean
  messageId?: string
  error?: string
}

export class EmailService {
  private transporter: Transporter
  private defaultFrom: string

  constructor(
    smtpHost: string,
    smtpPort: number,
    smtpUser: string,
    smtpPass: string,
    defaultFrom: string
  ) {
    console.log('📧 [EmailService] Initializing SMTP connection:', {
      host: smtpHost,
      port: smtpPort,
      user: smtpUser
    })

    this.transporter = nodemailer.createTransport({
      host: smtpHost,
      port: smtpPort,
      secure: false, // Port 10025 uses STARTTLS
      auth: {
        user: smtpUser,
        pass: smtpPass
      }
      // Note: tls.rejectUnauthorized is not supported in Cloudflare Workers nodejs_compat
    })

    this.defaultFrom = defaultFrom
  }

  /**
   * メール送信
   */
  async sendEmail(options: EmailOptions): Promise<EmailResult> {
    try {
      console.log('📧 [EmailService] Sending email:', {
        from: options.from || this.defaultFrom,
        to: options.to,
        subject: options.subject,
        hasHtml: !!options.html,
        hasText: !!options.text,
        hasAttachments: !!options.attachments?.length
      })

      const mailOptions: SendMailOptions = {
        from: options.from || this.defaultFrom,
        to: options.to,
        cc: options.cc,
        bcc: options.bcc,
        subject: options.subject,
        html: options.html,
        text: options.text,
        replyTo: options.replyTo,
        attachments: options.attachments
      }

      const info = await this.transporter.sendMail(mailOptions)

      console.log('✅ [EmailService] Email sent successfully:', {
        messageId: info.messageId,
        response: info.response
      })

      return {
        success: true,
        messageId: info.messageId
      }
    } catch (error: any) {
      console.error('❌ [EmailService] Failed to send email:', {
        error: error.message,
        code: error.code,
        command: error.command
      })

      return {
        success: false,
        error: error.message || 'Unknown error'
      }
    }
  }

  /**
   * SMTP接続をテスト
   */
  async verifyConnection(): Promise<boolean> {
    try {
      await this.transporter.verify()
      console.log('✅ [EmailService] SMTP connection verified')
      return true
    } catch (error: any) {
      console.error('❌ [EmailService] SMTP connection failed:', error.message)
      return false
    }
  }
}
