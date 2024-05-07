import requests
from bs4 import BeautifulSoup
import csv
import re
from unidecode import unidecode
from urllib.parse import unquote
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options


def search_prices(url):
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

        if app_product_v2_elements:
            print("Found", len(app_product_v2_elements), "app-product-v2 elements:")

        for element in app_product_v2_elements:
            # td elements for price
            h6_element = element.find_element(By.CSS_SELECTOR, 'div.product-item-header-container > div.product-heading-details > h6')
            h6_text = h6_element.text
            print("Όνομα προϊόντος:", h6_text)

            td_final_price = element.find_element(By.CSS_SELECTOR, 'div.table-container > div.product-item-table-wrapper > table > tbody > tr:nth-child(2) > td.text-center.final-price')
            final_price_text = td_final_price.text
            print("Τιμή:", final_price_text)

url = "https://www.metrocashandcarry.gr/categories/special/axtyphtes-prosfores-ebdomadas"
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
url_links = [url] + [base_url + str(page_number) for page_number in range(2, 13)]

for url_link in url_links:
    print("Page ", url_links.index(url_link) + 1)
    search_prices(url_link)