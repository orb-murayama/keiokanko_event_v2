import type { DatabaseAdapter } from './types'
import { D1Adapter } from './d1-adapter'
import { MySQLAdapter } from './mysql-adapter'

/**
 * データベースアダプターファクトリー
 * 
 * 環境変数に応じて適切なアダプターを返します。
 * D1 → MySQL への移行時は、このファクトリーの実装を変更するだけで対応できます。
 */
export function createDatabaseAdapter(env: any): DatabaseAdapter {
  // 将来的に環境変数で切り替え
  // if (env.DB_TYPE === 'mysql') {
  //   const pool = createMySQLPool(env)
  //   return new MySQLAdapter(pool)
  // }

  // 現在はD1のみ
  return new D1Adapter(env.DB)
}

/**
 * MySQL接続プール作成（将来の実装用）
 */
// function createMySQLPool(env: any) {
//   const mysql = require('mysql2/promise')
//   return mysql.createPool({
//     host: env.MYSQL_HOST,
//     user: env.MYSQL_USER,
//     password: env.MYSQL_PASSWORD,
//     database: env.MYSQL_DATABASE,
//     waitForConnections: true,
//     connectionLimit: 10,
//     queueLimit: 0
//   })
// }

// エクスポート
export type { DatabaseAdapter } from './types'
export { D1Adapter } from './d1-adapter'
export { MySQLAdapter } from './mysql-adapter'
