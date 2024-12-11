defmodule AOC do
  def get_input(day, input \\ nil) do
    case input do
      nil ->
        case File.read(Path.join(["input", "day#{day}.txt"])) do
          {:ok, content} -> content
        end

      _ ->
        input
    end
  end
end
