defmodule AdventOfCode2018.Day07.Worker do
  defstruct id: nil, current_piece: nil, end_time: -1

  def work_on_step(worker, step, current_time) do
    nw = %{worker | current_piece: step, end_time: current_time + get_time_required_for_step(step)}
    IO.inspect("Step: #{nw.current_piece} - Time: #{current_time}", label: "Step started")
    nw
  end

  def finish_work(worker) do
    %{worker | current_piece: nil, end_time: -1}
  end

  def busy?(worker, time) do
    worker.end_time >= time
  end

  def get_available(workers, time) do
    workers
    |> Enum.find(nil, fn worker -> !busy?(worker, time) end)
  end

  def next_available(workers) do
    workers
    |> Enum.min_by(fn worker -> worker.end_time end)
  end




  @doc """
  Obtains the time that is needed to finish the work on a specific step.

  Each step takes 60 seconds plus an amount corresponding to its letter: A=1,
  B=2, C=3, and so on. So, step A takes 60+1=61 seconds, while step Z takes
  60+26=86 seconds.

  We can obtain the time for each step by substracting 4 from its ASCII value.


  ## Examples

      iex> AdventOfCode2018.Day07.Worker.get_time_required_for_step "A"
      61

      iex> AdventOfCode2018.Day07.Worker.get_time_required_for_step "Z"
      86

  """
  def get_time_required_for_step(step) do
    [value] = step |> String.to_charlist
    value - 4
  end
end
