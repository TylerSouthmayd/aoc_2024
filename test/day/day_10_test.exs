defmodule AOCDay10Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day10.solve_part1() == 682
  end

  test "part 2" do
    assert AOC.Day10.solve_part2() == 1511
  end
end
