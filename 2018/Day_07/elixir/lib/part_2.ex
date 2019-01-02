defmodule AdventOfCode2018.Day07.Part2 do
  alias AdventOfCode2018.Day07.Instructions
  alias AdventOfCode2018.Day07.Worker
  alias AdventOfCode2018.Day07.Assembly

  def building_time(file_path) do
    file_path
    |> AdventOfCode2018.Utils.read_lines!
    |> Instructions.get_from_requirements
    |> create_assembly(5)
    |> build
  end

  def create_assembly(instructions, num_workers) do
    workers = create_workers(num_workers)

    %Assembly{instructions: instructions, workers: workers, current_time: 0}
  end
  
  def create_workers(num_workers) do
    for worker_id <- 1..num_workers, do: %Worker{id: worker_id}
  end

  def build(assembly) do
    assembly = Assembly.update(assembly)

    case Assembly.build(assembly) do
      {:error, _} -> assembly |> Assembly.advance_step |> build
      {:ok, new_assembly} -> new_assembly |> build
      {:finished, total_time} -> {assembly, total_time}
    end
  end
end