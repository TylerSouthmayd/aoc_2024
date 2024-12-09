defmodule AOC.Day6 do
  def solve_part1(input \\ nil) do
    {grid, start} = parse(input)

    walk(grid, MapSet.new(), start, :up)
  end

  def solve_part2(input \\ nil) do
    {grid, start} = parse(input)

    for row <- 0..(length(grid) - 1),
        col <- 0..(length(hd(grid)) - 1),
        cell_value({row, col}, grid) == ".",
        reduce: 0 do
      acc -> acc + walk_cycle(grid, MapSet.new(), start, :up, {row, col})
    end
  end

  defp walk(grid, seen, curr_pos, direction) do
    seen = MapSet.put(seen, curr_pos)
    next_pos = move(curr_pos, direction)
    exiting = not in_bound?(next_pos, grid)
    valid_next = valid_cell?(next_pos, grid)

    cond do
      exiting -> MapSet.size(seen)
      valid_next -> walk(grid, seen, next_pos, direction)
      true -> walk(grid, seen, curr_pos, turn(direction))
    end
  end

  defp walk_cycle(grid, seen, curr_pos, direction, override_pos) do
    cycle = MapSet.member?(seen, {direction, curr_pos})
    seen = MapSet.put(seen, {direction, curr_pos})
    next_pos = move(curr_pos, direction)
    exiting = not in_bound?(next_pos, grid)
    valid_next = valid_cell?(next_pos, grid, override_pos)

    cond do
      cycle -> 1
      exiting -> 0
      valid_next -> walk_cycle(grid, seen, next_pos, direction, override_pos)
      true -> walk_cycle(grid, seen, curr_pos, turn(direction), override_pos)
    end
  end

  defp cell_value({row, col}, grid) do
    Enum.at(Enum.at(grid, row), col)
  end

  defp in_bound?({row, col}, grid) do
    row >= 0 and row < length(grid) and
      col >= 0 and col < length(hd(grid))
  end

  defp valid_cell?(pos, grid) do
    in_bound?(pos, grid) and
      cell_value(pos, grid) != "#"
  end

  defp valid_cell?(pos, grid, override_pos) do
    valid_cell?(pos, grid) and pos != override_pos
  end

  defp turn(:right), do: :down
  defp turn(:left), do: :up
  defp turn(:up), do: :right
  defp turn(:down), do: :left

  defp move({row, col}, :right), do: {row, col + 1}
  defp move({row, col}, :down), do: {row + 1, col}
  defp move({row, col}, :left), do: {row, col - 1}
  defp move({row, col}, :up), do: {row - 1, col}

  defp parse(input) do
    content =
      case input do
        nil ->
          case File.read(Path.join(["input", "day6.txt"])) do
            {:ok, content} -> content
          end

        _ ->
          input
      end

    content
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce({[], nil}, fn {row, ri}, {grid, start} ->
      cells = String.graphemes(row)

      case Enum.find_index(cells, fn cell -> cell == "^" end) do
        nil ->
          {grid ++ [cells], start}

        ci ->
          {grid ++ [cells], {ri, ci}}
      end
    end)
  end
end
