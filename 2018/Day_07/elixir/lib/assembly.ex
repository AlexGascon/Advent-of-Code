defmodule AdventOfCode2018.Day07.Assembly do
  alias AdventOfCode2018.Day07.Instructions
  alias AdventOfCode2018.Day07.Worker

  defstruct instructions: nil, workers: [],  current_time: 0

  def build(assembly) do
    next_step = Instructions.get_next_step(assembly.instructions)
    worker = Worker.get_available(assembly.workers, assembly.current_time)

    cond do
      Instructions.work_finished?(assembly.instructions) ->
        {:finished, assembly.current_time}
      is_nil(next_step) -> 
        {:error, :no_steps}
      is_nil(worker) ->
        {:error, :no_workers}
      true ->
        {:ok, start_building_step(assembly, next_step, worker)}
    end
  end

  def update(assembly) do
    {workers, instructions, current_time} = {assembly.workers, assembly.instructions, assembly.current_time}

    {instructions, workers} = 
      Enum.reduce(workers, {instructions, workers}, fn worker, {acc_instruct, acc_workers} ->
        if !is_nil(worker.current_piece) && !Worker.busy?(worker, current_time) do
          updated_assembly = finish_work(assembly, worker)
          {updated_assembly.instructions, updated_assembly.workers}
        else
          {acc_instruct, acc_workers}
        end
      end)
    
    %{assembly | instructions: instructions, workers: workers}
  end

  def start_building_step(assembly, step, worker) do
    instructions =
      assembly.instructions
      |> Instructions.work_on_step(step)

    worker = Worker.work_on_step(worker, step, assembly.current_time)
    workers = update_workers(assembly.workers, worker)

    %{assembly | instructions: instructions, workers: workers, current_time: assembly.current_time}
  end

  def advance_step(assembly) do
    assembly
    |> finish_current_step
  end

  def finish_current_step(assembly) do
    current_worker =
      assembly
      |> get_busy_workers
      |> get_first_available_worker

    finish_work(assembly, current_worker)
  end

  def get_busy_workers(assembly) do
    assembly.workers |> Enum.filter(&Worker.busy?(&1, assembly.current_time))
  end

  def get_first_available_worker(workers) do
    workers |> Worker.next_available
  end

  def finish_work(assembly, worker) do
    IO.inspect("Step: #{worker.current_piece} - Time: #{worker.end_time}", label: "Step finished")

    instructions = Instructions.mark_step_as_completed(assembly.instructions, worker.current_piece)
    finished_worker = Worker.finish_work(worker)
    workers = update_workers(assembly.workers, finished_worker)
  
    %{assembly | instructions: instructions, workers: workers, current_time: worker.end_time}
  end

  def update_workers([], _worker), do: []

  def update_workers([workers_head | workers_tail], worker) do
    if workers_head.id == worker.id do
      [worker | workers_tail]
    else
      [workers_head | update_workers(workers_tail, worker)]
    end
  end
end