defmodule AOC.DayX do
  def solve_part1(input \\ nil) do
    content = parse(input)
  end

  def solve_part2(input \\ nil) do
    content = parse(input)
  end

  defp parse(input) do
    content =
      case input do
        nil ->
          case File.read(Path.join(["input", "day10.txt"])) do
            {:ok, content} -> content
          end

        _ ->
          input
      end

    content
  end
end
