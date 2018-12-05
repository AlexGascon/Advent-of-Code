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

  defmacro is_opposite_polarity?(unit1, unit2) do
    quote do: (unquote(unit1) + 32 == unquote(unit2)) or (unquote(unit2) + 32 == unquote(unit1))
  end

  def reduction([], accumulated_polymer), do: accumulated_polymer
  def reduction([unit | []], accumulated_polymer), do: [unit] ++ accumulated_polymer
  def reduction([unit | [next_unit | polymer]], accumulated_polymer) when is_opposite_polarity?(unit, next_unit) do
    reduce_accumulated_polymer(polymer, accumulated_polymer)
  end
  def reduction([unit | polymer], accumulated_polymer), do: reduction(polymer, [unit] ++ accumulated_polymer)


  def reduce_accumulated_polymer([next | t], [last | t2]) when is_opposite_polarity?(next, last) do
    reduce_accumulated_polymer(t, t2)
  end
  def reduce_accumulated_polymer(polymer, accumulated_polymer), do: reduction(polymer, accumulated_polymer)
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