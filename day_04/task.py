#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_04/{fname}") as f:
        return [l.strip() for l in f]

def get_score(board, num):
    total = 0
    for cell, dat in board.items():
        if not dat[0]:
            total += cell

    return total * num 

def check_board(board):
    cells = [(v[1],v[2]) for _, v in board.items() if v[0]]
    counter = [0 for _ in range(10)]
    for c in cells:
        counter[c[0]] += 1
        counter[c[1] + 5] += 1
        if any([counter[i] == 5 for i in range(10)]):
            return True

def main_a(data):
    numbers = [int(d) for d in data[0].split(',')]

    boards = []

    new_board = {}
    row_count = 0
    for line in data[2:]:
        if line == "":
            boards.append(new_board)
            new_board = {}
            row_count = 0
        else:
            for col, v in enumerate(line.split()):
                new_board[int(v)] = [False, row_count, col]
            row_count += 1
    boards.append(new_board)

    res = None
    for n in numbers:
        for b in boards:
            if n in b:
                b[n][0] = True

            if check_board(b):
                res = get_score(b, n)
                break

        if res is not None:
            return res

def main_b(data):
    numbers = [int(d) for d in data[0].split(',')]

    boards = []

    new_board = {}
    row_count = 0
    for line in data[2:]:
        if line == "":
            boards.append(new_board)
            new_board = {}
            row_count = 0
        else:
            for col, v in enumerate(line.split()):
                new_board[int(v)] = [False, row_count, col]
            row_count += 1
    boards.append(new_board)

    res = None
    for n in numbers:
        next_boards = []
        for b in boards:
            if n in b:
                b[n][0] = True

            if not check_board(b):
                next_boards.append(b)
            else:
                last_board = b

        boards = next_boards

        if len(boards) == 0:
            return get_score(last_board, n)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))