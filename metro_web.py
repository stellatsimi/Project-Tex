import requests
from bs4 import BeautifulSoup
import csv
import re
from unidecode import unidecode
from urllib.parse import unquote
from selenium import webdriver
from selenium.webdriver.common.by import By


url = "https://www.metrocashandcarry.gr/categories/special/axtyphtes-prosfores-ebdomadas"

# Launch the Chrome browser
driver = webdriver.Chrome()

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
        print("Text from h6:", h6_text)
        
        td_final_price = element.find_element(By.CSS_SELECTOR, 'div.table-container > div.product-item-table-wrapper > table > tbody > tr:nth-child(2) > td.text-center.final-price')
        final_price_text = td_final_price.text
        print("Final Price:", final_price_text)