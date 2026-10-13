# Student Fees Database

A relational database for managing students, fee types, invoices, payments,
discounts, and outstanding balances, with SQL queries to answer common
billing questions.

## Domain

A school tracks students, the types of fees it charges (tuition, library, exam fees, etc.), invoices issued to students for those fees, discounts applied to specific invoices, and payments students make against those invoices. The system needs to answer: who owes money, who's paid what, how much has been collected, and who's overdue. This design uses a normalized schema with five tables in third normal form, avoiding redundancy by calculating outstanding balances on the fly rather than storing them.

## Setup

Requires SQLite (`sqlite3` command, or DB Browser for SQLite as a GUI client).

The database is included as `fees.db`. To rebuild it from scratch instead:

```bash
sqlite3 fees.db < sql/schema.sql
sqlite3 fees.db < sql/seed.sql
```

Or using Python:

```bash
python create_db.py
python load_seed.py
```

## Running the queries

```bash
sqlite3 fees.db < sql/queries.sql
```

Or open `fees.db` in DB Browser for SQLite and run individual queries from
`sql/queries.sql` under the "Execute SQL" tab.

To run queries and see formatted results with Python:

```bash
python run_queries.py
```

## Files

| Path | Contents |
|---|---|
| `erd/schema.png` | Entity-relationship diagram |
| `erd/schema.dbml` | dbdiagram.io source for ERD |
| `sql/schema.sql` | Table definitions, keys, constraints, indexes |
| `sql/seed.sql` | Sample student, invoice, payment, and discount data |
| `sql/queries.sql` | 8+ queries answering common billing questions |
| `results/query_results.md` | Output of each query against the seed data |
| `DATA_QUALITY.md` | Note on how data quality affects downstream AI systems |

## Schema Design Notes

**Why these 5 tables**: The domain naturally decomposes into five entities—students, fee_types, invoices, discounts, and payments—each with a single responsibility. Students and fee_types are reference tables; invoices link them with amount, dates, and status; discounts and payments are child tables of invoices, allowing multiple of each per invoice (installment payments, multiple discounts). This is a clean one-to-many chain in every direction, keeping the schema in 3NF.

**Why outstanding balance is calculated rather than stored**: Outstanding balance = `amount_due - discounts - payments` for each invoice. Storing a redundant "balance" column would require keeping it in sync manually on every payment or discount change—a classic source of bugs and data inconsistency. A query derives it instead, guaranteeing it always reflects the current state of its components.

**Why these specific indexes**: The four indexes (`idx_invoices_student_id`, `idx_invoices_due_date`, `idx_payments_invoice_id`, `idx_discounts_invoice_id`) target the foreign keys used in joins and the `due_date` column filtered by the overdue query. Without them, SQLite would scan every row for each lookup; with them, joins and filters use B-tree lookups, which is critical as data grows.