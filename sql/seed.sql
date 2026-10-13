INSERT INTO students (full_name, email, enrollment_date, status) VALUES
  ('Ada Obi', 'ada.obi@example.com', '2026-01-15', 'active'),
  ('Bello Musa', 'bello.musa@example.com', '2026-01-20', 'active'),
  ('Chinwe Okonkwo', 'chinwe.okonkwo@example.com', '2026-02-01', 'active'),
  ('David Adebayo', 'david.adebayo@example.com', '2026-02-10', 'active'),
  ('Efe Okafor', 'efe.okafor@example.com', '2026-02-15', 'active'),
  ('Fatima Yusuf', 'fatima.yusuf@example.com', '2026-03-01', 'active'),
  ('Grace Nwosu', 'grace.nwosu@example.com', '2026-03-05', 'inactive'),
  ('Hassan Ibrahim', 'hassan.ibrahim@example.com', '2026-03-10', 'active');

INSERT INTO fee_types (name, description, default_amount) VALUES
  ('Tuition', 'Semester tuition fee', 150000),
  ('Library', 'Library access fee', 15000),
  ('Lab', 'Laboratory fee', 25000),
  ('Exam', 'Examination fee', 10000),
  ('Late Fee', 'Late payment penalty', 5000);

INSERT INTO invoices (student_id, fee_type_id, amount_due, issue_date, due_date, status) VALUES
  (1, 1, 150000, '2026-01-15', '2026-02-15', 'open'),
  (1, 2, 15000, '2026-01-15', '2026-02-20', 'open'),
  (1, 3, 25000, '2026-01-20', '2026-03-01', 'open');

INSERT INTO invoices (student_id, fee_type_id, amount_due, issue_date, due_date, status) VALUES
  (2, 1, 150000, '2026-01-20', '2026-02-20', 'open'),
  (2, 4, 10000, '2026-02-01', '2026-02-28', 'open');

INSERT INTO invoices (student_id, fee_type_id, amount_due, issue_date, due_date, status) VALUES
  (3, 1, 150000, '2026-02-01', '2026-03-01', 'open'),
  (3, 2, 15000, '2026-02-01', '2026-03-05', 'open'),
  (3, 5, 5000, '2026-02-15', '2026-02-28', 'open');

INSERT INTO invoices (student_id, fee_type_id, amount_due, issue_date, due_date, status) VALUES
  (4, 1, 150000, '2026-02-10', '2026-04-10', 'open'),
  (4, 3, 25000, '2026-02-15', '2026-04-15', 'open');

INSERT INTO invoices (student_id, fee_type_id, amount_due, issue_date, due_date, status) VALUES
  (5, 1, 150000, '2026-02-15', '2026-03-15', 'open'),
  (5, 2, 15000, '2026-02-15', '2026-03-20', 'open');

INSERT INTO invoices (student_id, fee_type_id, amount_due, issue_date, due_date, status) VALUES
  (6, 1, 150000, '2026-03-01', '2026-04-01', 'open'),
  (6, 4, 10000, '2026-03-01', '2026-04-05', 'open');

INSERT INTO invoices (student_id, fee_type_id, amount_due, issue_date, due_date, status) VALUES
  (7, 1, 150000, '2026-03-05', '2026-04-05', 'open');

INSERT INTO invoices (student_id, fee_type_id, amount_due, issue_date, due_date, status) VALUES
  (8, 1, 150000, '2026-03-10', '2026-04-10', 'open'),
  (8, 3, 25000, '2026-03-10', '2026-04-15', 'open'),
  (8, 5, 5000, '2026-03-15', '2026-03-25', 'open');

INSERT INTO discounts (invoice_id, description, amount) VALUES
  (1, 'Early bird discount', 10000),
  (3, 'Scholarship discount', 5000),
  (5, 'Sibling discount', 15000),
  (9, 'Merit discount', 20000),
  (13, 'Financial aid', 25000);

INSERT INTO payments (invoice_id, amount_paid, payment_date, method) VALUES
  (1, 50000, '2026-02-01', 'bank_transfer'),
  (1, 20000, '2026-02-10', 'card');

INSERT INTO payments (invoice_id, amount_paid, payment_date, method) VALUES
  (4, 135000, '2026-02-15', 'bank_transfer');

INSERT INTO payments (invoice_id, amount_paid, payment_date, method) VALUES
  (10, 80000, '2026-03-01', 'bank_transfer');

INSERT INTO payments (invoice_id, amount_paid, payment_date, method) VALUES
  (12, 150000, '2026-03-20', 'bank_transfer'),
  (13, 10000, '2026-03-22', 'card');

INSERT INTO payments (invoice_id, amount_paid, payment_date, method) VALUES
  (14, 75000, '2026-03-25', 'bank_transfer');