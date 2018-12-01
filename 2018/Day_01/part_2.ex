defmodule AdventOfCode2018.Day01.Part2 do
  alias AdventOfCode2018.Utils

  def repeated_frequency(file_path) do
    file_path
    |> Utils.read_int_lines!
    |> Stream.cycle
    |> find_repeated
  end

  def find_repeated(cycle) do
    Enum.reduce_while(
      cycle,
      {0, %{}},
      fn elem, {acc, seen_frequencies} ->
        case Map.get(seen_frequencies, acc) do
          nil ->
            {:cont, {acc + elem, Map.put(seen_frequencies, acc, true)}}
          true ->
            {:halt, acc}
        end
      end
    )
  end
end