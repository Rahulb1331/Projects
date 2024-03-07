#Importing the modules and Libraries
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import time
import requests
import bs4 as b
import csv
import pandas as pd
import streamlit as st

#Website to be scraped
url = "https://www.amazon.in/"


# Function to apply the filters
def apply_filters(driver):
    driver.find_element(By.ID, "p_72/1318476031").click()  # Rating 4 stars or above
    time.sleep(2)

    #Selecting the brands and filtering by them
    brands = ['ASUS', 'Acer', 'MSI', 'Dell', 'Lenovo']
    for i in brands:
        try:
            driver.find_element(By.LINK_TEXT, i).click()
            time.sleep(2)
        except:
            continue

    #Selecting the price range
    driver.find_element(By.ID, "low-price").send_keys("100000")
    driver.find_element(By.ID, "high-price").send_keys("150000")
    time.sleep(2)
    driver.find_element(By.CLASS_NAME, "a-button-input").click()


#Function to extract information from nested tags within elements matching the specified class and returning the content.
def extract_info(elements, tag_name, class_name):
    """
    Args:
    - elements: BeautifulSoup elements to search within.
    - tag_name: Name of the tag to search for (e.g., 'div').
    - class_name: Class name of the elements to search for.
    """
    ll = []
    for element in elements:
        # Find the nested tag within the element
        nested_tag = element.find(tag_name, class_=class_name)

        # Extract information from the nested tag to a list
        if nested_tag:
            nested_content = nested_tag.get_text().strip()
            ll.append(nested_content)
        else:
            print("Nested tag not found in this element")
    return ll


# Defining the function to scrape the data (title, price, stars, image and product link)
def scraper(driver):
    titles = []
    prices = []
    links = []
    stars = []
    images = []

    #For scraping through the first n pages (here 2)
    for page in range(2):
        soup = b.BeautifulSoup(driver.page_source, 'html.parser')
        block = soup.find_all('div',
                              class_="puisg-col puisg-col-4-of-12 puisg-col-8-of-16 puisg-col-12-of-20 puisg-col-12-of-24 puis-list-col-right")
        titles.extend(extract_info(block, "span", "a-size-medium a-color-base a-text-normal"))
        stars.extend(extract_info(block, "span", "a-icon-alt"))
        
        # Iterate over each div tag and extract the prices
        for element in block:
            divs = element.find("div", attrs={"data-cy": "price-recipe"})
            divss = element.find("div", attrs={"data-cy": "secondary-offer-recipe"})
            if divs:
                for div in divs:
                    # Find the span tag containing the price
                    price_spans_color = div.find('span', class_='a-price-whole')
                    if price_spans_color:
                        price = price_spans_color.text.strip()
                        prices.append(price)
                    else:
                        continue
            if divss:
                for div in divss:
                    featured = div.find('span', class_="a-size-base a-color-secondary")
                    if featured.text.strip() == "No featured offers available":
                        price_spans = div.find('span', class_='a-color-base')
                        if price_spans:
                            price = price_spans.text.strip()
                            prices.append(price)
                        else:
                            continue
                    else:
                        continue
            if not (divs or divss): #Handling cases where the product price is not available
                prices.append(' ')
                
        # Extracting the links for the laptops from the website
        link = soup.find_all('h2', class_="a-size-mini a-spacing-none a-color-base s-line-clamp-2")
        links.extend([url + tag.find('a').get('href', '') if tag.find('a') else '' for tag in link])

        # Extracting the images source
        div = soup.find_all('div', class_="a-section aok-relative s-image-fixed-height")
        for im in div:
            img_tag = im.find('img', class_="s-image")
            if img_tag:
                src = img_tag.get('src')
                images.append(src)
            else:
                images.append('')
        try:
            next_page_link = driver.find_element(By.PARTIAL_LINK_TEXT, 'Next').get_attribute('href')
            driver.get(next_page_link)
            time.sleep(5)  # Wait for next page to load
        except:
            break

    return titles, prices, stars, links, images

#Calling the above functions to scrape the data

Titles =[]
Prices = []
Stars = []
Links = []
Images = []
driver = webdriver.Chrome()
driver.get(url)
time.sleep(7)
#Entering the keywords on the search bar
input = driver.find_element(By.NAME, "field-keywords")
input.send_keys("Gaming laptop")
button = driver.find_element(By.ID, "nav-search-submit-button")
button.click()
#Selecting the filters for the Laptop
apply_filters(driver)
time.sleep(5)
#Extracting the information from the webpage
titles,prices,stars,links,images = scraper(driver)
#driver.quit()
#Appending the returned values to the Lists
Titles.extend(titles)
Prices.extend(prices)
Stars.extend(stars)
Links.extend(links)
Images.extend(images)

#Length of the extracted lists to ensure the dataframe is created
print(len(Prices),len(Titles),len(Stars),len(Links), len(Images))

# Extracting the first three characters from each element in the list and changing the datatype to float
stars = [star[:3] for star in stars]
Stars = [float(star) for star in stars]
# Printing the updated list
print(type(Stars[0]))


# Creating the pandas dataframe which has the scraped data
D1 = pd.DataFrame({' ': Images, 'Title':Titles, 'Stars':Stars, 'Price':Prices, 'Link': Links})


# Converting it to csv format which can be downloaded
D1.to_csv('Final.csv',index= False)

# Using Streamlit to display the scraped information
st.title("Price Tracer for Laptop")
st.write("Scraping the Amazon India website for the laptops for Asus, Acer, MSI, Lenovo and HP brands having the rating 4 stars and above and between the price range of 1,00,000 and 1,50,000.")
#st.table(D1)
# Display images along with the table
for index, row in D1.iterrows():
    st.image(row[' '])
    st.write(row['Title'])
    st.write(row['Stars'])
    st.write(row['Price'])
    st.write(row['Link'])
    st.write("---")

#!streamlit run C:\Users\......\Tracer.py 


