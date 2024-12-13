from typing import List
from functools import cache


@cache
def expand(n: int, rounds: int = 1) -> int:
    """Return the number of stones after a set of rounds"""
    while rounds > 0:
        sn = str(n)
        match n:
            case 0:
                n = 1
            case _ if len(sn) % 2 == 0:
                # Split and recurse
                return expand(int(sn[: len(sn) // 2]), rounds - 1) + expand(
                    int(sn[len(sn) // 2 :]), rounds - 1
                )
            case _:
                n *= 2024

        rounds -= 1
    return 1


def test_rule1():
    assert expand(0) == 1


def test_rule2():
    assert expand(10) == 2
    assert expand(101) == 1


def test_rule3():
    assert expand(1) == 1


def test_expand():
    assert expand(0, 1) == 1
    assert expand(10, 1) == 2
    assert expand(0, 3) == 2

    assert expand(125, 1) == 1
    assert expand(125, 2) == 2
    assert expand(125, 6) == 7


if __name__ == "__main__":
    input = list(map(int, open("input").read().split(" ")))

    print("part 1:", sum([expand(i, 25) for i in input]))
    print("part 2:", sum([expand(i, 75) for i in input]))
