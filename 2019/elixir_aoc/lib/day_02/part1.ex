defmodule AdventOfCode2019.Day02.Part1 do
  @addition_opcode 1
  @multiplication_opcode 2
  @stop_opcode 99
  @arithmetic_opcodes [@addition_opcode, @multiplication_opcode]

  @start_position 0

  @integers_per_block 4

  import AdventOfCode2019.Utils

  def solution(filename) do
    filename
    |> get_instructions
    |> set_to_1202_alarm_state
    |> execute_instructions
    |> Enum.at(0)
  end

  def get_instructions(filename) do
    filename
    |> read_int_list
  end

  def set_to_1202_alarm_state(instructions) do
    instructions
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
  end

  def execute_instructions(instructions) do
    instructions
    |> Enum.slice(@start_position, @integers_per_block)
    |> execute_instructions(@start_position, instructions)
  end

  defp execute_instructions([@stop_opcode | _], _, instructions), do: instructions

  defp execute_instructions([opcode, first_position, second_position, result_position], current_position, instructions) when opcode in @arithmetic_opcodes do
    first = instructions |> Enum.at(first_position)
    second = instructions |> Enum.at(second_position)
    result = apply(operation_for(opcode), [first, second])

    instructions =
      instructions
      |> List.replace_at(result_position, result)

    next_program =
      instructions
      |> Enum.slice(current_position + @integers_per_block, @integers_per_block)

    execute_instructions(next_program, current_position + @integers_per_block, instructions)
  end

  defp operation_for(@addition_opcode), do: fn a, b -> a + b end
  defp operation_for(@multiplication_opcode), do: fn a, b -> a * b end
end
