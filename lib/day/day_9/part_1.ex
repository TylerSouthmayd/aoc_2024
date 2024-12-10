defmodule AOC.Day9.Part1 do
  def solve(input \\ nil) do
    AOC.Day9.parse(input)
    |> Map.values()
    |> Enum.sort_by(& &1.id)
    |> fill_empty_locations()
    |> Enum.map(& &1.list)
    |> List.flatten()
    |> AOC.Day9.checksum()
  end

  defp fill_empty_locations(content) do
    fill_empty_locations_from_right(content, 0, length(content) - 1)
  end

  defp fill_empty_locations_from_right(content, head_position, tail_position)
       when head_position >= tail_position do
    content
  end

  defp fill_empty_locations_from_right(content, head_position, tail_position) do
    head_file = Enum.at(content, head_position)
    tail_file = Enum.at(content, tail_position)

    {new_head_file, new_tail_file} = FileStore.transfer_until_capacity(head_file, tail_file)
    content = List.replace_at(content, head_position, new_head_file)
    content = List.replace_at(content, tail_position, new_tail_file)

    if length(new_tail_file.list) == 0 do
      fill_empty_locations_from_right(content, head_position, tail_position - 1)
    else
      fill_empty_locations_from_right(content, head_position + 1, tail_position)
    end
  end
end
