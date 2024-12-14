defmodule AOCDay13Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day13.solve_part1() == 33921
  end

  test "part 2" do
    assert AOC.Day13.solve_part2() == 82_261_957_837_868
  end
end
