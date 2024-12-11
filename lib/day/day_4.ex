defmodule AOC.Day4 do
  def solve_part1() do
    grid = parse()
    word = String.graphemes("XMAS")
    directions = [:right, :down, :left, :up, :up_left, :up_right, :down_left, :down_right]

    for row <- 0..(length(grid) - 1),
        col <- 0..(length(hd(grid)) - 1),
        direction <- directions,
        matches_character?(grid, ["X"], {row, col}, 0),
        reduce: 0 do
      acc -> acc + word_search(grid, word, {row, col}, 0, direction)
    end
  end

  def solve_part2() do
    grid = parse()

    for row <- 0..(length(grid) - 1),
        col <- 0..(length(hd(grid)) - 1),
        matches_character?(grid, ["A"], {row, col}, 0),
        reduce: 0 do
      acc -> acc + xmas_search(grid, {row, col})
    end
  end

  defp xmas_search(grid, {row, col}) do
    corners = [
      {:down_right, GridUtils.move({row, col}, :up_left)},
      {:down_left, GridUtils.move({row, col}, :up_right)}
    ]

    if Enum.all?(corners, fn {direction, position} ->
         Enum.any?([["M", "A", "S"], ["S", "A", "M"]], fn word ->
           word_search(grid, word, position, 0, direction) == 1
         end)
       end),
       do: 1,
       else: 0
  end

  defp word_search(_grid, word, _position, word_index, _direction)
       when word_index == length(word),
       do: 1

  defp word_search(grid, word, {row, col}, word_index, direction) do
    if matches_character?(grid, word, {row, col}, word_index),
      do:
        word_search(grid, word, GridUtils.move({row, col}, direction), word_index + 1, direction),
      else: 0
  end

  defp matches_character?(grid, word, {row, col}, index) do
    GridUtils.in_bound?({row, col}, grid) and
      GridUtils.cell_value({row, col}, grid) == Enum.at(word, index)
  end

  defp parse() do
    {:ok, content} = File.read(Path.join(["input", "day4.txt"]))

    content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end
