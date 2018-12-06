defmodule AdventOfCode2018.Day05.Part2 do
  alias AdventOfCode2018.Utils
  alias AdventOfCode2018.Day05.Polymer

  def shortest_polymer(file_path \\ "inputs/input.txt") do
    polymer = file_path |> Utils.read_char_lists! |> Enum.at(0)
    units = ?a..?z |> Enum.to_list

    Stream.map(units, fn unit -> remove_unit(polymer, unit) end)
    |> Stream.map(&Polymer.reduce/1)
    |> Enum.min_by(fn polymer -> Enum.count(polymer) end)
    |> Enum.count
  end

  def remove_unit(polymer, type_to_remove) do
    polymer
    |> Enum.reduce([], fn unit, acc ->
      if unit_to_remove?(unit, type_to_remove) do
        acc
      else
        [unit | acc]
      end
    end)
    |> Enum.reverse
  end

  defp unit_to_remove?(unit, type_to_remove), do: (unit == type_to_remove) or (unit + 32 == type_to_remove)
end

ExUnit.start
AdventOfCode2018.Day05.Part2.shortest_polymer |> IO.inspect(label: "RESULT")


defmodule AdventOfCode2018.Day05.Test2 do
  use ExUnit.Case

  import AdventOfCode2018.Day05.Part2

  test "result" do
    assert shortest_polymer("inputs/test_input.txt") == 4
  end
end