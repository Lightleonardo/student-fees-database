import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch
import numpy as np

fig, ax = plt.subplots(1, 1, figsize=(14, 8))
ax.set_xlim(0, 14)
ax.set_ylim(0, 8)
ax.axis('off')

# Define table positions and colors
tables = {
    'students': {'pos': (1, 6), 'color': '#e3f2fd', 'fields': ['student_id (PK)', 'full_name', 'email (UNIQUE)', 'enrollment_date', 'status']},
    'fee_types': {'pos': (1, 2), 'color': '#e8f5e9', 'fields': ['fee_type_id (PK)', 'name (UNIQUE)', 'description', 'default_amount']},
    'invoices': {'pos': (6, 4), 'color': '#fff3e0', 'fields': ['invoice_id (PK)', 'student_id (FK)', 'fee_type_id (FK)', 'amount_due', 'issue_date', 'due_date', 'status']},
    'discounts': {'pos': (11, 6), 'color': '#fce4ec', 'fields': ['discount_id (PK)', 'invoice_id (FK)', 'description', 'amount']},
    'payments': {'pos': (11, 2), 'color': '#f3e5f5', 'fields': ['payment_id (PK)', 'invoice_id (FK)', 'amount_paid', 'payment_date', 'method']},
}

# Draw tables
for name, info in tables.items():
    x, y = info['pos']
    fields = info['fields']
    height = 0.4 + len(fields) * 0.35
    width = 3.5
    
    # Table background
    rect = FancyBboxPatch((x, y - height/2), width, height,
                          boxstyle="round,pad=0.05",
                          facecolor=info['color'],
                          edgecolor='#333',
                          linewidth=1.5)
    ax.add_patch(rect)
    
    # Table name
    ax.text(x + width/2, y + height/2 - 0.2, name.upper(),
            ha='center', va='center', fontsize=12, fontweight='bold', color='#333')
    
    # Fields
    for i, field in enumerate(fields):
        fy = y + height/2 - 0.5 - i * 0.35
        ax.text(x + 0.15, fy, field, ha='left', va='center', fontsize=9, color='#555')

# Draw relationships (crow's foot notation)
relationships = [
    # (from_table, to_table, label_from, label_to)
    ('students', 'invoices', '1', 'N'),
    ('fee_types', 'invoices', '1', 'N'),
    ('invoices', 'discounts', '1', 'N'),
    ('invoices', 'payments', '1', 'N'),
]

for from_name, to_name, from_card, to_card in relationships:
    fx, fy = tables[from_name]['pos']
    tx, ty = tables[to_name]['pos']
    
    # Draw line
    ax.annotate('', xy=(tx, ty), xytext=(fx, fy),
                arrowprops=dict(arrowstyle='-', color='#666', lw=1.5,
                               connectionstyle="arc3,rad=0.1"))
    
    # Add cardinality labels
    mid_x = (fx + tx) / 2
    mid_y = (fy + ty) / 2
    
    # Position labels near the ends
    if from_name in ['students', 'fee_types']:
        ax.text(fx + 1.5, fy, from_card, fontsize=10, fontweight='bold', ha='center')
        ax.text(tx - 0.5, ty, to_card, fontsize=10, fontweight='bold', ha='center')
    else:
        ax.text(fx - 0.5, fy, from_card, fontsize=10, fontweight='bold', ha='center')
        ax.text(tx - 1.5, ty, to_card, fontsize=10, fontweight='bold', ha='center')

# Title
ax.text(7, 7.5, 'Student Fees Database - Entity Relationship Diagram',
        ha='center', va='center', fontsize=16, fontweight='bold')

# Legend
ax.text(0.5, 0.5, 'PK = Primary Key\nFK = Foreign Key\n1:N = One-to-Many',
        fontsize=9, color='#666',
        bbox=dict(boxstyle="round,pad=0.3", facecolor='white', edgecolor='#ccc'))

plt.tight_layout()
plt.savefig('erd/schema.png', dpi=200, bbox_inches='tight', facecolor='white')
plt.close()
print("ERD PNG generated successfully!")