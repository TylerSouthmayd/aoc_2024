defmodule AOC.Day3 do
  def solve_part1(input \\ nil) do
    content = AOC.get_input(3, input)

    Regex.scan(~r/mul\((\d+),(\d+)\)/, content)
    |> Enum.reduce(0, fn [_, a, b], acc ->
      acc + String.to_integer(a) * String.to_integer(b)
    end)
  end

  def solve_part2(input \\ nil) do
    content = AOC.get_input(3, input)

    Regex.scan(~r/(mul\((\d+),(\d+)\)|do\(\)|don\'t\(\))/, content)
    |> Enum.reduce({0, true}, fn match, {sum, enabled} ->
      case match do
        ["do()", _] ->
          {sum, true}

        ["don\'t()", _] ->
          {sum, false}

        ["mul(" <> _, _, a, b] ->
          if enabled do
            {sum + String.to_integer(a) * String.to_integer(b), enabled}
          else
            {sum, enabled}
          end
      end
    end)
    |> elem(0)
  end
end
