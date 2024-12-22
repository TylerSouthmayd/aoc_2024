defmodule AOC.Day15.Part1 do
  def solve(input \\ nil) do
    {start, grid, steps, bounds} = parse(input)

    {_, final_map} = move_robot(start, grid, steps, bounds)

    Map.filter(final_map, fn {_, val} -> val == "O" end)
    |> Map.to_list()
    |> Enum.map(fn {position, _} ->
      AOC.Day15.score(position)
    end)
    |> Enum.sum()
  end

  defp move_robot(final_position, final_map, [], _) do
    {final_position, final_map}
  end

  defp move_robot(position, map, rules, bounds) do
    direction = hd(rules)
    next_position = GridUtils.move(position, direction)
    self_updates_on_move = [{position, "."}, {next_position, "@"}]

    {new_position, new_map} =
      case GridUtils.cell_value(next_position, map) do
        "." ->
          {next_position, AOC.Day15.update_grid(map, self_updates_on_move)}

        "O" ->
          pushable = pushable_cells(next_position, map, direction, [])

          if length(pushable) > 0,
            do: {next_position, AOC.Day15.update_grid(map, pushable ++ self_updates_on_move)},
            else: {position, map}

        "#" ->
          {position, map}
      end

    move_robot(new_position, new_map, tl(rules), bounds)
  end

  defp pushable_cells(position, map, direction, pushable) do
    cell = GridUtils.cell_value(position, map)

    case cell do
      "#" ->
        []

      "." ->
        [{position, "O"} | pushable]

      "O" ->
        pushable_cells(
          GridUtils.move(position, direction),
          map,
          direction,
          [{position, "O"} | pushable]
        )
    end
  end

  defp parse(input) do
    [grid, rules] =
      AOC.get_input(15, input)
      |> String.split("\n\n", trim: true)

    {start, grid} =
      grid
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce({nil, []}, fn {line, row}, {start, grid} ->
        cells = String.graphemes(line)
        robot_column = Enum.find_index(cells, &(&1 == "@"))

        if robot_column != nil do
          {{row, robot_column}, grid ++ [cells]}
        else
          {start, grid ++ [cells]}
        end
      end)

    {
      start,
      GridUtils.list_to_position_map(grid),
      AOC.Day15.parse_rules(rules),
      GridUtils.get_bounds(grid)
    }
  end
end
