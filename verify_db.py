import sqlite3

conn = sqlite3.connect('fees.db')
cursor = conn.cursor()
cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = cursor.fetchall()
print("Tables:", tables)

# Verify each table structure
for table in tables:
    cursor.execute(f"PRAGMA table_info({table[0]})")
    columns = cursor.fetchall()
    print(f"\n{table[0]} columns:")
    for col in columns:
        print(f"  {col}")

# Check indexes
cursor.execute("SELECT name FROM sqlite_master WHERE type='index'")
indexes = cursor.fetchall()
print("\nIndexes:", indexes)

conn.close()