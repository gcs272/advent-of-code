defmodule VM do
  def readProgram(path) do
    {:ok, contents} = File.read(path)
    Enum.map(String.split(contents, "\n", trim: true), fn(line) ->
      [code, sval] = String.split(line)
      {arg, _} = Integer.parse(sval)

      {code, arg}
    end)
  end

  def run(pos, acc, path, program) do
    {code, arg} = Enum.at(program, pos)
    {acc, next} = case code do
      "nop" -> {acc, pos + 1}
      "acc" -> {acc + arg, pos + 1}
      "jmp" -> {acc, pos + arg}
    end

    if next == length(program) do
      {:ok, acc}
    else
      case Enum.any?(path, fn(p) -> p == next end) do
        true -> {:halt, acc}
        false -> run(next, acc, path ++ [pos], program)
      end
    end
  end

  # flip the index and run the program
  def check(idx, inst, program) do
    run(0, 0, [], List.replace_at(program, idx, inst))
  end

  # find a program that won't halt
  def debug(program) do
    Enum.find_value(Enum.with_index(program), fn(inidx) ->
      {{code, arg}, i} = inidx
      {result, acc} = case code do
        "nop" -> check(i, {"jmp", arg}, program)
        "jmp" -> check(i, {"nop", 0}, program)
        "acc" -> {:halt, 0}
      end

      case result do
        :ok -> {result, acc}
        _ -> false
      end
    end
    )
  end

end

# Part one
{_, acc} = VM.run(0, 0, [], VM.readProgram("input"))
IO.puts(acc)

# Part two
{:ok, acc} = VM.debug(VM.readProgram("input"))
IO.puts(acc)
