defmodule AOCDay12Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day12.solve_part1() == 1_488_414
  end

  test "part 2" do
    assert AOC.Day12.solve_part2() == 911_750
  end
end
