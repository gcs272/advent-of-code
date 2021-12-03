def to_int(s)
  s.reverse.map_with_index { |v, i| v == 1 ? 2 ** i : 0 }.sum()
end

def one(readings)
  width = readings[0].size()

  # Grab the sum totals for each column
  totals = readings.reduce([0] * width) { |acc, line|
    (0...width).map { |i| acc[i] + (line[i] == 1 ? 1 : -1) }
  }

  gamma = to_int totals.map{ |v| v > 0 ? 1 : 0 }
  epsilon = to_int totals.map{ |v| v <= 0 ? 1 : 0 }
  return gamma * epsilon
end

def totals(vals, idx)
  vals.reduce(0) { | acc, v | acc + (v[idx] == 1 ? 1 : -1) }
end

def filter_o2(vals, idx)
  sum = totals(vals, idx)
  vals.select { |v| sum >= 0 ? v[idx] == 1 : v[idx] == 0 }
end

def filter_co2(vals, idx)
  sum = totals(vals, idx)
  vals.select { |v| sum >= 0 ? v[idx] == 0 : v[idx] == 1 }
end

def two(readings)
  width = readings[0].size()

  o2 = 0
  o2readings = readings
  (0..width).each { |i|
    o2readings = filter_o2(o2readings, i)
    if o2readings.size() <= 1
      o2 = to_int(o2readings[0])
      break
    end
  }

  co2 = 0
  co2readings = readings
  (0..width).each { |i|
    co2readings = filter_co2(co2readings, i)
    if co2readings.size() <= 1
      co2 = to_int(co2readings[0])
      break
    end
  }

  return o2 * co2
end

readings = File.read_lines("input").map { |line|
  line.split("").map { |bit| bit == "1" ? 1 : 0 }
}

puts "one=#{one(readings)}\ntwo=#{two(readings)}"
