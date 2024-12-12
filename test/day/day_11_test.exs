defmodule AOCDay11Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day11.solve_part1() == 202_019
  end

  test "part 2" do
    assert AOC.Day11.solve_part2() == 239_321_955_280_205
  end
end
