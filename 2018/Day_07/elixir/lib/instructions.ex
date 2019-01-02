defmodule AdventOfCode2018.Day07.Instructions do
  alias Graph
  alias AdventOfCode2018.Day07.Instructions

  defstruct requirements: Graph.new, completed_steps: [], steps_in_progress: []
  
  @doc """
  Defines a requirement graph given a list of requirements of the form "Step X must be finished before step Y can begin."

  """
  def get_from_requirements(requirements_list) do
    requirements_list
    |> Enum.reduce(struct(Instructions), fn requirement, instructions ->
        add_requirement(instructions, requirement)
      end)
  end

  def add_requirement(instructions, requirement_string) do
    {step_required, step} = parse_requirement(requirement_string)

    %Instructions{instructions | requirements: Graph.add_edge(instructions.requirements, step_required, step)}
  end

  def work_finished?(instructions) do
    Enum.count(instructions.completed_steps) == Enum.count(instructions.requirements.vertices)
  end

  def get_next_step(instructions) do
    instructions
    |> get_available_steps
    |> Enum.min(fn -> nil end)
  end

  def get_available_steps(instructions) do
    Graph.vertices(instructions.requirements)
    |> Enum.filter(&available_step?(instructions, &1))
  end

  def work_on_step(instructions, step) do
    %Instructions{instructions | 
      steps_in_progress: [step | instructions.steps_in_progress]
    }
  end

  def mark_step_as_completed(instructions, step) do
    %Instructions{instructions | 
      completed_steps: [step | instructions.completed_steps],
      steps_in_progress: instructions.steps_in_progress -- [step]
    }
  end

  defp available_step?(instructions, step) do
    !completed_step?(instructions, step) &&
    !step_in_progress?(instructions, step) &&
      Enum.all?(instructions |> get_steps_required_before(step), &completed_step?(instructions, &1))
  end

  defp completed_step?(instructions, step) do
    instructions.completed_steps
    |> Enum.member?(step)
  end

  defp step_in_progress?(instructions, step) do
    instructions.steps_in_progress |> Enum.member?(step)
  end

  defp get_steps_required_before(instructions, step) do
    instructions.requirements
    |> Graph.in_neighbors(step)
  end


  @doc """
  Given a requirement of the form "Step X must be finished before step Y can begin", 
  returns the steps in tuple form

  ## Examples

      iex> AdventOfCode2018.Day07.Instructions.parse_requirement "Step X must be finished before step Y can begin"
      {"X", "Y"}

  """
  def parse_requirement(requirement_string) do
    [a, b] = String.split(requirement_string, " must be finished before step ")
    [_, first_step] = String.split(a, "Step ")
    [second_step, _] = String.split(b, " ", parts: 2)

    {first_step, second_step}
  end
end
