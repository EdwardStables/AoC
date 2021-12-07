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

def main(data,fuel_func):
    h = [int(d) for d in data[0].split(",")]
    start = min(h)
    stop = max(h)
    min_fuel = fuel_func(h, start)
    for f in range(start+1, stop+1):
        if (new_min := fuel_func(h, f)) < min_fuel:
            min_fuel = new_min 

    return min_fuel

def main_a(data):
    return main(data, get_fuel)

def main_b(data):
    return main(data, get_fuel_exp)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))