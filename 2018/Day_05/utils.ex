defmodule AdventOfCode2018.Day05.Polymer do
  def reduce(polymer) do
    polymer
    |> reduction([])
    |> Enum.reverse
  end

  defmacro is_opposite_polarity?(unit1, unit2) do
    quote do: (unquote(unit1) + 32 == unquote(unit2)) or (unquote(unit2) + 32 == unquote(unit1))
  end

  def reduction([], accumulated_polymer) do
    accumulated_polymer
  end

  def reduction([unit | [next_unit | polymer]], accumulated_polymer) when is_opposite_polarity?(unit, next_unit) do
    {polymer, accumulated_polymer} = reduce_accumulated_polymer(polymer, accumulated_polymer)
    
    reduction(polymer, accumulated_polymer)
  end

  def reduction([unit | polymer], accumulated_polymer) do 
    reduction(polymer, [unit] ++ accumulated_polymer)
  end

  def reduce_accumulated_polymer([next | upcoming], [last | accumulated]) when is_opposite_polarity?(next, last) do
    reduce_accumulated_polymer(upcoming, accumulated)
  end

  def reduce_accumulated_polymer(polymer, accumulated_polymer) do
    {polymer, accumulated_polymer}
  end
end