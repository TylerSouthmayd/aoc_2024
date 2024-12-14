defmodule AOCDay2Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day2.solve_part1() == 670
  end

  test "part 2" do
    assert AOC.Day2.solve_part2() == 700
  end
end
