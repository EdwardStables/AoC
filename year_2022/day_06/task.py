#!/usr/bin/env python3
from collections import defaultdict

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_06/{fname}") as f:
        return [l.strip() for l in f][0]

def run(data, size):
    window = defaultdict(int)
    for d in data[:size]:
        window[d] += 1

    for i, d in enumerate(data[size:]):
        window[data[i]] -= 1
        window[d] += 1
        if all(v in (1,0) for v in window.values()):
            return i+size+1

def main_a(data):
    return run(data, 4)

def main_b(data):
    return run(data, 14)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))