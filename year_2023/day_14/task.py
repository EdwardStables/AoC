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
    weights = []
    for i in range(1000000000):
        for j in range(4):
            data = rotate_cw(data)
            data = shift_right(data)

        weights.append(weight(rotate_cw(data)))
        if i < 100:
            continue

        for first, w in enumerate(weights):
            if weights.count(w) == 1:
                continue
            try:
                second = weights.index(w, first+1)
            except ValueError:
                continue

            length = second - first

            if length < 3:
                continue            

            for i in range(first, second+1):
                if i + length >= len(weights):
                    break
                if weights[i] != weights[i+length]:
                    break
            else:
                #found a sequence which seems to work
                ind = (1000000000 - first - 1) % length
                return weights[ind+first]

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))