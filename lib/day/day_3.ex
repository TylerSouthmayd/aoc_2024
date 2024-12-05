defmodule AOC.Day3 do
  defp parse() do
    {:ok, content} = File.read(Path.join(["input", "day3.txt"]))
    content
  end

  def solve_part1() do
    content = parse()

    Regex.scan(~r/mul\((\d+),(\d+)\)/, content)
    |> Enum.reduce(0, fn [_, a, b], acc ->
      acc + String.to_integer(a) * String.to_integer(b)
    end)
  end

  def solve_part2() do
    content = parse()

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
