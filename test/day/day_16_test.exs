defmodule AOCDay16Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day16.solve_part1() == 130_536
  end

  test "part 2" do
    assert AOC.Day16.solve_part2() == 1024
  end
end
