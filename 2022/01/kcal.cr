vals = File.read("input").split("\n\n").map { |batch|
    batch.split().map { |line| line.to_i64 }.sum
}

puts "Part One: #{vals.max}"
puts "Part Two: #{vals.sort[-3..].sum}"
