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

    case Enum.any?(path, fn(p) -> p == next end) do
      true -> acc
      false -> run(next, acc, path ++ [pos], program)
    end
  end

end

IO.puts(VM.run(0, 0, [], VM.readProgram("sample")))
