defmodule AdventOfCode2018.Day04.Part1 do
  alias AdventOfCode2018.Utils
  alias AdventOfCode2018.Day04.Events

  def checksum(file_path) do
    events = 
      file_path
      |> Utils.read_lines!
      |> Enum.sort
      |> Enum.map(&Events.parse/1)
      |> Events.register_events

    {sleepiest_guard_id, minutes_asleep} = 
      events
      |> Map.to_list
      |> Enum.max_by(fn {_, minutes_sleeping} -> Enum.count minutes_sleeping end)

    most_frequent_minute = Enum.max_by(minutes_asleep, &frequency(&1, minutes_asleep))

    sleepiest_guard_id * most_frequent_minute
  end

  def frequency(element, list) do
    Enum.count(list, fn element_in_list -> element_in_list == element end) 
  end
end

ExUnit.start

defmodule AdventOfCode2018.Day04.Test1 do
  use ExUnit.Case

  import AdventOfCode2018.Day04.Part1

  test "result" do
    assert checksum("inputs/input.txt") == 140932
  end
end
