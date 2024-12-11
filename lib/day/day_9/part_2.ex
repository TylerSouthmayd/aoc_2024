defmodule AOC.Day9.Part2 do
  def solve(input \\ nil) do
    storage =
      AOC.Day9.parse(input)

    (map_size(storage) - 1)..0
    |> Enum.reduce(storage, &move_blocks(&2, 0, &1))
    |> Map.values()
    |> Enum.sort_by(& &1.id)
    |> Enum.map(&FileStore.pad_to_capacity/1)
    |> List.flatten()
    |> AOC.Day9.checksum()
  end

  defp move_blocks(content, head_position, tail_position)
       when head_position >= tail_position do
    content
  end

  defp move_blocks(content, head_position, tail_position) do
    head_file = Map.get(content, head_position)
    tail_file = Map.get(content, tail_position)

    {own_blocks, transferred_blocks} =
      split_identity_list(tail_file)

    if FileStore.fits?(head_file, own_blocks) do
      {new_head_file, _} = FileStore.transfer_until_capacity(head_file, own_blocks)
      content = Map.put(content, head_position, new_head_file)

      transfer_size = length(own_blocks.list)
      prev_file = Map.get(content, tail_position - 1)
      new_prev_file = %{prev_file | capacity: prev_file.capacity + transfer_size}

      Map.put(content, tail_position - 1, new_prev_file)
      |> Map.put(tail_position, transferred_blocks)
    else
      move_blocks(content, head_position + 1, tail_position)
    end
  end

  defp split_identity_list(store) do
    {owned, from_transfer} = Enum.split_with(store.list, fn id -> id == store.id end)

    {
      %{store | list: owned},
      %{store | list: from_transfer, capacity: store.capacity - length(owned)}
    }
  end
end
