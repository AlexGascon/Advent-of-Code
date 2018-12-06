defmodule AdventOfCode2018.Day05.Part1 do
  alias AdventOfCode2018.Utils
  alias AdventOfCode2018.Day05.Polymer

  def alchemical_reduction(file_path \\ "inputs/input.txt") do
    file_path
    |> Utils.read_char_lists!
    |> Enum.at(0)
    |> Polymer.reduce
  end
end

ExUnit.start
AdventOfCode2018.Day05.Part1.alchemical_reduction |> Enum.count |> IO.inspect(label: "RESULT")

defmodule AdventOfCode2018.Day05.Test1 do
  use ExUnit.Case
  import AdventOfCode2018.Day05.Part1

  test "only one reduction" do
    assert alchemical_reduction("inputs/test_input_2.txt") == 'ac'
  end

  test "chaining a reduction" do
    assert alchemical_reduction("inputs/test_input_3.txt") == ''
  end

  test "chaining lots of reductions" do
    assert alchemical_reduction("inputs/test_input.txt") == 'dabCBAcaDA'
  end
end