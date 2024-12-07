import re

def build_strings(chars: list[list[chr]], x: int, y: int) -> list[str]:
    results = []
    if x + 4 <= len(chars[0]):
        results.append(''.join(chars[y][x:x+4]))

        if y - 3 >= 0:
            results.append(chars[y][x] + chars[y-1][x+1] + chars[y-2][x+2] + chars[y-3][x+3])
        if y + 4 <= len(chars):
            results.append(chars[y][x] + chars[y+1][x+1] + chars[y+2][x+2] + chars[y+3][x+3])

    if y + 4 <= len(chars):
        results.append(chars[y][x] + chars[y+1][x] + chars[y+2][x] + chars[y+3][x])

    return results

def search(input: str) -> int:
    chars = [list(line) for line in input.split('\n')]

    matches = 0
    for y, line in enumerate(chars):
        for x, c in enumerate(line):
            # Grab 4 chars going up/right, right, and down/right
            if c in ('X', 'S'):
                matches += len([x for x in build_strings(chars, x, y) if x in ('XMAS', 'SAMX')])
            
    return matches

def search2(input: str) -> int:
    chars = [list(line) for line in input.split('\n')]

    matches = 0
    for y, line in enumerate(chars):
        for x, c in enumerate(line):
            if y + 2 < len(chars) and x + 2 < len(line):  # has available room
                a = chars[y][x] + chars[y+1][x+1] + chars[y+2][x+2]
                b = chars[y+2][x] + chars[y+1][x+1] + chars[y][x+2]

                matches += a in ('MAS', 'SAM') and b in ('MAS', 'SAM')
                
    return matches


if __name__ == '__main__':
    assert build_strings([['X', 'M', 'A', 'S']], 0, 0) == ["XMAS"]
    assert build_strings([['a', 'b', 'c', 'd'], ['e', 'f', 'g', 'h'], ['i', 'j', 'k', 'l'], ['m', 'n', 'o', 'p']], 0, 0) == ["abcd", "afkp", "aeim"]
    assert build_strings([['a', 'b', 'c', 'd'], ['e', 'f', 'g', 'h'], ['i', 'j', 'k', 'l'], ['m', 'n', 'o', 'p']], 0, 3) == ["mnop", "mjgd"]
    assert build_strings([['a', 'b', 'c', 'd'], ['e', 'f', 'g', 'h'], ['i', 'j', 'k', 'l'], ['m', 'n', 'o', 'p']], 3, 0) == ["dhlp"]
    assert build_strings([['a', 'b', 'c', 'd'], ['e', 'f', 'g', 'h'], ['i', 'j', 'k', 'l'], ['m', 'n', 'o', 'p']], 1, 1) == []

    assert search("XMAS") == 1
    assert search("XMASAMX") == 2
    assert search("X..S\n.MA.\n.MA.\nX..S") == 2

    assert search2("M.S\n.A.\nM.S") == 1
    assert search2("MMSS\n.AA.\nMMSS") == 2
    assert search2("MSSM\n.AA.\nMSSM") == 2

    input = open('input').read().strip()
    print('part 1:', search(input))
    print('part 2:', search2(input))
