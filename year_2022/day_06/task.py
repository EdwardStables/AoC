#!/usr/bin/env python3
from collections import defaultdict

def get_data(fname = "data.txt"):
    with open(f"year_2022/day_06/{fname}") as f:
        return [l.strip() for l in f][0]

def run(data, size):
    latest = size-1
    while True:
        window = data[latest-size+1:latest+1]
        bf = False
        for i, d1 in enumerate(window):
            for j, d2 in enumerate(window):
                if i == j:
                    continue
                if d1 == d2:
                    latest += min(i, j) + 1
                    bf = True
                    break
            if bf:
                break
        if bf:
            continue 
        return latest+1


def main_a(data):
    return run(data, 4)

def run_dict_window(data, size):
    window = defaultdict(int)
    for d in data[:size]:
        window[d] += 1

    for i, d in enumerate(data[size:]):
        window[data[i]] -= 1
        window[d] += 1
        if all(v in (1,0) for v in window.values()):
            return i+size+1

def main_b(data):
    return run_dict_window(data, 14)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))