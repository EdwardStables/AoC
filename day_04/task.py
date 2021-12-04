#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_04/{fname}") as f:
        return [l.strip() for l in f]

def get_score(board, num):
    total = 0
    for b in board:
        if b != -1:
            total += b

    return total * num 

def check_board(board):
    #check rows
    i = 0
    j = 0
    while i < 25:
        if board[i] == board[i+1] == board[i+2] == board[i+3] == board[i+4] == -1:
            return True
        if board[j] == board[j+5] == board[j+10] == board[j+15] == board[j+20] == -1:
            return True
        i += 5
        j += 1

    return False

def get_boards(data):
    boards = []
    new_board = []
    for line in data[2:]:
        if line == "":
            boards.append(new_board)
            new_board = []
        else:
            for v in line.split():
                new_board.append(int(v))
    boards.append(new_board)
    return boards

def get_numbers(data):
    return [int(d) for d in data[0].split(',')]

def main_a(data):
    numbers = get_numbers(data)
    boards = get_boards(data)

    for n in numbers:
        for b in boards:
            for i, c in enumerate(b):
                if c == n:
                    b[i] = -1

            if check_board(b):
                return get_score(b, n)

def main_b(data):
    numbers = get_numbers(data)
    boards = get_boards(data)

    for n in numbers:
        next_boards = []
        for b in boards:
            for i, c in enumerate(b):
                if c == n:
                    b[i] = -1

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