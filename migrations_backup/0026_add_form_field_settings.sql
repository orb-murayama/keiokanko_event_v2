-- eventsテーブルに申込フォームの項目設定を追加
-- JSON形式で各項目のON/OFF設定を保存

ALTER TABLE events ADD COLUMN form_field_settings TEXT DEFAULT '{"name_kanji":true,"name_kana":true,"name_roma":false,"address":true,"tel":true,"birth_date":false,"age":false}';

-- デフォルト設定:
-- name_kanji: 名前（漢字）- ON
-- name_kana: 名前（カナ）- ON
-- name_roma: 名前（ローマ字）- OFF
-- address: 住所 - ON
-- tel: 連絡先電話番号 - ON
-- birth_date: 生年月日 - OFF
-- age: 年齢 - OFF
