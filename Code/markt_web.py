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
import time

def remove_special_characters(string):
    pattern = r'[!@#$%^&*()_+={}\[\]:;"\'<>?/\\|`~]'
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
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--log-level=3")

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)
    time.sleep(10)
    target_element = driver.find_element(By.CLASS_NAME, "products-grid")
    
    
    target_element = driver.find_element(By.CSS_SELECTOR, "#maincontent > div > div.column.main > div.products.wrapper.grid.products-grid > ol")
    li_elements = target_element.find_elements(By.CLASS_NAME, 'product-item-info')
    
    for li in li_elements:
        product_details_element = li.find_element(By.CLASS_NAME, "product-item-details")
        a_element = product_details_element.find_element(By.CSS_SELECTOR, "strong > a")
        name = a_element.text
        clean_name = remove_special_characters(name)
        if any(product_name in clean_name for product_name in product_names):
            span_element = product_details_element.find_element(By.CSS_SELECTOR, ".price-wrapper.price-excluding-tax")
            price_amount = span_element.get_attribute("data-price-amount")
            search_results.append([clean_name, price_amount])


    driver.quit()

product_names = products()
search_results = []
base_url = "https://www.themart.gr/landing-page-category/evdomadiaies-prosfores.html?p="
url = "https://www.themart.gr/landing-page-category/evdomadiaies-prosfores.html?p=1"

chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--log-level=3")
driver = webdriver.Chrome(options=chrome_options)
driver.get(url)
time.sleep(15)
ul_element = driver.find_element(By.CSS_SELECTOR, '#maincontent > div > div.column.main > div:nth-child(4) > div.pages > ul')
li_elements = ul_element.find_elements(By.CSS_SELECTOR, 'li.item')
second_to_last_li_element = li_elements[-2]
span_element = second_to_last_li_element.find_element(By.CSS_SELECTOR, 'span:not([class])')
number_of_pages_text = span_element.text
driver.quit()
url_links = [url] + [base_url + str(page_number) for page_number in range(2, int(number_of_pages_text)+1)] #int(number_of_pages_text)+1


for url_link in url_links:
    search_prices(url_link, search_results, product_names)

cnx = mysql.connector.connect(user='root', password='root',database='simple')
cursor = cnx.cursor()


for row in search_results:
    clean_name = remove_special_characters(row[0])
    cursor.execute("INSERT INTO search_results (prod_results_name, prod_price_1, prod_price_2) VALUES (%s, %s, %s) ON DUPLICATE KEY UPDATE prod_price_1 = VALUES(prod_price_1)", (clean_name, row[1],'-'))
    cnx.commit()

cnx.close()

