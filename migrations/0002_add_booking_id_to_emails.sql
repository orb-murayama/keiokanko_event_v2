-- booking_emailsテーブルを再作成
DROP TABLE IF EXISTS booking_emails;
CREATE TABLE booking_emails (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER NOT NULL,
  booking_number TEXT NOT NULL,
  from_email TEXT NOT NULL,
  to_email TEXT NOT NULL,
  bcc_email TEXT,
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  scheduled_send_at DATETIME NOT NULL,
  send_status TEXT DEFAULT 'pending',
  sent_at DATETIME,
  error_message TEXT,
  template_id INTEGER,
  created_at DATETIME DEFAULT (datetime('now', 'localtime')),
  modified_at DATETIME DEFAULT (datetime('now', 'localtime')),
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE INDEX idx_booking_emails_booking_id ON booking_emails(booking_id);
CREATE INDEX idx_booking_emails_booking_number ON booking_emails(booking_number);
CREATE INDEX idx_booking_emails_send_status ON booking_emails(send_status);
