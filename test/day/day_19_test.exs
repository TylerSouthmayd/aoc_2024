defmodule AOCDay19Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day19.solve_part1() == 251
  end

  test "part 2" do
    assert AOC.Day19.solve_part2() == 616_957_151_871_345
  end

  test "part 2 memo server" do
    assert AOC.Day19.solve_part2_memo_server() == 616_957_151_871_345
  end
end
