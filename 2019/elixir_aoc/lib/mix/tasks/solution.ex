defmodule Mix.Tasks.Solution do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    case run_tests do
      :ok ->
        day = args |> Enum.at(0) |> String.to_integer
        {:ok, obtain_solution(day)}
      error ->
        {:error, error}
    end
    |> IO.inspect(label: "RESULT")
  end

  defp obtain_solution(day) do
    day
    |> get_module
    |> apply(:solution, [filename(day)])
  end

  def get_module(day) do
    day
    |> module_name
    |> String.to_atom
  end

  defp module_name(day) when day < 10, do: "Elixir.AdventOfCode2019.Day0#{day}.Part1"
  defp module_name(day), do: "Elixir.AdventOfCode2019.Day#{day}.Part1"

  defp filename(day) when day < 10, do: "lib/day_0#{day}/inputs/input.txt"
  defp filename(day), do: "lib/day_#{day}/inputs/input.txt"

  defp run_tests, do: Mix.Task.run("test", ["--trace"])
end
