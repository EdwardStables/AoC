#!/usr/bin/env python3
from math import gcd

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_17/{fname}") as f:
        return [l.strip() for l in f]

class y_wrap:
    y = 0

def pos_gen(y):
    ind = 4
    while True:

        ind = (ind + 1) % 5
        
        if ind == 0:
            yield [[2, y.y],[3, y.y],[4, y.y],[5, y.y]]
        if ind == 1:
            yield [[2, y.y+1],[3, y.y+1],[4, y.y+1],[3, y.y], [3,y.y+2]]
        if ind == 2:
            yield [[2, y.y],[3, y.y],[4, y.y],[4, y.y+1], [4,y.y+2]]
        if ind == 3:
            yield [[2, y.y],[2, y.y+1],[2, y.y+2],[2, y.y+3]]
        if ind == 4:
            yield [[2, y.y],[2, y.y+1],[3, y.y],[3, y.y+1]]

def dir_gen(data):
    ind = 0
    while True:
        val = data[ind]
        ind = (ind+1)%len(data)
        yield -1 if val=="<" else 1

def board_print(positions, highest_point):
    for y in range(highest_point + 1, -1, -1):
        if y == 0:
            print("+-------+")
            break
        for x in range(-1, 8):
            if x == -1:
                print("|",end="")
            elif x == 7:
                print("|")
            elif (x,y) in positions:
                print("#",end="")
            else:
                print(".",end="")


def run(lim, data):
    d = data[0]
    d_gen = dir_gen(d)

    yw = y_wrap()
    shapes = pos_gen(yw)

    highest_point = 0
    positions = set()

    for i in range(lim):
        #board_print(positions , highest_point+10)
        #input()
        yw.y = highest_point + 4
        shape = next(shapes)

        while True:
            dir = next(d_gen)
            shifted_shape = [[x+dir, y] for x, y in shape]
            valid = not any(x < 0 or x > 6 or (x,y) in positions for x, y in shifted_shape)
            if valid:
                shape = shifted_shape
            shifted_shape = [[x, y-1] for x, y in shape]
            valid = not any(y < 1 or (x,y) in positions for x,y in shifted_shape)
            if valid:
                shape = shifted_shape
                continue
            new_positions = set((x,y) for x,y in shape)
            highest_point = max(highest_point, max(y for _,y in new_positions))
            positions |= new_positions
            break

    return highest_point

def main_a(data):
    return run(2022, data)

def main_b(data):
    return 0
    return run(1000000000000, data)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))