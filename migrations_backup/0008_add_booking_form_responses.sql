-- 予約時のカスタムフォームフィールド回答テーブル
CREATE TABLE IF NOT EXISTS booking_form_responses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  field_id INTEGER NOT NULL,
  field_name TEXT NOT NULL,
  field_value TEXT,
  created_at TEXT DEFAULT (datetime('now', 'localtime')),
  modified_at TEXT DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (field_id) REFERENCES event_form_fields(id)
);

CREATE INDEX idx_booking_form_responses_customer_id ON booking_form_responses(customer_id);
CREATE INDEX idx_booking_form_responses_event_id ON booking_form_responses(event_id);
CREATE INDEX idx_booking_form_responses_field_id ON booking_form_responses(field_id);
