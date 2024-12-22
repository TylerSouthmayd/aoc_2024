ExUnit.start()

defmodule Day15Tests do
  use ExUnit.Case

  test "part 1" do
    assert AOC.Day15.Part1.solve() == 1_412_971
  end

  test "solve example 1" do
    assert AOC.Day15.Part2.solve("""
           #######
           #.....#
           #.....#
           #.@O..#
           #..#O.#
           #...O.#
           #..O..#
           #.....#
           #######

           >><vvv>v>^^^
           """) == 1430
  end

  test "solve example 2" do
    assert AOC.Day15.Part2.solve("""
           #####
           #O..#
           #..@#
           #...#
           #...#
           #...#
           #####

           <
           """) == 102
  end

  test "solve example 3" do
    assert AOC.Day15.Part2.solve("""
           #####
           #...#
           #.O@#
           #OO.#
           ##O.#
           #...#
           #####

           <^<<v
           """) == 1213
  end

  test "solve example 4" do
    assert AOC.Day15.Part2.solve("""
           #####
           #...#
           #.O@#
           #OO.#
           #O#.#
           #...#
           #####

           <^<<v
           """) == 1211
  end

  test "solve example 5" do
    assert AOC.Day15.Part2.solve("""
           #######
           #.....#
           #.O#..#
           #..O@.#
           #.....#
           #######

           <v<<^
           """) == 509
  end

  test "solve example 6" do
    assert AOC.Day15.Part2.solve("""
           #######
           #.....#
           #.OO@.#
           #.....#
           #######

           <<
           """) == 406
  end

  test "solve example 7" do
    assert AOC.Day15.Part2.solve("""
           #######
           #.....#
           #.#O..#
           #..O@.#
           #.....#
           #######

           <v<^
           """) == 511
  end

  test "solve example 8" do
    assert AOC.Day15.Part2.solve("""
           ######
           #....#
           #.O..#
           #.OO@#
           #.O..#
           #....#
           ######

           <vv<<^
           """) == 816
  end

  test "solve example 9" do
    assert AOC.Day15.Part2.solve("""
           #######
           #.....#
           #.O.O@#
           #..O..#
           #..O..#
           #.....#
           #######

           <v<<>vv<^^
           """) == 822
  end

  test "solve example 10" do
    assert AOC.Day15.Part2.solve("""
           ######
           #....#
           #..#.#
           #....#
           #.O..#
           #.OO@#
           #.O..#
           #....#
           ######

           <vv<<^^^
           """) == 1216
  end

  # test "solve real input" do
  #   assert AOC.Day15.Part2.solve() == 1_429_299
  # end
end
