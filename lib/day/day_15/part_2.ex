defmodule AOC.Day15.Part2 do
  def solve(input \\ nil) do
    {start, grid, steps, bounds} = parse(input)

    {_, final_map} = move_robot(start, grid, steps, bounds)

    Map.filter(final_map, fn {_, val} -> val == "[" end)
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
    next_cell = GridUtils.cell_value(next_position, map)
    self_updates_on_move = [{position, "."}, {next_position, "@"}]

    {new_position, new_map} =
      cond do
        next_cell == "." ->
          {next_position, AOC.Day15.update_grid(map, self_updates_on_move)}

        next_cell == "[" or next_cell == "]" ->
          square = get_square(next_cell, next_position)
          [left, right] = square

          case pushable_squares(square, map, direction) do
            {:ok, pushable} ->
              pushable =
                if direction in [:left, :right] do
                  pushable
                else
                  (pushable ++ [left, right])
                  |> Enum.sort_by(
                    fn {row, _col} -> row end,
                    if(direction == :up, do: :asc, else: :desc)
                  )
                  |> Enum.map(fn pos ->
                    [
                      {GridUtils.move(pos, direction), GridUtils.cell_value(pos, map)},
                      {pos, "."}
                    ]
                  end)
                  |> List.flatten()
                end

              final_updates = pushable ++ self_updates_on_move
              {next_position, AOC.Day15.update_grid(map, final_updates)}

            {:error} ->
              {position, map}
          end

        next_cell == "#" ->
          {position, map}
      end

    move_robot(new_position, new_map, tl(rules), bounds)
  end

  defp pushable_squares([first, second], map, direction) when direction in [:up, :down] do
    with {:ok, left_pushable} <- check_next(first, map, direction),
         {:ok, right_pushable} <- check_next(second, map, direction) do
      {:ok, left_pushable ++ right_pushable}
    else
      {:error} -> {:error}
    end
  end

  defp pushable_squares([first, _second], map, direction) when direction == :right do
    check_next(first, map, direction)
  end

  defp pushable_squares([_first, second], map, direction) when direction == :left do
    check_next(second, map, direction)
  end

  defp check_next(position, map, direction) when direction in [:left, :right] do
    next = GridUtils.move(position, direction)
    cell = GridUtils.cell_value(next, map)

    case cell do
      "." ->
        {:ok, [{next, GridUtils.cell_value(position, map)}]}

      "#" ->
        {:error}

      _ ->
        case check_next(next, map, direction) do
          {:ok, pushable} ->
            {:ok, pushable ++ [{next, GridUtils.cell_value(position, map)}]}

          {:error} ->
            {:error}
        end
    end
  end

  defp check_next(position, map, direction) when direction in [:up, :down] do
    next_pos = GridUtils.move(position, direction)
    next_cell = GridUtils.cell_value(next_pos, map)

    cond do
      next_cell == "#" ->
        {:error}

      next_cell == "." ->
        {:ok, []}

      next_cell == "[" or next_cell == "]" ->
        square = [left, right] = get_square(next_cell, next_pos)

        case pushable_squares(square, map, direction) do
          {:ok, pushable} ->
            {:ok, pushable ++ [left, right]}

          {:error} ->
            {:error}
        end
    end
  end

  defp get_square(char, position) do
    case char do
      "[" ->
        [position, GridUtils.move(position, :right)]

      "]" ->
        [GridUtils.move(position, :left), position]
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
        cells =
          String.graphemes(line)
          |> Enum.reduce([], fn cell, acc ->
            case cell do
              "O" ->
                acc ++ ["[", "]"]

              "@" ->
                acc ++ ["@", "."]

              _ ->
                acc ++ [cell, cell]
            end
          end)

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

    # |> IO.inspect(label: "parsed")
  end
end
