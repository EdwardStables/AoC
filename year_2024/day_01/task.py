#!/usr/bin/env python3

from collections import defaultdict

def get_data(fname = "data.txt"):
    with open(f"year_2024/day_01/{fname}") as f:
        return [l.strip() for l in f]

def main_a(data):
    l1 = []
    l2 = []
    for line in data:
        d1, d2 = line.split("   ")
        l1.append(int(d1))
        l2.append(int(d2))
    
    l1.sort()
    l2.sort()

    total = 0
    for a, b in zip(l1, l2):
        total += abs(a-b)

    return total

def main_b(data):
    l1 = []
    l2 = defaultdict(int)
    for line in data:
        d1, d2 = line.split("   ")
        l1.append(int(d1))
        l2[int(d2)] += 1

    total = 0
    for a in l1:
        total += a * l2[a]

    return total

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))