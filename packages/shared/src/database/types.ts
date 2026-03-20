/**
 * データベース抽象化レイヤー
 * 
 * Cloudflare D1 と MySQL の両方に対応するための抽象化インターフェース
 */

export interface DatabaseAdapter {
  /**
   * トランザクション開始
   * D1: 何もしない（バッチAPIで自動的にトランザクション）
   * MySQL: BEGIN を実行
   */
  beginTransaction(): Promise<void>

  /**
   * トランザクションコミット
   * D1: 何もしない
   * MySQL: COMMIT を実行
   */
  commit(): Promise<void>

  /**
   * トランザクションロールバック
   * D1: 何もしない（バッチ失敗時に自動ロールバック）
   * MySQL: ROLLBACK を実行
   */
  rollback(): Promise<void>

  /**
   * SELECT クエリ実行（1行取得）
   */
  execute<T>(query: string, params?: any[]): Promise<T | null>

  /**
   * INSERT クエリ実行
   * @returns last_insert_id
   */
  insert(query: string, params?: any[]): Promise<number>

  /**
   * UPDATE/DELETE クエリ実行
   * @returns affected_rows
   */
  update(query: string, params?: any[]): Promise<number>

  /**
   * SELECT クエリ実行（複数行取得）
   */
  query<T>(query: string, params?: any[]): Promise<T[]>
}

/**
 * トランザクションコンテキスト
 */
export interface TransactionContext {
  execute<T>(query: string, params?: any[]): Promise<T | null>
  insert(query: string, params?: any[]): Promise<number>
  update(query: string, params?: any[]): Promise<number>
  query<T>(query: string, params?: any[]): Promise<T[]>
}
