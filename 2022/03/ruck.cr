def priority(c)
    c > 96 ? c - 96 : c - 65 + 27
end

lines = File.read_lines("input")

common = lines.map { |line|
    (line[0...line.size//2].to_slice.to_set & line[line.size//2..].to_slice.to_set).to_a[0].to_u!
}
puts "Part One: #{common.map {|c| priority(c) }.sum}"

groups = lines.map { |line| line.to_slice.to_set }.in_groups_of 3
badges = groups.map { |group| group.compact }.map { |group| (group[0] & group[1] & group[2]).to_a[0].to_u! }
puts "Part Two: #{badges.map {|c| priority(c) }.sum}"
