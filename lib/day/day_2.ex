defmodule AOC.Day2 do
  def solve_part1() do
    content = parse()

    Enum.reduce(content, 0, fn line, acc ->
      if validate_line(line) do
        acc + 1
      else
        acc
      end
    end)
  end

  def solve_part2() do
    content = parse()

    Enum.reduce(content, 0, fn line, acc ->
      choices =
        [
          line
          | line
            |> Enum.with_index()
            |> Enum.map(fn {_, index} ->
              List.delete_at(line, index)
            end)
        ]

      if Enum.any?(choices, &validate_line/1), do: acc + 1, else: acc
    end)
  end

  defp increasing_comparator([a, b]), do: a < b

  defp decreasing_comparator([a, b]), do: a > b

  defp validate_line(line) do
    chunks = Enum.chunk_every(line, 2, 1, :discard)

    comparator =
      if increasing_comparator(hd(chunks)) do
        &increasing_comparator/1
      else
        &decreasing_comparator/1
      end

    Enum.all?(
      chunks,
      fn [a, b] ->
        diff = abs(a - b)
        diff <= 3 and diff >= 1 and comparator.([a, b])
      end
    )
  end

  defp parse() do
    {:ok, content} = File.read(Path.join(["input", "day2.txt"]))

    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
