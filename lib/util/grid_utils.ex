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

  def get_bounds(grid) when is_map(grid) do
    max_row = grid |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_col = grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()
    {max_row + 1, max_col + 1}
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

  def cell_value({row, col}, grid) when is_map(grid) do
    Map.get(grid, {row, col})
  end

  def list_to_position_map(grid) when is_list(grid) do
    for {row, i} <- Enum.with_index(grid),
        {value, j} <- Enum.with_index(row),
        into: %{} do
      {{i, j}, value}
    end
  end

  def position_map_to_list(grid, {row_bound, col_bound}) when is_map(grid) do
    for row <- 0..(row_bound - 1) do
      for col <- 0..(col_bound - 1) do
        Map.get(grid, {row, col}, ".")
      end
    end
  end

  def print_position_map(grid, default \\ " ") when is_map(grid) do
    {max_row, max_col} = get_bounds(grid)

    for row <- 0..max_row do
      for col <- 0..max_col do
        Map.get(grid, {row, col}, default)
      end
      |> Enum.join("")
      |> IO.puts()
    end

    grid
  end

  def opposite(:right), do: :left
  def opposite(:left), do: :right
  def opposite(:up), do: :down
  def opposite(:down), do: :up

  def move({row, col}, :right), do: {row, col + 1}
  def move({row, col}, :down), do: {row + 1, col}
  def move({row, col}, :left), do: {row, col - 1}
  def move({row, col}, :up), do: {row - 1, col}
  def move({row, col}, :up_right), do: {row - 1, col + 1}
  def move({row, col}, :down_right), do: {row + 1, col + 1}
  def move({row, col}, :down_left), do: {row + 1, col - 1}
  def move({row, col}, :up_left), do: {row - 1, col - 1}
end
