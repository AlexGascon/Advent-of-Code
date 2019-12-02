defmodule AdventOfCode2019.Day01.Part2Test do
  use ExUnit.Case

  import AdventOfCode2019.Day01.Part2

  describe "fuel_needed/1" do
    test "the amount of fuel necessary is computed considering the weight of the fuel" do
      assert fuel_needed(12) == 2
      assert fuel_needed(1969) == 966
    end
  end
end
