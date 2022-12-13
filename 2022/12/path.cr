struct Point
    property x, y

    def initialize(@x : Int32, @y : Int32)
    end
end

def paths(grid : Array(Array(Char)), start : Point) : (Int32|Nil)
    search = [{start, 0}]
    seen = Set(Point).new

    while !search.empty?
        head, depth = search.shift
        if !seen.includes? head
            seen.add head

            hval = grid[head.@y][head.@x] == 'S' ? 'a' : grid[head.@y][head.@x]

            candidates = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}].map { |dx, dy|
                nx, ny = head.@x + dx, head.@y + dy

                candidate = Point.new(nx, ny)
                in_bounds = ny >= 0 && ny < grid.size && nx >= 0 && nx < grid[0].size

                if in_bounds && !seen.includes?(candidate)
                    cval = grid[ny][nx] == 'E' ? 'z' : grid[ny][nx]
                    (cval - hval) <= 1 ? candidate : nil
                end
            }.compact.each { |candidate|
                if grid[candidate.@y][candidate.@x] == 'E'
                    return depth + 1
                end
                search << {candidate, depth + 1}
            }
        end
    end
end

start = Point.new(0, 0)

grid = File.read_lines("input").map(&.chars)
grid.each_with_index { |row, y|
    row.each_with_index { |val, x|
        if val == 'S'
            start = Point.new(x, y)
            break
        end
    }
}

puts "Part One: #{paths(grid, start)}"

shortest = grid.map_with_index { |row, y|
    row.map_with_index { |val, x|
        val == 'a' ? Point.new(x, y) : nil
    }
}.flatten.compact.map { |start|
    paths(grid, start)
}.compact.min

puts "Part Two: #{shortest}"
