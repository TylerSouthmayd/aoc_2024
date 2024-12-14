defmodule AOCDay4Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day4.solve_part1() == 2554
  end

  test "part 2" do
    assert AOC.Day4.solve_part2() == 1916
  end
end
