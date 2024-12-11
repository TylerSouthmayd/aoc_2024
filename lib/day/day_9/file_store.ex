defmodule FileStore do
  defstruct [
    :id,
    :capacity,
    :list
  ]

  def new(id, capacity, list \\ []) do
    %FileStore{
      id: id,
      capacity: capacity,
      list: list
    }
  end

  def transfer_until_capacity(target_store, source_store) do
    if length(target_store.list) == target_store.capacity or length(source_store.list) == 0 do
      {target_store, source_store}
    else
      transfer_until_capacity(
        %{target_store | list: target_store.list ++ [hd(source_store.list)]},
        %{source_store | list: tl(source_store.list)}
      )
    end
  end

  def pad_to_capacity(store, val \\ 0) do
    if length(store.list) < store.capacity,
      do: store.list ++ List.duplicate(val, store.capacity - length(store.list)),
      else: store.list
  end

  def fits?(target_store, source_store) do
    target_store.capacity - length(target_store.list) >= length(source_store.list)
  end

  def print(store) do
    Map.values(store)
    |> Enum.sort_by(& &1.id)
    |> Enum.map(&FileStore.pad_to_capacity(&1, "."))
    |> List.flatten()
    |> Enum.join()
    |> IO.inspect(label: "File Store")

    store
  end
end
