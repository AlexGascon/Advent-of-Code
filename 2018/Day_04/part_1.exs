defmodule AdventOfCode2018.Day04.Part1 do
  alias AdventOfCode2018.Utils
  alias AdventOfCode2018.Day04.Guards

  def main(file_path) do
    events = 
      file_path
      |> Utils.read_lines!
      |> Enum.sort
      |> Enum.map(&Guards.parse_event/1)
      |> Guards.register_events

    {guard_id, {sleep_time, minutes_asleep}} = 
      events
      |> Map.to_list
      |> Enum.max_by(fn {guard_id, {sleep_time, _}} ->
        sleep_time
      end)

    most_frequent_minute = Enum.max_by(minutes_asleep, fn minute -> Enum.count(minutes_asleep, &(&1 == minute)) end)

    IO.puts(guard_id * most_frequent_minute)

    {guard_id_2, most_frequent_minute_2, _times} =
      events
      |> Map.to_list
      |> Enum.map(fn {guard_id, {_, minutes_asleep}} ->
        Enum.map(Enum.uniq(minutes_asleep), fn minute -> {guard_id, minute, Enum.count(minutes_asleep, &(&1 == minute))} end)
      end)
      |> Enum.map(fn guard_data -> Enum.max_by(guard_data, fn {_, _, times} -> times end) end)
      |> Enum.max_by(fn {_, _, times} -> times end)
    
    IO.puts(guard_id_2 * most_frequent_minute_2)
  end
end


defmodule AdventOfCode2018.Day04.Guards do
  def parse_event(event) do
    last_word = event |> String.split |> Enum.at(-1)

    case last_word do
      "shift"   -> %{type: :start, instant: parse_date(event), guard: parse_guard(event)}
      "asleep"  -> %{type: :asleep, instant: parse_date(event)}
      "up"      -> %{type: :awake, instant: parse_date(event)}
    end
  end

  def parse_guard(event) do
    event
    |> String.split(["#", " begins"])
    |> Enum.at(1)
    |> String.to_integer
  end

  def parse_date(event) do
    datetime_without_seconds = 
      event
      |> String.split(["[", "]"])
      |> Enum.at(1)
    
    NaiveDateTime.from_iso8601!(datetime_without_seconds <> ":00")
  end

  def register_events(events) do
    Enum.reduce(events, {%{}, nil, nil}, &register_event/2)
    |> elem(0)
  end

  def register_event(event = %{type: :start}, {registry, _, _}), do: {registry, event[:guard], nil}
  def register_event(event = %{type: :asleep}, {registry, guard_id, _}), do: {registry, guard_id, event[:instant]}
  def register_event(event = %{type: :awake}, {registry, guard_id, asleep_instant}) do
    starting_minute = asleep_instant.minute
    ending_minute = event[:instant].minute - 1
    sleep_length = ending_minute - starting_minute
    minutes_sleeping = Range.new(starting_minute, ending_minute) |> Enum.to_list

    registry = Map.update(
      registry,
      guard_id,
      {sleep_length, minutes_sleeping},
      fn {time_sleeping, minutes} -> {time_sleeping + sleep_length, minutes ++ minutes_sleeping} end
    )

    {registry, guard_id, nil}
  end
end


AdventOfCode2018.Day04.Part1.main 'inputs/input.txt'