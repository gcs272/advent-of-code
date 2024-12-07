from typing import Tuple, List, Dict
from collections import defaultdict

def parse(input: str) -> Tuple[Dict[int, List[int]], List[List[int]]]:
    rules_str, updates_str = input.split('\n\n')

    rules = defaultdict(list)
    for (x, y) in [map(int, rule.split('|')) for rule in rules_str.split('\n')]:
        rules[x].append(y)

    return (
        rules,
        [list(map(int, l.split(','))) for l in updates_str.split('\n')]
    )
    
def valid(rules: Dict[int, List[int]], update: List[int]) -> bool:
    # Get positions of the pages in the update
    positions = dict([(y, x) for x, y in enumerate(update)])
    for idx, page in enumerate(update):
        if page in rules:
            for rp in rules[page]:
                if rp in positions and positions[rp] < idx:
                    return False

    return True

def swap(update: List[int], insert: int, index: int) -> List[int]:
    return update[:insert] + [update[index]] + update[insert:index] + update[index+1:]

def reorder(rules: Dict[int, List[int]], update: List[int]) -> List[int]:
    positions = dict([(y, x) for x, y in enumerate(update)])

    for idx, page in enumerate(update):
        if page in rules:
            for rp in rules[page]:
                if rp in positions and positions[rp] < idx:
                    # Put the current page into the position before we broke the rule
                    return reorder(rules, swap(update, max(0, positions[rp] - 1), idx))

    return update

def test_parse():
    assert parse("1|2\n3|4\n\n1,3\n4,2,1") == ({1: [2], 3: [4]}, [[1,3], [4,2,1]])
    assert parse("1|2\n1|3\n\n1") == ({1: [2, 3]}, [[1]])

def test_valid():
    assert valid({1: [2], 3: [4]}, [1,2,3,4])
    assert not valid({1: [2], 3: [4]}, [4,3,2,1])

    assert valid({1: [2, 3]}, [1,3,2])
    assert not valid({1: [2, 3], 2: [3,4]}, [1,3,2])

def test_swap():
    assert swap([1,2,3,4], 1, 2) == [1,3,2,4]

def test_reorder():
    assert reorder({1: [2, 3], 2: [3,4]}, [1,3,2]) == [1,2,3]

if __name__ == '__main__':
    rules, updates = parse(open('input').read().strip())

    middles = 0
    for update in updates:
        if valid(rules, update):
            middles += update[len(update) // 2] 

    print('part 1:', middles)

    middles = 0
    for update in updates:
        if not valid(rules, update):
            fixed = reorder(rules, update)
            middles += fixed[len(fixed) // 2]

    print('part 2:', middles)
