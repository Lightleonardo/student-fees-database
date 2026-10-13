# Data Quality Note: How Data Quality Affects Downstream AI Systems

## Garbage In, Garbage Out

An AI model trained on or querying this student fees database—whether a chatbot answering "has this student paid?" or a predictive model identifying students at risk of dropping out due to unpaid fees—is only as reliable as the underlying data. A missing payment record, a wrongly entered `amount_due`, or a duplicate invoice would directly corrupt that output. If the database shows a student as having an outstanding balance when they've actually paid in full, an AI-driven collections bot might send an unnecessary reminder, damaging trust. Conversely, if a payment is missing, a risk model might fail to flag a genuinely at-risk student. The principle is simple: **data quality is model quality**.

## Specific Risks in This Schema

Several design choices in this schema create specific data quality risks that would propagate to downstream AI systems:

**Duplicate student records** — The `email` column has a `UNIQUE` constraint, but in practice, typos (e.g., `ada.obi@exampl.com` vs `ada.obi@example.com`) or students registering with different email addresses would create duplicate identities. An AI model predicting payment behavior would see two "different" students with fragmented payment histories, diluting its learning signal and potentially missing risk patterns.

**Inconsistent `payment_date` semantics** — The schema stores `payment_date` as TEXT without enforcing a single interpretation. In practice, some systems log the transaction date (when the student initiated payment), others the reconciliation date (when the bank confirmed it), and others the posting date (when the bursar applied it). If an AI model uses this field to predict cash flow or detect seasonal payment patterns, mixing these semantics introduces noise that degrades forecasting accuracy.

**Discount audit trail gaps** — Discounts are stored as free-text `description` with an `amount`. There's no standardized discount code, no approval workflow tracking, and no link to who authorized it. If discounts are applied inconsistently—some students getting "merit" discounts without clear criteria—an AI fairness audit would find unexplained variance in net amounts due across similar students, raising bias concerns that the schema cannot explain or resolve.

## How Constraints Help

The schema's constraints aren't just SQL formalities; they're a first line of defense against the kind of bad data that quietly poisons downstream analytics or AI systems:

- **`NOT NULL` constraints** on `full_name`, `email`, `amount_due`, `issue_date`, `due_date` prevent incomplete records that would cause NULL propagation in queries, leading to missing rows in AI training sets.
- **`CHECK (amount_due >= 0)` and `CHECK (amount_paid > 0)`** reject negative or zero payments that would flip balance calculations and confuse any model learning "payment reduces debt."
- **Foreign keys** (`student_id`, `fee_type_id`, `invoice_id`) ensure referential integrity: no payment can exist for a non-existent invoice, no discount for a phantom student. This prevents orphaned records that would appear as data anomalies to an ML pipeline.
- **`UNIQUE` on `email` and `fee_types.name`** prevents the duplicate identity and duplicate fee type problems described above.

These constraints reject invalid rows *before they're written*, which is vastly cheaper than cleaning them up after they've corrupted a training dataset or biased a production model.

## What This Schema Still Doesn't Guarantee

Constraints catch *structural* problems—a negative payment, an invoice pointing to a student that doesn't exist—but not *semantic* ones. A correct-looking but wrong `amount_due` (e.g., 15000 instead of 150000), a payment logged against the wrong invoice, or a discount applied without proper authorization—all pass constraints but corrupt the data's meaning. Data quality is bigger than schema design alone; it requires application-level validation, audit logs, reconciliation processes, and human oversight. The schema provides the foundation, but the building on top must be maintained.