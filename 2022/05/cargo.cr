inventory, instructions = File.read("input").split("\n\n")

# inventory is a bunch of crates, then a line of labels
inv = inventory.split("\n")
labels = inv[-1].split().map &.[0]

# Start loading from the bottom
stacks = Hash(Char, Array(Char)).new
inv[...-1].reverse().each { |line|
    idx = 0
    labels.each { |label|
        stacks[label] = Array(Char).new if !stacks.has_key? label
        if line[idx + 1] != ' '
            stacks[label] << line.char_at(idx + 1)
        end
        idx += 4
    }
}

# Read and execute instructions
two = stacks.clone
instructions.strip().split("\n").each { |line|
    parts = line.split()
    amount, from, to = parts[1].to_i, parts[3][0], parts[5][0]

    # Part one
    amount.times {
        stacks[to].push stacks[from].pop
    }

    # Part two
    two[to] += two[from][-amount..]
    two[from] = two[from][...-amount]
}

# Pop all the stacks
puts "Part One: #{labels.map { |l| stacks[l].pop }.join}"
puts "Part Two: #{labels.map { |l| two[l].pop }.join}"
