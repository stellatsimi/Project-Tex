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

    # Load the webpage
    driver.get(url)

    # Find the target element using CSS selector
    target_element = driver.find_element(By.CLASS_NAME, "products-grid")
    
    
    target_element = driver.find_element(By.CSS_SELECTOR, "#maincontent > div > div.column.main > div.products.wrapper.grid.products-grid > ol")
    li_elements = target_element.find_elements(By.CLASS_NAME, 'product-item-info')
    
    for li in li_elements:
        product_details_element = li.find_element(By.CLASS_NAME, "product-item-details")
        a_element = product_details_element.find_element(By.CSS_SELECTOR, "strong > a")
        #print("Text of <a> element:", a_element.text)
        name = a_element.text

        span_element = product_details_element.find_element(By.CSS_SELECTOR, ".price-wrapper.price-excluding-tax")
    
        # Extract the text content of the <span> element
        price_amount = span_element.get_attribute("data-price-amount")
        print("Name: ", name, " Price: ", float(price_amount))

        search_results.append([name, price_amount])

    

    # Close the browser
    driver.quit()

search_results = []
base_url = "https://www.themart.gr/landing-page-category/evdomadiaies-prosfores.html?p="
url = "https://www.themart.gr/landing-page-category/evdomadiaies-prosfores.html?p=1"


search_prices(url, search_results)