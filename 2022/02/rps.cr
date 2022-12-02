def score(round, points)
    points[round[1]] +
    case round
    when [:rock, :rock], [:paper, :paper], [:scissors, :scissors]
        3
    when [:rock, :paper], [:paper, :scissors], [:scissors, :rock]
        6
    else
        0
    end
end

points = {:rock => 1, :paper => 2, :scissors => 3}

rounds = File.read_lines("input").map { |x| x.split }
round1 = rounds.map { |round|
    round.map { |r|
        {"A" => :rock, "B" => :paper, "C" => :scissors, "X" => :rock, "Y" => :paper, "Z" => :scissors}[r]
    }
}

# Remap for round 2
round2 = round1.map { |r|
    [r[0], {:rock => :lose, :paper => :draw, :scissors => :win}[r[1]]]
}.map { |round|
    target = case round[1]
    when :lose
        {:rock => :scissors, :paper => :rock, :scissors => :paper}[round[0]]
    when :win
        {:rock => :paper, :paper => :scissors, :scissors => :rock}[round[0]]
    else
        round[0]
    end

    [round[0], target]
}

puts "Part One: #{round1.map { |r| score(r, points) }.sum}"
puts "Part Two: #{round2.map { |r| score(r, points) }.sum}"
