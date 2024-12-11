defmodule AOC.Day6 do
  def solve_part1(input \\ nil) do
    {grid, start} = parse(input)

    walk(grid, MapSet.new(), start, :up)
  end

  def solve_part2(input \\ nil) do
    {grid, start} = parse(input)

    for row <- 0..(length(grid) - 1),
        col <- 0..(length(hd(grid)) - 1),
        GridUtils.cell_value({row, col}, grid) == ".",
        reduce: 0 do
      acc -> acc + walk_cycle(grid, MapSet.new(), start, :up, {row, col})
    end
  end

  defp walk(grid, seen, curr_pos, direction) do
    seen = MapSet.put(seen, curr_pos)
    next_pos = GridUtils.move(curr_pos, direction)
    exiting = not GridUtils.in_bound?(next_pos, grid)
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
    next_pos = GridUtils.move(curr_pos, direction)
    exiting = not GridUtils.in_bound?(next_pos, grid)
    valid_next = valid_cell?(next_pos, grid, override_pos)

    cond do
      cycle -> 1
      exiting -> 0
      valid_next -> walk_cycle(grid, seen, next_pos, direction, override_pos)
      true -> walk_cycle(grid, seen, curr_pos, turn(direction), override_pos)
    end
  end

  defp valid_cell?(pos, grid) do
    GridUtils.in_bound?(pos, grid) and
      GridUtils.cell_value(pos, grid) != "#"
  end

  defp valid_cell?(pos, grid, override_pos) do
    valid_cell?(pos, grid) and pos != override_pos
  end

  defp turn(:right), do: :down
  defp turn(:left), do: :up
  defp turn(:up), do: :right
  defp turn(:down), do: :left

  defp parse(input) do
    AOC.get_input(6, input)
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
