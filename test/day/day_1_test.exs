defmodule AOCDay1Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day1.solve_part1() == 1_506_483
  end

  test "part 2" do
    assert AOC.Day1.solve_part2() == 23_126_924
  end
end
