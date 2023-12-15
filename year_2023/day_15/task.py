#!/usr/bin/env python3
from collections import OrderedDict

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_15/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    s = 0
    for p in data[0].split(","):
        d = 0
        for c in p:
            d += ord(c)
            d *= 17
            d %= 256
        s += d
    return s

def main_b(data):
    boxes = [OrderedDict() for _ in range(256)]
    for p in data[0].split(","):
        if "-" in p:
            l = p.split("-")[0]
            f = None
        elif "=" in p:
            l,f = p.split("=")
        
        hash = 0
        for c in l:
            hash += ord(c)
            hash *= 17
            hash %= 256

        if f is None:
            if l in boxes[hash]:
                boxes[hash].pop(l)
        else:
            boxes[hash][l] = int(f)

    fp = 0
    for i, b in enumerate(boxes):
        s = (i+1)
        for j,v in enumerate(b.values()):
            fp += s * (j+1) * v

    return fp

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))