#!/usr/bin/env python3
from math import sqrt, floor, ceil

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_06/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    times = map(int, data[0].split(":")[1].split())
    targets = map(int, data[1].split(":")[1].split())
    ans = 1
    for time, target in zip(times, targets):
        upper = ceil(0.5 * (time+sqrt(time**2 - 4*target))-1)
        lower = floor(0.5 * (time-sqrt(time**2 - 4*target))+1)
        ans *= upper - lower + 1

    return ans

def main_b(data):
    time = int(data[0].split(":")[1].replace(" ", ""))
    target = int(data[1].split(":")[1].replace(" ", ""))
    upper = ceil(0.5 * (time+sqrt(time**2 - 4*target))-1)
    lower = floor(0.5 * (time-sqrt(time**2 - 4*target))+1)
    return upper - lower + 1

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))