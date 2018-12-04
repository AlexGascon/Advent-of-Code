defmodule AdventOfCode2018.Day03.Part2 do
  alias AdventOfCode2018.Day03.Claims
  alias AdventOfCode2018.Day03.Fabric

  def intact_claim(file_path) do
    claims = Claims.extract(file_path)
    fabric = Fabric.occupation(claims)

    claims
    |> Enum.find(nil, &is_intact?(&1, fabric))
    |> Access.get(:id)
  end

  defp is_intact?(claim, fabric) do
    claim
    |> Fabric.occuped_space
    |> Enum.all?(fn tile -> fabric[tile] == 1 end)
  end
end

ExUnit.start

defmodule AdventOfCode2018.Day03.Test2 do
  use ExUnit.Case

  import AdventOfCode2018.Day03.Part2
  
  test "result", do: assert intact_claim("inputs/input.txt") == 1254
end