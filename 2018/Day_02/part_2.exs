defmodule AdventOfCode2018.Day02.Part2 do
  alias AdventOfCode2018.Utils
  alias AdventOfCode2018.Day02.CharListHelpers
  
  def find_boxes(file_path) do
    boxes = 
      file_path
      |> Utils.read_char_lists!
      |> Enum.to_list

    boxes
    |> Enum.find(&has_matching_box?(&1, boxes))
    |> matching_box(boxes)
    |> CharListHelpers.common_characters
  end

  defp has_matching_box?(_, []), do: false
  defp has_matching_box?(box, [current_box | remaining_boxes]) do
    case matching_boxes?(box, current_box) do
      true -> true
      _    -> has_matching_box?(box, remaining_boxes)
    end
  end

  defp matching_boxes?(box1, box2), do: CharListHelpers.distance(box1, box2) == 1

  defp matching_box(box, [current_box | remaining_boxes]) do
    case matching_boxes?(box, current_box) do
      true -> [box, current_box]
      _    -> matching_box(box, remaining_boxes)
    end
  end
end

defmodule AdventOfCode2018.Day02.CharListHelpers do
  def distance(charlist1, charlist2), do: hamming_distance(charlist1, charlist2, 0)
  defp hamming_distance([], [], count), do: count
  defp hamming_distance([char | charlist1], [char | charlist2], count), do: hamming_distance(charlist1, charlist2, count)
  defp hamming_distance([_ | charlist1], [_ | charlist2], count), do: hamming_distance(charlist1, charlist2, count+1)
  defp hamming_distance([], _, _), do: nil
  defp hamming_distance(_, [], _), do: nil

  def common_characters([charlist1, charlist2]), do: charlist1 -- differing_characters(charlist1, charlist2)
  def differing_characters(charlist1, charlist2), do: charlist1 -- charlist2
end

ExUnit.start

defmodule AdventOfCode2018.Day02.Test2 do
  use ExUnit.Case

  import AdventOfCode2018.Day02.Part2

  test "example" do
    assert find_boxes("inputs/test_input_2.txt") == 'fgij'
  end

  test "distance is 1 but order is different" do
    assert find_boxes("inputs/test_input_3.txt") == 'fgij'
  end
end