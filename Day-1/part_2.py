"""
--- Part Two ---

You notice a progress bar that jumps to 50% completion. Apparently, the door isn't yet satisfied, but it did emit a
star as encouragement. The instructions change:

Now, instead of considering the next digit, it wants you to consider the digit halfway around the circular list.
That is, if your list contains 10 items, only include a digit in your sum if the digit 10/2 = 5 steps forward matches
it. Fortunately, your list has an even number of elements.

For example:
    1212 produces 6: the list contains 4 items, and all four digits match the digit 2 items ahead.
    1221 produces 0, because every comparison is between a 1 and a 2.
    123425 produces 4, because both 2s match each other, but no other digit has a match.
    123123 produces 12.
    12131415 produces 4.

What is the solution to your new captcha?
"""

def test_captcha_2():
    assert solve_captcha_2("1212") == 6
    assert solve_captcha_2("1221") == 0
    assert solve_captcha_2("123425") == 4
    assert solve_captcha_2("123123") == 12
    assert solve_captcha_2("12131415") == 4


def solve_captcha_2(captcha):
    count = 0
    length = len(captcha)

    for i in range(length):
        current = int(captcha[i])
        # We have to use the modulo operation to avoid getting an index out of range
        halfway_index = (i + length/2) % length
        halfway = int(captcha[halfway_index])

        if current == halfway:
            count += current

    return count


if __name__ == '__main__':
    # The input is the same we used on the first part
    input_path = 'input.txt'
    input_content = open(input_path).read()

    result = solve_captcha_2(input_content)
    print (result)