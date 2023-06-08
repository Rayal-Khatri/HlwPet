import requests
from bs4 import BeautifulSoup
import csv

# Make a GET request to the webpage
url = "https://www.petcarerx.com/article/dog-diseases-and-symptoms-a-to-z/1663"
response = requests.get(url)

# Create a BeautifulSoup object and specify the parser
soup = BeautifulSoup(response.text, 'html.parser')

# Find the table that contains the data
table = soup.find('table')

# Create a CSV file to store the extracted data
csv_file = open('disease_data_test.csv', 'w', newline='', encoding='utf-8')
csv_writer = csv.writer(csv_file)

# Find all rows in the table
rows = table.find_all('tr')

# Iterate over the rows and extract the data
for row in rows:
    cells = row.find_all('td')
    if len(cells) == 3:
        disease = cells[0].text.strip()
        symptoms = cells[1].text.strip()
        treatments = cells[2].text.strip()

        # Write the data to the CSV file
        csv_writer.writerow([disease, symptoms, treatments])

# Close the CSV file
csv_file.close()
