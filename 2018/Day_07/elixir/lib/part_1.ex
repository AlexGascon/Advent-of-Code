defmodule AdventOfCode2018.Day07.Part1 do
  alias AdventOfCode2018.Day07.Instructions

  def build_sleigh(file_path) do
    file_path
    |> AdventOfCode2018.Utils.read_lines!
    |> Instructions.get_from_requirements
    |> follow_instructions
    |> get_steps_order
  end

  def follow_instructions(instructions) do
    next_step = Instructions.get_next_step(instructions)

    case build_step(instructions, next_step) do
      {:ok, instructions} -> follow_instructions(instructions)
      :finished -> instructions
    end
  end

  def build_step(_, step) when is_nil(step), do: :finished

  def build_step(instructions, step) do
    instructions = Instructions.mark_step_as_completed(instructions, step)

    {:ok, instructions}
  end

  def get_steps_order(instructions) do
    instructions.completed_steps
    |> Enum.reverse
    |> Enum.join
  end
end
