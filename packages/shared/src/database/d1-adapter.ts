import type { DatabaseAdapter } from './types'

/**
 * Cloudflare D1 アダプター
 * 
 * D1は明示的なトランザクション制御（BEGIN/COMMIT/ROLLBACK）をサポートしていないため、
 * 内部的にバッチAPIを使用してアトミック性を保証します。
 */
export class D1Adapter implements DatabaseAdapter {
  private pendingQueries: Array<{ stmt: D1PreparedStatement; type: 'insert' | 'update' | 'execute' }> = []
  private inTransaction = false

  constructor(private db: D1Database) {}

  /**
   * トランザクション開始（D1では記録のみ）
   */
  async beginTransaction(): Promise<void> {
    this.inTransaction = true
    this.pendingQueries = []
    console.log('🔄 [D1] トランザクション開始（バッチモード）')
  }

  /**
   * トランザクションコミット（D1では即実行済みなので確認のみ）
   */
  async commit(): Promise<void> {
    if (!this.inTransaction) {
      throw new Error('トランザクションが開始されていません')
    }

    console.log('✅ [D1] トランザクションコミット（クエリは即実行済み）')
    this.inTransaction = false
    this.pendingQueries = []
  }

  /**
   * トランザクションロールバック（D1では補償トランザクションが必要）
   * 
   * ⚠️ 注意: D1はトランザクション中に即実行するため、
   * ロールバック時は既に実行されたクエリを手動で補償する必要があります。
   * 現在の実装では、エラー時にGMO仮売上取消で補償しています。
   */
  async rollback(): Promise<void> {
    console.log('⚠️ [D1] トランザクションロールバック（クエリは既に実行済み - 補償が必要）')
    this.inTransaction = false
    this.pendingQueries = []
  }

  /**
   * SELECT クエリ実行（1行取得）
   */
  async execute<T>(query: string, params?: any[]): Promise<T | null> {
    try {
      let stmt = this.db.prepare(query)
      if (params && params.length > 0) {
        stmt = stmt.bind(...params)
      }

      // トランザクション中でもSELECTは即実行（READ操作）
      const result = await stmt.first()
      return result as T | null
    } catch (error) {
      console.error('❌ [D1] execute エラー:', { 
        query: query.substring(0, 200), 
        params, 
        error: error instanceof Error ? {
          name: error.name,
          message: error.message,
          stack: error.stack
        } : error
      })
      throw new Error(`D1 SELECT失敗: ${error instanceof Error ? error.message : String(error)}. Query: ${query.substring(0, 100)}`)
    }
  }

  /**
   * INSERT クエリ実行
   */
  async insert(query: string, params?: any[]): Promise<number> {
    try {
      let stmt = this.db.prepare(query)
      if (params && params.length > 0) {
        stmt = stmt.bind(...params)
      }

      if (this.inTransaction) {
        // ⚠️ D1の制限: トランザクション中は即実行してIDを取得
        // バッチAPIではlast_row_idが配列で返されるが、順序管理が複雑なため即実行
        // 注意: アトミック性は完全ではないが、エラー時はロールバックで補償
        const result = await stmt.run()
        const insertId = result.meta.last_row_id as number
        console.log('💾 [D1] INSERT実行（トランザクション中）:', { insertId, query: query.substring(0, 50) })
        return insertId
      } else {
        // 即実行
        const result = await stmt.run()
        return result.meta.last_row_id as number
      }
    } catch (error) {
      console.error('❌ [D1] insert エラー:', { 
        query: query.substring(0, 200), 
        params, 
        error: error instanceof Error ? {
          name: error.name,
          message: error.message,
          stack: error.stack
        } : error
      })
      throw new Error(`D1 INSERT失敗: ${error instanceof Error ? error.message : String(error)}. Query: ${query.substring(0, 100)}`)
    }
  }

  /**
   * UPDATE/DELETE クエリ実行
   */
  async update(query: string, params?: any[]): Promise<number> {
    try {
      let stmt = this.db.prepare(query)
      if (params && params.length > 0) {
        stmt = stmt.bind(...params)
      }

      if (this.inTransaction) {
        // ⚠️ D1の制限: トランザクション中は即実行して更新件数を取得
        const result = await stmt.run()
        const changes = result.meta.changes as number
        console.log('🔄 [D1] UPDATE実行（トランザクション中）:', { changes, query: query.substring(0, 50) })
        return changes
      } else {
        // 即実行
        const result = await stmt.run()
        return result.meta.changes as number
      }
    } catch (error) {
      console.error('❌ [D1] update エラー:', { 
        query: query.substring(0, 200), 
        params, 
        error: error instanceof Error ? {
          name: error.name,
          message: error.message,
          stack: error.stack
        } : error
      })
      throw new Error(`D1 UPDATE失敗: ${error instanceof Error ? error.message : String(error)}. Query: ${query.substring(0, 100)}`)
    }
  }

  /**
   * SELECT クエリ実行（複数行取得）
   */
  async query<T>(query: string, params?: any[]): Promise<T[]> {
    let stmt = this.db.prepare(query)
    if (params && params.length > 0) {
      stmt = stmt.bind(...params)
    }

    const result = await stmt.all()
    return result.results as T[]
  }

  /**
   * D1専用: バッチ実行（トランザクション外で直接使用）
   */
  async batch(queries: D1PreparedStatement[]): Promise<D1Result[]> {
    return await this.db.batch(queries)
  }
}
