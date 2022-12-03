#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_03/{fname}") as f:
        return [l.strip() for l in f]

def priority(c):
    o = ord(c)
    if o < 97:
        return o - 38
    else:
        return o - 96
    

def main_a(data):
    total = 0
    for r in data:
        size = len(r)
        h1 = set(r[:size//2])
        h2 = set(r[size//2:])
        common = h1.intersection(h2)
        for c in common:
            total += priority(c)
    return total

def main_b(data):
    bs = []
    total = 0
    for r in data:
        bs.append(set(r))
        if len(bs) == 3:
            total += priority(bs[0].intersection(bs[1]).intersection(bs[2]).pop())
            bs = []

    return total

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))