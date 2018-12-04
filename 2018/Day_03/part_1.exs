defmodule AdventOfCode2018.Day03.Part1 do
  alias AdventOfCode2018.Day03.Claims
  alias AdventOfCode2018.Day03.Fabric

  def overlapped_tiles(file_path) do
    file_path
    |> Claims.extract
    |> fabric_occupation
    |> Map.values
    |> Enum.count(fn occupation -> occupation > 1 end)
  end

  def fabric_occupation(claims) do
    claims
    |> Enum.reduce(%{}, fn claim, fabric -> Fabric.mark_occuped_space(claim, fabric) end)
  end
end

ExUnit.start

defmodule AdventOfCode2018.Day03.Test1 do
  use ExUnit.Case

  import AdventOfCode2018.Day03.Part1

  test "result", do: assert overlapped_tiles("inputs/input.txt") == 117505
end
