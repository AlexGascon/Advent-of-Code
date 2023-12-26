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

--- Part Two ---
The sandstorm is upon you and you aren't any closer to escaping the wasteland. You had the camel follow the instructions, but you've barely left your starting position. It's going to take significantly more steps to escape!

What if the map isn't for people - what if the map is for ghosts? Are ghosts even bound by the laws of spacetime? Only one way to find out.

After examining the maps a bit longer, your attention is drawn to a curious fact: the number of nodes with names ending in A is equal to the number ending in Z! If you were a ghost, you'd probably just start at every node that ends with A and follow all of the paths at the same time until they all simultaneously end up at nodes that end with Z.

For example:

LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)

Here, there are two starting nodes, 11A and 22A (because they both end with A). As you follow each left/right instruction, use that instruction to simultaneously navigate away from both nodes you're currently on. Repeat this process until all of the nodes you're currently on end with Z. (If only some of the nodes you're on end with Z, they act like any other node and you continue as normal.) In this example, you would proceed as follows:

Step 0: You are at 11A and 22A.
Step 1: You choose all of the left paths, leading you to 11B and 22B.
Step 2: You choose all of the right paths, leading you to 11Z and 22C.
Step 3: You choose all of the left paths, leading you to 11B and 22Z.
Step 4: You choose all of the right paths, leading you to 11Z and 22B.
Step 5: You choose all of the left paths, leading you to 11B and 22C.
Step 6: You choose all of the right paths, leading you to 11Z and 22Z.
So, in this example, you end up entirely on nodes that end in Z after 6 steps.

Simultaneously start on every node that ends with A. How many steps does it take before you're only on nodes that end with Z?
"""

import math
import re
from dataclasses import dataclass
from typing import Dict


@dataclass
class Node:
    id: str
    left: 'Node'
    right: 'Node'

    def __repr__(self):
        return f"Node(id={self.id}, left={self.left.id}, right={self.right.id})"

class InputParser:
    STARTING_NODE = 'AAA'
    NODE_REGEX = re.compile("([A-Z]{3})\s*=\s*\(([A-Z]{3}),\s*([A-Z]{3})\)")
    NODE_MAP = {}

    @classmethod
    def parse(cls, filename, part1=True):
        cls.NODE_MAP.clear()

        with open(filename) as f:
            instructions = f.readline().strip()
            f.readline() # Blank line

            while True:
                line = f.readline().strip()
                if not line:
                    break

                cls._parse_node(line)

        if part1:
            return (instructions, cls.NODE_MAP[cls.STARTING_NODE])
        else:
            return (instructions, cls.NODE_MAP)
    
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

        result = self._find_distance(starting_node, lambda node: node.id == 'ZZZ', instructions)

        print(f"RESULT: {result}")


    # NOTE: This solution assumes that each starting node is connected only to one
    # possible ending node. If this does not hold true, the solution might not be
    # correct
    def part2(self, test=False):
        filename = 'inputs/test/day8-part2.txt' if test else 'inputs/day8.txt'
        instructions, node_map = InputParser.parse(filename, part1=False)

        starting_nodes = [node for node_id, node in node_map.items() if node_id.endswith('A')]

        steps = [
            self._find_distance(starting_node, lambda node: node.id.endswith('Z'), instructions)
            for starting_node in starting_nodes
        ]

        print("RESULT:")
        print(f"DISTANCES: {steps}")
        print(f"SOLUTION: {math.lcm(*steps)}")


    def _find_distance(self, start_node, is_end_function, instructions):
        step = 0
        current_node = start_node
        while True:
            current_instruction = instructions[step % len(instructions)]

            if is_end_function(current_node):
                break

            if current_instruction == 'L':
                current_node = current_node.left
            else:
                current_node = current_node.right
            
            step += 1
        
        return step

        


