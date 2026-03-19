-- 商品カテゴリー テーブル定義とテストデータ
-- product_categories

-- ========================================
-- テーブル定義 (DDL)
-- ========================================

CREATE TABLE IF NOT EXISTS product_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime'))
);

-- product_categoriesテーブルのインデックス
CREATE INDEX IF NOT EXISTS idx_product_categories_name ON product_categories(name);

-- ========================================
-- データインポート
-- ========================================

-- 商品カテゴリーのテストデータ
INSERT OR REPLACE INTO product_categories (id, name, description, created_at, modified_at) VALUES
  (1, 'チケット', 'イベント入場券やコンサートチケット', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (2, 'スポーツ参加', 'マラソンや競技大会への参加権', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (3, 'コンサート', 'コンサートやライブのチケット', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (4, 'グルメ', '食べ歩きチケットや食事プラン', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (5, 'ツアー', '旅行パッケージやツアープラン', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (6, 'セミナー', 'ビジネスセミナーや講座', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (7, '教室', 'プログラミング教室や体験教室', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (8, 'リトリート', 'ヨガや瞑想のリトリート', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (9, 'エンターテイメント', 'お笑いライブやショー', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (10, 'ショッピング', 'セールやショッピングイベント', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (11, '宿泊', 'ホテルや旅館の宿泊プラン', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (12, '交通', 'バスツアーや交通チケット', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (13, '物販', 'グッズや商品の販売', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (14, 'レンタル', '機材やスペースのレンタル', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (15, '体験', '体験イベントやアクティビティ', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (16, '展示会', '展示会や博覧会の入場券', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (17, '映画', '映画鑑賞券や試写会チケット', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (18, '演劇', '演劇やミュージカルのチケット', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (19, 'スパ・温泉', 'スパや温泉施設の利用券', datetime('now', 'localtime'), datetime('now', 'localtime')),
  (20, 'その他', 'その他の商品・サービス', datetime('now', 'localtime'), datetime('now', 'localtime'));

-- ========================================
-- カテゴリー説明
-- ========================================

-- 1. チケット: イベント、コンサート、スポーツ観戦などの入場券
-- 2. スポーツ参加: マラソン大会、競技会などへの参加権
-- 3. コンサート: 音楽コンサート、ライブイベントのチケット
-- 4. グルメ: 食事券、食べ歩きチケット、レストラン予約
-- 5. ツアー: 日帰りツアー、宿泊ツアー、観光パッケージ
-- 6. セミナー: ビジネスセミナー、講演会、研修
-- 7. 教室: 習い事教室、ワークショップ、講座
-- 8. リトリート: ヨガ、瞑想、ウェルネスリトリート
-- 9. エンターテイメント: お笑いライブ、ショー、パフォーマンス
-- 10. ショッピング: セール、ショッピングイベント、物産展
-- 11. 宿泊: ホテル、旅館、民泊の宿泊プラン
-- 12. 交通: バスツアー、鉄道チケット、送迎サービス
-- 13. 物販: イベントグッズ、記念品、関連商品の販売
-- 14. レンタル: 機材レンタル、スペースレンタル
-- 15. 体験: 体験型イベント、アクティビティ、手作り体験
-- 16. 展示会: 美術展、博覧会、企業展示会の入場券
-- 17. 映画: 映画鑑賞券、試写会、映画祭
-- 18. 演劇: 演劇、ミュージカル、舞台のチケット
-- 19. スパ・温泉: スパ施設、温泉、リラクゼーション施設
-- 20. その他: 上記に分類されないその他の商品・サービス
