defmodule AOC.Day11 do
  def solve_part1(input \\ nil) do
    blink(parse(input), 25)
  end

  def solve_part2(input \\ nil) do
    blink(parse(input), 75)
  end

  defp blink(stones, times) do
    Enum.reduce(stones, {0, %{}}, fn stone, {acc, memo} ->
      {size, memo} = blink(stone, times, memo)
      {acc + size, memo}
    end)
    |> elem(0)
  end

  defp blink(_, 0, memo), do: {1, memo}

  defp blink(stone, times, memo) do
    case Map.get(memo, {stone, times}) do
      nil ->
        len = String.length(stone)

        {size, memo} =
          cond do
            stone == "0" ->
              blink("1", times - 1, memo)

            rem(len, 2) == 0 ->
              Enum.reduce(split_stone(stone, len), {0, memo}, fn stone, {size, memo} ->
                {subset_size, memo} = blink(stone, times - 1, memo)
                {size + subset_size, memo}
              end)

            true ->
              blink("#{String.to_integer(stone) * 2024}", times - 1, memo)
          end

        {size, Map.put(memo, {stone, times}, size)}

      size ->
        {size, memo}
    end
  end

  defp split_stone(val, len) do
    String.split_at(val, div(len, 2))
    |> Tuple.to_list()
    |> Enum.map(&"#{String.to_integer(&1)}")
  end

  defp parse(input) do
    String.split(AOC.get_input(11, input), " ", trim: true)
  end
end
