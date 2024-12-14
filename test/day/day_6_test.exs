defmodule AOCDay6Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day6.solve_part1() == 4973
  end

  test "part 2" do
    input = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    assert AOC.Day6.solve_part2(input) == 6
    # assert AOC.Day6.solve_part1() == 1482
  end
end
