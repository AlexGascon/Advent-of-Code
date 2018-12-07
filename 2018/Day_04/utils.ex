defmodule AdventOfCode2018.Day04.Events do
  def parse(event) do
    last_word = event |> String.split |> Enum.at(-1)

    case last_word do
      "shift"   -> %{type: :start, instant: parse_date(event), guard: parse_guard(event)}
      "asleep"  -> %{type: :asleep, instant: parse_date(event)}
      "up"      -> %{type: :awake, instant: parse_date(event)}
    end
  end

  defp parse_guard(event) do
    event
    |> String.split(["#", " begins"])
    |> Enum.at(1)
    |> String.to_integer
  end

  defp parse_date(event) do
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

  def register_event(event = %{type: :start}, {registry, _, _}) do
    {registry, event[:guard], nil}
  end

  def register_event(event = %{type: :asleep}, {registry, guard_id, _}) do
    {registry, guard_id, event[:instant]}
  end

  def register_event(event = %{type: :awake}, {registry, guard_id, asleep_instant}) do
    starting_minute = asleep_instant.minute
    ending_minute = event[:instant].minute - 1

    minutes_sleeping = Range.new(starting_minute, ending_minute) |> Enum.to_list

    registry = Map.update(
      registry,
      guard_id,
      minutes_sleeping,
      fn minutes -> minutes ++ minutes_sleeping end
    )

    {registry, guard_id, nil}
  end
end
