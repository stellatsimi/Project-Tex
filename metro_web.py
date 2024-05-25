import requests
from bs4 import BeautifulSoup
import csv
import re
from unidecode import unidecode
from urllib.parse import unquote
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import mysql.connector
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.chrome.options import Options
import time

def remove_special_characters(string):
    # Define a regular expression pattern to match the special characters you want to remove
    pattern = r'[!@#$%^&*()_+={}\[\]:;"\'<>?/\\|`~]'
    # Use re.sub to replace these special characters with an empty string
    cleaned_string = re.sub(pattern, '', string)
    return cleaned_string

def products():
    cnx = mysql.connector.connect(user='root', password='root', database='simple')
    cursor = cnx.cursor()
    cursor.execute("SELECT prod_search_name FROM product_search")
    
    product_names = []
    for (product_search_name,) in cursor:
        product_names.append(product_search_name)
    
    cnx.close()
    return product_names

def search_prices(url, search_results, product_names):
    # Launch the Chrome browser
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--log-level=3")  # Suppress logging

    # Launch the Chrome browser in headless mode
    driver = webdriver.Chrome(options=chrome_options)

    driver.get(url)

    # Find the element containing the shadow root
    page_region = driver.find_element(By.CSS_SELECTOR, 'main page-region')

    # Execute JavaScript to access the shadow root
    shadow_root = driver.execute_script('return arguments[0].shadowRoot', page_region)

    time.sleep(10)

    # Find elements within the shadow root
    if shadow_root:
        app_product_v2_elements = shadow_root.find_elements(By.CSS_SELECTOR, '#app-product-v2')

        if not app_product_v2_elements:
            print("no app")

        for element in app_product_v2_elements:
            # td elements for price
            h6_element = element.find_element(By.CSS_SELECTOR, 'div.product-item-header-container > div.product-heading-details > h6')
            h6_text = h6_element.text
            clean_name = remove_special_characters(h6_text)
            
            if any(product_name in clean_name for product_name in product_names):
                td_final_price = element.find_element(By.CSS_SELECTOR, 'div.table-container > div.product-item-table-wrapper > table > tbody > tr:nth-child(2) > td.text-center.final-price > span.h6')
                final_price_text = td_final_price.text
                final_price = float(final_price_text.replace(',', '.'))
                search_results.append([clean_name, final_price])

    




url = "https://www.metrocashandcarry.gr/categories/special/axtyphtes-prosfores-ebdomadas"
product_names = products()
search_results = []
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--log-level=3")  # Suppress logging
driver = webdriver.Chrome(options=chrome_options)
driver.get(url)
page_region = driver.find_element(By.CSS_SELECTOR, 'main page-region')
print(page_region)
# Execute JavaScript to access the shadow root
shadow_root = driver.execute_script('return arguments[0].shadowRoot', page_region)

time.sleep(15)

page_items = shadow_root.find_elements(By.CSS_SELECTOR, 'app-product-list > div.container-xl.mt-4.mb-3.mb-md-5.mb-xl-6.d-block > div > div > div.col-xl-10.col-12 > div.display-items-components > app-item-grid > app-paginator > div > div.col-lg-6.d-flex.justify-content-center > nav > ul > li.page-item.mx-1')
last_page_item = page_items[-1]
button_element = last_page_item.find_element(By.CSS_SELECTOR, 'button')
number_of_pages_text = button_element.text


base_url = "https://www.metrocashandcarry.gr/categories/special/axtyphtes-prosfores-ebdomadas?size=16&page="
url_links = [url] + [base_url + str(page_number) for page_number in range(2, int(number_of_pages_text)+1)] #int(number_of_pages_text)+1

for url_link in url_links:
    print("Page ", url_links.index(url_link) + 1)
    search_prices(url_link, search_results, product_names)

cnx = mysql.connector.connect(user='root', password='root',database='simple')
cursor = cnx.cursor()

#deleting old search results
delete_query = "DELETE FROM search_results"
cursor.execute(delete_query)
cnx.commit()

for row in search_results:
    cursor.execute("INSERT INTO search_results (prod_results_name, prod_price_1, prod_price_2) VALUES (%s, %s, %s) ON DUPLICATE KEY UPDATE prod_price_2 = VALUES(prod_price_2)", (row[0], '-', row[1]))
    cnx.commit()

query = ("SELECT * FROM search_results")
cursor.execute(query)

for row in cursor:
    print(row)

cnx.close()