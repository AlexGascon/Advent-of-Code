defmodule Mix.Tasks.Solution do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    case run_tests do
      :ok ->
        day = args |> Enum.at(0) |> String.to_integer
        [part1_solution, part2_solution] = obtain_solution(day)
        {:ok, ["Part 1": part1_solution, "Part 2": part2_solution]}
      error ->
        {:error, error}
    end
    |> IO.inspect(label: "RESULT")
  end

  defp obtain_solution(day) do
    day
    |> get_modules
    |> Enum.map(&apply(&1, :solution, [filename(day)]))
  end

  def get_modules(day) do
    [get_module(day, 1), get_module(day, 2)]
  end

  def get_module(day, part) do
    day
    |> module_name(part)
    |> String.to_atom
  end

  defp module_name(day, part) when day < 10, do: "Elixir.AdventOfCode2019.Day0#{day}.Part#{part}"
  defp module_name(day, part), do: "Elixir.AdventOfCode2019.Day#{day}.Part#{part}"

  defp filename(day) when day < 10, do: "lib/day_0#{day}/inputs/input.txt"
  defp filename(day), do: "lib/day_#{day}/inputs/input.txt"

  defp run_tests, do: Mix.Task.run("test", ["--trace"])
end
