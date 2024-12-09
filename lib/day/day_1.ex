defmodule AOC.Day1 do
  def solve_part1() do
    {first, second} = parse()

    Enum.zip_reduce([Enum.sort(first), Enum.sort(second)], 0, fn [f, s], acc ->
      acc + abs(f - s)
    end)
  end

  def solve_part2() do
    {first, second} = parse()

    frequencies =
      Enum.reduce(second, %{}, fn n, acc ->
        Map.update(acc, n, 1, &(&1 + 1))
      end)

    Enum.reduce(first, 0, fn n, acc ->
      acc + Map.get(frequencies, n, 0) * n
    end)
  end

  defp parse() do
    {:ok, content} = File.read(Path.join(["input", "day1.txt"]))

    content
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], []}, fn line, {first, second} ->
      [e1, e2] =
        String.split(line, " ", trim: true)
        |> Enum.map(&String.to_integer/1)

      {
        [e1 | first],
        [e2 | second]
      }
    end)
  end
end
