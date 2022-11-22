#!/usr/bin/env python3
from time import time

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_04/{fname}") as f:
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
    to_check = [0 for _ in range(len(boards))]

    for n in numbers:
        for i, b in enumerate(boards):
            for j, c in enumerate(b):
                if c == n:
                    b[j] = -1
                    to_check[i] += 1

            if to_check[i] >= 5 and check_board(b):
                return get_score(b, n)

def main_b(data):
    numbers = get_numbers(data)
    boards = get_boards(data)
    left_to_win = len(boards)
    have_won = [False for _ in range(len(boards))]
    to_check = [0 for _ in range(len(boards))]

    for n in numbers:
        for j, b in enumerate(boards):
            if have_won[j]:
                continue
            
            for i, c in enumerate(b):
                if c == n:
                    b[i] = -1
                    to_check[j] += 1
            
            if to_check[j] >= 5 and check_board(b):
                left_to_win -= 1
                have_won[j] = True
                if not left_to_win:
                    return get_score(b, n)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))