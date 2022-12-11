class Monkey
    def initialize(blob : String)
        @id = 0
        @items = Array(UInt64).new
        @test = 1
        @targets = [0, 0]
        @operation = Proc(UInt64, UInt64).new { |x| x }
        @throws = 0.to_u64

        blob.split("\n").map(&.strip).each { |line|
            case line
            when .starts_with? "Monkey "
                @id = line[...-1].split[1].to_i
            when .starts_with? "Starting "
                @items = line.split(": ")[1].split(", ").map(&.to_u64)
            when .starts_with? "Operation: "
                op, val = line.split("= old ")[1].split
                case op
                when "*"
                    @operation = Proc(UInt64, UInt64).new {|x| x * (val == "old" ? x : val.to_u64)}
                else
                    @operation = Proc(UInt64, UInt64).new {|x| x + (val == "old" ? x : val.to_u64)}
                end
            when .starts_with? "Test: divisible"
                @test = line.split()[-1].to_i
            when .starts_with? "If true:"
                @targets[0] = line.split()[-1].to_i
            when .starts_with? "If false:"
                @targets[1] = line.split()[-1].to_i
            end
        }
    end

    def toss(div, lcm) : Array(NamedTuple(target: Int32, worry: UInt64))
        tosses = @items.map { |worry|
            @throws += 1
            worry = @operation.call(worry) // (div ? 3 : 1)
            worry = worry % lcm
            {target: @targets[worry % @test == 0 ? 0 : 1], worry: worry}
        }
        @items = Array(UInt64).new
        tosses
    end
end

def load
    File.read("input").split("\n\n").map { |line|
        Monkey.new line
    }.map { |m|
        {m.@id, m}
    }.to_h
end

monkeys = load()
lcm = monkeys.map { |_, m| m.@test }.product.to_u64

20.times {
    monkeys.each { |id, monkey|
        monkey.toss(true, lcm).each { |throw|
            monkeys[throw[:target]].@items.push throw[:worry]
        }
    }
}

puts "Part One: #{monkeys.map { |_, m| m.@throws }.sort[-2..].product}"

second = load()
10_000.times {
    second.each { |id, monkey|
        monkey.toss(false, lcm).each { |throw|
            second[throw[:target]].@items.push throw[:worry]
        }
    }
}

puts "Part Two: #{second.map { |_, m| m.@throws }.sort[-2..].product}"
