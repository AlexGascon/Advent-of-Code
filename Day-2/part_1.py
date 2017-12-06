"""
--- Day 2: Corruption Checksum ---

As you walk through the door, a glowing humanoid shape yells in your direction.
"You there! Your state appears to be idle. Come help us repair the corruption
in this spreadsheet - if we take another millisecond, we'll have to display an
hourglass cursor!"

The spreadsheet consists of rows of apparently-random numbers. To make sure the
recovery process is on the right track, they need you to calculate the spreadsheet's
checksum. For each row, determine the difference between the largest value and
the smallest value; the checksum is the sum of all of these differences.

For example, given the following spreadsheet:

5 1 9 5
7 5 3
2 4 6 8

    The first row's largest and smallest values are 9 and 1, their difference is 8.
    The second row's largest and smallest values are 7 and 3, their difference is 4.
    The third row's difference is 6.

In this example, the spreadsheet's checksum would be 8 + 4 + 6 = 18.

What is the checksum for the spreadsheet in your puzzle input?
"""

def test_row_difference():
    assert row_difference("5 1 9 5") == 8
    assert row_difference("7 5 3") == 4
    assert row_difference("2 4 6 8") == 6

def test_corruption_checksum():
    test_spreadsheet = "5 1 9 5\n7 5 3\n2 4 6 8"
    assert spreadsheet_checksum(test_spreadsheet) == 18


def row_difference(row):
    """Gets a string of numbers and returns the difference between its max and min
    The numbers must be separated by any whitespace character."""

    numbers = [int(char) for char in row.split()]
    max_num, min_num = max(numbers), min(numbers)

    return max_num - min_num

def spreadsheet_checksum(spreadsheet):
    """Given a spreadsheet with numbers, computes its checksum

    The spreadsheet is expected to be a string where each line represents a row
    and where the numbers in each column are separated by a whitespace.

    The checksum is obtained by computing the difference between the max and the
    min number of each row and then computing the sum of all these differences."""

    count = 0
    rows = spreadsheet.splitlines()

    for row in rows:
        count += row_difference(row)

    return count


if __name__ == '__main__':

    input_path = 'input.txt'
    input = open(input_path).read()

    result = spreadsheet_checksum(input)
    print(result)