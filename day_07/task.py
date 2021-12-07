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

def mean(arr):
    mean = sum(arr) / len(arr)
    if (imean := int(mean)) == mean:
        return [imean]
    else:
        return [imean, imean + 1]

def median(arr):
    start = 0
    end = len(arr)
    med = (start + end) / 2
    if (imed := int(med)) != med:
        return [arr[imed], arr[imed+1]]
    else:
        return [int(arr[imed])]

def main(data, avg_func, fuel_func):
    h = [int(d) for d in data[0].split(",")]
    h.sort()
    pos = avg_func(h)
    if len(pos) == 1:
        return fuel_func(h, pos[0])
    else:
        return min(fuel_func(h, pos[0]),fuel_func(h, pos[1]))

def main_a(data):
    return main(data, median, get_fuel)

def main_b(data):
    return main(data, mean, get_fuel_exp)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))