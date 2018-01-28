"""--- Day 5: A Maze of Twisty Trampolines, All Alike ---

An urgent interrupt arrives from the CPU: it's trapped in a maze of jump
instructions, and it would like assistance from any programs with spare cycles
to help find the exit.

The message includes a list of the offsets for each jump. Jumps are relative: -1
moves to the previous instruction, and 2 skips the next one. Start at the first
instruction in the list. The goal is to follow the jumps until one leads outside
the list.

In addition, these instructions are a little strange; after each jump, the offset
of that instruction increases by 1. So, if you come across an offset of 3, you
would move three instructions forward, but change it to a 4 for the next time it
is encountered.

For example, consider the following list of jump offsets:

0
3
0
1
-3

Positive jumps ("forward") move downward; negative jumps move upward. For
legibility in this example, these offset values will be written all on one line,
with the current instruction marked in parentheses. The following steps would be
taken before an exit is found:

    (0) 3  0  1  -3  - before we have taken any steps.
    (1) 3  0  1  -3  - jump with offset 0 (that is, don't jump at all).
    Fortunately, the instruction is then incremented to 1.
     2 (3) 0  1  -3  - step forward because of the instruction we just modified.
     The first instruction is incremented again, now to 2.
     2  4  0  1 (-3) - jump all the way to the end; leave a 4 behind.
     2 (4) 0  1  -2  - go back to where we just were; increment -3 to -2.
     2  5  0  1  -2  - jump 4 steps forward, escaping the maze.

In this example, the exit is reached in 5 steps.

How many steps does it take to reach the exit?
"""


"""TEST CASES"""
def test_steps_to_exit():
    assert steps_to_exit([0, 3, 0, 1, -3]) == 5


"""FOLLOWED APPROACH

We'll follow the same approach that has been used in the example: we'll create
an array representing the value of each offset, and then we'll go through it.

In order to do this, we'll use two auxiliar variables: position (to keep track
of our position inside the array) and steps. As long as position is within the
limits of the array (i.e. < len(maze) && >= 0) we'll keep looping. 

In each iteration, we'll update the number of steps we've taken, our position
and the value of the position in which we started the iteration"""


def steps_to_exit(maze):
    """Given an array representing a maze, returns the amount of steps needed to exit it

    The elements of the array must be integers. """
    position = 0
    steps = 0
    maze_length = len(maze)

    while 0 <= position < maze_length:
        steps += 1
        previous_position = position

        position = position + maze[previous_position]
        maze[previous_position] += 1

    return steps


if __name__ == '__main__':
    input_path = 'input.txt'
    input = open(input_path).readlines()
    input = [int(num) for num in input]

    print(steps_to_exit(input))
