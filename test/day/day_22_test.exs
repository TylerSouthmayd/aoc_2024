defmodule AOCDay22Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day22.solve_part1() == 19_458_130_434
  end

  test "part 2" do
    assert AOC.Day22.solve_part2("""
           1
           2
           3
           2024
           """) == {[-2, 1, -1, 3], 23}

    # ~10 seconds
    # assert AOC.Day22.solve_part2() == {[3, -3, 0, 4], 2130}
  end
end
