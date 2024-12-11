defmodule AOC.Day10 do
  def solve_part1(input \\ nil) do
    {trail_heads, grid} = parse(input)

    Enum.reduce(
      trail_heads,
      0,
      &(&2 + MapSet.size(elem(walk(grid, &1, 0, {MapSet.new(), 0}), 0)))
    )
  end

  def solve_part2(input \\ nil) do
    {trail_heads, grid} = parse(input)

    Enum.reduce(trail_heads, 0, &(&2 + elem(walk(grid, &1, 0, {MapSet.new(), 0}), 1)))
  end

  defp walk(
         _,
         current_position,
         current_value,
         {valid_trails, unique_paths}
       )
       when current_value == 9,
       do: {
         MapSet.put(valid_trails, current_position),
         unique_paths + 1
       }

  defp walk(grid, current_position, current_value, tracking) do
    neighbors = get_neighbors(current_position, current_value, grid)

    case length(neighbors) do
      0 ->
        tracking

      _ ->
        Enum.reduce(neighbors, tracking, fn neighbor, tracking ->
          walk(
            grid,
            neighbor,
            GridUtils.cell_value(neighbor, grid),
            tracking
          )
        end)
    end
  end

  defp get_neighbors({row, col}, val, grid) do
    GridUtils.get_neighbors({row, col})
    |> Enum.filter(&(GridUtils.in_bound?(&1, grid) and GridUtils.cell_value(&1, grid) == val + 1))
  end

  defp parse(input) do
    AOC.get_input(10, input)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({MapSet.new(), []}, fn {line, row}, {trail_heads, grid} ->
      {new_trailheads, new_line} =
        String.graphemes(line)
        |> Enum.with_index()
        |> Enum.reduce({trail_heads, []}, fn {char, col}, {trail_heads, line} ->
          if char == "0" do
            trail_heads = MapSet.put(trail_heads, {row, col})
            {trail_heads, [0 | line]}
          else
            {trail_heads, [String.to_integer(char) | line]}
          end
        end)

      {new_trailheads, grid ++ [Enum.reverse(new_line)]}
    end)
  end
end
