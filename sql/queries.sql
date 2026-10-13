-- 1. Invoices with an outstanding balance
SELECT
    i.invoice_id,
    s.full_name,
    ft.name AS fee_type,
    i.amount_due,
    COALESCE(SUM(p.amount_paid), 0) AS total_paid,
    COALESCE((SELECT SUM(d.amount) FROM discounts d WHERE d.invoice_id = i.invoice_id), 0) AS total_discount,
    i.amount_due - COALESCE((SELECT SUM(d.amount) FROM discounts d WHERE d.invoice_id = i.invoice_id), 0)
        - COALESCE(SUM(p.amount_paid), 0) AS balance
FROM invoices i
JOIN students s  ON s.student_id = i.student_id
JOIN fee_types ft ON ft.fee_type_id = i.fee_type_id
LEFT JOIN payments p ON p.invoice_id = i.invoice_id
GROUP BY i.invoice_id
HAVING balance > 0;

-- 2. Payment history for a given student
SELECT s.full_name, i.invoice_id, p.payment_date, p.amount_paid, p.method
FROM payments p
JOIN invoices i ON i.invoice_id = p.invoice_id
JOIN students s ON s.student_id = i.student_id
WHERE s.student_id = 1
ORDER BY p.payment_date;

-- 3a. Total collections overall
SELECT SUM(amount_paid) AS total_collections
FROM payments;

-- 3b. Total collections by fee type
SELECT ft.name AS fee_type, SUM(p.amount_paid) AS total_collected
FROM payments p
JOIN invoices i ON i.invoice_id = p.invoice_id
JOIN fee_types ft ON ft.fee_type_id = i.fee_type_id
GROUP BY ft.name;

-- 4. Overdue payments: invoices where due_date < date('now') and balance > 0
SELECT
    i.invoice_id,
    s.full_name,
    ft.name AS fee_type,
    i.amount_due,
    i.due_date,
    COALESCE(SUM(p.amount_paid), 0) AS total_paid,
    COALESCE((SELECT SUM(d.amount) FROM discounts d WHERE d.invoice_id = i.invoice_id), 0) AS total_discount,
    i.amount_due - COALESCE((SELECT SUM(d.amount) FROM discounts d WHERE d.invoice_id = i.invoice_id), 0)
        - COALESCE(SUM(p.amount_paid), 0) AS balance
FROM invoices i
JOIN students s  ON s.student_id = i.student_id
JOIN fee_types ft ON ft.fee_type_id = i.fee_type_id
LEFT JOIN payments p ON p.invoice_id = i.invoice_id
WHERE date(i.due_date) < date('now')
GROUP BY i.invoice_id
HAVING balance > 0;

-- 5. Outstanding balance per student (summed across all invoices)
SELECT
    s.student_id,
    s.full_name,
    COALESCE(inv_totals.total_due, 0) AS total_amount_due,
    COALESCE(disc_totals.total_discount, 0) AS total_discounts,
    COALESCE(pay_totals.total_paid, 0) AS total_payments,
    COALESCE(inv_totals.total_due, 0) - COALESCE(disc_totals.total_discount, 0) - COALESCE(pay_totals.total_paid, 0) AS outstanding_balance
FROM students s
LEFT JOIN (
    SELECT student_id, SUM(amount_due) AS total_due
    FROM invoices
    GROUP BY student_id
) inv_totals ON inv_totals.student_id = s.student_id
LEFT JOIN (
    SELECT i.student_id, SUM(d.amount) AS total_discount
    FROM discounts d
    JOIN invoices i ON i.invoice_id = d.invoice_id
    GROUP BY i.student_id
) disc_totals ON disc_totals.student_id = s.student_id
LEFT JOIN (
    SELECT i.student_id, SUM(p.amount_paid) AS total_paid
    FROM payments p
    JOIN invoices i ON i.invoice_id = p.invoice_id
    GROUP BY i.student_id
) pay_totals ON pay_totals.student_id = s.student_id
WHERE COALESCE(inv_totals.total_due, 0) - COALESCE(disc_totals.total_discount, 0) - COALESCE(pay_totals.total_paid, 0) > 0;

-- 6. Students with no payments at all
SELECT DISTINCT s.student_id, s.full_name, s.email
FROM students s
LEFT JOIN invoices i ON i.student_id = s.student_id
LEFT JOIN payments p ON p.invoice_id = i.invoice_id
WHERE p.payment_id IS NULL;

-- 7a. Total discounts given overall
SELECT SUM(amount) AS total_discounts
FROM discounts;

-- 7b. Total discounts given per fee type
SELECT ft.name AS fee_type, SUM(d.amount) AS total_discounts
FROM discounts d
JOIN invoices i ON i.invoice_id = d.invoice_id
JOIN fee_types ft ON ft.fee_type_id = i.fee_type_id
GROUP BY ft.name;

-- 8. Monthly collections trend
SELECT strftime('%Y-%m', payment_date) AS month, SUM(amount_paid) AS monthly_collections
FROM payments
GROUP BY strftime('%Y-%m', payment_date)
ORDER BY month;