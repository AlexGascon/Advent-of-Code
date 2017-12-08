"""--- Part Two ---

The programs explain the situation: they can't get down. Rather, they could get
down, if they weren't expending all of their energy trying to keep the tower
balanced. Apparently, one program has the wrong weight, and until it's fixed,
they're stuck here.

For any program holding a disc, each program standing on that disc forms a
sub-tower. Each of those sub-towers are supposed to be the same weight, or the
disc itself isn't balanced. The weight of a tower is the sum of the weights of
the programs in that tower.

In the example above, this means that for ugml's disc to be balanced, gyxo,
ebii, and jptl must all have the same weight, and they do: 61.

However, for tknk to be balanced, each of the programs standing on its disc and
all programs above it must each match. This means that the following sums must
all be the same:

    ugml + (gyxo + ebii + jptl) = 68 + (61 + 61 + 61) = 251
    padx + (pbga + havc + qoyq) = 45 + (66 + 66 + 66) = 243
    fwft + (ktlj + cntj + xhth) = 72 + (57 + 57 + 57) = 243

As you can see, tknk's disc is unbalanced: ugml's stack is heavier than the
other two. Even though the nodes above ugml are balanced, ugml itself is too
heavy: it needs to be 8 units lighter for its stack to weigh 243 and keep the
towers balanced. If this change were made, its weight would be 60.

Given that exactly one program is the wrong weight, what would its weight need
to be to balance the entire tower?
"""



def test_create_programs_dict():
    test_input = """pbga (66)
                    xhth (57)
                    ebii (61)
                    havc (66)
                    ktlj (57)
                    fwft (72) -> ktlj, cntj, xhth
                    qoyq (66)
                    padx (45) -> pbga, havc, qoyq
                    tknk (41) -> ugml, padx, fwft
                    jptl (61)
                    ugml (68) -> gyxo, ebii, jptl
                    gyxo (61)
                    cntj (57)""".splitlines()

    expected_output = {
        "tknk": ["ugml", "padx", "fwft"],
        "ugml": ["gyxo", "ebii", "jptl"],
        "padx": ["pbga", "havc", "qoyq"],
        "fwft": ["ktlj", "cntj", "xhth"]
    }

    assert create_children_dict(test_input) == expected_output

def test_subtower_weight():
    test_input = """pbga (66)
                    xhth (57)
                    ebii (61)
                    havc (66)
                    ktlj (57)
                    fwft (72) -> ktlj, cntj, xhth
                    qoyq (66)
                    padx (45) -> pbga, havc, qoyq
                    tknk (41) -> ugml, padx, fwft
                    jptl (61)
                    ugml (68) -> gyxo, ebii, jptl
                    gyxo (61)
                    cntj (57)""".splitlines()

    children = create_children_dict(test_input)
    weights = create_children_weight_dict(test_input)

    assert program_weight("gyxo", children, weights) == 61
    assert program_weight("cntj", children, weights) == 57
    assert program_weight("ebii", children, weights) == 61
    assert program_weight("ugml", children, weights) == 251
    assert program_weight("padx", children, weights) == 243
    assert program_weight("fwft", children, weights) == 243



def has_children(program):
    return program.find('->') != -1


def create_children_dict(input):
    children = {}
    for program in input:
        parent_name = program.split()[0]

        if has_children(program):
            current_children = program.split(' -> ')[1].split(', ')
            children[parent_name] = current_children

    return children


def create_children_weight_dict(input):
    weights = {}

    for program in input:
        program_info = program.split()

        name = program_info[0]
        weight = int(program_info[1][1:-1])  # Removing parenthesis and casting

        weights[name] = weight

    return weights


def program_weight(program, children, weights):

    if program in children.keys():
        total_weight = weights[program]
        for child in children[program]:
            total_weight += program_weight(child, children, weights)
        return total_weight
    else:
        return weights[program]


def is_balanced(program_children, children, weights):
    ws = [program_weight(child, children, weights) for child in program_children]
    return len(set(ws)) == 1


def find_unbalanced_program(programs, children, weights, parent):
    for program in programs:
        program_name = program.split()[0]

        program_children = children.get(program, list([]))

        if not is_balanced(program_children, children, weights):
            return find_unbalanced_program(program_children, children, weights, program_name)

    return parent


if __name__ == '__main__':
    input_path = 'input.txt'
    input = open(input_path).read().splitlines()

    children = create_children_dict(input)
    weights = create_children_weight_dict(input)
    unbalanced_parents = []

    possible_problems = [prog.split()[0] for prog in input if len(prog.split()) > 5]
    unbalanced = find_unbalanced_program(possible_problems, children, weights, None)

    # Aquí, unbalanced será el padre que contiene el array que necesita balanceo
    # Si sacamos el peso de los hijos, veremos que hay uno que se pasa.

    # IMPORTANTE: LOS PESOS HAY QUE SACARLOS CON program_weight

    # La respuesta al reto es:
    # <Peso del hijo que se pasa> - <Cantidad de peso que se pasa>

    # TODO: MIRAR DE QUÉ FORMA PUEDE HACERSE PROGRAMÁTICAMENTE




