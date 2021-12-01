function done(hands)
  for hand in hands
    if length(hand) <= 0
      return true
    end
  end
  return false
end

blocks = split(join(readlines(), "\n"), "\n\n")
hands = []

for blk in blocks
  push!(hands, map(x -> parse(Int, x), split(split(blk, ":\n")[2], "\n")))
end

while !done(hands)
  a = popfirst!(hands[1])
  b = popfirst!(hands[2])

  if a > b
    push!(hands[1], a, b)
  else
    push!(hands[2], b, a)
  end
end

winner = (length(hands[1]) > length(hands[2])) ? hands[1] : hands[2]
winner = reverse(winner)
score = foldl((acc, x) -> acc + (x * winner[x]), vcat(0, eachindex(winner)))
print(score)
