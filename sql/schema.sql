CREATE TABLE students (
    student_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    enrollment_date TEXT NOT NULL,
    status          TEXT NOT NULL DEFAULT 'active'
);

CREATE TABLE fee_types (
    fee_type_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL UNIQUE,
    description     TEXT,
    default_amount  NUMERIC NOT NULL CHECK (default_amount >= 0)
);

CREATE TABLE invoices (
    invoice_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id      INTEGER NOT NULL REFERENCES students(student_id),
    fee_type_id     INTEGER NOT NULL REFERENCES fee_types(fee_type_id),
    amount_due      NUMERIC NOT NULL CHECK (amount_due >= 0),
    issue_date      TEXT NOT NULL,
    due_date        TEXT NOT NULL,
    status          TEXT NOT NULL DEFAULT 'open'
);

CREATE TABLE discounts (
    discount_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_id      INTEGER NOT NULL REFERENCES invoices(invoice_id),
    description     TEXT NOT NULL,
    amount          NUMERIC NOT NULL CHECK (amount >= 0)
);

CREATE TABLE payments (
    payment_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_id      INTEGER NOT NULL REFERENCES invoices(invoice_id),
    amount_paid     NUMERIC NOT NULL CHECK (amount_paid > 0),
    payment_date    TEXT NOT NULL,
    method          TEXT NOT NULL
);

-- Indexes: speed up the lookups the required queries will do most often
CREATE INDEX idx_invoices_student_id ON invoices(student_id);
CREATE INDEX idx_invoices_due_date   ON invoices(due_date);
CREATE INDEX idx_payments_invoice_id ON payments(invoice_id);
CREATE INDEX idx_discounts_invoice_id ON discounts(invoice_id);