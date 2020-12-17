defmodule AdventOfCode2019.Day03.PointTest do
  use ExUnit.Case

  alias AdventOfCode2019.Day03.Point


  describe "distance/2" do
    test "computes the difference in coordinates between two points" do
      p1 = %Point{row: 3, col: 2}
      p2 = %Point{row: 1, col: 5}
      p3 = %Point{row: 5, col: 1}

      assert 5 == Point.distance(p1, p2)
      assert 8 == Point.distance(p2, p3)
    end
  end
end
