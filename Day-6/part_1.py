"""--- Day 6: Memory Reallocation ---

A debugger program here is having an issue: it is trying to repair a memory
reallocation routine, but it keeps getting stuck in an infinite loop.

In this area, there are sixteen memory banks; each memory bank can hold any
number of blocks. The goal of the reallocation routine is to balance the blocks
between the memory banks.

The reallocation routine operates in cycles. In each cycle, it finds the memory
bank with the most blocks (ties won by the lowest-numbered memory bank) and
redistributes those blocks among the banks. To do this, it removes all of the
blocks from the selected bank, then moves to the next (by index) memory bank and
inserts one of the blocks. It continues doing this until it runs out of blocks;
if it reaches the last memory bank, it wraps around to the first one.

The debugger would like to know how many redistributions can be done before a
blocks-in-banks configuration is produced that has been seen before.

For example, imagine a scenario with only four memory banks:

    - The banks start with 0, 2, 7, and 0 blocks. The third bank has the most
    blocks, so it is chosen for redistribution.
    - Starting with the next bank (the fourth bank) and then continuing to the
    first bank, the second bank, and so on, the 7 blocks are spread out over
    the memory banks. The fourth, first, and second banks get two blocks each,
    and the third bank gets one back. The final result looks like this: 2 4 1 2.
    - Next, the second bank is chosen because it contains the most blocks (four).
    Because there are four memory banks, each gets one block. The result
    is: 3 1 2 3.
    - Now, there is a tie between the first and fourth memory banks, both of
    which have three blocks. The first bank wins the tie, and its three blocks
    are distributed evenly over the other three banks, leaving it with none: 0 2 3 4.
    - The fourth bank is chosen, and its four blocks are distributed such that
    each of the four banks receives one: 1 3 4 1.
    - The third bank is chosen, and the same thing happens: 2 4 1 2.

At this point, we've reached a state we've seen before: 2 4 1 2 was already seen.
The infinite loop is detected after the fifth block redistribution cycle, and
so the answer in this example is 5.

Given the initial block counts in your puzzle input, how many redistribution
cycles must be completed before a configuration is produced that has been seen
before?
"""

def test_steps_to_repetition():
    assert steps_to_repetition([0, 2, 7, 0]) == 5


"""FOLLOWED APPROACH

We will use an infinite loop to allocate the memory as the challenge specifies,
along with a variable ('steps') to store the amount of steps we've used.

We'll have an array ('configurations') in which we'll store the configurations
that we have at the end of each iteration. Before storing it, we'll check if it
has already been stored, and if that's the case, we will return the 
current amount of steps."""


def get_max(configuration):
    max_index, max_value = max(enumerate(configuration), key=lambda x: x[1])
    return max_value, max_index

def copy_list(list_to_copy):
    """Returns a copy of the list to avoid modifying the original one"""
    return list(list_to_copy)


def steps_to_repetition(initial_configuration):

    configuration = copy_list(initial_configuration)
    length = len(configuration)

    steps = 0
    configurations = []

    while True:
        # Getting the index of the maximum value
        max_value, max_index = get_max(configuration)

        configuration[max_index] = 0
        next_index = (max_index + 1) % length

        # If the reallocation hasn't finished, we increase the corresponding value,
        # find which is the next index to update (circular increase by 1) and
        # reduce by one the amount of blocks left
        while max_value > 0:
            configuration[next_index] += 1
            next_index = (next_index + 1) % length
            max_value -= 1

        # After finishing the distribution, we store the current configuration
        # If it's already in the array, we'll finish the execution and return
        # the current number of steps
        steps += 1
        if configuration in configurations:
            return steps
        else:
            configurations.append(copy_list(configuration))


if __name__ == '__main__':
    input_path = 'input.txt'
    input = open(input_path).read()

    input = [int(num) for num in input.split()]
    print(steps_to_repetition(input))
