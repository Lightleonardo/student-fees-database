# Query Results

Output of each query against the seed data.

## Query 1: Invoices with an outstanding balance

```sql
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
```

| invoice_id | full_name | fee_type | amount_due | total_paid | total_discount | balance |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Ada Obi | Tuition | 150000 | 70000 | 10000 | 70000 |
| 2 | Ada Obi | Library | 15000 | 0 | 0 | 15000 |
| 3 | Ada Obi | Lab | 25000 | 0 | 5000 | 20000 |
| 4 | Bello Musa | Tuition | 150000 | 135000 | 0 | 15000 |
| 6 | Chinwe Okonkwo | Tuition | 150000 | 0 | 0 | 150000 |
| 7 | Chinwe Okonkwo | Library | 15000 | 0 | 0 | 15000 |
| 8 | Chinwe Okonkwo | Late Fee | 5000 | 0 | 0 | 5000 |
| 9 | David Adebayo | Tuition | 150000 | 0 | 20000 | 130000 |
| 11 | Efe Okafor | Tuition | 150000 | 0 | 0 | 150000 |
| 13 | Fatima Yusuf | Tuition | 150000 | 10000 | 25000 | 115000 |
| 15 | Grace Nwosu | Tuition | 150000 | 0 | 0 | 150000 |
| 16 | Hassan Ibrahim | Tuition | 150000 | 0 | 0 | 150000 |
| 17 | Hassan Ibrahim | Lab | 25000 | 0 | 0 | 25000 |
| 18 | Hassan Ibrahim | Late Fee | 5000 | 0 | 0 | 5000 |

## Query 2: Payment history for a given student (student_id=1)

```sql
-- 2. Payment history for a given student
SELECT s.full_name, i.invoice_id, p.payment_date, p.amount_paid, p.method
FROM payments p
JOIN invoices i ON i.invoice_id = p.invoice_id
JOIN students s ON s.student_id = i.student_id
WHERE s.student_id = 1
ORDER BY p.payment_date;
```

| full_name | invoice_id | payment_date | amount_paid | method |
| --- | --- | --- | --- | --- |
| Ada Obi | 1 | 2026-02-01 | 50000 | bank_transfer |
| Ada Obi | 1 | 2026-02-10 | 20000 | card |

## Query 3: Total collections overall

```sql
-- 3a. Total collections overall
SELECT SUM(amount_paid) AS total_collections
FROM payments;
```

| total_collections |
| --- |
| 520000 |

## Query 4: Total collections by fee type

```sql
-- 3b. Total collections by fee type
SELECT ft.name AS fee_type, SUM(p.amount_paid) AS total_collected
FROM payments p
JOIN invoices i ON i.invoice_id = p.invoice_id
JOIN fee_types ft ON ft.fee_type_id = i.fee_type_id
GROUP BY ft.name;
```

| fee_type | total_collected |
| --- | --- |
| Exam | 75000 |
| Lab | 80000 |
| Library | 150000 |
| Tuition | 215000 |

## Query 5: Overdue payments (due_date < today and balance > 0)

```sql
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
```

| invoice_id | full_name | fee_type | amount_due | due_date | total_paid | total_discount | balance |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Ada Obi | Tuition | 150000 | 2026-02-15 | 70000 | 10000 | 70000 |
| 2 | Ada Obi | Library | 15000 | 2026-02-20 | 0 | 0 | 15000 |
| 3 | Ada Obi | Lab | 25000 | 2026-03-01 | 0 | 5000 | 20000 |
| 4 | Bello Musa | Tuition | 150000 | 2026-02-20 | 135000 | 0 | 15000 |
| 6 | Chinwe Okonkwo | Tuition | 150000 | 2026-03-01 | 0 | 0 | 150000 |
| 7 | Chinwe Okonkwo | Library | 15000 | 2026-03-05 | 0 | 0 | 15000 |
| 8 | Chinwe Okonkwo | Late Fee | 5000 | 2026-02-28 | 0 | 0 | 5000 |
| 9 | David Adebayo | Tuition | 150000 | 2026-04-10 | 0 | 20000 | 130000 |
| 11 | Efe Okafor | Tuition | 150000 | 2026-03-15 | 0 | 0 | 150000 |
| 13 | Fatima Yusuf | Tuition | 150000 | 2026-04-01 | 10000 | 25000 | 115000 |
| 15 | Grace Nwosu | Tuition | 150000 | 2026-04-05 | 0 | 0 | 150000 |
| 16 | Hassan Ibrahim | Tuition | 150000 | 2026-04-10 | 0 | 0 | 150000 |
| 17 | Hassan Ibrahim | Lab | 25000 | 2026-04-15 | 0 | 0 | 25000 |
| 18 | Hassan Ibrahim | Late Fee | 5000 | 2026-03-25 | 0 | 0 | 5000 |

## Query 6: Outstanding balance per student (summed across all invoices)

```sql
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
```

| student_id | full_name | total_amount_due | total_discounts | total_payments | outstanding_balance |
| --- | --- | --- | --- | --- | --- |
| 1 | Ada Obi | 190000 | 15000 | 70000 | 105000 |
| 2 | Bello Musa | 160000 | 15000 | 135000 | 10000 |
| 3 | Chinwe Okonkwo | 170000 | 0 | 0 | 170000 |
| 4 | David Adebayo | 175000 | 20000 | 80000 | 75000 |
| 5 | Efe Okafor | 165000 | 0 | 150000 | 15000 |
| 6 | Fatima Yusuf | 160000 | 25000 | 85000 | 50000 |
| 7 | Grace Nwosu | 150000 | 0 | 0 | 150000 |
| 8 | Hassan Ibrahim | 180000 | 0 | 0 | 180000 |

## Query 7: Students with no payments at all

```sql
-- 6. Students with no payments at all
SELECT s.student_id, s.full_name, s.email
FROM students s
WHERE NOT EXISTS (
    SELECT 1 FROM invoices i
    JOIN payments p ON p.invoice_id = i.invoice_id
    WHERE i.student_id = s.student_id
);
```

| student_id | full_name | email |
| --- | --- | --- |
| 3 | Chinwe Okonkwo | chinwe.okonkwo@example.com |
| 7 | Grace Nwosu | grace.nwosu@example.com |
| 8 | Hassan Ibrahim | hassan.ibrahim@example.com |

## Query 8: Total discounts given overall

```sql
-- 7a. Total discounts given overall
SELECT SUM(amount) AS total_discounts
FROM discounts;
```

| total_discounts |
| --- |
| 75000 |

## Query 9: Total discounts given per fee type

```sql
-- 7b. Total discounts given per fee type
SELECT ft.name AS fee_type, SUM(d.amount) AS total_discounts
FROM discounts d
JOIN invoices i ON i.invoice_id = d.invoice_id
JOIN fee_types ft ON ft.fee_type_id = i.fee_type_id
GROUP BY ft.name;
```

| fee_type | total_discounts |
| --- | --- |
| Exam | 15000 |
| Lab | 5000 |
| Tuition | 55000 |

## Query 10: Monthly collections trend

```sql
-- 8. Monthly collections trend
SELECT strftime('%Y-%m', payment_date) AS month, SUM(amount_paid) AS monthly_collections
FROM payments
GROUP BY strftime('%Y-%m', payment_date)
ORDER BY month;
```

| month | monthly_collections |
| --- | --- |
| 2026-02 | 205000 |
| 2026-03 | 315000 |

