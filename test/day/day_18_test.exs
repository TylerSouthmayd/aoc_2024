defmodule AOCDay18Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day18.solve_part1() == 314
  end

  test "part 2" do
    assert AOC.Day18.solve_part2() == {15, 20}
  end
end
