defmodule AOC.Day23 do
  def solve_part1(input \\ nil) do
    parse(input)
    |> get_triplets()
    |> MapSet.filter(fn key ->
      Enum.any?(key, &String.starts_with?(&1, "t"))
    end)
    |> MapSet.size()
  end

  def solve_part2(input \\ nil) do
    content = parse(input)

    find_maximal_clique(content, get_triplets(content))
    |> MapSet.to_list()
    |> List.flatten()
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp get_triplets(content) do
    Map.keys(content)
    |> Enum.reduce(MapSet.new(), fn key, acc ->
      links = Map.get(content, key)
      choices = MapSet.new(links)

      {_, acc} =
        Enum.reduce(links, {choices, acc}, fn choice, {choices, acc} ->
          choices = MapSet.delete(choices, choice)
          choice_links = Map.get(content, choice)

          matches =
            Enum.filter(choices, fn choice ->
              MapSet.member?(choice_links, choice)
            end)
            |> Enum.map(&[key, choice, &1])
            |> Enum.map(&Enum.sort/1)
            |> MapSet.new()

          {choices, MapSet.union(acc, matches)}
        end)

      acc
    end)
  end

  defp find_maximal_clique(map, cliques) do
    find_maximal_cliques(map, cliques, MapSet.new())
  end

  defp find_maximal_cliques(map, cliques, prev_cliques) do
    if MapSet.size(cliques) == 0 do
      prev_cliques
    else
      new_cliques =
        Enum.reduce(cliques, MapSet.new(), fn key, acc ->
          expand_clique(map, MapSet.new(key))
          |> MapSet.union(acc)
        end)

      find_maximal_cliques(map, new_cliques, cliques)
    end
  end

  defp expand_clique(map, clique) do
    all_choices =
      Enum.reduce(clique, MapSet.new(), fn key, acc ->
        MapSet.union(acc, Map.get(map, key, MapSet.new()))
      end)
      |> MapSet.filter(fn key ->
        not MapSet.member?(clique, key)
      end)

    {_, cliques} =
      Enum.reduce(all_choices, {all_choices, MapSet.new()}, fn choice, {choices, cliques} ->
        choices = MapSet.delete(choices, choice)

        matches =
          Enum.filter(choices, fn neighbor ->
            neighbor_links = Map.get(map, neighbor, MapSet.new())

            Enum.all?(clique, fn c ->
              MapSet.member?(neighbor_links, c)
            end)
          end)

        new_cliques =
          Enum.map(matches, fn match ->
            [match | MapSet.to_list(clique)]
          end)
          |> Enum.map(&Enum.sort/1)
          |> MapSet.new()

        {choices, MapSet.union(cliques, new_cliques)}
      end)

    cliques
  end

  defp parse(input) do
    AOC.get_input(23, input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [a, b], acc ->
      Map.update(acc, a, MapSet.new([b]), fn set -> MapSet.put(set, b) end)
      |> Map.update(b, MapSet.new([a]), fn set -> MapSet.put(set, a) end)
    end)
  end
end
