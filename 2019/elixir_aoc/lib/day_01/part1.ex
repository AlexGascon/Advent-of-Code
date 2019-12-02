defmodule AdventOfCode2019.Day01.Part1 do
  def fuel_needed(module_mass) do
    trunc(module_mass / 3) - 2
  end

  def total_fuel_needed(module_masses) do
    module_masses
    |> Enum.map(&fuel_needed/1)
    |> Enum.sum
  end
end
