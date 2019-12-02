ExUnit.start()

defmodule AdventOfCode2019.TestHelper do
  def assert_results(function, tests_results) do
    Enum.each tests_results, fn {file, expected_result} ->
      result =
        file
        |> Atom.to_string
        |> function.()

      ^result = expected_result
    end
  end
end
