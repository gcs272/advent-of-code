vals = File.read_lines("input").map { |l| l.to_i64 }
dayone = (1..vals.size()-1).reduce(0) { |acc, i| vals[i] > vals[i-1] ? acc + 1 : acc }
daytwo = (3..vals.size()-1).reduce(0) { |acc, i| vals[i] > vals[i-3] ? acc + 1 : acc }
puts "one=#{dayone} two=#{daytwo}"
