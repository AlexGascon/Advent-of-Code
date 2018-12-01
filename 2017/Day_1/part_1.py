"""Day 1: Inverse Captcha (http://adventofcode.com/2017/day/1)

The night before Christmas, one of Santa's Elves calls you in a panic. "The printer's broken! We can't print the
Naughty or Nice List!" By the time you make it to sub-basement 17, there are only a few minutes until midnight. "We
have a big problem," she says; "there must be almost fifty bugs in this system, but nothing else can print The List.
Stand in this square, quick! There's no time to explain; if you can convince them to pay you in stars, you'll be able
to--" She pulls a lever and the world goes blurry.

When your eyes can focus again, everything seems a lot more pixelated than before. She must have sent you inside the
computer! You check the system clock: 25 milliseconds until midnight. With that much time, you should be able to
collect all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day millisecond in the advent calendar;
the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

You're standing in a room with "digitization quarantine" written in LEDs along one wall. The only door is locked, but
it includes a small interface. "Restricted Area - Strictly No Digitized Users Allowed."

It goes on to explain that you may only leave by solving a captcha to prove you're not a human. Apparently, you only
get one millisecond to solve the captcha: too fast for a normal human, but it feels like hours to you.

The captcha requires you to review a sequence of digits (your puzzle input) and find the sum of all digits that match
the next digit in the list. The list is circular, so the digit after the last digit is the first digit in the list.

For example:
    1122 produces a sum of 3 (1 + 2) because the 1st digit matches the 2nd digit and the third digit matches the 4th digit.
    1111 produces 4 because each digit (all 1) matches the next.
    1234 produces 0 because no digit matches the next.
    91212129 produces 9 because the only digit that matches the next one is the last digit, 9.

What is the solution to your captcha?
"""

def test_captcha():
    assert solve_captcha("1122") == 3
    assert solve_captcha("1111") == 4
    assert solve_captcha("1234") == 0
    assert solve_captcha("91212129") == 9


def solve_captcha(captcha):
    count = 0

    # We iterate over range(len(captcha)) because it allows us to easily compare
    # the first (0) and the last (-1) elements of the array
    for i in range(len(captcha)):
        current = int(captcha[i])
        previous = int(captcha[i-1])

        if current == previous:
            count += current

    return count


if __name__ == '__main__':

    input_path = 'input.txt'
    input_content = open(input_path).read()

    result = solve_captcha(input_content)
    print (result)
