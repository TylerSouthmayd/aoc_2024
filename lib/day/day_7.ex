defmodule AOC.Day7 do
  def solve_part1(input \\ nil) do
    operators = [:add, :mult]
    solve(input, operators)
  end

  def solve_part2(input \\ nil) do
    operators = [:add, :mult, :concat]
    solve(input, operators)
  end

  defp solve(input, operators) do
    parse(input)
    |> Enum.filter(fn [target, nums] ->
      create_expressions(
        nums,
        combinations(length(nums), operators)
      )
      |> Enum.map(&evaluate_expression/1)
      |> Enum.any?(fn v -> v == target end)
    end)
    |> Enum.map(fn [target, _] -> target end)
    |> Enum.sum()
  end

  defp combinations(0, _), do: [[]]

  defp combinations(n, operators) do
    for op <- operators,
        comb <- combinations(n - 1, operators) do
      [op | comb]
    end
  end

  defp create_expressions(numbers, operation_combinations) do
    Enum.map(operation_combinations, fn operations ->
      Enum.zip(numbers, operations)
    end)
  end

  defp evaluate_expression(expression) do
    expression
    |> Enum.reduce({0, :add}, fn {num, next_op}, {val, curr_op} ->
      case {val, curr_op} do
        {0, _} ->
          {num, next_op}

        {_, _} ->
          case curr_op do
            :add -> {val + num, next_op}
            :mult -> {val * num, next_op}
            :concat -> {String.to_integer("#{val}#{num}"), next_op}
          end
      end
    end)
    |> elem(0)
  end

  defp parse(input) do
    content =
      case input do
        nil ->
          case File.read(Path.join(["input", "day7.txt"])) do
            {:ok, content} -> content
          end

        _ ->
          input
      end

    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [line, nums] = String.split(line, ":")

      [
        String.to_integer(line),
        nums |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      ]
    end)
  end
end
