import sqlite3

conn = sqlite3.connect('fees.db')
cursor = conn.cursor()

tables = ['students', 'fee_types', 'invoices', 'discounts', 'payments']
for table in tables:
    cursor.execute(f"SELECT COUNT(*) FROM {table}")
    count = cursor.fetchone()[0]
    print(f"{table}: {count} rows")

conn.close()