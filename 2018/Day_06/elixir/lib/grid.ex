defmodule AdventOfCode2018.Day06.Grid do
  def from_dimensions({max_column, max_row}) do
    for col <- 0..max_column, row <- 0..max_row, into: %{} do
      {{col, row}, 1}
    end
  end

  def fill_with_closest_coordinate(grid, coordinates) do
    for {point, _} <- grid, into: %{} do
      {point, get_closest_coordinate(point, coordinates)}
    end
  end

  def create_from_coordinates_and_dimensions(coordinates, dimensions) do
    from_dimensions(dimensions)
    |> fill_with_closest_coordinate(coordinates)
  end


  @doc """
  Given a list of coordinates, returns a tuple with the max row and the max column

  ## Examples

      iex> AdventOfCode2018.Day06.Grid.get_dimensions([
      ...>  {1, 1},
      ...>  {1, 6},
      ...>  {8, 3},
      ...>  {3, 4},
      ...>  {5, 5},
      ...>  {2, 9},
      ...> ])
      {8, 9}
  """
  def get_dimensions(coordinates) do
    {max_column, _} = Enum.max_by(coordinates, fn {column, _row} -> column end)
    {_, max_row} = Enum.max_by(coordinates, fn {_column, row} -> row end)

    {max_column, max_row}
  end

  @doc """
  Given a point and a list of coordinates, returns a tuple with the closest coordinate to the point.

  In case that there are several coordinates at the same distance, returns nil

  ## Examples

      iex> AdventOfCode2018.Day06.Grid.get_closest_coordinate({1, 1}, [{1, 6}, {8, 3}])
      {1, 6}

      iex> AdventOfCode2018.Day06.Grid.get_closest_coordinate({1, 1}, [{0, 0}, {2, 2}])
      nil
  """
  def get_closest_coordinate(point, coordinates) do
    coordinates
    |> min_by_without_draw(fn coordinate-> distance(point, coordinate) end)
  end

  def distance({column1, row1}, {column2, row2}), do: abs(column1 - column2) + abs(row1 - row2)

  defp min_by_without_draw(enum, fun) do
    {_, min_element, is_repeated?} =
      enum
      |> Enum.reduce({:infinity, nil, false}, fn element, {min, min_element, repeated?} ->
        result = fun.(element)
        cond do
          result < min   -> {result, element, false}
          result == min  -> {min, min_element, true}
          true           -> {min, min_element, repeated?}
        end
      end)

    if(is_repeated?, do: nil, else: min_element)
  end

  def get_borders({max_column, max_row}) do
    top_border = for col <- 0..max_column, do: {col, 0}
    bottom_border = for col <- 0..max_column, do: {col, max_row}
    left_border = for row <- 0..max_row, do: {0, row}
    right_border = for row <- 0..max_row, do: {max_column, row}

    top_border ++ bottom_border ++ left_border ++ right_border |> Enum.uniq
  end
end