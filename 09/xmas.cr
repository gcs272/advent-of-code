def invalid?(current, prior)
  !prior.any? { |i| (current - i).in?(prior) }
end

# part one
vals = File.read_lines("input").map { |x| x.to_i64 }
idx = (25..vals.size).find { |i| invalid?(vals[i], vals[i-25..i]) }
target = vals[idx.as(Int)]
puts target

# part two
def find_run(target, vals)
  (25..vals.size).each do |i|
    current = i
    run = [vals[current]]
    while true
      if run.sum() == target
        return run.min() + run.max()
      elsif run.sum() > target
        break
      end

      current += 1
      run << vals[current]
    end
  end
end

puts find_run(target, vals)
