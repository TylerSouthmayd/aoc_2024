defmodule Trie do
  defstruct children: %{}, is_word: false, max_word_length: 0

  def insert(trie, word) do
    new_trie = insertp(trie, word)
    %Trie{new_trie | max_word_length: max(new_trie.max_word_length, String.length(word))}
  end

  defp insertp(trie, <<>>) do
    %Trie{trie | is_word: true}
  end

  defp insertp(%Trie{children: children} = trie, <<char::binary-size(1)>> <> rest) do
    child = Map.get(children, char, %Trie{})
    updated_child = insert(child, rest)
    %Trie{trie | children: Map.put(children, char, updated_child)}
  end

  def find(trie, key) do
    findp(trie, String.graphemes(key))
  end

  defp findp(%Trie{is_word: is_word}, []) do
    is_word
  end

  defp findp(%Trie{children: children}, [char | rest]) do
    child = Map.get(children, char, %Trie{})
    findp(child, rest)
  end
end
