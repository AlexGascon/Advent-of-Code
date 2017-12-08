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


"""TEST CASES"""
def test_steps_to_center():
    # Test cases provided by the challenge description
    assert steps_to_center(1) == 0
    assert steps_to_center(12) == 3
    assert steps_to_center(23) == 2
    assert steps_to_center(1024) == 31
    # Own test cases
    assert steps_to_center(9) == 2
    assert steps_to_center(25) == 4
    assert steps_to_center(49) == 6
    assert steps_to_center(4) == 1
    assert steps_to_center(16) == 3
    assert steps_to_center(36) == 5


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


"""FOLLOWED APPROACH

If we draw a big-enough portion of the spiral:

65  64  63  62  61  60  59  58  57
    37  36  35  34  33  32  31  56
.   38  17  16  15  14  13  30  55
.   39  18   5   4   3  12  29  54
.   40  19   6   1   2  11  28  53
    41  20   7   8   9  10  27  52
    42  21  22  23  24  25  26  51
    43  44  45  46  47  48  49  50
             .  .  .            81

we'll be able to appreciate that the numbers that appear in the lower-left 
diagonal are the squared values of the odd integers (9, 25, 49, 81...). Besides,
due to the direction followed by the spiral, the values on this diagonal are 
always the ones that complete a square. This has grants us a huge advantage:
given any number, we can know in which layer it's located: we just need to find
the immediately superior squared odd number.

Knowing the value of this corner, we can also compute its distance to the center:
it always corresponds to (its square root - 1) (i.e. 25 is 4 steps away, 9 is 2
steps away, 81 is 8, etc). And this is very important, because the corners of 
each layer have another interesting property: they are the farthest point in 
that layer. Each step away from the corner that we take, no matter in which 
direction (if we stay on the same layer, of course), will be a step closer to 
the center.

Therefore, there's an easy way to compute the distance to the center for every
point: we just need to find the distance from the corners of that layer to the
center, and the distance from that point to the closest corner. As we've said,
each step away of the corner is a step towards the center, and therefore:

d(point, center) = d(corner, center) - d(corner, point) 

"""


"""CODE"""
def next_odd_square(x):
    """Returns the immediately superior squared-odd-integer of a given number x"""
    closest_square_root = ceil(sqrt(x))

    if closest_square_root % 2 == 0:
        return (closest_square_root + 1)**2
    else:
        return closest_square_root**2


def corner_to_center(corner):
    """Computes the distance from a corner to the center of the spiral.
    IMPORTANT: the given corner must be located on the lower-right diagonal
    of the spiral"""
    return sqrt(corner) - 1


def closest_corners(x):
    """Finds out the value of the two corners closest to a given number (the
    previous and the following one)"""

    side_length = sqrt(next_odd_square(x))
    distance_between_corners = side_length - 1

    # We start on the lower right corner (the one we can find)
    next_corner = next_odd_square(x)
    previous_corner = next_corner - distance_between_corners

    # Then, we iterate until we found the ones surrounding the wanted number
    while previous_corner > x:
        next_corner, previous_corner = previous_corner, previous_corner - distance_between_corners

    return next_corner, previous_corner


def distance_from_corner(x):
    """Calculates the distance to the closest corner"""
    next_corner, previous_corner = closest_corners(x)
    return min(next_corner - x, x - previous_corner)


def steps_to_center(x):
    """Calculates the amount of steps to get to the center from a specific square"""
    closest_odd_square = next_odd_square(x)

    return int(corner_to_center(closest_odd_square) - distance_from_corner(x))


if __name__ == '__main__':
    input_value = 265149
    print(steps_to_center(input_value))
