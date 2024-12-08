from typing import List

def valid(reports: List[int]) -> bool:
    increasing = reports[1] - reports[0] < 0
    for i, r in enumerate(reports):
        if i == 0:
            continue
        diff = r - reports[i - 1]

        if increasing and (diff > -1 or diff < -3):
            return False
        elif not increasing and (diff < 1 or diff > 3):
            return False
            
    return True

def valid2(reports: List[int]) -> bool:
    if valid(reports):
        return True

    for i, _ in enumerate(reports):
        if valid(reports[:i] + reports[i+1:]):
            return True

    return False
    

def test_valid():
    assert valid([7, 6, 4, 2, 1])
    assert valid([1, 2, 4, 6, 7])
    assert not valid([1, 5, 6, 7])
    assert not valid([1, 4, 2, 5])
    assert valid([1, 2, 4, 5])

def test_valid2():
    assert valid2([7, 6, 4, 2, 1])
    assert not valid2([1, 2, 7, 8, 9])
    assert valid2([1, 3, 2, 4, 5])

if __name__ == '__main__':
    reports = [list(map(int, reps.split(' '))) for reps in open('input').read().strip().split('\n')]
    part1 = 0
    for report in reports:
        part1 += valid(report)

    print('part 1:', part1)

    part2 = 0
    for report in reports:
        part2 += valid2(report)

    print('part 2:', part2)
