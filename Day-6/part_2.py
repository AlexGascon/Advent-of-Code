"""--- Part Two ---

Out of curiosity, the debugger would also like to know the size of the loop:
starting from a state that has already been seen, how many block redistribution
cycles must be performed before that same state is seen again?

In the example above, 2 4 1 2 is seen again after four cycles, and so the answer
in that example would be 4.

How many cycles are in the infinite loop that arises from the configuration in
your puzzle input?
"""

def test_steps_to_repetition():
    assert steps_to_repetition([0, 2, 7, 0]) == 4


"""FOLLOWED APPROACH

The approach followed here is very similar to the one used in part 1. The 
main difference is that now we'll use a dictionary to store all the configurations.
As the value, we'll use the amount of steps that we had done when we got that
configuration. Then, when we find it again, we'll just have to substract that
value to the current number of steps.

Another difference is that, as we can't use an array as a dict's key (as it isn't
a hashable element), we'll convert it to a comma-separated string first"""


def get_max(configuration):
    max_index, max_value = max(enumerate(configuration), key=lambda x: x[1])
    return max_value, max_index

def hashable_configuration(configuration):
    """Converts the configuration array to a string.

    This we'll let us use it as a dict key"""
    return ",".join(str(num) for num in configuration)


def steps_to_repetition(initial_configuration):

    configuration = list(initial_configuration)
    length = len(configuration)

    steps = 0
    configurations = {}

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
        # If it's already in the dict, we'll finish the execution and return
        # the current number of steps - the value of the dict for that configuration
        steps += 1
        hashed_configuration = hashable_configuration(configuration)
        if hashed_configuration in configurations:
            return steps - configurations[hashed_configuration]
        else:
            configurations[hashed_configuration] = steps


if __name__ == '__main__':
    input_path = 'input.txt'
    input = open(input_path).read()

    input = [int(num) for num in input.split()]
    print(steps_to_repetition(input))