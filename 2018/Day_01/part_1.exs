defmodule AdventOfCode2018.Day01.Part1 do
  alias AdventOfCode2018.Utils

  def chronal_calibration(file_path) do
    file_path
    |> Utils.read_int_lines!
    |> Enum.sum
  end
end

ExUnit.start

defmodule AdventOfCode2018.Day01.Test1 do
  use ExUnit.Case

  import AdventOfCode2018.Day01.Part1

  assert chronal_calibration('inputs/test_input_1.txt') == 3
  assert chronal_calibration('inputs/test_input_2.txt') == 0
  assert chronal_calibration('inputs/test_input_3.txt') == -6
end