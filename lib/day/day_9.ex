defmodule AOC.Day9 do
  def checksum(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(0, fn {value, index}, acc -> acc + index * value end)
  end

  def parse(input) do
    content =
      case input do
        nil ->
          case File.read(Path.join(["input", "day9.txt"])) do
            {:ok, content} -> content
          end

        _ ->
          input
      end

    content
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.map(fn {pair, id} ->
      case pair do
        [block_count, free_space] ->
          {id, FileStore.new(id, block_count + free_space, List.duplicate(id, block_count))}

        [block_count] ->
          {id, FileStore.new(id, block_count, List.duplicate(id, block_count))}
      end
    end)
    |> Enum.into(%{})
  end
end
