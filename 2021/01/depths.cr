vals = File.read_lines("input").map { |l| l.to_i64 }
dayone = (1..vals.size()-1).map { |i| vals[i] > vals[i-1] ? 1 : 0 }.sum
daytwo = (3..vals.size()-1).map { |i| vals[i] > vals[i-3] ? 1 : 0}.sum
puts "one=#{dayone} two=#{daytwo}"
