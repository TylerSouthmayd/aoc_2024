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

    {distances, _} = Dijkstra.dijkstra(valid_maze, start, &get_neighbors/3)

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

    {distances, predecessors} = Dijkstra.dijkstra(valid_maze, start, &get_neighbors/3)
    potential_answers = Map.filter(distances, fn {key, _} -> key in targets end)
    min = potential_answers |> Map.values() |> Enum.min()

    potential_answers
    |> Map.filter(fn {_, value} -> value == min end)
    |> Map.to_list()
    |> Enum.map(fn {target, _} -> Dijkstra.reconstruct_paths(predecessors, target) end)
    |> List.flatten()
    |> Enum.reduce(maze, fn {position, _}, acc ->
      Map.put(acc, position, "O")
    end)
    # |> GridUtils.print_position_map()
    |> Map.filter(fn {_, cell} -> cell == "O" end)
    |> map_size()
  end

  defp get_neighbors({position, direction}, maze, visited) do
    GridUtils.get_neighbors(position, @neighbor_directions[direction])
    |> Enum.zip(@neighbor_directions[direction])
    |> Enum.zip([1, 1001, 1001])
    |> Enum.filter(fn {{neighbor, _}, _} ->
      Map.has_key?(maze, neighbor) and not Map.has_key?(visited, neighbor)
    end)
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
