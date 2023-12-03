"""
--- Day 3: Gear Ratios ---
You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you. You go inside.

It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.

"Aaah!"

You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.

The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.

The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

Here is an example engine schematic:

467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..

In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?
"""

import math
from dataclasses import dataclass
from typing import List, Set, Tuple, NewType

# type Position = Tuple[int, int]
Position = NewType('Position', Tuple[int, int])

@dataclass
class Schematic():
    side_size: int # Assuming the schematic will always be squared
    _contents: List[str]

    @staticmethod
    def parse(schematic_text):
        content = []
        rows = 0
        for line in schematic_text.strip().split("\n"):
            for char in line:
                content.append(str(char))
            rows += 1
        
        return Schematic(rows, content)


    def __getitem__(self, idx: Position) -> str:
        if not isinstance(idx, tuple) or len(idx) != 2:
            raise Exception("Pass two indexes")

        row, col = idx
        position = row * self.side_size + col
        return self._contents[position]

    def __str__(self):
        str_result = ""
        for row in range(self.side_size):
            start_position = row * self.side_size
            # In Python indexing the last position is excluded, otherwise we'd need to substract 1
            end_position = (row + 1) * (self.side_size)
            
            str_result += "".join(str(elem) for elem in self._contents[start_position:end_position])
            str_result += "\n"
        
        return str_result.strip()
    
    def __repr__(self):
        return f"Schematic(\n{str(self)}\n)"

    def _position_to_indexes(self, position: int) -> Position:
        row = position // self.side_size
        col = position % self.side_size

        return (row, col)

    def _indexes_to_position(self, row: int, col: int) -> int:
        return row * self.side_size + col

    def _is_out_of_bounds(self, position: Position) -> bool:
        row, col = position

        if row < 0 or col < 0:
            return True
        
        if row >= self.side_size or col >= self.side_size:
            return True

        return False

    def is_symbol(self, position: Position) -> bool:
        if self._is_out_of_bounds(position):
            return False

        elem = self[position]

        if elem == ".":
            return False

        return not self.is_number(position)

    def is_number(self, position: Position) -> bool:
        if self._is_out_of_bounds(position):
            return False

        elem = self[position]

        try:
            # If we can cast the element to int, is not a symbol
            int(elem)
            return True
        except ValueError:
            return False


    def extract_number(self, position: Position) -> int:
        if not self.is_number(position):
            raise Exception(f"Invalid position, not a number -- position={position} content={self[position]}")

        row, col = position
        
        # We get to the start of the number
        while self.is_number((row, col)):
            col = col - 1

        # If the while stopped, it was not a number anymore, so we go back to the previous position
        col = col + 1

        # And now start composing the number
        number_str = ""
        while self.is_number((row, col)):
            number_str += self[row, col]
            col = col + 1

        return int(number_str)



class Day3:
    def part1(self, schematic=None):
        # input_file = "inputs/test/day3_b.txt"
        input_file = "inputs/day3.txt"

        if not schematic:
            schematic = Schematic.parse(open(input_file).read())

        symbol_pos = self.symbol_positions(schematic)

        adjacent_numbers = list()
        for symbol_position in symbol_pos:
            adjacent_numbers.extend(self.get_adjacent_numbers(schematic, symbol_position))

        print(f"ADJ - {adjacent_numbers}")

        return sum(adjacent_numbers)

    @classmethod
    def symbol_positions(cls, schematic: Schematic) -> List[Position]:
        symbol_positions = []

        for row in range(schematic.side_size):
            for col in range(schematic.side_size):
                if schematic.is_symbol((row, col)):
                    symbol_positions.append((row, col))

        return symbol_positions

    @classmethod
    def get_adjacent_numbers(cls, schematic: Schematic, position: Position) -> List[int]:
        adjacent_number_positions = cls._get_adjacent_numbers_positions(schematic, position)

        numbers = set()
        for position in adjacent_number_positions:
            # NOTE: This assumes that the same number will never be present more than once in
            # adjacency to a symbol. If that's not true, this method won't work.
            numbers.add(schematic.extract_number(position))

        return list(numbers)


    @classmethod
    def _get_adjacent_numbers_positions(cls, schematic: Schematic, position: Position) -> List[Position]:
        (row, col) = position

        adjacents = [
            [row - 1, col - 1],
            [row - 1, col],
            [row - 1, col + 1],
            [row, col - 1],
            [row, col + 1],
            [row + 1, col - 1],
            [row + 1, col],
            [row + 1, col + 1]
        ]

        return [
            (row, col)
            for [row, col] in adjacents
            if schematic.is_number((row, col))
        ]



    def part2():
        pass


class TestDay3:
    def test(self):
        s = Schematic.parse("""467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
        """)
        d = Day3()

        assert d.symbol_positions(s) == [(1, 3), (3, 6), (4, 3), (5, 5), (8, 3), (8, 5)]
        assert sorted(d.get_adjacent_numbers(s, (1, 3))) == [35, 467]
        assert sorted(d.get_adjacent_numbers(s, (5, 5))) == [592]
        assert sorted(d.get_adjacent_numbers(s, (8, 5))) == [598, 755]
        assert d.part1(s) == 4361


d = Day3()
print(f"PART 1 - {d.part1()}")