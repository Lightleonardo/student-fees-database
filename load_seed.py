import sqlite3

conn = sqlite3.connect('fees.db')
cursor = conn.cursor()
with open('sql/seed.sql', 'r') as f:
    cursor.executescript(f.read())
conn.commit()
conn.close()
print('Seed data loaded successfully')