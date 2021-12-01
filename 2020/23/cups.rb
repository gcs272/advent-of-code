require 'pry'

#input='389125467'
input='952316487'
cups = input.split('').map { |i| Integer i }

current = 0
(0...100).each do |i|
  pulled = []
  cval = cups[current]

  # grab the next three items, then remove them from the cups array
  (1..3).each { |n| pulled.append cups[(current + n) % cups.length] }
  pulled.each { |n| cups.delete(n) }

  target = cups.select { |c| c < cval } .max || cups.max
  cups.insert(cups.find_index(target) + 1, *pulled)
  current = (cups.find_index(cval) + 1) % cups.length
end

idx = cups.find_index 1
puts cups.slice(idx + 1, cups.length).concat(cups.slice(0, idx)).join('')
