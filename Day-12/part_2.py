"""--- Part Two ---

There are more programs than just the ones in the group containing program ID 0.
The rest of them have no way of reaching that group, and still might have no
way of reaching each other.

A group is a collection of programs that can all communicate via pipes either
directly or indirectly. The programs you identified just a moment ago are all
part of the same group. Now, they would like you to determine the total number
of groups.

In the example above, there were 2 groups: one consisting of programs
0,2,3,4,5,6, and the other consisting solely of program 1.

How many groups are there in total?
"""

def test_count_groups():
    example = """
    0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5
    """

    assert count_groups(example) == 2

def parse_programs(programs_diagram):
    programs_array = programs_diagram.strip().splitlines()

    programs = {}
    for program in programs_array:
        root_str, connected_to_str = program.split(' <-> ')
        root = int(root_str)
        connected_to = [int(num) for num in connected_to_str.split(',')]

        programs[root] = connected_to

    return programs


def count_groups(programs_diagram):
    programs = parse_programs(programs_diagram)
    groups = 0
    already_classified = set()

    # We can do this because we know that the keys are a list of consecutive
    # integers. Otherwise, we'll have to use another approach
    programs_keys = range(len(programs))
    keys_not_visited = set(programs_keys)

    while len(already_classified) != len(programs):
        keys_visited = set()
        keys_to_visit = {keys_not_visited.pop()}

        while keys_to_visit:
            key_to_visit = keys_to_visit.pop()
            programs_connected = programs[key_to_visit]

            for program in programs_connected:
                if program not in keys_visited:
                    keys_to_visit.add(program)
                    keys_visited.add(program)

                already_classified.add(program)

        groups += 1
        keys_not_visited = keys_not_visited.difference(keys_visited)

    return groups


if __name__ == '__main__':
    with open('input.txt') as input_file:
        input_content = input_file.read()

    result = count_groups(input_content)
    print(f"GROUPS: {result}")