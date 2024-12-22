defmodule AOC.Day15 do
  @direction_mapping %{
    "^" => :up,
    "v" => :down,
    "<" => :left,
    ">" => :right
  }

  def score({row, col}), do: 100 * row + col

  def update_grid(map, updated_cells) do
    Enum.reduce(updated_cells, map, fn {{row, col}, val}, acc ->
      Map.put(acc, {row, col}, val)
    end)
  end

  def parse_rules(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Enum.map(String.graphemes(line), &@direction_mapping[&1])
    end)
    |> List.flatten()
  end
end
