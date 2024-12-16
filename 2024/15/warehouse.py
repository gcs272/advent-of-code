from typing import Tuple, List, Set

Coordinates = Tuple[int, int]


def parse(
    input: str,
) -> Tuple[Set[Coordinates], Set[Coordinates], Coordinates, Coordinates, List[str]]:
    maps, inst = input.strip().split("\n\n")

    obstacles = []
    boxes = []
    robot = (0, 0)

    # unwrap
    map = [l[1:-1] for l in maps.split("\n")[1:-1]]

    for y, line in enumerate(map):
        for x, c in enumerate(line):
            match c:
                case "O":
                    boxes.append((y, x))
                case "#":
                    obstacles.append((y, x))
                case "@":
                    robot = (y, x)
                case _:
                    pass

    return (
        set(obstacles),
        set(boxes),
        robot,
        (len(map), len(map[0])),
        list(inst.replace("\n", "")),
    )


def move(
    robot: Coordinates,
    bounds: Coordinates,
    obstacles: Set[Coordinates],
    boxes: Set[Coordinates],
    instruction: str,
) -> Tuple[Coordinates, Set[Coordinates]]:
    """returns robot and boxes"""
    # if we can move, then move, along with any boxes in the way
    # we can move if there's an open space between the robot and the next obstacle/bound
    dy, dx = {
        "^": (-1, 0),
        "<": (0, -1),
        ">": (0, 1),
        "v": (1, 0),
    }[instruction]

    cy, cx = robot
    has_free_space = False
    while (
        (cy + dy) >= 0
        and (cy + dy) < bounds[0]
        and (cx + dx) >= 0
        and (cx + dx) < bounds[1]
    ):
        cy += dy
        cx += dx

        if (cy, cx) in obstacles:
            return robot, boxes

        if (cy, cx) not in boxes:
            has_free_space = True
            break

    if not has_free_space:
        return robot, boxes

    # (cy, cx) is the free space we need to shift things to
    while (cy - dy, cx - dx) in boxes:
        boxes.remove((cy - dy, cx - dx))
        boxes.add((cy, cx))

        cy -= dy
        cx -= dx

    return (cy, cx), boxes


def test_parse():
    input = """
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<"""

    obstacles, boxes, robot, bounds, instructions = parse(input)
    assert len(obstacles) == 2
    assert len(boxes) == 6
    assert robot == (1, 1)
    assert bounds == (6, 6)
    assert instructions[0] == "<"


def test_basic_move():
    robot, _ = move((0, 0), (1, 3), set(), set(), ">")
    assert robot == (0, 1)


def test_boxed_move():
    robot, boxes = move((0, 0), (1, 3), set(), set([(0, 1)]), ">")
    assert robot == (0, 1)
    assert boxes == set([(0, 2)])


def test_double_boxed_move():
    robot, boxes = move((0, 0), (1, 4), set(), set([(0, 1), (0, 2)]), ">")
    assert robot == (0, 1)
    assert boxes == set([(0, 2), (0, 3)])


def test_invalid_move():
    robot, _ = move((0, 0), (1, 3), set(), set([(0, 1), (0, 2)]), ">")
    assert robot == (0, 0)


def test_obstacle_move():
    robot, _ = move((0, 1), (1, 2), set([(0, 0)]), set(), "<")
    assert robot == (0, 1)


def test_obstacle_box_move():
    robot, _ = move((0, 0), (3, 1), set([(2, 0)]), set([(1, 0)]), "v")
    assert robot == (0, 0)


def test_obstacle_free():
    robot, _ = move((0, 0), (1, 3), set([(0, 1)]), set(), ">")
    assert robot == (0, 0)


if __name__ == "__main__":
    obstacles, boxes, robot, bounds, instructions = parse(open("input").read())
    for instruction in instructions:
        robot, boxes = move(robot, bounds, obstacles, boxes, instruction)

        # print("\n", instruction)
        # for y in range(bounds[0]):
        #    for x in range(bounds[1]):
        #        if (y, x) in obstacles:
        #            print("#", end="")
        #        elif (y, x) in boxes:
        #            print("O", end="")
        #        elif (y, x) == robot:
        #            print("@", end="")
        #        else:
        #            print(".", end="")
        #    print("")

    print("part 1:", sum([100 * (y + 1) + 1 + x for y, x in boxes]))
