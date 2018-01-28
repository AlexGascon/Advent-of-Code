"""--- Day 14: Disk Defragmentation ---

Suddenly, a scheduled job activates the system's disk defragmenter. Were the
situation different, you might sit and watch it for a while, but today, you
just don't have that kind of time. It's soaking up valuable system resources
that are needed elsewhere, and so the only option is to help it finish its
task as soon as possible.

The disk in question consists of a 128x128 grid; each square of the grid is
either free or used. On this disk, the state of the grid is tracked by the
bits in a sequence of knot hashes.

A total of 128 knot hashes are calculated, each corresponding to a single row
in the grid; each hash contains 128 bits which correspond to individual grid
squares. Each bit of a hash indicates whether that square is free (0) or used (1).

The hash inputs are a key string (your puzzle input), a dash, and a number
from 0 to 127 corresponding to the row. For example, if your key string were
flqrgnkx, then the first row would be given by the bits of the knot hash of
flqrgnkx-0, the second row from the bits of the knot hash of flqrgnkx-1, and so
on until the last row, flqrgnkx-127.

The output of a knot hash is traditionally represented by 32 hexadecimal digits;
each of these digits correspond to 4 bits, for a total of 4 * 32 = 128 bits. To
convert to bits, turn each hexadecimal digit to its equivalent binary value,
high-bit first: 0 becomes 0000, 1 becomes 0001, e becomes 1110, f becomes 1111,
and so on; a hash that begins with a0c2017... in hexadecimal would begin with
10100000110000100000000101110000... in binary.

Continuing this process, the first 8 rows and columns for key flqrgnkx appear as
follows, using # to denote used squares, and . to denote free ones:

##.#.#..-->
.#.#.#.#
....#.#.
#.#.##.#
.##.#...
##..#..#
.#...#..
##.#.##.-->
|      |
V      V

In this example, 8108 squares are used across the entire 128x128 grid.

Given your actual key string, how many squares are used?

Your puzzle input is oundnydw"""

import Day_10.part_2

"""KNOT HASH PART"""

def dense_hash_element(sparse_hash_slice):

    result = sparse_hash_slice[0]
    for num in sparse_hash_slice[1:]:
        result ^= num

    return result

def calculate_dense_hash(sparse_hash):
    dense_hash = [0]*16
    for i in range(16):
        dense_hash[i] = dense_hash_element(sparse_hash[i*16:(i+1)*16])

    return dense_hash


def format_dense_hash(dense_hash):
    return ''.join('%02x' % num for num in dense_hash)



def ascii_knot_hash(stream, knot_size=256):
    knot = list(range(knot_size))
    start = 0
    skip_size = 0

    # Converting the lengths to ASCII
    ascii_lengths = [ord(char) for char in stream]
    ascii_lengths += [17, 31, 73, 47, 23]

    for _ in range(64):
        for length in ascii_lengths:

            # Normal case
            if start + length < knot_size:
                sublist = knot[start:start+length]
                sublist.reverse()

                knot[start:start + length] = sublist

            # Circular case
            else:
                circular_end = (start + length) % knot_size
                first_sublist = knot[start:]
                second_sublist = knot[:circular_end]
                sublist = first_sublist + second_sublist
                sublist.reverse()

                knot[start:] = sublist[:len(first_sublist)]
                knot[:circular_end] = sublist[len(first_sublist):]

            start += (length + skip_size)
            start = start % knot_size
            skip_size += 1

    pre_dense_hash = calculate_dense_hash(knot)
    dense_hash = format_dense_hash(pre_dense_hash)

    return dense_hash


"""ACTUAL CODE PART"""

def used_bits(input_str):
    knot_hash = Day_10.part_2.ascii_knot_hash(input_str)
    return hex_to_bits(knot_hash).count('1')


def hex_to_bits(hex):
    return bin(int(hex, 16))[2:]


if __name__ == '__main__':
    is_test = False
    input_value = 'flqrgnkx' if is_test else 'oundnydw'

    total_used = 0
    for num in range(128):
        total_used += used_bits(f"{input_value}-{num}")

    print(f"USED BITS: {total_used}")



