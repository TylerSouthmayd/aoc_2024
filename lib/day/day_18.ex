defmodule AOC.Day18 do
  def solve_part1(input \\ nil, bytes \\ 1024, bounds \\ {71, 71}) do
    {_, predecessors} =
      parse(input)
      |> dijkstra_n_corrupted(bytes, bounds)

    Dijkstra.reconstruct_paths(predecessors, {elem(bounds, 0) - 1, elem(bounds, 1) - 1})
    |> Enum.map(&length/1)
    |> Enum.min()
    |> then(&(&1 - 1))
  end

  def solve_part2(input \\ nil, bounds \\ {71, 71}) do
    parse(input)
    |> binary_search_corruption(bounds)
  end

  defp binary_search_corruption(corrupted_cells, bounds) do
    start = 0
    finish = length(corrupted_cells) - 1

    binary_search_corruption(
      corrupted_cells,
      bounds,
      start,
      finish,
      {elem(bounds, 0) - 1, elem(bounds, 1) - 1}
    )
  end

  defp binary_search_corruption(corrupted_cells, _bounds, left, right, _target_node)
       when left >= right do
    {row, col} = Enum.at(corrupted_cells, div(left + right, 2))
    {col, row}
  end

  defp binary_search_corruption(corrupted_cells, bounds, left, right, target_node) do
    mid = div(left + right, 2)
    {distances, _} = dijkstra_n_corrupted(corrupted_cells, mid, bounds)

    if Map.has_key?(distances, target_node),
      do: binary_search_corruption(corrupted_cells, bounds, mid + 1, right, target_node),
      else: binary_search_corruption(corrupted_cells, bounds, left, mid - 1, target_node)
  end

  defp dijkstra_n_corrupted(corrupted_cells, n, bounds) do
    Enum.take(corrupted_cells, n)
    |> Enum.reduce(%{}, &Map.put(&2, &1, "#"))
    |> GridUtils.position_map_to_list(bounds)
    |> GridUtils.list_to_position_map()
    |> Map.filter(fn {_, v} -> v != "#" end)
    |> Dijkstra.dijkstra({0, 0})
  end

  defp parse(input) do
    AOC.get_input(18, input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      [col, row] =
        String.split(s, ",")
        |> Enum.map(&String.to_integer/1)

      {row, col}
    end)
  end
end
