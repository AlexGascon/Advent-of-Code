defmodule AdventOfCode2019.Day03.Part2 do

  import AdventOfCode2019.Utils
  alias AdventOfCode2019.Day03.Point

  @origin %Point{row: 0, col: 0}

  def solution(filename) do
    wires = filename |> parse_wires

    intersections = wires |> find_intersections

    intersections
    |> remove_origin
    |> Enum.min_by(&steps_required(&1, wires))
    |> steps_required(wires)
  end

  def parse_wires(filename) do
    filename
    |> read_lines!
    |> Enum.map(&parse_wire/1)
  end

  def find_intersections(wires) do
    [points_in_first_wire, points_in_second_wire] =
      wires
      |> Enum.map(&extract_points/1)

    MapSet.intersection(points_in_first_wire, points_in_second_wire)
  end

  def remove_origin(points), do: points |> MapSet.delete(@origin)

  def steps_required(point = %Point{}, wires) do
    wires
    |> Enum.map(&steps_required_per_wire(&1, point))
    |> Enum.sum
  end

  def extract_points(wire) do
    for point <- Map.keys(wire), into: %MapSet{}, do: point
  end

  defp parse_wire(wire) do
    wire
    |> String.split(",", trim: true)
    |> store_points
  end

  def store_points(wire) do
    store_points(%{}, %Point{row: 0, col: 0}, wire)
  end

  def store_points(points, current_point, [movement | wire]) do
    next_point =
      movement
      |> split_direction_and_distance
      |> compute_next_point(current_point)

    path = get_points_in_path(current_point, next_point)

    points = points |> put_points(path)

    store_points(points, next_point, wire)
  end

  def store_points(points, _, []) do
    points
  end

  def split_direction_and_distance(movement) do
    directions_regex = ~r{[RUDL]}

    movement
    |> String.split(directions_regex, include_captures: true, trim: true)
    |> convert_distance_to_integer
  end

  def convert_distance_to_integer([direction, distance]) do
    [direction, String.to_integer(distance)]
  end

  def compute_next_point(["U", distance], p = %Point{}), do: %Point{row: p.row + distance, col: p.col}
  def compute_next_point(["D", distance], p = %Point{}), do: %Point{row: p.row - distance, col: p.col}
  def compute_next_point(["L", distance], p = %Point{}), do: %Point{row: p.row, col: p.col - distance}
  def compute_next_point(["R", distance], p = %Point{}), do: %Point{row: p.row, col: p.col + distance}

  def get_points_in_path(%Point{row: row, col: current_col}, %Point{row: row, col: next_col}) do
    for col <- current_col..next_col, do: %Point{row: row, col: col}
  end

  def get_points_in_path(%Point{row: current_row, col: col}, %Point{row: next_row, col: col}) do
    for row <- current_row..next_row, do: %Point{row: row, col: col}
  end

  def put_points(points, []), do: points
  def put_points(points, [point = %Point{} | remaining]) do
    points
    |> Map.put(point, map_size(points))
    |> put_points(remaining)
  end

  def steps_required_per_wire(wire, point) do
    # The +1 is because the origin is the step 1, not the step 0
    Map.get(wire, point) + 1
  end
end
