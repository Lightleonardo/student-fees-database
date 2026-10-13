import sqlite3

conn = sqlite3.connect('fees.db')
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

with open('sql/queries.sql', 'r') as f:
    content = f.read()

# Split queries by double semicolon or single semicolon at end of line
queries = []
current_query = ""
for line in content.split('\n'):
    stripped = line.strip()
    if stripped.startswith('--') and current_query:
        # Comment line, add to current query
        current_query += line + '\n'
    elif stripped and not stripped.startswith('--'):
        current_query += line + '\n'
        if line.strip().endswith(';'):
            queries.append(current_query.strip())
            current_query = ""
    else:
        current_query += line + '\n'

if current_query.strip():
    queries.append(current_query.strip())

print(f"Found {len(queries)} queries\n")

for i, query in enumerate(queries, 1):
    print(f"Query {i}:")
    print(query[:100] + "..." if len(query) > 100 else query)
    print()
    
    try:
        cursor.execute(query)
        results = cursor.fetchall()
        
        if results:
            # Print column headers
            cols = [description[0] for description in cursor.description]
            print(" | ".join(cols))
            print("-" * (sum(len(c) for c in cols) + 3 * (len(cols) - 1)))
            
            for row in results:
                print(" | ".join(str(row[col]) for col in cols))
        else:
            print("(no results)")
        print()
    except Exception as e:
        print(f"ERROR: {e}\n")

conn.close()