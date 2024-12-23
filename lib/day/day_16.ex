defmodule AOC.Day16 do
  @neighbor_directions %{
    :up => [:up, :left, :right],
    :down => [:down, :left, :right],
    :left => [:left, :up, :down],
    :right => [:right, :up, :down]
  }

  def solve_part1(input \\ nil) do
    maze = parse(input)
    # GridUtils.print_position_map(maze)

    valid_maze = Map.filter(maze, fn {_, cell} -> cell != "#" end)
    start = {find_position("S", valid_maze), :right}
    end_position = find_position("E", valid_maze)

    {distances, _} = dijkstra(valid_maze, start)

    targets = [
      {end_position, :right},
      {end_position, :up}
    ]

    Map.filter(distances, fn {key, _} -> key in targets end)
    |> Map.values()
    |> Enum.min()
  end

  def solve_part2(input \\ nil) do
    maze = parse(input)
    # GridUtils.print_position_map(maze)

    valid_maze = Map.filter(maze, fn {_, cell} -> cell != "#" end)
    start = {find_position("S", valid_maze), :right}
    end_position = find_position("E", valid_maze)

    targets = [
      {end_position, :right},
      {end_position, :up}
    ]

    {distances, predecessors} = dijkstra(valid_maze, start)
    potential_answers = Map.filter(distances, fn {key, _} -> key in targets end)
    min = potential_answers |> Map.values() |> Enum.min()

    potential_answers
    |> Map.filter(fn {_, value} -> value == min end)
    |> Map.to_list()
    |> Enum.map(fn {target, _} -> reconstruct_paths(predecessors, target) end)
    |> List.flatten()
    |> Enum.reduce(maze, fn {position, _}, acc ->
      Map.put(acc, position, "O")
    end)
    # |> GridUtils.print_position_map()
    |> Map.filter(fn {_, cell} -> cell == "O" end)
    |> map_size()
  end

  defp dijkstra(maze, start) do
    visited = %{}
    distances = %{start => 0}
    predecessors = %{}
    heap = Heap.new(fn {a, _}, {b, _} -> a < b end)
    heap = Heap.push(heap, {0, start})

    dijkstra(maze, heap, visited, distances, predecessors)
  end

  defp dijkstra(maze, heap, visited, distances, predecessors) do
    case Heap.root(heap) do
      nil ->
        {distances, predecessors}

      {distance, current} ->
        heap = Heap.pop(heap)

        if Map.has_key?(visited, current) do
          dijkstra(maze, heap, visited, distances, predecessors)
        else
          visited = Map.put(visited, current, true)
          neighbors = get_neighbors(current, maze, visited)

          {heap, distances, predecessors} =
            Enum.reduce(neighbors, {heap, distances, predecessors}, fn neighbor,
                                                                       {heap, distances,
                                                                        predecessors} ->
              {key, cost} = neighbor
              new_cost = distance + cost

              if new_cost <= Map.get(distances, key, :infinity) do
                case new_cost == Map.get(distances, key, :infinity) do
                  true ->
                    distances = Map.put(distances, key, new_cost)
                    heap = Heap.push(heap, {new_cost, key})

                    predecessors =
                      Map.put(predecessors, key, [current | Map.get(predecessors, key, [])])

                    {heap, distances, predecessors}

                  false ->
                    distances = Map.put(distances, key, new_cost)
                    predecessors = Map.put(predecessors, key, [current])
                    heap = Heap.push(heap, {new_cost, key})
                    {heap, distances, predecessors}
                end
              else
                {heap, distances, predecessors}
              end
            end)

          dijkstra(maze, heap, visited, distances, predecessors)
        end
    end
  end

  defp get_neighbors({position, direction}, maze, visited) do
    GridUtils.get_neighbors(position, @neighbor_directions[direction])
    |> Enum.zip(@neighbor_directions[direction])
    |> Enum.zip([1, 1001, 1001])
    |> Enum.filter(fn {{neighbor, _}, _} ->
      Map.has_key?(maze, neighbor) and not Map.has_key?(visited, neighbor)
    end)
  end

  defp reconstruct_paths(predecessors, target) do
    reconstruct_paths(predecessors, target, [])
  end

  defp reconstruct_paths(predecessors, target, path) do
    case Map.get(predecessors, target) do
      nil ->
        [Enum.reverse([target | path])]

      predecessors_list ->
        Enum.flat_map(predecessors_list, fn predecessor ->
          reconstruct_paths(predecessors, predecessor, [target | path])
        end)
    end
  end

  defp find_position(character, maze) do
    maze
    |> Enum.find(fn {_, cell} -> cell == character end)
    |> elem(0)
  end

  defp parse(input) do
    AOC.get_input(16, input)
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, col}, acc ->
        Map.put(acc, {row, col}, cell)
      end)
    end)
  end
end
