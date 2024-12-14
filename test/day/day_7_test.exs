defmodule AOCDay7Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day7.solve_part1() == 66_343_330_034_722
  end

  test "part 2" do
    input = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    assert AOC.Day7.solve_part2(input) == 11387
  end
end
