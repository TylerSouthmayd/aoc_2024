defmodule AOCTest do
  use ExUnit.Case
  doctest AOC

  test "day 1 part 1" do
    assert AOC.Day1.solve_part1() == 1_506_483
  end

  test "day 1 part 2" do
    assert AOC.Day1.solve_part2() == 23_126_924
  end

  test "day 2 part 1" do
    assert AOC.Day2.solve_part1() == 670
  end

  test "day 2 part 2" do
    assert AOC.Day2.solve_part2() == 700
  end

  test "day 3 part 1" do
    assert AOC.Day3.solve_part1() == 175_615_763
  end

  test "day 3 part 2" do
    assert AOC.Day3.solve_part2() == 74_361_272
  end

  test "day 4 part 1" do
    assert AOC.Day4.solve_part1() == 2554
  end

  test "day 4 part 2" do
    assert AOC.Day4.solve_part2() == 1916
  end

  test "day 5 part 1" do
    assert AOC.Day5.solve_part1() == 4905
  end

  test "day 5 part 2" do
    assert AOC.Day5.solve_part2() == 6204
  end

  test "day 6 part 1" do
    assert AOC.Day6.solve_part1() == 4973
  end

  test "day 6 part 2" do
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

  test "day 7 part 1" do
    assert AOC.Day7.solve_part1() == 66_343_330_034_722
  end

  test "day 7 part 2" do
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

  test "day 8 part 1" do
    assert AOC.Day8.solve_part1() == 409
  end

  test "day 8 part 2" do
    assert AOC.Day8.solve_part2() == 1308
  end

  test "day 9 part 1" do
    assert AOC.Day9.Part1.solve() == 6_241_633_730_082
  end

  test "day 9 part 2" do
    assert AOC.Day9.Part2.solve("2333133121414131402") == 2858
    assert AOC.Day9.Part2.solve("111000000000000000001") == 12
    assert AOC.Day9.Part2.solve("01012") == 10
    assert AOC.Day9.Part2.solve("252") == 5
    assert AOC.Day9.Part2.solve("171010402") == 88
    assert AOC.Day9.Part2.solve("354631466260") == 1325
    assert AOC.Day9.Part2.solve("1010101010101010101010") == 385
    assert AOC.Day9.Part2.solve("14113") == 16
    assert AOC.Day9.Part2.solve("2333133121414131401") == 2746
    # assert AOC.Day9.Part2.solve() == 6_265_268_809_555
  end

  test "day 10 part 1" do
    assert AOC.Day10.solve_part1() == 682
  end

  test "day 10 part 2" do
    assert AOC.Day10.solve_part2() == 1511
  end
end
