function play(hands)
  history = []
  while all(h -> length(h) > 0, hands)
    if hands in history
      # if we'll loop, then player 1 wins, so give them both sets of cards
      hands[1] = vcat(hands[1], hands[2])
      hands[2] = []
      return hands
    else
      push!(history, deepcopy(hands))
    end

    a = popfirst!(hands[1])
    b = popfirst!(hands[2])

    # recurse if both players have hands >= the size of the card they just drew
    if a <= length(hands[1]) && b <= length(hands[2])
      results = play([hands[1][1:a], hands[2][1:b]])
      if length(results[1]) > length(results[2])
        push!(hands[1], a, b)
      else
        push!(hands[2], b, a)
      end
    else
      # normal play
      if a > b
        push!(hands[1], a, b)
      else
        push!(hands[2], b, a)
      end
    end
  end

  return hands
end

function score(hand)
  hand = reverse(hand)
  return foldl((acc, x) -> acc + (x * hand[x]), vcat(0, eachindex(hand)))
end


blocks = split(join(readlines(), "\n"), "\n\n")
hands = []

for blk in blocks
  push!(hands, map(x -> parse(Int, x), split(split(blk, ":\n")[2], "\n")))
end

hands = play(hands)
winner = (length(hands[1]) > length(hands[2])) ? hands[1] : hands[2]
print(score(winner))
