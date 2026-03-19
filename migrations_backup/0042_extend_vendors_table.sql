-- 販売会社テーブルに主催者管理と同様の項目を追加

-- 基本情報
ALTER TABLE vendors ADD COLUMN vendor_code TEXT; -- 販売会社コード
ALTER TABLE vendors ADD COLUMN branch_office TEXT; -- 部署・支店名

-- 所在地情報
ALTER TABLE vendors ADD COLUMN zip TEXT; -- 郵便番号
ALTER TABLE vendors ADD COLUMN pref_id INTEGER; -- 都道府県ID
ALTER TABLE vendors ADD COLUMN addr TEXT; -- 住所

-- 連絡先情報
ALTER TABLE vendors ADD COLUMN fax TEXT; -- FAX番号
ALTER TABLE vendors ADD COLUMN contactable_person TEXT; -- 連絡可能担当者名
ALTER TABLE vendors ADD COLUMN position TEXT; -- 役職

-- 営業情報
ALTER TABLE vendors ADD COLUMN business_hours TEXT; -- 営業時間
ALTER TABLE vendors ADD COLUMN closed_days TEXT; -- 定休日
ALTER TABLE vendors ADD COLUMN business_notes TEXT; -- 営業に関する備考

-- 登録情報
ALTER TABLE vendors ADD COLUMN registration_number TEXT; -- 観光庁登録番号
ALTER TABLE vendors ADD COLUMN association_name TEXT; -- 協会名
ALTER TABLE vendors ADD COLUMN association_membership TEXT; -- 会員情報
ALTER TABLE vendors ADD COLUMN travel_manager_title TEXT; -- 旅行業務取扱管理者役職
ALTER TABLE vendors ADD COLUMN travel_manager_name TEXT; -- 旅行業務取扱管理者名

-- その他
ALTER TABLE vendors ADD COLUMN remarks TEXT; -- 備考
ALTER TABLE vendors ADD COLUMN group_id INTEGER DEFAULT 1; -- グループID
ALTER TABLE vendors ADD COLUMN reg_flg INTEGER DEFAULT 1; -- 公開状態フラグ (1: 有効, 0: 無効)

-- 外部キー制約用インデックス
CREATE INDEX IF NOT EXISTS idx_vendors_pref_id ON vendors(pref_id);
CREATE INDEX IF NOT EXISTS idx_vendors_reg_flg ON vendors(reg_flg);
CREATE INDEX IF NOT EXISTS idx_vendors_group_id ON vendors(group_id);
