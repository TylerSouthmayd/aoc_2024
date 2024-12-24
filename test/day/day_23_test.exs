defmodule AOCDay23Test do
  use ExUnit.Case
  doctest AOC

  test "part 1" do
    assert AOC.Day23.solve_part1() == 1323
  end

  test "part 2" do
    assert AOC.Day23.solve_part2("""
           kh-tc
           qp-kh
           de-cg
           ka-co
           yn-aq
           qp-ub
           cg-tb
           vc-aq
           tb-ka
           wh-tc
           yn-cg
           kh-ub
           ta-co
           de-co
           tc-td
           tb-wq
           wh-td
           ta-ka
           td-qp
           aq-cg
           wq-ub
           ub-vc
           de-ta
           wq-aq
           wq-vc
           wh-yn
           ka-de
           kh-ta
           co-tc
           wh-qp
           tb-vc
           td-yn
           """) == "co,de,ka,ta"

    # AOC.Day23.solve_part2() == "er,fh,fi,ir,kk,lo,lp,qi,ti,vb,xf,ys,yu"
  end
end
