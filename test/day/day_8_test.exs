defmodule AOCDay8Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day8.solve_part1() == 409
  end

  test "part 2" do
    assert AOC.Day8.solve_part2() == 1308
  end
end
