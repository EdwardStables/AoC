#!/usr/bin/env python3
from time import time
from collections import Counter, defaultdict

def get_data(fname = "data.txt"):
    with open(f"year_2021/day_14/{fname}") as f:
        return [l.strip() for l in f]

def parse(data):
    start = data[0]
    pairs = [l.split(" -> ") for l in data[2:]]
    pairs = {v[0]:(v[0][0]+v[1], v[1]+v[0][1]) for v in pairs}
    return start, pairs

def get_pairs(inp):
    pairs = []
    for i,_ in enumerate(inp[:-1]):
        pairs.append(inp[i:i+2])
    return pairs

def main(data, step_limit):
    start, pair_list = parse(data)
    table = defaultdict(int)

    for p in get_pairs(start):
        table[p] += 1

    for _ in range(step_limit):
        next_table = defaultdict(int)
        for k, v in table.items():
            next_table[pair_list[k][0]] += v
            next_table[pair_list[k][1]] += v
        table = next_table
    
    prots = defaultdict(int)
    for k, v in table.items():
        prots[k[0]] += v
        prots[k[1]] += v

    prots[start[0]] += 1
    prots[start[-1]] += 1

    prot_count = sorted(prots.values())
    return (prot_count[-1] - prot_count[0])//2

def main_a(data):
    return main(data, 10)

def main_b(data):
    return main(data, 40)

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))