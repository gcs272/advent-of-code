struct Finfo
    property name, size

    def initialize(@name : String, @size : UInt32)
    end
end

struct Directory
    property files, directories

    def initialize(@files : Array(Finfo), @directories : Hash(String, Directory))
    end
end

def getwd(root : Directory, pwd : Array(String)) : Directory
    curr = root
    pwd.each { |dir| curr = curr.directories[dir] }

    curr
end

# Read the current structure
root = Directory.new(Array(Finfo).new, Hash(String, Directory).new)
pwd = Array(String).new

File.read_lines("input").each { |line|
    case
    when line[0] == '$'
        # We only care about switching directories
        if line[0...4] == "$ cd"
            path = line.split.pop
            case path
            when "/"
                pwd = Array(String).new
            when ".."
                pwd.pop
            else
                pwd.push path
            end
        end

    when line[0...3] == "dir"
        path = line.split.pop
        wd = getwd(root, pwd)
        wd.directories[path] = Directory.new(Array(Finfo).new, Hash(String, Directory).new)
    else
        size, name = line.split
        wd = getwd(root, pwd)
        wd.files.push Finfo.new(name, size.to_u32)
    end
}

# Grab all the directories over a certain total size
def du(root : Directory) : UInt32
    root.files.map { |f| f.size }.sum + root.directories.map { |_, d| du(d) }.sum
end

candidates = [root]
sizes = Array(UInt32).new
while !candidates.empty?
    candidate = candidates.shift
    candidate.directories.each { |_, dir| candidates.push(dir) }
    sizes.push du(candidate)
end

puts "Part One: #{sizes.select { |s| s < 100_000 }.sum}"

needed = 30_000_000 - (70_000_000 - du(root))
puts "Part Two: #{sizes.sort.find(&. > needed)}"
