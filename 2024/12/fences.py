from typing import List, Tuple, Set
from collections import defaultdict

Position = Tuple[int, int]


def expand_region(
    input: List[List[str]], start: Position, seen: Set[Position] = set()
) -> Set[Position]:
    y, x = start

    expanded: List[Position] = []
    if y > 0 and (y - 1, x) not in seen and input[y - 1][x] == input[y][x]:
        expanded.append((y - 1, x))
    if y + 1 < len(input) and (y + 1, x) not in seen and input[y + 1][x] == input[y][x]:
        expanded.append((y + 1, x))
    if x > 0 and (y, x - 1) not in seen and input[y][x - 1] == input[y][x]:
        expanded.append((y, x - 1))
    if (
        x + 1 < len(input[0])
        and (y, x + 1) not in seen
        and input[y][x + 1] == input[y][x]
    ):
        expanded.append((y, x + 1))

    seen.update(expanded)
    for ex in expanded:
        seen.update(expand_region(input, ex, seen))

    return seen


def get_regions(input: List[List[str]]) -> List[Set[Position]]:
    seen: Set[Position] = set()
    regions: List[Set[Position]] = []

    for y, _ in enumerate(input):
        for x, _ in enumerate(input[y]):
            if (y, x) not in seen:
                region = expand_region(input, (y, x), set([(y, x)]))
                seen.update(region)
                regions.append(region)

    return regions


def fences(region: Set[Position]) -> Tuple[int, int]:
    perimeter = 0
    for y, x in region:
        perimeter += 4 - sum(
            [
                (y - 1, x) in region,
                (y + 1, x) in region,
                (y, x - 1) in region,
                (y, x + 1) in region,
            ]
        )
    return len(region), perimeter


def get_edges(region: Set[Position]) -> Set[Tuple[int, int, int]]:
    edges: Set[Tuple[int, int, int]] = set()
    for y, x in region:
        if (y - 1, x) not in region:
            edges.add((0, y, x))
        if (y, x + 1) not in region:
            edges.add((1, y, x))
        if (y + 1, x) not in region:
            edges.add((2, y, x))
        if (y, x - 1) not in region:
            edges.add((3, y, x))
    return edges


def get_lines(region: Set[Position]) -> int:
    # for each region, if there's a missing adjacent block, it's an edge
    edges = get_edges(region)

    lines = 0
    while len(edges) > 0:
        lines += 1

        direction, y, x = edges.pop()
        if direction in (0, 2):
            # horizontal line
            cx = x
            while (direction, y, cx + 1) in edges:
                edges.remove((direction, y, cx + 1))
                cx += 1

            cx = x
            while (direction, y, cx - 1) in edges:
                edges.remove((direction, y, cx - 1))
                cx -= 1
        else:
            # vertical line
            cy = y
            while (direction, cy - 1, x) in edges:
                edges.remove((direction, cy - 1, x))
                cy -= 1

            cy = y
            while (direction, cy + 1, x) in edges:
                edges.remove((direction, cy + 1, x))
                cy += 1

    return lines


def test_fences():
    assert fences(set([(0, 0)])) == (1, 4)


def test_expand_region():
    assert len(expand_region([["A", "A"], [".", "A"]], (0, 0), set([(0, 0)]))) == 3


def test_get_regions():
    assert get_regions([["A", "A"], ["B", "B"]]) == [
        set([(0, 0), (0, 1)]),
        set([(1, 0), (1, 1)]),
    ]

    assert get_regions([["A", "A"], ["A", "B"]]) == [
        set([(0, 0), (0, 1), (1, 0)]),
        set([(1, 1)]),
    ]


def test_get_edges():
    assert get_edges(set([(0, 0)])) == set([(0, 0, 0), (1, 0, 0), (2, 0, 0), (3, 0, 0)])
    assert get_edges(set([(0, 0), (1, 0), (1, 1)])) == set(
        [
            (0, 0, 0),
            (1, 0, 0),
            (3, 0, 0),
            (2, 1, 0),
            (3, 1, 0),
            (0, 1, 1),
            (1, 1, 1),
            (2, 1, 1),
        ]
    )


def test_get_lines():
    assert get_lines(set([(0, 0)])) == 4
    assert get_lines(set([(0, 0), (1, 0), (1, 1)])) == 6


if __name__ == "__main__":
    input = [list(line) for line in open("input").read().strip().split("\n")]
    regions = get_regions(input)

    total = 0
    for region in regions:
        area, perimeter = fences(region)
        total += area * perimeter

    print("part 1:", total)

    total = 0
    for region in regions:
        total += get_lines(region) * len(region)

    print("part 2:", total)
