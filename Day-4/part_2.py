"""--- Part Two ---

For added security, yet another system policy has been put in place. Now, a
valid passphrase must contain no two words that are anagrams of each other -
that is, a passphrase is invalid if any word's letters can be rearranged to
form any other word in the passphrase.

For example:

    abcde fghij is a valid passphrase.
    abcde xyz ecdab is not valid - the letters from the third word can be
    rearranged to form the first word.
    a ab abc abd abf abj is a valid passphrase, because all letters need to be
    used when forming another word.
    iiii oiii ooii oooi oooo is valid.
    oiii ioii iioi iiio is not valid - any of these words can be rearranged to
    form any other word.

Under this new system policy, how many passphrases are valid?
"""


"""TEST CASES"""
def test_is_passphrase_valid():
    assert is_passphrase_valid("abcde fghij") == True
    assert is_passphrase_valid("abcde xyz ecdab") == False
    assert is_passphrase_valid("a ab abc abd abf abj") == True
    assert is_passphrase_valid("iiii oiii ooii oooi oooo") == True
    assert is_passphrase_valid("oiii ioii iioi iiio") == False

"""
FOLLOWED APPROACH

This time we'll have to do the check at letter level, not at word level.
Therefore we won't use sets, because as only one instance of each element will
appear on it, set(ooii) == set(oiii). 

What we'll do instead is to create arrays with the letters of each word, sort
them and store them in another array. But, before storing them, we'll check if
they're already in the array, and if that's the case we'll consider the passphrase
as invalid.

As we're sorting the array before storing it, the order of the letters in each
word doesn't matter, so we can easily catch anagrams
Pseudocode example: 
sorted(letters_in_word(abcde)) == sorted(letters_in_word(edcba))"""


def is_passphrase_valid(passphrase):
    """Returns True if there are no anagrams in the passphrase"""

    word_chars = []

    for word in passphrase.split():
        chars_in_word = sorted(word)

        if chars_in_word in word_chars:
            return False
        else:
            word_chars.append(chars_in_word)

    # If at the end of the loop we haven't found any coincidence, there are
    # no anagrams in the passphrase. Therefore, we'll return True.
    return True


if __name__ == '__main__':
    input_path = 'input.txt'
    input = open(input_path).readlines()

    valid_passphrases = 0

    for passphrase in input:
        if is_passphrase_valid(passphrase):
            valid_passphrases += 1

    print(valid_passphrases)