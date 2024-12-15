defmodule Robot do
  defstruct [:initial_position, :position, :x_velocity, :y_velocity, :quadrant]

  defimpl String.Chars, for: Robot do
    def to_string(%Robot{
          initial_position: {x, y},
          position: {x2, y2},
          x_velocity: x_vel,
          y_velocity: y_vel
        }) do
      "ip=#{x},#{y} p=#{x2},#{y2} v=#{x_vel},#{y_vel}"
    end
  end

  def print_robots(robots, {x_bound, y_bound}, second \\ 0) when is_list(robots) do
    IO.puts("second #{second}:")

    position_map =
      robots
      |> Enum.reduce(%{}, fn %Robot{position: {y, x}}, acc ->
        Map.update(acc, {y, x}, 1, &(&1 + 1))
      end)

    for y <- 0..(y_bound - 1) do
      for x <- 0..(x_bound - 1) do
        position_map[{y, x}] || "."
      end
      |> Enum.join(" ")
      |> IO.inspect()
    end

    IO.puts(" ")
  end
end

defmodule AOC.Day14 do
  def solve_part1(input \\ nil, bounds \\ {101, 103}) do
    robots = parse(input, bounds)

    Enum.map(robots, fn robot ->
      Enum.reduce(0..99, robot, fn _i, rb -> move_robot(rb, bounds) end)
    end)
    |> quadrant_stats()
    |> safety_score()
  end

  def solve_part2(input \\ nil, bounds \\ {101, 103}) do
    robots = parse(input, bounds)

    Enum.reduce(0..10000, {0, :infinity, robots}, fn i, {min_index, min_score, robots} ->
      # Easter egg
      # if i == 7687 do
      #   Robot.print_robots(robots, bounds, i)
      # end

      robots = Enum.map(robots, &move_robot(&1, bounds))
      score = safety_score(quadrant_stats(robots))

      if score < min_score,
        do: {i + 1, score, robots},
        else: {min_index, min_score, robots}
    end)
    |> elem(0)
  end

  defp move_robot(
         %Robot{position: {x, y}, x_velocity: xv, y_velocity: yv} = robot,
         {x_bound, y_bound}
       ) do
    new_position = {
      wrap_dimension(x + xv, x_bound),
      wrap_dimension(y + yv, y_bound)
    }

    %Robot{
      robot
      | position: new_position,
        quadrant: find_quadrant(new_position, {x_bound, y_bound})
    }
  end

  defp wrap_dimension(x_or_y, bound) when x_or_y < 0, do: bound - abs(x_or_y)
  defp wrap_dimension(x_or_y, bound) when x_or_y >= bound, do: x_or_y - bound
  defp wrap_dimension(x_or_y, _bound), do: x_or_y

  defp find_quadrant({x, y}, {x_bound, y_bound}) do
    mid_x = div(x_bound, 2)
    mid_y = div(y_bound, 2)

    cond do
      x < mid_x and y < mid_y -> 1
      x > mid_x and y < mid_y -> 2
      x < mid_x and y > mid_y -> 3
      x > mid_x and y > mid_y -> 4
      true -> :none
    end
  end

  defp quadrant_stats(robots) do
    robots
    |> Enum.group_by(& &1.quadrant)
    |> Enum.map(fn {quadrant, robots} ->
      {quadrant, length(robots)}
    end)
  end

  defp safety_score(quadrants) do
    Enum.reduce(quadrants, 1, fn {quadrant, len}, acc ->
      if quadrant == :none, do: acc, else: acc * len
    end)
  end

  defp parse(input, bounds) do
    AOC.get_input(14, input)
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_robot(&1, bounds))
  end

  defp parse_robot(line, bounds) do
    [_, x, y, x_velocity, y_velocity] = Regex.run(~r/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/, line)

    initial_position = {String.to_integer(x), String.to_integer(y)}

    %Robot{
      initial_position: initial_position,
      position: initial_position,
      quadrant: find_quadrant(initial_position, bounds),
      x_velocity: String.to_integer(x_velocity),
      y_velocity: String.to_integer(y_velocity)
    }
  end
end
