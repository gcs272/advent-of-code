#!/usr/bin/env python3
class Board:
    def __init__(self, block):
        self.board = []
        for row in block.split('\n'):
            self.board.append([int(n) for n in row.split()])

        self.called = []
        for row in self.board:
            self.called.append([False] * len(self.board[0]))

    def call(self, number):
        for x, row in enumerate(self.board):
            for y, val in enumerate(row):
                if val == number:
                    self.called[x][y] = True

    def solved(self):
        # check rows
        if any([all(row) for row in self.called]):
            return True

        # check cols
        for colnum, _ in enumerate(self.called[0]):
            if all([row[colnum] for row in self.called]):
                return True

        return False

    def uncalled(self):
        for x, row in enumerate(self.called):
            for y, val in enumerate(row):
                if not self.called[x][y]:
                    yield self.board[x][y]



with open('input') as fp:
    contents = fp.read()
    blocks = contents.strip().split('\n\n')
    numbers = [int(n) for n in blocks[0].split(',')]

    # part one
    boards = [Board(block) for block in blocks[1:]]
    for number in numbers:
        [board.call(number) for board in boards]
        solved = [b for b in boards if b.solved()]
        if solved:
            print('one:', sum(solved[0].uncalled()) * number)
            break

    # part two
    boards = [Board(block) for block in blocks[1:]]
    for number in numbers:
        [board.call(number) for board in boards]
        if all([b.solved() for b in boards]):
            last = boards.pop()
            print('two:', sum(last.uncalled()) * number)
            break
        else:
            boards = [b for b in boards if not b.solved()]
