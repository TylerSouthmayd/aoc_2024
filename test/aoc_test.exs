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

  # test "day 5 part 1" do
  #   assert AOC.Day5.solve_part1() == 2554
  # end

  # test "day 5 part 2" do
  #   assert AOC.Day5.solve_part2() == 1916
  # end
end
