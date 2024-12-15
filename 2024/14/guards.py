from typing import Tuple, List

Robot = Tuple[Tuple[int, int], Tuple[int, int]]


def move(robot: Robot, rounds=1, width=11, height=7):
    (px, py), (vx, vy) = robot
    return (
        ((px + vx * rounds) % width, (py + vy * rounds) % height),
        (vx, vy),
    )


def parse(input: str) -> List[Robot]:
    robots = []
    for line in input.strip().split("\n"):
        p, v = line.replace("p=", "").replace("v=", "").strip().split(" ")
        px, py = p.split(",")
        vx, vy = v.split(",")

        robots.append(
            (
                (int(px), int(py)),
                (int(vx), int(vy)),
            )
        )

    return robots


def quadrants(robots: List[Robot], width=11, height=7) -> List[int]:
    results = [0, 0, 0, 0]
    for (x, y), (_, _) in robots:
        if x == width // 2 or y == height // 2:
            continue

        left = x < width // 2
        top = y < height // 2

        match (left, top):
            case (True, True):
                results[0] += 1
            case (False, True):
                results[1] += 1
            case (False, False):
                results[2] += 1
            case _:
                results[3] += 1

    return results


def test_parse():
    assert parse("p=0,4 v=3,-3\np=6,3 v=-1,-3") == [
        ((0, 4), (3, -3)),
        ((6, 3), (-1, -3)),
    ]


def test_move():
    assert move(((5, 5), (-1, -1))) == ((4, 4), (-1, -1))
    assert move(((0, 0), (-1, -1))) == ((10, 6), (-1, -1))

    bot = ((2, 2), (3, -4))
    for _ in range(10):
        bot = move(bot)

    assert bot == move(((2, 2), (3, -4)), 10)


def test_quadrants():
    robots = [
        ((0, 0), (0, 0)),
        ((5, 0), (0, 0)),  # in the middle
        ((6, 1), (0, 0)),
        ((6, 3), (0, 0)),  # also in the middle
    ]

    assert quadrants(robots) == [1, 1, 0, 0]


def test_part_one():
    robots = parse(
        """
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
""".strip()
    )

    moved = [move(r, 100, 11, 7) for r in robots]

    answer = 1
    for val in quadrants(moved, 11, 7):
        answer *= val

    assert answer == 12


def display(robots: List[Robot]):
    coords = set([r[0] for r in robots])
    for y in range(103):
        for x in range(101):
            print("X" if (x, y) in coords else ".", end="")
        print("")


def compute(robots: List[Robot]) -> int:
    answer = 1
    for val in quadrants(robots, 101, 103):
        answer *= val
    return answer


if __name__ == "__main__":
    robots = parse(open("input").read().strip())
    moved = [move(r, 100, 101, 103) for r in robots]
    answer = 1
    for val in quadrants(moved, 101, 103):
        answer *= val

    print("part 1:", answer)

    rounds = 0
    vals = []
    for i in range(10000):
        robots = [move(r, 1, 101, 103) for r in robots]
        safety = compute(robots)
        vals.append(safety)

    print("part 2:", vals.index(min(vals)) + 1)
