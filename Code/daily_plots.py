import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime, timedelta
import mysql.connector
from scipy.interpolate import interp1d

def get_hourly_income():
    cnx = mysql.connector.connect(user='root', password='root', database='simple')
    cursor = cnx.cursor()

    hourly_income = []
    start_time = datetime.now().replace(minute=0, second=0, microsecond=0)
    for i in range(24):
        end_time = start_time + timedelta(hours=1)
        query = "SELECT SUM(sum) FROM receipt WHERE date BETWEEN %s AND %s"
        cursor.execute(query, (start_time, end_time))
        result = cursor.fetchone()[0]
        if result is None or result < 0:
            result = 0.0
        hourly_income.append(result)
        start_time = end_time
        print(result)
    cnx.close()
    return hourly_income

def plot_hourly_income():
    hours = range(24)
    income = get_hourly_income()

    plt.figure(figsize=(10, 6))
    plt.plot(hours, income, marker='o', color='b', linestyle='-', linewidth=2, markersize=8, label='Hourly Income')  
    plt.title('Ημερήσια Έσοδα', fontsize=16, fontweight='bold') 
    plt.xlabel('Hour', fontsize=14, fontweight='bold') 
    plt.ylabel('Income', fontsize=14, fontweight='bold') 
    plt.xticks(ticks=range(24), fontsize=12)
    plt.yticks(fontsize=12)
    plt.legend(loc='upper left', fontsize=12) 
    plt.grid(True, linestyle='--', alpha=0.5)  
    plt.tight_layout()  
    plt.savefig('daily_plots.png', dpi=300) 

plot_hourly_income()
