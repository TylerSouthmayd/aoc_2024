defmodule AOC.Day25 do
  def solve_part1(input \\ nil) do
    {locks, keys} = parse(input)

    ans =
      for key <- keys,
          lock <- locks,
          check_key(key, lock),
          reduce: %{} do
        acc ->
          Map.update(acc, key, [lock], fn locks -> [lock | locks] end)
      end

    Enum.reduce(Map.values(ans), 0, fn locks, acc ->
      acc + length(locks)
    end)
  end

  def solve_part2(input \\ nil) do
    parse(input)
  end

  defp check_key([], []), do: true

  defp check_key([kv | key], [lv | lock]) do
    lv < kv and check_key(key, lock)
  end

  defp parse(input) do
    AOC.get_input(25, input)
    |> String.split("\n\n", trim: true)
    |> Enum.reduce({[], []}, fn chart, {locks, keys} ->
      chart_lines =
        chart
        |> String.split("\n", trim: true)

      type =
        if String.starts_with?(hd(chart_lines), "#"), do: :lock, else: :key

      lock_or_key =
        chart_lines
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {line, row}, col_height_map ->
          line
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.filter(fn {char, _col} -> char == "#" end)
          |> Enum.reduce(col_height_map, fn {_, col}, cols ->
            case type do
              :lock ->
                if row >= Map.get(cols, col, 0),
                  do: Map.put(cols, col, row),
                  else: cols

              :key ->
                if row < Map.get(cols, col, :infinity),
                  do: Map.put(cols, col, row),
                  else: cols
            end
          end)
        end)

      case type do
        :lock -> {locks ++ [map_to_sorted_list(lock_or_key)], keys}
        :key -> {locks, keys ++ [map_to_sorted_list(lock_or_key)]}
      end
    end)
  end

  defp map_to_sorted_list(map) do
    map
    |> Map.to_list()
    |> Enum.sort_by(fn {k, _v} -> k end)
    |> Enum.map(fn {_, v} -> v end)
  end
end
