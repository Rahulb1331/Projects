import requests  # type: ignore
import re
import time
from bs4 import BeautifulSoup  # type: ignore
import os 
from selenium import webdriver  # type: ignore
from selenium.webdriver.common.by import By  # type : ignore


def get_html(str=[]):
    url = 'https://www.myscheme.gov.in' + str
    page = requests.get(url)
    # BeautifulSoup expects a string input
    soup = BeautifulSoup(page.text, 'html.parser')
    return soup


def get_eligibility(soup):
    eligibility = soup.find('div', id=re.compile("eligibility"))
    lists = eligibility.find_all('span', {'data-slate-string': True})
    return lists


def get_documentsRequired(soup):
    docs = soup.find('div', id=re.compile("documentsRequired"))
    lists = []
    try:
        lists = docs.find_all('span', {'data-slate-string': True})
    except:
        lists = []
    return lists


def get_benefits(soup):
    docs = soup.find('div', id=re.compile("benefits"))
    lists = []
    try:
        lists = docs.find_all('span', {'data-slate-string': True})
    except:
        lists = []
    return lists


def get_exclusion(soup):
    exclucions = soup.find('div', id=re.compile("exclucions"))
    lists = []
    try:
        lists = exclucions.find_all('span', {'data-slate-string': True})
    except:
        lists = []
    return lists


def get_bodies(soup):
    return soup.find('main').contents[0].contents[3].contents[-1].contents[-1].find_all('h2', {'class': True})


os.environ['PATH'] += r"C:\Users\ADMIN\Desktop\Scarpper"
driver = webdriver.Firefox()
# change link for each sector
driver.get('https://www.myscheme.gov.in/search/category/Business%20&%20Entrepreneurship')
ans = []
links = []
orgs = []
# Change range limit to max pg number +1 eg for Social 9 page so 10
for i in range(1, 3):
    time.sleep(15)
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    lists = soup.find_all('a', href=True)
    for item in lists:
        if item['href'].startswith('/schemes'):
            links.append(item['href'])
    lists = soup.find('main').contents[0].contents[3].contents[-1].contents[-1].find_all('h2', {'class': True})
    ans.extend(lists)
    lists = get_bodies(soup)
    orgs.extend(lists)
    print("next")

i = 0
with open('info.txt', "w", encoding="utf-8") as file:
    for str1 in links:
        soup = get_html(str1)
        lists = get_eligibility(soup)
        str = soup.find('h1', {'title': True})
        file.write(str.text)
        file.write('\n')
        file.write(orgs[i].text)
        file.write('\n\n')
        file.write('Eligibility \n')
        i += 1
        for item in lists:
            try:
                file.write(item.text)
            except:
                file.write("-")
            file.write('\n')
        lists = get_exclusion(soup)
        for item in lists:
            try:
                file.write(item.text)
            except:
                file.write("-")
            file.write('\n')
        file.write('\n')
        file.write("Documents Required \n")
        lists = get_documentsRequired(soup)
        for item in lists:
            try:
                file.write(item.text)
            except:
                file.write("-")
            file.write('\n')
        file.write('\n')
        file.write("Benefits \n")
        lists = get_benefits(soup)
        for item in lists:
            try:
                file.write(item.text)
            except:
                file.write("-")
            file.write('\n')
        file.write('\n')
        file.write("****")
        file.write('\n')

driver.quit()
# For each next printed click on the next number except the last one as a check when last next
# is printed you should have reached the end .
# you change sleep time but dont website is slow
