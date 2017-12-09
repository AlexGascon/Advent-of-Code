"""--- Day 8: I Heard You Like Registers ---

You receive a signal directly from the CPU. Because of your recent assistance
with jump instructions, it would like you to compute the result of a series of
unusual register instructions.

Each instruction consists of several parts: the register to modify, whether to
increase or decrease that register's value, the amount by which to increase or
decrease it, and a condition. If the condition fails, skip the instruction
without modifying the register. The registers all start at 0. The instructions
look like this:

b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10

These instructions would be processed as follows:

    Because a starts at 0, it is not greater than 1, and so b is not modified.
    a is increased by 1 (to 1) because b is less than 5 (it is 0).
    c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
    c is increased by -20 (to -10) because c is equal to 10.

After this process, the largest value in any register is 1.

You might also encounter <= (less than or equal to) or != (not equal to). However,
the CPU doesn't have the bandwidth to tell you what all the registers are named,
and leaves that to you to determine.

What is the largest value in any register after completing the instructions in your
puzzle input?
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


def test_find_max_register():
    assert find_max_register({'a': 1, 'c': -10}) == 1


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


def find_max_register(registers):
    """Returns the max value in a dictionary"""
    return max(registers.values())




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

    print(find_max_register(registers))
