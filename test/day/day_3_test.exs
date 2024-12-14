defmodule AOCDay3Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day3.solve_part1() == 175_615_763
  end

  test "part 2" do
    assert AOC.Day3.solve_part2() == 74_361_272
  end
end
