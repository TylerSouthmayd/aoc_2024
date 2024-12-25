defmodule Dijkstra do
  @spec dijkstra(map(), tuple(), function()) :: {map(), map()}
  def dijkstra(graph, start, get_neighbors \\ &default_get_neighbors/3) do
    visited = %{}
    distances = %{start => 0}
    predecessors = %{}
    heap = Heap.new(fn {a, _}, {b, _} -> a < b end)
    heap = Heap.push(heap, {0, start})

    dijkstra(graph, heap, visited, distances, predecessors, get_neighbors)
  end

  defp dijkstra(graph, heap, visited, distances, predecessors, get_neighbors) do
    case Heap.root(heap) do
      nil ->
        {distances, predecessors}

      {distance, current} ->
        heap = Heap.pop(heap)

        if Map.has_key?(visited, current) do
          dijkstra(graph, heap, visited, distances, predecessors, get_neighbors)
        else
          visited = Map.put(visited, current, true)
          neighbors = get_neighbors.(current, graph, visited)

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

          dijkstra(graph, heap, visited, distances, predecessors, get_neighbors)
        end
    end
  end

  defp default_get_neighbors(node, graph, visited) do
    GridUtils.get_neighbors(node)
    |> Enum.zip([1, 1, 1, 1])
    |> Enum.filter(fn {neighbor, _cost} ->
      Map.has_key?(graph, neighbor) and not Map.has_key?(visited, neighbor)
    end)
  end

  @spec reconstruct_paths(map(), tuple()) :: [list()]
  def reconstruct_paths(predecessors, target) do
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
end
