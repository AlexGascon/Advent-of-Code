defmodule AdventOfCode2019.Utils do
  def read_lines!(file_path) do
    file_path
    |> File.stream!
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def read_int_lines!(file_path) do
    file_path
    |> read_lines!
    |> Stream.map(&String.to_integer(&1))
  end

  def read_char_lists!(file_path) do
  file_path
    |> read_lines!
    |> Stream.map(&String.to_charlist(&1))
  end

  def read_list(file_path) do
    file_path
    |> File.read!
    |> String.split(",")
  end

  def read_int_list(file_path) do
    file_path
    |> read_list
    |> Enum.map(&String.to_integer/1)
  end
end
