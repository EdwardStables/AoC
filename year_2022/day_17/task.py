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

def board_print(positions, highest_point, cut=None, label=None, show_base=False):
    cut = -1 if cut is None else highest_point-cut
    cut = max(-1, cut)
    s = ""
    if label is not None:
        print(label)
    for y in range(highest_point + 1, cut, -1):
        if y == cut+1:
            if (show_base):
                s += "+-------+"
            return s
        for x in range(-1, 8):
            if x == -1:
                s += "|"
            elif x == 7:
                s += "|\n"
            elif (x,y) in positions:
                s += "#"
            else:
                s += "."

def run_pattern(count, yw, shapes, d_gen, positions, highest_point):
    for j in range(count):
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

def run(lim, data):
    d = data[0]
    d_gen = dir_gen(d)

    yw = y_wrap()
    shapes = pos_gen(yw)

    highest_point = 0
    positions = set()

    major = lim // len(d)
    extra = lim % len(d)
    
    print("major", major, "extra", extra)

    diffs = []    

    prev_highest = 0
    pattern = []


    final_ind = 0
    for i in range(major):
        print(i)
        highest_point = run_pattern(len(data[0]), yw, shapes, d_gen, positions, highest_point)        
        diff = highest_point-prev_highest
        
        if i > 0:
            diffs.append(diff)

        if len(diffs) > 2 and len(diffs) % 2 == 0:
            mid = len(diffs)//2
            if diffs[:mid] == diffs[mid:]:
                pattern = diffs[:mid]
                print(i)
                final_ind = i
                break

        prev_highest = highest_point
        positions = set(p for p in positions if p[1] > highest_point-100)
    
    pattern_length = len(pattern)
    highest_point_to_add = 0
    if pattern_length > 0:
        remaining_major = major - final_ind
        print("remaining", remaining_major, )
        print(remaining_major // pattern_length, remaining_major%pattern_length)
        highest_point_to_add = (remaining_major // pattern_length)*sum(pattern)
        for i in range(remaining_major%pattern_length -1):
            highest_point = run_pattern(len(d), yw, shapes, d_gen, positions, highest_point)

    print(highest_point, extra)
    highest_point = run_pattern(extra, yw, shapes, d_gen, positions, highest_point)
    return highest_point + highest_point_to_add

def main_a(data):
    return run(2022, data)

def main_b(data):
    return run(1000000000000, data)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))