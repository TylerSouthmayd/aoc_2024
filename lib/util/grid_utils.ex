defmodule GridUtils do
  def get_neighbors({row, col}, directions \\ [:up, :down, :left, :right]) do
    Enum.map(directions, &GridUtils.move({row, col}, &1))
  end

  def get_all_neighbors(position) do
    GridUtils.get_neighbors(position, [
      :up,
      :down,
      :left,
      :right,
      :up_left,
      :up_right,
      :down_left,
      :down_right
    ])
  end

  def get_bounds(grid) when is_list(grid) do
    {length(grid), length(hd(grid))}
  end

  def in_bound?({row, col}, grid) when is_list(grid) do
    {row_bound, col_bound} = get_bounds(grid)

    row >= 0 and row < row_bound and
      col >= 0 and col < col_bound
  end

  def in_bound?({row, col}, {row_bound, col_bound}) do
    row >= 0 and row < row_bound and
      col >= 0 and col < col_bound
  end

  def cell_value({row, col}, grid) when is_list(grid) do
    Enum.at(Enum.at(grid, row), col)
  end

  def move({row, col}, :right), do: {row, col + 1}
  def move({row, col}, :down), do: {row + 1, col}
  def move({row, col}, :left), do: {row, col - 1}
  def move({row, col}, :up), do: {row - 1, col}
  def move({row, col}, :up_right), do: {row - 1, col + 1}
  def move({row, col}, :down_right), do: {row + 1, col + 1}
  def move({row, col}, :down_left), do: {row + 1, col - 1}
  def move({row, col}, :up_left), do: {row - 1, col - 1}
end
