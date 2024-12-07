from typing import Tuple, List, Set

Position = Tuple[int, int]

def parse(input: str) -> Tuple[Position, List[Position], Position]:
    obstacles = []
    guard = (0, 0)

    lines = input.split('\n')
    for y, line in enumerate(lines):
        for x, c in enumerate(line):
            match c:
                case '#':
                    obstacles.append((y, x))
                case '^':
                    guard = (y, x)

    return (guard, obstacles, (len(lines) - 1, len(lines[0]) - 1))

def step(guard, heading, obstacles) -> Tuple[Position, int]:
    target = (guard[0]-1, guard[1])
    if heading == 90:
        target = (guard[0], guard[1] + 1)
    elif heading == 180:
        target = (guard[0]+1, guard[1])
    elif heading == 270:
        target = (guard[0], guard[1] - 1)

    if target in obstacles:
        return (guard, (heading + 90) % 360)

    return (target, heading)

def run(guard: Position, obstacles: List[Position], bounds: Position) -> int:
    heading = 0
    visited: Set[Position] = set([guard])

    while True:
        guard, heading = step(guard, heading, obstacles)
        if guard[0] < 0 or guard[0] > bounds[0] or guard[1] < 0 or guard[1] > bounds[1]:
            return len(visited)
        
        visited.add(guard)

def will_loop(guard: Position, heading: int, obstacles: List[Position], bounds: Position) -> bool:
    visited: Set[Tuple[Position, int]] = set([(guard, heading)])
    while True:
        guard, heading = step(guard, heading, obstacles)
        if guard[0] < 0 or guard[0] > bounds[0] or guard[1] < 0 or guard[1] > bounds[1]:
            return False
        if (guard, heading) in visited:
            return True

        visited.add((guard, heading))


def block(guard: Position, obstacles: List[Position], bounds: Position) -> int:
    seen: Set[Position] = set()
    positions: Set[Position] = set()
    heading = 0
    while True:
        next_guard, next_heading = step(guard, heading, obstacles) 
        if guard != next_guard:
            # we're not turning, see if throwing an obstacle would trigger a loop
            if next_guard not in seen and will_loop(guard, heading, obstacles + [next_guard], bounds):
                    positions.add(next_guard)

            seen.add(next_guard)

        guard = next_guard
        heading = next_heading

        if guard[0] < 0 or guard[0] > bounds[0] or guard[1] < 0 or guard[1] > bounds[1]:
            return len(positions)

def test_parse():
    guard, obstacles, bounds = parse("#...\n...^\n#.#.")
    assert guard == (1,3)
    assert obstacles == [(0,0), (2,0), (2,2)]
    assert bounds == (2,3)

def test_step():
    guard, obstacles, _ = parse(".\n^")
    assert step(guard, 0, obstacles) == ((0, 0), 0)

    guard, obstacles, _ = parse("####\n.^..")
    assert step(guard, 0, obstacles) == ((1, 1), 90)
    assert step(guard, 90, obstacles) == ((1, 2), 90)

def test_run():
    input = """
.#..
.^.#
....
..#.
    """.strip()

    guard, obstacles, bounds = parse(input)
    assert run(guard, obstacles, bounds) == 5

def test_block():
    """ only position here is 2,0 """
    input = """
.#..
.^.#
....
..#.
    """.strip()
    guard, obstacles, bounds = parse(input)
    assert block(guard, obstacles, bounds) == 1

def test_will_loop():
    input = """
.#..
.^.#
....
..#.
    """.strip()

    guard, obstacles, bounds = parse(input)
    assert not will_loop(guard, 0, obstacles, bounds)

    input = """
.#..
.^.#
#...
..#.
    """.strip()
    guard, obstacles, bounds = parse(input)
    assert will_loop(guard, 0, obstacles, bounds)

if __name__ == '__main__':
    guard, obstacles, bounds = parse(open('input').read().strip())
    print('part 1:', run(guard, obstacles, bounds))
    print('part 2:', block(guard, obstacles, bounds))
