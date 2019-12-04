defmodule AdventOfCode2019.Day02.Part2 do
  @desired_solution 19690720

  import AdventOfCode2019.Utils
  alias AdventOfCode2019.Day02.Part1

  def solution(filename) do
    filename
    |> Part1.get_instructions
    |> find_correct_alarm
    |> format_alarm
  end


  @doc """
  The goal of this method is to brute-force the solution. As a condition
  is that both noun and verb have to be in the [0, 99] range, even trying all
  the possible combinations results in 10k tries, which is quite a lot, but
  should be assumible
  """
  def find_correct_alarm(instructions) do
    Enum.find(
      Stream.flat_map(0..99, fn noun ->
        Stream.map(0..99, fn verb ->
          alarm = {noun, verb}
          {alarm, get_solution_for_alarm(instructions, alarm)}
        end)
      end),
      fn {alarm, result} -> result == @desired_solution
    end)
  end

  defp format_alarm({_alarm = {noun, verb}, @desired_solution}) do
    100 * noun + verb
  end

  defp get_solution_for_alarm(instructions, {noun, verb}) do
    instructions
    |> set_alarm_state_to({noun, verb})
    |> Part1.execute_instructions
    |> Enum.at(0)
  end

  defp set_alarm_state_to(instructions, {noun, verb}) do
    instructions
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end
end
