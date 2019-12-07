defmodule AdventOfCode2019.Day03.Part1 do

  import AdventOfCode2019.Utils
  alias AdventOfCode2019.Day03.Point

  @origin %Point{row: 0, col: 0}

  def solution(filename) do
    filename
    |> parse_wires
    |> find_intersections
    |> remove_origin
    |> find_closest_point
    |> distance_to_center
  end

  def parse_wires(filename) do
    filename
    |> read_lines!
    |> Enum.map(&parse_wire/1)
  end

  def find_intersections([points_in_first_wire, points_in_second_wire]) do
    MapSet.intersection(points_in_first_wire, points_in_second_wire)
  end

  def remove_origin(intersections) do
    intersections |> MapSet.delete(@origin)
  end

  def find_closest_point(points) do
    points |> Enum.min_by(&distance_to_center/1)
  end

  defp parse_wire(wire) do
    wire
    |> String.split(",", trim: true)
    |> store_points
  end

  def store_points(wire) do
    store_points(%MapSet{}, %Point{row: 0, col: 0}, wire)
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
    |> MapSet.put(point)
    |> put_points(remaining)
  end

  def distance_to_center(point = %Point{}) do
    Point.distance(@origin, point)
  end
end
