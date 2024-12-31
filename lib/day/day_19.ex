defmodule AOC.Day19 do
  def solve_part1(input \\ nil) do
    {_words, combos, trie} =
      parse(input)

    Enum.map(combos, fn combo ->
      num_valid_string_combos(trie, combo, %{})
    end)
    |> Enum.filter(fn {ct, _} -> ct > 0 end)
    |> length()
  end

  def solve_part2(input \\ nil) do
    {_words, combos, trie} = parse(input)

    Enum.map(combos, fn combo ->
      num_valid_string_combos(trie, combo, %{})
    end)
    |> Enum.filter(fn {ct, _} -> ct > 0 end)
    |> Enum.map(fn {ct, _} -> ct end)
    |> Enum.sum()
  end

  def solve_part2_memo_server(input \\ nil) do
    {_words, combos, trie} = parse(input)

    MemoServer.start_link()

    Enum.map(combos, fn combo ->
      num_valid_string_combos_memo_server(trie, combo)
    end)
    |> Enum.filter(&(&1 > 0))
    |> Enum.sum()
  end

  defp num_valid_string_combos_memo_server(_trie, "") do
    1
  end

  defp num_valid_string_combos_memo_server(trie, word) do
    case MemoServer.get(word) do
      nil ->
        matches = word_starts_with_trie_member(trie, word)

        result =
          if length(matches) > 0 do
            matches
            |> Enum.reduce(0, fn {end_index, _}, acc ->
              num_child =
                num_valid_string_combos_memo_server(
                  trie,
                  String.slice(word, end_index..String.length(word))
                )

              acc + num_child
            end)
          else
            0
          end

        MemoServer.put(word, result)
        result

      matches ->
        matches
    end
  end

  defp num_valid_string_combos(_trie, "", memo) do
    {1, memo}
  end

  defp num_valid_string_combos(trie, word, memo) do
    case memo[word] do
      nil ->
        matches = word_starts_with_trie_member(trie, word)

        {ct, new_memo} =
          if length(matches) > 0 do
            matches
            |> Enum.reduce({0, memo}, fn {end_index, _}, {acc, memo} ->
              {num_child, memo} =
                num_valid_string_combos(
                  trie,
                  String.slice(word, end_index..String.length(word)),
                  memo
                )

              {acc + num_child, memo}
            end)
          else
            {0, memo}
          end

        new_memo = Map.put(new_memo, word, ct)
        {ct, new_memo}

      matches ->
        {matches, memo}
    end
  end

  defp word_starts_with_trie_member(trie, word) do
    word_starts_with_trie_member(trie, word, 1, [])
  end

  defp word_starts_with_trie_member(trie, word, end_index, out) do
    {slice, _} = StringUtils.extract_slice(word, end_index)
    is_word = Trie.find(trie, slice)

    cond do
      end_index > trie.max_word_length or end_index > String.length(word) ->
        out

      is_word ->
        new_out = [{end_index, slice} | out]
        word_starts_with_trie_member(trie, word, end_index + 1, new_out)

      true ->
        word_starts_with_trie_member(trie, word, end_index + 1, out)
    end
  end

  defp parse(input) do
    AOC.get_input(19, input)
    |> String.split("\n\n", trim: true)
    |> then(fn [words, combos] ->
      words = String.split(words, ", ", trim: true)
      combos = String.split(combos, "\n", trim: true)
      {words, combos}
    end)
    |> then(fn {words, combos} ->
      max_word_length = Enum.map(words, fn word -> String.length(word) end) |> Enum.max()
      trie = Enum.reduce(words, %Trie{}, fn word, acc -> Trie.insert(acc, word) end)
      trie = %Trie{trie | max_word_length: max_word_length}
      {words, combos, trie}
    end)
  end
end
