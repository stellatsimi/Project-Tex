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


def search_prices(url, search_results):
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

    # Find elements within the shadow root
    if shadow_root:
        app_product_v2_elements = shadow_root.find_elements(By.CSS_SELECTOR, '#app-product-v2')

        for element in app_product_v2_elements:
            # td elements for price
            h6_element = element.find_element(By.CSS_SELECTOR, 'div.product-item-header-container > div.product-heading-details > h6')
            h6_text = h6_element.text
            # print("Όνομα προϊόντος:", h6_text)

            td_final_price = element.find_element(By.CSS_SELECTOR, 'div.table-container > div.product-item-table-wrapper > table > tbody > tr:nth-child(2) > td.text-center.final-price > span.h6')
            final_price_text = td_final_price.text
            final_price = float(final_price_text.replace(',', '.'))
            # print("Τιμή:", final_price)

            search_results.append([h6_text, final_price])




url = "https://www.metrocashandcarry.gr/categories/special/axtyphtes-prosfores-ebdomadas"
search_results = []
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--log-level=3")  # Suppress logging
driver = webdriver.Chrome(options=chrome_options)
driver.get(url)
page_region = driver.find_element(By.CSS_SELECTOR, 'main page-region')
# Execute JavaScript to access the shadow root
shadow_root = driver.execute_script('return arguments[0].shadowRoot', page_region)


page_items = shadow_root.find_elements(By.CSS_SELECTOR, 'app-product-list > div.container-xl.mt-4.mb-3.mb-md-5.mb-xl-6.d-block > div > div > div.col-xl-10.col-12 > div.display-items-components > app-item-grid > app-paginator > div > div.col-lg-6.d-flex.justify-content-center > nav > ul > li.page-item.mx-1')
last_page_item = page_items[-1]
button_element = last_page_item.find_element(By.CSS_SELECTOR, 'button')
number_of_pages_text = button_element.text

base_url = "https://www.metrocashandcarry.gr/categories/special/axtyphtes-prosfores-ebdomadas?size=16&page="
url_links = [url] + [base_url + str(page_number) for page_number in range(2, number_of_pages_text)]

for url_link in url_links:
    print("Page ", url_links.index(url_link) + 1)
    search_prices(url_link, search_results)

cnx = mysql.connector.connect(user='root', password='root',database='simple')
cursor = cnx.cursor()

#deleting old search results
delete_query = "DELETE FROM search_results"
cursor.execute(delete_query)
cnx.commit()

for row in search_results:
    cursor.execute("INSERT INTO search_results (search_name, search_price1, search_price2) VALUES (%s, %s, %s)", (row[0], row[1], row[1]))
    cnx.commit()

query = ("SELECT * FROM search_results")
cursor.execute(query)

for row in cursor:
    print(row)

cnx.close()