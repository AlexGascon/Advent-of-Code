defmodule AdventOfCode2019.Day02.Part1Test do
  use ExUnit.Case

  import AdventOfCode2019.Day02.Part1

  test "execute_instructions/1" do
    assert execute_instructions([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
    assert execute_instructions([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
    assert execute_instructions([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
    assert execute_instructions([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
    assert execute_instructions([1, 1, 1, 4, 99, 5, 6, 0, 2, 3, 4, 5, 99, 8, 11, 23]) == [30, 1, 1, 4, 2, 8, 6, 0, 2, 3, 4, 5, 99, 8, 11, 23]
  end
end
