#!/usr/bin/env python3
from typing import List


def one(crabs: List[int]) -> int:
    median = sorted(crabs)[len(crabs) // 2]
    return sum([abs(median - c) for c in crabs])


def cost(x: int) -> int:
    return sum(range(x + 1))


def fuel(crabs: List[int], target: int) -> int:
    return sum([cost(abs(c - target)) for c in crabs])


def two(crabs: List[int]) -> int:
    target = 0
    least = fuel(crabs, 0)

    while True:
        curr = fuel(crabs, target + 1)
        if curr > least:
            return least
        least = curr
        target += 1


assert cost(1) == 1
assert cost(2) == 3
assert cost(3) == 6
assert fuel([0,1,2], 1) == 1 + 1
assert fuel([0,1,2], 2) == 3 + 1
assert fuel([16, 1, 2, 0, 4, 2, 7, 1, 2, 14], 5) == 168

crabs = [int(n) for n in open('input').read().split(',')]
print(f'one={one(crabs)}')
print(f'two={two(crabs)}')
