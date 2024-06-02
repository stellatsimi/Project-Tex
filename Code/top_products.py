import mysql.connector
import matplotlib.pyplot as plt
import seaborn as sns
from decimal import Decimal
import sys

def get_top_products(date1, date2):
    conn = mysql.connector.connect(user='root', password='root', database='simple')
    cursor = conn.cursor()
    query = """
    SELECT pr.prod_rec_name, SUM(pr.prod_rec_quantity) AS total_quantity
        FROM product_Receipt pr
        JOIN receipt r ON pr.prod_rec_id = r.receipt_id
        WHERE r.date BETWEEN %s AND %s
        GROUP BY pr.prod_rec_name
        ORDER BY total_quantity DESC
        LIMIT 5
"""

    cursor.execute(query, (date1, date2))
    results = cursor.fetchall()

    cursor.close()
    conn.close()
    return results

def plot_top_products(data):
    product_names = [row[0] for row in data]
    purchase_counts = [row[1] for row in data]
    colors = ['#1f77b4', '#4b88c3', '#6ea9db', '#a4cbe9', '#cfe1f2']

    plt.figure(figsize=(10, 6))
    plt.bar(product_names, purchase_counts, color=colors)
    plt.xlabel('Προϊόν')
    plt.ylabel('Ποσότητα')
    plt.title('Τα 5 πιο αγορασμένα προϊόντα')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig('top_products.png', dpi=300) 


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <date1> <date2>")
        sys.exit(1)

    date1 = sys.argv[1]
    date2 = sys.argv[2]

    top_products = get_top_products(date1, date2)
    plot_top_products(top_products)