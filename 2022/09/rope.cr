def apply(instructions, knots)
    head = [0, 0]
    path = Set.new [[0, 0]]
    instructions.each { |direction, steps|
        steps.times {
            case direction
            when "R"
                head[1] += 1
            when "U"
                head[0] += 1
            when "D"
                head[0] -= 1
            else
                head[1] -= 1
            end

            knot = head
            knots.each_with_index { |tail, i|
                dx = knot[0] - tail[0]
                dy = knot[1] - tail[1]

                # If any direction has a gap, move
                if dx.abs > 1 || dy.abs > 1
                    if dx.abs > 0
                        tail[0] += dx > 0 ? 1 : -1
                    end

                    if dy.abs > 0
                        tail[1] += dy > 0 ? 1 : -1
                    end
                end

                path.add(tail.clone) if i == knots.size - 1
                knot = tail
            }
        }
    }
    path
end

instructions = File.read_lines("input").map { |line|
    parts = line.split
    {parts[0], parts[1].to_i}
}

puts "Part One: #{apply(instructions, [[0, 0]]).size}"
puts "Part Two: #{apply(instructions, (0...9).map { [0, 0] }).size}"
