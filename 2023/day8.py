"""
--- Day 8: Haunted Wasteland ---
You're still riding a camel across Desert Island when you spot a sandstorm quickly approaching. When you turn to warn the Elf, she disappears before your eyes! To be fair, she had just finished warning you about ghosts a few minutes ago.

One of the camel's pouches is labeled "maps" - sure enough, it's full of documents (your puzzle input) about how to navigate the desert. At least, you're pretty sure that's what they are; one of the documents contains a list of left/right instructions, and the rest of the documents seem to describe some kind of network of labeled nodes.

It seems like you're meant to use the left/right instructions to navigate the network. Perhaps if you have the camel follow the same instructions, you can escape the haunted wasteland!

After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel like AAA is where you are now, and you have to follow the left/right instructions until you reach ZZZ.

This format defines each node of the network individually. For example:

RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)

Starting with AAA, you need to look up the next element based on the next left/right instruction in your input. In this example, start with AAA and go right (R) by choosing the right element of AAA, CCC. Then, L means to choose the left element of CCC, ZZZ. By following the left/right instructions, you reach ZZZ in 2 steps.

Of course, you might not find ZZZ right away. If you run out of left/right instructions, repeat the whole sequence of instructions as necessary: RL really means RLRLRLRLRLRLRLRL... and so on. For example, here is a situation that takes 6 steps to reach ZZZ:

LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)

Starting at AAA, follow the left/right instructions. How many steps are required to reach ZZZ?
"""

import re
from dataclasses import dataclass


@dataclass
class Node:
    id: str
    left: 'Node'
    right: 'Node'

    def __repr__(self):
        return f"Node(id={self.id}, left={self.left.id}, right={self.right.id})"

    def is_origin(self):
        return self.id == 'AAA'

    def is_destination(self):
        return self.id == 'ZZZ'


class InputParser:
    STARTING_NODE = 'AAA'
    NODE_REGEX = re.compile("([A-Z]{3})\s*=\s*\(([A-Z]{3}),\s*([A-Z]{3})\)")
    NODE_MAP = {}

    @classmethod
    def parse(cls, filename):
        cls.NODE_MAP.clear()

        with open(filename) as f:
            instructions = f.readline().strip()
            f.readline() # Blank line

            while True:
                line = f.readline().strip()
                if not line:
                    break

                cls._parse_node(line)

        return (instructions, cls.NODE_MAP[cls.STARTING_NODE])
    
    @classmethod
    def _parse_node(cls, line):
        id_self, id_left, id_right = re.match(cls.NODE_REGEX, line).group(1, 2, 3)

        node_self = cls._get_node(id_self)
        node_left = cls._get_node(id_left)
        node_right = cls._get_node(id_right)

        node_self.left = node_left
        node_self.right = node_right

        return node_self

    @classmethod
    def _get_node(cls, id):
        if id in cls.NODE_MAP:
            return cls.NODE_MAP[id]

        node = Node(id, None, None)
        cls.NODE_MAP[id] = node

        return node
    
class Day8:
    def part1(self, test=False):
        filename = 'inputs/test/day8-short.txt' if test else 'inputs/day8.txt'
        instructions, starting_node = InputParser.parse(filename)
        current_node = starting_node

        step = 0
        while True:
            current_instruction = instructions[step % len(instructions)]

            if current_node.is_destination():
                break

            if current_instruction == 'L':
                current_node = current_node.left
            else:
                current_node = current_node.right
            
            step += 1

        print(f"RESULT: {step}")
