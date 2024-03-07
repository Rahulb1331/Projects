<H1>Amazon India Laptop Price Tracker</H1>
The program is specifically tailored for scraping laptop listings from the Amazon India website and is customizable to refine the search criteria based on user preferences. It provides a convenient way to track laptop prices and specifications for potential buyers or researchers interested in the Indian market.
The script navigates to the Amazon India website and searches for gaming laptops.
It applies filters to narrow down the search results, including selecting laptops with a rating of 4 stars or above, choosing specific brands (ASUS, Acer, MSI, Dell, Lenovo), and setting a price range between 1,00,000 and 1,50,000 INR.
The script extracts relevant information from the search results, including the title, price, star rating, image, and product link for each laptop.
It converts the extracted star ratings into floating-point numbers for better analysis and creates a pandas DataFrame to store the scraped data.
The script saves the extracted data to a CSV file named "Final.csv" for further analysis or storage.
Utilizes Streamlit to present the scraped information in a user-friendly format, including images, titles, star ratings, prices, and links, allowing users to browse through the laptop listings conveniently.
