defmodule AdventOfCode2018.Day01.Part1 do
  alias AdventOfCode2018.Utils

  def chronal_calibration(file_path) do
    file_path
    |> Utils.read_int_lines!
    |> Enum.sum
  end
end