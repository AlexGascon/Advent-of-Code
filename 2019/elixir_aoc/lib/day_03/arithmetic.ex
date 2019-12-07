defprotocol AdventOfCode2019.Day03.Arithmetic do
  @doc "Calculates the sum between two elements"
  def add(addend1, addend2)

  @doc "Calculates the difference between two elements"
  def substract(elem1, elem2)
end
