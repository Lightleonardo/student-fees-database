import sqlite3

conn = sqlite3.connect('fees.db')
cursor = conn.cursor()
with open('sql/schema.sql', 'r') as f:
    cursor.executescript(f.read())
conn.commit()
conn.close()
print('Database schema created successfully')