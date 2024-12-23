defmodule AOCDay17Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day17.solve_part1() == "3,1,4,3,1,7,1,6,3"
  end

  # test "part 2" do
  #   assert AOC.Day17.solve_part2() == 0
  # end
end
