#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_11/{fname}") as f:
        return [l.strip() for l in f]

def data_as_arr(data):
    return [list(map(int, d)) for d in data]

def zero(data):
    for i,r in enumerate(data):
        for j, c in enumerate(r):
            if c < 0:
                data[i][j] = 0

def inc(data):
    for i,r in enumerate(data):
        for j, _ in enumerate(r):
            data[i][j] += 1

def flash(data):
    flashed = 0
    for i,r in enumerate(data):
        for j, c in enumerate(r):
            if c > 9:
                flashed += 1
                data[i][j] = -100
                if i > 0:
                    if j > 0:
                        data[i-1][j-1] += 1
                    data[i-1][j] += 1
                    if j < len(data[0]) - 1:
                        data[i-1][j+1] += 1
                if i < len(data) - 1:
                    if j > 0:
                        data[i+1][j-1] += 1
                    data[i+1][j] += 1
                    if j < len(data[0]) - 1:
                        data[i+1][j+1] += 1

                if j > 0:
                    data[i][j-1] += 1
                if j < len(data[0]) - 1:
                    data[i][j+1] += 1
    return flashed

def zerocount(data):
    zc = 0
    for r in data:
        for c in r:
            if c == 0:
                zc += 1
    return zc

def main_a(data):
    steplimit = 100
    flashcount = 0
    data = data_as_arr(data)

    for _ in range(steplimit):
        inc(data)
        while nf := flash(data):
            flashcount += nf
        zero(data)

    return flashcount

def main_b(data):
    stepcount = 1
    data = data_as_arr(data)
    while True:
        inc(data)
        while nf := flash(data):
            pass
        zero(data)
        if zerocount(data) == 100:
            return stepcount
        stepcount += 1



    return 0

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))