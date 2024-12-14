defmodule AOCDay9Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day9.Part1.solve() == 6_241_633_730_082
  end

  test "part 2" do
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
end
