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
    # Get hourly income
    hours = range(24)
    income = get_hourly_income()

    # Create the plot
    plt.figure(figsize=(10, 6))
    plt.plot(hours, income, marker='o', color='b', linestyle='-', linewidth=2, markersize=8, label='Hourly Income')  # Plot original data points
    plt.title('Ημερήσια Έσοδα', fontsize=16, fontweight='bold')  # Title with increased font size and bold
    plt.xlabel('Hour', fontsize=14, fontweight='bold')  # X-axis label with increased font size and bold
    plt.ylabel('Income', fontsize=14, fontweight='bold')  # Y-axis label with increased font size and bold
    plt.xticks(ticks=range(24), fontsize=12)  # X-axis ticks for each hour
    plt.yticks(fontsize=12)  # Y-axis ticks with appropriate font size
    plt.legend(loc='upper left', fontsize=12)  # Add legend with increased font size
    plt.grid(True, linestyle='--', alpha=0.5)  # Add grid with dashed lines and reduced opacity
    plt.tight_layout()  # Adjust layout to prevent overlap of labels
    plt.savefig('daily_plots.png', dpi=300)  # Save the plot as an image with higher resolution

plot_hourly_income()
