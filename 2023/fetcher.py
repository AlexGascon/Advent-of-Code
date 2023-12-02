import os

from dotenv import load_dotenv
import requests
from bs4 import BeautifulSoup

load_dotenv()

# Configuration
DAY = 1      # Change to the current day
URL = f"https://adventofcode.com/2023/day/{DAY}"
SESSION_COOKIE = os.environ['AOC_COOKIE']  # Replace with your session cookie

def get_puzzle_input():
    cookies = {'session': SESSION_COOKIE}
    response = requests.get(f"{URL}/input", cookies=cookies)
    if response.status_code == 200:
        return response.text
    else:
        print("Failed to retrieve puzzle input")
        return None

def get_puzzle_description():
    cookies = {'session': SESSION_COOKIE}
    response = requests.get(URL, cookies=cookies)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        # Assuming the description is in an article tag (you might need to adjust this)
        article = soup.find('article')
        return article.text if article else "No description found"
    else:
        print("Failed to retrieve puzzle description")
        return None

if __name__ == "__main__":
    # puzzle_description = get_puzzle_description()
    puzzle_input = get_puzzle_input()

    with open(f"inputs/day{DAY}.txt", 'w') as f:
        f.write(puzzle_input)

    print("Puzzle Description:\n", puzzle_description)
