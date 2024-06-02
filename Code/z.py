import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime, timedelta
import mysql.connector
from scipy.interpolate import interp1d
import sys
def get_z_values(date1, date2):
    conn = mysql.connector.connect(user='root', password='root', database='simple')
    cursor = conn.cursor()

    query = """
        SELECT ps.prod_stor_fpa,
               SUM((pr.prod_rec_quantity * ps.prod_stor_price)) AS total_profit
        FROM product_Receipt pr
        JOIN product_Storage ps ON pr.prod_rec_name = ps.prod_stor_name
        JOIN receipt r ON pr.prod_rec_id = r.receipt_id
        WHERE r.date BETWEEN %s AND %s
        GROUP BY ps.prod_stor_fpa;
    """
    cursor.execute(query, (date1, date2))

    results = cursor.fetchall()
    cursor.close()
    conn.close()

    return results


def plot_z_values(results):
    ffpa = [f'{result[0]}%' for result in results]
    total_profit = [result[1] for result in results]

    blue_colors = ['#7eb5e6', '#2c66b2']
    green_colors = ['#9fe5e6', '#33a02c']
   
    plt.figure(figsize=(8, 6))
    plt.title('Συνολικά Έσοδα ανά ΦΠΑ', fontsize=16)
    plt.pie(total_profit, labels=ffpa, autopct='%1.1f%%', startangle=140, colors=blue_colors + green_colors)
    plt.axis('equal')  
    
    legend_labels = [f'{result[0]}% - {result[1]:.2f}€' for result in results]
    plt.legend(legend_labels, loc='lower right', fontsize=12, bbox_to_anchor=(1, 0))

    plt.tight_layout()
    plt.savefig('z.png', dpi=300) 


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <date1> <date2>")
        sys.exit(1)

    date1 = sys.argv[1]
    date2 = sys.argv[2]
    z_values = get_z_values(date1, date2)
    plot_z_values(z_values)