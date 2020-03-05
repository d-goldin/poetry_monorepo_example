import requests

def important_functionality():
    response = requests.get('http://example.org/')

    if response.status_code == 200:
        return response.content
    else:
        return None

if __name__ == '__main__':
    print(important_functionality())
