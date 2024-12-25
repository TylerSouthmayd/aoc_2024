defmodule AOC.Day22 do
  def solve_part1(input \\ nil) do
    content = parse(input)

    Enum.reduce(1..2000, content, fn _, acc ->
      Enum.map(acc, fn secret ->
        recompute_secret_number(secret)
      end)
    end)
    |> Enum.sum()
  end

  def solve_part2(input \\ nil) do
    parse(input)
    |> Enum.map(fn secret ->
      Enum.reduce(1..2000, {secret, []}, fn _, {secret, diffs} ->
        expand_diffs(secret, diffs)
      end)
    end)
    |> Enum.map(fn {_, diffs} ->
      Enum.reverse(diffs)
      |> Enum.chunk_every(4, 1, :discard)
      |> Enum.reduce(%{}, fn chunk, acc ->
        chunk_sequence = value_diff_pairs_to_sequence(chunk)

        if Map.has_key?(acc, chunk_sequence) do
          acc
        else
          price = elem(List.last(chunk), 0)
          Map.put(acc, chunk_sequence, price)
        end
      end)
    end)
    |> calculate_windows()
    |> Enum.max_by(fn {_, value} -> value end)
  end

  defp calculate_windows(diff_sets) do
    sequences = %{}

    all_sequences =
      Enum.reduce(diff_sets, MapSet.new(), fn diff_set, acc ->
        Map.keys(diff_set) |> MapSet.new() |> MapSet.union(acc)
      end)
      |> MapSet.to_list()

    Enum.reduce(all_sequences, sequences, fn sequence, acc ->
      if Map.has_key?(acc, sequence) do
        acc
      else
        Map.put(acc, sequence, test_sequences(sequence, diff_sets))
      end
    end)
  end

  defp value_diff_pairs_to_sequence(pairs) do
    Enum.map(pairs, fn {_, diff} -> diff end)
  end

  defp test_sequences(sequence, diff_sets) do
    Enum.reduce(diff_sets, 0, fn diff_set, acc ->
      acc + Map.get(diff_set, sequence, 0)
    end)
  end

  defp expand_diffs(secret, []), do: expand_diffs(secret, [{ones_digit(secret), 0}])

  defp expand_diffs(secret, diffs) do
    new_secret = recompute_secret_number(secret)
    {new_secret, [{ones_digit(new_secret), ones_digit(new_secret) - ones_digit(secret)} | diffs]}
  end

  defp ones_digit(number), do: rem(number, 10)

  defp recompute_secret_number(secret) do
    first = (secret * 64) |> mix(secret) |> prune()
    second = (first / 32) |> floor() |> mix(first) |> prune()
    (second * 2048) |> mix(second) |> prune()
  end

  defp mix(new, old), do: Bitwise.bxor(new, old)
  defp prune(secret), do: rem(secret, 16_777_216)

  defp parse(input) do
    AOC.get_input(22, input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
