defmodule CPU do
  defstruct [:a, :b, :c, :pointer, :output]

  def print_cpu(%CPU{a: a, b: b, c: c, output: output} = cpu) do
    IO.puts("Register A: #{a}")
    IO.puts("Register B: #{b}")
    IO.puts("Register C: #{c}")
    IO.inspect(Enum.reverse(output))
    cpu
  end

  def tick(%CPU{a: a, pointer: pointer} = cpu, :adv, operand) do
    %{cpu | a: floor(a / :math.pow(2, combo_operand(cpu, operand))), pointer: pointer + 1}
  end

  def tick(%CPU{b: b, pointer: pointer} = cpu, :bxl, operand) do
    %{cpu | b: Bitwise.bxor(b, operand), pointer: pointer + 1}
  end

  def tick(%CPU{pointer: pointer} = cpu, :bst, operand) do
    %{cpu | b: rem(combo_operand(cpu, operand), 8), pointer: pointer + 1}
  end

  def tick(%CPU{a: a, pointer: pointer} = cpu, :jnz, operand) do
    if a == 0 do
      %{cpu | pointer: pointer + 1}
    else
      %{cpu | pointer: div(operand, 2)}
    end
  end

  def tick(%CPU{b: b, c: c, pointer: pointer} = cpu, :bxc, _operand) do
    %{cpu | b: Bitwise.bxor(b, c), pointer: pointer + 1}
  end

  def tick(%CPU{pointer: pointer, output: output} = cpu, :out, operand) do
    %{cpu | pointer: pointer + 1, output: [rem(combo_operand(cpu, operand), 8) | output]}
  end

  def tick(%CPU{a: a, pointer: pointer} = cpu, :bdv, operand) do
    %{cpu | b: floor(a / :math.pow(2, combo_operand(cpu, operand))), pointer: pointer + 1}
  end

  def tick(%CPU{a: a, pointer: pointer} = cpu, :cdv, operand) do
    %{cpu | c: floor(a / :math.pow(2, combo_operand(cpu, operand))), pointer: pointer + 1}
  end

  defp combo_operand(%CPU{a: a, b: b, c: c}, operand) do
    cond do
      operand in 0..3 -> operand
      operand == 4 -> a
      operand == 5 -> b
      operand == 6 -> c
      operand == 7 -> raise("should not happen")
    end
  end
end

defmodule AOC.Day17 do
  @opcode_mapping %{
    "0" => :adv,
    "1" => :bxl,
    "2" => :bst,
    "3" => :jnz,
    "4" => :bxc,
    "5" => :out,
    "6" => :bdv,
    "7" => :cdv
  }

  def solve_part1(input \\ nil) do
    {cpu, instructions} = parse(input)
    halt_pointer = map_size(instructions)

    run_cpu(cpu, instructions, halt_pointer)
    |> Enum.join(",")
  end

  defp run_cpu(%CPU{pointer: pointer, output: output} = cpu, instructions, halt) do
    if pointer >= halt do
      Enum.reverse(output)
    else
      {opcode, operand} = Map.get(instructions, pointer)

      # CPU.print_cpu(cpu)
      # IO.inspect([opcode, operand], label: "current instruction")

      CPU.tick(cpu, opcode, operand)
      |> run_cpu(instructions, halt)
    end
  end

  def solve_part2(input \\ nil) do
    parse(input)
  end

  defp parse(input) do
    [registers, program] =
      AOC.get_input(17, input)
      |> String.split("\n\n", trim: true)

    [a, b, c] =
      Enum.map(String.split(registers, "\n"), fn register ->
        [_, v] = String.split(register, ": ")
        String.to_integer(v)
      end)

    [_, instructions] =
      String.split(program, ": ")

    instructions =
      String.split(instructions, ",")
      |> Enum.chunk_every(2)
      |> Enum.with_index()
      |> Enum.map(fn {[opcode, operand], index} ->
        {index, {@opcode_mapping[opcode], String.to_integer(operand)}}
      end)
      |> Enum.into(%{})

    {%CPU{a: a, b: b, c: c, pointer: 0, output: []}, instructions}
  end
end
