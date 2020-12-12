-- read the input file and sort it
adapters = {}
for line in io.stdin:lines() do
  table.insert(adapters, tonumber(line))
end

table.sort(adapters)

-- part one
ones = 1
threes = 1

for i=1,(#adapters-1) do
  if adapters[i+1] - adapters[i] == 1 then
    ones = ones + 1
  else
    threes = threes + 1
  end
end

print(ones * threes)

-- part two
-- complete the dag
table.insert(adapters, 1, 0)
table.insert(adapters, adapters[#adapters] + 3)

-- return 1 for every path that terminates correctly
local memo = {}
function paths(position)
  if memo[position] ~= nil then
    return memo[position]
  end

  if position == #adapters then
    return 1
  end

  local lp = position + 1
  local acc = 0
  while (lp <= #adapters) and (adapters[lp] < adapters[position] + 4) do
    acc = acc + paths(lp)
    lp = lp + 1
  end

  memo[position] = acc
  return acc
end

print(paths(1))
