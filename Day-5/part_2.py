"""--- Part Two ---

Now, the jumps are even stranger: after each jump, if the offset was three or
more, instead decrease it by 1. Otherwise, increase it by 1 as before.

Using this rule with the above example, the process now takes 10 steps, and
the offset values after finding the exit are left as 2 3 2 3 -1.

How many steps does it now take to reach the exit?
"""


"""TEST CASES"""
def test_steps_to_exit():
    assert steps_to_exit([0, 3, 0, 1, -3]) == 10


"""FOLLOWED APPROACH
We'll use the same code than in the previous part, but updating the part where
we update the value of the position of the maze in which we started the iteration
"""
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

        if maze[previous_position] >= 3:
            maze[previous_position] -= 1
        else:
            maze[previous_position] += 1

    return steps


if __name__ == '__main__':
    input_path = 'input.txt'
    input = [int(num) for num in open(input_path).readlines()]

    print(steps_to_exit(input))
