s = File.read("input").strip.chars

sop = (0..s.size-4).find! { |i| s[i..i+3].to_set.size == 4 } + 4
puts "Part One: #{sop}"

som = (0..s.size-14).find! { |i| s[i..i+13].to_set.size == 14 } + 14
puts "Part Two: #{som}"
