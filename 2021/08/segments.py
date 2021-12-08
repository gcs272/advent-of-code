#!/usr/bin/env python
from typing import List, Set, Dict

def to_dict(segments: List[Set[str]]) -> Dict[int, Set[str]]:
    def select(segments, x):
        sel = [s for s in segments if x(s)][0]
        segments.remove(sel)
        return sel

    res = {
        1: select(segments, lambda x: len(x) == 2),
        7: select(segments, lambda x: len(x) == 3),
        4: select(segments, lambda x: len(x) == 4),
        8: select(segments, lambda x: len(x) == 7)
    }

    # 3 is the one with 5 digits that overlaps with 1
    res[3] = select(segments, lambda x: len(x) == 5 and x & res[1] == res[1])

    # 9 is 6 digits that overlaps 4
    res[9] = select(segments, lambda x: len(x) == 6 and x & res[4] == res[4])

    # 0 is the remaining 6 digit that overlaps 1
    res[0] = select(segments, lambda x: len(x) == 6 and x & res[1] == res[1])

    # 6 is the remaining 6 digit
    res[6] = select(segments, lambda x: len(x) == 6)

    # 6 - 5 should be a single element
    res[5] = select(segments, lambda x: len(res[6] - x) == 1)

    # last one
    res[2] = select(segments, lambda x: True)

    return res


def solve(line: str) -> List[int]:
    numbers, answer = line.split(' | ')
    segments = [set(n) for n in numbers.split(' ')]

    # well, sets aren't hashable, woops
    lookup = to_dict(segments)
    resp = []
    for digit in answer.split(' '):
        target = set(digit)
        for n, chars in lookup.items():
            if chars == target:
                resp.append(n)
                break

    return resp


sample = 'acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf'

assert to_dict([set(x) for x in sample.split(' | ')[0].split(' ')]) == {
    0: set('cagedb'),
    2: set('gcdfa'),
    1: set('ab'),
    3: set('fbcad'),
    4: set('eafb'),
    5: set('cdfbe'),
    6: set('cdfgeb'),
    7: set('dab'),
    8: set('acedgfb'),
    9: set('cefabd')
}

assert solve(sample) == [5, 3, 5, 3]

with open('input') as fp:
    one = 0
    two = 0

    for line in fp:
        reading = solve(line.strip())
        one += sum([1 for n in reading if n in [1,4,7,8]])
        two += int(''.join([str(n) for n in reading]))

    print(f'one={one}')
    print(f'two={two}')
