defmodule AOC.Day5 do
  def solve_part1(input \\ nil) do
    {rules, page_lists} = parse(input)

    page_lists
    |> Enum.filter(&valid_page_list?(&1, rules))
    |> Enum.map(&middle_elem/1)
    |> Enum.sum()
  end

  def solve_part2(input \\ nil) do
    {rules, page_lists} = parse(input)

    page_lists
    |> Enum.filter(&(!valid_page_list?(&1, rules)))
    |> Enum.map(&sort_pages(&1, rules))
    |> Enum.map(&middle_elem/1)
    |> Enum.sum()
  end

  defp valid_page_list?(page_list, rules) do
    page_list
    |> Enum.reverse()
    |> Enum.reduce_while({true, MapSet.new()}, fn page, {valid, banned_values} ->
      if MapSet.member?(banned_values, page) do
        {:halt, {false, banned_values}}
      else
        {:cont,
         {
           valid,
           MapSet.union(banned_values, MapSet.new(Map.get(rules, page, [])))
         }}
      end
    end)
    |> elem(0)
  end

  defp sort_pages(pages, rules) do
    page_graph = reduce_rules(pages, rules)

    pages
    |> Enum.reduce({[], MapSet.new()}, fn page, {sorted, seen} ->
      dfs_check(page, page_graph, sorted, seen)
    end)
    |> elem(0)
  end

  defp dfs_check(neighbor, graph, sorted, seen) do
    if MapSet.member?(seen, neighbor),
      do: {sorted, seen},
      else: dfs(neighbor, graph, sorted, seen)
  end

  defp dfs(page, graph, sorted, seen) do
    seen = MapSet.put(seen, page)
    dependencies = Map.get(graph, page, [])

    dependencies
    |> Enum.reduce({sorted, seen}, fn neighbor, {sorted, seen} ->
      dfs_check(neighbor, graph, sorted, seen)
    end)
    |> then(fn {sorted, seen} ->
      {[page | sorted], seen}
    end)
  end

  defp reduce_rules(pages, rules) do
    page_set = MapSet.new(pages)

    Enum.reduce(pages, %{}, fn page, graph ->
      Map.put(
        graph,
        page,
        Map.get(rules, page, [])
        |> Enum.filter(&MapSet.member?(page_set, &1))
      )
    end)
  end

  defp middle_elem(list) do
    Enum.at(list, div(length(list), 2))
  end

  defp parse(input) do
    AOC.get_input(5, input)
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, []}, fn line, {rules, page_lists} ->
      cond do
        String.contains?(line, "|") -> {add_rule(rules, line), page_lists}
        String.contains?(line, ",") -> {rules, add_page_list(page_lists, line)}
        true -> {rules, page_lists}
      end
    end)
  end

  defp add_rule(rules, rule) do
    [priority, secondary] = String.split(rule, "|")
    key = String.to_integer(priority)
    priorityRules = Map.get(rules, key, MapSet.new())

    Map.put(
      rules,
      key,
      MapSet.put(priorityRules, String.to_integer(secondary))
    )
  end

  defp add_page_list(page_lists, pages) do
    page_lists ++ [Enum.map(String.split(pages, ",", trim: true), &String.to_integer/1)]
  end
end
