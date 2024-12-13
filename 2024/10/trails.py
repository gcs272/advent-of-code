from typing import List, Tuple, Set

Position = Tuple[int, int]


def find_trailheads(map: List[List[int]]) -> List[Position]:
    trailheads = []
    for y, _ in enumerate(map):
        for x, h in enumerate(map[y]):
            if h == 0:
                trailheads.append((y, x))
    return trailheads


def find_trails(map: List[List[int]], position: Position) -> Set[Position]:
    y, x = position
    height = map[y][x]

    if height == 9:
        return set([(y, x)])

    steps = []
    if y > 0 and map[y - 1][x] - height == 1:
        steps.append((y - 1, x))
    if y + 1 < len(map) and map[y + 1][x] - height == 1:
        steps.append((y + 1, x))
    if x > 0 and map[y][x - 1] - height == 1:
        steps.append((y, x - 1))
    if x + 1 < len(map[0]) and map[y][x + 1] - height == 1:
        steps.append((y, x + 1))

    heads = set()
    for step in steps:
        heads.update(find_trails(map, step))

    return heads


def find_scores(map: List[List[int]], position: Position) -> int:
    y, x = position
    height = map[y][x]

    if height == 9:
        return 1

    steps = []
    if y > 0 and map[y - 1][x] - height == 1:
        steps.append((y - 1, x))
    if y + 1 < len(map) and map[y + 1][x] - height == 1:
        steps.append((y + 1, x))
    if x > 0 and map[y][x - 1] - height == 1:
        steps.append((y, x - 1))
    if x + 1 < len(map[0]) and map[y][x + 1] - height == 1:
        steps.append((y, x + 1))

    return sum([find_scores(map, s) for s in steps])


def test_find_trails():
    map = [[0, 1, 2], [5, 4, 3], [6, 7, 8], [0, 1, 9]]
    assert find_trails(map, (0, 0)) == set([(3, 2)])

    map = [[0, 1, 2], [1, 2, 3], [6, 5, 4], [7, 8, 9]]
    assert find_trails(map, (0, 0)) == set([(3, 2)])

    map = [[0, 1, 2, 3], [1, 2, 3, 4], [8, 7, 6, 5], [9, 8, 7, 6]]
    assert find_trails(map, (0, 0)) == set([(3, 0)])


def test_find_scores():
    map = [[0, 1, 2], [5, 4, 3], [6, 7, 8], [0, 1, 9]]
    assert find_scores(map, (0, 0)) == 1

    map = [[0, 1, 2], [1, 2, 3], [6, 5, 4], [7, 8, 9]]
    assert find_scores(map, (0, 0)) == 3


def test_find_trailheads():
    map = [[0, 1, 2], [5, 4, 3], [6, 7, 8], [0, 1, 9]]
    assert find_trailheads(map) == [(0, 0), (3, 0)]


if __name__ == "__main__":
    map = [list(map(int, l)) for l in open("input").read().strip().split("\n")]
    print(
        "part 1:",
        sum([len(find_trails(map, trailhead)) for trailhead in find_trailheads(map)]),
    )

    print(
        "part 2:",
        sum([find_scores(map, trailhead) for trailhead in find_trailheads(map)]),
    )
