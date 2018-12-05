defmodule AdventOfCode2018.Day05.Part1 do
  alias AdventOfCode2018.Utils

  def alchemical_reduction(file_path \\ "inputs/input.txt") do
    file_path
    |> Utils.read_char_lists!
    |> Enum.at(0)
    |> reduce_polymer
  end

  def reduce_polymer(polymer) do
    reduction(polymer, [])
    |> Enum.reverse
  end

  def reduction([], result), do: result
  def reduction([start | []], result), do: [start] ++ result
  def reduction([start | [second | rest]], result) when second + 32 == start or start + 32 == second do
    reduce_result(rest, result)
  end
  def reduction([start | rest], result), do: reduction(rest, [start] ++ result)


  def reduce_result([next | t], [last | t2]) when last + 32 == next or next + 32 == last do
    reduce_result(t, t2)
  end
  def reduce_result(rest, result), do: reduction(rest, result)
end

ExUnit.start
AdventOfCode2018.Day05.Part1.alchemical_reduction |> Enum.count |> IO.inspect

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