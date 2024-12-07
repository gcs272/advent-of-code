import re


def run2(input: str) -> int:
    total = 0
    skip = False

    for op in re.findall(r"do\(\)|don't\(\)|mul\(\d+,\d+\)", input):
        match op:
            case "do()":
                skip = False
            case "don't()":
                skip = True
            case _:
                if not skip:
                    x, y = map(int, re.findall(r"mul\((\d+),(\d+)\)", op)[0])
                    total += x * y

    return total

def run(input: str) -> int:
    matches = re.findall(r"mul\((\d+),(\d+)\)", input)
    return sum([int(x) * int(y) for (x, y) in matches])

if __name__ == '__main__':
    input = open('input').read()
    print("part 1:", run(input))
    print("part 2:", run2(input))

    assert run2("don't()mul(1,1)do()mul(2,2)") == 4
    assert run2("mul(2,2)") == 4
    assert run2("mul(1,1)don't()mul(2,2)do()mul(3,3)") == 10
    assert run2("mul(1,1)don't()mul(2,2)do()mul(3,3)don't()mul(4,4)") == 10
