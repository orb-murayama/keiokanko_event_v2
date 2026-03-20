/**
 * メールテンプレートエンジン
 * 
 * サポート機能:
 * - 変数置換: {{variable}}
 * - 条件分岐: {{#if condition}}...{{/if}}
 * - ループ: {{#each items}}...{{/each}}
 */
export class EmailTemplateEngine {
  private db: D1Database

  constructor(db: D1Database) {
    this.db = db
  }

  /**
   * データベースからテンプレートを取得してレンダリング
   */
  async renderTemplate(templateName: string, data: Record<string, any>): Promise<{ subject: string; body: string }> {
    // データベースからテンプレートを取得
    const template = await this.db.prepare(`
      SELECT subject_template, body_template 
      FROM email_templates 
      WHERE template_name = ? AND is_active = 1
    `).bind(templateName).first<{ subject_template: string; body_template: string }>()

    if (!template) {
      throw new Error(`Template "${templateName}" not found`)
    }

    // テンプレートをレンダリング
    return {
      subject: EmailTemplateEngine.renderAll(template.subject_template, data),
      body: EmailTemplateEngine.renderAll(template.body_template, data)
    }
  }
  /**
   * 変数置換（{{variable}} 形式）
   */
  static render(template: string, data: Record<string, any>): string {
    return template.replace(/\{\{(\w+)\}\}/g, (match, key) => {
      return data[key] !== undefined ? String(data[key]) : match
    })
  }

  /**
   * 条件分岐（{{#if condition}}...{{/if}}）
   */
  static renderConditional(template: string, data: Record<string, any>): string {
    return template.replace(
      /\{\{#if (\w+)\}\}([\s\S]*?)\{\{\/if\}\}/g,
      (match, key, content) => {
        return data[key] ? content : ''
      }
    )
  }

  /**
   * 否定条件分岐（{{#unless condition}}...{{/unless}}）
   */
  static renderUnless(template: string, data: Record<string, any>): string {
    return template.replace(
      /\{\{#unless (\w+)\}\}([\s\S]*?)\{\{\/unless\}\}/g,
      (match, key, content) => {
        return !data[key] ? content : ''
      }
    )
  }

  /**
   * ループ（{{#each items}}...{{/each}}）
   */
  static renderLoop(template: string, data: Record<string, any>): string {
    return template.replace(
      /\{\{#each (\w+)\}\}([\s\S]*?)\{\{\/each\}\}/g,
      (match, key, itemTemplate) => {
        const items = data[key]
        if (!Array.isArray(items)) return ''
        return items.map((item, index) => {
          // ループ内で @index を使用可能にする
          const itemData = { ...item, '@index': index, '@first': index === 0, '@last': index === items.length - 1 }
          return this.render(itemTemplate, itemData)
        }).join('')
      }
    )
  }

  /**
   * すべてのレンダリングを実行
   */
  static renderAll(template: string, data: Record<string, any>): string {
    let result = template
    result = this.renderConditional(result, data)
    result = this.renderUnless(result, data)
    result = this.renderLoop(result, data)
    result = this.render(result, data)
    return result
  }

  /**
   * HTMLエスケープ
   */
  static escapeHtml(text: string): string {
    const map: Record<string, string> = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#039;'
    }
    return text.replace(/[&<>"']/g, (char) => map[char])
  }

  /**
   * 日付フォーマット
   */
  static formatDate(date: string | Date, format: string = 'YYYY-MM-DD'): string {
    const d = typeof date === 'string' ? new Date(date) : date
    const year = d.getFullYear()
    const month = String(d.getMonth() + 1).padStart(2, '0')
    const day = String(d.getDate()).padStart(2, '0')
    const hours = String(d.getHours()).padStart(2, '0')
    const minutes = String(d.getMinutes()).padStart(2, '0')

    return format
      .replace('YYYY', String(year))
      .replace('MM', month)
      .replace('DD', day)
      .replace('HH', hours)
      .replace('mm', minutes)
  }

  /**
   * 金額フォーマット
   */
  static formatCurrency(amount: number, currency: string = '¥'): string {
    return `${currency}${amount.toLocaleString()}`
  }
}
