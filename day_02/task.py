#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"day_02/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    depth = 0
    horizontal = 0
    for d in data:
        v = int(d.split()[-1])
        if d[0] == "f":
            horizontal += v
        elif d[0] == "u":
            depth -= v
        elif d[0] == "d":
            depth += v
    
    return depth * horizontal

def main_b(data):
    depth = 0
    horizontal = 0
    aim = 0
    for d in data:
        v = int(d.split()[-1])
        if d[0] == "f":
            horizontal += v 
            depth += v * aim
        elif d[0] == "u":
            aim -= v
        elif d[0] == "d":
            aim += v

    return depth*horizontal

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))