defmodule AdventOfCode2018.Day03.Part1 do
  alias AdventOfCode2018.Utils
  alias AdventOfCode2018.Day03.Parsing
  alias AdventOfCode2018.Day03.Fabric

  def overlapped_tiles(file_path) do
    file_path
    |> Utils.read_lines!
    |> Stream.map(&Parsing.parse_claim(&1))
    |> Enum.reduce(%{}, fn claim, fabric -> Fabric.mark_occuped_space(claim, fabric) end)
    |> Map.values
    |> Enum.count(fn occupation -> occupation > 1 end)
  end
end

defmodule AdventOfCode2018.Day03.Parsing do
  def parse_claim(claim) do
    [
      id:     claim |> parse_id,
      left:   claim |> parse_left,
      top:    claim |> parse_top,
      width:  claim |> parse_width,
      height: claim |> parse_height 
    ]
  end
  defp parse_id(claim),     do: claim |> String.split("#") |> Enum.at(1) |> String.split |> Enum.at(0) |> String.to_integer
  defp parse_left(claim),   do: claim |> String.split(",") |> Enum.at(0) |> String.split |> Enum.at(2) |> String.to_integer
  defp parse_top(claim),    do: claim |> String.split(",") |> Enum.at(1) |> String.split(":") |> Enum.at(0) |> String.to_integer
  defp parse_width(claim),  do: claim |> String.split("x") |> Enum.at(0) |> String.split |> Enum.at(3) |> String.to_integer
  defp parse_height(claim), do: claim |> String.split("x") |> Enum.at(1) |> String.to_integer
end

defmodule AdventOfCode2018.Day03.Fabric do
  @fabric_side 1000

  def mark_occuped_space(claim, fabric) do
    claim
    |> occuped_space
    |> Enum.reduce(fabric, fn tile, cloth -> Map.update(cloth, tile, 1, &(&1 + 1)) end)
  end

  defp occuped_space(claim), do: occupy_space([], claim)

  defp occupy_space(already_occuped, [id: _, left: _, top: _, width: _, height: 0]), do: already_occuped
  defp occupy_space(already_occuped, [id: id, left: left, top: top, width: width, height: height]) do
    first = tile_to_int(top, left)
    last = tile_to_int(top, left + width - 1)
    
    Range.new(first, last)
    |> Enum.concat(already_occuped)
    |> occupy_space([id: id, left: left, top: top + 1, width: width, height: height - 1])
  end

  defp tile_to_int(row, column), do: row * @fabric_side + column + 1
end