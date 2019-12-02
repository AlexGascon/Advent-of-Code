defmodule AdventOfCode2019.Day01.Part1Test do
  use ExUnit.Case

  import AdventOfCode2019.Day01.Part1

  describe "fuel_needed/1" do
    test "the amount of fuel necessary is computed correctly" do
      assert fuel_needed(12) == 2
      assert fuel_needed(14) == 2
      assert fuel_needed(1969) == 654
      assert fuel_needed(100756) == 33583
    end
  end

  describe "total_fuel_needed/1" do
    test "the total amount of fuel is the sum of the amount of each module" do
      assert total_fuel_needed([12, 14]) == 4
      assert total_fuel_needed([12, 14, 1969]) == 658
    end
  end
end
