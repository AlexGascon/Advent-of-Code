"""--- Day 4: High-Entropy Passphrases ---

A new system policy has been put in place that requires all accounts to use
a passphrase instead of simply a password. A passphrase consists of a series
of words (lowercase letters) separated by spaces.

To ensure security, a valid passphrase must contain no duplicate words.

For example:

    aa bb cc dd ee is valid.
    aa bb cc dd aa is not valid - the word aa appears more than once.
    aa bb cc dd aaa is valid - aa and aaa count as different words.

The system's full passphrase list is available as your puzzle input. How many
passphrases are valid?
"""

def test_is_passphrase_valid():
    assert is_passphrase_valid("aa bb cc dd ee") == True
    assert is_passphrase_valid("aa bb cc dd aa") == False
    assert is_passphrase_valid("aa bb cc dd aaa") == True

def is_passphrase_valid(passphrase_string):
    """Returns true if there are no repeated words in the passphrase

    To calculate this easily, we'll convert the passphrase to an array of words
    and then create a set from it. A set stores each value just once, so if the
    amount of elements in the set is not equal to the amount of elements in the
    array, is because some word is repeated."""
    passphrase = passphrase_string.split()
    return len(passphrase) == len(set(passphrase))

if __name__ == '__main__':
    input_path = 'input.txt'
    input = open(input_path).readlines()

    valid_passphrases = 0

    for passphrase in input:
        if is_passphrase_valid(passphrase):
            valid_passphrases += 1

    print(valid_passphrases)