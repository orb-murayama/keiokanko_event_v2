import type { DatabaseAdapter } from './types'

/**
 * MySQL アダプター（将来の実装用）
 * 
 * MySQL移行時に使用します。標準的なBEGIN/COMMIT/ROLLBACKトランザクション制御を実装。
 * 
 * Note: 現在は未使用ですが、1ヶ月後のMySQL移行時に有効化します。
 */
export class MySQLAdapter implements DatabaseAdapter {
  private connection: any = null
  private pool: any

  constructor(pool: any) {
    this.pool = pool
  }

  /**
   * トランザクション開始
   */
  async beginTransaction(): Promise<void> {
    this.connection = await this.pool.getConnection()
    await this.connection.query('BEGIN')
    console.log('🔄 [MySQL] トランザクション開始')
  }

  /**
   * トランザクションコミット
   */
  async commit(): Promise<void> {
    if (!this.connection) {
      throw new Error('トランザクションが開始されていません')
    }

    await this.connection.query('COMMIT')
    this.connection.release()
    this.connection = null
    console.log('✅ [MySQL] トランザクションコミット完了')
  }

  /**
   * トランザクションロールバック
   */
  async rollback(): Promise<void> {
    if (!this.connection) {
      console.warn('⚠️ [MySQL] ロールバック: トランザクションが開始されていません')
      return
    }

    await this.connection.query('ROLLBACK')
    this.connection.release()
    this.connection = null
    console.log('🔄 [MySQL] トランザクションロールバック完了')
  }

  /**
   * SELECT クエリ実行（1行取得）
   */
  async execute<T>(query: string, params?: any[]): Promise<T | null> {
    const conn = this.connection || this.pool
    const [rows] = await conn.query(query, params)
    return (rows as any[])[0] || null
  }

  /**
   * INSERT クエリ実行
   */
  async insert(query: string, params?: any[]): Promise<number> {
    const conn = this.connection || this.pool
    const [result] = await conn.query(query, params)
    return (result as any).insertId
  }

  /**
   * UPDATE/DELETE クエリ実行
   */
  async update(query: string, params?: any[]): Promise<number> {
    const conn = this.connection || this.pool
    const [result] = await conn.query(query, params)
    return (result as any).affectedRows
  }

  /**
   * SELECT クエリ実行（複数行取得）
   */
  async query<T>(query: string, params?: any[]): Promise<T[]> {
    const conn = this.connection || this.pool
    const [rows] = await conn.query(query, params)
    return rows as T[]
  }
}

/**
 * MySQL接続プールの作成（将来の実装用）
 * 
 * 使用例:
 * ```typescript
 * import mysql from 'mysql2/promise'
 * 
 * const pool = mysql.createPool({
 *   host: env.MYSQL_HOST,
 *   user: env.MYSQL_USER,
 *   password: env.MYSQL_PASSWORD,
 *   database: env.MYSQL_DATABASE,
 *   waitForConnections: true,
 *   connectionLimit: 10,
 *   queueLimit: 0
 * })
 * 
 * const db = new MySQLAdapter(pool)
 * ```
 */
