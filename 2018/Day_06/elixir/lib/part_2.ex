defmodule AdventOfCode2018.Day06.Part2 do
  alias AdventOfCode2018.Day06.Coordinate
  alias AdventOfCode2018.Day06.Grid
  
  def safe_region_size(coordinate_strings, safe_distance) do
    coordinates = Enum.map(coordinate_strings, &Coordinate.from_string/1)

    grid =
      coordinates
      |> Grid.get_dimensions
      |> Grid.from_dimensions

    for({point, _} <- grid, do: safe_location?(point, coordinates, safe_distance))
    |> Enum.filter(fn v -> v == true end)
    |> Enum.count
  end

  def safe_location?(point, coordinates, safe_distance) do
    accumulated_distance = 
      Enum.reduce(
        coordinates,
        0,
        fn coordinate, total_distance -> total_distance + Grid.distance(point, coordinate) end
      )
    
    accumulated_distance < safe_distance
  end
end

"../inputs/input.txt"
|> AdventOfCode2018.Utils.read_lines!
|> AdventOfCode2018.Day06.Part2.safe_region_size(10000)
|> IO.inspect(label: "Result")