import requests
from bs4 import BeautifulSoup

# URL сторінки, яку хочемо спарсити
url = 'http://sortyourmusic.playlistmachinery.com/#access_token=BQCaUpNRV4FG4MBw8eZ1OYpqL7CtfRRPXy0s2L9luYOLxJklq4gHqMgBrvp9drjrr36RSm88yY7HbKHxmGZ4Im8Fdp8q23T7GBxXR2bWPa4Cy-kDcxj6ofbaDqYgBkaHK38EF15xYEEj8ehOJgf1cyQdhIriTALbcItK3b-pul-FEyR5IE07NZHwZRT21fpmKb0O9dWCvNBK7QicWPFkDMkoVTllffWrrOfIDyEYvxj6Nt9ej6gokj2iz18i7xtSyMOaxYU&token_type=Bearer&expires_in=3600'

# Використовуємо requests для отримання HTML-коду сторінки
response = requests.get(url)
print(response)
# Перевіряємо чи успішно отримали сторінку
if response.status_code == 200:
    # Створюємо об'єкт BeautifulSoup для парсингу HTML
    print('here')
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Знаходимо таблицю за допомогою BeautifulSoup
    table = soup.find('table')
    
    # Ініціалізуємо список для збереження даних
    data = []

    # Знаходимо всі рядки в таблиці
    for row in table.find_all('tr')[1:]:  # Пропускаємо заголовок таблиці
        cells = row.find_all('td')
        row_data = {
            'Title': cells[0].get_text(strip=True),
            'Artist': cells[1].get_text(strip=True),
            'Release': cells[2].get_text(strip=True),
            'BPM': cells[3].get_text(strip=True),
            'Energy': cells[4].get_text(strip=True),
            'Dance': cells[5].get_text(strip=True),
            'Loud': cells[6].get_text(strip=True),
            'Valence': cells[7].get_text(strip=True),
            'Length': cells[8].get_text(strip=True),
            'Acoustic': cells[9].get_text(strip=True),
            'Pop.': cells[10].get_text(strip=True),
            'A.Sep': cells[11].get_text(strip=True),
            'Rnd': cells[12].get_text(strip=True)
        }
        data.append(row_data)
        print(data)
    # Виводимо отримані дані
    for item in data:
        print(item)

