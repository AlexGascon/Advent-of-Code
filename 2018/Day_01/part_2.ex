defmodule AdventOfCode2018.Day01.Part2 do
  alias AdventOfCode2018.Utils

  def repeated_frequency(file_path) do
    file_path
    |> Utils.read_int_lines!
    |> Stream.cycle
    |> find_first_repeated
  end

  defp find_first_repeated(cycle) do
    Enum.reduce_while(
      cycle,
      {0, %{}},
      &check_if_repeated(&1, &2)
    )
  end

  defp check_if_repeated(value, {accumulated, seen_frequencies}) do
    case Map.has_key?(seen_frequencies, accumulated) do
      true ->
        {:halt, accumulated}
      false ->
        seen_frequencies = Map.put(seen_frequencies, accumulated, true)
        {:cont, {value + accumulated, seen_frequencies}}
    end
  end
end