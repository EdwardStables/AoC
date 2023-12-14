#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_14/{fname}") as f:
        return [l.strip() for l in f]

def rotate_cw(data):
    rows = [[] for _ in data[0]]
    for row in data:
        for i, c in enumerate(row):
            rows[i].insert(0,c)
    return rows

def shift_right(rows):
    for row in rows:
        i = len(row)-1
        while i >= 0:
            if row[i] == "O":
                _i = i+1
                while _i < len(row) and row[_i] == ".":
                    _i += 1
                _i -= 1
                if _i != i:
                    row[_i] = "O"
                    row[i] = "."
            i-=1
    return rows

def weight(rows):
    s = 0
    for row in rows:
        for x, c in enumerate(row):
            if c == "O":
                s += x+1
    return s


def main_a(data):
    rows = rotate_cw(data)
    rows = shift_right(rows)
    return weight(rows)

def main_b(data):
    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))