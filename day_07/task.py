#!/usr/bin/env python3
from math import floor, ceil
def get_data(fname = "data.txt"):
    with open(f"day_07/{fname}") as f:
        return [l.strip() for l in f]

def get_fuel(data, pos):
    return sum(abs(pos-d) for d in data)

def get_fuel_exp(data, pos):
    s = 0
    for d in data:
        s += tri(pos-d)
    return s

def tri(n):
    n = abs(n)
    return n*(n+1)//2

def median(arr):
    start = 0
    end = len(arr)
    med = (start + end) / 2
    if (imed := int(med)) != med:
        return [arr[imed], arr[imed+1]]
    else:
        return [int(arr[imed])]

def main_a(data):
    h = [int(d) for d in data[0].split(",")]
    h.sort()
    pos = median(h)
    if len(pos) == 1:
        return get_fuel(h, pos[0])
    else:
        return min(get_fuel(h, pos[0]),get_fuel(h, pos[1]))

def main_b(data):
    h = [int(d) for d in data[0].split(",")]
    start = min(h)
    stop = max(h)
    min_fuel = get_fuel_exp(h, start)
    for f in range(start+1, stop+1):
        if (new_min := get_fuel_exp(h, f)) < min_fuel:
            min_fuel = new_min 
        else:
            return min_fuel

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))