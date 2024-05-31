import requests
import json

# URL of the PlayStation API
api_url = 'https://api.sampleapis.com/playstation/games'

def fetch_api_data(api_url):
    response = requests.get(api_url)
    data = response.json()
    return data

def save_sample_data(data, filename):
    with open(filename, 'w') as f:
        json.dump(data, f, indent=2)

if __name__ == "__main__":
    data = fetch_api_data(api_url)
    save_sample_data(data, 'sample_playstation_data.json')
    print("Sample data saved to sample_playstation_data.json")
