x = 1

instructions = File.read_lines("input").map { |line|
    parts = line.split
    parts[0] == "addx" ? parts[1].to_i : 0
}

picture = Array(Int32).new
instructions.each { |inst|
    picture.push(x)
    if inst != 0
        picture.push(x)
        x += inst
    end
}

indexes = [20] + (21..picture.size).select { |i| (i - 20) % 40 == 0 }
puts "Part One: #{indexes.map { |i| picture[i-1] * i }.sum}"

puts "Part Two:"
picture.map_with_index { |x, i|
    ((i % 40) - x).abs < 2 ? 'X' : '.'
}.in_groups_of(40).each { |line|
    puts "#{line.join}"
}
