import sqlite3

conn = sqlite3.connect('fees.db')
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

with open('sql/queries.sql', 'r') as f:
    content = f.read()

# Split queries by semicolon
queries = []
current_query = ""
for line in content.split('\n'):
    current_query += line + '\n'
    if line.strip().endswith(';'):
        queries.append(current_query.strip())
        current_query = ""

if current_query.strip():
    queries.append(current_query.strip())

# Query descriptions
descriptions = [
    "Invoices with an outstanding balance",
    "Payment history for a given student (student_id=1)",
    "Total collections overall",
    "Total collections by fee type",
    "Overdue payments (due_date < today and balance > 0)",
    "Outstanding balance per student (summed across all invoices)",
    "Students with no payments at all",
    "Total discounts given overall",
    "Total discounts given per fee type",
    "Monthly collections trend"
]

with open('results/query_results.md', 'w') as out:
    out.write("# Query Results\n\n")
    out.write("Output of each query against the seed data.\n\n")
    
    for i, (query, desc) in enumerate(zip(queries, descriptions), 1):
        out.write(f"## Query {i}: {desc}\n\n")
        out.write("```sql\n")
        out.write(query + "\n")
        out.write("```\n\n")
        
        try:
            cursor.execute(query)
            results = cursor.fetchall()
            
            if results:
                cols = [description[0] for description in cursor.description]
                # Write header
                out.write("| " + " | ".join(cols) + " |\n")
                out.write("| " + " | ".join(["---"] * len(cols)) + " |\n")
                
                for row in results:
                    out.write("| " + " | ".join(str(row[col]) for col in cols) + " |\n")
            else:
                out.write("(no results)\n")
            out.write("\n")
        except Exception as e:
            out.write(f"**ERROR**: {e}\n\n")

conn.close()
print("Results captured to results/query_results.md")