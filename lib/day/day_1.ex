defmodule AOC.Day1 do
  def solve_part1(input \\ nil) do
    {first, second} = parse(input)

    Enum.zip_reduce([Enum.sort(first), Enum.sort(second)], 0, fn [f, s], acc ->
      acc + abs(f - s)
    end)
  end

  def solve_part2(input \\ nil) do
    {first, second} = parse(input)

    frequencies =
      Enum.reduce(second, %{}, fn n, acc ->
        Map.update(acc, n, 1, &(&1 + 1))
      end)

    Enum.reduce(first, 0, fn n, acc ->
      acc + Map.get(frequencies, n, 0) * n
    end)
  end

  defp parse(input) do
    AOC.get_input(1, input)
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
