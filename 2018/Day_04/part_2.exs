defmodule AdventOfCode2018.Day04.Part2 do
  alias AdventOfCode2018.Utils
  alias AdventOfCode2018.Day04.Events

  def checksum(file_path) do
    events = 
      file_path
      |> Utils.read_lines!
      |> Enum.sort
      |> Enum.map(&Events.parse/1)
      |> Events.register_events

    {guard_id, most_frequent_minute, _minute_frequency} =
      events
      |> Map.to_list
      |> Enum.map(&group_by_guard/1)
      |> Enum.map(&most_frequent_minute_by_guard/1)
      |> Enum.max_by(fn {_, _, minute_frequency} -> minute_frequency end)
    
    guard_id * most_frequent_minute
  end

  def group_by_guard({guard_id, minutes_sleeping}) do
    minutes_sleeping
    |> Enum.uniq
    |> Enum.map(fn minute -> {guard_id, minute, frequency(minute, minutes_sleeping)} end)
  end

  def most_frequent_minute_by_guard(guard_data) do
    guard_data
    |> Enum.max_by(fn {_, _, minute_frequency} -> minute_frequency end)
  end

  def frequency(element, list) do
    Enum.count(list, fn element_in_list -> element_in_list == element end) 
  end
end

ExUnit.start

defmodule AdventOfCode2018.Day04.Test2 do
  use ExUnit.Case

  import AdventOfCode2018.Day04.Part2

  test "result" do
    assert checksum("inputs/input.txt") == 51232
  end
end
