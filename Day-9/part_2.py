"""--- Part Two ---

Now, you're ready to remove the garbage.

To prove you've removed it, you need to count all of the characters within the
garbage. The leading and trailing < and > don't count, nor do any canceled
characters or the ! doing the canceling.

    <>, 0 characters.
    <random characters>, 17 characters.
    <<<<>, 3 characters.
    <{!>}>, 2 characters.
    <!!>, 0 characters.
    <!!!>>, 0 characters.
    <{o"i!a,<{i<a>, 10 characters.

How many non-canceled characters are within the garbage in your puzzle input?
"""

import re

def test_counting_garbage():
    assert counting_garbage('<>') == 0
    assert counting_garbage('<random characters>') == 17
    assert counting_garbage('<<<<>') == 3
    assert counting_garbage('<{!>}>') == 2
    assert counting_garbage('<!!>') == 0
    assert counting_garbage('<!!!>>') == 0
    assert counting_garbage('<{o"i!a,<{i<a>') == 10



def remove_ignores(stream):
    new_stream = ""

    ignored = False
    for character in stream:
        if character == '!' and not ignored:
            ignored = True

        elif ignored:
            ignored = False

        else:
            new_stream += character
            ignored = False

    return new_stream

def remove_garbage(stream):
    pattern = r'<.*?>'
    compiled_regex = re.compile(pattern)

    garbage_matches = len(re.findall(compiled_regex, stream))

    return re.sub(pattern, '', stream), garbage_matches


def counting_garbage(stream, current_level=0):
    stream = remove_ignores(stream)
    non_garbage_stream, garbages = remove_garbage(stream)

    return len(stream) - len(non_garbage_stream) - 2*garbages


if __name__ == '__main__':
    input_file = 'input.txt'
    input_content = open(input_file).read()

    print(f'RESULT: {counting_garbage(input_content)}')

