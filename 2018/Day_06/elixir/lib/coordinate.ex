defmodule AdventOfCode2018.Day06.Coordinate do
  @doc """
  Parses a coordinate in string form into a tuple in {row, column} form

  ## Examples

      iex> AdventOfCode2018.Day06.Coordinate.from_string "140, 168"
      {140, 168}

  """
  def from_string(coordinate_string) do
    coordinate_string
    |> String.split(", ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end
end