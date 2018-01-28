"""--- Part Two ---

"Great work; looks like we're on the right track after all. Here's a star for
your effort." However, the program seems a little worried. Can programs be
worried?

"Based on what we're seeing, it looks like all the User wanted is some information
about the evenly divisible values in the spreadsheet. Unfortunately, none of
us are equipped for that kind of calculation - most of us specialize in bitwise
operations."

It sounds like the goal is to find the only two numbers in each row where one
evenly divides the other - that is, where the result of the division operation
is a whole number. They would like you to find those numbers on each line, divide
them, and add up each line's result.

For example, given the following spreadsheet:

5 9 2 8
9 4 7 3
3 8 6 5

In the first row, the numbers that evenly divide are 8 and 2; the result is 4.
In the second row, the two numbers are 9 and 3; the result is 3.
In the third row, the result is 2.

In this example, the sum of the results would be 4 + 3 + 2 = 9.

What is the sum of each row's result in your puzzle input?
"""

def test_row_division():
    assert row_division("5 9 2 8") == 4
    assert row_division("9 4 7 3") == 3
    assert row_division("3 8 6 5") == 2


def test_spreadsheet_checksum():
    test_spreadsheet = "5 9 2 8\n9 4 7 3\n3 8 6 5"
    assert spreadsheet_checksum(test_spreadsheet) == 9


def row_division(row):
    """Given a string of numbers, divides the ones that are evenly divisible and returns the result

    As the problem specifies, we'll assume that only one pair of numbers is
    evenly divisible

    The numbers must be separated by any whitespace character."""

    numbers = [int(char) for char in row.split()]

    # Sorting the array makes us not needing to worry about the numbers at the
    # left of the one we're currently examinating
    numbers.sort(reverse=True)

    # We'll examine all the possibilities by brute-force.
    # This is not a good approach, but as the spreadsheet is quite small (16x16),
    # we don't have much to worry about
    for i in range(len(numbers)):
        for j in range(i + 1, len(numbers)):
            int_division = numbers[i] / numbers[j]
            exact_division = numbers[i] / float(numbers[j])

            if int_division == exact_division:
                return int_division

def spreadsheet_checksum(spreadsheet):
    """Given a spreadsheet with numbers, computes its checksum

    The spreadsheet is expected to be a string where each line represents a row
    and where the numbers in each column are separated by a whitespace.

    The checksum is obtained by computing the division between the only two
    numbers of each row that are evenly divisible and then computing the sum
    of all these results."""

    count = 0
    rows = spreadsheet.splitlines()

    for row in rows:
        count += row_division(row)

    return count


if __name__ == '__main__':

    input_path = 'input.txt'
    input = open(input_path).read()

    result = spreadsheet_checksum(input)
    print(result)
