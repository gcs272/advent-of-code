from collections.abc import Callable
from itertools import combinations
from typing import Tuple, List, Dict, Set
from collections import defaultdict

Antenna = Tuple[str, int, int]

def parse(input: str) -> Tuple[List[Antenna], Tuple[int, int]]:
    """ Return a list of antennas and a bounding box (height, width) """
    antennas = []

    lines = input.strip().split('\n')
    for y, line in enumerate(lines):
        for x, c in enumerate(line):
            if c != '.':
                antennas.append((c, y, x))

    return (antennas, (len(lines) - 1, len(lines[0]) - 1))

def collect(antennas: List[Antenna]) -> Dict[str, List[Antenna]]:
    collected = defaultdict(list)
    for (c, y, x) in antennas:
        collected[c].append((c, y, x))

    return collected

def project(a1: Antenna, a2: Antenna, bounds: Tuple[int, int]) -> List[Tuple[int, int]]:
    t1 = (
        (a1[1] + a1[1] - a2[1]),
        (a1[2] + a1[2] - a2[2]),
    )
    t2 = (
        (a2[1] + a2[1] - a1[1]),
        (a2[2] + a2[2] - a1[2]),
    )

    antinodes = []
    if t1[0] >= 0 and t1[0] <= bounds[0] and t1[1] >= 0 and t1[1] <= bounds[1]:
        antinodes.append(t1)
    if t2[0] >= 0 and t2[0] <= bounds[0] and t2[1] >= 0 and t2[1] <= bounds[1]:
        antinodes.append(t2)

    return antinodes

def project2(a1: Antenna, a2: Antenna, bounds: Tuple[int, int]) -> List[Tuple[int, int]]:
    s1 = (a1[1] - a2[1], a1[2] - a2[2])
    s2 = (a2[1] - a1[1], a2[2] - a1[2])

    c1 = (a1[1] + s1[0], a1[2] + s1[1])
    c2 = (a2[1] + s2[0], a2[2] + s2[1])

    antinodes = [(a1[1], a1[2]), (a2[1], a2[2])]
    while c1[0] >= 0 and c1[0] <= bounds[0] and c1[1] >= 0 and c1[1] <= bounds[1]:
        antinodes.append(c1)
        c1 = (c1[0] + s1[0], c1[1] + s1[1])

    while c2[0] >= 0 and c2[0] <= bounds[0] and c2[1] >= 0 and c2[1] <= bounds[1]:
        antinodes.append(c2)
        c2 = (c2[0] + s2[0], c2[1] + s2[1])

    return antinodes

def part_one(collected: Dict[str, List[Antenna]], bounds: Tuple[int, int]) -> int:
    return solve(collected, bounds, fn=project)

def part_two(collected: Dict[str, List[Antenna]], bounds: Tuple[int, int]) -> int:
    return solve(collected, bounds, fn=project2)

def solve(collected: Dict[str, List[Antenna]], bounds: Tuple[int, int], fn: Callable = project) -> int:
    antinodes: Set[Tuple[int, int]] = set()
    for _, antennas in collected.items():
        for (a, b) in combinations(antennas, 2):
            for an in fn(a, b, bounds):
                antinodes.add(an)

    return len(antinodes)

def test_parse():
    input = "..A\n0A."
    assert parse(input) == ([
        ('A', 0, 2),
        ('0', 1, 0),
        ('A', 1, 1)
    ], (1, 2))

def test_collect():
    assert collect([('A', 0, 2), ('0', 1, 0), ('A', 1, 1)]) == {'A': [('A', 0, 2), ('A', 1, 1)], '0': [('0', 1, 0)]}

def test_project():
    '''
    ...
    .c.
    ..c

    should have antinodes at 0,0 and 3,3 (but 3,3 would be out of bounds)
    '''
    assert project(('c', 1, 1), ('c', 2, 2), (2, 2)) == [(0, 0)]

def test_project2():
    '''
    a...
    .a..
    ..!.
    ...!
    '''

    assert project2(('a', 0, 0), ('a', 1, 1), (3, 3)) == [(0, 0), (1, 1), (2, 2), (3, 3)]

def test_part_one():
    collected = collect([('A', 1, 1), ('A', 2, 2), ('B', 0, 0), ('B', 1, 0)])
    assert part_one(collected, (2, 2)) == 2   # A -> (0, 0), B -> (2, 0)

def test_part_two():
    collected = collect([('A', 0, 0), ('A', 1, 1), ('B', 0, 0), ('B', 1, 0)])
    assert part_two(collected, (2, 2)) == 5 # same as above, with original antennas
    assert part_two(collected, (3, 3)) == 7 # keep extending


if __name__ == '__main__':
    input = open('input').read()
    antennas, bounds = parse(input)
    collected = collect(antennas)

    print('part 1:', part_one(collected, bounds))
    print('part 2:', part_two(collected, bounds))
