defmodule AdventOfCode2019.Day03.Point do
  defstruct row: 0, col: 0

  alias AdventOfCode2019.Day03.Point

  def distance(%Point{} = p1, %Point{} = p2) do
    abs(p1.row - p2.row) + abs(p1.col - p2.col)
  end

  defimpl Inspect, for: Point do
    def inspect(%Point{row: row, col: col}, _opts), do: "Point(#{row}, #{col})"
  end
end
