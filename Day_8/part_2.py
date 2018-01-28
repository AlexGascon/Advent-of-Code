"""
--- Part Two ---

To be safe, the CPU also needs to know the highest value held in any register
during this process so that it can decide how much memory to allocate to these
operations. For example, in the above instructions, the highest value ever held
was 10 (in register c after the third instruction was evaluated).

"""


def test_parse_instruction():
    test_instruction_1 = 'b inc 5 if a > 1'
    expected_1 = {
        'variable': 'b',
        'operation': 'inc',
        'amount': 5,
        'condition': 'a > 1'
    }

    test_instruction_2 = 'c dec -10 if a >= 1'
    expected_2 = {
        'variable': 'c',
        'operation': 'dec',
        'amount': -10,
        'condition': 'a >= 1'
    }

    assert parse_instruction(test_instruction_1) == expected_1
    assert parse_instruction(test_instruction_2) == expected_2


def parse_instruction(instruction):
    """Given an instruction, returns a dict with its parts.

    The instruction should be a string of the form:
    a inc 5 if x > 1
    b dec 24 if c <= 2"""
    variable, operation, amount, _, *condition = instruction.split()

    instruction_dict = {
        'variable': variable,
        'operation': operation,
        'amount': int(amount),
        'condition': ' '.join(condition)
    }

    return instruction_dict


if __name__ == '__main__':
    input_path = 'input.txt'
    input = open(input_path).readlines()

    registers = {}
    max_value = 0

    for raw_instruction in input:
        instruction = parse_instruction(raw_instruction)

        # Getting the value of the variable with a get to avoid NameError exceptions
        condition_variable, *condition_op = instruction['condition'].split()
        conditional_operation = "registers.get('{}', 0) ".format(condition_variable) + " ".join(condition_op)

        if eval(conditional_operation):
            amount = instruction['amount'] if instruction['operation'] == 'inc' else (-instruction['amount'])
            variable = instruction['variable']

            registers[variable] = registers.get(variable, 0) + amount

            # We just need to modify the loop to keep track of the value we got
            # after each iteration and to check if it's the max
            if registers[variable] > max_value:
                max_value = registers[variable]

    print(max_value)
