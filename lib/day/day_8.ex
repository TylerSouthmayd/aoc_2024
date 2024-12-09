defmodule AOC.Day8 do
  def solve_part1(input \\ nil) do
    parse(input)
    |> solve(&find_antinodes/2)
  end

  def solve_part2(input \\ nil) do
    parse(input)
    |> solve(&find_antinodes_continuous/2)
  end

  defp solve({antennas, bounds}, search_fn) do
    Map.to_list(antennas)
    |> Enum.reduce(MapSet.new(), fn {_, antenna_locations}, antinodes ->
      MapSet.union(antinodes, search_fn.(antenna_locations, bounds))
    end)
    |> MapSet.size()
  end

  defp find_antinodes(antenna_locations, bounds) do
    Enum.reduce(
      get_antenna_pairs(antenna_locations),
      MapSet.new(),
      fn [first, second], antinodes ->
        antinode =
          compute_antinode_location(first, compute_antinode_slope(first, second))

        case in_bound?(antinode, bounds) do
          true -> MapSet.put(antinodes, antinode)
          false -> antinodes
        end
      end
    )
  end

  defp find_antinodes_continuous(antenna_locations, bounds) do
    Enum.reduce(
      get_antenna_pairs(antenna_locations),
      MapSet.new(),
      fn antenna_pair, antinodes ->
        MapSet.union(antinodes, compute_antinode_location_while_inbound(antenna_pair, bounds))
      end
    )
  end

  defp compute_antinode_location_while_inbound([first_antenna, second_antenna], bounds) do
    slope = compute_antinode_slope(first_antenna, second_antenna)

    compute_antinode_location_while_inbound(
      first_antenna,
      bounds,
      slope,
      MapSet.new([first_antenna, second_antenna])
    )
  end

  defp compute_antinode_location_while_inbound(position, bounds, slope, antinodes) do
    antinode = compute_antinode_location(position, slope)

    if not in_bound?(antinode, bounds),
      do: antinodes,
      else:
        compute_antinode_location_while_inbound(
          antinode,
          bounds,
          slope,
          MapSet.put(antinodes, antinode)
        )
  end

  defp get_antenna_pairs(antenna_locations) do
    for i <- antenna_locations,
        j <- antenna_locations,
        i != j,
        reduce: MapSet.new() do
      acc -> MapSet.put(acc, [i, j])
    end
  end

  defp compute_antinode_location({r1, c1}, {r2, c2}) do
    {r1 + r2, c1 + c2}
  end

  defp compute_antinode_slope({r1, c1}, {r2, c2}) do
    {r1 - r2, c1 - c2}
  end

  defp in_bound?({row, col}, {row_bound, col_bound}) do
    row >= 0 and row < row_bound and
      col >= 0 and col < col_bound
  end

  defp parse(input) do
    content =
      case input do
        nil ->
          case File.read(Path.join(["input", "day8.txt"])) do
            {:ok, content} -> content
          end

        _ ->
          input
      end

    lines =
      content
      |> String.split("\n")

    bounds = {length(lines), String.length(hd(lines))}

    antennas =
      lines
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, row}, nodes ->
        String.graphemes(line)
        |> Enum.with_index()
        |> Enum.reduce(nodes, fn {char, col}, acc ->
          if char != ".",
            do:
              Map.update(acc, char, [{row, col}], fn existing ->
                [{row, col} | existing]
              end),
            else: acc
        end)
      end)

    {antennas, bounds}
  end
end
