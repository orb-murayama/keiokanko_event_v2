/**
 * 参加者データを旧形式から新形式に移行するスクリプト
 * 
 * 旧形式:
 * {
 *   lastname: '山田',
 *   firstname: '太郎',
 *   age: 30,
 *   gender: '男性',
 *   email: 'test@example.com',
 *   phone: '090-1234-5678',
 *   birth: '1990-01-01',
 *   custom_fields: {}
 * }
 * 
 * 新形式:
 * {
 *   lastname_kanji: '山田',
 *   firstname_kanji: '太郎',
 *   lastname_kana: '',
 *   firstname_kana: '',
 *   lastname_roman: '',
 *   firstname_roman: '',
 *   age: 30,
 *   gender: '男性',
 *   email: 'test@example.com',
 *   phone: '090-1234-5678',
 *   birth_date: '1990-01-01',
 *   address: '',
 *   custom_fields: {}
 * }
 */

// 参加者データを新形式に変換する関数
function migrateParticipant(oldParticipant) {
  return {
    lastname_kanji: oldParticipant.lastname || '',
    firstname_kanji: oldParticipant.firstname || '',
    lastname_kana: oldParticipant.lastname_kana || '',
    firstname_kana: oldParticipant.firstname_kana || '',
    lastname_roman: oldParticipant.lastname_roman || '',
    firstname_roman: oldParticipant.firstname_roman || '',
    age: oldParticipant.age || null,
    gender: oldParticipant.gender || '',
    email: oldParticipant.email || '',
    phone: oldParticipant.phone || '',
    birth_date: oldParticipant.birth || oldParticipant.birth_date || '',
    address: oldParticipant.address || '',
    custom_fields: oldParticipant.custom_fields || {}
  };
}

const { execSync } = require('child_process');

// SQLを生成
async function generateMigrationSQL() {
  
  // 全ての予約明細を取得
  const result = execSync(
    'cd /home/user/webapp && npx wrangler d1 execute webapp-production --local --command="SELECT id, participants FROM booking_items WHERE participants IS NOT NULL AND participants != \'[]\'"',
    { encoding: 'utf-8' }
  );
  
  // 結果をパース
  const jsonMatch = result.match(/\[[\s\S]*\]/);
  if (!jsonMatch) {
    console.log('データが見つかりませんでした');
    return;
  }
  
  const data = JSON.parse(jsonMatch[0]);
  const items = data[0]?.results || [];
  
  console.log(`${items.length}件の予約明細を処理します\n`);
  
  // 各明細を変換
  for (const item of items) {
    try {
      const oldParticipants = JSON.parse(item.participants);
      const newParticipants = oldParticipants.map(migrateParticipant);
      const newParticipantsJSON = JSON.stringify(newParticipants);
      
      // SQLエスケープ（シングルクォートを2つにする）
      const escapedJSON = newParticipantsJSON.replace(/'/g, "''");
      
      console.log(`-- 予約明細ID: ${item.id}`);
      console.log(`UPDATE booking_items SET participants = '${escapedJSON}' WHERE id = ${item.id};`);
      console.log('');
    } catch (error) {
      console.error(`明細ID ${item.id} の変換エラー:`, error.message);
    }
  }
}

generateMigrationSQL().catch(console.error);
