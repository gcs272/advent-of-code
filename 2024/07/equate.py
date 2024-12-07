from typing import List, Tuple

def valid(total: int, args: List[int]) -> bool:
    match args:
        case [h]:
            return h == total
        case [h, *t]:
            if total % h == 0:
                return valid(total // h, t) or valid(total - h, t)
            return valid(total - h, t)
        case _:
            return False

def valid2(target: int, total: int, args: List[int]) -> bool:
    match args:
        case []:
            return target == total
        case [h]:
            return (
                valid2(target, total + h, []) or
                valid2(target, total * h, []) or
                valid2(target, int(str(total) + str(h)), [])
            )
        case [h, *t]:
            return (
                valid2(target, total + h, t) or
                valid2(target, total * h, t) or
                valid2(target, int(str(total) + str(h)), t)
            )
        case _:
            return False

def parse(input: str) -> List[Tuple[int, List[int]]]:
    lines = input.strip().split('\n')

    equations = []
    for line in lines:
        total, args_str = line.split(': ')
        args = list(map(int, args_str.split(' ')))

        equations.append((int(total), args))

    return equations

def test_valid():
    assert valid(190, [19, 10])
    assert valid(3267, [27, 40, 81])
    assert not valid(83, [5, 17])

def test_valid2():
    assert valid2(190, 0, [10, 19])
    assert valid2(3267, 0, [81, 40, 27])
    assert not valid2(83, 0, [17, 5])
    assert valid2(156, 0, [15, 6])
    assert valid2(7290, 0, [6, 8, 6, 15])

def test_parse():
    assert parse("190: 10 19\n3267: 81 40 27\n") == [
        (190, [10, 19]),
        (3267, [81, 40, 27])
    ]

if __name__ == '__main__':
    calibration = 0
    equations = parse(open('input').read())
    for (total, args) in equations:
        args.reverse()
        if valid(total, args):
            calibration += total

    print('part 1:', calibration)

    calibration = 0
    for (total, args) in parse(open('input').read()):
        if valid2(total, 0, args):
            calibration += total

    print('part 2:', calibration)

