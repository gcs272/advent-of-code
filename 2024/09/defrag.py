from typing import List, Tuple

class Block(Tuple[int, int]):
    pass

class Space(int):
    pass

def parse(input: List[int]) -> List[int|None]:
    fs = []
    id = 0
    while input:
        if len(input) > 1:
            block, space = input[:2]
        else:
            block, space = input[0], 0

        fs += [id for _ in range(block)]
        fs += [None for _ in range(space)]

        input = input[2:]
        id += 1

    return fs

def fill(fs: List[int|None]) -> List[int|None]:
    left = 0
    right = len(fs) - 1

    while left < right:
        # Shift Nones off the right
        while right > left and fs[right] is None:
            fs.pop()
            right -= 1 

        # Forward left until we see a None
        while left < right and fs[left] is not None:
            left += 1

        if right > left:
            fs[left] = fs.pop()
            right -= 1


    return fs

def find_target(fs: List[int|None], id: int) -> Tuple[int, int]:
    for i, c in enumerate(fs):
        if c == id:
            r = i
            while r+1 < len(fs) and fs[r+1] == id:
                r += 1

            return i, 1 + r - i

def find_space(fs: List[int|None], size: int) -> int|None:
    i = 0
    while i < len(fs):
        if fs[i] is None:
            r = i
            while r + 1 - i < size and r + 1 < len(fs) and fs[r + 1] is None:
                r += 1
            if 1 + r - i >= size:
                return i
        i += 1

    return None

def move(fs: List[int|None], id: int) -> List[int|None]:
    target, size = find_target(fs, id)
    space = find_space(fs, size)

    if space is not None and space < target:
        for i in range(size):
            fs[space+i] = id
            fs[target+i] = None

    return fs

def checksum(fs: List[int]) -> int:
    return sum([i*n for i, n in enumerate(fs) if n is not None])

def test_parse():
    assert parse([1,0,1]) == [0,1]
    assert parse([1,1]) == [0,None]
    assert parse([1,1,1]) == [0,None,1]
    assert parse([1,2,3]) == [0,None,None,1,1,1]

def test_fill():
    assert fill([0, None, 1]) == [0, 1]
    assert fill([0, None, 1, None, 2]) == [0,2,1]
    assert fill([0, None, 1, None, 2, None]) == [0,2,1]
    assert fill([0, None, None, 1, 1, None, 2, 3, 3, 3]) == [0,3,3,1,1,3,2]

def test_checksum():
    assert checksum([0,1]) == 1
    assert checksum([0,2,4,6]) == 2 + (4 * 2) + (6 * 3)
        
def test_find_target():
    assert find_target([0, None, None, 1, 1, 1], 1) == (3, 3)
    assert find_target([0, None, 1, 1, 2, 3], 2) == (4, 1)

def test_find_space():
    assert find_space([0, None, 1], 1) == 1
    assert find_space([0, None, 1], 2) is None
    assert find_space([0, None, 1, None, None, 2], 2) == 3

def test_move():
    assert move([0, None, None, 1, 1, 1], 1) == [0, None, None, 1, 1, 1]
    assert move([0, None, None, 1, 1], 1) == [0, 1, 1, None, None]
    assert move([0, 0, None, None, 1], 0) == [0, 0, None, None, 1]

def flatten(fs: List[Block|Space]) -> List[int]:
    # Flatten the array
    flat = []
    for node in fs:
        if isinstance(node, Block):
            (id, size) = node
            for _ in range(size):
                flat.append(id)
        else:
            for _ in range(node):
                flat.append(0)

    return flat

if __name__ == '__main__':
    input = [int(n) for n in open('input').read().strip()]
    print('part 1:', checksum(fill(parse(input))))

    max_id = (len(input) - 1) // 2
    fs = parse(input)
    for id in reversed(range(max_id + 1)):
        fs = move(fs, id)

    print('part 2:', checksum(fs))
