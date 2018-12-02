defmodule AdventOfCode2018.Day02.Part1 do
  alias AdventOfCode2018.Utils

  def checksum(file_path) do
    file_path
    |> Utils.read_lines!
    |> Stream.map(&String.codepoints(&1))
    |> Enum.map(&count_letters(&1))
    |> count_pairs_and_trios
    |> compute_checksum
  end

  defp count_letters(letters, accumulator \\ %{})
  defp count_letters([], accumulator), do: accumulator
  defp count_letters([current | remaining], accumulator) do
    count = Map.get(accumulator, current, 0) + 1

    count_letters(remaining, Map.put(accumulator, current, count))
  end

  defp count_pairs_and_trios(frequencies, accumulator \\ {0, 0})
  defp count_pairs_and_trios([], accumulator), do: accumulator
  defp count_pairs_and_trios([current | remaining], {pairs_acc, trios_acc}) do
    current_pair = if pair?(current), do: 1, else: 0
    current_trio = if trio?(current), do: 1, else: 0

    count_pairs_and_trios(remaining, {pairs_acc + current_pair, trios_acc + current_trio}) 
  end

  defp pair?(collection), do: any_appears_exactly?(collection, 2)
  defp trio?(collection), do: any_appears_exactly?(collection, 3)
  defp any_appears_exactly?(collection, occurrences) do
    collection
    |> Map.values
    |> Enum.any?(fn val -> val == occurrences end)
  end

  defp compute_checksum(values) do
    values
    |> Tuple.to_list
    |> Enum.reduce(fn val, acc -> val*acc end)
  end
end

ExUnit.start

defmodule AdventOfCode2018.Day02.Test1 do
  use ExUnit.Case

  import AdventOfCode2018.Day02.Part1

  #assert count_letters(["a", "b", "b", "c"]) == %{"a" => 1, "b" => 2, "c" => 1}
  #assert count_pairs_and_trios([%{"a" => 1, "b" => 2, "c" => 1}]) == {1, 0}
  #assert count_pairs_and_trios([%{"a" => 2, "b" => 2, "c" => 1}]) == {1, 0}
  #assert count_pairs_and_trios([%{"a" => 1, "b" => 2, "c" => 3}]) == {1, 1}
  #assert count_pairs_and_trios([%{"a" => 1, "b" => 3, "c" => 3}, %{"a" => 1, "b" => 2, "c" => 3}]) == {1, 2}
  assert checksum("inputs/test_input.txt") == 12
end