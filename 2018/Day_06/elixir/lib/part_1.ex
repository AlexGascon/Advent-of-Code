defmodule AdventOfCode2018.Day06.Part1 do
  alias AdventOfCode2018.Day06.Coordinate
  alias AdventOfCode2018.Day06.Grid

  @doc """
  Given a text block with a coordinate in each line, returns the size of the finite area with more points close to it
  """
  def chronal_coordinates(coordinate_strings) do
    coordinates = coordinate_strings |> Enum.map(&Coordinate.from_string/1)

    grid_dimensions = coordinates |> Grid.get_dimensions

    grid = coordinates |> Grid.create_from_coordinates_and_dimensions(grid_dimensions)

    infinite_coordinates = 
      Grid.get_borders(grid_dimensions)
      |> Enum.map(fn border_coordinate -> Map.get(grid, border_coordinate) end)
      |> Enum.uniq

    {most_frequent_coordinate, frequency} = 
      grid
      |> Map.values
      |> Enum.reject(fn v -> Enum.member?(infinite_coordinates, v) end)
      |> Enum.reduce(%{}, fn closest_coordinate, acc ->
        Map.update(acc, closest_coordinate, 1, & (&1 + 1))
      end)
      |> Enum.max_by(fn {_coordinate, frequency} -> frequency end)

    {most_frequent_coordinate, frequency}
  end
end


"../inputs/input.txt"
|> AdventOfCode2018.Utils.read_lines!()
|> AdventOfCode2018.Day06.Part1.chronal_coordinates()
|> IO.inspect(label: "Part 1 result")
