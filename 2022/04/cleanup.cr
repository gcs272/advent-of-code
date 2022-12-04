assignments = File.read_lines("input").map { |line|
    line.split(",").map { |rec|
        a, b = rec.split("-")
        (a.to_i..b.to_i).to_set
    }
}

complete = assignments.count { |a|
    x, y = a
    (x | y).size == [x.size, y.size].max
}

puts "Part One: #{complete}"

partial = assignments.count { |a|
    x, y = a
    (x & y).size > 0
}

puts "Part Two: #{partial}"
