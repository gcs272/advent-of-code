def lines(forest, x, y)
    [
        (0...x).map { |cx| forest[cx][y] }.reverse,
        (x+1...forest.size).map { |cx| forest[cx][y] },
        (0...y).map { |cy| forest[x][cy] }.reverse,
        (y+1...forest[0].size).map { |cy| forest[x][cy] }
    ]
end

def visible?(forest, x, y)
    tree = forest[x][y]

    # Is there a sight line that hits the end?
    lines(forest, x, y).map { |line| line.all?(&. < tree) }.any?
end


def score(forest, x, y) : Int
    tree = forest[x][y]

    # Count the number of trees we can see
    lines(forest, x, y).map { |line|
        # If we're stopping at a tree, then we need to add 1 to the sight line
        line.take_while(&. < tree).size + (line.any?(&. >= tree) ? 1 : 0)
    }.product
end

forest = File.read_lines("input").map { |line|
    line.chars.map(&.to_i)
}

trees = (forest.size() - 2) * 2 + forest[0].size * 2
high_score = 0

(1...forest[0].size-1).each { |y|
    (1...forest.size-1).each { |x|
        trees += 1 if visible? forest, x, y
        current = score(forest, x, y)
        high_score = current if current > high_score
    }
}

puts "Part One: #{trees}"
puts "Part Two: #{high_score}"
