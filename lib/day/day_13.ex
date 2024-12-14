defmodule ClawMachine do
  defstruct [:goal, :a_mod, :b_mod]
end

defmodule AOC.Day13 do
  def solve_part1(input \\ nil) do
    solve(parse(input))
  end

  def solve_part2(input \\ nil) do
    solve(parse(input, true))
  end

  def solve(input) do
    Enum.reduce(input, 0, fn machine, cost ->
      ans = solve_system(machine)
      [a_presses, b_presses] = normalize_answer(machine, ans)

      new_cost = 3 * a_presses + b_presses
      cost + new_cost
    end)
  end

  defp solve_system(%ClawMachine{
         a_mod: {ax_mod, ay_mod},
         b_mod: {bx_mod, by_mod},
         goal: {x, y}
       }) do
    solution_matrix = [x, y]

    coefficient_matrix = [
      [ax_mod, bx_mod],
      [ay_mod, by_mod]
    ]

    multiply_2x2(invert_2x2!(coefficient_matrix), solution_matrix)
  end

  defp multiply_2x2([[a, b], [c, d]], [e, f]) do
    [a * e + b * f, c * e + d * f]
  end

  defp invert_2x2!([[a, b], [c, d]] = matrix) do
    determinant = determinant_2x2(matrix)

    if determinant == 0 do
      raise "Matrix is not invertible"
    end

    determinant = 1 / determinant

    [[determinant * d, determinant * b * -1], [determinant * c * -1, determinant * a]]
  end

  defp determinant_2x2([[a, b], [c, d]]) do
    a * d - b * c
  end

  defp normalize_answer(
         %ClawMachine{goal: {goal_x, goal_y}, a_mod: {ax_mod, ay_mod}, b_mod: {bx_mod, by_mod}},
         [a_presses, b_presses]
       ) do
    a_presses = round(a_presses)
    b_presses = round(b_presses)

    hits_goal_x = goal_x == ax_mod * a_presses + bx_mod * b_presses
    hits_goal_y = goal_y == ay_mod * a_presses + by_mod * b_presses

    if hits_goal_x and hits_goal_y do
      [a_presses, b_presses]
    else
      [0, 0]
    end
  end

  defp parse(input, extend_goal \\ false) do
    AOC.get_input(13, input)
    |> String.split("\n")
    |> Enum.chunk_every(4)
    |> Enum.reduce([], fn chunk, acc ->
      case chunk do
        [a, b, prize, _] ->
          [
            %ClawMachine{
              goal: extract_goal(prize, extend_goal),
              a_mod: extract_button(a),
              b_mod: extract_button(b)
            }
            | acc
          ]

        _ ->
          acc
      end
    end)
  end

  defp extract_button(button_string) do
    [_, x_mod, y_mod] = Regex.run(~r/.*X\+(\d+), Y\+(\d+)/, button_string)
    {String.to_integer(x_mod), String.to_integer(y_mod)}
  end

  defp extract_goal(prize_string, extend_goal) do
    [_, x_goal, y_goal] = Regex.run(~r/.*X=(\d+), Y=(\d+)/, prize_string)

    x_goal = String.to_integer(x_goal)
    y_goal = String.to_integer(y_goal)

    if extend_goal do
      {x_goal + 10_000_000_000_000, y_goal + 10_000_000_000_000}
    else
      {x_goal, y_goal}
    end
  end
end
