"""
--- Day 3: Spiral Memory ---

You come across an experimental new kind of memory stored on an infinite
two-dimensional grid.

Each square on the grid is allocated in a spiral pattern starting at a location
marked 1 and then counting up while spiraling outward. For example, the first
few squares are allocated like this:

17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...

While this is very space-efficient (no squares are skipped), requested data must
be carried back to square 1 (the location of the only access port for this
memory system) by programs that can only move up, down, left, or right. They
always take the shortest path: the Manhattan Distance between the location of
the data and square 1.

For example:

    Data from square 1 is carried 0 steps, since it's at the access port.
    Data from square 12 is carried 3 steps, such as: down, left, left.
    Data from square 23 is carried only 2 steps: up twice.
    Data from square 1024 must be carried 31 steps.

How many steps are required to carry the data from the square identified in
your puzzle input all the way to the access port?
"""

from math import sqrt, ceil


def test_step_amount_required():
    # Test cases provided by the challenge description
    assert step_amount_required(1) == 0
    assert step_amount_required(12) == 3
    assert step_amount_required(23) == 2
    assert step_amount_required(1024) == 31
    # Own test cases
    assert step_amount_required(9) == 2
    assert step_amount_required(25) == 4
    assert step_amount_required(49) == 6
    assert step_amount_required(4) == 1
    assert step_amount_required(16) == 3
    assert step_amount_required(36) == 5


def test_next_odd_square():
    assert next_odd_square(10) == 25
    assert next_odd_square(32) == 49
    assert next_odd_square(2) == 9
    assert next_odd_square(36) == 49
    assert next_odd_square(18) == 25
    assert next_odd_square(24) == 25


def test_corner_to_center():
    assert corner_to_center(9) == 2
    assert corner_to_center(25) == 4
    assert corner_to_center(49) == 6
    assert corner_to_center(81) == 8
    assert corner_to_center(1089) == 32


def test_distance_from_corner():
    assert distance_from_corner(25) == 0
    assert distance_from_corner(22) == 1
    assert distance_from_corner(39) == 2
    assert distance_from_corner(14) == 1
    assert distance_from_corner(6) == 1
    assert distance_from_corner(33) == 2
    assert distance_from_corner(61) == 4
    assert distance_from_corner(35) == 2
    assert distance_from_corner(44) == 1
    assert distance_from_corner(27) == 2
    assert distance_from_corner(26) == 1
    assert distance_from_corner(30) == 1
    assert distance_from_corner(12) == 1


def next_odd_square(x):
    closest_square_root = ceil(sqrt(x))

    if closest_square_root % 2 == 0:
        return (closest_square_root + 1)**2
    else:
        return closest_square_root**2


def corner_to_center(corner):
    return sqrt(corner) - 1


def distance_from_corner(x):
    next_corner = next_odd_square(x)
    side_length = sqrt(next_odd_square(x))
    distance_between_corners = side_length - 1
    previous_corner = next_corner - distance_between_corners

    while previous_corner > x:
        next_corner, previous_corner = previous_corner, previous_corner - distance_between_corners

    return min(next_corner - x, x - previous_corner)


def step_amount_required(x):
    closest_odd_square = next_odd_square(x)

    return corner_to_center(closest_odd_square) - distance_from_corner(x)


if __name__ == '__main__':
    input_value = 265149
    print(step_amount_required(input_value))
