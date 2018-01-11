"""--- Part Two ---

Now, you need to pass through the firewall without being caught - easier said
than done.

You can't control the speed of the packet, but you can delay it any number of
picoseconds. For each picosecond you delay the packet before beginning your
trip, all security scanners move one step. You're not in the firewall during
this time; you don't enter layer 0 until you stop delaying the packet.

In the example above, if you delay 10 picoseconds (picoseconds 0 - 9), you
won't get caught:

State after delaying:
 0   1   2   3   4   5   6
[ ] [S] ... ... [ ] ... [ ]
[ ] [ ]         [ ]     [ ]
[S]             [S]     [S]
                [ ]     [ ]

Picosecond 10:
 0   1   2   3   4   5   6
( ) [S] ... ... [ ] ... [ ]
[ ] [ ]         [ ]     [ ]
[S]             [S]     [S]
                [ ]     [ ]

 0   1   2   3   4   5   6
( ) [ ] ... ... [ ] ... [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]


Picosecond 11:
 0   1   2   3   4   5   6
[ ] ( ) ... ... [ ] ... [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]

 0   1   2   3   4   5   6
[S] (S) ... ... [S] ... [S]
[ ] [ ]         [ ]     [ ]
[ ]             [ ]     [ ]
                [ ]     [ ]


Picosecond 12:
 0   1   2   3   4   5   6
[S] [S] (.) ... [S] ... [S]
[ ] [ ]         [ ]     [ ]
[ ]             [ ]     [ ]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] [ ] (.) ... [ ] ... [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]


Picosecond 13:
 0   1   2   3   4   5   6
[ ] [ ] ... (.) [ ] ... [ ]
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] [S] ... (.) [ ] ... [ ]
[ ] [ ]         [ ]     [ ]
[S]             [S]     [S]
                [ ]     [ ]


Picosecond 14:
 0   1   2   3   4   5   6
[ ] [S] ... ... ( ) ... [ ]
[ ] [ ]         [ ]     [ ]
[S]             [S]     [S]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] [ ] ... ... ( ) ... [ ]
[S] [S]         [ ]     [ ]
[ ]             [ ]     [ ]
                [S]     [S]


Picosecond 15:
 0   1   2   3   4   5   6
[ ] [ ] ... ... [ ] (.) [ ]
[S] [S]         [ ]     [ ]
[ ]             [ ]     [ ]
                [S]     [S]

 0   1   2   3   4   5   6
[S] [S] ... ... [ ] (.) [ ]
[ ] [ ]         [ ]     [ ]
[ ]             [S]     [S]
                [ ]     [ ]


Picosecond 16:
 0   1   2   3   4   5   6
[S] [S] ... ... [ ] ... ( )
[ ] [ ]         [ ]     [ ]
[ ]             [S]     [S]
                [ ]     [ ]

 0   1   2   3   4   5   6
[ ] [ ] ... ... [ ] ... ( )
[S] [S]         [S]     [S]
[ ]             [ ]     [ ]
                [ ]     [ ]

Because all smaller delays would get you caught, the fewest number of picoseconds
you would need to delay to get through safely is 10.

What is the fewest number of picoseconds that you need to delay the packet to
pass through the firewall without being caught?
"""

def test_delay_needed():
    example = """0: 3
    1: 2
    4: 4
    6: 4"""

    assert delay_needed(example) == 10


def parse_firewall_structure(firewall_structure):
    firewall_levels = firewall_structure.strip().splitlines()
    firewall = {}

    for level in firewall_levels:
        layer, length = [int(part) for part in level.split(': ')]
        firewall[layer] = length

    return firewall


def round_trip_time(layer_length):
    """Time that a scanner needs to go to bottom of a layer and return its top"""
    return (layer_length - 1) * 2


def delay_needed(firewall_structure):
    firewall = parse_firewall_structure(firewall_structure)

    delay = 0
    while True:
        caught = False

        for layer, length in firewall.items():
            if (layer + delay) % round_trip_time(length) == 0:
                delay += 1
                caught = True
                break

        if not caught:
            return delay


if __name__ == '__main__':
    with open('input.txt') as input_file:
        input_content = input_file.read()

    severity = delay_needed(input_content)
    print(f"PICOSECONDS OF DELAY: {severity}")
