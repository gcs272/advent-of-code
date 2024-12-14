import re
import numpy as np
from typing import Tuple, List
from dataclasses import dataclass

SCENARIO_RE = (
    r"Button A: X\+(\d), Y\+(\d)\nButton B: X\+(\d), Y\+(\d)\nPrize: X=(\d), Y=(\d)"
)


@dataclass
class Scenario:
    a: Tuple[int, int]
    b: Tuple[int, int]
    prize: Tuple[int, int]


def solve(scenario: Scenario) -> int | None:
    left = np.array([[scenario.a[0], scenario.b[0]], [scenario.a[1], scenario.b[1]]])
    right = np.array([scenario.prize[0], scenario.prize[1]])

    npa = np.linalg.solve(left, right)
    ma = round(npa[0])
    mb = round(npa[1])

    if (
        scenario.a[0] * ma + scenario.b[0] * mb == scenario.prize[0]
        and scenario.a[1] * ma + scenario.b[1] * mb == scenario.prize[1]
    ):
        return ma * 3 + mb

    return None


def parse(input: str) -> List[Scenario]:
    scenarios = []
    for block in input.split("\n\n"):
        ax, ay, bx, by, px, py = map(int, re.findall(r"\d+", block))
        scenarios.append(Scenario(a=(ax, ay), b=(bx, by), prize=(px, py)))

    return scenarios


def test_parse():
    input = """
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176
    """.strip()

    assert parse(input) == [
        Scenario(a=(94, 34), b=(22, 67), prize=(8400, 5400)),
        Scenario(a=(26, 66), b=(67, 21), prize=(12748, 12176)),
    ]


def test_solve():
    assert solve(Scenario(a=(94, 34), b=(22, 67), prize=(8400, 5400))) == 280


if __name__ == "__main__":
    scenarios = parse(open("input").read().strip())

    print("part 1:", sum([solve(s) or 0 for s in scenarios]))

    for s in scenarios:
        s.prize = (s.prize[0] + 10000000000000, s.prize[1] + 10000000000000)

    print("part 2:", sum([solve(s) or 0 for s in scenarios]))
