-- オプション商品のテストデータ
-- 東京1日観光ツアー（event_id=3）用のオプション

-- お食事カテゴリー
INSERT INTO options (id, event_id, name, description, remarks, option_category_id, cancel_policy, note, enable_flg, created_at, modified_at, deleted_at, image_url) VALUES
(1, 3, '特選お弁当', '東京の老舗料亭が作る特選弁当。季節の食材を使った彩り豊かなお弁当です。', 'アレルギー対応可能。予約時にお知らせください。', 1, 'ツアー3日前まで無料キャンセル可能', '昼食時に配布いたします', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/4CAF50/ffffff?text=Special+Bento'),
(2, 3, 'ベジタリアン弁当', '野菜中心のヘルシーなお弁当。ビーガン対応も可能です。', '完全菜食主義の方にも対応可能', 1, 'ツアー3日前まで無料キャンセル可能', '事前にご希望をお知らせください', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/8BC34A/ffffff?text=Vegetarian+Bento'),
(3, 3, '浅草ランチクーポン', '浅草の提携レストランで使える2,000円分のランチクーポン。', '複数店舗から選択可能', 1, 'ツアー当日まで変更可能', '未使用の場合の返金不可', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/FF9800/ffffff?text=Lunch+Coupon');

-- 交通・送迎カテゴリー
INSERT INTO options (id, event_id, name, description, remarks, option_category_id, cancel_policy, note, enable_flg, created_at, modified_at, deleted_at, image_url) VALUES
(4, 3, 'ホテル送迎サービス', '都内主要ホテルからの往復送迎サービス。', '対象エリア：山手線内の主要ホテル', 2, 'ツアー前日17時まで無料キャンセル可能', '早朝7:00-8:00の間にお迎えに参ります', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/2196F3/ffffff?text=Hotel+Pickup'),
(5, 3, '空港送迎サービス', '成田・羽田空港からの往復送迎サービス。', '前日までの予約が必要です', 2, 'ツアー2日前まで無料キャンセル可能', 'フライト情報を事前にお知らせください', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/03A9F4/ffffff?text=Airport+Transfer');

-- 施設入場券カテゴリー
INSERT INTO options (id, event_id, name, description, remarks, option_category_id, cancel_policy, note, enable_flg, created_at, modified_at, deleted_at, image_url) VALUES
(6, 3, '東京スカイツリー天望回廊券', 'スカイツリー天望回廊（地上450m）への入場券。', '通常のツアーに含まれる天望デッキ（350m）に加えて、さらに高い天望回廊にも入場可能', 3, 'ツアー当日まで変更可能', '混雑時は待ち時間が発生する場合があります', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/9C27B0/ffffff?text=Sky+Tree+Ticket'),
(7, 3, '東京タワー入場券', '東京タワー大展望台（150m）への入場券。', 'ツアー行程に含まれない追加スポット', 3, 'ツアー当日まで変更可能', '自由時間に各自で訪問してください', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/E91E63/ffffff?text=Tokyo+Tower'),
(8, 3, '浅草寺お守りセット', '浅草寺の縁起物お守り3点セット（交通安全・学業成就・健康祈願）。', '浅草寺参拝時にお渡しします', 3, '返品・交換不可', '記念品として大変人気があります', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/F44336/ffffff?text=Omamori+Set');

-- お土産・グッズカテゴリー
INSERT INTO options (id, event_id, name, description, remarks, option_category_id, cancel_policy, note, enable_flg, created_at, modified_at, deleted_at, image_url) VALUES
(9, 3, '東京みやげセット', '東京名物の詰め合わせセット（東京ばな奈、雷おこし、人形焼など）。', '6種類の人気お土産', 4, 'ツアー前日まで変更可能', 'ツアー終了時にお渡しします', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/FF5722/ffffff?text=Souvenir+Set'),
(10, 3, 'オリジナルTシャツ', 'ツアー記念オリジナルTシャツ（サイズ：S/M/L/XL）。', 'サイズを予約時にお知らせください', 4, 'ツアー3日前まで変更可能', 'デザインは当日のお楽しみ', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/795548/ffffff?text=Original+Tshirt');

-- 写真撮影カテゴリー
INSERT INTO options (id, event_id, name, description, remarks, option_category_id, cancel_policy, note, enable_flg, created_at, modified_at, deleted_at, image_url) VALUES
(11, 3, 'プロカメラマン同行撮影', 'プロカメラマンがツアー中に同行し、記念写真を撮影します（30枚以上保証）。', 'データは後日ダウンロード可能', 5, 'ツアー5日前まで無料キャンセル可能', '撮影データは1週間以内にお届けします', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/3F51B5/ffffff?text=Photo+Service'),
(12, 3, '集合写真プリント', 'ツアー参加者全員での集合写真をプロが撮影しプリントします（A4サイズ）。', '1グループ1枚', 5, 'ツアー当日まで追加可能', 'ツアー終了時にお渡しします', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/673AB7/ffffff?text=Group+Photo');

-- 保険・サポートカテゴリー
INSERT INTO options (id, event_id, name, description, remarks, option_category_id, cancel_policy, note, enable_flg, created_at, modified_at, deleted_at, image_url) VALUES
(13, 3, '旅行保険プラス', '通常の旅行保険に加えて、携行品損害・疾病治療費用を手厚く補償。', '最大500万円まで補償', 6, 'ツアー前日まで加入可能', '万が一の事故や病気に備えて安心', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/009688/ffffff?text=Insurance+Plus'),
(14, 3, '日本語ガイド追加', '英語ガイドに加えて日本語ガイドも同行します。', '日本語での詳しい説明をご希望の方に', 6, 'ツアー3日前まで変更可能', '少人数制のためお早めにお申し込みください', 1, '2026-02-18 10:00:00', '2026-02-18 10:00:00', NULL, 'https://placehold.co/400x300/00BCD4/ffffff?text=Japanese+Guide');
