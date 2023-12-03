import os
import sys

from dotenv import load_dotenv
import requests
from bs4 import BeautifulSoup

load_dotenv()

# Configuration
SESSION_COOKIE = os.environ['AOC_COOKIE']  # Replace with your session cookie

def get_puzzle_input(day):
    cookies = {'session': SESSION_COOKIE}
    response = requests.get(f"https://adventofcode.com/2023/day/{day}/input", cookies=cookies)
    if response.status_code == 200:
        return response.text
    else:
        print("Failed to retrieve puzzle input")
        return None

def get_puzzle_description(day):
    cookies = {'session': SESSION_COOKIE}
    response = requests.get(f"https://adventofcode.com/2023/day/{day}", cookies=cookies)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        # Assuming the description is in an article tag (you might need to adjust this)
        article = soup.find('article')
        return article.text if article else "No description found"
    else:
        print("Failed to retrieve puzzle description")
        return None

if __name__ == "__main__":
    if len(sys.argv) != 2 or not sys.argv[1].isdigit():
        print("Usage: python fetcher.py <day>")
        sys.exit(1)

    day = int(sys.argv[1])

    if not (1 <= day <= 25):
        print("Invalid day. Please enter a day between 1 and 25.")
        sys.exit(1)

    # puzzle_description = get_puzzle_description(day)
    puzzle_input = get_puzzle_input(day)

    filename = f"inputs/day{day}.txt"
    with open(filename, 'w') as f:
        f.write(puzzle_input)
        print(f"Input saved as {filename}")
