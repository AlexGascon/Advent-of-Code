defmodule AdventOfCode2019.Day01.Part2 do
  # 8 es el resultado de despejar module_mass en la ecuacion,
  # intentar montarlo de una forma mas bonita y practica
  def fuel_needed(module_mass) when module_mass <= 8, do: 0
  def fuel_needed(module_mass) do
    fuel_needed_by_module = trunc(module_mass / 3) - 2
    fuel_needed_by_module + fuel_needed(fuel_needed_by_module)
  end

  def total_fuel_needed(module_masses) do
    module_masses
    |> Enum.map(&fuel_needed/1)
    |> Enum.sum
  end
end
