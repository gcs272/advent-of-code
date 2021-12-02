{:ok, content} = File.read("./input")

instructions = content
  |> String.split("\n", trim: true)
  |> Enum.map(fn (line) ->
    [op, valstr] = String.split(line, " ", trim: true)
    {val, _} = Integer.parse(valstr)
    {op, val}
  end)

{depth, dist} = Enum.reduce(instructions, {0, 0}, fn ({op, val}, {depth, dist}) ->
  case op do
    "forward" -> {depth, dist + val}
    "down" -> {depth + val, dist}
    "up" -> {depth - val, dist}
  end
end)

IO.puts("one=#{depth * dist}")

{depth, dist, _} = Enum.reduce(instructions, {0, 0, 0}, fn({op, val}, {depth, dist, aim}) ->
  case op do
    "forward" -> {depth + (aim * val), dist + val, aim}
    "down" -> {depth, dist, aim + val}
    "up" -> {depth, dist, aim - val}
  end
end)

IO.puts("two=#{depth * dist}")
