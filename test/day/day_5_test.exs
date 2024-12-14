defmodule AOCDay5Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day5.solve_part1() == 4905
  end

  test "part 2" do
    assert AOC.Day5.solve_part2() == 6204
  end
end
