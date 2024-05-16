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

def search_prices(url, search_results):
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
        span_element = product_details_element.find_element(By.CSS_SELECTOR, ".price-wrapper.price-excluding-tax")

        price_amount = span_element.get_attribute("data-price-amount")
        print("Name: ", name, " Price: ", float(price_amount))

        search_results.append([name, price_amount])

    driver.quit()

search_results = []
base_url = "https://www.themart.gr/landing-page-category/evdomadiaies-prosfores.html?p="
url = "https://www.themart.gr/landing-page-category/evdomadiaies-prosfores.html?p=1"

chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--log-level=3")
driver = webdriver.Chrome(options=chrome_options)
driver.get(url)
ul_element = driver.find_element(By.CSS_SELECTOR, '#maincontent > div > div.column.main > div:nth-child(4) > div.pages > ul')
li_elements = ul_element.find_elements(By.CSS_SELECTOR, 'li.item')
second_to_last_li_element = li_elements[-2]
span_element = second_to_last_li_element.find_element(By.CSS_SELECTOR, 'span:not([class])')
number_of_pages_text = span_element.text
driver.quit()
url_links = [url] + [base_url + str(page_number) for page_number in range(2, int(number_of_pages_text)+1)]


for url_link in url_links:
    print("Page ", url_links.index(url_link) + 1)
    search_prices(url_link, search_results)