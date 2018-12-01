defmodule AdventOfCode2018.Day01.Test do
  alias AdventOfCode2018.TestUtils
  alias AdventOfCode2018.Day01.Part1
  alias AdventOfCode2018.Day01.Part2

  @test_results_1 ["test_input_1.txt": 3, "test_input_2.txt": 0, "test_input_3.txt": -6]

  TestUtils.assert_results(&Part1.chronal_calibration/1, @test_results_1)

  @test_results_2 ["test_input_4.txt": 5, "test_input_5.txt": 10]

  TestUtils.assert_results(&Part2.repeated_frequency/1, @test_results_2)
end