"""
--- Day 1: Trebuchet?! ---
Something is wrong with global snow production, and you've been selected to take a look. The Elves have even given you a map; on it, they've used stars to mark the top fifty locations that are likely to be having problems.

You've been doing this long enough to know that to restore snow operations, you need to check all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

You try to ask why they can't just use a weather machine ("not powerful enough") and where they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from") when you realize that the Elves are already loading you into a trebuchet ("please hold still, we need to strap you in").

As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.

The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.

For example:

1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.

Consider your entire calibration document. What is the sum of all of the calibration values?
"""

import re

# Regex for part 1
# DIGIT_SUBSTRING_REGEX = re.compile("\D*(\d.*\d)\D*|\D*(\d)\D*")

# Explanation for the regex
# - \D*? matches non-digits (\D), zero or more (*) but as few as possible (?), i.e. prioritize the next parts of the regex
# - Then, on the next group:
#     - The outermost parentheses match the content multiple times (...)*
#     - ?= allows overlapping matches - It matches without consuming string characters (i.e. if we have "oneight", match both "one" and "eight" even though they overlap)
#     - Then we use | to combine matches, which can be either
#         - A digit (\d)
#         - Any of the words
# - \D*?, again, matches as few non-digits as possible
#     - We do this at the beginning and the end to ensure that the central part is as "greedy" as possible
DIGIT_SUBSTRING_REGEX = re.compile("\D*?((?=(\d|one|two|three|four|five|six|seven|eight|nine)))*\D*?")
TEXT_TO_DIGIT_MAPPING = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
}


def extract_digits(line):
    digits = []
    for groups in DIGIT_SUBSTRING_REGEX.findall(line):
        for group in groups:
            if not group:
                continue

            digits.append(convert_to_digit(group))
    
    if len(digits) == 0:
        return [digits[0], digits[0]]

    return [digits[0], digits[-1]]

def convert_to_digit(group):
    try:
        return int(group)
    except Exception:
        return TEXT_TO_DIGIT_MAPPING[group]


total = 0
for line in open("inputs/day1.txt").readlines():
    [first_digit, last_digit] = extract_digits(line.strip())
    total += int(f"{first_digit}{last_digit}")


print(f"Result: {total}")
