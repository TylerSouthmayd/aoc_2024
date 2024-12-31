defmodule StringUtils do
  def extract_slice(word, end_index) when byte_size(word) >= end_index do
    <<slice::binary-size(end_index), rest::binary>> = word
    {slice, rest}
  end

  def extract_slice(word, _end_index), do: {word, <<>>}
end
