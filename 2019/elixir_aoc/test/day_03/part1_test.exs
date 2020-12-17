defmodule AdventOfCode2019.Day03.Part1Test do
  use ExUnit.Case

  import AdventOfCode2019.Day03.Part1

  describe "parse_wires/1" do
    test "correctly parses the lines in the file" do
      lines = parse_wires("lib/day_03/inputs/test_input_1.txt")

      #assert Enum.at(lines, 0) == ["R8", "U5", "L5", "D3"]
      #assert Enum.at(lines, 1) == ["U7", "R6", "D4", "L4"]
    end
  end

  test "find_closest_intersection finds the closest point where the two lines cross" do
  end
end
